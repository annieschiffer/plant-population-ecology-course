
# model an annual plant with a seed predator
# the predator consumers seeds after they are produced and 
# before they are incorporated in the seed bank

# set your working directory
setwd("G:/My Drive/AdlerLabDocs/PlantPopEcol/code")

### define population growth function-----------------------

seed_herbivore_growth <- function(N,g,s,fec,alpha,H,s_H,a,h,b){
  
  # plants
  germinants <- g*N   # number of plants germinating out of the seed bank
  surv_seeds <- N*(1-g)*s  # number of ungerminated seeds that survive
  new_seeds <- fec*germinants/(1+alpha*germinants)  # fecundity (production of new seeds)
  consumed_seeds <- a*new_seeds*H/(1 + a*h*new_seeds)  # seed consumed by the herbivore, Type II functional response
  if(consumed_seeds>new_seeds) consumed_seeds<- new_seeds  # impose realistic limit on seed consumption
  total_seeds <- surv_seeds + new_seeds - consumed_seeds
  
  # herbivores
  surv_herbivores <- H*s_H
  new_herbivores <- b*consumed_seeds
  total_herbivores <- surv_herbivores + new_herbivores
  
  # format output
  plant_out <- c(total_seeds,germinants,surv_seeds,new_seeds)
  herbivore_out <- c(total_herbivores,consumed_seeds)
  return(list(plant_out=plant_out,herbivore_out=herbivore_out))
  
}

### set plant parameters ------------------------------------------
fec_mu <- 10      # mean fecundity (must be > 0)
fec_sigma <- 0  # year-to-year standard deviation of fecundity (must be >= 0)
g <- 0.5        # germination rate
s <- 0.8              # survival of ungerminated seeds
alpha <- 0.1          # density dependence

### set seed predator (herbivore = H) parameters
s_H <- 0.4   # herbivore survival rate
a <- 0.1   # herbivore attack rate
h  <- 0.2   # handling time
b <- 0.2   # number of new herbivores per seeds consumed

### set-up simulation ------------------------------------------

timesteps <- 500  # number of time steps to simulate

# matrix to store plant and seed data
Nmatrix <- matrix(NA,nrow=timesteps,ncol=4)  
colnames(Nmatrix) <- c("total_seeds","germinants","surv_seeds","new_seeds")
Nmatrix[1,] <- c(10,0,0,0)  # initial population state

# matrix to store herbivore data
Hmatrix <- matrix(NA,nrow=timesteps,ncol=2)  
colnames(Hmatrix) <- c("total_herbivores","consumed_seeds")
Hmatrix[1,] <- c(1,0)  # initial population state

# draw time-varying plant fecundities
fec <- rnorm(timesteps,fec_mu, fec_sigma) 
fec[fec<0] <- 0   # set negative fecundities to zero

### run simulation ------------------------------------------

for(i in 2:timesteps){
  update<- seed_herbivore_growth(Nmatrix[i-1,1],g,s,fec[i],alpha,H=Hmatrix[i-1,1],s_H,a,h,b)
  Nmatrix[i,] <- update$plant_out
  Hmatrix[i,] <- update$herbivore_out
}

### plot results ------------------------------------------

myCols <-c("black","green","blue","violet")
myNames <- c("total seeds","plants","seed bank","new seeds")
myNames_H <- c("total herbivores","seeds consumed")

par(mfrow=c(2,1))  # set up plotting device for two panels

matplot(Nmatrix,type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2, col=myCols, main="Plants and seeds")
legend("topleft",myNames,col=myCols,lty=1, lwd=2, bty="n")

matplot(Hmatrix,type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2, col=myCols, main= "Herbivores")
legend("topleft",myNames_H,col=myCols,lty=1, lwd=2, bty="n")


