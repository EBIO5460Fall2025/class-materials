# Data generating process for a descriptive model
# Linear normal model

# Linear model skeleton

lin_skel <- function(b_0, b_1, x) {
    y <- b_0 + b_1 * x
    return(y)
}

# Intialize parameters

b_0 <- 1
b_1 <- 2

# Use function for a single value of x

x <- 4.672
y <- lin_skel(b_0, b_1, x)
y


# This function will also work vectorized
# Input a vector of x values

x <- seq(0, 100, by=5)
y <- lin_skel(b_0, b_1, x)
plot(x, y)

# or random x values ... but remember we are assuming that x is not measured
# with error, so this is modeling random known values of x and the outcome of y
# is still deterministic, so the plot is a perfect straight line.

x <- runif(21, 0, 100)
y <- lin_skel(b_0, b_1, x)
plot(x, y)

# This would be the data if the biological process was entirely deterministic
# and there was no observation error. To model a data generating process we need
# to add stochastic components to the model.

# First model the full step-by-step algorithm.

# The basic data story of the descriptive model is that there is some underlying
# deterministic biological component that determines the pattern but mixed in
# with the determinism are stochastic biological processes that add noise.
# Ultimately, the stochastic model represents processes that we don't know
# about. The actual biological outcome is the result of this combination of
# determinism and stochasticity. On top of that, there is error in the
# observation process. The data we observe (e.g. number of individuals in a
# population) may not be the true values but estimates of them (e.g samples) or
# error-prone recordings of them (e.g. miscounts, wrong species identifications,
# unobserved individuals, noisy instruments etc).

# To illustrate, we can tell this data story for a single observation, with its
# unique value of x (we are assuming that x is measured without error)

x <- 23.7

# Model the deterministic skeleton

mu <- lin_skel(b_0, b_1, x)
mu

# Model the biological process error (one value for y drawn from a Normal
# distribution)

sigma_bio <- 30
y_bio <- rnorm(1, mean=mu, sd=sigma_bio)
y_bio

# This result is the outcome of the biological processes, representing the true
# state of the study system. On top of this biological stochasticity, we now
# model taking an observation of the system but with error in the measurement of
# the true value y_bio (one value for y drawn from a Normal distribution).

sigma_obs <- 20
y_obs <- rnorm(1, mean=y_bio, sd=sigma_obs)
y_obs

# So, there are now three values involved, the deterministic component, the true
# biological outcome, and the observed outcome

c(deterministic = mu, true_bio = y_bio, observed = y_obs)

# Run the lines of code above from the beginning of the data story a few times
# to get an idea of the variability to expect among realizations. Think of it as
# imagining what might have happened if the processes were run again.

# This leads to the following general algorithm (pseudocode) for a collection of
# observations:

# for each data point (value of x)
#     start with the deterministic skeleton
#     model biological process error
#     model observation error

# Next, we'll look at several detailed but equivalent variations of this
# algorithm where the deterministic skeleton is linear and the process and
# observation error are modeled as Normal distributions.


# Algorithm 1

# The deterministic skeleton represents the mean of a Normal stochastic process
# for the biology, while the true y (y_bio) represents the mean of a Normal
# stochastic process for the observation. Here, the output from the previous
# step is the input mean of the stochastic process in the next step.

lin_norm_dgp_alg1 <- function(b_0, b_1, x, sigma_bio, sigma_obs) {
    n <- length(x)
    y_obs <- rep(NA, n)
    for ( i in 1:n ) {
        mu <- lin_skel(b_0, b_1, x[i])
        y_bio <- rnorm(1, mean=mu, sd=sigma_bio)
        y_obs[i] <- rnorm(1, mean=y_bio, sd=sigma_obs)
    }
    return(y_obs)
}

# Use the function
sigma_bio <- 30
sigma_obs <- 20
#x <- seq(0, 100, by=5)  #perhaps a designed experiment or survey
x <- runif(21, 0, 100)  #perhaps an opportunistic survey
y <- lin_norm_dgp_alg1(b_0, b_1, x, sigma_bio, sigma_obs)
plot(x, y)


# Algorithm 2

# Biological process error and observation error are modeled as deviations from
# the deterministic skeleton and true y (y_bio) respectively. Here, the
# deviations are added to the output from the previous step.

lin_norm_dgp_alg2 <- function(b_0, b_1, x, sigma_bio, sigma_obs) {
    n <- length(x)
    y_obs <- rep(NA, n)
    for ( i in 1:n ) {
        mu <- lin_skel(b_0, b_1, x[i])
        y_bio <- mu + rnorm(1, mean=0, sd=sigma_bio)
        y_obs[i] <- y_bio + rnorm(1, mean=0, sd=sigma_obs)
    }
    return(y_obs)
}

# Use this function
y <- lin_norm_dgp_alg2(b_0, b_1, x, sigma_bio, sigma_obs)
plot(x, y)


# The above two algorithms are equivalent in this special case of two Normal
# stochastic processes. This usually won't be the case when the stochastic
# processes have qualitatively different distributions. Algorithm 1 can be
# applied more generally with mixed distributions.

# Furthermore, we have assumed that the biological and observation process
# errors are independent. A little bit of fundamental statistical theory tells
# us that the combination, or sum, of two Normal distributions is also Normal
# but with the variance of the two distributions added together (you should try
# confirming this by simulation!). Again, this often isn't the case with mixed
# distributions but here it means we can reduce the complexity of the model by
# combining the biological and observation processes into one distribution:

# Algorithm 3

lin_norm_dgp_alg3 <- function(b_0, b_1, x, sigma) {
    n <- length(x)
    y_obs <- rep(NA, n)
    for ( i in 1:n ) {
        mu <- lin_skel(b_0, b_1, x[i])
        y_obs[i] <- rnorm(1, mean=mu, sd=sigma)
    }
    return(y_obs)
}

sigma <- sqrt(sigma_bio^2 + sigma_obs^2) #variances (sigma^2) are additive
y <- lin_norm_dgp_alg3(b_0, b_1, x, sigma)
plot(x, y)


# Finally, that for loop is not very efficient and we can vectorize that step
# instead.

# Algorithm 4

# Now the mean argument in the rnorm() function is a vector and 1 random draw is
# made for each value of x at its corresponding value of mu, just as in the
# `for` repetition structure above.

lin_norm_dgp <- function(b_0, b_1, x, sigma) {
    n <- length(x)
    mu <- lin_skel(b_0, b_1, x)
    y <- rnorm(n, mean=mu, sd=sigma)
    return(y)
}

# Generate data

y <- lin_norm_dgp(b_0, b_1, x, sigma)
plot(x, y)

# 8 realizations of this process
# Recall that variation among realizations is entirely due to variation in y.
# The x values are the same among these realizations.

par(mfrow = c(2,4), mar=c(4,4,0,0.2))
for ( i in 1:8 ) {
    y <- lin_norm_dgp(b_0, b_1, x, sigma)
    plot(x, y)
}
