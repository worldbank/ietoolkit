# How to contribute:
If you are familiar with how GitHub works, please feel free to make a fork and submit a pull request for any additions you want to make, but please read the **ietoolkit contribution conventions** section below first. If you are new to GitHub, start by reading the **Bug reports and feature requests** section below. 

## Bug reports and feature requests
An easy but still very efficient way to provide any feedback on these commands that does not require any GitHub knowledge is to create an *issue*. You can read *issues* submitted by other users or create a new *issue* [here](https://github.com/worldbank/ietoolkit/issues). While the word *issue* has a negative connotation outside GitHub, it can be used for any kind of feedback. If you have an idea for a new command, or a new feature on an existing command, creating an *issue* is a great tool for suggesting that to us. Please read already existing *issues* to check whether someone else has made the same suggestion or reported the same error before creating a new *issue*.

# ietoolkit contribution conventions
In addition to using common GitHub practices, please follow these conventions to make it possible to keep an overview of the progress made to the code in this toolkit.

## Commit message conventions
If your commit is specific to a command, then always start with that command name for example `iefolder: fix typo in error message`

## Working with solutions to issues
When you start working on the solution to a new issue, then create a new branch named after the issue, for example `fix issue #122`. If you want feedback on your solution to the issue or help with testing it, then ask for that before you merge the fix to the `develop` branch. If your branch contains many changes back and forth, then we suggest that you do a squashed merge to the `develop` branch. Squashed merge means that all commits in the fix issue branch are combined into a single commit in the `develop` branch where only the final changes are reflected. All commits in the branch are still saved individually in the history of that branch.

## Other branch naming conventions
Please make pull requests to the `master` branch **only** if you wish to contribute to README, LICENSE or similar meta data files. If you wish to make a contribution to any Stata file, then please **do not** use the `master` branch. If you wish to make a contribution to any Stata files that we have published at least once, then please fork from and make your pull request to the `develop` branch. The `develop` branch includes all minor edits we have made to already published commands since the last release that we will include in the next version released on the SSC server. If your addition is related to a specific issue in the repositort, then see the naming conventions in the **Working with solutions to issues** section above.

All Stata commands we are working on that we have yet to release a first version of, are found in the branches called `develop-NAME` where *NAME* corresponds to the working name of the command that is yet to be published. If you wish to contribute to any of those commands, then please fork from the branch of the command you want to contribute to, and only make edits to the .ado/.do and .sthlp that correspond to that command. If you want to make contributions to multiple commands that have yet to be released, then you will have to fork from and make pull request to multiple branches.
