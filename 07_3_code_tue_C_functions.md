# Functions in C

A simple function to add two numbers

```c
#include <stdio.h>

// Function to add two doubles
double add_two_nums(double a, double b) {
    return a + b;
}

// Use the function
int main() {
    double num1 = 5.7;
    double num2 = 3.3;

    double result = add_two_nums(num1, num2);

    printf("The sum of %.2f and %.2f is %.2f\n", num1, num2, result); //2 decimal places for printing

    return 0;
}
```

Above, we defined the function before `main()`. But in more complex programs, it's customary to put all the custom functions after `main()`. When we do that, we need to put a function declaration before `main()`. The function declaration (called a function prototype) contains the first line of the function definition, without the body. The compiler uses this information to process the code in `main()`.

```c
#include <stdio.h>

// Function declaration
double add_two_nums(double a, double b);

int main() {
    double num1 = 5.7;
    double num2 = 3.3;

    double result = add_two_nums(num1, num2);

    printf("The sum of %.2f and %.2f is %.2f\n", num1, num2, result);

    return 0;
}

// Function to add two doubles
double add_two_nums(double a, double b) {
    return a + b;
}
```


General scoping rule: where the variable is declared

```c
#include <stdio.h>

// Function to add two doubles
double add_two_nums(double a, double b) {
    double c = a + b;
    return c;
}


int main() {
    double num1 = 4.6;
    double num2 = 3.2;

    // Declared in scope `main(){}`
    double b = 20.0;
    double c = 10.0;

    double result = add_two_nums(num1, num2);

    printf("The sum of %.2f and %.2f is %.2f\n", num1, num2, result);
    printf("b declared in main, %.2f, was not added\n", b);
    printf("c declared in main is not changed: %.2f\n", c);

    return 0;
}
```

This time declare b outside of `add_two_nums()`. We need to nest the function inside main.

> With respect to `add_two_nums()`, b is a global variable.

```c
#include <stdio.h>

int main() {
    double num1 = 4.6;

    // Declared in scope `main(){}`
    double b = 20.0;
    double c = 10.0;

    // Function to add two doubles, also declared in scope main()
    double add_two_nums(double a) {
        double c = a + b;
        return c;
    }

    double result = add_two_nums(num1);

    printf("The sum of %.2f and %.2f is %.2f\n", num1, b, result);
    printf("b declared in main, %.2f, was added to num1, %.2f\n", b, num1);
    printf("c declared in main is still not changed: %.2f\n", c);

    return 0;
}
```
