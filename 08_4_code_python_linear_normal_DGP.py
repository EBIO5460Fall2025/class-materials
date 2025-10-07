import numpy as np
import matplotlib.pyplot as plt

# Start RNG with seed for reproducibility

rng = np.random.default_rng(1029839)


# Linear deterministic skeleton
# y = b_0 + b_1 * x

def lin_skel(x, b_0, b_1):
    y = b_0 + b_1 * x
    return y


# Linear Normal model for data generating process
# y ~ Normal(mu, sigma)

def lin_norm_dgp(x, b_0, b_1, sigma, rng):
    mu = lin_skel(x, b_0, b_1)
    y = rng.normal(loc=mu, scale=sigma, size=np.shape(mu))
    return y


# Set parameters

b_0 = 1     # intercept
b_1 = 2     # slope
sigma = 36  # standard deviation of the error

# Range of x from 0 to 100 (inclusive), evenly spaced

n = 21
x = np.linspace(0.0, 100.0, num=n)  # Evenly spaced from 0 to 100

# Simulate data

y = lin_norm_dgp(x, b_0, b_1, sigma, rng)

# Plot

plt.figure() #initialize plotting space
plt.plot(x, y, marker='o', linestyle="", color="blue", fillstyle="none")
plt.xlabel("x")
plt.ylabel("y")

# Add deterministic skeleton to plot

mu = lin_skel(x, b_0, b_1)
plt.plot(x, mu, color="black", linewidth=1)

