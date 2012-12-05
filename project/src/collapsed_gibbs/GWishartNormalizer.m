
% Monte Carlo algorithm to calculate normalization constant for G-Wishart
% density

function [pG,lpG] = GWishartNormalizer(A,b,D)

% Set constants
NUM_SAMPLES = 20;

% Get size
[p p] = size(A);

% Get Cholesky decomposition of inverse of D
T = chol(inv(D));

% Create upper triangular matrix H, where h_ij = t_ij/t_jj and h_ii = 1
H = T./repmat(diag(T)',p,1);
%H(logical(diag(ones(p,1)))) = 1;

% Get number of 1's in rows of A and in columns of A
Nu = sum(A,2);
Kappa = sum(A,1)';

% Initialize
Psi = cell(NUM_SAMPLES,1);
J_samples = zeros(NUM_SAMPLES,1);

% Repeat for several samples
for n = 1:NUM_SAMPLES
    %display(num2str(n));
    % Sample the free variables psi_ij for all i <= j
    Psi{n} = zeros(p);
    for i = 1:p
        for j = i:p
            if (i==j) Psi{n}(i,j) = sqrt(chi2rnd(b+Nu(i))); 
            elseif (A(i,j)==1) Psi{n}(i,j) = randn; 
            elseif (A(i,j)==0)
                Psi{n}(i,j) = -sum(Psi{n}(i,i:j-1).*H(i:j-1,j)');
                if (i > 1)
                    for r = 1:i-1
                        %temp = - (sum(Psi{n}(r,r:i).*H(r:i,i)')*sum(Psi{n}(r,r:j).*H(r:j,j)'))/(Psi{n}(i,i));
                        Psi{n}(i,j) = Psi{n}(i,j) - (sum(Psi{n}(r,r:i).*H(r:i,i)')*sum(Psi{n}(r,r:j).*H(r:j,j)'))/(Psi{n}(i,i));
                        %if (r >= 90) keyboard; end
                    end
                end
            end
            %if (Psi{n}(i,j) == -Inf) keyboard; end
            %if (Psi{n}(i,j) > 10^200) keyboard; end
            %if (abs(Psi{n}(i,j)) > 1000000) keyboard; end
        end
    end
    J_samples(n) = (-0.5)*sum(sum(Psi{n}(triu(~A,1)).^2));
end

J_full_1 = max(J_samples) + log(sum(exp(J_samples-repmat(max(J_samples),NUM_SAMPLES,1)))) - log(length(J_samples));
J_full_2 = log(sum(exp(J_samples))) - log(length(J_samples));

aa = (Nu./2).*log(2*pi);
bb = (b/2 + Nu./2).*log(2);
cc = gammaln(b/2 + Nu./2);
dd = (b + Nu + Kappa).*log(diag(T));
C = sum(aa + bb + cc + dd);

pG = exp(C + J_full_1);
lpG = C + J_full_1;

end