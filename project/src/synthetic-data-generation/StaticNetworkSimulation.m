% Micol Marchetti-Bowick
% CMU School of Computer Science

% Adapted from Ankur Parikh

% Main function that controls simulation of static network

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [network,sampleData] = StaticNetworkSimulation()

NUM_VERTICES = 10;
NUM_EDGES = 5;
NUM_SAMPLES = 100;

global MAX_DEGREE
global THETA_MIN
global THETA_MAX

MAX_DEGREE = 6;
THETA_MIN = 0.5;
THETA_MAX = 1;

% generate a random graph with given number of nodes and edges
network = GenerateGraph(NUM_VERTICES,NUM_EDGES);

% diagonalize the matrix to be positive definite
epsilon = .001;
network = network + diag(sum(abs(network),2) + epsilon);

% standardize the matrix to have variance of 1
d = sqrt(diag(diag(inv(network))));
network = d * network * d;

% generate data sampled from GGM
sampleData = GenerateData(network,NUM_SAMPLES); 

end




