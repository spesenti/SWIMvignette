---
title: 'SWIM: Scenario Weights for Importance Measurement'
author: Silvana M. Pesenti^[silvana.pesenti@utoronto.ca] ^,2^, Alberto Bettini, Pietro Millossovich^3,4^, Andreas Tsanakas^4^ 
date: ^2^University of Toronto, ^3^DEAMS, University of Trieste Cass Business School, ^4^Cass Business School, City, University of London
bibliography: bibliography.bib
documentclass: article
github-repo: spesenti/SWIMvignette
link-citations: yes
site: bookdown::bookdown_site
biblio-style: apalike
---




# Introduction
## Abstract


The SWIM package is an efficient sensitivity analysis tool for stochastic models developed in @Pesenti2019. It provides a stressed version of a stochastic model, subject to model components (random variables) fulfilling given probabilistic constraints (stresses). Possible constraints include stressing moments, propability intervals and risk measures such as the Value-at-Risk and the Expected Shortfall. Provided with simulated scenarios from a stochastic model, the SWIM package returns scenario weights under which the stochastic model satisfies the stress and minimises the relative entropy with respect to the baseline model. 



## Background
a short literature review



## Concepts of the `SWIM` package



### Installation

The SWIM package can be install from [CRAN](https://CRAN.R-project.org/package=SWIM) :

> 
<https://CRAN.R-project.org/package=SWIM>;


alternatively from [GitHub](https://github.com/spesenti/SWIM) in R studio:


``` r}
install.packages("spesenti/SWIM")
```


## Structure of the vignette

Section \@ref(Sec:Scope) contains the mathematical background and the description of the optimisation that underlies the implementation of the SWIM package. For readers interested in the application and usage of the SWIM package, Section \@ref(Sec:Scope) can serve as a reference, as all implemented `R` functions, including stresses and graphical and analysis tools are described in detail. 




