
# model density dependent growth in a metapopulation

# set your working directory
setwd("G:/My Drive/AdlerLabDocs/PlantPopEcol/code")

### define metapopulation growth function-----------------------

metapop_growth <- function(N,g,s,fec,alpha,d,patch_fec){
  
  # Note that N is now a vector, each element corresponds to one site
  germinants <- g*N   # number of plants germinating out of the seed bank
  surv_seeds <- N*(1-g)*s  # number of ungerminated seeds that survive
  new_seeds_local <- patch_fec*fec*germinants/(1+alpha*germinants)  # fecundity (production of new seeds)
  
  # do dispersal
  new_seeds_dispersal <- rep(0, length(N))
  for(iPatch in 1:length(N)){
    emigrants <- new_seeds_local[iPatch]*d
    new_seeds_local[iPatch] <- new_seeds_local[iPatch] - emigrants
    new_seeds_dispersal[-iPatch] <- new_seeds_dispersal[-iPatch] + emigrants/(length(N)-1)
  }
  
  total_seeds <- surv_seeds+new_seeds_local+new_seeds_dispersal
  
  # enforce extinction threshold
  total_seeds[total_seeds < 1] <- 0
  
  return(total_seeds)
  
}

### set parameters ------------------------------------------

fec_mu <- 3      # mean fecundity (must be > 0)
fec_sigma <- 0  # year-to-year standard deviation of fecundity (must be >= 0)
g <- 1        # germination rate
s <- 0.8              # survival of ungerminated seeds
alpha <- 0.1
d <- 0         # dispersal: fraction of seeds that leave the local patch

### set-up simulation ------------------------------------------

patches <- 5
patch_fec <- runif(patches,0.8,1.2)  # multiplier so each patch has different fecundity
pDist <- 0    # probability of disturbance

timesteps <- 100  # number of time steps to simulate

Nmatrix <- matrix(NA,nrow=timesteps,ncol=patches)  # matrix to store population time series
Nmatrix[1,] <- (fec_mu-1)/alpha  # initial population state

fec <- rnorm(timesteps,fec_mu, fec_sigma) # draw fecundities from a distribution, all sites have same fecundity
fec[fec<0] <- 0   # set negative fecundities to zero

### run simulation ------------------------------------------

for(i in 2:timesteps){
  
  # disturbance 
  Nmatrix[i-1,] <- Nmatrix[i-1,]*(1-rbinom(n=patches,size=1,prob=pDist))
  
  # population growth and dispersal
  Nmatrix[i,] <- metapop_growth(Nmatrix[i-1,],g,s,fec[i],alpha,d,patch_fec)
  
}

### plot results ------------------------------------------

# plot on raw (arithmetic) scale
myCols<-c(1:patches)
matplot(Nmatrix,type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2,col=myCols)
#legend("topleft",as.character(1:patches),col=myCols,lty=1, lwd=2, bty="n")

# calculate incidence for each patch
(incidence <- colSums(Nmatrix>0)/nrow(Nmatrix))




