function [Asamples, Ksamples] = bdmcmc_static(data_t,P,b,D)

% BDMCMC for samples from posterior over graphs and precision
% matrices in a Bayesian Gaussian graphical model
%
% Inputs:
% (1) data_t is an nxd matrix of observations from a single time step
% (2) P is the number of particles (number of samples to generate) 
% (3) b is the G-Wishart degrees of freedom parameter 
% (4) D is the G-Wishart matrix parameter

burnin = 2000;
iter = 2000;
