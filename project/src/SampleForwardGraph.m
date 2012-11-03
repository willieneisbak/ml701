function A = SampleForwardGraph(A,b,D)

% SampleForwardGraph(A,b,D) Sample precision matrix K ~ G-Wishart_A(b,D)
%
% Sample a precision matrix K which is distributed according to a
% G-Wishart distribution with graph structure A, degrees of freedom b,
% and scale matrix D
%
% Inputs:
% (1) A is the adjacency matrix of the graph in the G-Wishart prior
% (2) b is the number of degrees of freedom of the G-Wishart prior
% (3) D is the scale matrix of the G-Wishart prior



% Default params:
% for two beta distributions, want default params:

alpha1 = 9;
beta1 = 1;

alpha0 = 1;
beta0 = 9;


% compute probability that next edge is one and next edge is zero (should only need one matrix with one param specifying prob that next edge is 1)
% then sample from cat(that param) ie, take a uniform random and see if less than that value

