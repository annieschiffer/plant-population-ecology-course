
# Model an annual plant interacting with an insect
# that is both a pollinator, which increases fecundity,
# and a seed predator, consuming seeds after they are produced but 
# before they are incorporated in the seed bank.

# set your working directory
setwd("G:/My Drive/AdlerLabDocs/PlantPopEcol/code")

### define population growth function-----------------------

mutualist_growth <- function(N,g,s,fec,alpha,H,s_H,a,h,b,p,h_p){
  
  # plants
  germinants <- g*N   # number of plants germinating out of the seed bank
  surv_seeds <- N*(1-g)*s  # number of ungerminated seeds that survive
  pollination <- p*H/(1 + p*h_p*H) # pollination benefit
  fec_eff <- fec*(1 + pollination) # effective fecundity after pollination
  new_seeds <- fec_eff*germinants/(1+alpha*germinants)  # fecundity (production of new seeds)
  consumed_seeds <- a*new_seeds*H/(1 + a*h*new_seeds)  # seed consumed by the herbivore, Type II functional response
  if(consumed_seeds>new_seeds) consumed_seeds<- new_seeds  # impose realistic limit on seed consumption
  total_seeds <- surv_seeds + new_seeds - consumed_seeds
  
  # herbivores
  surv_herbivores <- H*s_H
  new_herbivores <- b*consumed_seeds
  total_herbivores <- surv_herbivores + new_herbivores
  
  # format output
  plant_out <- c(total_seeds,germinants,surv_seeds,new_seeds)
  herbivore_out <- c(total_herbivores,consumed_seeds, pollination)
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

### set pollination parameters
p <- 0.01      # pollination "attack" rate; set to 0 to turn off pollination
h_p <- 0.95     # pollination handling time, < 1 (max pollination benefit = 1/h_p)

### set-up simulation ------------------------------------------

timesteps <- 500  # number of time steps to simulate

# matrix to store plant and seed data
Nmatrix <- matrix(NA,nrow=timesteps,ncol=4)  
colnames(Nmatrix) <- c("total_seeds","germinants","surv_seeds","new_seeds")
Nmatrix[1,] <- c(10,0,0,0)  # initial population state

# matrix to store herbivore data
Hmatrix <- matrix(NA,nrow=timesteps,ncol=3)  
colnames(Hmatrix) <- c("total_herbivores","consumed_seeds","pollination")
Hmatrix[1,] <- c(1,0,0)  # initial population state

# draw time-varying plant fecundities
fec <- rnorm(timesteps,fec_mu, fec_sigma) 
fec[fec<0] <- 0   # set negative fecundities to zero

### run simulation ------------------------------------------

for(i in 2:timesteps){
  update<- mutualist_growth(Nmatrix[i-1,1],g,s,fec[i],alpha,H=Hmatrix[i-1,1],s_H,a,h,b,p,h_p)
  Nmatrix[i,] <- update$plant_out
  Hmatrix[i,] <- update$herbivore_out
}

### plot results ------------------------------------------

myCols <-c("black","green","blue","violet")
myNames <- c("total seeds","plants","seed bank","new seeds")
myNames_H <- c("total herbivores","seeds consumed","pollination benefit")

par(mfrow=c(2,1))  # set up plotting device for two panels

matplot(Nmatrix,type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2, col=myCols, main="Plants and seeds")
legend("topleft",myNames,col=myCols,lty=1, lwd=2, bty="n")

matplot(Hmatrix,type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2, col=myCols, main= "Herbivores")
legend("topleft",myNames_H,col=myCols,lty=1, lwd=2, bty="n")

### plot effects of herbivore/mutualist density ----------------------------

# plant density at the no-herbivore equilibrium
lambda <- (1-g)*s + fec_mu*g
N_ref <- (lambda - 1)/(alpha*g*(1-(1-g)*s))

# range of herbivore densities
H_seq <- seq(0, 150, length.out=150)

# calculate germinants and seed production at N_ref
germinants_ref <- g*N_ref
new_seeds_ref <- fec_mu*germinants_ref/(1 + alpha*germinants_ref)

# seed consumption as a function of herbivore density
consumption <- a*new_seeds_ref*H_seq/(1 + a*h*new_seeds_ref)
consumption[consumption > new_seeds_ref] <- new_seeds_ref 

# pollination benefit as a function of herbivore density
pollination <- p*H_seq /
  (1 + p*h_p*H_seq)
fec_without_pollination <- fec_mu
fec_with_pollination <- fec_mu * (1 + pollination)
seeds_without_pollination <- fec_without_pollination * germinants_ref/(1 + alpha * germinants_ref)
seeds_with_pollination <- fec_with_pollination * germinants_ref/(1 + alpha * germinants_ref)
pollination_seeds <- seeds_with_pollination - seeds_without_pollination

# plot
par(mfrow=c(1,1))
plot(H_seq, consumption,
     type="l", lwd=2,
     xlab="Herbivore density",
     ylab="Seeds consumed or generated",
     ylim=c(0, max(consumption, pollination_seeds)),
     main=paste("Effects of Herbivores at N =", 
                round(N_ref, 1)))

lines(H_seq, pollination_seeds,
      lwd=2, lty=2)

legend("bottomright",
       legend=c("Seed consumption",
                "Pollination benefit"),
       lty=c(1,2), lwd=2, bty="n")
