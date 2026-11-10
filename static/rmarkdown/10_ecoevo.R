# install R packages (if necessary) and load them
if (!require("pacman")) install.packages("pacman")
pacman::p_load(boot, latticeExtra, here)

###
### 1. load custom functions ---------------------------------------------------------
###

# generate fecundity rates
getLambdas = function(temperature,fec_Tmu,fec_Tsigma,fec_max){
  # temperature is a time series (vector) of T values
  # fec.Tmu is a vector of optimal temperatures (one value for each genotype)
  # fec.Tsigma is a vector of standard deviations for the temperature niche of each genotype
  L <- matrix(NA,nrow=length(temperature),ncol=length(fec_Tmu))
  for(i in 1:length(fec_Tmu)){
    L[,i] <- dnorm(temperature,fec_Tmu[i],fec_Tsigma[i])
    scalar <- fec_max[i]/dnorm(fec_Tmu[i],fec_Tmu[i],fec_Tsigma[i])
    L[,i] <- scalar*L[,i]
  }
  return(L)
}

# the next four functions make up the diploid model

newSeeds = function(N,lambda,alpha,g){
  # calculate the number of seeds produced by each genotype
  
  # N = vector of length 3 giving each population at time t
  # lambda = vector of the 3 genotype's fecundities
  # alpha is a 3x3 matrix of competition coefficients
  # g = vector of length 3 of each genotype's germination rate
  # output = vector (3) giving # seeds produced by each genotype at time t+1
  
  AA = g[1]*lambda[1]*N[1]/(1+g[1]*alpha[1,1]*N[1]+g[2]*alpha[1,2]*N[2]+g[3]*alpha[1,3]*N[3])
  Aa = g[2]*lambda[2]*N[2]/(1+g[1]*alpha[2,1]*N[1]+g[2]*alpha[2,2]*N[2]+g[3]*alpha[2,3]*N[3])
  aa = g[3]*lambda[3]*N[3]/(1+g[1]*alpha[3,1]*N[1]+g[2]*alpha[3,2]*N[2]+g[3]*alpha[3,3]*N[3])
  return(c(AA,Aa,aa))
  
}

survSeeds <- function(N,s,g){
  # calculate the number of seeds surviving in the seedbank for each genotype
  
  # N = vector of length 3 giving each population at time t
  # s = vector of length 3 of each genotype's seed survival rate
  # g = vector of length 3 of each genotype's germination rate
  AA=N[1]*(1-g[1])*s[1]
  Aa=N[2]*(1-g[2])*s[2]
  aa=N[3]*(1-g[3])*s[3]
  return(c(AA,Aa,aa))
}

getPhi<-function(seeds){
  
  # seeds is a vector of dim=3 containing the seeds produced by each genotpye (calculated in newSeeds() )
  phi<-numeric(2)   # create vector to store homozygote sqrt(frequencies)
  bigT<-sum(seeds)  # total seeds produced by all genotypes
  phi[1]<-(seeds[1] + seeds[2]/2)/bigT
  phi[2]<-1-phi[1] 
  return(phi)
}

diploid = function(N,seeds,phi){
  # This is an annual plant model, so it tracks
  # populations as numbers of seeds
  
  # N = vector of length 3 giving each genotype's density at time t
  # G = vector of length 3 of each genotype's germination rate
  # seedSurv = scalar giving the seedbank survival rate
  # seeds = vector (3) giving seeds produced by each genotype
  # phi = vector (2) giving frequency of homozygotes
  # output = vector (3) giving density of each genotype at time t+1
  
  Plants = N
  bigT = sum(seeds)  # total seed production
  Fec=c(phi[1]^2*bigT, 2*phi[1]*phi[2]*bigT, phi[2]^2*bigT)
  AA = Fec[1]
  Aa = Fec[2]
  aa = Fec[3]
  return(c(AA,Aa,aa))
}

###
### 2. set plant parameters ---------------------------------------------------------
###

# diploid model
fec_Tmu = c(-2,0,2)  # optimal temperature for genotypes AA, Aa, and aa
fec_Tsigma = rep(5,3)     # sets width of temperature niche for genotypes AA, Aa, and aa
fec_max = c(100,100,100)  # fecundity for genotypes AA, Aa, and aa
g = rep(1,3)
s = rep(0.8,3)  # survival of ungerminated seeds (same for both genotypes)
alpha = matrix(1,3,3)      # all competition coefficients (intra- and inter-) are equal for both genotypes
diag(alpha) = 1  # option to make intraspecific competition stronger than inter

###
### 3. set up simulation parameters
###

baseline_yrs<-400  # number of yrs at baseline temperature
warming_yrs <- 100  # number of yrs with warming occurring
final_yrs <- 400  # number of yrs at steadty-state, warmed temperature
sim_yrs <- baseline_yrs + warming_yrs + final_yrs # total number of years

Tstdev <- 0   # st dev of temperature (stationary)
baseT <- -2 # initial temperature
deltaT <- 4  # total change in temperature
Tmean <- baseT + c(rep(0,baseline_yrs),seq(deltaT/warming_yrs,deltaT,deltaT/warming_yrs),
                   rep(deltaT,final_yrs))

# generate a temperature time series
temperature = rnorm(sim_yrs,Tmean,Tstdev)  # generate temperature time series


###
### 4. run simulation ---------------------------------------------------------
###


burn_in=baseline_yrs/2   # years to reach stochastic equilibrium

# initialize
N=Plants=Fec=matrix(0,sim_yrs,3)
colnames(N)<-colnames(Plants)<-colnames(Fec)<-c("AA","Aa","aa")
N[1,] = fec_max[1]/3
lambdas = getLambdas(temperature,fec_Tmu,fec_Tsigma,fec_max)

for(iYr in 2:(sim_yrs)){
  seeds<-newSeeds(N[iYr-1,],lambdas[iYr,],alpha,g)
  phi <- getPhi(seeds)
  seeds_new <- diploid(N[iYr-1,],seeds,phi)
  seeds_surv <- survSeeds(N[iYr-1,],s,g)
  N[iYr,] <- seeds_new + seeds_surv  # total seedbank

}   # next i

###
### 5. plot time series ---------------------------------------------------------
###

par(mfrow=c(3,1),tcl=-0.2,mgp=c(2,0.5,0),mar=c(3,4,1,1))
plot(temperature,type="l",xlab="Time",ylab="Temperature")  # take a look
abline(v=baseline_yrs,lty="dotted")
plot(rowSums(N),type="l",xlab="Time",ylab="Total population size")
abline(v=baseline_yrs,lty="dotted")
matplot(N,type="l",xlab="Time",ylab="Genotype population size",
        lty=1,col=c("blue","darkgrey","red"))
legend("topleft",c("AA","Aa","aa"),lty=1,col=c("blue","darkgrey","red"),bty="n")
abline(v=baseline_yrs,lty="dotted")

# compare last total population time series with the current one,
# IF the last one was saved
if(exists("lastN")){
  X11(title="Compare runs")
  par(mfrow=c(1,1))
  matplot(cbind(rowSums(lastN),rowSums(N)),
          type="l",lty=1,
          col=c("black","red"),
          xlab="Time",ylab="Total population size")
  legend("bottomleft",c("lastN","N"),lty=1, col=c("black","red"),bty="n")
}

# save the population time series
lastN <- N



