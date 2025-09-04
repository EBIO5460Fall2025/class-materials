# Setting up a Git-GitHub workflow
Here we focus on getting set up with a workflow that has two components:
1. Git
2. GitHub

We'll address rationale and usage later.

## Register a GitHub account
You can use your existing account or sign up here:

https://github.com/ \
I suggest using your colorado.edu email but you don't have to.\
Email me your GitHub username so I can add you to the class's GitHub organization.

## Install Git

There are lots of options for Git [clients](https://en.wikipedia.org/wiki/Client_(computing)) (including GitHub desktop) but I highly recommend the official Git version.:\
https://git-scm.com.

Go to downloads and choose your operating system. The current version is 2.51.0.

The official version includes both a CLI ([command line interface](https://en.wikipedia.org/wiki/Command-line_interface)) and a GUI ([graphical user interface](https://en.wikipedia.org/wiki/Graphical_user_interface)).

On this website there is also a section for third-party GUI clients. You can ignore this section but feel to try some out.

**Windows**\
The installer will install both git and git-gui. When installing, there will be a bunch of questions. For most, the defaults are good. These three are important:

1) Adjust the name of initial branch name for new repositories: main
2) Choose default editor - I suggest [nano](https://www.nano-editor.org/), or [notepad++](https://notepad-plus-plus.org/).
3) Adjust your path environment if necessary: Git from the command line and also from 3rd-party software (this is the default choice). This is important to allow other programs (such as Positron or Rstudio) to find Git.

**Mac**\
Best to install via homebrew.\
You need to separately install both git and git-gui.\
If asked, install Xcode command line developer tools also.

**Linux**\
Instructions for different distributions here:\
https://git-scm.com/download/linux.

## Set up Git
Open a [CLI shell](https://en.wikipedia.org/wiki/Shell_(computing)).
**Windows:** start the "Git bash" program/app (which you installed above)\
**Mac:** start the terminal app.\
**Linux:** start the terminal app.

Set up Git with your name and email. These will label your commits to document who made changes - important when you are collaborating. You will enter this line by line into the CLI shell.
```bash
git config --global user.name "Your_full_name"
git config --global user.email "your.email@address"
git config --global --list
```
The email address should be the same one you used to register on GitHub. That's all you should need to set up. For more options, see
https://swcarpentry.github.io/git-novice/02-setup.

## Set up a test Git repository (or two)

First test that everything works. Do this directly from your personal GitHub account (i.e. not from the class organization at this stage), setting up public repos each time. Follow the directions in [Happy Git with R Can you hear me now?](https://happygitwithr.com/connect-intro.html) working through Chapters 9-11. Don't worry about understanding what is going on too much at this stage. Just follow the directions and type carefully (or copy and paste). I suggest using a personal access token with HTTPS, in which case you'll follow the directions in Chapter 9 to do this then skip Chapter 10. You can alternatively set up SSH keys if you prefer, in which case you'll follow Chapter 10 instead of Chapter 9.  In Chapter 11 you'll make the basic connection between Git and Github. Finish by cleaning up as directed.

If you run into trouble with any of this, there are lots of resources at Happy Git with R, especially [Chapter 14](http://happygitwithr.com/troubleshooting.html).
