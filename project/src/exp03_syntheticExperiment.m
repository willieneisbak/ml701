function resultcell = exp03_syntheticExperiment()

% testing SMC inference on synthetic data

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
numEdgesToSwap = length(find(network1))/4;
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

% standardize matrices to have variance of 1
d = sqrt(diag(diag(inv(network1))));
network1 = d * network1 * d;
d = sqrt(diag(diag(inv(network2))));
network2 = d * network2 * d;

networkcell{1} = network1;
networkcell{2} = network2;
netCell = {networkcell{1},networkcell{1},networkcell{1},networkcell{2},networkcell{2},networkcell{2}};

% generate data sampled from GGM
data{1} = GenerateData(networkcell{1},NUM_SAMPLES); 
data{2} = GenerateData(networkcell{1},NUM_SAMPLES); 
data{3} = GenerateData(networkcell{1},NUM_SAMPLES); 
data{4} = GenerateData(networkcell{2},NUM_SAMPLES); 
data{5} = GenerateData(networkcell{2},NUM_SAMPLES); 
data{6} = GenerateData(networkcell{2},NUM_SAMPLES); 

% do inference (for 3 cases: time-varying, static-expanded, and static-collapsed)
numPtsToAve = 5;

%for i=1:numPtsToAve
    %disp('STARTING TIME VARYING CASE')
    %alpha = 0.47; savestring = 'exp03_synth_pt47alpha_trials'; % time-varying
    %graphs_tv{i} = getGraphcell_perTrial(data,alpha);
    %save(savestring);
%end
%errVec_tv = resultsPerCase(graphs_tv,netCell)

%for i=1:numPtsToAve
    %disp('STARTING STATIC EXPANDED CASE')
    %alpha = 0.5; savestring = 'exp03_synth_pt5alpha_trials'; % static-expanded
    %graphs_se{i} = getGraphcell_perTrial(data,alpha);
    %save(savestring);
%end
%errVec_se = resultsPerCase(graphs_se,netCell)

for t=2:6, data{1}=[data{1};data{t}]; end
data(2:6) = [];
for i=1:numPtsToAve
    disp('STARTING STATIC COLLAPSED CASE')
    alpha = 0.5;
    savestring = 'exp03_synth_pt5alphaCollapsed_trials'; % static-collapsed
    graphs_sc{i} = getGraphcell_perTrial(data,alpha);
    save(savestring);
end
for i=1:length(graphs_sc)
    for j=1:length(graphs_sc{i})
        graphs_sc{i}{j} = {graphs_sc{i}{j}{1},graphs_sc{i}{j}{1},graphs_sc{i}{j}{1},graphs_sc{i}{j}{1},graphs_sc{i}{j}{1},graphs_sc{i}{j}{1}};
    end
end
errVec_sc = resultsPerCase(graphs_sc,netCell)

resultcell = {graphs_tv, graphs_se, graphs_sc, networkcell, errVec_tv, errVec_se, errVec_sc};


function graphs = getGraphcell_perTrial(dat,alph)
    trials = [50,500:500:3000];
    for P=1:length(trials)
        tic; graphcell = smc(dat,trials(P),alph); toc
        graphs{P} = graphcell;
        fprintf('FINISHED TRIAL %d.\n',P);
    end
end

function err = resultsPerCase(graphy,netcell)
    for j=1:length(graphy{1}) % loop through multi-results, which is same length for all graphy{i}
        err(j) = 0;
        for i=1:length(graphy)
            err(j) = err(j) + (getSmcError(graphy{i}{j},netcell) / length(graphy));
        end
    end
end


end
