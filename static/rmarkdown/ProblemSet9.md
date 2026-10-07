---
title: "Problem set 9: Metapopulations"
output: html_document
date: "2026-09-02"
---

## Purpose

The goal of this problem set is to gain some intuition about metapopulation dynamics and also to learn
how to code a simple metapopulation simulation. 

## Getting started

Download the script `09_metapops.R` from the course website and save it to your working directory. This script 
builds on the week 5 code we used to study density dependence. There are just a few main differences: First, we simulate
multiple populations, or patches, at once. Second, the patches are connected by dispersal. Third, random disturbances
can wipe out an entire population, seedbank and all. Here is a little more information about choices I made in coding
each of these features.

I did not assign spatial coordinates to each patch. We know there are multiple patches, but we don't know which ones
are close together and which are far apart. That means we can only use a very simple dispersal process: In each patch, 
a fraction, `d`, of newly produced seeds leaves the patch and is redistributed evenly among all 
other patches (see script lines 16-22). To implement more realistic, distance-dependent dispersal, we would 
need to assign spatial coordinates to each patch.

I assume the patches are all identical except they may differ in mean fecundity (see the `patch_fec`
parameter on lines 14 and 49). 

I assume disturbances happen with probability `pDist` (line 46), they affect each patch
independently of other patches and independently of previous disturbances, and they wipe 
out populations at the start of the growing season. 

## Problems

P1. Start with these parameters (note that `pDist` and `d` are both set to zero):
```
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
```
Run the script and examine the graph: you shoud see that each patch reaches a stable
equilibrium population size. Now set `pDist <- 0.1` and run the script 10 times.
What happens? Why?

P2. Keeping `pDist <- 0.1`, re-run the script at progressively higher values of `d`, 
increasing `d` by 0.02 each time. For each value of `d`, run the script 10 times and record the number
of runs in which at least one patch has a non-zero population at the end of the simulation. Your answer
should include a plot of `d` on the x-axis against the number of runs in which the metapopulation persisted 
on the y-axis. What is the lowest value of `d` that ensures metapopulation persistence?

P3. Answer problem 2 again, but this time set `patches <- 20`. 
How does the relationship between `d` and metapopulation persistence change and
what is the lowest value of `d` that ensures metapopulation persistence? Why did the answer change? 

P4. Answer problem 2 again, but this time return `patches <- 5` and increase `fec_mu` to 5 for all runs.
How does the relationship between `d` and metapopulation persistence change and
what is the lowest value of `d` that ensures metapopulation persistence? Why did the answer change? 

P5. Same question again, but return `fec_mu` to 3 and set `g <- 0.5`, so a seedbank will develop. 
How does the relationship between `d` and metapopulation persistence change and
what is the lowest value of `d` that ensures metapopulation persistence? Why did the answer change? 

P6. If we altered the disturbance so it only affected new seeds, and left the seedbank intact, 
do you think the lowest value of `d` that ensures metapopulation persistence would go up or down?
If you have the time, go ahead and alter the script to test your hypothesis (Hint: right now,
the disturbance happens outside the population growth function; to make this change, I think you
need to include the disturbance inside that function.)


