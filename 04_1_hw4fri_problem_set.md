# Programming problems on repetition structures



**Due:** Friday 11 Sep 11:59 PM

**Grading criteria:** Answer all the questions completely. On time submission.

**Format for submitting solutions:**

* Submit only one file of R code and one file of Python code.
* The filenames should be `coding_assignment2.R` and `coding_assignment2.py` but you can add any prefixes to the filename that work with your file naming scheme. 

**Push your files to your GitHub repository**



## Learning goals

* Practice using repetition structures
* Use `while` to implement both sentinel- and counter-controlled repetition
* Solve problems by combining sentinel control with auxiliary counters
* Develop algorithms to model ecological and evolutionary processes
* Convert process descriptions and problem statements into algorithms
* Analyze the program flow of algorithms
* Practice debugging programs
* Practice following coding style guides
* Build flexibility in multiple languages



For these problems, only use the basic selection and repetition structures covered in class and the basic arithmetic operators (e.g. `+` `-` `/` `*`). Do not use any libraries/packages, or functions other than `print()`.

* For R, follow the class coding style in [ebio5460_r_style_guide.md](skills_tutorials/ebio5460_r_style_guide.md)
* For Python, follow the [PEP 8 official Python style guide](https://peps.python.org/pep-0008/)



Get help or ask questions on [our Piazza forum]( https://piazza.com/colorado/fall2025/ebio5460002/home)!



## While repetition structure



### Sentinel control

```R
# R
while ( condition ) {
    expression
}
```

```python
# Python
while condition:
    expression
```



### Counter control

```R
# R
i <- 0
while ( i < n ) {
    expression
    i <- i + 1
}
```

```python
# Python
i = 0
while i < n:
    expression
    i = i + 1
```



### Question 1

What is wrong with the following Python code? (Provide your answer as a comment). Fix the code, making some assumptions about what it is supposed to do.

```R
number = 100
while number <= 100:
    print(number)
    number = number - 1
```



### Question 2

Write an algorithm in R using a `while` structure to model the following ecological process and answer the question.  An invasive riparian plant colonizes at the river mouth and spreads upstream 700 m per year, more or less in annual jumps. How many years until it has spread at least 5 km upstream? The algorithm should print the answer.

> Hints:
>
> Model the process directly as it reads, year by year (what happens this year, then what happens next?)
>
> Counter control or sentinel control? Do we need a counter?

> It's always a good idea to devise tests of a computational algorithm. For this question there is an obvious way to answer the question with simple math. Check your algorithm against the mathematical calculations.



### Question 3

Follows from Q2. How far has it spread upstream after 13 years? The algorithm should print the answer.

> Hints:
>
> Counter control or sentinel control?



### Question 4

Write an algorithm in Python using a `while` structure to model the following ecological process and answer the question.  A population is declining with a discrete-time growth rate, R of 0.9. If the population starts with 1000 individuals, how many generations until it falls below a quasi-extinction threshold of 2 individuals? The algorithm should print the answer.

> Hints:
>
> The population size each generation is R multiplied by population size in the previous generation.
>
> Counter control or sentinel control? Do we need a counter?



### Question 5

Write an algorithm in R using a `while` structure to model the following ecological process and answer the question.  Using the pre-dawn hours to avoid predation, a school of herbivore fish consumes 0.1 kg per square meter per day of seagrass. The seagrass meadow increases it's biomass 10% per day. If the seagrass starts off with a biomass of 1 kg per square meter, how many days will it take to eat the seagrass down to nothing?

> Hints:
>
> Write an algorithm to carry out these within-year events step by step. Which comes first, consumption or biomass growth?
>
> Counter control or sentinel control? Do we need a counter?



### Question 6

Write an algorithm in Python using a `while` structure to model the following ecological process and answer the question. Each year a population typically produces 0.2 births per individual at the start of the year. Over the course of a year, typically 30% of these immature individuals die. In addition, 5% of the mature individuals also die. If the population starts with 1000 individuals, how large is the population after 20 years? The algorithm should print the answer.

> Hints:
>
> Counter control or sentinel control?
>
> Carry out these within-year events step by step: first model births (calculate how many), then model deaths for each of the two age classes. The total population size, N, at the end of the year is N from the previous year plus births minus deaths.



### Question 7

Follows from Q6. Overall, how many individuals were born into the population over the 20 years? The algorithm should print the answer. 

> Hints:
>
> Add to your algorithm a variable to keep a running sum of births



## Problems combining while and if or if/else



### Question 8

Follows from Q4. Print the density of the declining population every fifth generation, including generation 0. Also print the final generation.

> Hint:
>
> y mod x equals zero when y is perfectly divided by x. The modulus operator in Python is `%`.



### Question 9

Follows from Q5. What would happen if once a week on Tuesday a fishing boat scares away the fish so they don't consume any seagrass? Start your simulation on Friday morning.

> Hint:
>
> One way would be to model days of the week as numbers from 1 to 7.



## Multiple counters, counting up and down



### Question 10

A series of five islands is colonized by species 1 to 5 and the island communities form nested subsets. In (a)-(e) below, each island is represented by a row. Species in columns are listed in order of abundance. A general process described by the following algorithm determines the patterns of nestedness.

```python
j = ?
while j ?
    i = ?
    while i ?
        print(i, end=" ")  # i followed by space, no newline
        i = i ?
    print("")              # newline
    j = j ?
```

Question marks indicate simple rules that can vary. Insert the rules to produce the following patterns of community composition. Write the algorithm for each pattern in Python. Other than the question marks, nothing else can be changed.

a)

```
1
1 2 
1 2 3 
1 2 3 4 
1 2 3 4 5
```

b)

```
1 2 3 4 5
1 2 3 4 
1 2 3 
1 2 
1
```

c)

```
5 4 3 2 1 
4 3 2 1 
3 2 1 
2 1 
1 
```

d)

```
1 
2 1 
3 2 1 
4 3 2 1 
5 4 3 2 1
```

e)

```
5 4 3 2 1 
5 4 3 2
5 4 3 
5 4
5 
```

