# Solving the Travelling-salesman problem with Grover's algorithm
Q# implementation of a travelling salesman algorithm 

This implementation is based on the idea of Andris Ambainis paper Quantum Speedups for Exponential-Time Dynamic Programming Algorithms,
which proposes combining dynamic programming and Grover's search to speed up the TSP using dynamic programming. The implementation 
contains:

1. An implementation of a simple approach to solve the TSP by using all permutations from a given start vertex. 
2. An approach using dynamic programming to solve the TSP

Grover's algorithm is used to find the minimum value in the resulting search arrays. 

Note: Currently, there is a 50:50 chance Grover's search does find a solution to the search problem, which is the lowest possible success probability. There is open potential to optimize the implementation of Grover's algorithm further. 


# Travelling-Salesman-Problem Overview
The travelling salesman-problem - short TSP - is a graph based optimization problem. 
It describes a salesman, who travels from a starting point to a discrete amount of locations. 
The salesman can visit every location only once except of the start point of his voyage, which is also the end point of his journey. 
The solution to the problem is the route or respectively the set of routes, which is least expensive. 
The travelling salesman-problem can be applied to various real-world problems e.g. vehicle routing, computer wiring, machine sequencing, 
communication networks etc. 

Although a lot of different techniques f.e. branch and bound, nearest-neighbour or insertion heuristics, simulated annealing, genetic algorithms 
and many more  have been used to solve the TSP, the TSP is not solvable in polynomial time on classical hardware.
Actually, the TSP is NP-complete, which means that it lies in NP and is even NP-hard. 

It would be great to have a quantum algorithm, that would solve a NP-hard problem, because all NP-hard problems can be transformed into each other with 
minimal overhead, thus a quantum algorithm solving the TSP in polynomial time could be used to solve all NP-hard problems in polynomial time on a quantum 
computer. Unfortunately, such an algorithm has not been discovered, yet. 



