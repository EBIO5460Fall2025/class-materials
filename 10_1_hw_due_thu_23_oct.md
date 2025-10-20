#### 1. Descent and grid search algorithms with an ecological model

We just looked at SSQ training algorithms applied to a linear model (aka linear regression). Among the [three data science cultures](01_1_slides_thu_intro_welcome.pdf), this was an example of the **generative modeling culture**, which emphasizes generic models and phenomenological algorithms such as linear regression. We'll now apply these training algorithms to an ecological model, an example from the **natural processes culture** of data science, which emphasizes mechanistic models for the data generating process.



**Experimental data**

The data file `paramecium.csv` in the [data folder](/data) contains data from a laboratory experiment with the model aquatic species *Paramecium aurelia* (actually, so as not to make it too hard, these are simulated data generated from a detailed stochastic model of births and deaths but let's imagine this scenario). To begin this experiment on population dynamics, 100 individuals were added to a 1 L flask and then sampled every hour for 24 hours. To take a sample, the flask was shaken to mix it well, a 10 ml sample was withdrawn, and the number of individuals in the sample was counted under the microscope, before returning the sample to the flask. Don't forget to first plot the data!



**Mechanistic model**

If we assume that individuals are well mixed in the flask, reproduce randomly over time by binary fission (splitting in two), and experience mortality randomly, then we naturally arrive at the following mathematical model for the population dynamics over time (how we arrive at this model is a topic for another time):

$$\frac{dN(t)}{dt} = rN(t)\left ( 1-\frac{N(t)}{K} \right )$$

where $N(t)$ is the population density at time $t$, $r = b - d$ is the intrinsic rate of growth, a balance of the birth, $b$, and death, $d$, rates of the *Paramecium*, and $K$ is the carrying capacity. This is the classic model of **logistic growth** in continuous time. To translate this model to an algorithm in R code, we could use a general solver for differential equations, such as that found in the R package `deSolve`. But in this special case, there is a solution to the equation in terms of time and the initial density:

$$N(t) = N(0) \frac{ K e^{rt} }{ K + N(0) (e^{rt} - 1) }$$

We can think of this equation as the deterministic skeleton of the ecological process.


**Now train the model!**

To train (or "fit") the logistic model to the data, you can simply use the above equation to form predictions for the population density, $N(t)$, at any time. Our goal now is to find values of the two parameters $r$ and $K$ that minimize the SSQ and thus maximize the deterministic signal in the data. First try it assuming that $N(0)$ is known. Then try it assuming that we don't know $N(0)$, which means you will also need to estimate a third parameter, $N(0)$. Use a combination of a descent algorithm (Nelder-Mead, R: `optim()`) and a grid search algorithm.

Use the following strategy:
* Base your R code on the template algorithms that use the linear deterministic skeleton (but replace the linear model with the logistic model)
* Use `optim()` to find a candidate set of optimum parameter values
* Check that it is robust (finds the same minimum) by trying different starting points for the parameters
* Use a grid search to inspect the profiles of the SSQ surface near the optimum parameters

**Push your code to GitHub**

#### 2. Video coding demonstration: Beetle sampling distribution

Finishing off the coding exercise from Thursday's class.

* [09_7_beetle_sampling_distribution.R](09_7_beetle_sampling_distribution.R)
* [09_7_video_beetle_sampling_distribution.md](09_7_video_beetle_sampling_distribution.md)

#### 3. Reading & video lecture: sampling distribution and coverage algorithm

Read an example about using the sampling distribution for frequentist inference, applied to confidence intervals. This is best read in the markdown `.md` format on GitHub (in your browser) because the equations and so on will render nicely there. The markdown version was generated from the code in the `.Rmd` file. You can explore the code from the `.Rmd` version from within Positron (or R Studio).

Watch the video for this example. See also associated slides.

   * [10_2_sampling_distribution_CI_coverage.md](10_2_sampling_distribution_CI_coverage.md) - reading/code
   * [10_3_slides_sampling distribution_CI_coverage.pdf](10_3_slides_sampling_distribution_CI_coverage.pdf)
   * [10_3_video_sampling_distribution_CI_coverage.md](10_3_video_sampling_distribution_CI_coverage.md)

#### 4. Frequentist inference algorithms in lm()

TBA


