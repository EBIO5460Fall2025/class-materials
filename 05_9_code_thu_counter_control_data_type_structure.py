# Python lists and counter control 

# Lists can hold heterogeneous elements

mylist = ["a", 9, "b"]
mylist
type(mylist)
type(mylist[0])
type(mylist[1])

# Lists can be constructed from iterables. Here is the sequence 0 to 10 by 2

x = list(range(0, 11, 2))
x
type(x)
type(x[0])

# An iterable is required as the argument to `list()`, so the following does not
# work

mylist = list("a", 9, "b")


# Counter control
# for item in iterable

# Classic counter-controlled repetition

for i in range(10):
    print("Hello")

# More general `for item in iterable` example

for i in range(1, 11):
    j = i * 2
    print(j)

# Iterate over a collection

rainbow = list(range(1, 11))
for i in rainbow:
    j = i * 2
    print(j)

# As with R, and C, any names are valid for the counter/item variable

rainbow = list(range(1, 11))
for unicorn in rainbow:
    j = unicorn * 2
    print(j)

# range() produces an object of type "iterable"

myiter <- range(1, 11)
type(myiter)

