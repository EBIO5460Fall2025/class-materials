# Install Miniconda

In data science, one of the most common ways to manage Python and R installations for specific projects is the conda environment and package management system. 

Download and install miniconda from here
* https://www.anaconda.com/download/success
* Be sure to choose "Miniconda Installers"

Installation directions are here:
* https://www.anaconda.com/docs/getting-started/miniconda/install#basic-install-instructions

During the installation, say yes to conda initialization but then do the following:

```bash
conda config --set auto_activate_base false
```

This will prevent conda from always activating when you start a shell.
