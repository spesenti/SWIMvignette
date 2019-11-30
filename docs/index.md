---
title: Scenario Weights for Importance Measurement (SWIM) -- an `R` package for sensitivity
  analysis
author: Silvana M. Pesenti^[silvana.pesenti@utoronto.ca] ^,2^, Alberto Bettini^3^, Pietro
  Millossovich^4,5^, Andreas Tsanakas^5^
date: ^2^University of Toronto, ^3^ Assicurazioni Generali S.p.A, ^4^DEAMS, University of Trieste,
  ^5^Cass Business School, City, University of London
bibliography: bibliography.bib
documentclass: article
github-repo: spesenti/SWIMvignette
link-citations: true
site: bookdown::bookdown_site
biblio-style: "apalike"
abstract: 'The SWIM package implements a flexible sensitivity analysis framework,
  based primarily on results and tools developed by @Pesenti2019. SWIM provides a
  stressed version of a stochastic model, subject to model components (random variables)
  fulfilling given probabilistic constraints (stresses). Possible stresses can be
  on  moments, probabilities of given events, and risk measures such as Value-at-Risk
  and Expected Shortfall. SWIM oparates upon a single set of simulated scenarios from
  a stochastic model, returning scenario weights which encode the required stress
  and allow monitoring the impact of the stress on all model components. The scenario
  weights are calculated to minimise the relative entropy with respect to the baseline
  model, subject to the stress applied. SWIM does not require additional evaluations
  of the simulation model or explicit knowledge of its underlying statistical and 
  functional relations; hence it is suitable for the analysis of black box models.
  The capabilities of SWIM are demonstrated through a case study of a credit portfolio
  model. '
---






# Introduction

## Background and contribution

Complex quantitative models are used extensively in actuarial and financial risk management applications, as well as in wider fields such as environmental risk modelling [@Tsanakas2016b; @Borgonovo2016; @Pesenti2019]. The complexity of such models (high dimensionality of inputs; non-linear relationships)  motivates the performance of sensitivity analyses, with the aim of providing insight into the ways that model inputs interact and impact upon the model output. 

The task of ranking the importance of different model inputs leads to the use of sensitivity measures, which assign a score to each model input.
When model inputs are subject to uncertainty, the sensitivity measures used are often *global*, considering the full space of (randomly generated) multivariate scenarios, which represent possible configurations of the model input vector. A rich literature on global sensitivity analysis methods exists, with variance decomposition methods being particularly prominent; see @Saltelli2008 and @Borgonovo2016 for wide-ranging reviews.  The `R` package sensitivity [@Rsensitivity] implements a wide range of sensitivity analysis approaches and measures.

We introduce an alternative approach to sensitivity analysis called *Scenario Weights for Importance Measurement* (SWIM) and present the `R` package implementing it. The aim of this paper is to provide an accessible introduction to the concepts underlying SWIM and a vignette demonstrating how the package is used.

SWIM quantifies how distorting a particular model component (which could be a model input, output, or an intermediate quantity) impacts all other model components. The SWIM approach can be summarised as follows:

* The starting point is a table of simulated scenarios, each column containing realisations of a different model component. This table forms the *baseline model*.

* A *stress* is defined as a particular modification of a model component (or group of components). This could relate to a change in moments, probabilities of events of interest, or risk measures, such as Value-at-Risk or Expected Shortfall (e.g. @Mcneil2015B).

* A set of *scenario weights* are calculated, acting upon the simulated scenarios and thus modifying the relative probabilities of scenarios occurring. Scenario weights are derived such that the defined stress on model components is fulfilled, while keeping the distortion to the baseline model to a minimum, as quantified by the Kullback-Leibler divergence (relative entropy).

* Given the calculated scenario weights, the impact of the stress on the distributions of all model components is worked out and sensitivity measures, useful for ranking model components, are evaluated. 

Two key benefits of SWIM are that it provides a sensitivity analysis framework that is economical both computationally and in terms of the information needed to perform the analysis. Specifically, sensitivity analysis is performed using only one set of simulated scenarios. No further simulations are needed, thus eliminating the need for potentially costly evaluations of the model. Furthermore, the user of SWIM needs to know neither the explicit form of the joint distribution of model components nor the exact form of functional relations between them. Hence, SWIM is appropriate for the analysis of 'black box' models, thus having a wide scope of applications. 

The SWIM approach is largely based on @Pesenti2019 and uses theoretical results on risk measures and sensitivity measures developed in that paper. An early sensitivity analysis approach based on scenario weighting was proposed by @Beckman1987. The Kullback-Leibler divergence has been used extensively in the financial risk management literature -- papers that are conceptually close to SWIM include @Weber2007; @Breuer2013; and @Cambou2017.





## Installation

The SWIM package can be installed from [CRAN](https://CRAN.R-project.org/package=SWIM) or through [GitHub](https://github.com/spesenti/SWIM): 

``` r}
# direlty from CRAN
install.packages("SWIM")

# the development version from GitHub 
devtools::install_github("spesenti/SWIM")
```


## Structure of the paper

Section \@ref(Sec:Intro) provides an introduction to SWIM, illustrating key concepts and basic functionalities of the package on a simple example. Section 
\@ref(Sec:Scope) contains technical background on the optimisations that underly SWIM package implementation. Furthermore, a brief reference guide is given, providing an overview of implemented `R` functions, objects, and graphical/analysis tools.  Finally, in Section \@ref(Sec:CreditModel) a more detailed case study is given, focusing on sensitivity analysis of a credit risk portfolio. Through this case study, more advanced capabilities of SWIM are demonstrated.


