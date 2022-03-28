# How to run old versions of ietoolkit

There are three ways to use an old version of `ietoolkit` that we would like to recommend. We have listed them below in our order of preference. We prefer method 1 and 2 over method 3 as they only temporarily install the older version of the command. Method 3 creates a second full installation of the package that one should remember to remove for it to not cause issues in the future

## 1. Using Git

** Clone the repo in Git
** Check out the version of `ietoolkit` using this command.
Replace `<tag_name>` with the version tag you want to use.
See available tags for `ietoolkit` [here](https://github.com/worldbank/ietoolkit/tags).
`-b <branch_name>` isn't strictly needed,
but in order to checkout a tag,
git must create a new branch.
Using `-b <branch_name>` you decide what this branch should be called
 instead of Git giving it a cryptic name.
`git checkout tags/<tag_name> -b <branch_name>`
** So far we only made the code of the version you want to use availible on your computer. Next you need to load it into temporary memory in Stata. You do that with the following code. Replace `${path_to_clone}` with your file path to the clone and replace `<command_name>` with the specific command you want to use. If you want to use multiple commands you will have to repeat this line of code for each command
`quietly do "${path_to_clone}/src/ado_files/<command_name>.ado"`
** This temporary installation of this command has the same scope as a global.
This means that Stata will keep using this version of the command until you close Stata.
After you restart Stata it will use the version of the `ietoolkit` command
you have installed using `ssc` again.

## 2. Manual installation


## 3. Using net install
