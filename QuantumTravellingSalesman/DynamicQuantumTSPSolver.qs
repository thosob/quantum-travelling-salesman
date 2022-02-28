namespace TravellingSalesman
{    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.AmplitudeAmplification;
    open Microsoft.Quantum.Canon;
    
    /// # Summary
    /// Dynamic programming TSP approach  
    /// # Input
    /// ## costMatrix Matrix with costs
    /// # Output
    /// Path, Costs
    /// Graph with costs
    operation DynamicQuantumTSPSolver (costMatrix: (Int[][])) : (Int[], Int)[] {
        let result = QuantumDynamicProgrammingTSP(costMatrix);       
        return result;
    }
    /// # Summary
    /// Dynamic programming TSP approach  
    /// # Input
    /// ## graph Matrix with costs
    /// # Output
    /// Path, Costs
    /// Graph with costs
    operation QuantumDynamicProgrammingTSP(graph: (Int[])[]) : (Int[], Int)[] {                
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
        let (way, cost) = Unzipped(distanceMatrix);        
        let minimumResult = MinimumSearch(cost, way); 
       
        return minimumResult;
    }
}
