# Not vectorized addition a + b
# Element by element addition

a <- runif(5)
b <- runif(5)

c <- rep(NA, 5)
for ( i in 1:5 ) {
  c[i] <- a[i] + b[i] 
}
c 

# Vectorized addition
# Much faster to type, much faster to run, much easier to read

c <- a + b

# Still element by element under the hood
# the + operator is actually a function

"+"(a, b)

# deep down in the source code this is a C for loop that goes element by element
# 
# for ( i = 0; i < len, i++ ) {
#   c[i] <- a[i] + b[i];
# }

