# Data generating process for a descriptive model
# linear normal model

# Linear model skeleton

lin_skel <- function(b_0, b_1, x) {
    y <- b_0 + b_1 * x
    return(y)
}

# Use it
b_0 <- 1
b_1 <- 2
x <- seq(0, 100, by=5)

y <- lin_skel(b_0, b_1, x)
plot(x,y)


# Add stochastic component to the model for DGP

lin_norm_dgp <- function(b_0, b_1, x, sigma) {
    n <- length(x)
    mu <- lin_skel(b_0, b_1, x)
    y <- rnorm(n, mean=mu, sd=sigma)
    return(y)
}

# Generate data
# Try running many times to get a feel for variation in realizations

sigma <- 50
y_gen <- lin_norm_dgp(b_0, b_1, x, sigma)
plot(x, y_gen, ylim=c(0,250))

