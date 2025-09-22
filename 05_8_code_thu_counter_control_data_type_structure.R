# R data types/structures and iterating over a collection

# Querying objects in R for data type and data structure

mylist <- list(9, "A", 2)
mylist
class(mylist)
typeof(mylist)      #because list is a mixed data type
typeof(mylist[[1]]) #[[]] extracts the element
typeof(mylist[[2]])
typeof(mylist[2])   #[] extracts a list with one element

myobj <- c(9, "A", 2)  #coerced to character vector
myobj
class(myobj)        #character vector
typeof(myobj)

mybool <- c(TRUE, TRUE, FALSE)
mybool
class(mybool)       #logical vector
typeof(mybool)

mychar <- c("a", "b", "c")
class(mychar)       #character vector
typeof(mychar)

mymat <- matrix(1.2, 2, 3)
mymat
class(mymat)
typeof(mymat)

myarr <- array(2L, dim=c(2, 3, 4))
myarr
class(myarr)
typeof(myarr)


# Iterate over a collection (vector 1 to 10)

rainbow <- 1:10
for ( i in rainbow ) {
    j = i * 2
    print(j)
}

# Any names are valid for the counter/item variable

rainbow <- 1:10
for ( unicorn in rainbow ) {
    j = unicorn * 2
    print(j)
}

# Iterate over a collection (vector, sequence)

myvec <- seq(0, 20, by=2)
for ( unicorn in myvec ) {
    j <- unicorn * 2
    print(j)
}

# Iterate over a list

a <- c(0.51,0.57,0.09,1.02,1.10)
for ( number in a ) {
    print(number * 2)
}

# Iterate over a list to do something useful

a <- rnorm(100, mean=10, sd=3)
b <- rnorm(100, mean=25, sd=10)
c <- rnorm(100, mean=25, sd=1)
d <- rnorm(100, mean=50, sd=10)
datasets <- list(a, b, c, d)
datasets
class(datasets)

for ( x in datasets ) {
    hist(x)
    abline(v=mean(x), col="red")
}

