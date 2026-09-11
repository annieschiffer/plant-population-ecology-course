---
title: "Problem set 6: Competition and Coexistence"
output: html_document
date: "2026-09-10"
---

## Purpose

The goal of this problem set is to explore competition between two plants species, the 
possible outcomes of competition, and the conditions that make stable coexistence possible.

## Getting started

Download the script `06_competition.R` from the course website, save it to your working directory, and run the code. 
The population growth function should look similar to the single species version we worked with last week, with
two important differences: there are now twice as many lines of code, since we need to calculate the number
of germinants, seed bank survivors, etc. for two species instead of one, and there are new indices
applied to each parameter. That is because parameters like `g` and `s` now have two values, one for 
each species, and `alpha` is a 2x2 matrix (see lines 46-49). That function corresponds to this equation:
$$N_{i,t+1} = s_i(1-g_i)N_{i,t} + \frac{F_i g_i  N_{i,t}}{1+ \alpha_{i,i}g_i N_{i,t} + \alpha_{i,j}g_j N_{j,t}}$$
Note that $N$ now has a time subscript, $t$, and a species subscript, $i$.

Another difference is a new, custom function to draw
fecundities for both species from a multivariate normal distribution (lines 26-36). 
We will talk about how that works in class.

Finally, I added an extinction threshold (line 22).


## Problems

P1. We will start with stable coexistence and a constant environment using these parameters:

```
### set parameters ------------------------------------------

fec_mu <- c(30,24)      # mean fecundity (must be > 0) for species 1 and 2
fec_sigma <- c(0,0)  # year-to-year standard deviation of fecundity (must be >= 0) for species 1 and 2
fec_cor <- -0.9           # correlation in species 1 and 2 fecundity (ranges from -1 to 1)
g <- c(0.5,0.5)        # germination rate for species 1 and 2
s <- c(0.8,0.8)            # survival of ungerminated seeds for species 1 and 2
alpha <- matrix(NA,2,2)
alpha[1,1] <- 0.2   # effect of species 1 on itself
alpha[2,1] <- 0.15   # effect of species 1 on species 2
alpha[1,2] <- 0.15   # effect of species 2 on species 1
alpha[2,2] <- 0.2    # effect of species 2 on itself
```
Please paste the resulting time series figure into your answer document so I can see this worked correctly.
Now, alter parameters to produce the following four scenarios. Each scenario should differ in only one parameter from the values shown above.
For each scenario, list the parameter you altered and its new value and show the resulting time series figure.

 - Alter `fec_mu` so that species 1 wins and species 2 goes extinct.
 - Alter `fec_mu` so that species 2 wins and species 1 goes extinct.
 - Alter one element of `alpha` so that species 1 wins and species 2 goes extinct.
 - Alter one element of `alpha` so that species 2 wins and species 1 goes extinct.

P2. Eyeballing a simulated time series is not a dependable way of diagnosing stable coexistence. A much better
method is an "invasion analysis," as shown in the code chunk starting at line 79. For a two species system, 
we know coexistence is stable if each species can invade (has a positive growth rate when rare) a monoculture of
the other species at its steady-state abundance. Make sure you understand the code then calculate 
(and show me) the invasion growth rates for both species 1 and species 2 for 1) the 
parameters I show above, and 2) each of the additional four scenarios you explored for Problem 1. Are the 
invasion growth rates consistent with your interpretion of the coexistence outcome for each of these scenarios?

P3. So far, we've explored three of the four possible outcomes of two-species competition: species 1 excludes species 2,
species 2 excludes species 1, or stable coexistence. The fourth is unstable coexistence. In mathland, this can
result in a fragile equilibrium which any tiny perturbation will destroy. In the real world, it manifests as 
"priority effects": different species win depending on the initial conditions. Please use the script to demonstrate this scenario.
Your first step is to set the parameters as shown above, but change `alpha` like this to make interspecific competition
stronger than intraspecific competition:
```
alpha[1,1] <- 0.2   # effect of species 1 on itself
alpha[2,1] <- 0.23   # effect of species 1 on species 2
alpha[1,2] <- 0.25  # effect of species 2 on species 1
alpha[2,2] <- 0.2    # effect of species 2 on itself
```
Next, play with the initial values (line 56) to find a case where species 1 drives species 2 extinct and 
a second case with the opposite outcome. Your answer will be the initial values for each of those cases 
and the corresponding time series figure. Please also report the invasion growth rates for each species for these 
two scenarios. Do they make sense? Explain.

P4. In this version of the model adding environmental variation makes coexistence harder. This is consistent with what we
learned about single-species models: adding variation in fecundity decreased the long-term mean growth rate. To see that 
with this model, return to the parameter values shown in P1 but set `fec_mu <- c(30,23)`. What is the invasion growth rate
for species 2? Now set `fec_sigma <- c(10,10)'. What is the invasion growth rate now for species 2 (do at least 5 runs)? Do the 
time series figures show results consistent with the invasion analysis?

P5. The previous problem shows that variation in fecundity does not help stabilize coexistence, even when the two 
species are favored in different years (`fec_cor <- -0.9`). So how can species "time share" the environment?
We need a different part of the life cycle to respond to environmental variation. Open up the script `06_competition_g_varies.R`.
I've set it up with parameters that result in species 1 driving species 2 to extinction. In fact, because all values of
`alpha` equal 2, any difference in fecundity will lead to exclusion, at least in a constant environment. But what happens 
if you set `g_sigma <- c(0.5,0.5)` (again, you may need to do a few runs)? What is species 2's invasion growth rate? 
What if you set `g_cor <- 0`? How does the invasion growth rate change? And if `g_cor <- 1`?


