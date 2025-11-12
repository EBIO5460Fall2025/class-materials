
# Data generating process model for the ants data

latitude <- seq(42, 45, length.out=22)
site <- 1:22
beta_0 <- 14.2  #Bog   log(5) = beta_0 + beta_1 * 42 -> beta_0 = log(5) - beta_1 * 42
beta_1 <- -0.3  #      (log(7) - log(2)) / (45 - 42)
beta_2 <- 15.3  #Forest
beta_3 <- -0.3
sdlog_site <- 0.1
sdlog_plot <- 0.1

s <- rnorm(length(site), mean=0, sd=sdlog_site)
e_bog <- rnorm(length(latitude), mean=0, sd=sdlog_plot)
e_forest <- rnorm(length(latitude), mean=0, sd=sdlog_plot)

ln_mu_bog <- beta_0 + beta_1 * latitude + s + e_bog
ln_mu_forest <- beta_2 + beta_3 * latitude + s + e_forest

mu_bog <- exp(ln_mu_bog)
mu_forest <- exp(ln_mu_forest)

richness_bog <- rpois(length(mu_bog), mu_bog)
richness_forest <- rpois(length(mu_forest), mu_forest)

plot(latitude, richness_forest, ylim=c(0, max(richness_forest)))
points(latitude, richness_bog, col="red")



