
# Biological parameters
p_move <- 0.2

# Simulation parameters
t_end <- 10
delta_t <- 0.01
n_reps <- 10000


x_final <- rep(NA, n_reps)

for ( i in 1:n_reps ) {

  # Initialize
    t <- 0
    x <- 0
  
    while ( t < t_end ) {

        if ( runif(1) < p_move ) {
            if ( runif(1) < 0.5 ) {
                # move left
                x <- x - 1
            } else {
                # move right
                x <- x + 1
            }
        }
        t <- t + delta_t

    }
    x_final[i] <- x
}

print(x_final)


mean(x_final)
sd(x_final)
range(x_final)

# Distribution of the data generating process

hist(x_final)

# Tweak the histogram (adjust bins, divide by area under curve)

hist(x_final, freq=FALSE, breaks=seq(-25.5, 25.5), xlab="x",
     main = "Data generating process", xlim=c(-20, 20))

