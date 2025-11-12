# Data generating process for the logit binomial model
# Swiss breeding bird survey

elev <- seq(250, 2750, length.out=100)
beta_0 <- -8
beta_1 <- 0.01
beta_2 <- -3.5e-06

# Deterministic skeleton

logitp <- beta_0 + beta_1 * elev + beta_2 * elev^2
p <- exp(logitp) / (1 + exp(logitp))

plot(elev, logitp)
plot(elev, p)


# Binomial process

occurrence <- rbinom(length(p), 1, p)
plot(elev, occurrence)

