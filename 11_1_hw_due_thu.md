# Homework

**Due:** Thursday 30 Oct 11:59 PM

**Grading criteria:** Answer questions 1 & 2 with a complete attempt. On time submission.

**Format for submitting solutions:**

* Submit only one file of R code for questions 1 and 2 combined
* The filename should be `bootstrap_assignment.R` but you can add any prefixes to the filename that work with your file naming scheme. 

**Push your file to your GitHub repository**



## Learning goals

* Understand how bootstrap algorithms mimic the sampling distribution algorithm
* Gain intuition for the plug in principle by using it directly, algorithmically
* Use simulation to understand how the sampling distribution is the basis for frequentist inference
* Develop inference algorithms from first principles that can be applied to any model

The bootstrap is a powerful, general algorithm for computational frequentist inference. You can use this whenever there is not a pre-built way to assess uncertainty, which is common with one-off models tailored to your biological system or question. Although we're using the linear model here as an example, the bootstrap algorithm can be applied to any kind of model.


##  1. Estimate bootstrap confidence intervals for your linear dataset

Use the **empirical** bootstrap algorithm to calculate 95% confidence intervals for the parameters and confidence bands for y. Use the 2 sigma method to form intervals. Note that this is not simply running your data through one section of my code: you'll need to combine aspects of the code that I introduced in different places to make the algorithm. You'll know you're doing it right if the bootstrap intervals are very similar to the intervals given by these R functions that do the calculations the classical math way:

```R
fit <- lm(y ~ x, data=df) #df is a dataframe of your data
confint(fit)
df_new <- data.frame(x=seq(min(df$x), max(df$x), length.out=50)
predict(fit, newdata=df_new, interval="confidence")
```


## 2. Estimate bootstrap prediction intervals for your linear dataset

Use the **parametric** bootstrap algorithm to calculate 95% prediction intervals for new predicted values of y. Use the percentile method to form intervals. This is more or less minor modifications to the code we went through in class. Explore the code thoroughly, line by line, to be sure what it's doing. You'll know you're doing it right if the bootstrap intervals are very similar to the intervals given by:

```R
predict(fit, newdata=df_new, interval="prediction")
```


## 3. Bootstrapped *p*-values

We didn't get to this in class on Thursday. For better or worse, *p*-values and hypothesis testing are staples in frequentist inference. My philosophy is that if you must go this route, any paper or study should only have one to maybe three *p*-values, **only for the key general hypotheses**. Most estimated quantities are instead better reported with their confidence intervals. Sometimes the only way to get a *p*-value is using one of the variations of the bootstrap algorithm. A bonus of the bootstrapped *p*-value is that it provides deeper insight into what a *p*-value actually is.

Read about it here:
* [10_9_bootstrap_p-value.md](10_9_bootstrap_p-value.md)

Also see the further reading on *p*-values:
* [10_9_p-value_further_reading.md](10_9_p-value_further_reading.md)

