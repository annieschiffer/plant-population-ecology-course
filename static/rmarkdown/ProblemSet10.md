---
title: "Problem set 10: Evolutionary rescue"
output: html_document
date: "2026-11-07"
---

## Purpose

The goal of this problem set is to gain some intuition about eco-evolutionary
dynamics and evolutionary rescue following rapid environmental change. 

## Getting started

Download the script `10_ecoevo.R` from the course website and save it to your working directory. This script 
builds on the week 5 code we used to study density dependence, but we will keep track of three genotypes
within this population. We assume a diploid population and focus on one temperature dependent loci: 
The AA homozygous genotype has highest fitness under cold temperatures, the aa genotype has highest fitness 
under high temperatures, and the Aa heterozygous genotype has highest fitness under at the midpoint between the 
specified high and low temperature optima for aa and AA, respectively.

Our model keeps track of each population's genotype separately. The trick is sex: what are the 
genotypes of the next generation's seeds? We assign those genotypes assuming Hardy_Weinberg 
equilibrium:
$$p^2 + 2pq + q^2 = 1$$
where $p$ is the frequency of AA in the population and $q$ is the frequency of aa. To scale 
that equation to the number of seeds in the next generation, we just multiply both sides by
total new seed production (summed across all three genotypes). That is done in the custom
function named `diploid` (the object `phi` contains the three quantities on the left
side of the equation above).

Our simulation asks what happens to the total population size after temperature increases rapidly?
Two of the parameters look similar but do different things: `fec_Tsigma` determines the width
of each genotypes temperature niche (i.e., reaction norm), whereas `Tstdev` determines the magnitude
of interannual variation in our simulated temperature time series. We start with `Tstdev` set to zero
to make the dynamics more obvious. 

## Problems

P1. Start by running the script with the default parameters (shown below, please check to make sure they
match the version of the script you downloaded). What happens to total population size over the course
of the simulation? Can you explain what is happening based on the changes in genotype frequencies? Hint: try
plotting the genotype abundances line 146) on log scale.
```
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
```

P2. Now increase `fec_Tsigma` from 5 to 10. What changed? Why?

P3. Return `fec_Tsigma` to 5 and now increase `Tstdev` from 0 to 1. What changed? Why?

P4. Reduce `g` to 0.4. This will allow a seedbank to develop. What changes? Why?

P5. Return `g` to 1. Now we will ask how the dynamics change if each genotype
limits its own population growth more than it limits the other genotypes. Do 
this by changing line 94 to `diag(alpha) = 1.1`. What changes? Why? (Again, plotting
the genotype abundances on log scale might help).

P6. Please summarize what you've learned about evolutionary rescue: what factors 
cause a deep "dip" in population size following warming? What factors make that
dip shallower or prevent it altogether?
