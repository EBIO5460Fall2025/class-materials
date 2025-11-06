# Exploring the Poisson stochastic model
# Useful for modeling data generating processes involving counts 

mu <- 2.1
y <- rpois(n=10000, mu)
hist(y, freq=FALSE, breaks=seq(min(y)-0.5, max(y)+0.5, by=1), ylab="Probability")

var(y)
mean(y)

# Variance is equal to the mean

mu_grid <- seq(0, 250, 10)
y_mu <- rep(NA, length(mu_grid))
y_var <- rep(NA, length(mu_grid))

i <- 1
for ( mu in mu_grid ) {
    y <- rpois(n=1000, mu)
    y_mu[i] <- mean(y)
    y_var[i] <- var(y)
    i <- i + 1
}

plot(y_mu, y_var)
abline(a=0,b=1)
