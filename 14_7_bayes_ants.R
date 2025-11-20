
library(ggplot2)
library(dplyr)
library(rethinking)
theme_set(theme_bw())

# Read in and plot the data

ant <- read.csv("data/ants.csv")
ant$habitat <- factor(ant$habitat)
ant |> 
    ggplot(aes(x=latitude, y=richness, col=habitat)) +
    geom_point()


# ---- Training

# Bayesian fit with `ulam`, spelling out the model. We first need new columns to
# represent the design matrix. We'll also scale by latitude (center and divide
# by sd) to improve efficiency of the training algorithm.

# Set up variables

mean_lat <- mean(ant$latitude)
sd_lat <- sd(ant$latitude)
d <- ant |>
    mutate(intercept = rep(1, n()),
           forest = ifelse(habitat == "forest", 1, 0),
           latitude = (latitude - mean_lat) / sd_lat,
           forest_X_latitude = forest * latitude) |>
    select(richness, intercept, forest, latitude, forest_X_latitude)
d

# Now specify the model in full and train with `ulam`. It will take a minute to
# compile, then it will sample from the posterior. I'm choosing to compile and
# run with one chain at first to check that the model compiles, then if all goes
# well, we'll carry on.

bysfitHxL <- ulam(
    alist(
        richness ~ dpois(mu),
        log(mu) <- 
            beta_0 * intercept +
            beta_1 * forest +
            beta_2 * latitude +
            beta_3 * forest_X_latitude,
        beta_0 ~ dnorm(1, 10),
        beta_1 ~ dnorm(0, 10),
        beta_2 ~ dnorm(0, 10),
        beta_3 ~ dnorm(0, 10),
    ),
    data=d
)


# The model compiles and the training algorithm doesn't complain. So, now for a
# serious run. There will be a bunch of messages tracking progress of the
# chains.

bysfitHxL <- ulam(bysfitHxL, chains=4, cores=4, warmup=1000, iter=10000)


# Parameter information

precis(bysfitHxL, prob=0.95, digits=4)


# Working with posterior samples

samples <- extract.samples(bysfitHxL)
class(samples)
str(samples)
names(samples)

# Visualizing the posterior

samplesdf <- data.frame(samples)
head(samplesdf)

hist(samples$beta_0, breaks=75)
hist(samples$beta_1, breaks=75)
hist(samples$beta_2, breaks=75)
hist(samples$beta_3, breaks=75)

# Check traceplot to confirm convergence and check the behavior

traceplot(bysfitHxL)



# Inference

# Parameter credible intervals directly from the samples

HPDI(samples$beta_0, prob=0.95)
HPDI(samples$beta_1, prob=0.95)
HPDI(samples$beta_2, prob=0.95)
HPDI(samples$beta_3, prob=0.95)



# Mean curves, intervals for curves (HPDI), posterior predictive distribution
# derived quantities

# Initialize a grid of latitudes, scaled the same as we scaled the data
lat_lwr <- (41.92 - mean_lat) / sd_lat
lat_upr <- (45 - mean_lat) / sd_lat
latitude <- seq(from=lat_lwr, to=lat_upr, length.out=50)

# Initialize storage
n <- length(latitude)
hpdi_bog <- matrix(NA, nrow=n, ncol=5) #to store hpdi values and mean
colnames(hpdi_bog) <- c("mnmu","mulo95","muhi95","ppdlo95","ppdhi95")
hpdi_forest <- matrix(NA, nrow=n, ncol=5)
colnames(hpdi_forest) <- c("mnmu","mulo95","muhi95","ppdlo95","ppdhi95")

# For each latitude, form the posterior
for ( i in 1:n ) {
    
    # First form samples for the linear predictor \eta
    eta_bog <- samples$beta_0 + 
               samples$beta_2 * latitude[i]
    eta_forest <- samples$beta_0 + 
                  samples$beta_1 + 
                  samples$beta_2 * latitude[i] + 
                  samples$beta_3 * latitude[i]
    
    # Then use inverse link for samples of the posterior \mu
    mu_bog <- exp(eta_bog)
    mu_forest <- exp(eta_forest)
    
    # Sample from Poisson to get the posterior predictive distribution
    ppd_bog <- rpois(n=length(mu_bog), lambda=mu_bog)
    ppd_forest <- rpois(n=length(mu_forest), lambda=mu_forest)
    
    # Mean and intervals of these samples
    hpdi_bog[i,1] <- mean(mu_bog)
    hpdi_bog[i,2:3] <- HPDI(mu_bog, prob=0.95)
    #hpdi_bog[i,4:5] <- HPDI(ppd_bog, prob=0.95)
    hpdi_bog[i,4:5] <- quantile(ppd_bog, prob=c(0.025,0.975)) #CPI
    hpdi_forest[i,1] <- mean(mu_forest)
    hpdi_forest[i,2:3] <- HPDI(mu_forest, prob=0.95)
    #hpdi_forest[i,4:5] <- HPDI(ppd_forest, prob=0.95)
    hpdi_forest[i,4:5] <- quantile(ppd_forest, prob=c(0.025,0.975)) #CPI
    
}
rm(eta_bog, eta_forest, mu_bog, mu_forest) #clean up

# Notice that we calculated expectations (e.g. `mean(mu_bog)`) and intervals
# directly on the scale of the data (the "response" scale), not on the linear
# predictor scale. If we calculated first on the linear predictor scale and then
# backtransformed the HPDI intervals to the response scale they would be biased
# due to nonlinear averaging. Also, the posterior predictive distribution (PPD)
# can, of course, only be on the response scale. I used the CPI (`quantile()`)
# for the posterior predictive distribution because plots of the HPDI and CPI
# were substantially similar but the CPI was more numerically stable.

# Package in tidy format and plot

latitude <- latitude * sd_lat + mean_lat
predsbog <- data.frame(habitat=rep("bog", n), latitude, hpdi_bog)
predsforest <- data.frame(habitat=rep("forest", n), latitude, hpdi_forest)
preds <- rbind(predsbog, predsforest)
rm(latitude, n, hpdi_bog, hpdi_forest, predsbog, predsforest) #clean up

bfc <- c("#d95f02", "#1b9e77") #bog & forest colors
preds |>
    ggplot() +
    geom_ribbon(aes(x=latitude, ymin=mulo95, ymax=muhi95, fill=habitat),
                alpha=0.2) +
    geom_line(aes(x=latitude, y=mnmu, col=habitat)) +
    geom_line(aes(x=latitude, y=ppdlo95, col=habitat), lty=2) +
    geom_line(aes(x=latitude, y=ppdhi95, col=habitat), lty=2) +
    geom_point(data=ant, aes(x=latitude, y=richness, col=habitat)) +
    annotate("text", x=42.7, y=3.3, label="Bog", col=bfc[1]) +
    annotate("text", x=43.85, y=9.5, label="Forest", col=bfc[2]) +
    scale_fill_manual(values=bfc) +
    scale_color_manual(values=bfc) +
    scale_y_continuous(breaks=seq(0, 20, 4), minor_breaks=seq(0, 20, 2)) +
    coord_cartesian(ylim=c(0, 20)) +
    xlab("Latitude (degrees north)") +
    ylab("Ant species richness") +
    theme(legend.position="none")



# How different is species richness between habitats?

# We can see from the plot above that mean species richness is mostly higher in
# forest than bog, judging by the non-overlap of the credible intervals for the
# mean. We can also roughly read off the difference (about 5.5 at latitude 42,
# or 2.5 at latitude 45). But we haven't yet precisely quantified this
# difference or its uncertainty. Let's do that next.

# We need to derive the relevant quantities: the differences in mean species
# richness between habitats at different latitudes. 

# The first half of this code is substantially the same as above; the main
# action is at the line that calculates the difference (`diff`).

# Initialize variables and storage 
lat_lwr <- (41.92 - mean_lat) / sd_lat
lat_upr <- (45 - mean_lat) / sd_lat
latitude <- seq(from=lat_lwr, to=lat_upr, length.out=50)
n <- length(latitude)
forest_bog_diff <- matrix(NA, nrow=n, ncol=3) #to store mean and hpdi values
colnames(forest_bog_diff) <- c("mndiff","difflo95","diffhi95")

# For each latitude, form the posterior
for ( i in 1:n ) {
    
    # First form samples for the linear predictor \eta
    eta_bog <- samples$beta_0 + 
        samples$beta_2 * latitude[i]
    eta_forest <- samples$beta_0 + 
        samples$beta_1 + 
        samples$beta_2 * latitude[i] + 
        samples$beta_3 * latitude[i]
    
    # Then use inverse link for samples of the posterior \mu
    mu_bog <- exp(eta_bog)
    mu_forest <- exp(eta_forest)
    
    # Now calculate the habitat difference (derived quantity)
    diff <- mu_forest - mu_bog
    
    # Mean and intervals of these samples
    forest_bog_diff[i,1] <- mean(diff)
    #forest_bog_diff[i,2:3] <- HPDI(diff, prob=0.95)
    forest_bog_diff[i,2:3] <- quantile(diff, prob=c(0.025,0.975)) #CPI
    
}

# Package in a dataframe (with latitude rescaled to original) & plot

latitude <- latitude * sd_lat + mean_lat
diff_df <- data.frame(cbind(forest_bog_diff, latitude))
rm(latitude,n,forest_bog_diff,eta_bog,eta_forest,mu_bog,mu_forest,diff) #clean up

diff_df |> 
    ggplot() +
    geom_ribbon(aes(x=latitude, ymin=difflo95, ymax=diffhi95),
        alpha=0.2) +
    geom_line(aes(x=latitude, y=mndiff)) +
    coord_cartesian(ylim=c(0,8.3)) +
    xlab("Latitude (degrees north)") +
    ylab("Difference in species richness (forest - bog)")

# Difference declines with latitude, and we can see how the uncertainty changes
# with latitude showing that mean ant richness in forest is clearly higher than
# in bog across the entire range of latitudes.
