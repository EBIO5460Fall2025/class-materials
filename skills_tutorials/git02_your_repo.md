# Take control of your GitHub repo for this class

I will set up a GitHub repo for you that is within the private GitHub space for this class. This repo is not public (i.e. not open to the world). You and I both have write access to this repo. To take control of your repo, you will clone it to your computer using RStudio.

1. Go to the class GitHub organization. From your personal GitHub profile page, look to the left for organizations. The organization name is EBIO5460Fall2025. Or directly, the URL is https://github.com/EBIO5460Fall2025.
2. Find your repo. It is called ds4e-firstname-lastinitial.
3. From the green `Code` button in your repo, copy its URL to the clipboard.
4. Clone it to your computer, as you did in the Git setup tutorial.

You're now ready to organize and develop your class materials in your repository, which is now also a directory (folder) on your computer. In the directory you just created, you'll find two files.

1. `README.md`. This file was created by GitHub. This is a plain text file with extension `.md`, indicating that it's a file in Markdown format. We'll learn more about Markdown soon. The `README.md` file will be where you begin documenting your repository and will become a guide to files and further documentation. The contents of this file are displayed, nicely formatted, on the home page of your GitHub repo. You can edit this file using a text editor.
2. `.gitignore`. This file was created by my setup script and is used by Git. This file tells Git which files or types of files to ignore in your repository (i.e. files that won't be under version control). For now I've added some temporary files to ignore, including `.Rhistory` and `.Rdata`, because it usually doesn't make sense to track these. We'll add more to this `.gitignore` file as the semester progresses. You can use a text editor to add other files to `.gitignore`.
