
todo:
# need to parse data into consistent format
# have parseStockData.m, parseGeneNetwork.m, parseBioData.m, etc,
    # all which parse data into consistent format





## Algorithm 2.1: BD-MCMC algorithm for high-dimentional problem (roughly graphs with more than 8 nodes)
bdmcmc.high=function(data,n=NULL,meanzero=FALSE,iter=5000,burn=floor(iter/2),
skip=1,gamma.b=1,prior.g="Uniform",b=3,D=NULL,A=NULL,print=FALSE,sumery=FALSE) ### params
{
  if (iter<=burn){
    stop("Number of iterations have to be more than the number of burn-in iterations")
  }
  if (gamma.b<=0){
    stop("birth rate 'gamma.b' has to be positive value")
  }
  id <- pmatch(prior.g,c("Uniform","Poisson"))[1]
  if(!is.na(id)){
     if(id == 1) pr=0
     if(id == 2) pr=1
    }
  Sn = get.S(data,n,meanzero=meanzero)
  if (is.null(Sn$n) & is.null(n)){
    stop("If you provide the covariance matrix, you have to specify the number of observations")
  }
  S = Sn$S
  n = Sn$n
  p = ncol(S) 
  if (is.null(A)) {
     A = 0 * S
     A[upper.tri(A)] = 1
     } 
  if (is.null(D)) D = diag(p)
  bstar=b+n
  Ds=D+S
  Ts=chol(solve(Ds))
  H=diag(p)
  Hs=Hmatrix(Ts,p)
  K=sampleK(A,bstar,Hs,Ts,p)
  Ks=As=allA=list()
  lambda=vector() # waiting time for every state
  cont=allAcont=0
  alla=ceiling(iter/2000)# for saving allA which we need it for plotConvergency function
  for (g in 1:iter){
    if (print==T){
	  cat(paste("time =", format(Sys.time(), "%X")),
      paste(c("Sum.links = ",sum(A)),collapse=""), fill = TRUE,
      labels = paste("{",paste(c("iter=",g),collapse=""),"}:",sep=""))
	}
    rates=0*K ### Get rates
    for (i in 1:(p-1)){
       for (j in (i+1):p){
          if (A[i,j]==0) rates[i,j]=gamma.b
          if (A[i,j]==1){
             Aminus=A
             Aminus[i,j]=0
             Kminus=sampleK(Aminus,bstar,Hs,Ts,p)
             if (sum(A)==0 & pr==0) pr=1
             rates[i,j]=(((sum(A))^pr)*((gamma.b)^(1-pr)))*exp((n/2)*(log(abs(det(Kminus)))-
             log(abs(det(K))))+(sum(diag(S%*%(K-Kminus))))/2 )
             if (is.infinite(rates[i,j])==TRUE) rates[i,j]=gamma(170)
          }
       }
    }
	if (g%%alla==0){
        allAcont=allAcont+1
        allA[[allAcont]]=A
    }
    if (g > burn && g%%skip==0){
        cont=cont+1
        Ks[[cont]]=K
        As[[cont]]=A
        lambda[cont]=sum(rates)
    }
    melt=melt(rates,p)
    rows=which(rmultinom(1,1,melt[,3])==1)
    ii=melt[rows,1]
    jj=melt[rows,2]
    A[ii,jj]=A[ii,jj]+(-1)^(A[ii,jj]) 
    K=sampleK(A,bstar,Hs,Ts,p)
  }
  if (sumery==FALSE){
     return(list(Ks=Ks,As=As,lambda=lambda,allA=allA,alla=alla))
  } else {
        output=list(Ks=Ks,As=As,lambda=lambda,allA=allA,alla=alla)
		# best graph and estimaition of its parameters
		bestg=select.g (output, K=TRUE, g=1)
		print(round(bestg,2))
        # for phat
		phat=0*As[[1]]
        for (i in 1:(p-1)){
            for (j in (i+1):p){
                for (k in 1:length(As)){
                    phat[i,j]=phat[i,j]+As[[k]][i,j]/lambda[k]
                }
                phat[i,j]=phat[i,j]/(sum(1/lambda))
            }
        }
		cat(paste(""), fill = TRUE)
		cat(paste(""), fill = TRUE)
		cat(paste("Posterior edge inclusion probabilities for all possible edges equal with"), fill = TRUE)
		cat(paste(""), fill = TRUE)
        return(round(phat,2))	
    }
}

