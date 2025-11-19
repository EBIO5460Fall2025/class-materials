# Homework

**Due:** Tuesday 2 Dec 3:30 PM (i.e. before class)

**Grading criteria:** Problems from question 3 with a complete attempt. On time submission.

**Format for submitting solutions:**

* Submit one file of R code for question 3 named `McElreathCh8_assignment.R`
* You can add any prefixes to the filename that work with your file naming scheme. 

**Push your file to your GitHub repository**


## 1. Set up RStan

This can be fussy if you previously installed an older version of Stan or another package that depended on Stan. The instructions below assume you have **R version 4.4.x** installed and are based on the more comprehensive instructions at [RStan Getting Started](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started), which you can consult for troubleshooting (or if you are working with an earlier version of R).

**Step 1. Uninstall Rstan**

It's best to uninstall this and start clean. Open Positron/Rstudio and do this:

```r
remove.packages("rstan")
if (file.exists(".RData")) file.remove(".RData")
```

Then, close Positron/Rstudio.

**Step 2. Configure C Toolchain**

**Microsoft Windows**

* These instructions are based on the full instructions here:
  * https://mc-stan.org/docs/cmdstan-guide/installation.html#windows
* The instructions below are for Intel/AMD 64-bit (x86_64) architectures (which is most laptops). If you have an ARM architecture, the instructions are almost identical but minor important details, such as filenames, differ. See the link above.
* First check if you have Rtools installed (most people won't) by going to the Windows Control Panel (start > type "control") and navigate to "Uninstall a program". If it is installed and it is older than Rtools42, uninstall the old version first using the Windows Control Panel.
* Download the Rtools44 installer from here: https://cran.r-project.org/bin/windows/Rtools/rtools44/files/rtools44-6459-6401.exe. This is a large file, about 500MB.
* Run the installer. This will take a few minutes.
* Next, you need to add the following directories to your `PATH` variable
  ```
  C:\rtools44\usr\bin
  C:\rtools44\x86_64-w64-mingw32.static.posix\bin
  ```
* Instructions for updating the PATH:
  * https://helpdeskgeek.com/windows-10/add-windows-path-environment-variable/
  * Click Start > type "advanced system settings" > click "View advanced system settings"
  * You will be on the Advanced tab of the System Properties dialogue
  * Click Environment variables
  * In the top panel click on the line that says Path
    * choose Edit
  * Click New
    * paste the first path
  * Click New
    * paste the second path
  * Click OK to save changes
  * Click OK to save Environment Variables
  * Click OK to exit system properties
* Check the toolchain is working
  * Click Start > type "windows powershell" > click "Windows powershell"
  * Type these commands
    ```
    g++ --version
    make --version
    ```
  * It should report versions. If not, the installation is not correct. You can close the powershell window.


**Mac OS**

* Follow the instructions here:
  * https://mc-stan.org/docs/cmdstan-guide/installation.html#macos


**Step 3. Install Rstan**

**Windows & MacOS**

You can usually simply type (exactly like this)
```
Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1)
install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies = TRUE)
```

**Step 4. Test RStan**

To verify your installation, you can run the RStan example/test model:
```
example(stan_model, package = "rstan", run.dontrun = TRUE)
```

 The model should then compile and sample. It might first dump a whole lot of text to the console and then seem not to be doing anything. You might need to wait a few minutes for the model to compile. You may also see a warning. If the model has successfully compiled and sampled it will produce output like this:

```
SAMPLING FOR MODEL 'anon_model' NOW (CHAIN 1).
Chain 1: 
Chain 1: Gradient evaluation took 8.3e-05 seconds
Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.83 seconds.
Chain 1: Adjust your expectations accordingly!
Chain 1: 
Chain 1: 
Chain 1: Iteration:    1 / 2000 [  0%]  (Warmup)
Chain 1: Iteration:  200 / 2000 [ 10%]  (Warmup)
Chain 1: Iteration:  400 / 2000 [ 20%]  (Warmup)
Chain 1: Iteration:  600 / 2000 [ 30%]  (Warmup)
Chain 1: Iteration:  800 / 2000 [ 40%]  (Warmup)
Chain 1: Iteration: 1000 / 2000 [ 50%]  (Warmup)
Chain 1: Iteration: 1001 / 2000 [ 50%]  (Sampling)
Chain 1: Iteration: 1200 / 2000 [ 60%]  (Sampling)
Chain 1: Iteration: 1400 / 2000 [ 70%]  (Sampling)
Chain 1: Iteration: 1600 / 2000 [ 80%]  (Sampling)
Chain 1: Iteration: 1800 / 2000 [ 90%]  (Sampling)
Chain 1: Iteration: 2000 / 2000 [100%]  (Sampling)
Chain 1: 
Chain 1:  Elapsed Time: 0.011 seconds (Warm-up)
Chain 1:                0.01 seconds (Sampling)
Chain 1:                0.021 seconds (Total)
Chain 1: 

SAMPLING FOR MODEL 'anon_model' NOW (CHAIN 2).
Chain 2:
...
```



## 2. Install cmdstan

This is for use with McElreath's `rethinking` package. We already installed the R package `cmdstanr` last week but now we need to install cmdstan itself, which involves compiling its C++ program. It's easiest to do this from R.

Close and then reopen Positron/Rstudio and run (one line at a time)
```r
library(cmdstanr)
check_cmdstan_toolchain(fix = TRUE)
install_cmdstan()
```

Each step may take several minutes and dump a lot of text to the console.


## 3. McElreath Chapter 8.

You can use the text in Google Drive. We are using the first edition. The second edition is largely the same (now Chapter 9) but longer with expanded background. The shorter version suits this class.

Wherever it says to use `map()`, use `sampost()` instead. Read in the `sampost` function first (as for last week).

```r
sampost <- function( flist, data, n=10000 ) {
    quadapprox <- map(flist,data)
    posterior_sample <- extract.samples(quadapprox,n)
    return(posterior_sample)
}
```

Wherever it says use `map2stan()`, use the newer `ulam()` instead.

A full script of the code (with new functions and compatibility updates) for Chapter 8 is in

* [14_5_mcelreath_ch8_code.R](14_5_mcelreath_ch8_code.R)

Do the easy and medium problem sets.
