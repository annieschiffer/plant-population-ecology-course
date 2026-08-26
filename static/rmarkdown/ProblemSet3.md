---
title: "Problem set 3: Stage-structured population growth"
output: html_document
date: "2026-08-7"
---


## Purpose

This problem set re-writes the annual plant model from Week 2 as a matrix population model representing two life stage: seeds and plants. Doing this makes it possible to turn our model of an annual plant with a seed abnk into a model of a perennial plant with a seedbank.

## Getting started

Download the script `03_stagestructured_growth.R` from the course website, save it to your working directory, and run the code:
```r
03_stagestructured_growth.R")
```
Lines 7 - 51 are copied from last week's code. Lines 53 - 78 contain the new part: rewriting last week's model as a matrix population model. You should understand lines 60-64 and be prepared to explain them to me. I also expect you to understand and be able to explalin line 74:
```r
Nout[i,] <- A%*%Nout[i-1,]
```

## Problems

P1. When I started writing this code, I thought the matrix version would perfectly match the annual plant version 
from last week. I was wrong! If the models were the same, then they would have identical long-term population 
growth rates, given identical parameters. But they don't. Compare the output from lines 41-42:
```r
little_r <- mean(log(Nmatrix[2:(nrow(Nmatrix)),1]/Nmatrix[1:(nrow(Nmatrix)-1),1]))
print(paste0("r=",little_r))
```
with the output from lines 84-85: 
```r
r_t <- log(rowSums(Nout)[2:timesteps]) - log(rowSums(Nout)[1:(timesteps-1)])
print(paste0("r=",mean(r_t)))
```
What is the critical biological difference between these models that I did not anticipate? 
Hint: Look at the transition from seeds to plants in the first few time steps (try `head(Nout)`) 
and think about how the seeds column in `Nout` compares to the `surv_seed`s and `new_seeds` columns in `Nmatrix`. 

P2. In the previous question, I showed how you might calculate the long-term average population growth rate 
from the simulated population time series. But for a deterministic matrix population model (no temporal fluctuations), 
you don't need to simulate anything. The long-term population growth rate is simply the dominant eigenvalue of the matrix. You can calculate that with one short line of code (line 88):
```r
growthrate <- eigen(A)$values[1]
print(paste0("r=",log(growthrate)))
```
The second line of code is just the log transformation, to ease comparison with the numerical approach I used on lines 84-85. 
However, as I've written these lines of code, the growth rates are close but not identical. 
Please explain why they are not identical and how you could modify line 84 to make them identical. This is
a technical question about how to compute the average growth rate, not a question about ecology.
Hint: Consider the stage distribution, which is the proportion of the population in each stage if
you ran the model indefinitely. How does the stage distribution change over time (line 92)? When does the population
converge on a stable stage distribution?

P3. Please modify the code to add a third life stage. Instead of seeds and reproductive plants, we will have seeds, 
a vegetative plant stage, and a reproductive plant stage. Your answer to this question will be the block of code 
that implements this three stage model. 
