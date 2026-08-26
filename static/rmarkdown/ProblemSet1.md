---
title: "Problem set 1: Density-independent growth"
output: html_document
date: "2026-07-16"
---

## Purpose

This problem set explores density-independent population growth in a temporally variable environment. The model does not represent the environment explicitly. Instead, we will draw fecundity (`lambda`) from a distribution. High values of `lambda` reflect favorable environmental conditions, low values reflect unfavorable conditions. The mean of this distribution, `lambda_mu`, determines average fecundity, and the standard deviation, `lambda_sgima`, determines the variation around the mean. More variation implies a more variable environment. 

# Problems

1. Download the script `01_DI_growth.R` from the course website, save it to your working directory, and run the code:

    ```r
    source("01_DI_growth.R")
    ```

    You can plot the population time series on arithmetic scale:

    ```r
    plot(Nvec, type = "l", xlab = "Time", ylab = "Population size")
    ```

    or on log scale:

    ```r
    plot(log(Nvec), type = "l", xlab = "Time", ylab = "(log) Population size")
    ```

    You should understand each line of code and be prepared to explain it to me. It is particularly important to understand functions and loops. Re-run the script a few times with different values of the parameters.

2. One way to calculate the long-term, average population growth rate is to fit a regression and calculate the slope of log(Population size) over time. What is the slope of that relationship when `lambda_mu = 1.2` and `lambda_sigma = 0.2`?

3. A more direct way to calculate the long-term, average population growth rate, that avoids the estimation error of regression, is to calculate the mean of the annual lambda values. But there are two ways you can do this:

    ```r
    mean(log(lambda))   # geometric mean (on log scale)
    log(mean(lambda))   # arithmetic mean (on log scale)
    ```

    Explain which of these methods is correct and why. Hint: try this with `lambda_sigma = 0`.