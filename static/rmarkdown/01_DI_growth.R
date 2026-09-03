
# model density independent growth

# set your working directory
setwd("G:/My Drive/AdlerLabDocs/PlantPopEcol/code")

### define population growth function-----------------------

DI_growth <- function(N,lambda){
  output <- lambda*N
  return(output)
}

### set parameters ------------------------------------------

lambda_mu <- 1.2 # mean fecundity (must be > 0)
lambda_sigma <- 0 # year-to-year standard deviation of fecundity (must be >= 0)

### set-up simulation ------------------------------------------

timesteps <- 100  # number of time steps to simulate
Nvec <- rep(NA,timesteps)  # vector to store population time series
Nvec[1] <- 1  # initial population size
lambda <- rnorm(timesteps,lambda_mu, lambda_sigma) # draw lambdas from a distribution
lambda[lambda<0] <- 0   # set negative lambdas to zero

### run simulation ------------------------------------------

for(i in 2:timesteps){
  Nvec[i] <- DI_growth(Nvec[i-1],lambda[i])
}

### plot results ------------------------------------------

# plot on raw (arithmetic) scale
plot(Nvec,type="l",xlab="Time",ylab="Population size")

# plot on log scale
plot(log(Nvec),type="l",xlab="Time",ylab="(log) Population size")

### fit regression of population size over time------------------------------------------

time <- 1:timesteps
myReg <- lm(log(Nvec) ~ time)
(coef(myReg))
(log(lambda_mu))


