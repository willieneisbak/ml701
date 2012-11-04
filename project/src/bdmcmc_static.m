function samples = bdmcmc_static(data_t,P,b,D)

% BDMCMC for samples from posterior over graphs and precision
% matrices in a Bayesian Gaussian graphical model
%
% Inputs:
% (1) data_t is an nxd matrix of observations from a single time step
% (2) P is the number of particles (number of samples to generate) 
% (3) b is the G-Wishart degrees of freedom parameter 
% (4) D is the G-Wishart matrix parameter

iter = 2000; burn = iter/2;
n = size(data_t,1);
p = size(data_t,2); 
A = ones(length(S)); A = triu(A,1);  % init A as an upper triangular matrix with all 1s
meanzero=false; % used in getS function
skip=1; % used in main loop
birth_rate=1;
priorG='Uniform'; % can be 'Uniform' or 'Poisson'
b=3;
D=eye(p);

if strcmpi(priorG,'Uniform'),id=1;pr=0;end
if strcmpi(priorG,'Poisson'),id=2;pr=1;end
%S = getS(data_t,n,meanzero); %%%% COMPLETE THIS MATLAB FUNCTION   %Should return S=covariance matrix??
S = cov(data_t);  % could create my own function here like in BDgraph
bstar = b+n; % posterior update for b param of G-Wishart
Ds = D+S; % posterior update for D param of G-Wishart
Ts = chol(inv(Ds));
Hs = Ts./repmat(diag(Ts)',p,1); Hs(logical(diag(ones(p,1)))) = 1;
K = SamplePrecisionMatrix_quick(A,bstar,Ts,Hs);

Ks={};As={};allA={};
lambda=[];
count=0;allAcount=0;
alla=ceil(iter/2000); % alla needs to be saved for plotConvergency function

for g=1:iter
    % if print==T, cat(paste('time =', format(Sys.time(), '%X')), paste(c('Sum.links = ',sum(A)),collapse=''), fill = TRUE, labels = paste('{',paste(c('iter=',g),collapse=''),'}:',sep='')); end
    rates = zeros(length(K));
    for i=1:(p-1)
        for j=(i+1):p
            if A(i,j)==0, rates(i,j)=birth_rate; end   % set birth rates for non-edges
            if A(i,j)==1   % set death rates for edges
                Aminus=A;
                Aminus(i,j)=0;
                Kminus = SamplePrecisionMatrix_quick(Aminus,bstar,Ts,Hs);
                if (sum(A(:))==0 & pr==0), pr=1; end
                rates(i,j)=((sum(A(:))^pr)*(birth_rate^(1-pr)))*exp((n/2)*(log(abs(det(Kminus)))-log(abs(det(K))))+sum(sum(eye(S*(K-Kminus))))/2);
                if rates(i,j)==Inf, rates(i,j)=gamma(170); end
            end
        end
    end
    if mod(9,alla)==0
        allAcount=allAcount+1;
        allA{allAcount}=A;
    end 
    if (g>burn && mod(g,skip)==0)
        count=count+1;
        Ks{count}=K;
        As{count}=A;
        lambda(count)=sum(rates(:));
    end 
    melt=melt(rates,p)  %%%% COMPLETE THIS MATLAB FUNCTION
    rows=which(rmultinom(1,1,melt[,3])==1) %%%% FIX LINE
    ii=melt[rows,1] %%%% FIX LINE
    jj=melt[rows,2] %%%% FIX LINE
    A[ii,jj]=A[ii,jj]+(-1)^(A[ii,jj]) %%%% FIX LINE
    K=SamplePrecisionMatrix(A,bstar,Hs,Ts,p) %%%% USE SMALLL VERSION HERE
end

samples = {Ks,As,allA,lambda};
% maybe: resample As and Ks based on time (lambdas) in each to get "correct unweighted samples"


% auxiliary function to get covariance matrix
%%%% STILL NEED TO CONVERT TO MATLAB
get.S=function(data,n,tol=1e-5,meanzero)
{
  if (ncol(data)!=nrow(data)){    % if data not square matrix
     n = nrow(data)
	 if (meanzero==TRUE) S = t(data)%*%data
     if (meanzero==FALSE) S = n*cov(data)
  } else {
     if (sum(abs(data-t(data)))>tol){
        n = nrow(data)
	    if (meanzero==TRUE) S = t(data)%*%data
        if (meanzero==FALSE) S = n*cov(data)
    }
  }
  return(list(S=S,n=n))
}


% By using this function we do not need "reshape" package (in R)
melt=function(rates,p)
{
   trates=t(rates)
   v3=trates[lower.tri(trates)]
   v1=v2=c()
   for (i in 1:(p-1)){
       v1=c(v1,rep(i,p-i))
       v2=c(v2,(i+1):p)
   }
   cbind(v1,v2,v3)
}
