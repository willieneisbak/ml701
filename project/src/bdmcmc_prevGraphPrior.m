function samples = bdmcmc_prevGraphPrior(data_t,P,b,D,prevGraph,alpha)

% BDMCMC for samples from posterior over graphs and precision
% matrices in a Bayesian Gaussian graphical model
%
% Inputs:
% (1) data_t is an nxd matrix of observations from a single time step
% (2) P is the number of particles (number of samples to generate) 
% (3) b is the G-Wishart degrees of freedom parameter 
% (4) D is the G-Wishart matrix parameter

printout=false; % print at each iteration

burn=P;
iter = P+burn;
n = size(data_t,1);
p = size(data_t,2); 
A = ones(p); A = triu(A,1);  % init A as an upper triangular matrix with all 1s
meanzero=false; % used in getS function
skip=1; % used in main loop
birth_rate=1;
priorG='Uniform'; % can be 'Uniform' or 'Poisson'
% alpha is now an input param: alpha = 0.49; % fixed "edge flip" prob (for previous graph prior)

if strcmpi(priorG,'Uniform'),id=1;pr=0;end
if strcmpi(priorG,'Poisson'),id=2;pr=1;end
%S = getS(data_t,n,meanzero); 
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

fprintf('Running BDMCMC for %d iterations...\n',iter);
for g=1:iter
    % if print==T, cat(paste('time =', format(Sys.time(), '%X')), paste(c('Sum.links = ',sum(A)),collapse=''), fill = TRUE, labels = paste('{',paste(c('iter=',g),collapse=''),'}:',sep='')); end
    if printout, fprintf('iter=%d\n',g); end
    rates = zeros(length(K));
    %%%%
    Knew = SamplePrecisionMatrix_quick(A,bstar,Ts,Hs);
    %%%%
    for i=1:(p-1)
        for j=(i+1):p
            if A(i,j)==0, rates(i,j)=birth_rate; end   % set birth rates for non-edges
            if A(i,j)==1   % set death rates for edges
                Aminus=A;
                Aminus(i,j)=0;
                %Kminus = SamplePrecisionMatrix_quick(Aminus,bstar,Ts,Hs);
                %%%%
                Kminus=Knew;
                Kminus(i,j) = 0;
                Kminus(j,i) = 0;
                %%%%
                if (sum(A(:))==0 & pr==0), pr=1; end
                %rates(i,j)=((sum(A(:))^pr)*(birth_rate^(1-pr)))*exp((n/2)*(log(abs(det(Kminus)))-log(abs(det(K))))+sum(sum(diag(S*(K-Kminus))))/2);
                %rates(i,j)=exp( (n/2)*(log(abs(det(Kminus)))-log(abs(det(K))))+(sum(sum(diag(S*(K-Kminus))))/2) );
                if prevGraph(i,j)==1, priorVal = alpha/(1-alpha); else priorVal = (1-alpha)/alpha; end
                rates(i,j)=exp( (n/2)*(log(abs(det(Kminus)))-log(abs(det(K))))+(trace(S*(K-Kminus))/2) ) * priorVal;
                if rates(i,j)==Inf, rates(i,j)=gamma(170); end
            end
        end
        %disp(['made it here: 02. i=',num2str(i)]) %%%%
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
    rtmp = rates'; rflat = rtmp(:);
    samp = catrnd(rflat);
    ii = ceil(samp/p);
    jj = mod(samp,p); if jj==0, jj=p; end;
    A(ii,jj)=A(ii,jj)+(-1)^(A(ii,jj)); % make graph move
    K=SamplePrecisionMatrix_quick(A,bstar,Ts,Hs);
end

samples = {Ks,As,allA,lambda};
% maybe: resample As and Ks based on time (lambdas) in each to get "correct unweighted samples"
    % currently i do this in smcSimple after getting results from this function
