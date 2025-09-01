#### Programming problems on selection structures

**Due:** Friday 5 Sep 11:59 PM

**Grading criteria:** Answer all the questions completely. On time submission.

**Format for submitting solutions:**

* Submit only one file of R code and one file of Python code.
* The filenames should be `coding_assignment1.R` and `coding_assignment1.py` but you can add any prefixes to the filename that work with your file naming scheme. 



**Push your files to your GitHub repository**. To push, you first commit to your local repository, then do

```bash
git push
```



**Learning goals:**

* Practice writing selection structures
* Analyze the program flow of algorithms
* Practice debugging programs
* Practice following coding style guides
* Build flexibility in multiple languages



You must not use any R or Python packages/libraries for these problems, only straight up structured code from scratch.

* For R, follow the class coding style in [ebio5460_r_style_guide.md](skills_tutorials/ebio5460_r_style_guide.md).

* For Python, follow the [PEP 8 official Python style guide](https://peps.python.org/pep-0008/).

* At the very least, these two style guides should give you an appreciation that coding style is quite arbitrary!



##### Single selection structure

```R
# R
if ( condition ) {
    expression
}
```

```python
# Python
if condition:
    expression
```



**Question 1**

Write an R selection structure that will change the status of migrate to TRUE if day length is greater than 11. Regardless, migration state should be printed at the end.

```R
daylength <- 13
migrate <- FALSE
# ... selection structure here
print(migrate)
```



**Question 2**

Write a Python selection structure that will print "Time to fly away!" if the status of migrate is True.

```python
migrate = True
# ... selection structure here
```



##### Question 3

What goes wrong with the following R code and why? (Provide your answer as a comment). Fix the code.

```R
temperature <- -5
if ( temperature < -2 )
    print("Temperature stress detected")
    print("Plant mortality likely")
```



##### Question 4

What goes wrong with the following Python code and why? (Provide your answer as a comment). Fix the code.

```python
temperature = 55
if temperature > 50:
    print("Temperature stress detected")
print("Plant mortality likely")
```



##### Question 5

Why doesn't the following R code work as intended?  Provide your answer as a comment. Fix the code while **retaining the single selection structures**.

```R
fire_possible <- TRUE
tree_density <- 100

if ( fire_possible ) {
    if ( tree_density > 80 ) {
        print("There is a fire disturbance, trees burn down")
        tree_density <- 0
    }
    if ( tree_density <= 80 ) {
        print("No fire disturbance")
    }
}
```



##### Double selection structure

```R
# R
if ( condition ) {
    expression_1
} else {
    expression_2
}
```

##### 

```python
# Python
if condition:
    expression_1
else:
    expression_2
```



##### Question 6

Fix the algorithm in (Q5) using a double selection structure but provide Python code instead of R. Which option works best, stacked single selection structures or a double selection structure, and why? (Provide your answer as a comment).



##### Question 7

Fix the following R code

```R
genotype <- "Aa"

if ( genotype == "aa" ) {
    print("Recessive")
}
print("Dominant")
```



##### Multiple selection structure

```R
# R
if ( condition1 ) {
    expression_1
} else if {
    expression_2
} else {
    expression_3
}
```

```python
# Python
if condition:
    expression_1
elif:
    expression_2
else:
    expression_3
```



**Question 8**

Write a selection structure in R that will print the type of species based on the input trophic level.

| Trophic level | Type of species |
| ------------- | --------------- |
| 1             | "Producer"      |
| 2             | "Herbivore"     |
| 3             | "Carnivore"     |
| other         | "Unknown"       |



**Nested selection structures**



**Question 9**

An amphibian prefers wet habitats, but only if temperature is also above 15°C. Write a selection structure in Python that will print one of "Habitat suitable", "Habitat too cold", "Habitat too dry" depending on the combination of environmental conditions.

```python
habitat = "wet"
temp = 16

# ... selection structure here
```



##### Question 10

Where should I put indents? Modify the following code to produce the patterns shown in tables (a) and (b) depending on the input. You may not make any changes other than adding spaces. Hint: decide when to stack or nest the selection structures.

```R
pattern = ""

if y == 2:
if x == 1:
pattern = pattern + "@"
else:
pattern = pattern + "#"
pattern = pattern + "$"
pattern = pattern + "&"

print(pattern)
```

You will also need to add assignment statements for `y` and `x` before this code so you can vary the input values of `y` and `x`, e.g.

```R
y = 3
x = 1
```

Your answer will require separate code (separate answers) for each of table (a) and table (b).

| Table (a)       | Case 1       | Case 2       | Case 3       |
| --------------- | ------------ | ------------ | ------------ |
| With input:     | y = 3, x = 1 | y = 2, x = 3 | y = 2, x = 1 |
| Pattern output: | `&`          | `# $ &`      | `@ $ &`      |

A single algorithm should produce all of the patterns in table (a) by changing only the input values of y and x. 

| Table (b)       | Case 1       | Case 2       | Case 3       |
| --------------- | ------------ | ------------ | ------------ |
| With input:     | y = 3, x = 1 | y = 2, x = 3 | y = 2, x = 1 |
| Pattern output: | `# $ &`      | `&`          | `@ &`        |

A single algorithm should produce all of the patterns in table (b) by changing only the input values of y and x.

