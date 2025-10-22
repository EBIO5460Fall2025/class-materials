import numpy as np
import matplotlib.pyplot as plt

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

rng = np.random.default_rng(seed=3569807)
pop_size = 1000000  #Let's say it has a million individuals
true_weights = rng.normal(loc=0.1, scale=0.02, size=pop_size) #representing biology; deterministic skeleton + stochasticity
print(true_weights[1:100])  #the population
true_mean = np.mean(true_weights)
print(true_mean)   #The actual known mean weight of this population

# Now simulate the sampling distribution
# We are imagining the many ways we could have sampled the population

reps = 100000 #higher gives closer to true sampling distribution
n = 25        #sample size; try varying this

mean_weights = np.full(reps, np.nan)
for i in range(reps):
    # Sampling (part 2 of the data generating process, the science part)
    sample_weights = rng.choice(true_weights, n, replace=False)
    # sample statistic (we can also think of this as a simple model for the deterministic skeleton; linear, intercept only)
    mean_weights[i] = np.mean(sample_weights)
    if i % 500 == 0:
        print(i)  #monitor progress

plt.figure()
plt.hist(mean_weights, bins=50, edgecolor='black')
plt.title("Sampling distribution of beetle mean weight")
plt.xlabel("Mean weight")
plt.ylabel("Frequency")

print(np.mean(mean_weights))
print(np.std(mean_weights))

