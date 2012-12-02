function graphCell = smc(data,numParticles,alpha)

% Sequential Monte Carlo (SMC) inference for the time-varying Bayesian Gaussian graphical model.
%
% Inputs:
% (1) data is a 1xT cell-array; each element is an nxd matrix of observations from a single point in time 
% (2) numParticles is the number of SMC particles
% (3) alpha is the transition parameter (prob of edge flipping)
%
% --------------------------------------------------------------
% Procedure:
% 1) do static inference on t=1 
% 2) for each t=2:T
%   a) for each particle k=1:K
%       i) sample a graph given previous fraph and current data
%       ii) compute weight for sample
%   b) resample from (pair down) set of particles
%
% Note: there is a simple version and complex version of smc
%   For simple version:
%       sample new state: P(G|G_-1), P(K|G)
%       compute weight: P(X|K)
%   For complex version:
%       sample new state: P(G|G_-1,X), P(K|G)
%       compute weight: P(X|K)*P(G|G_-1) / P(G|G_-1,X)
%           or  P(X|K)*P(G|G_-1) / P(G|G_-1,X)*P(K|G)
% --------------------------------------------------------------

d = size(data{1},2); % number of nodes / length of adjacency and precision matirices
P = numParticles; % number of particles
b = 3; % G-Wishart prior param b
D = eye(d); % G-Wishart prior param D

graphCell = {}; % holds inferred graph at each time
result = bdmcmc_new(data{1},P,b,D);
%result = bdmcmc_new(data{1},P,b,D); 
[meanGraphMat,meanWeightedGraph] = meanGraph(result{2},result{4});
graphCell{1} = meanWeightedGraph;
fprintf('finished time-step t=1\n');
for t=2:length(data)
    result = bdmcmc_prevGraphPrior(data{t},P,b,D,graphCell{t-1},alpha); %modified bdmcmc (with graphCell{t-1} as prior)
    [meanGraphMat,meanWeightedGraph] = meanGraph(result{2},result{4});
    while sum(sum(logical(triu(meanGraphMat,1))))==sum(sum(triu(ones(length(meanGraphMat)),1)))
        fprintf('time-step: %d. ERROR: meanGraphMat all 1s!\n', t);
        result = bdmcmc_prevGraphPrior(data{t},P,b,D,graphCell{t-1},alpha); %modified bdmcmc (with graphCell{t-1} as prior)
        [meanGraphMat,meanWeightedGraph] = meanGraph(result{2},result{4});
    end
    graphCell{t} = meanWeightedGraph;
    fprintf('finished time-step t=%d\n',t);
end
