# Semester timetable
Since this semester is a major revision with new content, this is only roughly how it will go!

## Week 1

* Intro to data science
  * 3 cultures
  * Models, algorithms, workflows
  * Algorithm classes: model, training, inference
  * Importance of data generating processes in science

* Productive programming tools
  * IDEs, screen real estate, pseudocode, flowcharts

* Structured programming

* Sequence structure

* Homework
  * Skills: Get set up with Git and GitHub.
  * Mini lecture: What is an algorithm?
  * Reading: How algorithms unite data science


## Week 2 - 3

* Version control workflow

* Designing algorithms

* Selection structures
  * Single: if
  * Double: if/else
  * Multiple: if/else if

* Repetition structures
  * Sentinel control: while
  * Counter control: for
  * Vector control: foreach

* Stacking & nesting control structures

* Repetition structures
  * until, do-while, foreach object in list

* Structured programming: functions
  * Making programs modular
  * Scope

* Homework
  * Skills: Git and GitHub: stage, commit, push, backtrack
  * Skills: Using code styles
  * Mini lecture: Selection structures
  * Mini lecture: Further repetition structures
  * Coding: Selection structures problem set
  * Coding: Sentinel and counter controlled repetition
  * Coding: Repetition structures problem set


## Week 4 - 5

* The art of modeling
  * Formulating and writing a model
  * Making assumptions explicit
  * Mapping science questions to models
  * Tools for conceptualizing models
  * Scope of inference and data design

* Data generating processes and model algorithms
  * Simple linear model in math and code
  * Stochastic processes
  * Generating random numbers
  * Generating data from distributions
  * Design an algorithm to generate animal movement data

* Homework
  * Skills: Git and GitHub: amend, .gitignore, GUI
  * Skills: Git and GitHub: branch, merge
  * Mini lecture: 3 classes of algorithms
  * Coding: Simulate an ecological or evolutionary process


## Week 6 - 7

* Training algorithms
  * Vary model parameters to minimize distance from data

* Training models general recipe
  1. Biology function
  2. Error function
  3. Optimize

* Optimization algorithms
  * Optimization: grid search
  * Design a grid search algorithm for linear regression
  * Descent methods: Nelder-Mead simplex algorithm using `optim()`
  * Numerical/analytical methods: SSQ QR decomposition algorithm used in `lm()`
  
* Homework
  * Skills: Reproducible science
  * Skills: Writing markdown documents
  * Skills: Practice git branch and merge with your own code
  * Mini lecture: Intro to training algorithms
  * Mini lecture: Optimization algorithms
  * Coding: Grid search for linear model
  * Coding: Grid search training algorithm for mechanistic population growth model
  * Coding: Descent training algorithm for mechanistic population growth model


## Week 8 - 9

* Inference algorithms intro
  * Inference problems/goals
  * Statistical inference is about accuracy, reliability, uncertainty
  * Looking back or looking forward
  * Looking back: considering the ways data could have happened

* Frequentist inference algorithms
  * The sampling distribution algorithm considers the ways a sample could have happened
  * Plug in principle
  * Confidence intervals from the sampling distribution
  * Coverage algorithm
  * P-value algorithm
  * Prediction intervals

* Bootstrap algorithm
  * Plug in a computational sampling algorithm
  * Non-parametric, empirical, parametric
  * Bootstrapped confidence interval
  * Bootstrapped p-value

* Homework
  * Skills: Reproducible workflow
  * Skills: Literate programming, render scripts to markdown
  * Mini lecture: Inference algorithms
  * Mini lecture: Frequentist inference algorithms for `lm()` simple linear model
  * Reading: Sampling distribution
  * Reading: Bootstrap algorithm
  * Reading: Theory and concepts behind ggplot and plotnine
  * Coding: Confidence versus prediction intervals
  * Coding: Bootstrap algorithms


## Week 10

* Visualization
  * Theory
  * Grammar of graphics (GOG) theory
  * GOG with any plotting tools (including base R or matplotlib)
  * GOG with ggplot or plotnine

* Likelihood inference
  * Conditional probability: P(y|theta)
  * Likelihood principle, likelihood function, likelihood ratio
  * Training algorithm: maximum likelihood
  * Inference algorithm: likelihood profiles
  * Pure likelihood intervals

* Homework
  * Skills: Visualization using ggplot or plotnine
  * Mini lecture: Likelihood
  * Reading: Pitfalls of p-values
  * Reading: Conceptual foundations of likelihood
  * Reading: Likelihood inference for the linear model
  * Problem set: Likelihood problems from McElreath Ch 2
  * Coding: Likelihood intervals for the linear model


## Week 11 - 12

* Bayesian inference algorithms
  * Posterior sampling
  * Histograms as approximations to posterior distribution
  * Credible intervals: central posterior interval, highest posterior density interval
  * Prediction intervals
  * Inference for linear models

* Homework
  * Mini lecture & reading: Bayes' theorem, prior, posterior
  * Problem set: Bayesian problems from McElreath Ch 2
  * Reading & active coding:
    * Bayesian model notation
    * Bayesian inference algorithm
    * Coding problems from McElreath Ch 4

* MCMC algorithms for Bayesian training
  * Rosenbluth-Metropolis-Hastings, Gibbs sampling, Hamiltonian Monte Carlo
  * Stan, rstan, rstanarm
  * MCMC diagnostics

* Further Bayesian topics
  * Choosing priors
  * Posteriors for derived quantities

* Priors in Bayesian models
  * From flat to informative
  * How to decide?
  * Visualizing priors and prior predictive distribution

* Homework
  * Skills: Tidy data
  * Coding: McElreath Ch 8 problems
  * Coding: Rosenbluth (Metropolis) algorithm


## Week 13 - 14
  
* Model checking
  * Evaluating model assumptions
  * Assessing training robustness
  * Residuals, leverage, outliers, QQ plots, nonlinearity, non-constant variance
  * Leave one out (case deletion) algorithm for influence
  
* Model checking for Bayesian models
  * MCMC diagnostics
  * Posterior predictive checks

* Data simulation check for frequentist models

* Data simulation of multilevel designs

* Generalized linear and nonlinear models (GLMs)
  * Link functions
  * Data distributions

* GLMs: ant data case study
  * Bayesian analysis using `ulam` and `stan_glm()`
  * Frequentist/likelihood analysis using `glm()` and bootstrap
  * Derived quantities from posterior or bootstrap samples

* Model selection from various perspectives (frequentist, Bayesian, IC)
  * CV, AIC, BIC, WAIC, LOOIC

* Introduction to machine learning
  * Cross validation algorithm

* Homework
  * Individual project
  * Mini lecture: Model checking
  * Mini lecture: model formula syntax in R and Python
  * Coding: Frequentist and likelihood diagnostics for the linear Normal model
  * Reading: Cross validation
  * Reading: Model selection


## Where next?

This course is the start of a full four-semester sequence in data science for ecology and evolution. I'm also writing a textbook *Data Science for Ecology: Algorithms to Understand and Predict Nature*. These topics will be covered in the book and a selection in future semesters and seminars:

* Machine learning (see my course website from [Spring 2025](https://github.com/EBIO5460Spring2025/class-materials))
  * bagging, random forests, boosting, stochastic gradient descent, neural networks & deep learning
* Process modeling with data (course scheduled Spring or Fall 2026, last taught as [QEE 2017](https://www.colorado.edu/lab/melbourne/courses))
  * wide range of process models in discrete and continuous time and space, agent-based models, approximate Bayesian computation (ABC)
* Hierarchical and other advanced statistical models (likely Spring 2027)
  * GLMMs, spatio-temporal models, programming in Stan and JAGS
* Unsupervised learning (aka "multivariate statistics")
* Ecological forecasting and time series (see my course website from [Spring 2020](https://github.com/EBIO6100Spring2020/Class-materials))
