% UNTITLED Summary of this function goes here
%   Detailed explanation goes here

function [pK_G] = GWishartDensity(K,A,b,D)

%%%%%%%%%%%%%%% SET CONSTANTS %%%%%%%%%%%%%%%

NUM_SAMPLES = 100;

%%%%%%%%%%%%%%% VALIDATE INPUTS %%%%%%%%%%%%%%%

% Make sure K, A, and D are square matrices with same dimension
assert(size(K,1)==size(K,2),'Error: K must be a square matrix'):
assert(size(A,1)==size(A,2),'Error: A must be a square matrix');
assert(size(D,1)==size(D,2),'Error: D must be a square matrix');
assert(size(K,1)==size(K,1),'Error: K and A must be the same size');
assert(size(A,1)==size(D,1),'Error: A and D must be the same size');

% Make sure b is a scalar
assert(length(b)==1,'Error: b must be a scalar');

% Make sure K is an upper triangular matrix
K = triu(K);

% Make sure A is an upper triangular matrix, with diagonal elements 0
A = triu(A,1);

%%%%%%%%%%%%%%% CALCULATE DENSITY %%%%%%%%%%%%%%%

% Get dimension
p = length(K);

% Verify that K is in M+(A), the cone of positive definite matrices with
% entries corresponding to missing edges equal to zero
if ~(K(triu(~A,1))==0)
    pK_G = 0;
    return;
end

% Calculate P(K,G)
pKG = (det(K).^(b/2-1))*exp(-0.5*trace(D*K));

% Calculate P(G)
pG = GWishartNormalizer(A,b,D);

% Calculate P(K|G)
pK_G = pKG/pG;

end

