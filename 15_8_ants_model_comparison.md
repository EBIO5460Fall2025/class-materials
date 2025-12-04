Ant data: model comparison
================
Brett Melbourne
12 Dec 2018 (updated 3 Dec 2025)

This script considers model comparison from several perspectives,
including frequentist, Bayesian, information theoretic, and pure
predictive performance (a concept also key to machine learning). It uses
the ant data described in Ellison (2004), which we have previously
looked at.

``` r
library(lme4)
library(ggplot2)
library(rstanarm)
options(mc.cores = parallel::detectCores())
theme_set(theme_bw())
```

Read in the data

``` r
ant <- read.csv("data/ants.csv")
ant$habitat <- factor(ant$habitat)
ant$site <- factor(ant$site) #site identifier for site-level variation
ant$plot <- factor(1:nrow(ant)) #unit-level identifier for plot-level variation (or overdispersion)
```

Train the basic model from our previous investigations. This model for
the data generating process is:

$$
\begin{align}
   y_i &\sim \text{Poisson}(\lambda_i) \\
  ln(\lambda_i) &= \beta_0 + \beta_1 \text{forest}_i + \beta_2 \text{latitude}_i + 
    \beta_3 \text{forest}_i \times \text{latitude}_i + s_{j[i]} + e_i \\
  s_j &\sim \text{Normal}(0, \sigma_{site}) \\
  e_i &\sim \text{Normal}(0, \sigma_{plot})
\end{align}
$$

We’ll train here with both a likelihood and Bayesian approach using
standard tools for this generalized linear mixed model. In regression
formula syntax, the stochastic component $s_{j[i]}$ is added below as
`(1|site)` and is often called a “random effect”. We use the function
`glmer()` from the package `lme4` for the maximum likelihood training
and `stan_glmer()` from the `rstanarm` package for the Bayesian training
(with default priors that are built in). The algorithm in `glmer()` was
not able to successfully train the model including the plot-level
variation, $e_i$, because $\sigma_{plot}$ was close to zero. Our best
recourse is to leave $e_i$ out of the model, effectively assuming it is
zero. The Bayesian algorithm did not have a problem estimating $e_i$ and
$\sigma_{plot}$. We’ll train all these versions for later comparison.
Also, we need to scale the predictor variables to get the maximum
likelihood algorithm to work, so we’ll work with the scaled variables to
enable comparison between frequentist and Bayesian (this does not affect
the inferences). Model naming convention: `HxL` indicates model that
includes the habitat-latitude interaction, `od` indicates the
“overdispersed” model (Poisson-lognormal) that includes plot-level
variation ($e_i$ in the equation above).

``` r
ant$latitude_s <- scale(ant$latitude)
glmerHxL <- glmer(richness ~ habitat + latitude_s + habitat:latitude_s + (1|site),
                 family=poisson, data=ant)

bayesHxL <- stan_glmer(richness ~ habitat + latitude_s + habitat:latitude_s + (1|site),
                 family=poisson, data=ant)

bayes_odHxL <- stan_glmer(richness ~ habitat + latitude_s + habitat:latitude_s + (1|site) + (1|plot),
                        family=poisson, data=ant)
```

## Model comparison approaches

We’ll now contrast five ways to approach model comparison (here
comparing models that include different variables), first asking the
question: Should the model include an interaction of habitat and
latitude (i.e. should the relationship between richness and latitude be
different between habitats)?

1.  Frequentist NHST  
2.  Bayesian credible interval for the interaction coefficient
    $\beta_3$  
3.  Cross-validation  
4.  AIC and AICc  
5.  LOOIC  

Finally, in the next section, we’ll look at a bigger investigation and
consider the many possible models that could result from considering
combinations of the predictors (including a new one: elevation) and all
their higher-order interactions.

### 1. Frequentist NHST

In the classical frequentist approach we could conduct a null-hypothesis
significance test (NHST), which essentially asks: Could the data
plausibly be explained by a model without the interaction? More
precisely, what is the probability, *p*, of a test statistic, given
$\beta_3 = 0$? If *p* \< 0.05 reject the null hypothesis and decide to
add the interaction to the model.

First train the model without the interaction. This will be the null
model in the NHST.

``` r
glmerHL <- glmer(richness ~ habitat + latitude_s + (1|site),
                 family=poisson, data=ant)
```

The usual NHST for GLMMs is the likelihood ratio test. Twice the log of
the likelihood ratio,

$$
2 ln \left( \frac{L(full)}{L(null)} \right)
$$

will be our test statistic. Asymptotically, this has a Chi-squared
distribution. We can thus compute *p* directly:

``` r
chisq_stat <- as.numeric( 2 * ( logLik(glmerHxL) - logLik(glmerHL) ) )
chisq_stat
```

    ## [1] 0.04038776

``` r
1 - pchisq(chisq_stat, df=1) #p-value.
```

    ## [1] 0.8407243

Or we can use the `anova()` convenience function, where the deviance is
reported for models trained by maximum likelihood. The deviance is minus
twice the log-likelihood, so the Chi-squared test statistic is
equivalently the difference in deviance of the models. In the following
table `Chisq` is the Chi-squared statistic and its associated p-value is
shown.

``` r
anova(glmerHxL, glmerHL)
```

    ## Data: ant
    ## Models:
    ## glmerHL: richness ~ habitat + latitude_s + (1 | site)
    ## glmerHxL: richness ~ habitat + latitude_s + habitat:latitude_s + (1 | site)
    ##          npar    AIC    BIC  logLik -2*log(L)  Chisq Df Pr(>Chisq)
    ## glmerHL     4 214.47 221.60 -103.23    206.47                     
    ## glmerHxL    5 216.42 225.34 -103.21    206.42 0.0404  1     0.8407

Since *p* is greater than 0.05, we don’t find the data implausible given
the model without the interaction. So, in this approach we would decide
to leave the interaction out. Although the above asymptotic test is
frequently used for multilevel models, it’s not entirely clear that it
is theoretically valid. The most defensible approach here would be a
bootstrapped p-value. See code in
[10_9_bootstrap_p-value.md](10_9_bootstrap_p-value.md).

### 2. Bayesian credible interval for the interaction coefficient $\beta_3$

In the Bayesian setting, we could ask if 0 is a credible value for the
interaction coefficient. Inspecting the posterior summary, we find the
estimate is close to zero and the 95% credible interval widely spans
zero. Here, we are using the central posterior interval as a more
numerically stable approximation to the HPDI since the posterior is
symmetric. We’ll use the overdispersed model because the Bayesian
algorithm has no problem training it.

``` r
summary(bayes_odHxL, pars="beta", probs=c(0.025,0.975), digits=4)
```

    ## 
    ## Model Info:
    ##  function:     stan_glmer
    ##  family:       poisson [log]
    ##  formula:      richness ~ habitat + latitude_s + habitat:latitude_s + (1 | site) + 
    ##     (1 | plot)
    ##  algorithm:    sampling
    ##  sample:       4000 (posterior sample size)
    ##  priors:       see help('prior_summary')
    ##  observations: 44
    ##  groups:       plot (44), site (22)
    ## 
    ## Estimates:
    ##                            mean    sd      2.5%    97.5%
    ## habitatforest             0.6347  0.1345  0.3776  0.9035
    ## latitude_s               -0.2729  0.1236 -0.5157 -0.0373
    ## habitatforest:latitude_s -0.0227  0.1410 -0.2906  0.2658
    ## 
    ## MCMC diagnostics
    ##                          mcse   Rhat   n_eff
    ## habitatforest            0.0019 1.0007 5115 
    ## latitude_s               0.0021 0.9999 3373 
    ## habitatforest:latitude_s 0.0023 0.9999 3761 
    ## 
    ## For each parameter, mcse is Monte Carlo standard error, n_eff is a crude measure of effective sample size, and Rhat is the potential scale reduction factor on split chains (at convergence Rhat=1).

Since zero is well within the credible interval, we could decide to
leave the interaction out of the model.

We could come to the same decision from the frequentist confidence
interval for the interaction, which is almost the same as the Bayesian
credible interval (for comparison, given here for the Bayesian model
without overdispersion):

``` r
confint(glmerHxL, parm="habitatforest:latitude_s")
```

    ## Computing profile confidence intervals ...

    ##                               2.5 %    97.5 %
    ## habitatforest:latitude_s -0.2883807 0.2413327

``` r
summary(bayesHxL, pars="beta", probs=c(0.025,0.975), digits=4)['habitatforest:latitude_s',c('2.5%','97.5%')]
```

    ##       2.5%      97.5% 
    ## -0.2937281  0.2425487

### 3. Cross-validation

The cross-validation (CV) approach (and the related information criteria
in the following sections) have a different underlying philosophy.
Whereas the above approaches focus on inference for the value of the
interaction coefficient, cross validation focuses on the predictive
performance of the model on new data (in other words, out-of-sample
performance). Since CV is a general tool, we can apply it in either the
likelihood or Bayesian workflow. Here, I’ll illustrate CV with models
trained by likelihood, since it’s faster. We’ll do leave-one-out-CV
(LOOCV), which is a special case of k-fold CV where k = n. LOOCV is a
good choice for the multilevel model because we won’t make any trained
model too unbalanced by leaving out only one data point (recall that
data points are paired at sites, one each of forest and bog). As we are
training a model with a log link, it makes sense to calculate the mean
squared error (MSE) on the log scale (the scale of the linear
deterministic skeleton).

``` r
n <- nrow(ant) #number of data points

# LOOCV algorithm for model with interaction
errHxL <- rep(NA,n)
for ( i in 1:n ) { 
    glmerHxL_loo <- glmer(richness ~ habitat + latitude_s + habitat:latitude_s +
                          (1|site), family=poisson, data=ant[-i,])
    errHxL[i] <- (predict(glmerHxL_loo, newdata=ant[i,]) - log(ant[i,"richness"]))^2 #MSE
    rm(glmerHxL_loo) 
}
CV_HxL <- mean(errHxL)

# LOOCV algorithm for model without interaction
errHL <- rep(NA,n)
for ( i in 1:n ) {
    glmerHL_loo <- glmer(richness ~ habitat + latitude_s + 
                         (1|site), family=poisson, data=ant[-i,])
    errHL[i] <- (predict(glmerHL_loo, newdata=ant[i,]) - log(ant[i,"richness"]))^2 #MSE
    rm(glmerHL_loo)
}
CV_HL <- mean(errHL)

# Compare models
cbind(CV_HxL,CV_HL)
```

    ##         CV_HxL     CV_HL
    ## [1,] 0.2083276 0.1971044

We see that the prediction error is basically the same for the two
models, with slightly better out-of-sample predictive performance (lower
LOOCV) for the model without the interaction. Thus, we should prefer the
model without the interaction.

### 4. AIC or AICc

AIC can be derived as a measure of out-of-sample predictive performance.
It is very popular in ecology. Comparing the AIC of the two models is
straightforward (using the built in `AIC` function):

``` r
AIC(glmerHL)
```

    ## [1] 214.4646

``` r
AIC(glmerHxL)
```

    ## [1] 216.4242

The model with the lower AIC should be preferred, so we again see that
the model without the interaction is best.

Burnham and Anderson recommend a small sample correction to AIC when n/k
\< 40, where n is the number of data points and k is the number of
estimated parameters. The corrected value is

$$
AICc = AIC + \frac{2k(k+1)}{n-k-1}
$$

We can make a simple helper function that takes the trained model object
and calculates AICc

``` r
AICc <- function(fitmod) {
    ll <- logLik(fitmod)
    k <- attr(ll, "df")
    n <- attr(ll,"nobs")
    return( -2 * as.numeric(ll) + 2 * k + 2 * k * (k + 1) / (n - k - 1) )
}
```

Now we can use it:

``` r
AICc(glmerHL)
```

    ## [1] 215.4902

``` r
AICc(glmerHxL)
```

    ## [1] 218.0031

We see that this doesn’t change our decision and indeed favors the
simpler model even more than the uncorrected AIC.

### 5. LOOIC

Finally, the Bayesian approach that is the state of the art, the
leave-one-out information criterion (LOOIC). The measure of
out-of-sample predictive fit for LOOIC is the expected log predictive
density:

$$
\text{elpd}_\text{loo} = \displaystyle \sum_{i=1}^{n} \text{log} \left( p(y_i | y_{-i}) \right)
$$

where $p(y_i | y_{-i})$ is the predictive density for the ith data point
given the data without the ith data point.

It would be computationally expensive to do LOOCV directly on Bayesian
models (it would require retraining the model leaving out each
observation). Instead, the LOOIC approach *approximates* this for most
points but uses a direct CV algorithm when the approximation is
determined to be not good (typically zero to a few points).

As we’re able to train the overdispersed Bayesian model just fine, we’ll
do that here. First train the model without the interaction term:

``` r
bayes_odHL <- stan_glmer(richness ~ habitat + latitude_s + (1|site) + (1|plot), 
                         family=poisson, data=ant)
```

Now calculate the LOOIC, which is very conveniently done automatically
for `rstanarm` objects using the `loo()` function. First for the model
without the interaction (this will take a minute or so):

``` r
loo(bayes_odHL)
```

    ## 
    ## Computed from 4000 by 44 log-likelihood matrix.
    ## 
    ##          Estimate  SE
    ## elpd_loo   -105.8 4.0
    ## p_loo        10.7 1.7
    ## looic       211.6 7.9
    ## ------
    ## MCSE of elpd_loo is 0.1.
    ## MCSE and ESS estimates assume independent draws (r_eff=1).
    ## 
    ## All Pareto k estimates are good (k < 0.7).
    ## See help('pareto-k-diagnostic') for details.

This reports the leave-one-out expected log predictive density
(`elpd_loo`), the effective number of parameters (`p_loo`), and the
leave-one-out information criterion (`looic`), which is `-2 * elpd_loo`.
There are also some diagnostics for this algorithm. We are hoping to see
that all Pareto k estimates are at least `ok`. If not, there will be a
warning message that some observations had a pareto_k \> 0.7, which is
telling us that the approximation might not be accurate for those
observations. We would then follow any advice here to set the
`k_threshold` argument as follows, which will perform a direct LOOCV
simulation for those observations. In practice, I find this happens
often enough that I always set `k_threshold` by default.

``` r
loo(bayes_odHL, k_threshold = 0.7)
```

    ## All pareto_k estimates below user-specified threshold of 0.7. 
    ## Returning loo object.

    ## 
    ## Computed from 4000 by 44 log-likelihood matrix.
    ## 
    ##          Estimate  SE
    ## elpd_loo   -105.8 4.0
    ## p_loo        10.7 1.7
    ## looic       211.6 7.9
    ## ------
    ## MCSE of elpd_loo is 0.1.
    ## MCSE and ESS estimates assume independent draws (r_eff=1).
    ## 
    ## All Pareto k estimates are good (k < 0.7).
    ## See help('pareto-k-diagnostic') for details.

Now for the model with the interaction:

``` r
loo(bayes_odHxL, k_threshold = 0.7)
```

    ## 3 problematic observation(s) found.
    ## Model will be refit 3 times.

    ## 
    ## Fitting model 1 out of 3 (leaving out observation 3)

    ## 
    ## Fitting model 2 out of 3 (leaving out observation 4)

    ## 
    ## Fitting model 3 out of 3 (leaving out observation 11)

    ## 
    ## Computed from 4000 by 44 log-likelihood matrix.
    ## 
    ##          Estimate  SE
    ## elpd_loo   -106.8 4.0
    ## p_loo        11.5 1.7
    ## looic       213.6 7.9
    ## ------
    ## MCSE of elpd_loo is 0.1.
    ## MCSE and ESS estimates assume independent draws (r_eff=1).
    ## 
    ## All Pareto k estimates are good (k < 0.7).
    ## See help('pareto-k-diagnostic') for details.

Comparing LOOIC between the models, we find that the model without the
interaction has lower LOOIC (see the lines above labelled `looic`), so
we favor the simpler model without the interaction.

## Comparing multiple Bayesian models with LOOIC

Often you want to compare many models. This is computationally expensive
but not too bad. Here we compare the many possible models that could
result from considering combinations of the predictors (including a new
one: elevation) and all their higher order interactions. Model training
takes about 10-20 secs per model (2-5 mins in all but possibly much
longer if you have a slow CPU) and about the same for the LOOIC
algorithm. If we found this too arduous (say if each of our models takes
a long time to train), then we might fall back to maximum likelihood and
AICc, provided those models can converge (which they often won’t). Here
we are including the overdispersion term (`plot`) in all the models (and
dropping `od` from the object name to simplify the code).

Scale and center the new variable

``` r
ant$elevation_s <- scale(ant$elevation)
```

Single factor models

``` r
bayesH <- stan_glmer(richness ~ habitat + (1|site) + (1|plot), 
                     family=poisson, data=ant)
bayesL <- stan_glmer(richness ~ latitude_s + (1|site) + (1|plot), 
                     family=poisson, data=ant)
```

    ## 4:

    ## Warning: There were 1 divergent transitions after warmup. See
    ## https://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
    ## to find out why this is a problem and how to eliminate them.

    ## Warning: Examine the pairs() plot to diagnose sampling problems

``` r
bayesE <- stan_glmer(richness ~ elevation_s + (1|site) + (1|plot),
                     family=poisson, data=ant)
```

Two factor models

``` r
bayesHL <- stan_glmer(richness ~ habitat + latitude_s + (1|site) + (1|plot), 
                      family=poisson, data=ant)
bayesHE <- stan_glmer(richness ~ habitat + elevation_s + (1|site) + (1|plot),
                      family=poisson, data=ant)
bayesLE <- stan_glmer(richness ~ latitude_s + elevation_s + (1|site) + (1|plot),
                      family=poisson, data=ant)
```

Two factor models with interactions

``` r
bayesHxL <- stan_glmer(richness ~ habitat + latitude_s + habitat:latitude_s + 
                       (1|site) + (1|plot), family=poisson, data=ant)
bayesHxE <- stan_glmer(richness ~ habitat + elevation_s + habitat:elevation_s + 
                       (1|site) + (1|plot), family=poisson, data=ant)
```

``` r
bayesLxE <- stan_glmer(richness ~ latitude_s + elevation_s + 
                       latitude_s:elevation_s + (1|site) + (1|plot),
                       family=poisson, data=ant)
```

Three factor model

``` r
bayesHLE <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                       (1|site) + (1|plot), family=poisson, data=ant)
```

Three factor model with single two-way interactions

``` r
bayesHLE_HxL <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                           habitat:latitude_s + (1|site) + (1|plot),
                           family=poisson, data=ant)
bayesHLE_HxE <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                           habitat:elevation_s + (1|site) + (1|plot),
                           family=poisson, data=ant)
bayesHLE_LxE <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                           latitude_s:elevation_s + (1|site) + (1|plot),
                           family=poisson, data=ant)
```

Three factor model with multiple two-way interactions

``` r
bayesHLE_HxL_HxE <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                               habitat:latitude_s + habitat:elevation_s + 
                               (1|site) + (1|plot), family=poisson, data=ant)
bayesHLE_HxL_LxE <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                               habitat:latitude_s + latitude_s:elevation_s + 
                               (1|site) + (1|plot), family=poisson, data=ant)
bayesHLE_HxE_LxE <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                               habitat:elevation_s + latitude_s:elevation_s + 
                               (1|site) + (1|plot), family=poisson, data=ant)
```

``` r
bayesHLE_HxL_HxE_LxE <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                                   habitat:latitude_s + habitat:elevation_s + 
                                   latitude_s:elevation_s + (1|site) + (1|plot),
                                   family=poisson, data=ant)
```

Three factor model with three-way interaction (full model)

``` r
bayesHxLxE <- stan_glmer(richness ~ habitat + latitude_s + elevation_s + 
                         habitat:latitude_s + habitat:elevation_s + 
                         latitude_s:elevation_s + habitat:latitude_s:elevation_s + 
                         (1|site) + (1|plot), family=poisson, data=ant)
```

Calculate LOOICs. We include `k_threshold=0.7` because many simulations
had one or two observations where an explicit LOOCV was needed. Because
these are stochastic simulations, sometimes it will be needed and
sometimes not, so it’s easiest to include the option for all
simulations. I didn’t suppress the output, so you can see how often the
model has to be retrained. As a result, you’ll have to scroll through a
few pages here to get to the conclusion.

``` r
loo_H <- loo(bayesH,k_threshold = 0.7)
```

    ## 5 problematic observation(s) found.
    ## Model will be refit 5 times.

    ## 
    ## Fitting model 1 out of 5 (leaving out observation 4)

    ## 
    ## Fitting model 2 out of 5 (leaving out observation 6)

    ## 
    ## Fitting model 3 out of 5 (leaving out observation 9)

    ## 
    ## Fitting model 4 out of 5 (leaving out observation 14)

    ## 
    ## Fitting model 5 out of 5 (leaving out observation 22)

``` r
loo_L <- loo(bayesL,k_threshold = 0.7)
```

    ## 14 problematic observation(s) found.
    ## Model will be refit 14 times.

    ## 
    ## Fitting model 1 out of 14 (leaving out observation 1)

    ## 
    ## Fitting model 2 out of 14 (leaving out observation 3)

    ## 
    ## Fitting model 3 out of 14 (leaving out observation 4)

    ## 
    ## Fitting model 4 out of 14 (leaving out observation 6)

    ## 
    ## Fitting model 5 out of 14 (leaving out observation 9)

    ## 
    ## Fitting model 6 out of 14 (leaving out observation 12)

    ## 
    ## Fitting model 7 out of 14 (leaving out observation 13)

    ## 
    ## Fitting model 8 out of 14 (leaving out observation 19)

    ## 
    ## Fitting model 9 out of 14 (leaving out observation 20)

    ## 
    ## Fitting model 10 out of 14 (leaving out observation 24)

    ## 
    ## Fitting model 11 out of 14 (leaving out observation 25)

    ## 
    ## Fitting model 12 out of 14 (leaving out observation 26)

    ## 
    ## Fitting model 13 out of 14 (leaving out observation 27)

    ## 
    ## Fitting model 14 out of 14 (leaving out observation 33)

``` r
loo_E <- loo(bayesE,k_threshold = 0.7)
```

    ## 13 problematic observation(s) found.
    ## Model will be refit 13 times.

    ## 
    ## Fitting model 1 out of 13 (leaving out observation 2)

    ## 
    ## Fitting model 2 out of 13 (leaving out observation 3)

    ## 
    ## Fitting model 3 out of 13 (leaving out observation 4)

    ## 
    ## Fitting model 4 out of 13 (leaving out observation 7)

    ## 
    ## Fitting model 5 out of 13 (leaving out observation 8)

    ## 
    ## Fitting model 6 out of 13 (leaving out observation 10)

    ## 
    ## Fitting model 7 out of 13 (leaving out observation 12)

    ## 
    ## Fitting model 8 out of 13 (leaving out observation 19)

    ## 
    ## Fitting model 9 out of 13 (leaving out observation 20)

    ## 
    ## Fitting model 10 out of 13 (leaving out observation 25)

    ## 
    ## Fitting model 11 out of 13 (leaving out observation 29)

    ## 
    ## Fitting model 12 out of 13 (leaving out observation 37)

    ## 
    ## Fitting model 13 out of 13 (leaving out observation 42)

``` r
loo_HL <- loo(bayesHL,k_threshold = 0.7)
```

    ## 1 problematic observation(s) found.
    ## Model will be refit 1 times.

    ## 
    ## Fitting model 1 out of 1 (leaving out observation 25)

``` r
loo_HE <- loo(bayesHE,k_threshold = 0.7)
```

    ## 3 problematic observation(s) found.
    ## Model will be refit 3 times.

    ## 
    ## Fitting model 1 out of 3 (leaving out observation 3)

    ## 
    ## Fitting model 2 out of 3 (leaving out observation 4)

    ## 
    ## Fitting model 3 out of 3 (leaving out observation 6)

``` r
loo_LE <- loo(bayesLE,k_threshold = 0.7)
```

    ## 9 problematic observation(s) found.
    ## Model will be refit 9 times.

    ## 
    ## Fitting model 1 out of 9 (leaving out observation 4)

    ## 
    ## Fitting model 2 out of 9 (leaving out observation 5)

    ## 
    ## Fitting model 3 out of 9 (leaving out observation 7)

    ## 
    ## Fitting model 4 out of 9 (leaving out observation 8)

    ## 
    ## Fitting model 5 out of 9 (leaving out observation 9)

    ## 
    ## Fitting model 6 out of 9 (leaving out observation 24)

    ## 
    ## Fitting model 7 out of 9 (leaving out observation 27)

    ## 
    ## Fitting model 8 out of 9 (leaving out observation 30)

    ## 
    ## Fitting model 9 out of 9 (leaving out observation 37)

``` r
loo_HxL <- loo(bayesHxL,k_threshold = 0.7)
```

    ## 1 problematic observation(s) found.
    ## Model will be refit 1 times.

    ## 
    ## Fitting model 1 out of 1 (leaving out observation 1)

``` r
loo_HxE <- loo(bayesHxE,k_threshold = 0.7)
```

    ## 3 problematic observation(s) found.
    ## Model will be refit 3 times.

    ## 
    ## Fitting model 1 out of 3 (leaving out observation 2)

    ## 
    ## Fitting model 2 out of 3 (leaving out observation 8)

    ## 
    ## Fitting model 3 out of 3 (leaving out observation 9)

``` r
loo_LxE <- loo(bayesLxE,k_threshold = 0.7)
```

    ## 8 problematic observation(s) found.
    ## Model will be refit 8 times.

    ## 
    ## Fitting model 1 out of 8 (leaving out observation 2)

    ## 
    ## Fitting model 2 out of 8 (leaving out observation 4)

    ## 
    ## Fitting model 3 out of 8 (leaving out observation 6)

    ## 
    ## Fitting model 4 out of 8 (leaving out observation 7)

    ## 
    ## Fitting model 5 out of 8 (leaving out observation 8)

    ## 
    ## Fitting model 6 out of 8 (leaving out observation 9)

    ## 
    ## Fitting model 7 out of 8 (leaving out observation 27)

    ## 
    ## Fitting model 8 out of 8 (leaving out observation 42)

``` r
loo_HLE <- loo(bayesHLE,k_threshold = 0.7)
```

    ## All pareto_k estimates below user-specified threshold of 0.7. 
    ## Returning loo object.

``` r
loo_HLE_HxL <- loo(bayesHLE_HxL,k_threshold = 0.7)
```

    ## All pareto_k estimates below user-specified threshold of 0.7. 
    ## Returning loo object.

``` r
loo_HLE_HxE <- loo(bayesHLE_HxE,k_threshold = 0.7)
```

    ## All pareto_k estimates below user-specified threshold of 0.7. 
    ## Returning loo object.

``` r
loo_HLE_LxE <- loo(bayesHLE_LxE,k_threshold = 0.7)
```

    ## 2 problematic observation(s) found.
    ## Model will be refit 2 times.

    ## 
    ## Fitting model 1 out of 2 (leaving out observation 8)

    ## 
    ## Fitting model 2 out of 2 (leaving out observation 25)

``` r
loo_HLE_HxL_HxE <- loo(bayesHLE_HxL_HxE,k_threshold = 0.7)
```

    ## 2 problematic observation(s) found.
    ## Model will be refit 2 times.

    ## 
    ## Fitting model 1 out of 2 (leaving out observation 6)

    ## 
    ## Fitting model 2 out of 2 (leaving out observation 14)

``` r
loo_HLE_HxL_LxE <- loo(bayesHLE_HxL_LxE,k_threshold = 0.7)
```

    ## All pareto_k estimates below user-specified threshold of 0.7. 
    ## Returning loo object.

``` r
loo_HLE_HxE_LxE <- loo(bayesHLE_HxE_LxE,k_threshold = 0.7)
```

    ## All pareto_k estimates below user-specified threshold of 0.7. 
    ## Returning loo object.

``` r
loo_HLE_HxL_HxE_LxE <- loo(bayesHLE_HxL_HxE_LxE,k_threshold = 0.7)
```

    ## 2 problematic observation(s) found.
    ## Model will be refit 2 times.

    ## 
    ## Fitting model 1 out of 2 (leaving out observation 8)

    ## 
    ## Fitting model 2 out of 2 (leaving out observation 14)

``` r
loo_HxLxE <- loo(bayesHxLxE,k_threshold = 0.7)
```

    ## 4 problematic observation(s) found.
    ## Model will be refit 4 times.

    ## 
    ## Fitting model 1 out of 4 (leaving out observation 7)

    ## 
    ## Fitting model 2 out of 4 (leaving out observation 24)

    ## 
    ## Fitting model 3 out of 4 (leaving out observation 25)

    ## 
    ## Fitting model 4 out of 4 (leaving out observation 30)

Now we can compare the models, looking particularly at LOOIC and the
difference in LOOIC.

``` r
modcompare <- loo_compare(loo_H,loo_L,loo_E,loo_HL,loo_HE,loo_LE,loo_HxL,
                          loo_HxE,loo_LxE,loo_HLE,loo_HLE_HxL,loo_HLE_HxE,
                          loo_HLE_LxE,loo_HLE_HxL_HxE,loo_HLE_HxL_LxE,
                          loo_HLE_HxE_LxE,loo_HLE_HxL_HxE_LxE,loo_HxLxE)
modcompare <- cbind(modcompare, -2*modcompare[,1], 2*modcompare[,2]) #calc LOOIC difference
colnames(modcompare)[9:10] <- c("looic_diff","se_looic_diff")
print(modcompare[,c("looic","looic_diff","se_looic_diff")], simplify=FALSE, digits=4)
```

    ##                      looic looic_diff se_looic_diff
    ## bayesHLE             208.1      0.000        0.0000
    ## bayesHLE_LxE         209.6      1.459        0.9987
    ## bayesHLE_HxE         210.1      1.938        1.4171
    ## bayesHLE_HxL         210.3      2.191        0.6193
    ## bayesHLE_HxE_LxE     210.9      2.761        1.9656
    ## bayesHL              211.0      2.841        4.1039
    ## bayesHLE_HxL_LxE     211.9      3.742        0.9786
    ## bayesHLE_HxL_HxE     212.5      4.408        1.5251
    ## bayesHE              212.9      4.771        3.9094
    ## bayesHxL             213.6      5.512        4.1016
    ## bayesHLE_HxL_HxE_LxE 214.0      5.929        2.0475
    ## bayesH               215.0      6.859        5.3720
    ## bayesHxE             215.7      7.539        4.6223
    ## bayesHxLxE           215.9      7.793        2.2353
    ## bayesLE              232.1     23.944        7.8097
    ## bayesLxE             234.6     26.498        8.1059
    ## bayesL               234.9     26.827        8.3944
    ## bayesE               238.0     29.848        8.7576

We see that the model with the best out-of-sample prediction error is
`bayesHLE`, the model with each of the variables but with no
interactions. We have also calculated the LOOIC differences (and their
standard errors) of each model *from the best model*. A LOOIC difference
of about 2 indicates a fairly negligible difference between models. So,
the top four models all have about the same predictive performance. Also
notice the uncertainty (`se_`) in these differences is reasonably large
for small differences. By default, `loo_compare()` reports results for
the expected log predictive density (ELPD). LOOIC is -2\*ELPD and we
calculated that here instead for consistency with the AIC convention.

A maximum likelihood analysis followed by AICc gives very similar
results, identifying the same “best” model, then the next top three,
with some differences in the ordering of other models.

We have used `rstanarm` to train the models in this example but the
`loo` package can be used to compute LOOIC for any Stan model, including
models you write yourself, or those implemented using the `brms`
package. It can also do more general k-fold cross validation.
