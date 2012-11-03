% sequential monte carlo inference for the time-varying Bayesian Gaussian graphical model.


% note: there is a simple version and complex version
%
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
%
% for complex version:
%   sample new state: P(G|G_-1,X), P(K|G)
%   compute weight: P(X|K)*P(G|G_-1) / P(G|G_-1,X)  or  P(X|K)*P(G|G_-1) / P(G|G_-1,X)*P(K|G)
