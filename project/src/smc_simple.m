function samples = smc_simple(data)

% smc_simple(A,b,D) Sampling with simple smc.
%
% Description of function 
%
% Inputs:
% (1) Input one
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

T = getT(data); %%%% get num time steps T given data with consistent structure
K = bdmcmc_static(); %%%% make function 
A = makeGraphFromK(K); %%%% make function
