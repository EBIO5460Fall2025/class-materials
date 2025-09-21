# Setting up Windows for C coding

There are various ways to do this. We'll use an approach that's equivalent for everyone in the class by using Linux. Positron and the editor will be working in Windows but compiling and running C programs will be done using Ubuntu Linux running as a virtual machine (VM) in Windows Subsystem for Linux.



### 1. Install Windows Subsystem for Linux (WSL2)

1. Open PowerShell as Administrator and run:
   ```powershell
   wsl --install
   ```

2. Restart the computer if prompted

3. Once logged back in, a terminal will be open. This is installing an Ubuntu Linux system (Ubuntu 24.04). Wait for Ubuntu to install (it might take some time and look like it's stuck at zero but be patient)

4. Launch Ubuntu from the Windows Start menu (there should now be an application icon). It may take a moment to start up. Once it starts, it will ask to set up a username and password. It doesn't matter what the username is (first name in lowercase is a natural choice). Don't forget the password because you'll need to use it reasonably often.



### 2. Install GCC in Ubuntu

In the Ubuntu terminal:
```bash
sudo apt update
sudo apt upgrade
sudo apt install build-essential
```

In Ubuntu, all the installed software is managed by the package manager, APT (Advanced Package Tool). The first line updates the package manager records. The second line updates any installed packages that are out of date. During the package installation process, generally follow the instructions and choose `y` to proceed. The final line installs `gcc` and other tools needed to compile C programs.

You can close the Ubuntu terminal window, or leave it open. You can either use this terminal, or start one from within Positron. You can have both running at the same time. Using this terminal, you need to navigate to your git repository on your Windows file system. The windows file system on the `C:` drive is mounted to the Ubuntu VM. You get to it like so:

```bash
cd /mnt/c/Users/your_username/rest_of_path_to_git_directory
```



### 3. Starting WSL within Positron

On the terminal tab, you'll likely be in the powershell terminal. If not, switch to powershell. Then type:

```powershell
wsl
```

WSL will start and the prompt will change to the WSL terminal. **You are now in linux!** The nice thing about this approach is that the terminal starts in the current working directory.

>  Footnote:
>
> If you click on the down arrow on the terminal bar, you'll see a selection of available terminals. One of these is likely Ubuntu 24.04. However, at this time, it doesn't work to start Ubuntu this way, only via powershell.



### 4. Create and compile a C program

1. In Positron, create a file `hello.c`:

   ```c
   #include <stdio.h>
   
   int main() {
       printf("Hello, WSL!\n");
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
   Hello, WSL!
   ```

