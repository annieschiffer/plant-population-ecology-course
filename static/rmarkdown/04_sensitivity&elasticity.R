
# model density independent growth of a population with two stages: seeds and plants

# set your working directory
setwd("G:/My Drive/AdlerLabDocs/PlantPopEcol/code")

### set parameters ------------------------------------------

fec_mu <- 1.8      # mean fecundity (must be > 0)
fec_sigma <- 0  # year-to-year standard deviation of fecundity (must be > 0)
g <- 0.5              # germination rate
s <- 0.8              # survival of ungerminated seeds

### Rewrite as a matrix population model ---------------------------------

# let's assume a constant environment for now:
fec_sigma <- 0
fec <- lambda_mu

# set up the transition matrix and compute matrix entries
A <- matrix(NA,2,2)  # 2 x 2 transition matrix
A[1,1] <- (1-g)*s  # probability that a seed does not germinate and survives
A[2,1] <- g    # probability that a seed germinates, emerges and grows into a plant
A[1,2] <- fec   # fecundity: number of seeds produced by each plant
A[2,2] <- 0   # probability that a plant survives (our annual plant model assumed this was zero)

### calculate sensitivity and elasticity by hand---------------------------------

# First we need the stable stage distribution and the population growth rate, lambda. 
# We could get those from eigen analysis (as in the next section) but let's just do it numerically with a simulation. 
timesteps <- 100  # number of time steps to simulate
Nout <- matrix(NA,timesteps,2)
colnames(Nout) <- c("seeds","plants")
Nout[1,] <- c(1,0)  # initial abundance of seeds and plants in the population
for(iT in 2:timesteps){
  Nout[iT,] <- A%*%Nout[iT-1,]
}
N_stable <- Nout[timesteps,]/sum(Nout[timesteps,])  # assume we've reached the stable stage distribution by the last time step
Lambda <- sum(A%*%N_stable)/sum(N_stable) # note: because N stable sums to 1, we can simply write: Lambda <- sum(A%*%N_stable)

# Now calculate the change in Lambda for a very small change in one matrix element
i <- 1  # choose matrix row
j <- 1  # choose matrix column
delta <- 0.01 # amount to change one matrix element
A_p <- A # make a copy of the original transition matrix ("p" for "perturbed")
A_p[i,j] <-  A_p[i,j] + delta
# calculate the stable stage distribution for this new matrix
Nout[1,] <- c(1,0)  # initial abundance of seeds and plants in the population
for(iT in 2:timesteps){
  Nout[iT,] <- A_p%*%Nout[iT-1,]
}
N_stable_p <- Nout[timesteps,]/sum(Nout[timesteps,])  # assume we've reached the stable stage distribution by the last time step
Lambda_p <- sum(A_p%*%N_stable_p)
sensitivity_ij <- (Lambda_p - Lambda)/delta  # sensitivity of the one matrix element we perturbed
print(sensitivity_ij)

# convert sensitivity_ij to an elasticity
elasticity_ij <- sensitivity_ij*A[i,j]/Lambda
print(elasticity_ij)


### calculate sensitivity and elasticity with formulas based on eigen analysis---------------------------------

# Compute eigenvalues and  eigenvectors
eig <- eigen(A)

# Extract dominant eigenvalue and Lambda
k <- which.max(Re(eig$values))  # Re() returns the real part of a complex number 
Lambda <- Re(eig$values[k])

# Right eigenvector
w <- Re(eig$vectors[, k])

# Left eigenvector = right eigenvector of t(A_matrix)
eig_left <- eigen(t(A))
k_left <- which.min(abs(eig_left$values - eig$values[k]))
v <- Re(eig_left$vectors[, k_left])

# Make eigenvectors positive
if (sum(w) < 0) w <- -w
if (sum(v) < 0) v <- -v

# Sensitivity matrix
sensitivity <- outer(v, w) / sum(v * w)
print(sensitivity)

# Elasticity matrix
elasticity <- (A / Lambda) * sensitivity
print(elasticity)


### calculate sensitivity and elasticity with functions from the popbio package ---------------------------------
library(popbio)

sensitivity <- sensitivity(A)
print(sensitivity)

elasticity <- elasticity(A)
print(elasticity)



                         