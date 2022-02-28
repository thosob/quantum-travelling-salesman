namespace TravellingSalesman {
    
    open Microsoft.Quantum.Intrinsic;
    
    /// # Summary
    /// Starts classical TSP and Quantum Search with Grover's algorithm to find all solutions
    /// of a given graph for the TSP. Here is also the test graph hardcoded.    
    @EntryPoint()
    operation Main() : Unit {        
        let costMatrix = [[0, 0, 0, 1],
                         [1, 0, 1, 1],
                         [1, 1, 0, 2],
                         [0, 1, 2, 0]];
        let cityMapping = [(0, "Vertex 1"), 
                          (1, "Vertex 2"), 
                          (2, "Vertex 3"), 
                          (3, "Vertex 4")];                
        TravellingSalesman(costMatrix, cityMapping);        
    }
    
    /// # Summary
    /// Shows the results in a table
    /// # Input
    /// ## cityMapping Name, vertex count structure
    /// ## tspResult The path, cost result from the TSP algorithm
    /// ## startVertex vertex starting
    /// # Output
    /// Integer
    /// Path, cost result
    operation DisplayRoute(cityMapping: (Int, String)[], tspResult: (Int[], Int)[], startVertex: Int) : Unit{        
        
        mutable cityString = ""; 
        for (idxs, costs) in tspResult {
            let (node, firstCity) = cityMapping[startVertex];
            set cityString = $"{firstCity} ";
            for idx in idxs {
                for (cityIdx, city) in cityMapping {
                    if idx == cityIdx {
                        if cityString == "" {
                            set cityString = city;
                        }
                        else {
                            set cityString = $"{cityString} -> {city}";
						}
				    }
	            }
		    }
            Message($"{cityString}");
            Message($"Costs: {costs}");
            set cityString = "";
	    }
    }
           
    /// # Summary
    /// Classical and quantum solutions of the TSP using Grover's search to find a minimum in the solution space
    /// Solves the TSP in 4 different ways 
    /// SimpleClassicTSPSolver: Solves the TSP on a naive, classical way
    /// SimpleQuantumTSPSolver: Uses the all permutations and minimizes the costs with Grover's Search
    /// DynamicClassicalTSPSolver: Solves the TSP with dynamic programming
    /// DynamicQuantumTSPSolver: Solves the TSP with dynamic programming and calls Grover's Search to minimize the result
    /// # Input
    /// ## cityMapping Name, vertex count structure
    /// ## costMatrix Matrix of costs  
    operation TravellingSalesman (costMatrix: Int[][], cityMapping: (Int, String)[]) : Unit{        
        let numberCities = Length(costMatrix) - 1;
        let startVertex = 0;
        let allPermutations = PermutationHelper(numberCities);
        let classicResult = SimpleClassicalTSPSolver(allPermutations, costMatrix);        
        Message("Classical Result using Permutation: ");        
        DisplayRoute(cityMapping, classicResult, startVertex);       
        Message("-----------------------------");
        Message("Classical Result using Dynamic Programming: ");
        let dynamicClassicalResult = DynamicClassicalTSPSolver(costMatrix);
        DisplayRoute(cityMapping, dynamicClassicalResult, startVertex);                    
        Message("-----------------------------");
        Message("Classical Permutation with Quantum Minimization Result: ");
        let simpleQuantumResult = SimpleQuantumTSPSolver(allPermutations, costMatrix);       
        DisplayRoute(cityMapping, simpleQuantumResult, startVertex);
        Message("-----------------------------");
        Message("Dynamic Programming with Quantum Minimization Result: ");
        let dynamicQuantumResult = DynamicQuantumTSPSolver(costMatrix);       
        DisplayRoute(cityMapping, dynamicQuantumResult, startVertex);       	
    }
}
