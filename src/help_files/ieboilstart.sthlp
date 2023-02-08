{smcl}
{* 16 Dec 2022}{...}
{hline}
help for {hi:ieboilstart}
{hline}

{title:Title}

{phang}{cmdab:ieboilstart} {hline 2} applies best practices for
collaboration and reproducibility within a project.{p_end}

{phang2}For a more descriptive discussion on the intended usage and workflow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Ieboilstart":DIME Wiki}.

{phang}{hi:DISCLAIMER} {hline 1} One objective of this command
is to harmonize settings across users.
However, it is impossible to guarantee that different types of Stata
(version number, Small/IC/SE/MP or PC/Mac/Linux)
will work exactly the same in every possible context.
This command does not guarantee against any version discrepancies in Stata
or in user-contributed commands.
This command is solely a collection of common practices to reduce the risk
that the same code generates different outputs
when running on different computers.
See more details {help ieboilstart##desc:below}.

{marker synt}{...}
{title:Syntax}

{phang}Note that one important feature of this command requires that
{inp: `r(version)'} is written on the first do-file line after {cmd: ieboilstart}, 
as this setting cannot be done inside a user-command. 
This will set the Stata version to the correct setting.

{phang}{cmdab:ieboilstart} , {opt v:ersionnumber(Stata_version)}
[{opt ado:path("path/to/folder" [, strict])}
{opt noclear} {opt q:uietly} {opt veryquietly}
{it:{help ieboilstart##mset:memory_options}}]{p_end}{phang}`r(version)'{p_end}

{marker opts}{...}
{synoptset 28}{...}
{synopthdr:options}
{synoptline}
{synopt :{opt v:ersionnumber(Stata_version)}}Sets the Stata version
for all subsequent code execution (required){p_end}
{synopt :{opt ado:path("path" [, strict])}}Sets the folder where this
project's ado-files or user-written commands are stored (required for standalone reproducibility packages){p_end}
{synopt :{opt noclear}}Makes the command not start by clearing all data{p_end}
{synopt :{opt q:uietly}}Suppresses most of the command's output{p_end}
{synopt :{opt veryquietly}}Suppresses all of the command's output{p_end}

{marker mset}{...}
{pstd}{it:Memory options}{p_end}
{synopt :{opt maxvar(numlist)}}Manually specify maximum
number of variables allowed{p_end}
{synopt :{opt matsize(numlist)}}Manually specify maximum
number of variables allowed in estimation commands{p_end}
{synopt :{opt noperm:anently}}Disable the default to
permanently set some best practice memory settings{p_end}
{synoptline}

{marker desc}{...}
{title:Description}

{pstd}{cmdab:ieboilstart} applies best practices for
collaboration and reproducibility within a research project.
Making the same Stata code consistently generate the same results when
run on other people's computers is harder than what it first might seem.
This is especially true in order to ensure that Stata code will function identically in the future,
even if new versions of Stata and user-written commands (such as those on SSC)
have been released.
The objective of this command is to reduce the risk
that a research project's code changes its results
when running the same code on different computers
or in different points in the future.
However, note that it is not technically possible
to fully eliminate this risk.{p_end}

{pstd}The best practice settings this command applies
can be categorized into the following types:
{it:Stata version}, {it:adopath} management, and {it:other} settings.{p_end}

{dlgtab:Stata version settings}

{pstd}Research projects often span over several years,
and are required to be reproducible for anyone in the future
reviewing the results.
After several years have passed, it is likely that
a new version of Stata has been released.
This can change how the Stata code runs, so for reproducibility,
it is important to indicate which Stata version this code was written in.{p_end}

{pstd}This command uses Stata's built-in command {cmd:version} to
execute a script using a specific version of Stata (and its syntax).
Different versions of Stata might run the same code slightly differently,
or they may have changed syntax or functionality for built-in commands entirely.
See many more details {help version:here}.
Setting the Stata version makes them run the same code more similarly.
Note that there is no guarantee that two different versions of Stata
run the same code identically in every single aspects
even after selecting the same version.
However, the risk that they do run differently is
significantly reduced when setting the version.{p_end}

{pstd}Setting the Stata version is particularly important for any Stata code
containing randomization that is intended to be reproducible.
Stata occasionally updates the randomization algorithm used between versions.
The improvement when updating the randomization algorithm
is unlikely to make any difference to the vast majority of research projects,
but any change to {it: any} command might cause the same Stata code to obtain different random numbers
when used in the future.
What's important is that to make code with a random process reproducible,
it must use the exact same algorithm,
and that is achieved by selecting an exact Stata version.{p_end}

{pstd}For good reasons, it is not possible to set the Stata version
for the rest of the code from inside a user-written command.
Therefore, in order for the version best practice
to be applied across the project code,
any user of this command must add {inp:`r(version)'}
on the immediate subsequent do-file line after {cmdab:ieboilstart}. See below.{p_end}

{phang}{cmdab:ieboilstart} , {it:options}{p_end}{phang}`r(version)'{p_end}

{pstd}The version setting has the scope of a local,
meaning that it expires when a dofile
and all sub-dofiles it is calling are completed. If
{browse "https://dimewiki.worldbank.org/Master_Do-files":main/master do-files}
are used, then the version should be set in the main file,
and only results generated when running all code from the main file
should be considered reproducible.{p_end}

{dlgtab:Adopath settings}

{pstd}Many research projects use user-written commands in the code.
These commands are commonly installed from {help ssc:SSC},
but can also be installed from other sources
or be custom written for the specific project.
Code using user-written commands is only permanently reproducible
if future users have {it: exactly} the same versions of all commands.
This is rarely the case, unless the functionality made easily accessible
in the option {opt adopath()} in this command is used.{p_end}
This functionality requires that all user-written commands for a single project
be stored in a single unique location.
This ensures that the corresponding code can be maintained, packaged, and archived
with the precise outputs those versions of code create.
User-written commands never guarantee backwards compatibility or random-output stability when they are updated.

{pstd}Coordinating that all users in a project team, as well as
anyone reproducing the results at the same time or in the future,
have exactly the same version of user-written commands
installed in their installation of Stata is probably impossible.
The best practice solution is to set up a project specific folder
where the commands needed for this project are installed.
This folder can be shared using a syncing service (for example, Dropbox)
or in version control tools such as Github, where the rest of the project code is stored.
Just make sure that if this folder is shared publicly,
the project is allowed to do so
for commands not written by anyone in the project.{p_end}

{pstd}In this command, the {opt adopath("path/to/folder")} option specifies
a folder as the project specific folder for user-written commands.
This allows any commands in that folder to be available to the code
in addition to the commands already installed in the user's Stata installation.
If the sub-option {it:strict} is used,
as in {opt adopath("path/to/folder", strict)},
then {ul:only} commands in this folder is available to the code.
(Stata's built-in commands are always available.)
This allows a project to make sure that everyone is only using
the exact version of the user-written command installed in that folder.
After {it:strict} is used, you can use {inp:ssc install} or {inp:net install}
to install commands into the project specific folder.{p_end}

{pstd}The scope of adopath setting is the same as for globals.
This means that the adopath settings done by this command
are restored to the defaults next time Stata is restarted.{p_end}

{dlgtab:Other settings}

{pstd}It is rare that any of the settings in this category
is anything a typical user ever needs to worry about.
These settings mostly prevents that some unusual and outlier memory setting
is the reason some computer is not able to run
the code the same way as other computers.
One example use case where it can be relevant for a user to
modify these settings is if the code is developed to run
on a computer or server with unusual
(for example very small) specifications.{p_end}

{pstd}This command also standardize some settings that could, in some cases,
could otherwise cause the code to run differently or with interruptions.
For example, {help set more:set more off},
{help set varabbrev:set varabbrev off}, {help set type:set type float},
etc.{p_end}

{pstd}See the tables below for a discussion of which settings used and
why certain default values were used.{p_end}

{p2colset 5 23 25 2}
{p2col : Other Settings}Explanation{p_end}
{p2line}
{pstd}{it: Basic Memory Settings:}{p_end}
{p2col :{cmdab:set maxvar}}sets the maximum number of variables allowed.
The default value is the maximum allowed in the version of Stata.
A lower maximum number can manually be set by the option {cmdab:maxvar()}.
This value is fixed in Stata Small or IC,
so this setting is ignored when any of those versions of Stata is used.
See {help set maxvar:set maxvar}.{p_end}
{p2col :{cmdab:set matsize}}sets the maximum number of variables
that can be included in estimation commands such as {cmd:regress}.
The default value used in this command is 400 which
is the default value for Stata.
A higher value is often allowed but it slows down Stata
and is only needed when running very complex analysis.
This option can be used to set a higher value,
as long as the value does not violate the limitations in
the versions of Stata this code will be used in.
See {help set matsize:set matsize}.{p_end}
{break}
{pstd}{it: Dynamic Memory Settings (see {help memory:memory} for default values):}{p_end}
{p2col :{cmdab:set min_memory}}sets a lower bound
for the amount of memory assigned to Stata.
The default value is no lower bound.{p_end}
{p2col :{cmdab:set max_memory}}sets an upper bound
for the amount of memory assigned to Stata.
The default is as much as the hardware of the computer allows.{p_end}
{p2col :{cmdab:set niceness}}defines how quickly Stata releases
unused memory back to the computer{p_end}
{p2col :{cmdab:set segmentsize}}defines how large bundles of data
is assigned each time Stata request more memory.
Too large bundles make Stata occupy
an unnecessary large part of the computer's memory
(that otherwise could have been used by other applications),
and too small bundles makes Stata have to interrupt itself to request
more bundles of memory too frequently{p_end}
{break}
{pstd}{it: Code Flow Settings:}{p_end}
{p2col :{cmdab:set more off}}disables the default setting that
Stata stops and waits for the user to press any key each time
the output window is full.
Long dofiles would take a very long time to run and require
constant attention from the user without this setting.
Most Stata users always disable the default which is {cmdab:set more on}.
See {help set more:set more}.{p_end}
{p2col :{cmdab:pause on}}allows the usage of the command {cmdab:pause}
which can  be very useful during debugging.
See {help pause:pause}.{p_end}
{break}
{pstd}{it: Variable Settings:}{p_end}
{p2col :{cmdab:set varabbrev off}}allows users to abbreviate variable names.
Somewhat similarly to command names abbreviation such as
{inp:gen} for {inp:generate} and {inp:reg} for {inp:regress}.
However, command name abbreviations are set up to make sure there is no
name conflicts that makes the abbreviations ambiguous.
This is not true for variable name abbreviation and
code that relies on variable name abbreviations tend to be error prone.
See {help set varabbrev} for more details and carefully
consider these words of caution before enabling
variable name abbreviation in a collaborative dofile.{p_end}
{p2col :{cmdab:set type float}}sets the default variable type to {it:float}
when creating a new variable and no type is specified.
Different default types can lead to differences in randomization
as this setting affects the precision in the randomization.
For extremely large dataset the type {it:double} might be required,
when generating random numbers that is expected to be unique.
But since that type is twice as storage intensive,
this command use {it:float} as default,
and users need to specify {it:double} in the rare cases
it makes a difference.{p_end}
{p2line}

{title:Options}

{phang}{opt v:ersionnumber(string)} sets a stable version of Stata
for all users. Stata does not (for good reasons) allow a user-written command
to alter the version setting from inside a command. Therefore, this option does
{ul:nothing} unless "`r(version)'" is included as described in the
{help ieboilstart##synt:syntax section}. While the version number cannot be set
inside the command code, {cmd:ieboilstart} does two things. First it reminds
the user to set the version since it is a required command. Second, it makes
sure that the version number used is not too old. A too old version might
risk that there are far too big a difference in many commands. Best
practice is therefore to keep the same version number throughout a project,
unless there is something specific to a newer version
that is required for any dofile.
Only major and recent versions are allowed in order
to reduce errors and complexity.
All versions of Stata can be set to run
any older version of Stata but not a newer.{p_end}

{phang}{opt ado:path("path/to/folder" [, strict])} adds the folder specified
in this option to the {help sysdir:ado-file paths}.
When {it:strict} is not used this option sets the {it:PERSONAL} path
to the path specified in this command.
When {it:strict} is used then this option instead sets
that path to the {it:PLUS} path.
Read more in {help sysdir} about the {it:PERSONAL} and {it:PLUS} paths.
When {it:strict} is used the all other ado-paths are removed apart from the
{it:BASE} path where the built-in Stata commands are stored.
When preparing a reproducibility package one should use the {it:strict}
to make sure that all user-written commands are saved in the project ado-folder.
If a project should eventually be turned into a reproducibility package,
then it is easier to use {it:strict} from the beginning
and continuously add user-written commands as
they are introduced to the project's code.
This is easier compared to, in the very end making sure that
the correct versions of all user-written commands
are installed in the project ado-folder.{p_end}

{phang}{opt noclear} prevents the command from clearing
any data set currently loaded into Stata's working memory.
The default is to clear data as the working memory needs to be empty
in order to modify settings for maxvar, min_memory, max_memory and segmentsize.
Nothing saved to hard drive memory will ever be deleted by this command.
This command is intended to be placed at the very top of a dofile,
before any data is loaded into working memory.
For these reasons, {cmdab:noclear} and {cmdab:maxvar()}
cannot be used together.{p_end}

{phang}{opt q:uietly} suppresses the most verbose outputs from this command,
but not the most important outputs.{p_end}

{phang}{opt veryquietly} suppresses all the output from this command.
Including the important reminder to set the version number using
{inp:`r(version)'} after running the command.

{phang}{opt maxvar(numlist)} manually sets
the maximum number of variables allowed in a data set.
The default is to set the number to
the highest allowed in the user's version of Stata.
Reducing this number can occasionally improve performance,
but it is unlikely to make a difference to a modern computer.
This option can be used if a project wants to make sure that the code
can run on smaller versions of Stata or small computers.
Then the project can use this option to restrict all computers
to those limitations, so no one write codes exceeding them.{p_end}

{phang}{opt matsize(numlist)} manually sets the maximum number of variables
allowed in estimation commands, for example {help reg:regress}.
The default is to set the number to the highest allowed
in the user's version of Stata.
Reducing this number can occasionally improve performance,
but it is unlikely to make a difference to a modern computer.
This option can be used if a project wants to make sure that the code
can run on smaller versions of Stata or small computers.
Then the project can use this option to restrict all computers
to those limitations, so no one write codes exceeding them.{p_end}

{phang}{opt noperm:anently} is used to disable that this command
updates any default settings in a user's installation of Stata.
For extensively used best practices, this command updates the default settings
such that they apply even after the user has restarted their Stata session.
See option permanently in {help memory:memory} for more details.
The setting {cmd:set more off} is always set permanently,
regardless of if this option used,
as it universally agreed within the Stata community to be better.{p_end}

{title:Examples}

{pstd}{hi:Example 1.}

{phang2}{cmd: ieboilstart}, {opt versionnumber(12.1)}{p_end}
{phang2}{inp:`r(version)'}{p_end}

{pmore}After running the two lines of code above
all users will run their version of Stata as if the version was 12.1.
That means that anyone who bought or upgraded their Stata
to version 12.1 or a more recent version can run this code
and will behave as identical as possible.{p_end}

{pstd}{hi:Example 2.}

{phang2}{inp:local proj_ado} {it:"/path/to/project/code/ado"}{p_end}
{phang2}{cmd:ieboilstart}, {opt versionnumber(15.1)}
{opt adopath("`proj_ado'", strict)}{p_end}
{phang2}{inp:`r(version)'}{p_end}

{pmore}In this example the Stata version is set to 15.1
and the ado-folders are updated.
Let's say a project folder is located at {it:"/path/to/project"} and
inside it there is a folder called {it:code} where all code files are located.
This would be a great location for a folder called {it:ado} that would be
the project specific ado-folder.
Since the sub-option {it:strict} is used this is the only place
where Stata would look for commands that are not built-in commands.
Any commands installed by SSC before updating
this ado-path is no longer available.
Any such commands that is needed in the code for this project needs
to be installed again in the project specific ado-folder.
Which can be done using {inp:ssc install ...} the regular way
after {cmd:ieboilstart} was run like this.

{marker auth}{...}
{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DIME, The World Bank's department for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
   writing "ietoolkit ieboilstart" in the subject line to:{break}
   dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
   history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
