# Fundamental algorithms in data science

Collected here are the algorithms we encountered throughout the semester. They are classified as model, training, or inference algorithm (described in 08_5_slides_tue_training_algo.pdf). For models, they are also classified as coming from the natural processes, generic generative, or generic algorithmic cultures (described in 01_1_slides_thu_intro_welcome.pdf).



## Organism movement: discrete random walk, one dimension

Type: model

Culture: Natural process

```
prob_move = 0.2
t_finish = 10
dt = 0.1
position = 0
t = 0
while t < t_finish
    if uniform random number < prob_move
        if uniform random number < 0.5
            position = position - 1
        else
            position = position + 1
    t = t + dt
    print(position)
```



## Simple linear model

Type: model

Culture: Generic generative

```
# Atomic pseudocode
for i in 1:n
    y[i] = b_0 + b_1 * x[i]

# Vectorized pseudocode
y = b_0 + b_1 * x
```



## Logistic growth model

Type: model

Culture: Natural process

```
define function logistic_growth with arguments r, K, N_0, t
    N_t = N_0 * K * exp(r*t) / ( K + N_0 * (exp(r*t) - 1) )
    return(N_t)
```



## Grid search illustrated for linear SSQ

Type: training

```
read in data
set up values of b0 and b1 to try
set up storage for ssq, b0, b1
for each value of b0
    for each value of b1
        calculate model predictions
        calculate deviations
        sum squared deviations
        store ssq, b0, b1
plot sum of squares profiles (ssq vs b0, ssq vs b1)
report best ssq, b0, b1
plot trained model with the data
```



## A descent algorithm illustrated with the bisection algorithm

Type: training

```
set f_opt = Inf
start with 2 parameter (theta) values
bisect these theta values to create a third theta value
calculate f(theta) for all parameter values
make triangle
while f_opt is no longer declining to desired resolution
    bisect theta for the two lower sides of the triangle
    calculate f(theta) for all parameter values
    make lowest triangle
    f_opt = min(f(theta))
return theta of f_opt
```



## High level algorithm for training models by optimization

Type: training

```
define a biology process function, biology_f(theta)
define an error function, error_f(theta, data, biology_f)
optimize error_f with respect to theta given data
```



## Sampling distribution

Type: inference

```
repeat very many times
    sample n units from the population
    calculate the sample statistic
plot sampling distribution (histogram) of the sample statistic
```



## Sampling distribution for model parameters

Type: inference

```
repeat very many times
    sample data from the population
    train the model
    record the estimated parameters
plot sampling distribution (histogram) of parameter estimates
```



## Confidence interval coverage

Type: inference

```
repeat very many times
    sample n units from the population
    calculate the sample statistic
    calculate the interval for the sample statistic
calculate frequency true value is in the interval
```



## Bootstrap (general version)

Type: inference

```
repeat very many times
    simulate data based on the sample
    train the model on simulated data
    record the estimated parameters
plot sampling distribution (histogram) of the parameter estimates
```



## Non-parametric bootstrap for model parameters

Type: inference

```
repeat very many times
    resample data (with replacement) from the single sample
    train the model
    record the estimated parameters
plot sampling distribution (histogram) of the parameter estimates
```



## Empirical bootstrap for model parameters

Type: inference

```
train the model (estimate parameters)
extract the errors
repeat very many times
    resample the errors (with replacement) from the single sample
    create new y-values from the original estimated parameters and resampled errors
    train the model
    record the parameters
plot sampling distribution (histogram) of the parameter estimates
```



## Parametric bootstrap for model parameters

Type: inference

```
train the model (including error distribution)
record estimated parameters
repeat very many times
    simulate data from the original trained model
    train the model on simulated data
    record the parameters
plot sampling distribution (histogram) of the parameter estimates
```



## Bootstrap confidence interval for parameters

Type: inference

```
simulate sampling distribution of model parameters using one of the above algorithms
# Standard deviation method
CI = estimated parameter +/- t_c times standard deviation of the bootstrap distribution
     (where t_c is the value from the t distribution at the confidence level,
      e.g. t is about 2 for a 95% CI)
# Percentile method
CI = appropriate quantiles of the bootstrap distribution (e.g. 0.025, 0.975 for 95% CI)
```



## Bootstrap confidence interval for derived quantity

Type: inference

```
collect bootstrap samples of model parameters using one of the above algorithms
for each bootstrap sample of parameters
    calculate the derived quantity
    record the derived quantity
we now have the sampling distribution of the derived quantity
calculate CI from the sampling distribution of the derived quantity using one method above
```



## Bootstrap CI for continuous derived quantity (e.g. $\bar{y}$)

Type: inference

```
collect bootstrap samples of model parameters using one of the above algorithms
make a grid of predictor variables
for each combination of predictor variables
    for each sample of parameters
        calculate \bar_y as a function of parameters and predictor variables
        record \bar_y
we now have the sampling distribution of \bar_y at each combination of predictor variables
for each combination of predictor variables
    calculate CI \bar_y from the sampling distribution of \bar_y using one method above
```



## Bootstrap prediction interval (e.g. parametric)

Type: inference

```
collect bootstrap samples of model parameters using one of the above algorithms
make a grid of predictor variables
for each combination of predictor variables
    for each sample of parameters
        generate one realization of the DGP (stochastic function of parameters and predictors)
        record realized prediction
we now have the predictive distribution of the predicted quantity
for each combination of predictor variables
    calculate PI from the predictive distribution using one method above
```
where DGP is the data generating process



## Bootstrap *p*-value (e.g. linear model $H_0: \beta_1=0$)

Type: inference

```
train full model (y = beta_0 + beta_1 * x + e)
record estimated beta_1_hat and sigma_e_hat
train null model (y = beta_0 + e)
record estimated beta_0_hat
repeat very many times
    generate data from the null model
    train the full model
    record the estimated beta_1 (call this beta_1_boot)
calculate the frequency beta_1_boot is as large or larger than beta_1_hat
```



## Model for data generating process (e.g. linear Normal model)

Type: model

$y_i \sim \text{Normal}(\mu_i,\sigma)$ \
$\mu_i = \beta_0 + \beta_1 x_i$

```R
# Simulate model, e.g. in R
n <- 20
beta_0 <- 23.1
beta_1 <- 9.4
sigma <- 10
x <- seq(0, 100, length.out=n)
mu <- beta_0 + beta_1 * x          #deterministic skeleton
y <- rnorm(n, mean=mu, sd=sigma)   #stochasticity
```



## Likelihood training

Type: training

Likelihood for linear Normal model:

$y_i \sim \text{Normal}(\mu_i, \sigma)$ \
$\mu_i = \beta_0 + \beta_1 x_i$

```R
# R
# Linear model function (deterministic skeleton)
lmod <- function(b0, b1, x) {
    return(b0 + b1 * x)
}
# Negative log likelihood function (stochasticity)
lm_nll <- function(p, y, x) {
    mu <- lmod(b0=p[1], b1=p[2], x=x)
    nll <- -sum(dnorm(y, mean=mu, sd=p[3], log=TRUE)) 
    return(nll)
}
# Optimize (find the maximum likelihood)
optim(p=start_pars, lm_nll, y=y, x=x)
```



## Likelihood inference (general)

Type: inference

Likelihood ratio of model 2 to model 1:

$\displaystyle \frac{P(y|\theta_2)}{P(y|\theta_1)}$

```
for each pair of models in a set
    calculate likelihood ratio
judge the relative evidence for the models
```



## Likelihood profiling for intervals

Type: inference

Example: 1/8 likelihood interval for $\beta_1$ of the Normal linear model
Likelihood ratio of $\beta_{1i}$ to $\beta_{1MLE}$:

$\displaystyle \frac{P(y|\beta_{1i})}{P(y|\beta_{1MLE})}$

```
make a grid of beta_1 values either side of beta_1[MLE]
for each value of beta_1
    optimize the log likelihood over the other parameters
    ll_beta_1[i] = optimum log likelihood
    likelihood ratio = exp(ll_beta_1[i] - ll_beta_1[MLE])  #P(y|beta_1[i]) / P(y|beta_1[MLE])
plot the likelihood ratio against beta_1
find the values of beta_1 for which likelihood ratio = 1/8
```



## Bayesian posterior distribution (general)

Type: inference

```
load data
for each parameter value
    unstandardized posterior = prior * likelihood
calculate the total probability
for each parameter value
    posterior probability = unstandardized posterior / total probability
plot posterior probability vs parameter values
```



## Bayesian posterior distribution (discrete parameter)

Type: inference

```
load data
for each parameter value
    unstandardized posterior = prior * likelihood
total probability = sum of unstandardized posteriors
for each parameter value
    posterior probability = unstandardized posterior / total probability
plot posterior probability vs parameter values
```



## Bayesian posterior distribution (continuous parameter)

Type: inference

```
load data
define grid of parameter values
for each parameter value
    unstandardized posterior = prior * likelihood
total probability = integral of unstandardized posterior function
for each parameter value
    posterior Pr density = unstandardized posterior / total probability
plot posterior Pr density vs parameter values
```



## Bayesian posterior distribution (grid approximation)

Type: inference

```
load data
define grid of parameter values with resolution r
for each parameter value
    unstandardized posterior = prior * likelihood
total probability = sum(unstandardized posteriors) * r
for each parameter value
    posterior Pr density = unstandardized posterior / total probability
plot posterior Pr density vs parameter values
```



## MCMC sampling from posterior distribution (general algorithm)

Type: training, inference

```
set starting value for parameter
for many iterations
    propose new value for parameter
    calculate the probability of accepting the proposal:
        P_accept = min(Pr(proposal) / Pr(current), 1)
    accept proposal randomly with Bern(P_accept)
plot posterior distribution (histogram) of parameter values
```

where `Pr()` = prior x likelihood



## MCMC sampling from posterior distribution (Rosenbluth algorithm)

aka Metropolis algorithm

Type: training, inference

```
set maximum step size: max_d
set starting value for parameter
for many iterations
    propose new value for parameter:
        draw a random number from Unif(-max_d, max_d)
        proposal = current parameter + draw
    calculate the probability of accepting the proposal:
        P_accept = min(Pr(proposal) / Pr(current), 1)
    accept proposal randomly with Bern(P_accept)
plot posterior distribution (histogram) of parameter values
```

where `Pr()` = prior x likelihood



## Others

Bayesian prediction interval algorithm

HMC

Leave one out influence algorithm

k-fold cross validation

