namespace TravellingSalesman {
          
   /// # Summary
    /// Uses Grover's algorithm to minimize the solutionvector to the TSP
    /// # Input
    /// ## permutationArray Array of all permutations    
    /// ## costMatrix Matrix of costs
    /// # Output
    /// path, cost result
    operation SimpleQuantumTSPSolver (permutationArray: Int[][], costMatrix: (Int[])[]) : (Int[], Int)[]  {
        //Database to search in        
        mutable costArray = [];        
        mutable permutationCostArray = [];

        for permutation in permutationArray {
            let costs = CalculateCosts(permutation, costMatrix);            
            if(costs > 0 and Length(costArray) < 3){            
                set costArray = costArray + [costs];
                set permutationCostArray = permutationCostArray + [permutation];
            }            
        }
        return MinimumSearch(costArray, permutationCostArray);
    }
    

    
}
