---
title: "Problem set 8: Mutualism"
output: html_document
date: "2026-09-23"
---

## Purpose

The goal of this problem set is to model and explore interactions between a plant
population and an insect that is both a pollinator (as an adult) and a seed
predator (as a larvae).

## Getting started

Download the script `08_mutualists.R` from the course website and save it to your working directory.

The starting point for this model is the model of seed predation we worked with last week. All
I have done is added two lines of code (lines 17-18) to include pollination. I chose a saturating functional
form for the *M*utualistic benefit of pollination, $M$:
$$M = p H/(1 + p h_p H)$$
where $p$ represents the pollination attach rate and $p_h$ is pollinator handling time. This 
relationship saturates with herbivore density, $H$: a few pollinators make a big difference,
but eventually adding more pollinators doesn't increase their benefits. Note that this benefit
has a multiplicative effect on *effective* fecundity:
$$f_{eff} = f_\mu (1 + M)$$
which is implemented on line 18. The maximum pollination benefit is $1/h_p$. So a
value of $h_p=0.5$ could double fecundity.

We use a similar saturating function for herbivory: as the number of plants increases, herbivores first
have  big impact per capita, but when there are tons of plants, consumption levels off.

At the end of the script, I've added code for a new figure that compares the costs of
herbivory and the benefits of pollination from the plant's perspective. For the equilibrium
plant population we would expect in the absence of the herbivore, it shows how the number
of seeds consumed, and the change in the number of seeds produced via pollination, increase
with the size of the herbivore population.

## Problems

P1. Before you run the script, please answer this question in words. Last week, we saw that we had to
choose just the right parameters to get the plant and the seed predator to reach a stable
equilibrium: if the herbivore wasn't effective enough, it went extinct, and if it was too 
effective, the system began oscillating in a stable limit cycle. What do you think will
change when the seed predator also functions as a pollinator? Will adding the mutualism increase
or decrease the tendency of the system to cycle? Why?

P2. Now use the script to see if your answer to problem 1 is correct. Start with the same
parameters we used last week to get a stable equilibrium, with pollination turned off 
(`p <- 0`):

```
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
p <- 0      # pollination "attack" rate; set to 0 to turn off pollination
h_p <- 0.65     # pollination handling time, < 1 (max pollination benefit = 1/h_p)

```
Now increase `p` in increments of 0.001 or 0.002 (really, it is super sensitive!).
What happens to the qualitative behavior of the system as you increase `p`.

P3. Compared to the model with seed predation only (no pollination), who is "helped" by
the addition of the mutualism? Do plant populations increase? Do herbivore populations
increase? Both? This is a hard question to answer when the populations are cycling
frequently and dramatically. But try a run with these parameters:
```
### set pollination parameters
p <- 0.01      # pollination "attack" rate; set to 0 to turn off pollination
h_p <- 0.95     # pollination handling time, < 1 (max pollination benefit = 1/h_p)
```
The low value of `p` means the benefits of pollination increase slowly and the high
value of `h_p` means that the maximum benefit of herbivory is low. So we are adding
 a very weak mutualism. The populations still cycle, but I think you can compare 
plant and herbivore abundances to the no mutualism case. Who is benefitting more from
the mutualism? Is this what you would expect? Why or why not?

P4. Follow up to problem 3: Do you think the outcome would be different if the pollination
service came from a third species, not the seed predator? Imagine a generalist pollinator
whose population is regulated by some other plant species, or resource, that is not included in our model.
Assume the abundance of the generalist pollinator is relatively constant, but its effect
on effective fecundity is similar to what we have in our model. Would you still expect
rapid cycling? How would the abundances of our focal plant and seed predator be affected?



