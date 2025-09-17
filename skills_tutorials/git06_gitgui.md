# Git GUI

There's not much to say here, except that you might consider whether you prefer a graphical user interface (GUI) instead of the command line for routine tasks. I use the official Git GUI, which is installed when you install Git (you may have to [install it separately via homebrew on MacOS](https://git-scm.com/download/mac)). I use the GUI for basic stage, diff, commit, push since I find it faster than the command line for that. In fact, I also use it for most other basic tasks like fetch, merge, branch. In a windows environment you can simply right-click within the repository directory and choose "Git GUI here".

To invoke the GUI from the command line:

```bash
git gui &
```

The ampersand at the end tells bash to start the GUI but then be ready to accept the next command (otherwise you'll need to quit the GUI before entering another bash command).

The other thing I often use a GUI for is visualizing the history of the repository. The official Git tool is gitk and it is installed along with the Git GUI. This gives a very nice graphical view of all the commits on the different branches.

You can invoke the history viewer from the Git GUI or from the command line:

```bash
gitk &
```



Apart from the official GUI, there are many 3rd party GUIs, including the ones built into Positron, VSCode, or RStudio. I just use the official one everywhere as it's minimal and I only need to learn one tool. 



## Further reading:

https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Graphical-Interfaces







