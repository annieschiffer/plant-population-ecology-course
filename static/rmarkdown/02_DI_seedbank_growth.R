
# model density independent growth with a seedbank

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
fec_sigma <- 0.2  # year-to-year standard deviation of fecundity (must be > 0)
g <- 0.5              # germination rate
s <- 0.8              # survival of ungerminated seeds

### set-up simulation ------------------------------------------

timesteps <- 100  # number of time steps to simulate
Nmatrix <- matrix(NA,nrow=timesteps,ncol=4)  # matrix to store population time series
colnames(Nmatrix) <- c("total_seeds","germinants","surv_seeds","new_seeds")
Nmatrix[1,] <- c(1,0,0,0)  # initial population state
fec <- rnorm(timesteps,fec_mu, fec_sigma) # draw fecundities from a distribution
fec[fec<0] <- 0   # set negative fecundities to zero

### run simulation ------------------------------------------

for(i in 2:timesteps){
  Nmatrix[i,] <- DI_SB_growth(Nmatrix[i-1,1],g,s,fec[i])
}

# calculate long-term average population growth rate (geometric mean)
little_r <- mean(log(Nmatrix[2:(nrow(Nmatrix)),1]/Nmatrix[1:(nrow(Nmatrix)-1),1]))
print(paste0("r=",little_r))

# calculate the standard deviation of the annual population growth rates 
little_r_sd <- sd(log(Nmatrix[2:(nrow(Nmatrix)),1]/Nmatrix[1:(nrow(Nmatrix)-1),1]))
print(paste0("r SD =",little_r_sd))

### plot results ------------------------------------------

myCols <-c("black","green","blue","violet")
myNames <- c("total seeds","plants","seed bank","new seeds")

# plot on raw (arithmetic) scale
matplot(Nmatrix,type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2, col=myCols)
legend("topleft",myNames,col=myCols,lty=1, lwd=2, bty="n")

# plot on log scale
matplot(log(Nmatrix),type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2, col=myCols)
legend("topleft",myNames,col=myCols,lty=1,lwd=2, bty="n")


