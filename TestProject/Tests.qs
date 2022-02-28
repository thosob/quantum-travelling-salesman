namespace Quantum.TestProject {
    
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open TravellingSalesman;

    operation GetSmallExample() : Int[][]{
        let costMatrix = [[0, 1, 1, 0],
                         [0, 0, 2, 1],
                         [1, 2, 0, 1],
                         [1, 1, 1, 0]];
        return costMatrix;
    }

    operation GetBigExample() : Int[][]{
        let costMatrix = [
                            [0, 1, 1, 0, 4, 1, 1],
                            [0, 0, 2, 1, 0, 1, 2],
                            [1, 2, 0, 1, 3, 5, 2],
                            [1, 1, 1, 0, 0, 0, 1],
                            [0, 1, 1, 0, 4, 1, 1],
                            [1, 2, 0, 1, 3, 5, 2],
                            [1, 2, 0, 1, 3, 5, 2]
                         ];
        return costMatrix;
    }

    @Test("ResourcesEstimator")
    operation BigGraphTest() : Unit {
        let result = DynamicQuantumTSPSolver(GetBigExample());
        EqualityFactB(true, true, "Estimator call only.");
    }    

    @Test("QuantumSimulator")
    operation SimpleClassicalTSPSolverTest() : Unit{
        let numberCities = Length(GetSmallExample()) - 1;
        let allPermutations = PermutationHelper(numberCities);
        let result = SimpleClassicalTSPSolver(allPermutations, GetSmallExample());
        let (path, costs) = result[0];
        EqualityFactI(costs, 4,"Test passed.");        
    }

    @Test("QuantumSimulator")
    operation DynamicClassicalTSPSolverTest() : Unit {
        let result = DynamicClassicalTSPSolver(GetSmallExample());
        let (path, costs) = result[0];
        EqualityFactI(costs, 4,"Test passed.");
    }
    
    @Test("QuantumSimulator")
    operation SimpleQuantumTSPSolverTest() : Unit {
        let numberCities = Length(GetSmallExample()) - 1;
        let allPermutations = PermutationHelper(numberCities);
        let result = SimpleQuantumTSPSolver(allPermutations, GetSmallExample());
        let (path, costs) = result[0];
        EqualityFactI(costs, 4,"Test passed.");
    }

    @Test("QuantumSimulator")
    operation DynamicQuantumTSPSolverTest() : Unit {
        let result = DynamicQuantumTSPSolver(GetSmallExample());
        let (path, costs) = result[0];
        EqualityFactI(costs, 4,"Test passed.");
    }
}
