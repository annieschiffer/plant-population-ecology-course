
# model 2 species competition

# set your working directory
setwd("G:/My Drive/AdlerLabDocs/PlantPopEcol/code")

# load required packages
library(mvtnorm)

### define population growth function-----------------------

DD_2spp_growth <- function(N,g,s,fec,alpha){
  germinants1 <- g[1]*N[1]   # number of species 1 plants germinating out of the seed bank
  germinants2 <- g[2]*N[2]   # number of species 2 plants germinating out of the seed bank
  surv_seeds1 <- N[1]*(1-g[1])*s[1]  # number of ungerminated seeds that survive for species 1
  surv_seeds2 <- N[2]*(1-g[2])*s[2]  # number of ungerminated seeds that survive for species 1
  new_seeds1 <- fec[1]*germinants1/(1+alpha[1,1]*germinants1 + alpha[1,2]* germinants2)  # species 1 fecundity (production of new seeds)
  new_seeds2 <- fec[2]*germinants2/(1+alpha[2,1]*germinants1 + alpha[2,2]* germinants2)  # species 2 fecundity (production of new seeds)
  total_seeds1 <- surv_seeds1+new_seeds1
  total_seeds2 <- surv_seeds2+new_seeds2
  output <- c(total_seeds1,total_seeds2)
  output[output<0.01] <- 0             # extinction threshold
  return(output)
}

# Define a funtion to  draw fecundities from a multivariate normal distribution.
get_g <- function(timesteps, g_mu, vcov){
  # First we need to set up the variance-covariance matrix:
  vcov <- matrix(NA,2,2)
  diag(vcov) <- g_sigma^2
  vcov[1,2] <- vcov[2,1] <- g_cor*g_sigma[1]*g_sigma[2]
  # Now we draw from the multivariate normal:
  g_continuous <- rmvnorm(timesteps, mean=g_mu, sigma=vcov) # draw fecundities from a distribution
  g <-pnorm(g_continuous)
  return(g)
}

### set parameters ------------------------------------------

fec <- c(30,28)     # fecundity for species 1 and 2; doesn't vary
g_mu <- c(0,0)      # mean scaled germination fraction for each species; 0 will get converted into a probability of 0.5
g_sigma <- c(0,0)  # year-to-year standard deviation of fecundity (must be >= 0) for species 1 and 2
g_cor <- -0.9          # correlation in species 1 and 2 fecundity (ranges from -1 to 1)
s <- c(0.8,0.8)            # survival of ungerminated seeds for species 1 and 2
alpha <- matrix(NA,2,2)
alpha[1,1] <- 0.2   # effect of species 1 on itself
alpha[2,1] <- 0.2   # effect of species 1 on species 2
alpha[1,2] <- 0.2   # effect of species 2 on species 1
alpha[2,2] <- 0.2    # effect of species 2 on itself

### set-up simulation ------------------------------------------

timesteps <- 100  # number of time steps to simulate
Nmatrix <- matrix(NA,nrow=timesteps,ncol=2)  # matrix to store population time series
colnames(Nmatrix) <- c("spp1","spp2")
Nmatrix[1,] <- c(1,1)  # initial population state

# draw fecundities
g <- get_g(timesteps, g_mu, vcov)

### run simulation ------------------------------------------

for(i in 2:timesteps){
  Nmatrix[i,] <- DD_2spp_growth(N=Nmatrix[i-1,],g[i,],s,fec,alpha)
}

### plot results ------------------------------------------

myCols <-c("blue3","red4")
myNames <- c("Spp1","Spp2")

# plot on raw (arithmetic) scale
matplot(Nmatrix,type="l",xlab="Time",ylab="Population size",
        lty=1,lwd=2, col=myCols)
legend("topleft",myNames,col=myCols,lty=1, lwd=2, bty="n")

### calculate an invasion growth rate ------------------------

spin_up <- 100  # how many time steps before invasion
invasion_reps <-  1000 # how many times to study the invasion
invader <- 2         # which species is the invader, 1 or 2?
N_init <- c(1,1)     # initial population size
N_init[invader] <- 0 # initialize the invader at 0 abundance

# first, spin up the resident to equilibrium density
g <- get_g(spin_up, g_mu, vcov)
N_mono <- N_init  # this will become the starting density for the invasion experiment
for(i in 2:spin_up){
  N_mono <- DD_2spp_growth(N=N_mono,g[i,],s,fec,alpha)
}

# now, repeat a one-time step invasion experiment many times
resident <- ifelse(invader==1,2,1)
N_t0 <- matrix(NA,nrow=invasion_reps,ncol=2)  # matrix to store time t abundances
N_t0[1,] <-N_mono
N_t0[,invader] <- 1  # invader abundance
N_t1 <- matrix(NA,nrow=invasion_reps,ncol=2)  # matrix to store time t+1 abundances
g <- get_g(invasion_reps, g_mu, vcov)
# prevent invader from affecting itself or the resident
alpha_invade <- alpha
alpha_invade[,invader] <- 0

for(i in 1:invasion_reps){
  N_t1[i,] <- DD_2spp_growth(N=N_t0[i,],g[i,],s,fec,alpha_invade) 
  if(i < invasion_reps) N_t0[i+1,resident] <- N_t1[i,resident]    # store resident abundance as the initial value for the next invasion experiment
}

# calculate the invasion growth rate (use the geometric mean!)
r_inv <- mean(log(N_t1[,invader]/N_t0[,invader]))
print(paste0("(log) invasion growth rate=",r_inv))


