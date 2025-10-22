# Some beginnings for the grid search algorithm

```python
for b_0 in b_0_grid:
    
    for b_1 in b_1_grid:

        # calculate model predictions
        y_pred = b_0 + b_1 * x    #or call the previously defined lin_skel() function

        # calculate deviations
        e = y - y_pred

        # sum squared deviations
        ssq = np.sum(e * e) #or e**2
```

We're going to need the numpy library and matplotlib. Import at the top of the script.

```python
import numpy as np
import matplotlib.pyplot as plt
```

Reference for the numpy library

* [Basics](https://numpy.org/doc/stable/user/absolute_beginners.html) (arrays, indexing, etc)
* [Random numbers](https://numpy.org/doc/stable/reference/random/index.html#numpyrandom)
   * [Distributions](https://numpy.org/doc/stable/reference/random/generator.html#distributions)
   * [Normal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.normal.html#numpy.random.Generator.normal)
* [Math](https://numpy.org/doc/stable/reference/routines.math.html)


We'll need to read in data. Use numpy to read in a CSV (comma separated values) file.

```python
data = np.loadtxt("xy_data.csv", delimiter=",", skiprows=1)  # skip header row (can't mix types)
type(data)
type(data[0, 0])
data.shape
print(data)
print(data[:, 0]) #indexing column 1
print(data[:, 1]) #indexing column 2
```

We need to initialize a grid of values to search over. We could use the function `linspace` from `numpy`, e.g.

```python
b_0_grid = np.linspace(10, 20, 51)
```

We'll need to store values. Ways to initialize numpy arrays include:

```python
np.ones((n,1))    #n rows, 1 column
np.zeros((n,1))
np.full((n,1), fill_value=np.nan) #like NA in R
np.full((n,3), fill_value=np.nan) #n rows, 3 columns
```

We'll need to add a counter to keep track of what row we're up to. Don't forget to start from zero

```python
i = 0
...
results[i, 0] = ...
i += 1
```

To find which row is the minimum of a column, we could write a function to scan over the column but it's much simpler to use `np.argmin()`, e.g. to find which row is the minimum in column 3 of the matrix `results`:

```python
min_row = np.argmin(results[:, 2])
```

Plotting with matplotlib

```python
# Basic scatterplot
plt.figure()
plt.plot(x, y, marker='o', linestyle="", color="blue", fillstyle="none")
plt.ylim(0, 1000)
plt.xlabel("Axis text")

# New plot
plt.figure()
...

# Add a line
plt.plot(x, y_pred, color="black", linewidth=1)
```





