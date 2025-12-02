# There are two scripts that demonstrate diagnostic procedures for evaluating
# models trained by optimizing the likelihood. This is script 1
# (model_checking_lin_norm.R), which is oriented toward Normal, linear, and
# generalized linear models and their multilevel counterparts. The second script
# (model_checking_likelihood.R) has procedures for more general likelihood cases
# (including arbitrary data distributions and nonlinear models). Much of the
# advice here should in principle also apply to Bayesian models especially when
# strong priors are not used and the likelihood contains most of the information
# in the posterior.

# It's important not to get confused by the different parts of this program.
# Simulating data and doing a linear regression in the first section are not
# part of the diagnostic methods. We need example datasets to demonstrate
# various scenarios, so I simulate data for them. I simulate data where the true
# model for the data generating process is a simple linear or nonlinear function
# for the deterministic skeleton. After simulating data, we imagine that our
# proposed model for the data generating process is a linear Normal model, which
# we train using lm(). We'll consider diagnostics for this trained model. Most
# of these methods extend from the Normal linear model to the rest of the linear
# model family (GLMM etc).

# Brett Melbourne 18 Oct 2018 (updated 2 Dec 2025)

# Set the type of example data to simulate
# 1 = linear
# 2 = nonlinear
# 3 = linear with outlier
# 4 = linear but not Normal (instead lognormal)

sim_type <- 1

# Simulate data

if ( sim_type == 1 ) {
    # linear
    a <- 0    #y-intercept
    b <- 3    #slope of linear predictor
    v <- 1000    #error variance
    x <- runif(100, 50, 100)    #an x variable
    y <- a + b * x + rnorm(100, sd=sqrt(v)) #the y data
} else if (sim_type == 2) {
    # nonlinear
    a <- 0    #y-intercept
    b <- 1    #slope of linear predictor
    c <- 1    #quadratic parameter - controls degree of nonlinearity
    v <- 10000    #error variance
    x <- runif(100, 50, 100)    #an x variable
    y <- a + b * x + c * x^2 + rnorm(100, sd=sqrt(v)) #the y data
} else if (sim_type == 3) {
    # linear with outlier
    a <- 0    #y-intercept
    b <- 3    #slope of linear predictor
    v <- 1000    #error variance
    x <- runif(100, 50, 100)    #an x variable
    y <- a + b * x + rnorm(100, sd=sqrt(v)) #the y data
    y[which.min(x)] <- y[which.min(x)] * 2.5 #simulated outlier
} else if (sim_type == 4) {
    # linear but not Normal (instead lognormal)
    a <- 0    #y-intercept
    b <- 3    #slope of linear predictor
    v <- 0.01  #error variance on log scale
    x <- runif(100, 50, 500)    #an x variable
    y <-  rlnorm(100, meanlog=log(a + b * x), sdlog=sqrt(v)) #the y data
} else {
    stop("sim_type must be 1, 2, 3, or 4")
}


#--Train a linear Normal model on the simulated data 
# Simple linear regression using `lm()` as a simple example of training a model.
fit <- lm(y ~ x)
plot(x, y, main="Linear Normal model trained on simulated data")
abline(fit, col="steelblue2")

# So, now we have a trained model, are our assumptions about the data generating
# process reasonable? We are assuming the DGP is linear Normal. Is this
# reasonable? Are there any other apparent problems, such as outliers or
# influential data points?


#----Diagnostic quantities------------------------------------------------------
# Begin by calculating some basic quantities. Some of these are easily obtained
# from the object saved by `lm()` but we'll instead calculate them from first
# principles to illustrate how to do it in the general case.

# First we want the model predictions (also called the "fitted values"), which 
# we'll calculate by plugging the maximum likelihood estimates of the parameters
# into the equation for the linear model.
beta <- coef(fit)                  #These are the best-fit parameters
beta                               #The parameter marked "x" is the slope
preds <- beta[1] + beta[2] * x 

# Then we'll calculate the residuals (observed minus predicted)
segments(x, preds, x, y, col="goldenrod2") #shows the residuals
r <- y - preds

# And here is a special diagnostic for linear normal models, called Cook's
# statistic, that measures the influence of a data point. We'll use the built in
# function to calculate it. This only works for an `lm()` fitted object.
cooks <- cooks.distance(fit) 

# Cook's statistic is a "deletion diagnostic". In `model_checking_likelihood.R`
# we'll look at a more general algorithm for deletion diagnostics that can be
# applied to any model, including multilevel models, to identify influential
# data points.


#----Diagnostic plots-----------------------------------------------------------
par(mfrow=c(2,2))

# 1. histogram of residuals assessed against theoretical distribution
hist(r, xlab="Residuals", main="Histogram of residuals", freq=FALSE)
rseq <- seq(min(r), max(r),  length.out=100)
lines(rseq, dnorm(rseq, mean=0, sd=sd(r)), col="red")

# 2. Residuals vs predicted (fitted)
plot(preds, r, ylab="Residuals", xlab="Fitted values",
     main="Residuals vs fitted")
abline(h=0, col="red")

# 3. Quantile-quantile plot
qqnorm(r)
qqline(r, col="red")
# See quantiles_&_qqplots.R for a tutorial on quantiles and Q-Q plots

# 4. Cooks distance (case deletion diagnostic)
plot(1:length(cooks), cooks, ylab="Cooks distance", xlab="Index of data",
     main="Influence")

# Several of these, or variants, are also produced by R's linear regression
# tools. An additional diagnostic provided here is *leverage*. Leverage is a
# problem associated with linear models and GLMs. The general idea is that a
# point with high leverage is an influential point in a special way: typically
# it is at one end of the independent variable and it is far from the fitted
# line relative to other points. Because of the geometry, the point "pulls" on
# the line like a lever, thus affecting the estimate of the slope.

par(mfrow=c(3,2))
plot(fit, 1:6, ask=FALSE)
?plot.lm

