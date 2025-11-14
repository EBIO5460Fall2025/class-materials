# Homework

**Due:** Tuesday 18 Nov 3:30 PM (i.e. before class)

**Grading criteria:** Problems from question 3 with a complete attempt. On time submission.

**Format for submitting solutions:**

* Submit one file of R code for question 3 named `bayesnorm_assignment.R`
* You can add any prefixes to the filename that work with your file naming scheme. 

**Push your file to your GitHub repository**


## 1. From prior to posterior distribution (reading and video)

* Read McElreath Chapter 2 (1st edition), sections 2.1.2 - 2.4.1 (pp 25-40). [Google Drive](https://drive.google.com/drive/folders/1t418DW77_pnFPG5BE3ZyGMmIEuKQ5qCp?usp=sharing) (Texts)
* Watch McElreath video lecture 2 (you can stop at 60 mins):
* https://www.youtube.com/watch?v=IFRAKBArIyM&list=PLDcUM9US4XdM9_N6XUUFrhghGJ4K25bFc
* There are two short sections of lecture 2 that are not in the book:
  * 18:50 has a few minutes on how to use probability to do typical statistical modeling.
  * 34:20 has a few minutes on evaluating the model.

## 2. Problem set on using prior information (optional)

To get a good intuition for the prior distribution and Bayesian updating, it's a good idea to work through a few examples by hand.
* Do the following problems from McElreath Chapter 2 (1st edition):
  * 2M1, 2M2, 2M3
  * 2H2, 2H3, 2H4

Send me an email when you're done (or done trying) these problems and I'll drop the answers in your repo.

## 3. Bayesian Normal linear model

* Install the `rethinking` R package (for McElreath book). Running the next three lines of code in this order should install all that is necessary for now. You might be prompted to update some packages to more recent versions if you already have some installed. I chose to update all. Let me know if you have any problems.
  
  ```r
  install.packages("cmdstanr", repos = c('https://stan-dev.r-universe.dev', getOption("repos")))
  install.packages(c("coda","mvtnorm","devtools","loo","dagitty","shape"))
  devtools::install_github("rmcelreath/rethinking")
  ```

* Note that the above is not sufficient to install all the needed components for McElreath's book. We still need to install Stan components but we'll do that next week. If you want to rush ahead, you can follow McElreath's install instructions here:
  
  * https://github.com/rmcelreath/rethinking

* Read McElreath Chapter 4 (1st edition), sections 4.2 to 4.4 (other sections are optional). I have put a heavily modified version of Chapter 4 in the [Google Drive](https://drive.google.com/drive/folders/1t418DW77_pnFPG5BE3ZyGMmIEuKQ5qCp?usp=sharing) (Texts). Please use that version (the modified pdf explains why). I have **removed** and **modified** quite a lot of the text.

* Clean and modified code for Chapter 4 that you can follow along line by line is provided in:
  
  * [14_2_mcelreath_ch4_code.R](14_2_mcelreath_ch4_code.R). 

* Do problems H1-H3.

