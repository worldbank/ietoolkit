# How to run old versions of ietoolkit

There are three ways to use an old version of `ietoolkit` that we would like to recommend. 
We have listed them below in our order of preference. 
We prefer method 1 and 2 over method 3 as they only temporarily install the older version of the command. 
Method 3 creates a second full installation of the package that one should remember to remove 
when no longer needed for it to not cause issues in the future

## 1. Using Git

Start by cloning the repo using Git to your local computer

Check out the version of `ietoolkit` using the command below.
Replace `<tag_name>` with the version tag you want to use.
See available tags for `ietoolkit` [here](https://github.com/worldbank/ietoolkit/tags).
`-b <branch_name>` isn't strictly needed,
but in order to checkout a tag,
git must create a new branch.
Using `-b <branch_name>` you decide what this branch should be called
 instead of Git giving it a cryptic name.

```git checkout tags/<tag_name> -b <branch_name>```

So far we only made the code of the version you want to use availible on your computer. 
Add the code below to the beginning of your do-file. 
Replace `${path_to_clone}` with your file path to the clone and 
replace `<command_name>` with the specific command you want to use. 
If you want to use multiple commands you will have to repeat this line of code for each command

```quietly do "${path_to_clone}/src/ado_files/<command_name>.ado"```

This temporary installation of this command has the same scope as a global.
This means that Stata will keep using this version of the command until you close Stata.
After you restart Stata it will use the version of the `ietoolkit` command
you have installed using `ssc` again.

## 2. Manual installation

Navigate to the version of ietoolkit you want to use.
If you want a version for which there is a tag, 
then you can use browse the versions [here](https://github.com/worldbank/ietoolkit/tags).
Click the `.zip` link for the version you want to use and 
download the file to your computer.

If you want a any other version in this repository you need to naviage to that commit 
and download the `.zip` file using teh green "Code" button on the landing page of the repository.

Unzip the folder anywhere. Copy the `.ado` file for the command you want to use and save it in your project folder.
Then in your code before you use the command, run the code below.
Replace `${path_to_file}` with your file path in your project folder where you saved the file. 
Replace `<command_name>` with the specific command you want to use. 

```quietly do "${path_to_file}/<command_name>.ado"```

This temporary installation of this command has the same scope as a global.
This means that Stata will keep using this version of the command until you close Stata.
After you restart Stata it will use the version of the `ietoolkit` command
you have installed using `ssc` again.

## 3. Using net install

To permanently install an odler version, use the code below. 
Replace `tag_name` with the tag used for the version you want to install. 
See availible tags [here](https://github.com/worldbank/ietoolkit/tags).

```net install ietoolkit, from("https://raw.githubusercontent.com/worldbank/ietoolkit/<tag_name>") replace```

You can now use the commands as usual in your Stata code. 
This permanently installs this version of `ietollkit`
and if you want to remove this version you will have to do so manually.
If you also installed other versions or the most recent version through `SSC`
then the order of when you installed the different version of the same package matters.


