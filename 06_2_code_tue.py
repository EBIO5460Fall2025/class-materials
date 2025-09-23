# This is a Python script

# Python for is sometimes sentinel controlled, e.g. list iterator constantly
# asks if the current index is greater than the length of the current list
# instead of comparing to the length of the original list. Thus, the
# following makes an infinite loop:

x = [0, 1]
for item in x:
    x.append(item)


# Python lists

mylist = list(range(1, 11))
print(mylist)

# The elements of a list can themselves be more complex objects. Here is a list
# containing two different kinds of lists plus a string.

mynewlist = [[0, 1, 2, 3, 4, 5], ["a", 31.2, "d"], "unicorn"]
print(mynewlist)

# List comprehensions (mini algorithms embedded in a list)

double_mylist = [2 * x for x in mylist]
print(double_mylist)

# To refer to elements of a list, use list indexing notation. Python indexes
# from 0.

mylist[0]          # 1st element
mylist[3]          # 4th element
mylist[10]         # index out of range
mynewlist[1][2]    # 3rd element of the 2nd element

# Ranges include the first index but exclude the last index!

mylist[0:4]        # 1st to 4th element (first 4 elements)
mylist[:4]         # same (first 4 elements)
mylist[-2:]        # last 2 elements
mynewlist[1][1:3]  # 2nd to 3rd element of the 2nd element
mynewlist[1][2:3]  # list with just the 3rd element of the 2nd element

# Accessing non contiguous elements (use list comprehension)

[mylist[i] for i in [0, 3, 4]]


# List operators

# They don't do element by element math but instead expand or combine existing
# elements into new lists

x = [2] * 10
print(x)
y = [8] * 10
print(y)
z = x + y
print(z)



# A list is from a broader category of objects known as sequences
# lists, tuples (immutable lists), strings
# Operators for these have the same behavior
# e.g. strings

part_1 = "Once upon a time, "
part_2 = "there was a data science class about "
part_3 = "unicorns and rainbows."

the_end = part_1 + part_2 + part_3
print(the_end)

my_favorite_things = (part_3 + " ") * 3
print(my_favorite_things)


# Strings (a sequence type) are iterable

rainbow = "My little pony"
for character in rainbow:
    print(character)


# Keeping results in lists

# Classic preallocation pattern

x = 2
results = [None] * 10
for i in range(10):
    x = x * 2
    results[i] = x
results

# Appending a list in Python costs little in memory allocation and time, so the
# following is the usual way

# (This contrasts with R, where appending a list has large speed costs)

x = 2
results = []
for i in range(10):
    x = x * 2
    results.append(x)
results

# However, most numerical work in Python is not done with lists. For numerical
# work, we turn to numpy. (Like R, appending a numpy array is slow).


# Object referencing behavior

# Python: mutable objects can change other objects that reference them
# R: changing an object will not cause changes in another

# e.g. 1. Assignment

a = list(range(10))
b = a
print(a)
print(b)

# Now change something in a
a[2] = 20
print(a)

# But b has also changed
print(b)

# This is because a and b refer to the same object in memory
# a and b are **bound** to the same object

# e.g. 2. An object that references another

# Define two lists
x = ["g", 42.0, "pony"]
y = list(range(10, -1, -2))

# Define a third list consisting of the previous two
z = [x, y]
print(z)

# But z is actually a list of references to the objects x and y. If we change x
# or y in any way, the change is also in z.
x[2] = "unicorn"
print(z)

# However, if we reassign x, z still references the object before the
# reassignment.
x = [2, 4]
print(z)

# The object that x previously referred to still exists (with a reference ID).
# It just no longer has a name. That name has been **bound** to a new object. It
# will continue to exist as long as it is referred to by any other object.
