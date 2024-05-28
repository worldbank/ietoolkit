{smcl}
{* *! version 0.0 20240404}{...}
{hline}
{pstd}help file for {hi:ieboilstart}{p_end}
{hline}

{title:Title}

{phang}{bf:ieboilstart} - applies best practices for collaboration and reproducibility within a project.
{p_end}

{phang}For a more descriptive discussion on the intended usage and workflow of this command please see the {browse "https://dimewiki.worldbank.org/wiki/Ieboilstart":DIME Wiki}.
{p_end}

{phang}{bf:DISCLAIMER} - One objective of this command is to harmonize settings across users. However, it is impossible to guarantee that different types of Stata (version number, Small/IC/SE/MP or PC/Mac/Linux) will work exactly the same in every possible context. This command does not guarantee against any version discrepancies in Stata or in user-contributed commands. This command is solely a collection of common practices to reduce the risk that the same code generates different outputs when running on different computers. See more details below.
{p_end}

{title:Syntax}

{phang}{bf:ieboilstart} , {bf:{ul:v}ersionnumber}( {it:Stata_version} ) [{bf:{ul:ado}path}({it:{c 34}path/to/folder{c 34}}, {c -(}{it:strict} | {it:nostrict}{c )-}) {bf:noclear} {bf:{ul:q}uietly} {bf:veryquietly} {it:memory_options} ]
{p_end}

{phang}Note that one important feature of this command requires that  {bf:r(version)} is written on the first do-file after {bf:ieboilstart}. This setting cannot be specified within a user command and ensures that the Stata version is set correctly. For example:
{p_end}

{input}{space 8}ieboilstart , options 
{space 8}`r(version)' 
{text}
{synoptset 66}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:v}ersionnumber}({it:Stata_version})}Sets the Stata version for all subsequent code execution (required){p_end}
{synopt: {bf:{ul:ado}path}({it:{c 34}path/to/folder{c 34}}, {c -(}{it:strict} / {it:nostrict}{c )-})}Sets the folder where this project{c 39}s ado-files or user-written commands are stored (required for standalone reproducibility packages){p_end}
{synopt: {bf:noclear}}Makes the command not start by clearing all data{p_end}
{synopt: {bf:{ul:q}uietly}}Suppresses most of the command{c 39}s output{p_end}
{synopt: {bf:veryquietly}}Suppresses all of the command{c 39}s output{p_end}
{synoptline}

{dlgtab:Memory options}

{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:maxvar}({it:numlist})}Manually specify maximum number of variables allowed{p_end}
{synopt: {bf:matsize}({it:numlist})}Manually specify maximum number of variables allowed in estimation commands{p_end}
{synopt: {bf:{ul:noperm}anently}}Disable the default to permanently set some best practice memory settings{p_end}
{synoptline}

{title:Description}

{pstd}{bf:ieboilstart} applies best practices for collaboration and reproducibility within a research project. Making the same Stata code consistently generate the same results when run on other people{c 39}s computers is harder than what it first might seem. This is especially true in order to ensure that Stata code will function identically in the future, even if new versions of Stata and user-written commands (such as those on SSC) have been released. The objective of this command is to reduce the risk that a research project{c 39}s code changes its results when running the same code on different computers or in different points in the future. However, note that it is not technically possible to fully eliminate this risk.
{p_end}

{pstd}The best practice settings this command applies can be categorized into the following types: version control of built-in commands, version control of user-written commands, {it:other} settings.
{p_end}

{dlgtab:Version control: Stata and built-in commands}

{pstd}Research projects often span over several years, and are required to be reproducible for anyone in the future reviewing the results. After several years have passed, it is likely that a new version of Stata has been released. When Stata releases a new version they add new built-in commands, but they might also make changes to already published commands.
{p_end}

{pstd}For you to make sure that old code in your project behaves the same way even after you update your Stata installation you need to version control the built-in commands in Stata. You also need to version control the built-in commands in Stata when you are collaborating as you cannot be sure what version of Stata everyone else are using at all points in time. Finally, this becomes particularly important when preparing a reproducibility package that should stand the test of time, as you definitely do not know what version of Stata someone in the future will use.
{p_end}

{pstd}One example where this becomes important is reproducible randomization. Sometimes Stata updates the random number generator between versions. Unless the built-in commands that use randomization are version controlled, then the results of the randomization can vary between versions of Stata. This is true even if other requirements for reproducible randomization is used, such as setting the seed (see {inp:help seed}). Each time Stata updates the random number generator it gets marginally better. However, for the vast majority of research projects, this improvement is so marginal it is most definitely negligible. 
{p_end}

{pstd}This command uses the Stata command {bf:version} (see {inp:help version}) to version control all built-in commands. For some good technical reasons, it is not possible for {bf:ieboilstart} to set the version for the rest of the project{c 39}s code from inside the command. This means that all {bf:ieboilstart} start is preparing the line of code you need to run to version control all built-in commands. You need to run this line of code on the immediate subsequent line after {bf:ieboilstart}. Like this: 
{p_end}

{input}{space 8}ieboilstart , options 
{space 8}`r(version)' 
{text}
{pstd}The version setting has the scope of a local, meaning that it expires when a do-file and all sub-dofiles it is calling are completed. If {browse "https://dimewiki.worldbank.org/Master_Do-files":main/master do-files} are used, then the version should be set in the main file, and only results generated when running all code from the main file should be considered reproducible.
{p_end}

{pstd}It is just as important, if not more important, to version control the user-written commands as well. See next section for how to version control user-written commands, such as commands installed from {it:SSC} (see {inp:help ssc}). 
{p_end}

{dlgtab:Version control: User-written commands}

{pstd}The option {bf:adopath()} makes one key reproducibility component easy to use in Stata. Many projects in Stata relies on user-written commands, such as commands installed from SSC. With user-written commands there is always a risk that the project code does not reproduce correctly if a different version of any user-written command is used. This applies when team members collaborate in real team on a project, but it is especially a risk if someone would try to reproduce the project results in the future. User-written commands updates frequently, and depending on when a user installed a command or when it was last updated, the version of a command that user use will inevitable eventually be different. The option {bf:adopath()} provides an easy to use tool to completely eliminate this risk.
{p_end}

{pstd}When a project use the {bf:adopath()} option with the sub-option {it:strict}, {bf:adopath}({it:{c 34}path{c 34}}, {it:strict}), it is guaranteed that no one running that project{c 39}s code will ever use any other version of user-written commands than what was intended for that project. When using the sub-option {bf:strict} it is referred to as using {bf:adopath()} in {it:strict mode}. The intention is that this option should almost always be used in strict mode.
{p_end}

{pstd}The folder that {it:path} in {bf:adopath}({it:{c 34}path{c 34}}, {it:strict}) points to is referred to as the project{c 39}s {it:ado-folder}. To make the project{c 39}s code reproducible as promised above, then this folder needs to be shared with the rest of the project{c 39}s code. Therefore it is recommended that each project has its own {it:ado-folder} and that it is stored together with the rest of that project code. This makes it easy to include the {it:ado-folder}.  when sharing the project code, no matter if it is shared over Git/GitHub, sync-software like DropBox, over a network drive, in a reproducibility archive etc. This folder should include all user-written commands this project uses.
{p_end}

{pstd}When using strict mode, the command {bf:net install} (including commands that builds on it such as {bf:ssc install}) will install the commands in the project{c 39}s {it:ado-folder}. Therefore, the intended workflow is that whenever a project needs another user-written command, then in strict mode, the user simply installs the command using {bf:ssc install} as usual but the command will be installed in the project {it:ado-folder} instead of in that user{c 39}s individual Stata installation. After this, then all users will be guaranteed to use that exact version of that command as long as strict mode is still used.
{p_end}

{pstd}In order to guarantee that no user use any command other than the commands in the project{c 39}s {it:ado-folder}, the option {it:adopath()} in strict mode, makes all commands the user have installed in their Stata installation unavailable. This setting is restored when the user restarts Stata so nothing is uninstalled or made permanently unavailable. The purpose of this functionality is to make sure that no-one forgets to include any user-written command that the project needs in the {it:ado-folder}.
{p_end}

{pstd}The {bf:nostrict} sub-option, as in {bf:adopath}({it:{c 34}path{c 34}}, {it:nostrict}), exists to temporarily disable the functionality in strict mode. For example, if someone wants to test using a command installed in their Stata installation before installing it in the project {it:ado-folder} then this option can be used. When {bf:nostrict} is used, when the commands installed in the user{c 39}s Stata installation, are available in addition to the commands in the project{c 39}s {it:ado-folder}. If a user has a command installed in their Stata installation with the same name as a command installed in the {it:ado-folder}, then the version installed in the {it:ado-folder_* will always be used. While using the {bf:nostrict} option can perhaps be seen as more convenient, it would defy the purpose of {bf:adopath()} to use _nostrict} as a projects standard mode.
{p_end}

{pstd}A in-depth technical presentation on how this feature works can be found in a recording found {browse "https://osf.io/6tg3b":here}. The slides used in that presentation can be found {browse "https://osf.io/wa3tr":here}. Note that in this presentation {bf:nostrict} was called {it:default mode}. While the option {bf:adopath()} makes one component needed for a gold-standard level reproducibility easy to use, it is not the only thing needed for reproducibility. Other practices such as setting the seed if using randomization is still as important.
{p_end}

{dlgtab:Other settings}

{pstd}It is rare that any of the settings in this category is anything a typical user ever needs to worry about. These settings mostly prevents that some unusual and outlier memory setting is the reason some computer is not able to run the code the same way as other computers. One example use case where it can be relevant for a user to modify these settings is if the code is developed to run on a computer or server with unusual (for example very small) specifications.
{p_end}

{pstd}This command also standardize some settings that could, in some cases, could otherwise cause the code to run differently or with interruptions. For example, set more off (see {inp:help set more}), set varabbrev off ({inp:help set varabbrev}), set type float ({inp:help set type}), etc. 
{p_end}

{pstd}See the tables below for a discussion of which settings used and why certain default values were used.
{p_end}

{dlgtab:Basic Memory Settings}

{col 4}{c TLC}{hline 20}{c TT}{hline 483}{c TRC}
{col 4}{c |} {it:Other Settings}{col 25}{c |} Explanation{col 509}{c |}
{col 4}{c LT}{hline 20}{c +}{hline 483}{c RT}
{col 4}{c |} {bf:set maxvar}{col 25}{c |} sets the maximum number of variables allowed. The default value is the maximum allowed in the version of Stata. A lower maximum number can manually be set by the option {bf:maxvar()}. This value is fixed in Stata Small or IC, so this setting is ignored when any of those versions of Stata is used. See set maxvar ({inp:help set maxvar}).{col 509}{c |}
{col 4}{c |} {bf:set matsize}{col 25}{c |} sets the maximum number of variables that can be included in estimation commands such as {bf:regress}. The default value used in this command is 400 which is the default value for Stata. A higher value is often allowed but it slows down Stata and is only needed when running very complex analysis. This option can be used to set a higher value, as long as the value does not violate the limitations in the versions of Stata this code will be used in. See set matsize  ({inp:help set matsize}).{col 509}{c |}
{col 4}{c BLC}{hline 20}{c BT}{hline 483}{c BRC}

{dlgtab:Dynamic Memory Settings}
{pstd}see memory ({inp:help memory}) for default values  
{p_end}

{col 4}{c TLC}{hline 20}{c TT}{hline 345}{c TRC}
{col 4}{c |} {it:Other Settings}{col 25}{c |} Explanation{col 371}{c |}
{col 4}{c LT}{hline 20}{c +}{hline 345}{c RT}
{col 4}{c |} {bf:set min_memory}{col 25}{c |} sets a lower bound for the amount of memory assigned to Stata. The default value is no lower bound.{col 371}{c |}
{col 4}{c |} {bf:set max_memory}{col 25}{c |} sets an upper bound for the amount of memory assigned to Stata. The default is as much as the hardware of the computer allows.{col 371}{c |}
{col 4}{c |} {bf:set niceness}{col 25}{c |} defines how quickly Stata releases unused memory back to the computer{col 371}{c |}
{col 4}{c |} {bf:set segmentsize}{col 25}{c |} defines how large bundles of data is assigned each time Stata request more memory. Too large bundles make Stata occupy an unnecessary large part of the computer{c 39}s memory (that otherwise could have been used by other applications), and too small bundles makes Stata have to interrupt itself to request more bundles of memory too frequently{col 371}{c |}
{col 4}{c BLC}{hline 20}{c BT}{hline 345}{c BRC}

{dlgtab:Code Flow Settings}

{col 4}{c TLC}{hline 20}{c TT}{hline 335}{c TRC}
{col 4}{c |} {it:Other Settings}{col 25}{c |} Explanation{col 361}{c |}
{col 4}{c LT}{hline 20}{c +}{hline 335}{c RT}
{col 4}{c |} {bf:set more off}{col 25}{c |} disables the default setting that Stata stops and waits for the user to press any key each time the output window is full. Long dofiles would take a very long time to run and require constant attention from the user without this setting. Most Stata users always disable the default which is {bf:set more on}. See set more ({inp:help set more}).{col 361}{c |}
{col 4}{c |} {bf:pause on}{col 25}{c |} allows the usage of the command {bf:pause} which can be very useful during debugging. See pause ({inp:help pause}).{col 361}{c |}
{col 4}{c BLC}{hline 20}{c BT}{hline 335}{c BRC}

{dlgtab:Variable Settings:}

{col 4}{c TLC}{hline 20}{c TT}{hline 562}{c TRC}
{col 4}{c |} {it:Other Settings}{col 25}{c |} Explanation{col 588}{c |}
{col 4}{c LT}{hline 20}{c +}{hline 562}{c RT}
{col 4}{c |} {bf:set varabbrev off}{col 25}{c |} allows users to abbreviate variable names. Somewhat similarly to command names abbreviation such as {bf:gen} for {bf:generate} and {bf:reg} for {bf:regress}. However, command name abbreviations are set up to make sure there is no name conflicts that makes the abbreviations ambiguous. This is not true for variable name abbreviation and code that relies on variable name abbreviations tend to be error prone. See set varabbrev ({inp:help set varabbrev}) for more details and carefully consider these words of caution before enabling variable name abbreviation in a collaborative dofile.{col 588}{c |}
{col 4}{c |} {bf:set type float}{col 25}{c |} sets the default variable type to {it:float} when creating a new variable and no type is specified. Different default types can lead to differences in randomization as this setting affects the precision in the randomization. For extremely large dataset the type {it:double} might be required, when generating random numbers that is expected to be unique. But since that type is twice as storage intensive, this command use {it:float} as default, and users need to specify {it:double} in the rare cases it makes a difference.{col 588}{c |}
{col 4}{c BLC}{hline 20}{c BT}{hline 562}{c BRC}

{title:Options}

{pstd}{bf:{ul:v}ersionnumber}({it:string}) sets a stable version of Stata for all users. Stata does not (for good reasons) allow a user-written command to alter the version setting from inside a command. Therefore, this option does {it:nothing} unless {bf:r(version)} is included as described in the Syntax section. While the version number cannot be set inside the command code, {bf:ieboilstart} does two things. First it reminds the user to set the version since it is a required command. Second, it makes sure that the version number used is not too old. A too old version might risk that there are far too big a difference in many commands. Best practice is therefore to keep the same version number throughout a project, unless there is something specific to a newer version that is required for any dofile. Only major and recent versions are allowed in order to reduce errors and complexity. All versions of Stata can be set to run any older version of Stata but not a newer.
{p_end}

{pstd}{bf:{ul:ado}path}({it:{c 34}path/to/folder{c 34}} [, {it:strict}]) adds the folder specified in this option to the ado-file paths (see {inp:help sysdir}). When {it:strict} is not used this option sets the {it:PERSONAL} path to the path specified in this command. When {it:strict} is used then this option instead sets that path to the {it:PLUS} path. Read more in {inp:help sysdir} about the {it:PERSONAL} and {it:PLUS} paths. When {it:strict} is used the all other ado-paths are removed apart from the {it:BASE} path where the built-in Stata commands are stored. When preparing a reproducibility package one should use the {it:strict} to make sure that all user-written commands are saved in the project ado-folder. If a project should eventually be turned into a reproducibility package, then it is easier to use {it:strict} from the beginning and continuously add user-written commands as they are introduced to the project{c 39}s code. This is easier compared to, in the very end making sure that the correct versions of all user-written commands are installed in the project ado-folder. 
{p_end}

{pstd}{bf:noclear} prevents the command from clearing any data set currently loaded into Stata{c 39}s working memory. The default is to clear data as the working memory needs to be empty in order to modify settings for maxvar, min{it:memory, max_memory and segmentsize. Nothing saved to hard drive memory will ever be deleted by this command. This command is intended to be placed at the very top of a dofile, before any data is loaded into working memory. For these reasons, {bf:noclear} and {bf:maxvar()} cannot be used together.
{p_end}

{pstd}{bf:{ul:q}uietly} suppresses the most verbose outputs from this command, but not the most important outputs.
{p_end}

{pstd}{bf:veryquietly} suppresses all the output from this command. Including the important reminder to set the version number using {bf:r(version)} after running the command.
{p_end}

{pstd}{bf:maxvar}({it:numlist}) manually sets the maximum number of variables allowed in a data set. The default is to set the number to the highest allowed in the user{c 39}s version of Stata. Reducing this number can occasionally improve performance, but it is unlikely to make a difference to a modern computer. This option can be used if a project wants to make sure that the code can run on smaller versions of Stata or small computers. Then the project can use this option to restrict all computers to those limitations, so no one write codes exceeding them.
{p_end}

{pstd}{bf:matsize}({it:numlist}) manually sets the maximum number of variables allowed in estimation commands, for example regress. The default is to set the number to the highest allowed in the user{c 39}s version of Stata. Reducing this number can occasionally improve performance, but it is unlikely to make a difference to a modern computer. This option can be used if a project wants to make sure that the code can run on smaller versions of Stata or small computers. Then the project can use this option to restrict all computers to those limitations, so no one write codes exceeding them.
{p_end}

{pstd}{bf:{ul:noperm}anently} is used to disable that this command updates any default settings in a user{c 39}s installation of Stata. For extensively used best practices, this command updates the default settings such that they apply even after the user has restarted their Stata session. See option permanently in memory ({inp:help memory}) for more details. The setting {bf:set more off} is always set permanently, regardless of if this option used, as it universally agreed within the Stata community to be better. 
{p_end}

{title:Examples}

{pstd}{bf:Example 1.}
{p_end}

{input}{space 8}ieboilstart, versionnumber(12.1) 
{space 8}`r(version)' 
{text}
{pstd}After running the two lines of code above all users will run their version of Stata as if the version was 12.1. That means that anyone who bought or upgraded their Stata to version 12.1 or a more recent version can run this code and will behave as identical as possible.
{p_end}

{pstd}{bf:Example 2.}
{p_end}

{input}{space 8}local proj_ado "/path/to/project/code/ado" 
{space 8}ieboilstart, opt versionnumber(15.1) adopath_("`proj_ado'", strict)  
{space 8}`r(version)' 
{space 8}
{text}
{pstd}In this example the Stata version is set to 15.1 and the ado-folders are updated. Let{c 39}s say a project folder is located at {it:{c 34}/path/to/project{c 34}} and inside it there is a folder called {it:code} where all code files are located. This would be a great location for a folder called {it:ado} that would be the project specific ado-folder. Since the sub-option {it:strict} is used this is the only place where Stata would look for commands that are not built-in commands. Any commands installed by SSC before updating this ado-path is no longer available. Any such commands that is needed in the code for this project needs to be installed again in the project specific ado-folder. Which can be done using {bf:ssc install ...} the regular way after {bf:ieboilstart} was run like this.
{p_end}

{title:Author}

{pstd}All commands in ietoolkit is developed by DIME Analytics at DIME, The World Bank{c 39}s department for Development Impact Evaluations.
{p_end}

{pstd}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group
{p_end}

{pstd}Please send bug-reports, suggestions and requests for clarifications writing {c 34}ietoolkit ieboilstart{c 34} in the subject line to: {browse "mailto:dimeanalytics@worldbank.org":dimeanalyticswworldbank.org}{c -(}.email{c )-}
{p_end}

{pstd}You can also see the code, make comments to the code, see the version history of the code, and submit additions or edits to the code through {browse "%22https://github.com/worldbank/ietoolkit%22":the GitHub repository of ietoolkit}.
{p_end}
