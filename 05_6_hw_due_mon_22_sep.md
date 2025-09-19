# Homework



**Due:** Monday 22 Sep 11:59 PM

**Grading criteria:** Answer questions 3 & 4 with a complete attempt. On time submission.

**Format for submitting solutions:**

* Submit only one file of R code for questions 3 and 4.
* The filenames should be `coding_assignment3.R` but you can add any prefixes to the filename that work with your file naming scheme. 

**Push your file to your GitHub repository**



## Learning goals

* Practice modeling an ecological data generating process
* Practice combining repetition and selection structures
* Use `while` to implement sentinel-controlled repetition
* Use `for` to implement counter-controlled repetition
* Develop algorithms to model stochastic ecological processes
* Convert process descriptions and problem statements into algorithms
* Practice debugging programs
* Practice following coding style guides



For these problems, only use the basic selection and repetition structures covered in class (`while` `for`, `if`, `ifelse` etc) and the basic arithmetic operators (e.g. `+` `-` `/` `*`). Do not use any libraries/packages, or functions other than `runif(1)`, `rep()`, `print()`, `abs()`, `plot()`, `segments()`,  `hist()`.

* For R, follow the class coding style in [ebio5460_r_style_guide.md](skills_tutorials/ebio5460_r_style_guide.md)



Get help or ask questions on [our Piazza forum]( https://piazza.com/colorado/fall2025/ebio5460002/home)!




## 1. Skill of the week, git amend, .gitignore, Git GUI

* [git04_amend.md](skills_tutorials/git04_amend.md) - make minor updates without messing up your history
* [git05_gitignore.md](skills_tutorials/git05_gitignore.md) - how to not track all files
* [git06_gitgui.md](skills_tutorials/git06_gitgui.md) - how to invoke the GUI for basic tasks and explore your history



## 2. Feedback for me

Let me know how the class is going for you so far and provide any feedback or ideas. What's working or not working for you? Are there things you'd like me to do differently? Please fill out the anonymous qualtrics survey here:

   * https://cuboulder.qualtrics.com/jfe/form/SV_3mHygwu7alfirGK 1-3 mins



## 3. Time to move to the edge

Extending the Paramecium movement example from Tuesday's class, if the arena ends at (-15, 15) how long until an individual gets to the edge? Plot a histogram that shows the distribution of times. A large number of replicates will smooth out the histogram. Assuming we record the time without error, this is the distribution of the data generating process. It's handy to tweak the histogram to show more detail by increasing the number of bins. See the code from class. What makes sense for the bin width? This is an example of a time-to-event distribution.



### Tips

* Start by coding the algorithm for one replicate simulation
* Check your algorithm by carefully stepping through it
* Add a plot to visualize movement as another check (see below)
* Then add a `for` repetition structure to conduct repeated simulations



### Visualizing the simulation

One simple plot we could use here is time (y-axis) versus x (x-axis), or axes reversed if you prefer to emphasize time. But we don't know how long the simulation will go for each time. So, if we want to keep the simulated data to plot at the end, we don't know how large a vector to initialize. There are a few solutions to this problem, some that work well, and others that can greatly slow down the algorithm. A simple approach is to build the plot piece by piece as we go. This can't be done with ggplot (requires a completed data frame), so we'll use base R.

Start by initializing a blank plot (you might need to adjust the axis limits):

```R
plot(NA, NA, xlim=c(-15,15), ylim=c(0,250), xlab="x", ylab="t")
```

Then, at the end of each repetition through the while loop, draw the step that was made:

```R
segments(x_prev, t_prev, x, t)
```

where `x_prev` is the x position on the previous repetition at time `t_prev`, and `x`, and `t` are the current position and time. Store the current position `x` into the variable `x_prev` just before exiting the loop so that it's available to use in the next repetition.



## 4. Find the nut

Imagine now that we have a squirrel moving around its home range looking for nuts. For simplicity, let's make it a square 31 m to a side (15.5 m from the center to each edge). The home range is divided into 1 m grid cells, so we have 31 grid cells per side, and 15 grid cells on either side of the center (i.e the center of the center cell is at (0, 0)). Here are its movement rules:

* Can only move left or right, or up or down (i.e. parallel to the edges, not diagonal)
* If it moves, it moves to a neighboring grid cell
* If it moves into an edge, it is reflected back (no movement)

The algorithm will be very similar to the Paramecium example, except now there are two dimensions, x and y. The two parameters that determine movement are:

* p_move = 0.8
* dt = 1 / 6

Time is in minutes. These parameters say there is a 0.8 probability of moving in 10 seconds.

Place a nut randomly within the range like this (the nut could be anywhere within a grid cell, not necessarily at the center of a grid cell):

```R
nut_x <- runif(1, min=-15.5, max=15.5)
nut_y <- runif(1, min=-15.5, max=15.5)
```

The squirrel searches randomly. If the nut is inside a grid cell that the squirrel lands on, the squirrel has found the nut. To check if the nut is found, you could calculate the deviations of the nut from the centerlines of the grid cell that the squirrel is in:

```R
x_dev <- abs(nut_x - x)
y_dev <- abs(nut_y - y)
```

If both of these are less than 0.5, the nut is in the squirrel's current grid cell.



### The data questions

* How long until the squirrel finds the nut?
* What is the distribution of times (the data generating distribution)?
   * The nut should be placed randomly at a new location each replicate simulation



### Tips

* Start by coding the algorithm for one replicate of the search
* Start by modeling movement only
* Check your algorithm by carefully stepping through it
* Add a plot to visualize movement as another check (this time plotting in x, y instead of x, t)
* Then, once that's working, add the nut
* Then add a `for` repetition structure to conduct repeated simulations



