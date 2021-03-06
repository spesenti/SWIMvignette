
# Scope of the SWIM package {#Sec:Scope}


## Stressing a model {#Rfunctions}

While the SWIM package is designed to work on (Monte Carlo) realisations of model components, the scenario weights are derived in a general probabilistic framework. A baseline probability (representing the equiprobable Monte Carlo simulations) can be described by a probability measure $P$, and a stressed model by a different probability measures $P^W$. The stressed model is then uniquely described by the change of measure from the baseline to the stressed model, which can be seen as the scenario weights $W= \frac{dP^W}{dP}$ (this random variable is also known as the Radon-Nikodym derivative of $P^W$ with respect to $P$). The stressed model, under which model components fulfil specific stresses, is chosen such that the distortion to the baseline model is as small as possible when measured by the Kullback-Leibler divergence (or relative entropy). Mathematically, a stressed model is the solutions to
\begin{equation} 
\min_{ W } ~E(W \log (W)), \quad
\text{subject to constraints under } P^W.
(\#eq:optimisation)
\end{equation}
Subsequently, we denote by a superscript $W$ the quantity of interest under the stressed model, such as $F^W, ~ E^W$ for the probability distribution and expectation under the stressed model, respectively. We refer to @Pesenti2019 and references therein for further mathematical details and derivations of solutions to \@ref(eq:optimisation).


The subsequent table is a collection of all implemented types of stresses in the `SWIM` package. The precise constraints of \@ref(eq:optimisation) are explained below.

| R function         | Stress                                | `type`  |  Reference  
| :------------------| :------------------------------------ |:--------|:------------------ 
| `stress()`         | wrapper for the `stress_type` functions   |         | Section \@ref(Rstress)
| `stress_user()`    | user defined scenario weights         |`user`   |
| `stress_prob()`    | disjoint intervals                    |`prob`   | Equation \@ref(eq:optimisationprob)
| `stress_mean()`    | means                                 |`mean`   | Equation \@ref(eq:optimisationmoment)
| `stress_mean_sd()` | means and standard deviations         |`mean sd`| Equation \@ref(eq:optimisationmoment)
| `stress_moment()`  | moments (of functions)                |`moment` | Equation \@ref(eq:optimisationmoment)
| `stress_VaR()`     | VaR risk measure (quantile)          |`VaR`    | Equation \@ref(eq:optimisationVaR)
| `stress_VaR_ES()`  | VaR and ES risk measures              |`VaR ES` | Equation \@ref(eq:optimisationVaRES)




### The `stress` function and the `SWIM` object {#Rstress}
The `stress()` function is a wrapper for the `stress_type` functions, where `stress(type = "type", )` and `stress_type()` are equivalent. The `stress()` function solves optimisation \@ref(eq:optimisation) for constraints specified through `type` and returns a `SWIM` object containing a list including:

| | |
| :---           | :--- |       
| `x`            | realisations of the model  |
| `new_weights`  | scenario weights |
| `type`         | type of stress |
| `specs`        | details about the stress |

The data frame containing the realisations of the baseline model, `x` in the above table, can be extracted from a `SWIM` object using `get_data()`. Similarly, `get_weights()` and `get_weightsfun()` provide the scenario weights, respectively the functions, that when applied to `x` generate the scenario weights. The specification of the applied stress can be obtained using `get_specs()`.

### Stressing disjoint probability intervals 

Stressing disjoint probability intervals allows to define stresses by altering regions or events of a model component. The scenario weights are calculated via `stress_prob()`, or equivalently `stress(type = "prob", )`, and the stressed probability intervals are specified through the `lower` and `upper` endpoints of the intervals. Specifically, 


> for disjoint intervals $B_1, \ldots, B_I$ with $P(X \in B_i) >0$ for all $i = 1, \ldots, I$, and $\alpha_1, \ldots, \alpha_I > 0$ such that $\alpha_1 + \ldots  + \alpha_I < 1$, `stress_prob()` solves \@ref(eq:optimisation) with the constraints
\begin{equation} 
P^W(X \in B_i) = \alpha_i, ~i = 1, \ldots, I. (\#eq:optimisationprob)
\end{equation}


### Stressing moments 

The functions `stress_mean()`, `stress_mean_sd()` and `stress_moment()` provide stressed models with moment constraints. The function `stress_mean()` returns a stressed model that fulfils constraints on the first moment of model components. Specifically, 

> For $m_i, ~ i \in J$, where $J$ is a subset of $\{1, \ldots, d\}$, `stress_mean()` solves \@ref(eq:optimisation) with the constraints
\begin{equation} 
E^W(X_i) = m_i, ~i \in J. (\#eq:optimisationmoment)
\end{equation}
The $m_i, ~i \in J$, are specified in the `stress_mean()` function through the argument `new_means`. The `stress_mean_sd()` allows to stress simultaneously the mean and the standard deviation of model components. Specifically,   

> For $m_i, s_i ~ i \in J$, where $J$ is a subset of $\{1, \ldots, d\}$, `stress_mean_sd()` solves \@ref(eq:optimisation) with the constraints
\begin{equation} 
E^W(X_i) = m_i \text{ and Var}^W(X_i) = s_i^2 , ~i \in J. (\#eq:optimisationmoment)
\end{equation}
The parameters $m_i, s_i, ~ i \in J$, are defined in the `stress_mean_sd()` function by the arguments `new_means`and `new_sd`, respectively. The `stress_mean()` and `stress_mean_sd()` are special cases of the general `stress_moment()` function, which allows for stressed models with constraints on functions of the (joint) moments of model components. Specifically

> For $i = 1, \ldots, I$, $J_i$ subsets of $\{1, \ldots, n\}$, $m_i \in \mathbb{R}$ and functions $f_i \colon \mathbb{R}^{J_i} \to \mathbb{R}$, `stress_moment()` solves \@ref(eq:optimisation) with the constraints
\begin{equation} 
E^W(f_i(X_{J_i}) ) = m_i, ~i = 1, \ldots, I. (\#eq:optimisationmoment)
\end{equation}
Here $X_{J_i}$ is the subvector of model components with indices in $J_i$.
Note that `stress_moment()` not only allows to define constraints on higher moments of model components but also to construct constraints that apply to multiple model components simultaneously. For example, stressing the joint mean of two model components $X_i, X_j$, that is $E^W(X_i X_j) = E^W(f(X_i, X_j))$, for $f(x_i, x_j) = x_i x_j$. ++++JOINT MEAN? NOT SURE++++ The covariance of $X_i$ and $X_j$ can, for example, be approximately stressed using the function $f(x_i, x_j) = x_i x_j - \bar{X}_i \bar{X}_j$, where $\bar{X}_i$ and $\bar{X}_i$ denote the sample mean of $X_i$ and $X_j$, respectively. ++++MAYBE ONLY THIS LAST EXAMPLE IS SUFFICIENT++++ The functions `stress_mean()`, `stress_mean_sd()` and `stress_moment()` can be applied to multiple model components and are the only `stress` functions that have scenario weights calculated via numerical optimisation using the [nleqslv](https://CRAN.R-project.org/package=nleqslv) package. Thus, depending on the choice of constraints, existence or uniqueness, of a stressed model is not guaranteed. 


### Stressing risk measures {#Sec:RiskMeasures}

The functions `stress_VaR` and `stress_VaR_ES` provides stressed models, under which a model components fulfils a stress on the risk measures Value-at-Risk ($\text{VaR}$) and/or Expected Shortfall ($\text{ES}$). The $\text{VaR}$ at level $0 < \alpha < 1$ of a random variable $Z$ with distribution $F$ is defined as its left-inverse evaluated at $\alpha$, that is $$\text{VaR}_\alpha(Z) = F^{-1}(\alpha).$$ The $\text{ES}$ at level $0 < \alpha < 1$ of a random variable $Z$ is given by $$\text{ES}_\alpha(Z) = \int_\alpha^1 \text{VaR}_u(Z) \mathrm{d}u.$$ 
The details of the constraints, that `stress_VaR()` and `stress_VaR_ES()` solve, are as follows:

> For $0< \alpha <1$ and $q, s \in \mathbb{R}$ such that $\text{VaR}_{\alpha}(Y)<q < s$, `stress_VaR()` solves \@ref(eq:optimisation) with the constraints
\begin{equation} 
\text{VaR}_{\alpha }^W(Y) = q;  (\#eq:optimisationVaR)
\end{equation}
and `stress_VaR_ES()` solves \@ref(eq:optimisation) with the constraints
\begin{equation}                                                
\text{VaR}_{\alpha }^W(Y) = q \text{ and ES}_{\alpha }^W(Y) = s.(\#eq:optimisationVaRES)
\end{equation}

### User defined scenario weights 

The option `type = user` allows to generate a `SWIM` object with  scenario weights defined by a user. The scenario weights can be provided directly via the `new_weights` parameter or through a list of functions, `new_weightsfun`, that applied to the data `x` generates the scenario weights. 

## Analysis of stressed models {#Sec:analysis}

The function `summary()` is a methods for an object of class SWIM and provides summary statistics of the baseline and stressed models. If the SWIM object contains more than one set of scenario weights, each corresponding to one stressed model, the `stress()` function returns for each set of scenario weights a list containing:    

|                | |
| :---           | :--- |  
|`mean`          |sample mean
|`sd`            |sample standard deviation
|`skewness`      |sample skewness
|`ex kurtosis`   |sample excess kurtosis
|`1st Qu.`       |25% quantile
|`Median`        |median, 50% quantile
|`3rd Qu.`       |75% quantile

### Distributional comparison
The `SWIM` package contains functions to compare the distribution of model components under different (stressed) models. It is important to note, that \textbf{R} functions implementing the empirical cdf or the quantile, `ecdf()` or `quantile()`, will **not** return the empirical distribution function or the quantile function under a stressed model.++++MAYBE LAST SENTENCE AS A FOOTNOTE?++++ The empirical distribution function of model components under a stressed model can be calculated using the `cdf()` function of the SWIM package, applied to a SWIM object. To calculate sample quantiles of stressed models components, the function `quantile_stressed()` should be used. The function `VaR_stressed()` and `ES_stressed()` provide the stressed VaR and ES of model components, which is of particular interest for stressed models resulting from constraints on risk measures, see Section \@ref(Sec:RiskMeasures).

Implemented visualisation of distribution functions are `plot_cdf()`, for plotting empirical distribution functions, and `plot_hist()`, for plotting histograms of model components under different (stressed) models.


### Sensitivity measures 
Comparison of baseline and stressed models and how model components change under different models, is typically done via sensitivity measures. The `SWIM` packages contains the `sensitivity()` function, that calculates sensitivity measures of stressed models and model components. The implemented sensitivity measures, summarised in the table below, are the Wasserstein, Kolmogorov and the Gamma sensitivity measures, see @Pesenti2019 for the latter.++++ADD MORE REFERENCES?++++ The Wasserstein and Kolmogorov sensitivities provide a comparison of different (stressed and baseline) models, as these sensitivities only depend on the scenario weights. The Gamma sensitivity measure, which accounts for the induced stress to the mean of a model component, can be utilised to compare the impact of a stressed model on the model components. The definition of the sensitivity measures is summarised in the following table:

|                |                  |
| :---           | :--- | :--- | 
|Wasserstein   |$\int | F^W_X (x) - F_X(x)| dx$ | comparing models
|Kolmogorov    |$\sup_x |F^W_X (x) - F_X(x)|$ | comparing models
|Gamma         |$\frac{E^W(X) - E(X)}{c}$, for a normalisation $c$ | comparing model components

The Gamma sensitivity measure is normalised such that it takes values between -1 and 1, and positive values correspond to a larger impact. The sensitivity measures of models or model components can be plotted using `plot_sensitivity()`. The function `importance_rank()` returns the effective rank of model component according to the chosen sensitivity measures. 
