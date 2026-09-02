
# model density dependent growth

# set your working directory
setwd("G:/My Drive/AdlerLabDocs/PlantPopEcol/code")

### define population growth function-----------------------

DD_SB_growth <- function(N,g,s,fec,alpha){
  germinants <- g*N   # number of plants germinating out of the seed bank
  surv_seeds <- N*(1-g)*s  # number of ungerminated seeds that survive
  new_seeds <- fec*germinants/(1+alpha*germinants)  # fecundity (production of new seeds)
  total_seeds <- surv_seeds+new_seeds
  output <- c(total_seeds,germinants,surv_seeds,new_seeds)
  return(output)
}

### set parameters ------------------------------------------

fec_mu <- 3      # mean fecundity (must be > 0)
fec_sigma <- 1.5  # year-to-year standard deviation of fecundity (must be >= 0)
g <- 0.5        # germination rate
s <- 0.8              # survival of ungerminated seeds
alpha <- 0.1

### set-up simulation ------------------------------------------

timesteps <- 100  # number of time steps to simulate
Nmatrix <- matrix(NA,nrow=timesteps,ncol=4)  # matrix to store population time series
colnames(Nmatrix) <- c("total_seeds","germinants","surv_seeds","new_seeds")
Nmatrix[1,] <- c(1,0,0,0)  # initial population state
fec <- rnorm(timesteps,fec_mu, fec_sigma) # draw fecundities from a distribution
fec[fec<0] <- 0   # set negative fecundities to zero

### run simulation ------------------------------------------

for(i in 2:timesteps){
  Nmatrix[i,] <- DD_SB_growth(Nmatrix[i-1,1],g,s,fec[i],alpha)
}

### plot results ------------------------------------------

myCols <-c("black","green","blue","violet")
myNames <- c("total seeds","plants","seed bank","new seeds")

# plot on raw (arithmetic) scale
matplot(Nmatrix,type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2, col=myCols)
legend("topleft",myNames,col=myCols,lty=1, lwd=2, bty="n")

### intrinsic growth rate (set alpha = 0 and N to any arbitrary number)

Nnew <- DD_SB_growth(N=1,g,s,fec=fec_mu,alpha=0)
Lambda <- Nnew[1]/1 
r <- log(Lambda)

### find the intrinsic growth rate in a variable environment

# repeat the previous calculation many times, sampling from fec
Lambda_save <- rep(NA,timesteps)
for(i in 1:timesteps){
  Nnew <- DD_SB_growth(N=1,g,s,fec=fec[i],alpha=0)
  Lambda_save[i] <- Nnew[1]/1 
}
r_save <- log(Lambda_save)
(r_mu <- mean(r_save))
(Lambda_mu <- exp(r_mu))



