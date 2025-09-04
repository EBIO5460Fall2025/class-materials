# File management using the terminal



To list the files in a directory type:

```bash
ls       # just the names
ls -hal  # human readable list with details, including hidden files
```

Make new directories (folders) within the current directory

```bash
mkdir mydirectory
```

Rename, move, or copy files

```bash
mv old_filename new_filename  # rename
mv myfile mydirectory         # move
cp myfile mynewfile           # copy
```

Navigate among directories (folders)

```bash
pwd                  # where am I now? "print working directory"
cd mydirectory       # change directory
cd ..                # move up to the parent directory
cd ~                 # change to home directory
cd /                 # change to the root directory
cd /home/brett/Documents/myprojects    # change to a directory given as a path 
```

Some other useful bash commands

```bash
cat myfile           # view the contents of a file
rm myfile            # delete (remove) files
rmdir mydirectory    # remove directory (needs to be empty)
rm -r mydirectory    # remove directory with all its subfolders and files
man <command>        # help (manual) on a command
man mv               # e.g. help for move
```

