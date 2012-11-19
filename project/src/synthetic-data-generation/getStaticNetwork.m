function [network,sampledData] = getStaticNetwork(NUM_VERTICES,NUM_EDGES,NUM_SAMPLES,MAX_DEGREE,THETA_MIN,THETA_MAX)

if nargin<1, NUM_VERTICES = 10; end
if nargin<2, NUM_EDGES = 5; end
if nargin<3, NUM_SAMPLES = 100; end

global MAX_DEGREE; global THETA_MIN, global THETA_MAX
if nargin<4, MAX_DEGREE = 6; end
if nargin<5, THETA_MIN = 0.5; end
if nargin<6, THETA_MAX = 1; END

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
