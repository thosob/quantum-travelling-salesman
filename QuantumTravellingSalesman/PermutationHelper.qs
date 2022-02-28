namespace TravellingSalesman {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    /// # Summary
    /// Creates a permutation of a vertices in a graph with k vertices
    /// # Input
    /// ## k count of vertices in graph
    /// # Output
    /// Path, Costs    
    function PermutationHelper(k: Int) : (Int[])[] {
        let initialSequence = SequenceI(0, k);
        mutable result = [];
        mutable tempSequence = initialSequence; 

        for i in 0 .. k {
            let tmpSequence = Swap(tempSequence, k);            
            set result = result + Swap(tempSequence, k);
            set tempSequence = Tail(result);
        }

        return result;
    }

    /// # Summary
    /// Helper to simplify array concatination
    /// # Input
    /// ## a1 Array 1
    /// ## a2 Array 2
    /// # Output
    /// Output Array    
    function ConcatArray(a1: (Int[])[], a2: Int[]) : (Int[])[] {
        return a1 + [a2];
    }
    /// # Summary
    /// Swapping of elements in an array
    /// # Input
    /// ## input Array
    /// ## k count of vertices in graph
    /// # Output
    /// Swap result
    function Swap(input: Int[], k: Int) : (Int[])[]{
        mutable resultArray = [];
        mutable tempArray = input;
        for i in 0 .. k - 1{
            set tempArray = Swapped(i, i + 1, tempArray); 
            if tempArray[k] == 0 {
                set resultArray = ConcatArray(resultArray, tempArray);        
		    }
        }
        return resultArray;
    } 
}
