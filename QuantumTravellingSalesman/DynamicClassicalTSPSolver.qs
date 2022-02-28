namespace TravellingSalesman
{        
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Arrays;

    /// # Summary
    /// Solves the classical tsp    
    /// # Input
    /// ## costMatrix Matrix with costs
    /// # Output
    /// Path, Costs
    /// Graph with costs
    function DynamicClassicalTSPSolver (costMatrix: (Int[][])) : (Int[], Int)[] {                
        let result = TSP(costMatrix);       
        return result;
    }    

    /// # Summary
    /// Solves the classical tsp    
    /// # Input
    /// ## graph Matrix with costs
    /// # Output
    /// Path, Costs
    /// Graph with costs
    function TSP(graph: (Int[])[]) : (Int[], Int)[] {                
        let vertexCount = Length(graph);             
        mutable distanceMatrix = [];
        mutable vertex = 0;
        let startVertex = 0;

        let startingArray = graph[0];
        for subtreeVertexCosts in startingArray {
            if(subtreeVertexCosts > 0){
                set distanceMatrix = distanceMatrix + Recursion([vertex], graph[startVertex][vertex], startVertex, graph, []);		        
            }
            set vertex = vertex + 1;
        }
        let minimumResult = FindMinimumClassic(distanceMatrix); 
       
        return minimumResult;
    }
    /// # Summary
    /// Recursion function of the dynamic programming approach    
    /// # Input
    /// ## visitedVertices Array with visited vertices
    /// ## costs Sum of costs
    /// ## graph Graph or matrix of costs
    /// ## resultArray path, costs result
    /// # Output
    /// Path, Costs
    /// Graph with costs
    function Recursion(visitedVertices: Int[], costs: Int, startVertex: Int, graph: Int[][], resultArray: (Int[], Int)[]) : (Int[], Int)[]{            
        mutable result = [];
        if Length(visitedVertices) == Length(graph) {                        
            return [(visitedVertices, costs)];
        }
        else { 
            let lastVisitedVertex = Tail(visitedVertices);
            let discoveredVertices = graph[lastVisitedVertex];
            mutable elem = 0;
            
            if Length(visitedVertices) < Length(graph) - 1 {                        
                for elemCosts in discoveredVertices {
                    if not Any(EqualI(_,elem), visitedVertices) and elemCosts > 0 {                                        
                        set result = result + Recursion(visitedVertices + [elem], costs + elemCosts, startVertex, graph, result);				    
			        }
                    set elem = elem + 1;
                }
		    }
            else{  
                let elemCosts = discoveredVertices[startVertex];
                if(elemCosts > 0) {
                    set result = result + Recursion(visitedVertices + [startVertex], costs + elemCosts, startVertex, graph, result);				    
                }
                else{ 
                    set result = [];
                }
            }
            return result;
        }
    }


    /// # Summary
    /// Finds the minimum by iterating "classically" through the solution
    /// # Input
    /// ## distanceMatrix Matrix of costs
    /// # Output
    /// Minimum paths and costs (can be more than one)
    function FindMinimumClassic(distanceMatrix : (Int[], Int)[]) : (Int[], Int)[]{
        mutable minimum = -1;
        mutable posArray = [];
        mutable count = 0;

        for (way, cost) in distanceMatrix{
            if(minimum < 0 ){ 
                set minimum = cost;
                set posArray = [(way, cost)];
            }
            if minimum >= cost {
                if minimum > cost {
                    set minimum = cost;
                    set posArray = [(way, cost)];
			    }
                else {
                    set posArray = posArray + [(way, cost)];
                }
			}
            set count = count + 1;
        }
        return posArray;        
    }
}