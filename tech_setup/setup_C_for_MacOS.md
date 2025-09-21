# Setting up MacOS for C coding

If you've previously installed Xcode, you're likely already set up. To check, type this at the terminal

```bash
gcc --version
```

If this returns something sensible, skip to (2). If not, continue to install Xcode.



### 1. Install Xcode command line tools

This provides `gcc` (actually `clang`, Apple's GCC-compatible compiler)

```bash
xcode-select --install
```

- A dialog will appear. Click **Install**.
- After installation, verify with:
  ```bash
  gcc --version
  ```



### 2. Create and compile a C program

1. In Positron, create a file `hello.c`:

   ```c
   #include <stdio.h>
   
   int main() {
       printf("Hello, world!\n");
       return 0;
   }
   ```

2. Save the file

3. In the terminal, compile and then run the C program (`./` is required):

   ```bash
   gcc hello.c -o hello
   ./hello
   ```

   You should see this output:

   ```bash
   Hello, world!
   ```
