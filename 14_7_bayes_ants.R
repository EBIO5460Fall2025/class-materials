library(rethinking)
library(ggplot2)
theme_set(theme_bw())

# Read in and plot the data

ant <- read.csv("data/ants.csv")
ant$habitat <- factor(ant$habitat)
ggplot(ant) +
    geom_point(aes(x=latitude, y=richness, col=habitat))


# ---- Training

# Bayesian fit with `ulam`, spelling out the model.

# We first set up the data in a list with an indicator variable `forest` and
# scaled latitude (center and divide by sd). With latitude unscaled the training
# algorithm was very inefficient. This data structure is a list, following the
# examples in McElreath, but a data frame would also work since that is also a
# named list.

mean_lat <- mean(ant$latitude)
sd_lat <- sd(ant$latitude)
d <- list(
    richness = ant$richness,
    latitude_s = (ant$latitude - mean_lat) / sd_lat,
    forest = ifelse(ant$habitat == "forest", 1, 0)
)
d

# Now specify the model in full and train with `ulam`. It will take a minute to
# compile, then it will sample from the posterior. I'm choosing to compile and
# run with one chain at first to check that the model compiles, then if all goes
# well, we'll carry on.

bysfitHxL <- ulam(
    alist(
        richness ~ poisson(mu),
        log(mu) <- 
            beta_0 +
            beta_1 * forest +
            beta_2 * latitude_s +
            beta_3 * forest * latitude_s,
        beta_0 ~ normal(1, 10),
        beta_1 ~ normal(0, 10),
        beta_2 ~ normal(0, 10),
        beta_3 ~ normal(0, 10)
    ),
    data=d
)

# The model compiles and the training algorithm doesn't complain. So, now for a
# serious run with multiple chains and more iterations. There will be a bunch of
# messages tracking progress of the chains.

bysfitHxL <- ulam(bysfitHxL, chains=4, cores=4, iter=2000)

# Parameter summary information. We seem to have convergence as rhat = 1, and we
# have efficient sampling as ess_bulk is high, indicating a large effective
# sample size.

precis(bysfitHxL, prob=0.95, digits=4)

# Here is the stancode for this model

stancode(bysfitHxL)

# The above model does not include site-level and plot-level variation that we
# included in our model for the data generating process. Here's how to add
# those. We first need to add site and plot identifiers to the data.

d$site <- as.numeric(factor(ant$site)) #integer for each site
d$plot <- 1:44

# Then in the model definition, we add `s` for site-level and `e` for plot-level
# variation. There will be a unique deviation for each site, and a unique
# deviation for each plot. We assume `s` and `e` are Normal random variables,
# and since these deviations are on the scale of `log(mu)` we are effectively
# adding lognormal variation. Overall, our model is a Poisson-lognormal compound
# distribution. We need priors for `sigma_s` and `sigma_e`. Many choices would
# work. For example, McElreath typically uses Exponential(1) distributions.
# Gelman has previously recommended a half-Cauchy distribution. After consulting
# the current "Prior choice recommendations" at the Stan wiki under the heading
# "Prior for scale parameters in hierarchical models", we'll use the currently
# recommended half-Normal prior. A half-Normal distribution is Normal centered
# at zero but the negative half is cut off so that `sigma_s` or `sigma_e` will
# take only positive values.

bysfitHxL <- ulam(
    alist(
        richness ~ poisson(mu),
        log(mu) <- 
            beta_0 +
            beta_1 * forest +
            beta_2 * latitude_s +
            beta_3 * forest * latitude_s +
            s[site] + 
            e[plot],
        s[site] ~ normal(0, sigma_s),
        e[plot] ~ normal(0, sigma_e),
        beta_0 ~ normal(1, 10),
        beta_1 ~ normal(0, 1),
        beta_2 ~ normal(0, 1),
        beta_3 ~ normal(0, 1),
        sigma_s ~ half_normal(0, 1),
        sigma_e ~ half_normal(0, 1)
    ),
    data=d
)

# We'll deal with the warning in a moment but first look at the Stan code.

stancode(bysfitHxL)

# Here we see that `ulam's` half Normal distribution for the `sigma_s` prior is
# implemented in Stan as a Normal distribution with `sigma_s` constrained as
# `real<lower=0> sigma_s` (same for `sigma_e`).

# The training algorithm warned us of an `E-BFMI less than 0.3` and checking the
# parameter summary, we find additional problems with convergence (rhat > 1) and
# efficiency of the chains (very low ess_bulk) for `sigma_s` and especially
# `sigma_e`.

precis(bysfitHxL, prob=0.95, digits=4)

# This is an issue that often comes up with hierarchical models and the HMC
# algorithm. The issue is that the physics simulation component of the algorithm
# has trouble when the posterior surface is steep and narrow resulting in
# inefficient exploration of the posterior. The solution is often a
# reparameterization of the model called the non-centered parameterization (see
# McElreath for more detailed explanation). The small change is to draw `s` and
# `e` from a Normal(0, 1) instead of Normal(0, sigma) and move the sigmas to the
# equation for `log(mu)`.

bysfitHxL <- ulam(
    alist(
        richness ~ poisson(mu),
        log(mu) <- 
            beta_0 +
            beta_1 * forest +
            beta_2 * latitude_s +
            beta_3 * forest * latitude_s +
            s[site] * sigma_s + 
            e[plot] * sigma_e,
        s[site] ~ normal(0, 1),
        e[plot] ~ normal(0, 1),
        beta_0 ~ normal(1, 10),
        beta_1 ~ normal(0, 1),
        beta_2 ~ normal(0, 1),
        beta_3 ~ normal(0, 1),
        sigma_s ~ half_normal(0, 1),
        sigma_e ~ half_normal(0, 1)
    ),
    data=d
)

# That looks better; there are no warnings. Here's the Stan model

stancode(bysfitHxL)

# Serious training run now. I'm going to bump up the iterations so we can get
# good detail in the tails of the posterior distributions especially for the two
# sigma parameters.

bysfitHxL <- ulam(bysfitHxL, chains=4, cores=4, warmup=1000, iter=10000)

# Now we have good convergence and efficient sampling

precis(bysfitHxL, prob=0.95, digits=4)

# Inspect the traceplots
# The beta chains are excellent. The sigma chains are not the most efficient and
# do wander a bit and sometimes hover near zero for a few iterations but I could
# not do any better with a longer warmup.

op <- par(no.readonly = TRUE) #copy the original graphics parameters
traceplot(bysfitHxL, pars=paste0("beta_", 0:3), window=c(0,2000), n_cols=2)
traceplot(bysfitHxL, pars=paste0("beta_", 0:3), window=c(2000, 2250), n_cols=2)
traceplot(bysfitHxL, pars=c("sigma_s", "sigma_e"), window=c(0,2000), n_cols=1)
traceplot(bysfitHxL, pars=c("sigma_s", "sigma_e"), window=c(2000,2250), n_cols=1)
par(op)

# ---- Inference

# All inferences are from the posterior samples

samples <- extract.samples(bysfitHxL)
class(samples)
str(samples)
names(samples)

# Visualizing the posterior for each parameter

par(mfrow=c(2,2))
hist(samples$beta_0, breaks=75)
hist(samples$beta_1, breaks=75)
hist(samples$beta_2, breaks=75)
hist(samples$beta_3, breaks=75)
hist(samples$sigma_s, breaks=75)
hist(samples$sigma_e, breaks=75)

# Parameter credible intervals directly from the samples

HPDI(samples$beta_0, prob=0.95)
HPDI(samples$beta_1, prob=0.95)
HPDI(samples$beta_2, prob=0.95)
HPDI(samples$beta_3, prob=0.95)
HPDI(samples$sigma_s, prob=0.95)
HPDI(samples$sigma_e, prob=0.95)


# Mean curves, intervals for curves (HPDI), posterior predictive distribution.
# These are all derived quantities.

# Initialize a grid of latitudes, scaled the same as we scaled the data
lat_lwr <- (41.92 - mean_lat) / sd_lat
lat_upr <- (45 - mean_lat) / sd_lat
latitude_s <- rep(seq(from=lat_lwr, to=lat_upr, length.out=50), 2)
forest <- rep(0:1, each=50)

# Initialize storage
n <- length(latitude_s)
mn_hpdi <- matrix(NA, nrow=n, ncol=5) #to store mean and hpdi values
colnames(mn_hpdi) <- c("mnmu","mulo95","muhi95","ppdlo95","ppdhi95")

# For each latitude-habitat combination, form the posterior
for ( i in 1:n ) {
    
    # First form samples for the linear deterministic skeleton
    ln_mu <- samples$beta_0 + 
             samples$beta_1 * forest[i] + 
             samples$beta_2 * latitude_s[i] + 
             samples$beta_3 * forest[i] * latitude_s[i]
    
    # Then use inverse link for samples of the posterior \mu
    mu <- exp(ln_mu)
    
    # Sample from the data generating process to get the posterior predictive
    # distribution. This prediction is for a generic new plot at a new site,
    # which includes the stochasticity and parameter uncertainty for the site
    # and plot scales.
    n <- length(mu)
    s <- rnorm(n, mean=0, sd=samples$sigma_s)
    e <- rnorm(n, mean=0, sd=samples$sigma_e)
    lambda <- exp(ln_mu + s + e)
    ppd <- rpois(n, lambda)

    # Mean and intervals of these samples
    mn_hpdi[i,1] <- mean(mu)
    mn_hpdi[i,2:3] <- HPDI(mu, prob=0.95)
    #mn_hpdi[i,4:5] <- HPDI(ppd, prob=0.95)
    mn_hpdi[i,4:5] <- quantile(ppd, prob=c(0.025,0.975)) #CPI
    
}
rm(lat_lwr, lat_upr, n, ln_mu, mu, s, e, lambda, ppd) #clean up

# Notice that we calculated expectations (e.g. `mean(mu)`) and intervals
# directly on the scale of the data (the "response" scale), not on the linear
# predictor scale. If we calculated first on the linear predictor scale and then
# backtransformed the HPDI intervals to the response scale they would be biased
# due to nonlinear averaging. Also, the posterior predictive distribution (PPD)
# can, of course, only be on the response scale. I used the CPI (`quantile()`)
# for the posterior predictive distribution because plots of the HPDI and CPI
# were substantially similar but the CPI was more numerically stable.

# Package in tidy format and plot
preds <- data.frame(
    habitat=ifelse(forest == 0, "bog", "forest"),
    latitude=latitude_s * sd_lat + mean_lat, 
    mn_hpdi)
rm(latitude_s, forest, mn_hpdi) #clean up

bfc <- c("#d95f02", "#1b9e77") #bog & forest colors
ggplot(preds) +
    geom_ribbon(aes(x=latitude, ymin=mulo95, ymax=muhi95, fill=habitat),
                alpha=0.2) +
    geom_line(aes(x=latitude, y=mnmu, col=habitat)) +
    geom_line(aes(x=latitude, y=ppdlo95, col=habitat), lty=2) +
    geom_line(aes(x=latitude, y=ppdhi95, col=habitat), lty=2) +
    geom_point(data=ant, aes(x=latitude, y=richness, col=habitat)) +
    annotate("text", x=43.6, y=3, label="Bog", col=bfc[1]) +
    annotate("text", x=43.6, y=8.5, label="Forest", col=bfc[2]) +
    scale_fill_manual(values=bfc) +
    scale_color_manual(values=bfc) +
    scale_y_continuous(breaks=seq(0, 24, 4), minor_breaks=seq(0, 24, 2)) +
    coord_cartesian(ylim=c(0, 24)) +
    xlab("Latitude (degrees north)") +
    ylab("Ant species richness") +
    theme(legend.position="none")

# Shaded areas are 95% credible intervals for the mean. Dashed lines are 95%
# prediction intervals.

# How different is species richness between habitats?

# We can see from the plot above that mean species richness is mostly higher in
# forest than bog, judging by the non-overlap of the credible intervals for the
# mean. We can also roughly read off the difference (about 5.5 at latitude 42,
# or 2 at latitude 45). But we haven't yet precisely quantified this difference
# or its uncertainty. Let's do that next.

# We need to derive the relevant quantities: the differences in mean species
# richness between habitats at different latitudes. 

# The first half of this code is substantially the same as above; the main
# action is at the line that calculates the difference (`diff`).

# Initialize variables and storage 
lat_lwr <- (41.92 - mean_lat) / sd_lat
lat_upr <- (45 - mean_lat) / sd_lat
latitude_s <- seq(from=lat_lwr, to=lat_upr, length.out=50)
n <- length(latitude_s)
forest_bog_diff <- matrix(NA, nrow=n, ncol=3) #to store mean and hpdi values
colnames(forest_bog_diff) <- c("mndiff","difflo95","diffhi95")

# For each latitude, form the posterior
for ( i in 1:n ) {
    
    # First form samples for the linear deterministic skeleton
    ln_mu_bog    <- samples$beta_0 + 
                    samples$beta_2 * latitude_s[i]
    ln_mu_forest <- samples$beta_0 + 
                    samples$beta_1 + 
                    samples$beta_2 * latitude_s[i] + 
                    samples$beta_3 * latitude_s[i]
    
    # Then use inverse link for samples of the posterior \mu
    mu_bog <- exp(ln_mu_bog)
    mu_forest <- exp(ln_mu_forest)
    
    # Now calculate the habitat difference (derived quantity)
    diff <- mu_forest - mu_bog
    
    # Mean and intervals of these samples
    forest_bog_diff[i,1] <- mean(diff)
    #forest_bog_diff[i,2:3] <- HPDI(diff, prob=0.95)
    forest_bog_diff[i,2:3] <- quantile(diff, prob=c(0.025,0.975)) #CPI
    
}

# Package in a dataframe (with latitude rescaled to original) & plot
diff_df <- data.frame(latitude=latitude_s * sd_lat + mean_lat,
                      forest_bog_diff)
rm(lat_lwr, lat_upr, latitude_s, n, forest_bog_diff, ln_mu_bog, ln_mu_forest,
   mu_bog, mu_forest, diff) #clean up

ggplot(diff_df) +
    geom_ribbon(aes(x=latitude, ymin=difflo95, ymax=diffhi95),
        alpha=0.2) +
    geom_line(aes(x=latitude, y=mndiff)) +
    coord_cartesian(ylim=c(0,8.3)) +
    xlab("Latitude (degrees north)") +
    ylab("Difference in species richness (forest - bog)")

# Difference declines with latitude, and we can see how the uncertainty changes
# with latitude showing that mean ant richness in forest is clearly higher than
# in bog across almost the entire range of latitudes.
