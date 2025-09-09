# Problem 1

# A population starts with 2 individuals. Each generation, it doubles in size.
# What is the population size after 20 generations?

max_gen = 20
N = 2
g = 0
while g < max_gen:
    N = N * 2
    g = g + 1

print(N)


# Problem 2

# How many generations does it take to exceed 10,000?
# What is the population size then?

N = 2
g = 0
while N <= 10000:
    N = N * 2
    g = g + 1

print(g)
print(N)


# Problem 3

# Stop if population size is more than a billion
# or
# generation is more than 100

N = 2
g = 0
while N <= 1e9 and g <= 100:
    N = N * 2
    g = g + 1

print(g)
print(N)
