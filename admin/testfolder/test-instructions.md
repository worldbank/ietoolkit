# Instructions and best-practices for testing **ietoolkit** (and Stata commands in general)

## Installing _not-yet released_ versions of **ietoolkit**
**DO NOT** follow these instructions if you want to install the version of **ietoolkit** that is tested for public release. Use **`ssc install ietoolkit`** if that is what you want to do.

There are two ways for how to install not-yet released versions of **ietoolkit** that we recommend. Through `net install` or `do`, the list below helps you decide what you want to do:
* `net install`
    * Automated and do not require that you manually clone or download any files to your computer.
    * The version of the commands you install this way stays installed until you actively uninstall them and install the version you had installed before or any other version. This could be both good and bad.
    * The help files can be viewed (if they exist already) the same way as you normally view a help file with the command `help`.
    * This point only applies if you are setting up your own repository so that the command you wrote can be installed the same way,  **ietoolkit** already has these files. This method required a `.toc` and a `.pkg` file to be set up in the repository.
    * This method can be used to install any version of **ietoolkit** since commit [22da4fb](https://github.com/worldbank/ietoolkit/commit/22da4fb) made on December 11, 2018.
    * This method does sometime not work if you do not have admin rights to your computer, which is common on work computer. For example, this does not work on World Bank computers unless you have specifically been given admin right by the World Bank IT team.
* `do`
    * These instructions applies to any command written in any `.ado` or `.do` file, not just the **ietoolkit** files.
    * Requires you to manually put the files on your computer, either by downloading or cloning the files, or if it is a command you are writing yourself the files are already on your computer.
    * You cannot use the command `help` to view the help files of this version. If you use `help` you will see the help file of the version of the command previously installed, or get an error if the command was not installed previously. See instructions below how to read the help file.
    * The commands are only installed until you close your Stata window or you run `clear all` after which you will have to repeat this installation. If you do not repeat the installation you will either go back to the version of the command you had before this installation, or to not having these commands installed if these commands were not installed before this installation.
    * This method can be used to install any version of **ietoolkit** in the repository since the initial commit. Just go to [the repo](https://github.com/worldbank/ietoolkit) and download the files of the repository at the point of that commit.

### How to install not-yet released version using `net install`

First you must uninstall any installation of the same package that you already have installed to make sure that the version you end up having installed is the version you are installing through `net install`. If the version number is updated already the uninstallation step is not needed, but since these files are not prepared for release yet we do not know if that is the case and should therefore always uninstall first.

```stata
*uninstalling any version of ietoolkit already installed
ado uninstall ietoolkit //will generate error that can be ignored if commands are not installed

*Install the version of ietoolkit that is in the develop branch
net install ietoolkit , from("https://raw.githubusercontent.com/worldbank/ietoolkit/develop/src")
```

The version of **ietoolkit** in the `develop` branch will not stay installed unless they are actively replaced. The code below shows how to uninstalled the version of **ietoolkit** you just installed and go back to having the most recently released version of **ietoolkit** installed.

```stata
*uninstalling any version of ietoolkit already installed
ado uninstall ietoolkit //will generate error that can be ignored if commands are not installed

*Install the most recent published version of ietoolkit
ssc install ietoolkit
```

You can install **ietoolkit** from any branch in the repository. Just replace `develop` with the name of the branch you want to install from in `net install ietoolkit , from("https://raw.githubusercontent.com/worldbank/ietoolkit/develop/src")`.

### How to install not-yet released version using `do`

This applies both (1) if you are writing your own ado-file, or made changes to an ado-file on disk, or (2) if you would like to test a new user-written command, or a new version of an existing command that has not yet been deployed and you have downloaded the file to your computer via GitHub or Dropbox. For the purposes of this exercise, we will use `iebaltab` as an example, but it applies to any command you may like to test.

When you install a command from SSC, Stata saves the ado-file that contains the code for the command in a special folder on your computer. Which folder this is differs between users and operative systems, but you can see the different possible folders that Stata may save commands by typing `sysdir` in Stata. You do not need to know the differences between these folders, and how Stata uses them. However, it might be helpful to know for this testing exercise that, by default, Stata looks in those folders for all ado-files whenever you type a command. For example, it will search there for *iebaltab.ado* if you use the command `iebaltab` in Stata.

If your code isn't ready for a "final" installed version, you want to make an edit to `iebaltab` and want to temporarily have Stata run your experimental version of *iebaltab.ado* – _instead of the version you installed through SSC_. Then, you need to load the command into the one place Stata looks _before_ looking in the folders described in the paragraph above, and that is __current memory__. To load a command into memory you simple use the command `do` and run the ado-file with your edits. Now, Stata will run the command from current memory instead. (It can also be good practice to do this as part of release packages and GitHub repos; see https://github.com/qutubproject/plosmed2018 for an example.) Stata will then use the temporary version of the command until you either close the Stata window or type `clear all`. See example below. Note that you need to change the ${ietoolkitRepo} global to point where the ietoolkit repo is saved on your computer.

```
global ietoolkitRepo "C:\Users/username/Documents/GitHub/ietoolkit"
do "${ietoolkitRepo}/src/ado_files/iebaltab.ado"
```

If it is a new command or you do not have the command installed already you would still follow the same steps to temporarily install a command in Stata.

#### How to view a new help file or a new version of a help file
If you type `help iebaltab` you will see the help file of already installed version of iebaltab. When you want to read the help file for a new command or the new version of a helpfile that includes the new features of the command you instead have to use the *View* option in the *File* drop-down menu. After you click *View* you browse to the location on your computer where you have the new version of the help file and select that file.

## What to test for when testing a Stata commands

There are two main aspects when testing a command which are, **Does the command work?** and **Does the command make sense?**. The two questions are equally important as it does not matter how good a command works if it makes sense to anyone but the person who developed it. *Making sense* should be interpreted in the broadest possible sense here. For example, *Is it intuitive what the purpose of the command is?*, *Is it intuitive how the command is specified?*, *Does the documentation make sense?*, *Do the error messages make sense and are they helpful?* etc. The developer can do a lot to test if the command works, but will ultimately need help from the user base to know if it make sense.

This is a suggested approach to how to test a command:
1. Simplest case
    1. If it is a new command, or a command you have never used, try to figure out the simplest way the command can be used (i.e. the fewest amount of options used) and make sure you understand the input, the calculations and the output. In this process, try to come up with a way that the documentation could have been more helpful to you coming up with this case.
      1. To test a command, see if there is a *run-file* where someone have already prepared this simplest way to use the command.
      1. After you have tested on the data in the *run-file* test the same specification of your own data
      1. If there is no *run-file* come up with your own most simple case
1. Standard case
    1. After you tested the most simple case it is time to test a standard case. Again, see if there is a *run-file* that have prepared such a case for you. If there is no such file, see if you can use the documentation to come up with that case
    1. If the command has new features, you can skip testing the most simple case and go directly to test that specific feature.
1. Special cases
    1. A special case where the command is supposed to work. Come up with a case that is special but you still expect the command to handle that. For example:
        1. Some observations have missing values in variables used
        1. Both numeric and string variables are working if that is supposed to be the cases
    1. A special case where the command is not supposed to work. This should lead to the command providing a helpful error message instead of an unhelpful error message, or - even worse - incorrect analysis.
        1. Use string variable where numeric is expected, and vice versa.
        1. Use corner case variables, like zero or very large values
        1. Specify too many or too few variables
