# (APPENDIX) Appendix {-}

# Appendix Credit Model {#AppendixCM}

## Credit Model assumptions

The credit model is based on the conditionally binomial credit model described in @Mcneil2015B which belongs to the family of mixture models. Specifically, we consider a portfolio that consists of three homogeneous sub-portfolios and denote the total aggregate loss of the portfolio by $L = L_1 + L_2+  L_2$, where $L_1, L_2, L_3$ are the aggregate losses of each sub-portfolio, given by 
\begin{equation}
L_i=e_i\cdot\text{LGD}_i\cdot M_i,\quad i=1,2,3, 
\end{equation}
where $e_i$ and $M_i$ are the exposure and number of insolvencies of the $i^{\text{th}}$ sub-portfolio, respectively, and $\text{LGD}_i$ is the loss given default of sub-portfolio $i$. The number of insolvencies of the $i^{\text{th}}$ sub-portfolio $M_i$ is, conditionally on a $[0,1]$ valued random variable $H_i$, independent and Binomially distributed with parameters $m_i$, the sub-portfolio size, and common random probability $H_i$. $H_i, ~ i = 1,2,3$ follows a Beta distribution with parameters chosen such as to match the default probability $p_i$ and the default correlation $\rho_i$, that is the correlation between two default events within a sub-portfolio, see @Mcneil2015B. The dependence structure of $(H_1,H_2,H_3)$ is modelled via a Gaussian copula with correlation matrix    
\begin{equation}\Sigma = \begin{pmatrix}
1 & 0.3 & 0.1\\
0.3 & 1 & 0.4\\
0.1 & 0.4 & 1
\end{pmatrix}.\end{equation}

The subsequent table summarises the parameter values used in the simulation.

|$i$|$m_i$|$e_i$|$p_i$|$\rho_i$|$LGD_i$|
|:------|:------|:------|:------|:------|:------|
|1|2500|80|0.0004|0.00040|0.250|
|2|5000|25|0.0097|0.00440|0.375|
|3|2500|10|0.0503|0.01328|0.500|

## Code for generating the data



```r
  set.seed(1)
  library(copula)
  nsim <- 100000
  
# data
  m1 <- 2500 # counterparties tranche A
  m2 <- 5000 # counterparties tranche B
  m3 <- 2500 # counterparties tranche C
  
  p1 <- 0.0004 # prob of default 
  rho1 <- 0.0004 # correlation within the tranche

  p2 <- 0.0097 
  rho2 <- 0.0044
  
  p3 <- 0.0503  
  rho3 <- 0.01328
  
# exposures
  e1 <- 80
  e2 <- 25 
  e3 <- 10 
  
# loss given default
  LGD1 <- 0.25
  LGD2 <- 0.375
  LGD3 <- 0.5
  
# beta-binomial model with copula 
  
# beta parameters: matching tranches default probabilities and correlation
  alpha1 <- p1 * (1 / rho1 - 1)
  beta1 <- alpha1 * (1 / p1 - 1)
  
  alpha2 <- p2 * (1 / rho2 - 1)
  beta2 <- alpha2 * (1 / p2 - 1)
  
  alpha3 <- p3 * (1 / rho3 - 1)
  beta3 <- alpha3 * (1 / p3 - 1)
  
# correlations between sub-portfolios
  cor12 <- 0.3
  cor13 <- 0.1
  cor23 <- 0.4
  
# Gaussian copula structure
  myCop <- normalCopula(param = c(cor12, cor13, cor23), dim = 3, dispstr = "un")
  
# define multivariate beta with given copula
  myMvd <- mvdc(copula = myCop,
                margins = c("beta", "beta", "beta"),
                paramMargins = list(list(alpha1, beta1),
                                    list(alpha2, beta2),
                                    list(alpha3, beta3)))

# simulation from the chosen copula
  H <- rMvdc(nsim, myMvd)
  
# simulate number of default per tranches (binomial distributions)
  M1 <- rbinom(n = nsim, size = m1, prob = H[, 1])
  M2 <- rbinom(n = nsim, size = m2, prob = H[, 2])
  M3 <- rbinom(n = nsim, size = m3, prob = H[, 3])
  
# total loss per sub-portfolio
  L1 <- M1 * e1 * LGD1
  L2 <- M2 * e2 * LGD2
  L3 <- M3 * e3 * LGD3
  
# aggregate portfolio loss
  L <- L1 + L2 + L3
  
# DB for SWIM
  credit_data <- cbind(L, L1, L2, L3, H)
  colnames(credit_data) <- c("L", "L1", "L2", "L3", "H1", "H2", "H3")
```




