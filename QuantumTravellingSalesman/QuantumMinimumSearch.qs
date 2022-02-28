namespace TravellingSalesman {

    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.AmplitudeAmplification;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    /// # Summary
    /// Checks if an element is greater than another element, if so flips the result Qubit
    /// # Input
    /// ## currentElement Element, that is tested
    /// ## currentMinimum Current minimum
    /// ## result Result of the test    
    operation ElementIsLessThan(currentElement : Qubit[], currentMinimum : Qubit[], result : Qubit) : Unit is Adj+Ctl {                
        GreaterThan(LittleEndian(currentElement), LittleEndian(currentMinimum), result);                 
        // //Change the amplitude
        X(result);
    }

    /// # Summary
    /// Find the minimum of the array
    /// # Input
    /// ## register 
    /// ## targetRegister       
    operation FindMinimum(        
        register : Qubit[],        
        targetRegister: Qubit[]
    ) : Unit is Adj+Ctl {                
        let chunks = Chunks(3, register);
        let targetRegisterIt = Length(targetRegister) - 1;
        borrow min = Qubit[3];
        for j in 1 .. 7 {            
            for i in 0 .. targetRegisterIt { 
                ConvertIntToQubitUnit(j, min);
                if i < Length(chunks){
                    ElementIsLessThan(chunks[i], min, targetRegister[i]);            
			    }
            }
        }        
    }
    /// # Summary
    /// Find the minimum of the array
    /// # Input
    /// ## markingOracle 
    /// ## register
    /// ## target 
    operation ApplyMarkingOracleAsPhaseOracle(
        markingOracle : ((Qubit[], Qubit[]) => Unit is Adj), 
        register : Qubit[],
        target: Qubit[]
    ) : Unit is Adj {        
        within {
            ApplyToEachA(X,target);
            ApplyToEachA(H,target);
        } apply {
            markingOracle(register, target);
        }
    }
    
    /// # Summary
    /// Calculates the number of Grover iterations needed
    /// # Input
    /// ## qubits Amount of qubits that are used    
    operation CalculateIterations(qubits : Int) : Int {
        let items = 1 <<< qubits;
        let angle = ArcSin(1. / Sqrt(IntAsDouble(items)));
        let iterationCount = Round(0.25 * PI() / angle - 0.5);
        return iterationCount;
    }

    /// # Summary
    /// Converts a Qubit bitwise to an Int with max. 3 qubits max. 7 in dec 
    /// # Input
    /// ## number number of qubits
    /// ## output result
    /// # Output
    /// Qubit array of result
    operation ConvertIntToQubit(number: Int, output: Qubit[]) : Qubit[]{        
            let bits = IntAsBoolArray(number, Length(output));            
            ApplyPauliFromBitString(PauliX, true, bits, output);             
            return output;	    
    }
    /// # Summary
    /// Converts a Qubit bitwise to an Int with max. 3 qubits max. 7 in dec 
    /// # Input
    /// ## number number of qubits
    /// ## output result  
    operation ConvertIntToQubitUnit(number: Int, output: Qubit[]) : Unit is Adj + Ctl{        
            let bits = IntAsBoolArray(number, Length(output));            
            ApplyPauliFromBitString(PauliX, true, bits, output);                            
    }
    /// # Summary
    /// Converts a Qubit to an Int: Attention destroy super position
    /// # Input
    /// ## array number of qubits
    /// # Output
    /// Integer
    operation ConvertQubitToInt(array: Qubit[]):Int{
        let result = MeasureInteger(LittleEndian(array));
        return result;
    }
    /// # Summary
    /// Converts a Qubit to an Int: Attention destroy super position
    /// # Input
    /// ## costArray costs
    /// ## wayArray ways
    /// # Output
    /// Integer
    /// Path, cost result
    operation MinimumSearch(costArray: Int[], wayArray: Int[][]) : (Int[], Int)[] {
        use numberRegister = Qubit[Length(costArray) * 3];        
        mutable count = 0;
        use targetRegister = Qubit[3];
        let numberRegisterChunks = Chunks(3, numberRegister);

        //Load numbers into number register
        for cost in costArray{            
            ConvertIntToQubitUnit(cost, numberRegisterChunks[count]);
            set count += 1;
	    }

        //calculates the iterations needed
        let iterations = CalculateIterations(Length(targetRegister));        
        ApplyToEach(H, targetRegister);
        let markingOracle = FindMinimum(_, _);
        let phaseOracle = ApplyMarkingOracleAsPhaseOracle(_,_,_);
        
        // Iterations of Grover's search
        for i in 1 .. iterations {                        
            phaseOracle(markingOracle, numberRegister, targetRegister);            
            within {
                ApplyToEachA(H, targetRegister);
                ApplyToEachA(X, targetRegister);
            } apply {
                Controlled Z(Most(targetRegister), Tail(targetRegister));
            }
        }
        //Measure
        let measuredTargets = MultiM(targetRegister);
        mutable targetCount = 0;
        mutable result = [([-1], -1)];
        for target in measuredTargets {
            if target == One {
                //number register can be smaller
                if targetCount < Length(numberRegisterChunks) - 1{
                    set result = result + [(wayArray[targetCount], ResultArrayAsInt(MultiM(numberRegisterChunks[targetCount])))];
			    }
            }
            set targetCount += 1;
        }        
        ResetAll(numberRegister);
        return Rest(result);
    }
}