---
title: "Problem set 4: Sensitivity and elasticity"
output: html_document
date: "2026-08-26"
---


## Purpose

The goal of this problem set is to give you practice, and intuitive understanding, of sensitivity and elasticity analyses. 
We use these perturbation techniques to learn about the influence of different portions of the life cycle on the population growth rate.

## Getting started

Download the script `04_sensitivity&elasticity.R` from the course website, save it to your working directory, and run the code. 
Everything up to line 25 should look familiar--it is a copy of last week's script. The rest is new.


## Problems

P1. I have coded three ways to calculate sensitivities and elasticities. The code chunk starting at line 27 
shows how to do this, for one matrix element, without using any calculus or matrix math. It is a purely 
numerical approach. Please add code to calculate sensitivites and elasticities for the other three 
matrix elements. Your answer will be a matrix of sensitivities and a matrix of elasticities. (This is a 
busy-work question to make sure you understand the code; you should also be prepared to explain each 
line of this code chunk to me in class.)

P2. The code chunk starting on line 62 shows how to do the same thing using calculus and matrix math (eigen 
analysis). The code chunk starting on line 92 shows how to do the same thing using the popbio package (which
relies on the same eigen analysis). Execute those code chunks and save the answers (the matrices). 
You should now have three sensitivity matrices and three elasticity matrices. 
Compare them: which match perfectly and which are different? Can you explain why 
one approach gives you slightly different values? (Hint: play with the value of `delta` on line 44.)

P3. Matrix element [2,2] is the survival (stasis) of reproductive plants. You should see that the sensitivity value
for this matrix element is positive, but the elasticity is zero. Please explain why that answer makes sense. I am
hoping this question helps you understand the difference between sensitivity and elasticity.

P4. How does increasing `g`, the germination fraction, change the sensitivities and elasticities? Please 
provide a biological explanation for this quantitative difference. 

P5. Last week you extended my 2-stage model to a 3-stage model (seeds, vegetative plants, and
reproductive plants). Calculate the sensitivities and elasticities of your 3-stage model using 
the method of your choice and show me the results. Which matrix element has the highest sensitivity? 
Highest elasticity? What do these results tell you about the life history strategy of your 
hypothetical plant species?



