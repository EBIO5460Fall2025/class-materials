# Homework



**Due:** Tuesday 30 Sep 3:30 PM (i.e. before class)

In class, you'll continue to use this example for the topic of functions.

**Grading criteria:** Make a complete attempt. Code compiles and runs. On time submission.

**Format for submitting solutions:**

* Submit one file of C code, one binary executable program, and one text file with timings.
* The filenames should be `squirrel.c`, `squirrel` and `squirrel.txt` but you can add any prefixes to the filename that work with your file naming scheme. 

**Push your files to your GitHub repository**



## Learning goals

* Implement a C program
* Understand and use data types
* Use a compiler
* Generate random numbers in C
* Practice using C programming structures
* Develop flexibility in programming languages
* Practice following coding style guides



For C, follow the class coding style for R in [ebio5460_r_style_guide.md](skills_tutorials/ebio5460_r_style_guide.md)

Get help or ask questions on [our Piazza forum]( https://piazza.com/colorado/fall2025/ebio5460002/home)!



## Reimplementing the squirrel finding a nut in C

Convert your R algorithm (or my version if you prefer) to C.

Use a stopwatch to time the C version and the R version. How much faster is the C version? (include your answer in the text file)



### Tips

* Because R style is so similar to C, it's fairly straightforward for most of the code

* One of the important things you need to do is decide what type of variable everything needs to be. Use double precision for floating point numbers (i.e. `double`)

* Generating random numbers in C

* Here's an example showcasing a few techniques you might need. This program tests whether the random number generator matches the expected probability. Change `p_event` to try different probabilities.

```c
#include <stdio.h>
#include <stdlib.h> //for drand48()

#define SEED 5520629
#define NUMREPS 1000000

int main(void) {

    double p_event = 0.5;
    int event; //0 is False, 1 is True
    int sum = 0;
    double proportion;

    // Seed the random number generator
    srand48(SEED);

    // drand48() generates a random number between 0 and 1
    for ( int i = 0; i < NUMREPS; i++) {
        if ( drand48() < p_event ) {
            event = 1;
        } else {
            event = 0;
        }
        if ( event ) {
        	sum++;   
        }
    }
    
    proportion = (double)sum / NUMREPS; //cast int to double
    printf("Proportion of times event occurs: %f\n", proportion);

    return 0;
}
```

* In C, if you divide one integer by another, the result is integer division. For example, 3 / 2 equals 1. To not get integer division, you need to convert an integer to a float (or double). This is called "casting".

* Similarly, if an expression involves only integers, you'll get integer division. This can be important when declaring variables. To prevent integer division, make at least one of the numbers a decimal.

  ```c
  double x = 1 / 6    #incorrect: integer division
  double x = 1.0 / 6  #correct
  ```

* Provide a seed for the random number generator, as above. I usually grab a `runif(1)` from R, and copy all the digits.

* I suggest using the preprocessor directive `#define` for the seed and the number of replicate simulations, as above.

* Declare all the variables in the program at the start of `main()`. Then start the random number generator. Then the algorithm.

* To get a random number between -15.5 and 15.5, you can do this

  ```c
  nut_x = drand48() * 31 - 15.5;
  ```

* Absolute values in C involve some library and compiling options that we're not ready for. Here's an easy way to get an absolute value:

  ```c
  x_dev = nut_x - x;
  if ( x_dev < 0 ) {
      x_dev = -1 * x_dev; //absolute value
  }
  ```

* Each loop, print the time to find a nut.

* You can collect the data into a file (instead of the screen) using a bash redirection:

  ```bash
  ./squirrel > time_to_nut.csv
  ```

* Then you can read the file in R and plot a histogram. Do you get the same result as for the R program?



