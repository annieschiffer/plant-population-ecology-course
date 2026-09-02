---
title: "Problem set 5: Density dependence"
output: html_document
date: "2026-09-02"
---

## Purpose

The goal of this problem set is to introduce the analysis of density-dependent models. Analyses of 
density-independent models focus on a single population growth rate, $\lambda$. But in a 
density-dependent model, the population growth rate depends on the size of the population; 
there are an infinite number of possible $\lambda$s. Instead of focusing on $\lambda$, 
we focus on the intrinsic, or low density growth rate, and the equilibrium population size, or 
carrying capacity. In this lab, we will examine how different parameters in the annual
plant model affect those two quantities. 

## Getting started

Download the script `05_density_dependence.R` from the course website, save it to your working directory, and run the code. 
The population growth function, defined on lines 9-16, may look familiar at first glance, but it contains a 
new parameter, `alpha`, which affects seed production (line 12). Be prepared to explain to me how that line of code
relates to the equation for this model:
$$N_{t+1} = (1-g)sN_t + \frac{f_t g N_t}{1+\alpha g N_t}$$
where $f$ is fecundity in year $t$.


## Problems

P1. We will start by finding the intrinsic growth rate and equilibrium population size in a constant environment
with no seedbank. Use the following parameters:
```
fec_mu <- 3      # mean fecundity (must be > 0)
fec_sigma <- 0  # year-to-year standard deviation of fecundity (must be >= 0)
g <- 1             # germination rate
s <- 0.8              # survival of ungerminated seeds
alpha <- 0.1
```
Setting `g <- 1` prevents a seedbank from forming, and setting `fec_sigma <- 0` holds fecundity constant. 
Setting `g <- 1` also means you can simplify the equation above. The first part of your answer 
to this question should be the simplified version of that equation (a photo of a handwritten 
equation is OK).

Now, there are two ways we could find the intrinsic growth rate: you could set 
$N_t$ to a tiny number or you could set $\alpha =0$. Either approach effectively
removes the density-dependent term in your equation. The equation should now be
simple enough that you can simply see the population growth rate. What is it? You can 
check your answer with the code on lines 53-55.

There are also two ways to find the equilibrium population size. One is numerical:
just look at the figure produced by lines 47-49 (or the data for the figure, `Nmatrix`). 
The other method uses algebra. At equilibrium, $\frac{N_{t+1}}{N_t}=1$. 
Please use that expression and your simplified
version of the model equation to solve for the equilibrium population size (show
me each step of your solution; you can take a photo of handwritten math). 

P2. Now we will find the intrinsic growth rate and equilibrium population size in a constant environment
with a seedbank. For this scenario, set `g <- 0. 5`. You can use lines 53-55 to
find the intrinsic growth rate, but can you also find the analytical solution,
just using the equation? Did changing the germination rate from 1 (no seedbank) to
0.5 (seedbank) increase or decrease the intrinsic growth rate? Please give an
intuitive, ecological (not mathematical) explanation for that change.

In the presence of a seedbank, it is still possible to find an algebraic solution 
for the equilibrium population size, but it is ugly and I won't make you do it. 
Instead simply look at the figure (or data) for population size over time
to determine the equilibrium. Did changing the germination rate from 1 (no seedbank) to
0.5 (seedbank) increase or decrease the equilibrium population size? Please give an
intuitive, ecological (not mathematical) explanation for that change.

P3. Using the methods of your choice, show me whether the parameter `s` has 
a positive or negative effect on both the intrinsic growth rate and the equilibrium population size.
Same question for `alpha`.

P4. Finally, we will find the intrinsic growth rate and equilibrium population size
in the presence of temporal variation. Keep all the parameters the same (`g` is still `0.5`)
but now set `fec_sigma <- 1.5`. The code chunk starting at line 57 shows how 
to find the intrinsic growth rate numerically. Is this rate larger or smaller
than the rate for a constant environment (problem 2)? Why?

We can use the same numerical approach as before to find the equilibrium population size.
But eyeballing the figure will be harder given all the variation in population size.
Instead, take the average of the population time series, excluding the early
time steps when the population has not yet reached equilibrium. If you are not sure
when that early, transient period ends, you can set `timesteps` to a much larger
number and average over the second half of the time series. Is the equilibrium larger
or smaller than it was in a constant environment (problem 2)? Why?





