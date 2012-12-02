function resultcell = test_smc_networkDrift()

% testing SMC inference on a 2 time-step drifting-network example


addpath('synthetic-data-generation');
NUM_VERTICES = 12; NUM_EDGES = 20; NUM_SAMPLES = 100;
global MAX_DEGREE; global THETA_MIN; global THETA_MAX
MAX_DEGREE = 6; THETA_MIN = 0.5; THETA_MAX = 0.5;
epsilon = .001;

network1 = GenerateGraph(NUM_VERTICES,NUM_EDGES);
network2 = network1;
n2ones = find(triu(network2,1));
tmp = not(network2);
n2zeros = find(triu(tmp,1));
numEdgesToSwap = 4;
setToZero = n2ones(randperm(length(n2ones),4));
setToOne = n2zeros(randperm(length(n2zeros),4));
network2(setToZero)=0; network2=network2'; network2(setToZero)=0; network2=network2';
network2(setToOne)=0.5; network2=network2'; network2(setToOne)=0.5; network2=network2';

% diagonalize the matrices to be positive definite
network1 = network1 + diag(sum(abs(network1),2) + epsilon);
network2 = network2 + diag(sum(abs(network2),2) + epsilon);

% make sure network1 and network2 are valid precision matrices
chol(network1);
chol(network2);

disp('Here are precision matrices of networks:');
disp('Network 1:')
disp(network1);
disp('Network 2:')
disp(network2);

% standardize matrices to have variance of 1
d = sqrt(diag(diag(inv(network1))));
network1 = d * network1 * d;
d = sqrt(diag(diag(inv(network2))));
network2 = d * network2 * d;

networkcell{1} = network1;
networkcell{2} = network2;

% generate data sampled from GGM
data{1} = GenerateData(networkcell{1},NUM_SAMPLES); 
data{2} = GenerateData(networkcell{2},NUM_SAMPLES); 
data{3} = data{2};
data{4} = data{1};

% do inference
tic; graphcell = smc(data); toc

disp('graphcell{1}');
disp(graphcell{1})
disp('graphcell{2}');
disp(graphcell{2})


resultcell = {graphcell, networkcell};
