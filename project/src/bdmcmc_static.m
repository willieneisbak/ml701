function [Asamples, Ksamples] = bdmcmc_static(data_t,P,b,D)

% BDMCMC for samples from posterior over graphs and precision
% matrices in a Bayesian Gaussian graphical model
%
% Inputs:
% (1) data_t is an nxd matrix of observations from a single time step
% (2) P is the number of particles (number of samples to generate) 
% (3) b is the G-Wishart degrees of freedom parameter 
% (4) D is the G-Wishart matrix parameter

iter = 2000;
burn = iter/2; % must be less than iter
n = size(data_t,1); % number of observations
p = size(data_t,2); % should be = num cols in covariance matrix?
A = ones(length(S)); A = triu(A,1);  % instantiate A as an upper triangular matrix with all 1s
meanzero=false;
skip=1;
gamma_b=1; % must be greater or equal to 0
priorG='Uniform';
b=3;
D=eye(p);
print=False;

if strcmpi(priorG,'Uniform'),id=1;pr=0;end
if strcmpi(priorG,'Poisson'),id=2;pr=1;end
Sn = getS(data_t,n,meanzero); %%%% COMPLETE THIS MATLAB FUNCTION   %note:meanzero=false
% S = %%%% covariance matrix? Should be returned in Sn?
bstar = b+n; % posterior update for b param of G-Wishart
Ds = D+S; % posterior update for D param of G-Wishart
%Ts = chol(inv(Ds)); % assuming solve() gives inverse and chol() is same as in MATLAB
%H = eye(p);
%Hs = Hmatrix(Ts,p); %%%% COMPLETE THIS MATLAB FUNCTION
K = SamplePrecisionMatrix(A,bstar,Ds);
Ks={};As={};allA={};% Ks=As=allA=list()   %%%% set Ks,As,allA equal to cell-array?
lambda=[];% lambda = vector()   %%%% set lambda equal to an array? %% this is waiting time for each state
cont=0;allAcont=0;alla=ceil(iter/2000); % needs to be saved for plotConvergency function

for g=1:iter
    % if print==T, cat(paste('time =', format(Sys.time(), '%X')), paste(c('Sum.links = ',sum(A)),collapse=''), fill = TRUE, labels = paste('{',paste(c('iter=',g),collapse=''),'}:',sep='')); end
    rates = zeros(length(K)); %rates=0*K
    for i=1:(p-1)
        for j=(i+1):p
            if A(i,j)==0, rates(i,j)=gamma_b; end
            if A(i,j)==1
                Aminus=A;
                Aminus(i,j)=0
                Kminus = SamplePrecisionMatrix(Aminus,bstar,Hs,Ts,p); %%%% USE SMALL VERSION HERE
                if (sum(A)==0 & pr==0), pr=1; end %%%% CHECK LINE
                rates(i,j)=(((sum(A))^pr)*((gamma.b)^(1-pr)))*exp((n/2)*(log(abs(det(Kminus)))-log(abs(det(K))))+(sum(diag(S%*%(K-Kminus))))/2 ) %%%% FIX LINE
                if (is.infinite(rates[i,j])==TRUE), rates[i,j]=gamma(170); end %%%% FIX LINE
            end
        end
    end
    if (g%%alla==0) %%%% FIX LINE
        allAcont=allAcont+1;
        allA[[allAcont]]=A; %%%% FIX LINE
    end 
    if (g > burn && g%%skip==0) %%%% FIX LINE
        cont=cont+1;
        Ks[[cont]]=K; %%%% FIX LINE
        As[[cont]]=A; %%%% FIX LINE
        lambda(cont)=sum(rates) %%%% CHECK LINE
    end 
    melt=melt(rates,p)  %%%% COMPLETE THIS MATLAB FUNCTION
    rows=which(rmultinom(1,1,melt[,3])==1) %%%% FIX LINE
    ii=melt[rows,1] %%%% FIX LINE
    jj=melt[rows,2] %%%% FIX LINE
    A[ii,jj]=A[ii,jj]+(-1)^(A[ii,jj]) %%%% FIX LINE
    K=SamplePrecisionMatrix(A,bstar,Hs,Ts,p) %%%% USE SMALLL VERSION HERE
end
% make a cell structure and return at top %%%% return(list(Ks=Ks,As=As,lambda=lambda,allA=allA,alla=alla))


% auxiliary function to get covariance matrix
%%%% STILL NEED TO CONVERT TO MATLAB
get.S=function(data,n,tol=1e-5,meanzero)
{
  if (ncol(data)!=nrow(data)){
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
