namespace TravellingSalesman {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    /// # Summary
    /// Solves the TSP in a classical "naive" way
    /// # Input
    /// ## permutationArray Array of all permutations
    /// ## costMatrix Matrix of costs    
    /// # Output    
    /// Path, cost result
    function SimpleClassicalTSPSolver (permutationArray: Int[][], costMatrix: (Int[])[]) : (Int[], Int)[] {                
        mutable result = [];

        for permutation in permutationArray {
            let costs = CalculateCosts(permutation, costMatrix);
            if(costs > 0){
                if(Length(result) > 0){                    
                    let (resPerm, resCosts) = result[0];
                    //if the costs are the same add this route to the result
                    if(costs ==  resCosts){
                        set result = result + [(permutation, costs)];
                    }
                    //if the costs are lower remove all routes from the array and only add the latest route
                    if(costs < resCosts){
                        set result = [(permutation, costs)];
                    }                    
                }
                else{
                    //if no route was added before: add one regardless of its costs to the array
                    set result = [(permutation, costs)];
                }                
            }            
        }
        return result;
    }
    /// # Summary
    /// Calculates the costs for a permutation
    /// # Input
    /// ## route Route, that would be taken
    /// ## costMatrix Matrix of costs
    /// # Output
    /// costs of the route
    function CalculateCosts(route: Int[], costMatrix: Int[][]): Int {
        mutable costs = 0;
        mutable tempCosts = 0;
        let startVertex = route[0];
        for i in 0 .. Length(route) - 1 {
           let vertex = route[i]; 
           if(Length(route) == i + 1){
               set tempCosts = RouteCosts(vertex, startVertex, costMatrix);                          		   
           }
           else{
               let nextVertex = route[i + 1];
               set tempCosts = RouteCosts(vertex, nextVertex, costMatrix);
	        }
            if(tempCosts > 0 ){ 
                set costs += tempCosts;
		    }
            else{
                //Impossible route
                return -1;
            }
		}
        return costs;
    }

    /// # Summary
    /// Helper to calculate the routes costs
    /// # Input
    /// ## vertex1 First connected vertex
    /// ## vertex2 Second connected vertex    
    /// ## costMatrix Matrix of costs
    /// # Output
    /// costs of the route
    function RouteCosts(vertex1: Int, vertex2: Int, costMatrix: Int[][]) : Int{        
               let routeCosts = costMatrix[vertex1][vertex2];
               if(routeCosts > 0){
                   //Calculate route costs
                   return routeCosts;
            }
            else{
                //Impossible route
                return -1;                  
           }
    }
}
