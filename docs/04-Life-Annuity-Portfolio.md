
# Life Annuity Portfolio

**comment Silvana: I added the text Alberto wrote, might be a starting point**    


In this section we showcase the SWIM package to conduct sensitivity analysis of a life annuity portfoliol inspired by @Olivieri2003, which includes the following types of risks:    

  - *mortality risk* including process and longevity risk.   
  - *investment risk* originating from the financial markets in which the insurer invests.


## Assumptions
A single cohort, where the annuitants have age $x$ at time $t=0$. It is assumed that at time $t=n$ every policy holder is deceased. Every policy holder has an immediate life annuity withy annual amout $R$.   
Notation:   

  - $Z_t$ portfolio fund at time $t$    
  - $N_t$  number of annuitants at time $t$    
  - $D_t = N_t - N_{t+1}$    
  - $I_t$ rate of return for the period ($t-1,t$)    
  - $\omega -1$ maximum attainable age    
  - $\Pi$ single premium   
  - $M$ (initial) solvency margin.   


The portfolio fund is modelled via
\begin{equation}
Z_t = (Z_{t-1} - N_{t-1} R) (1+I_{t}), \ \ \ t=1,\ldots,\omega-x,
\end{equation}
with initial fund equal to 
\begin{equation}
Z_0 = N_0 \Pi + M.
\end{equation}


For a fixed solvency level $\varepsilon$, the initial margin $M$ is chosen so that:
\begin{equation}
P(Z_n \ge 0) \ge 1-\varepsilon.
\end{equation}


*Mortality Model*
The random variable $\tilde{q}_{x+t,t}$ denotes the one-year death probability for an individual aged $x+t$ in calendar year $\hat{t}+t$ (where $\hat{t}$ is fixed). 
Under the assumptions of homogeneous and indipendent lives, the conditional probability distribution of $D_t$ given $N_t$ is Binomial distributed

\begin{equation}
D_t|N_{t},\tilde{q}_{x+t,t} \sim \text{Binom}(N_{t},\tilde{q}_{x+t,t}),  t=0,\ldots,\omega-x-1.
\end{equation}
