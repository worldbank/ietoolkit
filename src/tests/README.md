# Folder for test files

The folders in this folder is expected to be created using the command `ad_command`.
For each new command, `ad_command` creates a folder named after the command and creates a do-file in that folder.
That do-file is the main do-file.

In the command specific folders, users may create whatever files they need to create and run the relevant tests.
If you are using GitHub and have used `adodown` to set up GitHub files, then you can, in these command folders,
create a folder called `inputs` and a folder called `outputs`.
These folders and their content is ignored from the repository.
If you do want to commit your inputs or outputs in this test to your repository,
then just name the folders something slightly different.
