function samples = bdmcmc_static(data_t,P,b,D,printout)

% BDMCMC for samples from posterior over graphs and precision
% matrices in a Bayesian Gaussian graphical model
%
% Inputs:
% (1) data_t is an nxd matrix of observations from a single time step
% (2) P is the number of particles (number of samples to generate) 
% (3) b is the G-Wishart degrees of freedom parameter 
% (4) D is the G-Wishart matrix parameter

if nargin<5
    printout==true;
end

burn=2000;
iter = P+burn;
n = size(data_t,1);
p = size(data_t,2); 
A = ones(p); A = triu(A,1);  % init A as an upper triangular matrix with all 1s
meanzero=false; % used in getS function
skip=1; % used in main loop
birth_rate=1;
priorG='Uniform'; % can be 'Uniform' or 'Poisson'

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
    if printout, fprintf('iter=%d\n',g); end
    rates = zeros(length(K));
    for i=1:(p-1)
        for j=(i+1):p
            if A(i,j)==0, rates(i,j)=birth_rate; end   % set birth rates for non-edges
            if A(i,j)==1   % set death rates for edges
                Aminus=A;
                Aminus(i,j)=0;
                Kminus = SamplePrecisionMatrix_quick(Aminus,bstar,Ts,Hs);
                if (sum(A(:))==0 & pr==0), pr=1; end
                rates(i,j)=((sum(A(:))^pr)*(birth_rate^(1-pr)))*exp((n/2)*(log(abs(det(Kminus)))-log(abs(det(K))))+sum(sum(diag(S*(K-Kminus))))/2);
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
    meltMat=melt(rates,p);
    rows=find(mnrnd(1,meltMat(:,3)/sum(meltMat(:,3))));
    ii=meltMat(rows,1);
    jj=meltMat(rows,2);
    A(ii,jj)=A(ii,jj)+(-1)^(A(ii,jj)); % make graph move
    K=SamplePrecisionMatrix_quick(A,bstar,Ts,Hs);
end

samples = {Ks,As,allA,lambda};
% maybe: resample As and Ks based on time (lambdas) in each to get "correct unweighted samples"
    % currently i do this in smcSimple after getting results from this function

% utility function
function result=melt(rates,p)
    v3=tril(rates',-1); v3=v3(:); v3(v3==0)=[];
    v1=[]; v2=[];
    for i=1:p-1
        v1=[v1,i*ones(1,p-i)];
        v2=[v2,(i+1):p];
    end
    result = [v1',v2',v3];
