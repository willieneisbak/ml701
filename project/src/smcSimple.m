function finalSamples = smcSimple(data)

% Sampling with the simple version of smc.
%
% Description of function 
%
% Inputs:
% (1) data is a 1xT cell-array; each element is an nxd matrix of observations from a single point in time 
% (2) Input two
% (3) Input three


% ----------------------------------------------
% 1) do static inference on t=1 
% 2) for each t=2:T
%   a) for each particle k=1:K
%       i) sample a graph given previous
%       ii) compute weight for sample
%   b) resample from (pair down) set of particles
%
% for simple version:
%   sample new state: P(G|G_-1), P(K|G)
%   compute weight: P(X|K)
% ---------------------------------------------

d = size(data{1},2);

P = 1000; %%%% Number of particles. Put here or have as param to this function?
b = 3; % set prior param b
D = eye(d); %%% prior param D

%ACell = {}; KCell = {};
%[ACell{1},KCell{1}] = bdmcmc_static(data{1},P,b,D); %%%% NEED TO MAKE. returns cell of graph samples and cell of associated precision-matrix samples
result = bdmcmc_static(data{1},P,b,D); %%%% NEED TO MAKE. returns cell of graph samples and cell of associated precision-matrix samples
ACell{1} = result{2}; KCell{1} = result{1};
for t=2:length(data)
    newAs = {}; newKs = {};
    for p=1:P
        newAs{p} = SampleForwardGraph(ACell{t-1}{p}); % sample p_th graph given p_th graph at previous time
        newKs{p} = SamplePrecisionMatrix(newAs{p},b,D); % sample p_th precision matrix given p_th graph
    end
    weights = getWeights_smcSimple(newKs,data{t}); % compute weights
    resampleInd = resampleParticles(weights); % resample particles
    ACell{t} = newAs(resampleInd); KCell{t} = newKs(resampleInd);
end
finalSamples = {ACell,KCell};
