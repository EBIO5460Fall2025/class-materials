# Example C programs



### Hello world



Add the following to file named `hello.c`

```c
// Hello world
#include <stdio.h>    // Standard input/output library, contains printf() function

// Declare the function main, with no arguments (void), to return an integer
int main(void) {
    printf("Hello, world!\n");    // "\n" is newline
    return 0;    // 0 indicates to the OS that all went well
}
```



In bash terminal, compile

```bash
gcc hello.c -o hello
```



In bash terminal, run the program

```bash
./hello
```





### Hello world printed 10 times



Add the following to file named `hello10.c`

```c
// Print hello world 10 times

#include <stdio.h>

int main(void) {

    for ( int i = 0; i < 10; i++ ) {
        printf("Hello, world!\n");
    }

    return 0;
}
```



Compile & run

```bash
gcc hello10.c -o hello10
./hello10
```





### Print the result of 2 * (1 to 10 )



Add the following to file named `iby2.c`

```c
// Counter control, multiply i by 2

#include <stdio.h>

int main(void) {

    int j;

    for ( int i = 1; i <= 10; i++ ) {
        j = i * 2;
        printf("%d\n", j);    // %d integer, %f float, %s string
    }

    return 0;
}
```



Compile & run

```bash
gcc iby2.c -o iby2
./iby2
```





### Add two vectors



Add the following to file named `add2vecs.c`

```c
// Add two integer vectors, x, y, of length 10
// all x = 1, all y = 2

#include <stdio.h>

int main(void) {

    // Variable declarations

    int x[10], y[10], z[10];

    // Initialization phase
    
    for ( int i = 0; i < 10; i++ ) {
        x[i] = 1;
        y[i] = 2;
    }
    
    // Calculation phase

    for ( int i = 0; i < 10; i++ ) {
        z[i] = x[i] + y[i];
    }

    // Termination phase

    for ( int i = 0; i < 10; i++ ) {
        printf("%d\n", z[i]);
    }
    
    return 0;

}
```



Compile & run

```bash
gcc add2vecs.c -o add2vecs
./add2vecs
```

