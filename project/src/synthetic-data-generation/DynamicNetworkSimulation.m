% Micol Marchetti-Bowick
% CMU School of Computer Science

% Adapted from Ankur Parikh

% Main function that controls simulation of dynamic network

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [network,sampleData] = DynamicNetworkSimulation()

NUM_VERTICES = 100;
INITIAL_NUM_EDGES = 200;
NUM_SAMPLES = 10;
NUM_TIME_STEPS = 10;
MIN_EDGE_CHANGE = 5;
MAX_EDGE_CHANGE = 20;

global MAX_DEGREE
global THETA_MIN
global THETA_MAX

MAX_DEGREE = 6;
THETA_MIN = 0.5;
THETA_MAX = 1;

network = cell(NUM_TIME_STEPS,1);
sampleData = cell(NUM_TIME_STEPS,1);

% generate an initial random graph with given number of nodes and edges
network{1} = GenerateGraph(NUM_VERTICES,INITIAL_NUM_EDGES);

% generate a graph for each remaining time step
for t = 2:NUM_TIME_STEPS
    network{t} = GenerateEvolvedGraph(network{t-1},MIN_EDGE_CHANGE,MAX_EDGE_CHANGE);
end

% make sure each graph encodes a valid precision matrix
for t = 1:NUM_TIME_STEPS
    
    % diagonalize the matrix to be positive definite
    network{t} = network{t} + diag(sum(abs(network{t}),2) + .001);

    % standardize the matrix to have variance of 1
    d = sqrt(diag(diag(inv(network{t}))));
    network{t} = d * network{t} * d;
end

% generate data sampled from each GGM 
for t = 1:NUM_TIME_STEPS
    sampleData{t} = GenerateData(network{t},NUM_SAMPLES); 
end

end




