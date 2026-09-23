---
title: "Problem set 7: Herbivory or predation"
output: html_document
date: "2026-09-23"
---

## Purpose

The goal of this problem set is to model and explore interactions between an herbivore, or 
predator, and a plant population. 

## Getting started

Download the script `07_seed_predation.R` from the course website, save it to your working directory, and run the code. 
The population growth function should is a lot longer than the last model we built, which was for competition
between two plants species. That one was easy to write because we had one equation that worked for both species.
To add an herbivore, we need to add a new equation.

The first question I had to answre when building this model was, where in the plant life cycle is herbivory
occurring? An herbivore could attack seeds in the seed bank, could eat plants before they produce seeds,
or could attack newly produced seeds before they are incorporated in the seedbank. Or some combination of 
all of these! I decided to model a seed predator who attacks new seeds: think of weevils eating thistle seeds 
before they disperse, or ants harvesting seeds on the ground before they are incorporated in the seed bank. My
model assumes that once seeds make it into the seedbank, they are safe from predation. 

Here are the equations for the model. To make it easier to write and read, let's first define two quantities. 
$P_t$, the number of newly *P*roduced seeds at time $t$, is:
$$P_t = \frac{f g  N_t} {1 + \alpha g N_t}$$
where $g$ is germination rate, $f$ is fecundity and $\alpha$ is density dependence.

$C_t$, the number of seeds consumed by the predator, is:
$$C_t = \frac{a B_t H_t} {1 + a h B_t}$$
where $H_t$ is the seed predator population (herbivores), $a$ is the herbivore attack rate, and $h$ is the herbivore
handling time. This consumption function is a "type II" functional response: it saturates when the number of seeds 
grows large relative to the number of herbivores. 

Now we can write the equation for the plant population:
$$N_{t+1} = s(1-g)N_t + P_t - C_t$$
where $s$ is seedbank survival, and for the herbivore population:
$$H_{t+1} = s_H H_t + b C_t$$
where $s_H$ is herbivore survival and $b$ converts consumed seeds into new herbivores.

Before answering the questions below, make sure you can relate these equations to particular
lines of code in the function I wrote (lines 11-31 in the script). I may call on people to 
explain each link.




## Problems

P1. We will start with parameters that give a stable equilibrium for the plant and the seed predator
in a constant environment:

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
```
I've found that this equilibrium is not very robust: small changes in parameters can lead to either 
extinction of the seed predator or a stable limit cycle. What happens if you increase the herbivore survival rate, `s_H`,
to 0.45? (Paste the resulting figure into your answer sheet.) How do you explain this dynamic? What happens
if you decrease `s_H`to 0.35? How do you explain this result?

P2. Repeat the previous analysis for the other three herbivore parameters: `a, h, b`. Beginning with
the parameter values shown above, increase or decrease the values of each parameter in small increments (0.01).
What value of each parameter leads to a stable limit cycle? What value leads to herbivore exclusion? 
(Or maybe something else happens? I haven't played with all of these parameters.) 

P3. Now repeat the same analysis for three of the plant parameters: `fec_mu, g, alpha`. Report your results as for Problem 2. 
Based on these results, can you draw any general, qualitative conclusions about the conditions under which herbivore
extinction, stable (positive) equilibrium, and stable limit cycles occur?

P4. Choose parameter values that result in a stable limit cycle but now add environmental stochasticity (set
`fec_sigma > 0)`. Does a little environmental stochasticity change the qualitative outcome? What about a lot of 
environmental stochasticity?

P5. Here is the hard one: alter the model so that the seed predator can attack all seeds,
not just the recently produced seeds. Does this modification change the qualitative dynamics, 
or do you still get either herbivore extinction, stable equilibrium, or a stable limit cycle?
(Hint, it might take some trial and error, messy algebra, or AI help to find parameters
that give a stable equilibrium. Let me know how you find those parameters.) Please upload your modified script
along with your answer.