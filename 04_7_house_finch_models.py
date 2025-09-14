# House finch models

# Principles illustrated
#
# 1) Models can be expressed as algorithms that encode biological events
# 2) A good strategy is building incrementally from simple models to complex
#    models
# 3) We end up with a suite of models that we can use to explore our
#    understanding of the biological system and varying with levels of
#    complexity that might be supported by the data we have or want to collect


# 1. Simplest model

# Parameters
R = 1.1

# Initialize variables
N = 100
t = 0

# Population dynamics
while t < 20:
    N = R * N
    print(N)
    t = t + 1


# 2. Next level of complexity: 2 parameters

# Parameters
b = 0.2
d = 0.1

# Initialize variables
N = 100
t = 0

# Population dynamics
while t < 20:
    births = b * N
    deaths = d * N
    N = N + births - deaths
    print(N)
    t = t + 1


# 3. Next level of complexity: 5 parameters

# Parameters
p_fem = 0.5
p_breed = 0.8
clutch_size = 3
d_chick = 1 / 3
d_adult = 0.1

# Initialize variables
N = 100
t = 0

# Population dynamics
while t < 10:
    F_breed = p_fem * p_breed * N
    births = F_breed * clutch_size
    deaths_chicks =  births * d_chick
    deaths_adults = N * d_adult
    N = N + births - deaths_chicks - deaths_adults
    print(N)
    t = t + 1


# 4. Next level of complexity: 6 parameters

# Parameters
p_fem = 0.5
p_breed = 0.8
nests_max = 200
clutch_size = 3
d_chick = 1 / 3
d_adult = 0.1

# Initialize variables
N = 100
t = 0

# Population dynamics
while t < 1000:
    F_breed = p_fem * p_breed * N
    if F_breed > nests_max:
        F_breed = nests_max
    births = F_breed * clutch_size
    deaths_chicks =  births * d_chick
    deaths_adults = N * d_adult
    N = N + births - deaths_chicks - deaths_adults
    print(N)
    t = t + 1


# 5. Next level of complexity: 7 parameters

# Parameters
p_fem = 0.5
p_breed = 0.8
nests_max = 200
clutch_size = 3
s_chick_max = 0.9
alpha = s_chick_max / 1000
d_adult = 0.1

# Initialize variables
N = 100
t = 0

# Population dynamics
while t < 20:
    F_breed = p_fem * p_breed * N
    if F_breed > nests_max:
        F_breed = nests_max
    births = F_breed * clutch_size
    s_chick = s_chick_max - alpha * N
    if s_chick < 0:
        s_chick = 0
    deaths_chicks =  births * (1 - s_chick)
    deaths_adults = N * d_adult
    N = N + births - deaths_chicks - deaths_adults
    print(N)
    t = t + 1

