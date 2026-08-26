---
title: "Problem set 2: Seedbanks and bet hedging"
output: html_document
date: "2026-07-16"
---


## Purpose

This problem set focuses on modeling a population with a seedbank and exploring the concept of bet-hedging in a temporally variable environment. 

## Getting started

Download the script `02_DI_seedbank_growth.R` from the course website, save it to your working directory, and run the code:
```r
source("02_DI_seedbank_growth.R")
```

Re-run the script a few times with different values of the parameters. You should understand each line of code and be prepared to explain it to me. In particular, you should be able to relate each line in the function I create, DI_SB_growth, with the terms in the following equation:
    
$$N_{t+1} = s(g-1)N_t + gN_t\lambda_t$$

## Problems

P1. Let's compare two life history strategies, a non-seedbanking annual and a seedbanking annual. 
For the non-seedbanker, set
```r
g <- 0.9              # germination rate
s <- 0.2              # survival of ungerminated seeds
```
This species will germinate most of its seeds every year and the seeds that don't germinate won't persist long in the seedbank. 
For the seedbanker, set
```r
g <- 0.5              # germination rate
s <- 0.8              # survival of ungerminated seeds
```
Which life history has a higher long-term average population growth rate in an environment with little 
temporal variation (set `lambda_mu <- 2` and `lambda_sigma <- 0.1`?  Which life history has a higher long-term 
average population growth rate in a variable environment (keep `lambda_mu <- 2` but change `lambda_sigma <- 1.5`)?  
(You will need to repeat the simulation 5 or 10 times for each parameter combination to get a good answer.) 
Can you explain why you get this result? Hint: consider the standard deviation of the annual growth rates, `lambda_sigma`.

P2. 'Bet-hedging' is the idea that, in a variable environment, evolutionary selection can act on the variability 
of fitness (`lambda_sigma` in our model) in addition to acting on mean fitness. 
Please use the model to demonstrate this principle by comparing the long-term average growth rate for two 
parameter sets. For both runs, set 
```r
g <- 0.5              # germination rate
s <- 0.8              # survival of ungerminated seeds
```
but choose different values for `lambda_mu` and `lambda_sigma`. Explain why your results show that 
"evolutionary selection can act on the variability of fitness in addition to acting on mean fitness." 
In addition, please restate the idea of bet hedging without the jargon I used in the previous sentence. 
How would you explain it someone who never took any college biology courses?

