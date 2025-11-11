# Models for declining ant species richness as a function of latitude

# --- First develop some alternative models for the deterministic skeleton

# Latitude grid

latitude <- 0:90

# Piecewise linear model: hockey stick

beta_0 <- 200
beta_1 <- -3

mu <- rep(NA, length(latitude))
i <- 1
for ( lat in latitude ) {
    mu[i] <- max(0, beta_0 + beta_1 * lat)
    i <- i + 1
}
mu
plot(latitude, mu)

# Vectorized version    
mu <- beta_0 + beta_1 * latitude
mu <- ifelse(mu < 0, 0, mu)


# Exponential model

beta_0 <- log(200)
beta_1 <- -0.05
mu <- exp(beta_0 + beta_1 * latitude)
plot(latitude, mu)

# Logistic model

# Basic form gives range 0 to 1
# Playing with parameters gives a form that looks like what we imagined
beta_0 <- 5
beta_1 <- -0.1
mu <- exp(beta_0 + beta_1 * latitude) / (1 + exp(beta_0 + beta_1 * latitude))
plot(latitude, mu)

# Scale to expand species richness values (and rename parameters)
beta_0 <- 200
beta_1 <- 5
beta_2 <- -0.1
mu <- beta_0 * exp(beta_1 + beta_2 * latitude) / (1 + exp(beta_1 + beta_2 * latitude))
points(latitude, mu)


# Make these models into functions

hockey_stick <- function(beta_0, beta_1, latitude) {
    mu <- beta_0 + beta_1 * latitude
    mu <- ifelse(mu < 0, 0, mu)
    return(mu)
}

exponential <- function(beta_0, beta_1, latitude) {
    mu <- exp(beta_0 + beta_1 * latitude)
    return(mu)
}


logistic <- function(beta_0, beta_1, beta_2, latitude) {
    mu <- beta_0 * exp(beta_1 + beta_2 * latitude) / (1 + exp(beta_1 + beta_2 * latitude))
    return(mu)
}


# Plot all on one for comparison

latitude <- 0:90
plot(NA, NA, xlim=c(0,90), ylim=c(0,200),
     xlab="latitude", ylab="richness")

# Piecewise linear model: hockey stick
beta_0 <- 200
beta_1 <- -2.8
mu <- hockey_stick(beta_0, beta_1, latitude)
points(latitude, mu)
  
# Exponential model  
beta_0 <- log(200)
beta_1 <- -0.05
mu <- exponential(beta_0, beta_1, latitude)
points(latitude, mu, col="blue")

# Logistic
beta_0 <- 200
beta_1 <- 5
beta_2 <- -0.11
mu <- logistic(beta_0, beta_1, beta_2, latitude)
points(latitude, mu, col="red")


# --- Now add Poisson stochastic component to the deterministic skeleton

# e.g. hockey stick model
beta_0 <- 200
beta_1 <- -3.1
mu <- hockey_stick(beta_0, beta_1, latitude)
richness <- rpois(length(mu), mu)
plot(latitude, richness)

# We see that Poisson does not have the magnitude of variation we would expect in
# ecological data.

# Add variation to Poisson by combining with lognormal. This is a compound
# distribution and we refer to it as a Poisson-lognormal distribution. Why
# lognormal and not normal? Because normal would allow lambda to be negative and
# because lognormal will scale the variation proportional to the mean, whereas
# normal would have constant variation regardless of the mean.

# Data story: deterministic skeleton determines the mean richness among sites
# at a latitude but there is also variation among sites at that latitude. Model
# site variation as lognormal.

# At one latitude:

mu <- 100
sd <- 0.3 #variation among sites; 0.1 to 0.3 is about 10% to 30%

ln_lambda <- rnorm(10000, mean=log(mu), sd)
hist(ln_lambda) #normal

lambda <- exp(ln_lambda)
hist(lambda) #lognormal

# Now combine with Poisson variation at a site. We can vary sd to control the
# variation. 

richness <- rpois(10000, lambda)
hist(richness)


# Make a Poisson-lognormal function

rpoislnorm <- function(n, mu, sdlog) {
    ln_lambda <- rnorm(n, mean=log(mu), sd=sdlog)
    lambda <- exp(ln_lambda)
    return(rpois(n, lambda))
}


# Plot the three models with Poisson-lognormal
# Variance increases with the mean but faster than Poisson. This is much more
# realistic.

latitude <- 0:90
sd <- 0.2

# Piecewise linear model: hockey stick
beta_0 <- 200
beta_1 <- -3
mu <- hockey_stick(beta_0, beta_1, latitude)
richness <- rpoislnorm(length(mu), mu, sd)
plot(latitude, richness, main="Hockey stick", ylim=c(0, 350))
lines(latitude, mu)

# Exponential model  
beta_0 <- log(200)
beta_1 <- -0.05
mu <- exponential(beta_0, beta_1, latitude)
richness <- rpoislnorm(length(mu), mu, sd)
plot(latitude, richness, main="Exponential")
lines(latitude, mu)

# Logistic
beta_0 <- 200
beta_1 <- 5
beta_2 <- -0.1
mu <- logistic(beta_0, beta_1, beta_2, latitude)
richness <- rpoislnorm(length(mu), mu, sd)
plot(latitude, richness, main="Logistic")
lines(latitude, mu)


# A common alternative to the Poisson-lognormal compound distribution is the
# Poisson-gamma compound distribution. This is also known as the Negative
# binomial distribution. The data story is analogous. Variation in lambda among
# sites is modeled as a gamma distribution.

# Plot the three models with Poisson-gamma (aka Negative binomial)
# k is the dispersion parameter, which controls the among site variation.
# Paradoxically, variation is largest when k is near zero, and vanishes to the
# Poisson limit as k -> Inf.

latitude <- 0:90
k <- 20

# Piecewise linear model: hockey stick
beta_0 <- 200
beta_1 <- -3
mu <- hockey_stick(beta_0, beta_1, latitude)
richness <- rnbinom(length(mu), size=k, mu=mu)
plot(latitude, richness, main="Hockey stick", ylim=c(0, 350))
lines(latitude, mu)

# Exponential model  
beta_0 <- log(200)
beta_1 <- -0.05
mu <- exponential(beta_0, beta_1, latitude)
richness <- rnbinom(length(mu), size=k, mu=mu)
plot(latitude, richness, main="Exponential")
lines(latitude, mu)

# Logistic
beta_0 <- 200
beta_1 <- 5
beta_2 <- -0.1
mu <- logistic(beta_0, beta_1, beta_2, latitude)
richness <- rnbinom(length(mu), size=k, mu=mu)
plot(latitude, richness, main="Logistic")
lines(latitude, mu)

