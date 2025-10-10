#### 1. Grid search training algorithm

* Finish off coding the algorithm. See [08_6_train_ssq_grid.md](08_6_train_ssq_grid.md) for the code we started in class and some Python hints.
* Use the algorithm to train the model with your linear dataset. You've no doubt previously used the R function `lm()` to train (fit) a linear model. Also fit the linear model to your data using `lm()` (or other software if that's what you're used to). You should find your hand-coded algorithm gets the same answer as `lm()`. If not, something is wrong and you'll need to debug your code.
* Notice and comment on the shape of the sum-of-squares profile for each parameter (plot of SSQ vs parameter value). Focus on the lower values of SSQ, the "underside" of the cloud of points.
* Hint: You'll want to adjust the y axis limits substantially to zoom in on the underside of the points. This is where you'll see the profile approach the minimum SSQ. Don't forget that most parameter combinations are terrible and will have massive SSQ.
* Mentally step through the algorithm, particularly the nested for loops, and confirm that the pattern of points makes sense as an output of the algorithm. Is the algorithm working? Do you understand what it's doing? Make a habit of visualizing the dynamic algorithm in your head (like a movie). This imaginative visualization is a central skill of modeling and science.
* **Push your Python script to GitHub.**


#### 2. Video lecture: optimization algorithms (especially descent algorithms)
   * [09_2_slides_optim_algos.pdf](09_2_slides_optim_algos.pdf)
   * [09_2_video_optim_algos.md](09_2_video_optim_algos.md) - 13 mins
   

