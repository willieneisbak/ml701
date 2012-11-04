function K = SamplePrecisionMatrix_quick(A,b,T,H)

% SAMPLEPRECISIONMATRIX(A,b,D) Sample precision matrix K ~ G-Wishart_A(b,D)
% with some precomputed params given as inputs for speed
%
% Inputs:
% (1) A is the adjacency matrix of the graph in the G-Wishart 
% (2) b is the number of degrees of freedom of the G-Wishart 
% (3) T is the cholesky decomposition of inv(D) (where D is the matrix param of the G-Wishart)
% (4) H is the
% (5) p is the number of nodes

% Validate inputs
assert(size(A,1)==size(A,2),'Error: A must be a square matrix');
assert(length(b)==1,'Error: b must be a scalar');

% Get dimension
p = length(A);

% Make sure A is an upper triangular matrix, with diagonal elements 0
A = triu(A,1);

% Get number of 1's in rows of A
Nu = sum(A,2);

% Sample the free variables psi_ij for all i <= j
Psi = randn(p);
Psi(~A) = 0;
Psi(logical(diag(ones(p,1)))) = sqrt(chi2rnd(b+Nu));
%Psi = zeros(p);  % BDgraph way
for i = 1:p
    for j = i:p
        %if (i==j) Psi(i,j) = sqrt(chi2rnd(b+Nu(i))); end  % BDgraph way
        %if (A(i,j)==1) Psi(i,j) = randn; end  % BDgraph way
        if (A(i,j)==0 & i~=j)
            Psi(i,j) = -sum(Psi(i,i:j-1)*H(i:j-1,j));
            if (i > 1)
                for r = 1:i-1
                    Psi(i,j) = Psi(i,j) - (sum(Psi(r,r:i)*H(r:i,i))*sum(Psi(r,r:j)*H(r:j,j)))/(Psi(i,i));
                end
            end
        end
    end
end

% Calculate Phi, the Cholesky decomposition of K
Phi = Psi*T;

% Calculate precision matrix K
K = Phi'*Phi;

end
