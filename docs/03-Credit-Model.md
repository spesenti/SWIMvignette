
# Simulation study {#Sec:CreditModel}

## A credit risk portfolio 



The credit model in this section is a conditionally binomial loan portfolio model including systematic and specific portfolio risk. We refer to the Appendix \@ref(AppendixCM) for details and the generation of the simulated data. Of interest is the total aggregate portfolio loss $L = L_1 + L_2 + L_3$, where $L_1, L_2, L_3$ are homogeneous subportfolios on  comparable scale (say, thousands of \$). The data set contains 100,000 simulations of the portfolio $L$, the sub-portfolios $L_1, L_2, L_3$ as well as the default probability of each subportfolio $H_1, H_2, H_3$. These (conditional) default probabilities represent the sytematic risk *within* each subportfolio, and their dependence structure allows to introduce a systematic risk effect *between* the subportfolios. A snippet of the data set looks as follows:


```
##         L L1    L2  L3       H1      H2     H3
## [1,]  692  0 346.9 345 1.24e-04 0.00780 0.0294
## [2,] 1006 60 515.6 430 1.16e-03 0.01085 0.0316
## [3,] 1661  0 806.2 855 5.24e-04 0.01490 0.0662
## [4,] 1708  0 937.5 770 2.58e-04 0.02063 0.0646
## [5,]  807  0  46.9 760 8.06e-05 0.00128 0.0632
## [6,] 1159 20 393.8 745 2.73e-04 0.00934 0.0721
```

## Stressing the aggregate portfolio loss 

In this section, following a reverse sensitivity approach, we study the effect of stresses on (the tail of) the aggregate portfolio on the three sub-portfolios in order to investigate their importance.

First, we impose a $20\%$ increase on the $VaR_{0.9}$ of the loss of the aggregate portfolio.


```r
stress.credit <- stress(type = "VaR", x = credit_data, k = "L", 
                        alpha = 0.9, q_ratio = 1.2)
```

```
## Stressed VaR specified was 2174.25 , stressed VaR achieved is 2173.75
```

Note that, since we work with a simulated set of losses, the exact required quantile may not be achievable. By default, `stress_VaR` will target the largest quantile in the data set smaller or equal than the required VaR.

The imposed change in VaR determines an increase in ES.


++++WOULD IT BE POSSIBLE TO EXTEND ES_stressed (AND quantile_stressed AS WELL) TO CALCULATE THESE QUANTITIES ON BASELINE OBJECTS (VECTORS, MATRICES OR DATA FRAMES)?+++
--- Silvana: ES_Stressed and VaR_stressed have a parameter base = TURE which allows to calculate the VaR and ES under the baseline model---

We then consider, additionally to the $20\%$ increase in $\text{VaR}_{0.9}$, a further increase in $\text{ES}_{0.9}$ of the aggregate portfolio $L$. Note that both VaR and ES need be stressed at the same level `alpha = 0.9`. Instead of providing the percentage increases in the VaR and ES through the arguments `q_ratio` and `s_ratio`, the actual stressed values of VaR and ES can be set using the arguments `q` and `s`, respectively. 



```r
stress.credit <- stress(type = "VaR ES", x = stress.credit, k = "L", alpha = 0.9, q_ratio = 1.2, s = 3500)
```

```
## Stressed VaR specified was 2174.25 , stressed VaR achieved is 2173.75
```

When applying the `stress` function, or one of its alternative versions, to a SWIM object, the result will be a new SWIM object where the new stress has been ''appended'' to the previous one. This is convenient when large data sets are involved, as the `stress` function returns an object  containing the original simulated data and the scenario weights. 

## Analysing the stressed model

The `summary` function provides a statistical summary of the stressed models. Choosing  `base = TRUE`, compares the stressed models with the the simulated data - the baseline model.


```r
summary(stress.credit, base = TRUE)
```

```
## $base
##                    L    L1     L2      L3       H1      H2     H3
## mean        1102.914 19.96 454.04 628.912 0.000401 0.00968 0.0503
## sd           526.538 28.19 310.99 319.715 0.000400 0.00649 0.0252
## skewness       0.942  2.10   1.31   0.945 1.969539 1.30834 0.9501
## ex kurtosis    1.326  6.21   2.52   1.256 5.615908 2.49792 1.2708
## 1st Qu.      718.750  0.00 225.00 395.000 0.000115 0.00490 0.0318
## Median      1020.625  0.00 384.38 580.000 0.000279 0.00829 0.0464
## 3rd Qu.     1398.750 20.00 609.38 810.000 0.000555 0.01296 0.0643
## 
## $`stress 1`
##                   L    L1     L2     L3       H1      H2     H3
## mean        1193.39 20.83 501.10 671.46 0.000417 0.01066 0.0536
## sd           623.48 29.09 363.57 361.21 0.000415 0.00756 0.0285
## skewness       1.01  2.09   1.36   1.02 1.973337 1.35075 1.0283
## ex kurtosis    0.94  6.14   2.23   1.22 5.630153 2.23353 1.2382
## 1st Qu.      739.38  0.00 234.38 405.00 0.000120 0.00512 0.0328
## Median      1065.62 20.00 412.50 605.00 0.000290 0.00878 0.0483
## 3rd Qu.     1505.62 40.00 675.00 865.00 0.000578 0.01422 0.0688
## 
## $`stress 2`
##                   L    L1     L2     L3       H1      H2     H3
## mean        1240.94 21.30 528.73 690.91 0.000427 0.01122 0.0552
## sd           750.61 29.90 435.15 405.26 0.000433 0.00901 0.0319
## skewness       1.64  2.14   1.92   1.38 2.060844 1.91260 1.3718
## ex kurtosis    3.20  6.61   4.68   2.44 6.144161 4.80920 2.3599
## 1st Qu.      739.38  0.00 234.38 405.00 0.000121 0.00512 0.0328
## Median      1065.62 20.00 412.50 605.00 0.000294 0.00879 0.0484
## 3rd Qu.     1505.62 40.00 675.00 870.00 0.000587 0.01432 0.0694
```

The information on individual stresses can be recovered through the `get_specs` function and the actual scenario weights using `get_weights`.


```r
get_specs(stress.credit)
```

```
##            type k alpha    q    s
## stress 1    VaR L   0.9 2174 <NA>
## stress 2 VaR ES L   0.9    1 3500
```

```r
w <- get_weights(stress.credit)
```

<img src="03-Credit-Model_files/figure-html/plotting-stresses-1.png" width="50%" /><img src="03-Credit-Model_files/figure-html/plotting-stresses-2.png" width="50%" />

++++SHOULD THE CODE BE VISIBLE? A FUTURE IMPROVEMENT FOR THE PACKAGE COULD BE ADDING A FUNCTION TO PLOT THE SCENARIO WEIGHTS+++
---Silvana: that's a good suggestions regarding including a plot_weights function in a future version of the package. I'm open for including the code or not.---

## Visual comparison
The change in the distributions of the portfolio and subportfolios from the baseline to the stressed models can be visualised through the functions `plot_hist` and `plot_cdf`. The following figure displays the histogram of the aggregate portfolio loss under the baseline and the two stressed models.


```r
plot_hist(object = stress.credit, xCol = "L", base = TRUE)
```

<img src="03-Credit-Model_files/figure-html/CM-histL-1.png" width="672" />

The arguments `xCol` and `wCol` specify the columns of the data to be plotted and the scenario weights to be used, respectively. The impact on the subportfolios of stressing the aggregate loss can thus be investigated. The graphical functions `plot_hist` and `plot_cdf` return objects compatible with the package **ggplot2**. Therefore, we can for instance compare the histograms of the portfolio losses via the function `grid.arrange` (of the package **gridExtra**) and understand how each tranche reacts to the different stresses.


```r
pL2.stress1 <- plot_hist(object = stress.credit, xCol = 3, wCol = 1, base = TRUE)
pL2.stress2 <- plot_hist(object = stress.credit, xCol = 3, wCol = 2, base = TRUE)
grid.arrange(pL2.stress1, pL2.stress2, ncol = 1, nrow = 2)
```

<img src="03-Credit-Model_files/figure-html/CM-plot1-1.png" width="672" />

The tail of the subportfolios $L_2$ is more affected by the second stress. 

## Sensitivity measures

The impact of the stressed models on the model components can be quantified through sensitivity measures. The function `sensitivity` includes *Kolmogorov*, the *Wasserstein* distance and the sensitivity measure *Gamma*, which can be specified through the optional argument `type`. We refer to Section \@ref(Sec:analysis) for the definitions of these measures. The Kolmogorov and the Wasserstein distance are useful to compare different stressed models, whereas the sensitivity measure Gamma ranks model components for one stressed model.


```r
sensitivity(object = stress.credit, xCol = c(2 : 7), wCol = 1, type = "Gamma")
```

```
##     stress  type   L1    L2    L3    H1    H2    H3
## 1 stress 1 Gamma 0.15 0.819 0.772 0.196 0.811 0.767
```

Using the `sensitivity` function we can analyse whether the first (column 2) and third (column 4) tranches considered as a whole are able to exceed the riskiness of the second. This can be accomplished specifying, through the option `f`, a list of functions applicable to the columns `k` of the dataset. Through the argument `xCol = NULL` only the transformed data is considered. The sensitivity measure of a function of the columns is particularly useful when high dimensional models are considered and a resuming statistics is needed in order to compare blocks of model components against each others.


```r
sensitivity(object = stress.credit, type = "Gamma", f = list(sum), 
            k = list(c(2, 4)), wCol = 1, xCol = NULL)
```

```
##     stress  type        f1
## 1 stress 1 Gamma 0.7830995
```

++++CAN WE ALLOW FOR "f" and "k" TO BE A FUNCTION AND A VECTOR, RESPECTIVELY, AS IN stress_moments? RIGHT NOW WE NEED TO USE "list(SUM)"++++ --- Silvana: the sensitivity function has parameters f and k, which are the same as the one specified in stress_moments. The problem is that if k has length >1, both f and k must be a list. We could change it to, if f is a function and k a vector then the same function is applied to all k's. ---

The `importance_rank` function, having the same structure as the `sensitivity` function, return the ranks of the sensitivity measures. This function is particularly useful when there are several risk factors involved.


```r
importance_rank(object = stress.credit, xCol = c(2 : 7), wCol = 1, type = "Gamma")
```

```
##     stress  type L1 L2 L3 H1 H2 H3
## 1 stress 1 Gamma  6  1  3  5  2  4
```

```r
importance_rank(object = stress.credit, xCol = c(2 : 7), wCol = 2, type = "Gamma")
```

```
##     stress  type L1 L2 L3 H1 H2 H3
## 1 stress 2 Gamma  6  1  3  5  2  4
```

It transpires that subportfolios $2$ and $3$ are, in this order, most responsible for the stress in the global loss. Also, most of the sensitivity seems to be imputable to the systematic risk components $H_2$ and $H_3$. To confirm this, another stress resulting in the same $\text{VaR}_{90\%}(L)$, but controlling for the distribution of $H_2$, can be imposed using the function `stress_moment`. More precisely, we fix $E[H_2]$ and the $75\%$ quantile of $H_2$ as in the base model.

+++THE APPENDING OF STRESS_MOMENT IS STILL NOT WORKING PROPERLY.+++


```r
VaR.L <- quantile(x = credit_data[, "L"], prob = 0.9, type = 1) # VaR of L
q.H2 <- quantile(x = credit_data[, "H2"], prob = 0.75, type = 1) # quantile of H2
k.stressH2 = c(1, 6, 6) # columns to be stressed (L, H2, H2)
# functions to be applied to columns
f.stressH2 <- list(function(x)1 * (x <= VaR.L * 1.2), # indicator function for L
                 function(x)x, # mean of H2
                 function(x)1 * (x <= q.H2)) # indicator function for H2
# new values for the VaR of L, mean of H2, quantile of H2
m.stressH2 = c(0.9, mean(credit_data[, "H2"]), 0.75) 
stress.credit.H2 <- stress_moment(x = credit_data, f = f.stressH2, k = k.stressH2, m = m.stressH2)
```

In this case we can use the `summary` function to verify whether we are actually controlling the distribution of $H_2$. 

+++IS IT COMPLEX TO ADD TO THE SUMMARY FUNCTION THE POSSIBILITY OF SPECIFYING WHICH STRESS TO CONSIDER? IN THIS CASE FOR EXAMPLE SOMEONE COULD BE INTERESTED ONLY ON THE NEW STRESS AND THE BASELINE+++
---Silvana: you can do this with the parameter wCol, which can be a vector, say you want to have stresses 1 and 3 and the baseline, choose wCol = c(1,3) and base = TRUE---


```r
summary(stress.credit.H2, base = TRUE)
```

```
## $base
##                    L    L1     L2      L3       H1      H2     H3
## mean        1102.914 19.96 454.04 628.912 0.000401 0.00968 0.0503
## sd           526.538 28.19 310.99 319.715 0.000400 0.00649 0.0252
## skewness       0.942  2.10   1.31   0.945 1.969539 1.30834 0.9501
## ex kurtosis    1.326  6.21   2.52   1.256 5.615908 2.49792 1.2708
## 1st Qu.      718.750  0.00 225.00 395.000 0.000115 0.00490 0.0318
## Median      1020.625  0.00 384.38 580.000 0.000279 0.00829 0.0464
## 3rd Qu.     1398.750 20.00 609.38 810.000 0.000555 0.01296 0.0643
## 
## $`stress 1`
##                    L    L1    L2     L3       H1      H2     H3
## mean        1140.535 20.06 456.0 664.47 0.000400 0.00968 0.0530
## sd           616.930 28.48 340.9 371.14 0.000405 0.00706 0.0292
## skewness       1.059  2.13   1.4   1.09 2.013196 1.39135 1.0949
## ex kurtosis    0.895  6.40   2.3   1.31 5.899634 2.26506 1.3371
## 1st Qu.      695.000  0.00 206.2 395.00 0.000113 0.00453 0.0318
## Median      1001.875  0.00 365.6 590.00 0.000276 0.00786 0.0472
## 3rd Qu.     1430.625 20.00 609.4 855.00 0.000554 0.01296 0.0679
```

```r
sensitivity(object = stress.credit.H2, xCol = c(2:7), type = "Gamma")
```

```
##     stress  type     L1     L2    L3        H1       H2    H3
## 1 stress 1 Gamma 0.0102 0.0203 0.366 -0.000521 1.17e-08 0.359
```

The sensitivity measure confirms that the systematic risk prevails on binomial (event) risk.

The following example is another case involving the stress of multiple model components. Namely, we impose a stress requiring a 20\% increase in the quantile of both the losses in subportfolios 2 and 3. In particular, we can examine two different situations: in the first the minimization problem is subject to two separate constraints while in the second it is subject to a joint one. 


```r
VaR.L2 <- quantile(x = credit_data[, "L2"], prob = 0.9, type = 1) # VaR of L2
VaR.L3 <- quantile(x = credit_data[, "L3"], prob = 0.9, type = 1) # VaR of L3
# functions to be applied to columns
 
# two constraints
f.stress <- list(function(x)1 * (x <= VaR.L2 * 1.2), function(x)1 * (x <= VaR.L3 * 1.2)) 
# single joint constraint
f.stress.joint <- list(function(x)1 * (x[1] <= VaR.L2 * 1.2) * (x[2] <= VaR.L3 * 1.2)) 
stress.credit.L2L3 <- stress_moment(x = credit_data, f = f.stress, k = c(3, 4), m = c(0.9, 0.9))
stress.credit.L2L3.joint <- stress_moment(x = credit_data, f = f.stress.joint, 
                                          k = list(c(3, 4)), m = 0.9)
summary(stress.credit.L2L3)
```

```
## $`stress 1`
##                    L    L1     L2      L3       H1      H2     H3
## mean        1211.156 20.66 504.20 686.297 0.000416 0.01072 0.0548
## sd           627.086 28.82 361.91 375.153 0.000413 0.00753 0.0295
## skewness       0.995  2.07   1.30   0.992 1.958843 1.29316 0.9966
## ex kurtosis    1.049  6.07   1.95   0.894 5.515336 1.96199 0.9214
## 1st Qu.      749.375  0.00 234.38 410.000 0.000120 0.00518 0.0331
## Median      1087.500 20.00 412.50 610.000 0.000290 0.00885 0.0489
## 3rd Qu.     1556.250 40.00 675.00 880.000 0.000576 0.01430 0.0701
```

```r
summary(stress.credit.L2L3.joint)
```

```
## $`stress 1`
##                    L    L1     L2      L3       H1      H2     H3
## mean        1118.966 20.09 462.40 636.474 0.000403 0.00986 0.0509
## sd           541.029 28.31 320.25 327.183 0.000402 0.00668 0.0258
## skewness       0.946  2.09   1.32   0.965 1.967341 1.31574 0.9689
## ex kurtosis    1.244  6.20   2.43   1.246 5.597467 2.42008 1.2610
## 1st Qu.      723.125  0.00 225.00 395.000 0.000116 0.00494 0.0320
## Median      1031.250 20.00 393.75 585.000 0.000281 0.00838 0.0467
## 3rd Qu.     1421.875 40.00 618.75 815.000 0.000558 0.01317 0.0651
```

The stress obtained with the joint constraint on $L_2$ and $L_3$ is weaker.
