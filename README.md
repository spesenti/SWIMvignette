
# Vignette for the `R` package SWIM -- Scenario Weights for Importance Measurement
 
The [SWIM](https://CRAN.R-project.org/package=SWIM) package provides a
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
  model. 