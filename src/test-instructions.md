# Instructions and best-practices for testing Stata Commands

### How to temporarily install a new command or a experimental version of an already installed command
This applies both to if you have made a change to a file on disk, or if that is a file that someone else have done and you have downloaded those edits to your computer via for example GitHub Desktop.

When you install a command from SSC, Stata saves the file that contain the code for the command in a folder on your computer. Which folder this is differ from between users and operative systems, but you can see the different possible folders that Stata may save commands by typing `sysdir` in Stata. You do not need to know the differences between these folders, and how Stata use them, but it might be helpful to know for this testing exercise that it is in those folders Stata looks for an .ado file called, for example, *iebaltab.ado* each time you use the command `iebaltab` in Stata.

If you want to make an edit to `iebaltab` and want to temporarily have Stata run your experimental version of *iebaltab.ado* instead of the version you installed through SSC, then you need to load the command in the one place Stata looks before looking in the folders described in the paragraph above, and that is current memory. To load a command in temporary memory you simple use the command `do` and run the file with your edits. Now Stata will run the command from current memory instead. Stata will do so until you either close the Stata window or type `clear all`. See example below. Note that you need to change the global to point where the ietoolkit repo is saved on your computer.

```
global ietoolkitRepo "C:\Users/username/Documents/GitHub/ietoolkit"
do "$ietoolkitRepo/src/ado_files/iebaltab.ado"
```

If it is a new command or you do not have the command installed already you would still follow the same steps to temporarily install a command in Stata.

