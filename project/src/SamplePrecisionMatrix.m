function [] = SamplePrecisionMatrix(A,b,D)

% SAMPLEPRECISIONMATRIX(A,b,D) Sample precision matrix K ~ G-Wishart_A(b,D)
%
% Sample a precision matrix K which is distributed according to a
% G-Wishart distribution with graph structure A, degrees of freedom b,
% and scale matrix D
%
% Inputs:
% (1) A is the adjacency matrix of the graph in the G-Wishart prior
% (2) b is the number of degrees of freedom of the G-Wishart prior
% (3) D is the scale matrix of the G-Wishart prior

% Validate inputs
assert(size(A,1)==size(A,2),'Error: A must be a square matrix');
assert(size(D,1)==size(D,2),'Error: D must be a square matrix');
assert(size(A,1)==size(D,1),'Error: A and D must be the same size');
assert(length(b)==1),'Error: b must be a scalar');

% Get dimension
p = length(A);

% Make sure A is an upper triangular matrix, with diagonal elements 0
A = triu(A,1);

% Get Cholesky decomposition of D
T = chol(inv(D));

% Create upper triangular matrix H, where h_ij = t_ij/t_jj and h_ii = 1
H = T./repmat(diag(T)',p,1);
H(diag(ones(p,1))) = 1;

% Get number of 1's in rows of A
Nu = sum(A,2);

% Sample the free variables psi_ij for all i <= j
Psi = randn(p);
Psi(~A) = 0;
Psi(diag(ones(p,1))) = sqrt(chi2rnd(b+Nu));
Psi = zeros(p);
for i = 1:p
    for j = 1:p
        %if (i==j) Psi(i,j) = sqrt(chi2rnd(b+Nu(i))); end
        %if (A(i,j)==1) Psi(i,j) = randn; end
        if (A(i,j)==0 & i~=j)
            Psi(i,j) = -sum(Psi(i,i:j-1)*H(i:j-1,j));
            if (i > 1)
                for r = 1:i-1
                    Psi(i,j) = Psi(i,j) - (sum(Psi(r,r:i)*H(r:i,i))*sum(Psi(r,r:j)*H(r:j,j)))/(Psi(i,i))
                end
            end
        end
    end
end

% Calculate Phi, the Cholesky decomposition of K
Phi = Psi*T;

% Calculate precision matrix K
K = Psi'*Psi;

end

