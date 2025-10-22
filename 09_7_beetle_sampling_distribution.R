# First simulate our population 

# This is the biological part of the data generating process. It consists of a
# deterministic skeleton (the target mean) and a stochastic component
# (represented by a Normal distribution).

# Let's say the weights of individuals in the population follow a normal
# distribution. This is arbitrary, and it could in fact be any kind of
# distribution. Let's say the mean weight of an individual in the population is
# around 0.1 grams (which seems the right ballpark for the species shown in the
# picture) with a standard deviation around 0.02 (weights vary by about 20% of
# the mean).

set.seed(3569807)
pop_size <- 1000000  #Let's say it has a million individuals
true_weights <- rnorm(pop_size, mean=0.1, sd=0.02)  #representing biology; deterministic skeleton + stochasticity
true_weights[1:100]  #the population
true_mean <- mean(true_weights)
true_mean   #The actual known mean weight of this population

# Now simulate the sampling distribution
# We are imagining the many ways we could have sampled the population

reps <- 100000 #higher gives closer to true sampling distribution
n <- 25        #sample size; try varying this

mean_weights <- rep(NA, reps)
for ( i in 1:reps ) {
    # Sampling (part 2 of the data generating process, the science part)
    sample_weights <- sample(true_weights, n)
    # sample statistic (we can also think of this as a simple model for the
    # deterministic skeleton; linear, intercept only)
    mean_weights[i] <- mean(sample_weights)
    if ( i %% 500 ==0 ) {
        print(i)  #monitor progress
    }
}
hist(mean_weights, breaks=50, main="Sampling distribution of beetle mean weight")
mean(mean_weights)
sd(mean_weights)
