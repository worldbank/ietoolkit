# Title

__ieboilstart__ - applies best practices for collaboration and reproducibility within a project.

For a more descriptive discussion on the intended usage and workflow of this command please see the [DIME Wiki](https://dimewiki.worldbank.org/wiki/Ieboilstart).

__DISCLAIMER__ - One objective of this command is to harmonize settings across users. However, it is impossible to guarantee that different types of Stata (version number, Small/IC/SE/MP or PC/Mac/Linux) will work exactly the same in every possible context. This command does not guarantee against any version discrepancies in Stata or in user-contributed commands. This command is solely a collection of common practices to reduce the risk that the same code generates different outputs when running on different computers. See more details below.

# Syntax

__ieboilstart__ , __**v**ersionnumber__( _Stata_version_ ) [__**ado**path__(_"path/to/folder"_, {_strict_ | _nostrict_}) __noclear__ __**q**uietly__ __veryquietly__ _memory_options_ ]

Note that one important feature of this command requires that  __r(version)__ is written on the first do-file after __ieboilstart__. This setting cannot be specified within a user command and ensures that the Stata version is set correctly. For example:

``` 
ieboilstart , options 
`r(version)'
```



| _options_ | Description |
|-----------|-------------|
| __**v**ersionnumber__(_Stata_version_)                      | Sets the Stata version for all subsequent code execution (required) |
| __**ado**path__(_"path/to/folder"_, {_strict_ / _nostrict_}) | Sets the folder where this project's ado-files or user-written commands are stored (required for standalone reproducibility packages) |
| __noclear__                                             | Makes the command not start by clearing all data                    |
| __**q**uietly__                                             | Suppresses most of the command's output                             |
| __veryquietly__                                         | Suppresses all of the command's output                              |

## Memory options

| _options_ | Description |
|-----------|-------------|
| __maxvar__(_numlist_) | Manually specify maximum number of variables allowed |
| __matsize__(_numlist_) | Manually specify maximum number of variables allowed in estimation commands |
| __**noperm**anently__ | Disable the default to permanently set some best practice memory settings |


# Description 

__ieboilstart__ applies best practices for collaboration and reproducibility within a research project. Making the same Stata code consistently generate the same results when run on other people's computers is harder than what it first might seem. This is especially true in order to ensure that Stata code will function identically in the future, even if new versions of Stata and user-written commands (such as those on SSC) have been released. The objective of this command is to reduce the risk that a research project's code changes its results when running the same code on different computers or in different points in the future. However, note that it is not technically possible to fully eliminate this risk.

The best practice settings this command applies can be categorized into the following types: version control of built-in commands, version control of user-written commands, _other_ settings.

## Version control: Stata and built-in commands

Research projects often span over several years, and are required to be reproducible for anyone in the future reviewing the results. After several years have passed, it is likely that a new version of Stata has been released. When Stata releases a new version they add new built-in commands, but they might also make changes to already published commands.

For you to make sure that old code in your project behaves the same way even after you update your Stata installation you need to version control the built-in commands in Stata. You also need to version control the built-in commands in Stata when you are collaborating as you cannot be sure what version of Stata everyone else are using at all points in time. Finally, this becomes particularly important when preparing a reproducibility package that should stand the test of time, as you definitely do not know what version of Stata someone in the future will use.

One example where this becomes important is reproducible randomization. Sometimes Stata updates the random number generator between versions. Unless the built-in commands that use randomization are version controlled, then the results of the randomization can vary between versions of Stata. This is true even if other requirements for reproducible randomization is used, such as setting the seed (see `help seed`). Each time Stata updates the random number generator it gets marginally better. However, for the vast majority of research projects, this improvement is so marginal it is most definitely negligible.

This command uses the Stata command __version__ (see `help version`) to version control all built-in commands. For some good technical reasons, it is not possible for __ieboilstart__ to set the version for the rest of the project's code from inside the command. This means that all __ieboilstart__ start is preparing the line of code you need to run to version control all built-in commands. You need to run this line of code on the immediate subsequent line after __ieboilstart__. Like this:

``` 
ieboilstart , options 
`r(version)'
```

The version setting has the scope of a local, meaning that it expires when a do-file and all sub-dofiles it is calling are completed. If [main/master do-files](https://dimewiki.worldbank.org/Master_Do-files) are used, then the version should be set in the main file, and only results generated when running all code from the main file should be considered reproducible.

It is just as important, if not more important, to version control the user-written commands as well. See next section for how to version control user-written commands, such as commands installed from _SSC_ (see `help ssc`).

## Version control: User-written commands

The option __adopath()__ makes one key reproducibility component easy to use in Stata. Many projects in Stata relies on user-written commands, such as commands installed from SSC. With user-written commands there is always a risk that the project code does not reproduce correctly if a different version of any user-written command is used. This applies when team members collaborate in real team on a project, but it is especially a risk if someone would try to reproduce the project results in the future. User-written commands updates frequently, and depending on when a user installed a command or when it was last updated, the version of a command that user use will inevitable eventually be different. The option __adopath()__ provides an easy to use tool to completely eliminate this risk.

When a project use the __adopath()__ option with the sub-option _strict_, __adopath__(_"path"_, _strict_), it is guaranteed that no one running that project's code will ever use any other version of user-written commands than what was intended for that project. When using the sub-option __strict__ it is referred to as using __adopath()__ in _strict mode_. The intention is that this option should almost always be used in strict mode.

The folder that _path_ in __adopath__(_"path"_, _strict_) points to is referred to as the project's _ado-folder_. To make the project's code reproducible as promised above, then this folder needs to be shared with the rest of the project's code. Therefore it is recommended that each project has its own _ado-folder_ and that it is stored together with the rest of that project code. This makes it easy to include the _ado-folder_.  when sharing the project code, no matter if it is shared over Git/GitHub, sync-software like DropBox, over a network drive, in a reproducibility archive etc. This folder should include all user-written commands this project uses.

When using strict mode, the command __net install__ (including commands that builds on it such as __ssc install__) will install the commands in the project's _ado-folder_. Therefore, the intended workflow is that whenever a project needs another user-written command, then in strict mode, the user simply installs the command using __ssc install__ as usual but the command will be installed in the project _ado-folder_ instead of in that user's individual Stata installation. After this, then all users will be guaranteed to use that exact version of that command as long as strict mode is still used.

In order to guarantee that no user use any command other than the commands in the project's _ado-folder_, the option _adopath()_ in strict mode, makes all commands the user have installed in their Stata installation unavailable. This setting is restored when the user restarts Stata so nothing is uninstalled or made permanently unavailable. The purpose of this functionality is to make sure that no-one forgets to include any user-written command that the project needs in the _ado-folder_.

The __nostrict__ sub-option, as in __adopath__(_"path"_, _nostrict_), exists to temporarily disable the functionality in strict mode. For example, if someone wants to test using a command installed in their Stata installation before installing it in the project _ado-folder_ then this option can be used. When __nostrict__ is used, when the commands installed in the user's Stata installation, are available in addition to the commands in the project's _ado-folder_. If a user has a command installed in their Stata installation with the same name as a command installed in the _ado-folder_, then the version installed in the _ado-folder_* will always be used. While using the __nostrict__ option can perhaps be seen as more convenient, it would defy the purpose of __adopath()__ to use _nostrict_ as a projects standard mode.

A in-depth technical presentation on how this feature works can be found in a recording found [here](https://osf.io/6tg3b). The slides used in that presentation can be found [here](https://osf.io/wa3tr). Note that in this presentation __nostrict__ was called _default mode_. While the option __adopath()__ makes one component needed for a gold-standard level reproducibility easy to use, it is not the only thing needed for reproducibility. Other practices such as setting the seed if using randomization is still as important.

## Other settings

It is rare that any of the settings in this category is anything a typical user ever needs to worry about. These settings mostly prevents that some unusual and outlier memory setting is the reason some computer is not able to run the code the same way as other computers. One example use case where it can be relevant for a user to modify these settings is if the code is developed to run on a computer or server with unusual (for example very small) specifications.

This command also standardize some settings that could, in some cases, could otherwise cause the code to run differently or with interruptions. For example, set more off (see `help set more`), set varabbrev off (`help set varabbrev`), set type float (`help set type`), etc.

See the tables below for a discussion of which settings used and why certain default values were used.

## Basic Memory Settings

| _Other Settings_ | Explanation |
|------------------|-------------|                  
| __set maxvar__ | sets the maximum number of variables allowed. The default value is the maximum allowed in the version of Stata. A lower maximum number can manually be set by the option __maxvar()__. This value is fixed in Stata Small or IC, so this setting is ignored when any of those versions of Stata is used. See set maxvar (`help set maxvar`). |
| __set matsize__ | sets the maximum number of variables that can be included in estimation commands such as __regress__. The default value used in this command is 400 which is the default value for Stata. A higher value is often allowed but it slows down Stata and is only needed when running very complex analysis. This option can be used to set a higher value, as long as the value does not violate the limitations in the versions of Stata this code will be used in. See set matsize  (`help set matsize`). |

## Dynamic Memory Settings 
see memory (`help memory`) for default values 

| _Other Settings_ | Explanation |
|------------------|-------------|   
| __set min_memory__ | sets a lower bound for the amount of memory assigned to Stata. The default value is no lower bound. |
| __set max_memory__ | sets an upper bound for the amount of memory assigned to Stata. The default is as much as the hardware of the computer allows. |
| __set niceness__ | defines how quickly Stata releases unused memory back to the computer |
| __set segmentsize__ | defines how large bundles of data is assigned each time Stata request more memory. Too large bundles make Stata occupy an unnecessary large part of the computer's memory (that otherwise could have been used by other applications), and too small bundles makes Stata have to interrupt itself to request more bundles of memory too frequently   |
                                                                                                                                                                                                      
## Code Flow Settings

| _Other Settings_ | Explanation |
|------------------|-------------|
| __set more off__ | disables the default setting that Stata stops and waits for the user to press any key each time the output window is full. Long dofiles would take a very long time to run and require constant attention from the user without this setting. Most Stata users always disable the default which is __set more on__. See set more (`help set more`).|
| __pause on__   | allows the usage of the command __pause__ which can be very useful during debugging. See pause (`help pause`). |

## Variable Settings:

| _Other Settings_ | Explanation |
|------------------|-------------|
| __set varabbrev off__  | allows users to abbreviate variable names. Somewhat similarly to command names abbreviation such as __gen__ for __generate__ and __reg__ for __regress__. However, command name abbreviations are set up to make sure there is no name conflicts that makes the abbreviations ambiguous. This is not true for variable name abbreviation and code that relies on variable name abbreviations tend to be error prone. See set varabbrev (`help set varabbrev`) for more details and carefully consider these words of caution before enabling variable name abbreviation in a collaborative dofile. |   
| __set type float__ | sets the default variable type to _float_ when creating a new variable and no type is specified. Different default types can lead to differences in randomization as this setting affects the precision in the randomization. For extremely large dataset the type _double_ might be required, when generating random numbers that is expected to be unique. But since that type is twice as storage intensive, this command use _float_ as default, and users need to specify _double_ in the rare cases it makes a difference. |

# Options

__**v**ersionnumber__(_string_) sets a stable version of Stata for all users. Stata does not (for good reasons) allow a user-written command to alter the version setting from inside a command. Therefore, this option does _nothing_ unless __r(version)__ is included as described in the Syntax section. While the version number cannot be set inside the command code, __ieboilstart__ does two things. First it reminds the user to set the version since it is a required command. Second, it makes sure that the version number used is not too old. A too old version might risk that there are far too big a difference in many commands. Best practice is therefore to keep the same version number throughout a project, unless there is something specific to a newer version that is required for any dofile. Only major and recent versions are allowed in order to reduce errors and complexity. All versions of Stata can be set to run any older version of Stata but not a newer.

__**ado**path__(_"path/to/folder"_ [, _strict_]) adds the folder specified in this option to the ado-file paths (see `help sysdir`). When _strict_ is not used this option sets the _PERSONAL_ path to the path specified in this command. When _strict_ is used then this option instead sets that path to the _PLUS_ path. Read more in `help sysdir` about the _PERSONAL_ and _PLUS_ paths. When _strict_ is used the all other ado-paths are removed apart from the _BASE_ path where the built-in Stata commands are stored. When preparing a reproducibility package one should use the _strict_ to make sure that all user-written commands are saved in the project ado-folder. If a project should eventually be turned into a reproducibility package, then it is easier to use _strict_ from the beginning and continuously add user-written commands as they are introduced to the project's code. This is easier compared to, in the very end making sure that the correct versions of all user-written commands are installed in the project ado-folder.

__noclear__ prevents the command from clearing any data set currently loaded into Stata's working memory. The default is to clear data as the working memory needs to be empty in order to modify settings for maxvar, min_memory, max_memory and segmentsize. Nothing saved to hard drive memory will ever be deleted by this command. This command is intended to be placed at the very top of a dofile, before any data is loaded into working memory. For these reasons, __noclear__ and __maxvar()__ cannot be used together.

__**q**uietly__ suppresses the most verbose outputs from this command, but not the most important outputs.

__veryquietly__ suppresses all the output from this command. Including the important reminder to set the version number using __r(version)__ after running the command.

__maxvar__(_numlist_) manually sets the maximum number of variables allowed in a data set. The default is to set the number to the highest allowed in the user's version of Stata. Reducing this number can occasionally improve performance, but it is unlikely to make a difference to a modern computer. This option can be used if a project wants to make sure that the code can run on smaller versions of Stata or small computers. Then the project can use this option to restrict all computers to those limitations, so no one write codes exceeding them.

__matsize__(_numlist_) manually sets the maximum number of variables allowed in estimation commands, for example regress. The default is to set the number to the highest allowed in the user's version of Stata. Reducing this number can occasionally improve performance, but it is unlikely to make a difference to a modern computer. This option can be used if a project wants to make sure that the code can run on smaller versions of Stata or small computers. Then the project can use this option to restrict all computers to those limitations, so no one write codes exceeding them.

__**noperm**anently__ is used to disable that this command updates any default settings in a user's installation of Stata. For extensively used best practices, this command updates the default settings such that they apply even after the user has restarted their Stata session. See option permanently in memory (`help memory`) for more details. The setting __set more off__ is always set permanently, regardless of if this option used, as it universally agreed within the Stata community to be better.

# Examples

__Example 1.__

```
ieboilstart, versionnumber(12.1) 
`r(version)'
```

After running the two lines of code above all users will run their version of Stata as if the version was 12.1. That means that anyone who bought or upgraded their Stata to version 12.1 or a more recent version can run this code and will behave as identical as possible.

__Example 2.__

```
local proj_ado "/path/to/project/code/ado" 
ieboilstart, opt versionnumber(15.1) adopath_("`proj_ado'", strict) 
`r(version)'

```

In this example the Stata version is set to 15.1 and the ado-folders are updated. Let's say a project folder is located at _"/path/to/project"_ and inside it there is a folder called _code_ where all code files are located. This would be a great location for a folder called _ado_ that would be the project specific ado-folder. Since the sub-option _strict_ is used this is the only place where Stata would look for commands that are not built-in commands. Any commands installed by SSC before updating this ado-path is no longer available. Any such commands that is needed in the code for this project needs to be installed again in the project specific ado-folder. Which can be done using __ssc install ...__ the regular way after __ieboilstart__ was run like this.

# Author

All commands in ietoolkit is developed by DIME Analytics at DIME, The World Bank's department for Development Impact Evaluations.

Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

Please send bug-reports, suggestions and requests for clarifications writing "ietoolkit ieboilstart" in the subject line to: [dimeanalytics\@worldbank.org](mailto:dimeanalytics@worldbank.org){.email}

You can also see the code, make comments to the code, see the version history of the code, and submit additions or edits to the code through [the GitHub repository of ietoolkit](%22https://github.com/worldbank/ietoolkit%22).
