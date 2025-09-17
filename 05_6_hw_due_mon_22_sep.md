# Homework

Questions below. I need to add learning goals etc here. Coming soon.


## 1. Skill of the week, git amend, .gitignore, Git GUI

* [git04_amend.md](skills_tutorials/git04_amend.md) - make minor updates without messing up your history
* [git05_gitignore.md](skills_tutorials/git05_gitignore.md) - how to not track all files
* [git06_gitgui.md](skills_tutorials/git06_gitgui.md) - how to invoke the GUI for basic tasks and explore your history



## 2. Feedback for me

Let me know how the class is going for you so far and provide any feedback or ideas. What's working or not working for you? Are there things you'd like me to do differently? Please fill out the anonymous qualtrics survey here:

   * https://cuboulder.qualtrics.com/jfe/form/SV_3mHygwu7alfirGK 1-3 mins


## 3. Time to move to the edge

Extending the Paramecium movement example, if the arena ends at (-15, 15) how long until an individual gets to the edge? Plot a histogram that shows the distribution of times. A large number of replicates will smooth out the histogram. Assuming we record the time without error, this is the distribution of the data generating process. It's handy to tweak the histogram to show more detail by increasing the number of bins. See the code from class. What makes sense for the bin width? This is an example of a time-to-event distribution.



## 4. Find the nut

Imagine now that we have a squirrel moving around its home range looking for nuts. For simplicity, let's make it a square 31 m to a side (15.5 m from the center to each edge). The home range is divided into 1 m grid cells, so we have 31 grid cells per side, and 15 grid cells on either side of the center (i.e the center of the center cell is at (0, 0)). Here are its movement rules:

* Can only move left or right, or up or down (i.e. parallel to the edges, not diagonal)
* If it moves, it moves to a neighboring grid cell
* If it moves into an edge, it is reflected back (no movement)

The algorithm will be very similar to the Paramecium example, except now there are two dimensions, x and y. The two parameters that determine movement are:

p_move = 0.8
dt = 1 / 6

Time is in minutes. So these parameters say there is a 0.8 probability of moving in 10 seconds.

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

If both of these are less than 0.5, the nut is in the squirrel's grid cell.

The data questions:

* How long until the squirrel finds the nut?
* What is the distribution of times (the data generating distribution)?
   * The nut should be placed randomly at a new location each replicate simulation

Tips:

* Start by coding the algorithm for one replicate of the search
* Start by modeling movement only
* Check your algorithm by carefully stepping through it
* Add a plot to visualize movement as another check
* Then, once that's working, add the nut
* Then add a `for` repetition structure to conduct repeated simulations

