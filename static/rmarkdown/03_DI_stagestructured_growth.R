
# model density independent growth of a population with two stages: seeds and plants

# set your working directory
setwd("G:/My Drive/AdlerLabDocs/PlantPopEcol/code")

### define population growth function-----------------------

DI_SB_growth <- function(N,g,s,fec){
  germinants <- g*N   # number of plants germinating out of the seed bank
  surv_seeds <- N*(1-g)*s  # number of ungerminated seeds that survive
  new_seeds <- fec*germinants  # fecundity (production of new seeds)
  total_seeds <- surv_seeds+new_seeds
  output <- c(total_seeds,germinants,surv_seeds,new_seeds)
  return(output)
}

### set parameters ------------------------------------------

fec_mu <- 1.8      # mean fecundity (must be > 0)
fec_sigma <- 0  # year-to-year standard deviation of fecundity (must be > 0)
g <- 0.5              # germination rate
s <- 0.8              # survival of ungerminated seeds

### set-up simulation ------------------------------------------

timesteps <- 100  # number of time steps to simulate
Nmatrix <- matrix(NA,nrow=timesteps,ncol=4)  # matrix to store population time series
colnames(Nmatrix) <- c("total_seeds","germinants","surv_seeds","new_seeds")
Nmatrix[1,] <- c(1,0,0,0)  # initial population state
fec<- rnorm(timesteps,fec_mu, fec_sigma) # draw fecundities from a distribution
fec[fec<0] <- 0   # set negative fecundities to zero

### run simulation ------------------------------------------

for(i in 2:timesteps){
  Nmatrix[i,] <- DI_SB_growth(Nmatrix[i-1,1],g,s,fec[i])
}

# calculate long-term average population growth rate (geometric mean)
little_r <- mean(log(Nmatrix[2:(nrow(Nmatrix)),1]/Nmatrix[1:(nrow(Nmatrix)-1),1]))
print(paste0("r=",little_r))

# plot
myCols <-c("black","green","blue","violet")
myNames <- c("total seeds","plants","seed bank","new seeds")

# plot on log scale
matplot(log(Nmatrix),type="l",xlab="Time",ylab="(log) Population size",
        lty=1,lwd=2, col=myCols)
legend("topleft",myNames,col=myCols,lty=1,lwd=2, bty="n")

### Rewrite as a matrix population model ---------------------------------

# let's assume a constant environment for now:
fec_sigma <- 0
fec<- fec_mu

# set up the transition matrix and compute matrix entries
A <- matrix(NA,2,2)  # 2 x 2 transition matrix
A[1,1] <- (1-g)*s  # probability that a seed does not germinate and survives
A[2,1] <- g    # probability that a seed germinates, emerges and grows into a plant
A[1,2] <- fec   # fecundity: number of seeds produced by each plant
A[2,2] <- 0   # probability that a plant survives (our annual plant model assumed this was zero)

# set up the simulation
timesteps <- 100  # number of time steps to simulate
Nout <- matrix(NA,timesteps,2)
colnames(Nout) <- c("seeds","plants")
Nout[1,] <- c(1,0)  # initial abundance of seeds and plants in the population

# run simulation
for(i in 2:timesteps){
  Nout[i,] <- A%*%Nout[i-1,]
}

# plot seeds and plants
matplot(log(Nout),type="l", col=c("black","red"),lty=1,lwd=2,xlab="Time")
legend("topleft",c("seeds","plants"),col=c("black","red"),lty=1,lwd=2, bty="n")

### analyze output -------------------------------------------------------

# calculate annual growth rates
r_t <- log(rowSums(Nout)[2:timesteps]) - log(rowSums(Nout)[1:(timesteps-1)])
print(paste0("r=",mean(r_t)))

# simple formula for the log population growth rate in a constant environment (no simulations needed!)
growthrate <- eigen(A)$values[1]
print(paste0("r=",log(growthrate)))

# look at the size distribution over time as the proportion of the population in seed stage
prop_seeds <- Nout[,1]/(rowSums(Nout))

# simpler formula for stable proportion of seeds and plants
Evector<- eigen(A)$vectors[,1]
print(Evector/sum(Evector))

                         