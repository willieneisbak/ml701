% Micol Marchetti-Bowick
% CMU School of Computer Science

% This function runs collapsed Gibbs sampling on a dynamic GGM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A,errors] = RunGibbsSampling(trueA,X,currA,b,D,P,q)

NUM_ITER = 10;

[T ~] = size(X);
p = size(X{1},2);

if ~exist('b','var') b = 3; end
if ~exist('D','var') D = eye(p); end
if ~exist('P','var') 
    P = cell(2,1);
    P{1} = repmat(0.1,p,p);
    P{2} = repmat(0.1,p,p);
end
if ~exist('q','var')
    q = 0.05;
end

% get sample covariance matrices
S = cell(T,1);
for t = 1:T
    S{t} = X{t}'*X{t};
end

% initialize
if exist('currA','var')
    A = currA;
else
    A = cell(T,1);
    for t = 1:T
        A{t} = InitializeGraph(X{t},1);
    end
end

errors = zeros(NUM_ITER,T);

for iter = 1:NUM_ITER
    for t = 1:T
        tic;
        n = size(X{t},1);
        display(['Iteration ' num2str(iter) ', Time ' num2str(t)]);
        % Sample from P(A_{ij}^t|*) for each edge {ij}
        for i = 1:p
            for j = i+1:p
                
                % Calculate P(A_{ij}^t=1|*)
                A{t}(i,j) = 1;
                [PAcurr,PAnext] = EdgeTransition1(A,P,q,t,i,j,T);
                [IGposterior,lIGposterior] = GWishartNormalizer(A{t},b+n,D+S{t});
                [IGprior,lIGprior] = GWishartNormalizer(A{t},b,D);
                PXt = ((2*pi)^(-n*p/2))*(IGposterior/IGprior);
                lPXt = (-n*p/2)*log(2*pi) + lIGposterior - lIGprior;
                prob1 = PAcurr*PAnext*PXt;
                lprob1 = log(PAcurr) + log(PAnext) + lPXt;
                
                % Calculate P(A_{ij}^t=0|*)
                A{t}(i,j) = 0;
                [PAcurr,PAnext] = EdgeTransition0(A,P,q,t,i,j,T);   
                [IGposterior,lIGposterior] = GWishartNormalizer(A{t},b+n,D+S{t});
                [IGprior,lIGprior] = GWishartNormalizer(A{t},b,D);
                PXt = ((2*pi)^(-n*p/2))*(IGposterior/IGprior);
                lPXt = (-n*p/2)*log(2*pi) + lIGposterior - lIGprior;
                prob0 = PAcurr*PAnext*PXt;
                lprob0 = log(PAcurr) + log(PAnext) + lPXt;
                
                % Sample A_{ij}^t
                Z = prob0 + prob1;
                lZ = max(lprob0,lprob1) + log(exp(lprob0-max(lprob0,lprob1)) + exp(lprob1-max(lprob0,lprob1)));
                prob = prob1/Z;
                lprob = lprob1 - lZ;
                if (rand <= exp(lprob))
                    A{t}(i,j) = 1;
                else
                    A{t}(i,j) = 0;
                end
                
            end
        end
        toc;
    end
    
    % evaluate error
    for t = 1:T
        errors(iter,t) = sum(sum(abs(A{t}-trueA{t})));
    end
    display(['Avg error = ' num2str(mean(errors(iter,:)))]);
    
end

end

