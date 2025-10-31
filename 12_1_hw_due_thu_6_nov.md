# Homework

**Due:** Thursday 6 Nov 11:59 PM

**Grading criteria:** Answer questions 1 & 2 with a complete attempt. On time submission.

**Format for submitting solutions:**

* Submit one text or markdown file for the individual project named `individual_project_ideas.md`
* Submit one file of R code for questions 2 named `likelihood_assignment.R`
* You can add any prefixes to the filenames that work with your file naming scheme. 

**Push your files to your GitHub repository**


## 1. Individual project

Think about what you might want to do for your individual project. For greatest synergy with your research, choose a project, research question or dataset that you'd like to make progress on. If that's not possible yet, you could base it on a paper that inspires you or is connected to your work but you'd love to look more deeply into.

### Simulating the data generating process

The goal of this project is to make a data simulation that can inform your research. There are two main approaches you could take:

* 1\ A fully stochastic biological simulation (e.g. squirrel movement)
* 2\ A deterministic skeleton + noise simulation (e.g. Paramecium logistic growth or linear normal model)

If you **have a research question but no data** you can do either of these. You could use this as an opportunity to plan a study or experiment. If you **have a dataset already**, you can also do either of these. It will help you build an appropriate model that can be trained on the data to give biologically-relevant inferences.

### Too many options?

Lucky you! If you have several options and are unsure which is best, jot down a few notes about each and I'll help you decide.

### Here's what to do for this week's assignment:

Jot down a few preliminary bullet points:

* What are the scientific questions?
* Describe the process you want to simulate
* If you have a dataset, provide a brief description (size, types of variables, etc)


## 2. Likelihood inference algorithm with your data
   
   * Use your linear dataset as in previous homework
   * Using the approach in [11_3_likelihood_inference.md](11_3_likelihood_inference.md)  (e.g. see code in Summary) calculate 1/8 likelihood intervals for the intercept, slope, and standard deviation. Compare the intervals for the intercept and slope to the classical confidence intervals.

## 3. (Optional) Problem set on counting the ways

To get a good intuition for how likelihood (and probability) works, it's a good idea to work through a few examples by hand.
   * Do the following problems from McElreath Chapter 2:
     * 2E1, 2E2, 2E3
     * 2M4, 2M5, 2M7, 2H1
     * use the counting method, i.e. draw forking paths, for the latter 4 problems
   * Challenge problems (again, use the counting method)
     * Extending from 2H1, on the next birth the panda has twins. What are the likelihoods for the two models: M1 Panda is species A; M2: Panda is species B? Recall that the likelihood is the probability of the data given the model.
     * Now calculate the likelihoods if, instead, the next birth was a singleton

Send me an email when you're done (or done trying) these problems and I'll drop the answers in your repo.
