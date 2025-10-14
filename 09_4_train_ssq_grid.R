
# Grid search of model parameters

# First generate some fake data to work with

set.seed(4.6) #make example reproducible
n <- 30    #size of dataset
b_0 <- 20   #true y intercept
b_1 <- 10   #true slope
s <- 20    #true standard deviation of the errors
x <- runif(n, min=0, max=25)   #nb despite runif, x is not a random variable
y <- b_0 + b_1 * x + rnorm(n, sd=s)   #random sample of y from the population
mydata <- data.frame(x, y)
rm(n, b_0, b_1, s, x, y)   #clean up

plot(mydata$x, mydata$y, ylim=c(0,300))


# Model for the biology (e.g. linear deterministic skeleton)

lin_skel <- function(b_0, b_1, x) {
    return(b_0 + b_1 * x)
}


# Train the model by grid search

# Initialize parameters
# Where to start? Look at the data, biological knowledge etc

b_0_grid <- seq(10, 50, length.out=200)
b_1_grid <- seq(5, 15, length.out=200)

# Initialize storage object (here I use a matrix)

n <- length(b_0_grid) * length(b_1_grid)
results <- matrix(NA, n, 3)
colnames(results) <- c("b_0", "b_1", "ssq")

# Grid search over the two parameters: b_0 and b_1

i <- 1 #row index for results matrix
for ( b_0 in b_0_grid ) {
    for ( b_1 in b_1_grid ) {

    #   Calculate model predictions
        y_pred <- lin_skel(b_0, b_1, mydata$x)

    #   Calculate deviations and sum of squares
        e <- mydata$y - y_pred
        ssq <- sum(e^2)

    #   Keep the results
        results[i,] <- c(b_0, b_1, ssq)
        i <- i + 1

    }
#   Monitor progress
    print(paste(round(100 * i / n), "%", sep=""), quote=FALSE)
}

# Find the minimum SSQ

ssq_min_row <- which.min(results[,3])
opt_pars <- results[ssq_min_row,]
ssq_min <- opt_pars["ssq"]
opt_pars


# Plot sum of squares profiles

# Profile for b_0

plot(results[,"b_0"], results[,"ssq"], main="SSQ profile for b_0")

# What is going on here? Dominated by bad fits. Adjust y axis limits.

scale <- 1.2  #This is a zoom setting. Must be > 1. Smaller is zooming in.
par(mfrow=c(1,2))
plot(results[,1], results[,3], xlab="b_0", ylab="Sum of squares",
     ylim=c(ssq_min, scale * ssq_min))
plot(results[,2], results[,3], xlab="b_1", ylab="Sum of squares",
     ylim=c(ssq_min, scale * ssq_min))
mtext("Sum of squares profiles - grid search", outer=TRUE, line=-2.5)

# Now we can clearly see the basins of the SSQ for each parameter.
# Basin is underside of this U-shaped profile
# Best-fit parameter value at the bottom of the basin
# Points filling in the interior are SSQ for other parameter combinations

# Algorithm works! Found the basin.
# Next: adjust ranges for higher precision
# Profiles indicate uncertainty (wider = more uncertainty)

# Plot the trained model with the data. Does it make sense?
plot(mydata$x, mydata$y, ylim=c(0,300))
xx
y_pred
lines
