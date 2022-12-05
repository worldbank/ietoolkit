{smcl}
{* 11 Jan 2022}{...}
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
work exactly the same in every possible context.
This command does not guarantee against any version discrepancies in Stata
or in user-contributed commands.
This command is solely a collection of common practices to reduce the risk
that the same code generates different outputs
when running on different computers.
See more details {help ieboilstart##desc:below}.

{marker synt}{...}
{title:Syntax}

{phang}Note that one important feature of this command requires that
{inp: `r(version)'} is included on the first line after {cmd: ieboilstart}, as this setting cannot be done inside a user-command.

{phang}{cmdab:ieboilstart} , {opt v:ersionnumber(Stata_version)}
[{opt ado:path("path/to/folder" [, strict])}
{opt noclear} {opt q:uietly} {opt veryquietly}
{it:{help ieboilstart##mset:memory_options}}]{p_end}{phang}`r(version)'{p_end}

{marker opts}{...}
{synoptset 28}{...}
{synopthdr:options}
{synoptline}
{synopt :{opt v:ersionnumber(Stata_version)}}Sets the Stata version
the project's code should targets{p_end}
{synopt :{opt ado:path("path" [, strict])}}Sets the folder where this
project's ado-files are stored.{p_end}
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
Especially if you want the code to run identically also in the future when
new versions of Stata and new versions of user-written commands
have been released.
The objective of this command is to reduce the risk
that the code does not generate the same results in different environments,
but it is not technically possible to fully eliminate this risk.{p_end}

{pstd}The best practice settings this command use
can be grouped into the following types:
{it:Stata version}, {it:ado-paths}, and {it:other} settings.{p_end}

{dlgtab:Stata version settings}

{pstd}Research projects often span over several years,
or is required to be reproducible for anyone in the future
reviewing the results.
After several years have past, it is likely that
a new version of Stata has been released.
This can change how the Stata code runs, so for reproducibility,
it is important to indicate which Stata version this code targets.{p_end}

{pstd}This command uses Stata's built in command {cmd:version} to
target a script to a specific versions of Stata.
While this makes the code run more similar to the targeted Stata version,
it does not guarantee that the code runs identically.
Setting the Stata version is particularly important for any Stata code
containing randomization that is intended to be reproducible.
Stata occasionally updates the randomization algorithm used between versions.
See many more details {help version:here}.{p_end}

{pstd}Due how {cmd:version} works is it not possible to set
the Stata version for the rest of the code inside a command like this command.
Therefore, in order for the version best practices to be applied,
any user of this command must add {inp:`r(version)'}
on the immediate subsequent line. See below.{p_end}

{phang}{cmdab:ieboilstart} , {it:options}{p_end}{phang}`r(version)'{p_end}

{pstd}The version setting has the scope of a local,
meaning that it expires when a dofile
and all sub-dofiles it is calling are completed. If
{browse "https://dimewiki.worldbank.org/Master_Do-files":main/master do-files}
are used, then the version should be set in the main file,
and only results generated when running all code from the main file
should be considered reproducible.{p_end}

{dlgtab:Ado-path settings}

{pstd}Many research projects use user-written commands in the code.
These commands are commonly installed from {help ssc:SSC},
but can also be installed from other sources
or be custom written for the specific project.
Code using user-written commands is only reproducible to the highest standard
if they are using the same versions of these commands.
This is rarely the case, unless the functionality
simplified by this command is used.{p_end}

{pstd}Coordinating that all users in a project team, as well as
anyone reproducing the results at the same time or in the future,
have exactly the same version of user-written commands
installed in their installation of Stata is probably impossible.
The best practice solution is to set up a project specific folder
where the commands needed for this project is installed.
This folder can be shared using a syncing service (ex. DropBox)
or in version control tools (ex. GitHub).
Just make sure that if this folder is shared publicly,
the project is allowed to do so
for commands not written by anyone in the project.{p_end}

{pstd}In this command, the {opt adopath("path/to/folder")} option specifies
a folder as the project specific folder for user written commands.
This allows any program files in that folder to be available to the code
in addition to the commands already installed in the users Stata installation.
If the sub-option {it:strict} is used,
as in {opt adopath("path/to/folder", strict)},
then {ul:only} commands in this folder is available to the code.
Stata's built-in commands are always available.
After {it:strict} is used, you can use {inp:ssc install} or {inp:net install}
to install commands into the project specific folder.{p_end}

{pstd}The scope of adopath setting is the same as for globals.
This means that the settings are restored to the defaults
next time Stata is restarted.{p_end}

{dlgtab:Other settings}

{pstd}It is rare that any of the settings in this category
is anything a typical user ever needs to worry about.
These settings mostly prevents that code does not run on a computer as the
Stata memory management settings has been set
to a particularly extreme value.
The one case these settings can be relevant to modify for a user is if
the code is developed to run on a computer or server with unusual
(for example very small) specifications.{p_end}

{pstd}This command also standardize some settings that could in some cases
make sure that the code runs differently on different computers.
For example, {help set more:set more off},
{help set varabbrev:set varabbrev off}, {help set type:set type float},
etc.{p_end}

{pstd}See the tables below for a discussion of which settings used and
why certain default values were used.{p_end}

{p2colset 5 23 25 2}
{p2col : Other Settings}Short explanation{p_end}
{p2line}
{pstd}{it: Basic Memory Settings:}{p_end}
{p2col :{cmdab:set maxvar}}sets the maximum number of variables allowed. The
	default value is the maximum allowed in the version of Stata used which is 32,767 in Stata MP or SE, and 120,000 in Stata MP 15. A lower maximum
	number can manually be set by the option {cmdab:maxvar()}. The maxvar is fixed in Stata Small or IC so this setting is ignored when any of
	those versions of Stata is used. See {help set maxvar:set maxvar}.{p_end}
{p2col :{cmdab:set matsize}}sets the maximum number of variables that can be included
	in estimation commands such as {cmd:regress}. The {cmdab:ieboilstart} default value
	is 400 which is the default value for Stata. A higher value is often allowed but it slows down
	Stata and is only needed when running very complex analysis. This option can be used to set a higher
	value, as long as the value does not violate the limitations in the version of Stata used. See {help set matsize:set matsize}.{p_end}
{break}
{pstd}{it: Dynamic Memory Settings (see {help memory:memory} for details and reasons for default values. Few users ever need to change these values):}{p_end}
{p2col :{cmdab:set min_memory}}sets a lower bound for the amount of memory assigned to Stata. The default value is no lower bound.{p_end}
{p2col :{cmdab:set max_memory}}sets an upper bound for the amount of memory assigned to Stata. The default is as much as the hardware of the computer allows.{p_end}
{p2col :{cmdab:set niceness}}defines how quickly Stata releases unused memory back to the computer{p_end}
{p2col :{cmdab:set segmentsize}}defines how large bundles of data is assigned each time
Stata request more memory. Too large bundles make Stata occupy an
unnecessary large part of the computer's memory (that otherwise could
have been used by other applications), and too small bundles make
Stata frequently consume processing power requesting new bundles.{p_end}
{break}
{pstd}{it: Code Flow Settings:}{p_end}
{p2col :{cmdab:set more off}}disables the default setting that Stata stops and
	waits for the user to press any key each time the output window is full. Long
	dofiles would take a very long time to run and require constant attention from
	the user without this setting. Most Stata users always disable the default
	which is {cmdab:set more on}. See {help set more:set more}.{p_end}
{p2col :{cmdab:pause on}}allows the usage of the command {cmdab:pause} which can
	be very useful during debugging. See {help pause:pause}.{p_end}
{break}
{pstd}{it: Variable Settings:}{p_end}
{p2col :{cmdab:set varabbrev off}}allows users to abbreviate variable names
similarly to command names such as gen for generate and reg for regress.
However, while command abbreviation has strict rules constant across data sets, users, and
Stata versions; variable name abbreviation does not have the same strict rules
and consistency. While enabling variable abbreviation can speed up coding,
it is an error-prone technique unless all users using a dofile with
variable abbreviations organize their coding practices exactly the same
way. See {help set varabbrev:set varabbrev} for more details and carefully
consider this caution before enabling variable abbreviations in a
collaborative dofile.{p_end}
{p2col :{cmdab:set type float}}sets the default variable type
when creating a new variable to {it:float}.
Different default type can lead to differences in randomization
as this setting affects the precision in the randomization.
For extremely large dataset the type {it:double} might be required,
when generating random numbers that is expected to be unique.
But since that type is twice as storage intensive,
this command use {it:float} as default,
and users need to specify {it:double} in the rare cases
it makes a difference.  {p_end}
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
	unless there is something specific to a newer version that is required for any
	dofile.
  Only major and recent versions are allowed in order
  to reduce errors and complexity.
	All versions of Stata can be set to run any older version of Stata but not a newer. {p_end}

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
to make sure that all user written commands are saved in the project ado-folder.
If a project should eventually be turned into a reproducibility package,
then the it is easier to use {it:strict} from the beginning and add commands
as they are used in the code.
This is easier than in the very end make sure that
the correct version is installed to the project ado-folder.

{phang}{opt noclear} prevents the command from clearing/deleting the data set
	in working memory. No data may be in working memory in order to modify
	settings for maxvar, min_memory, max_memory and segmentsize. That is why the default
	is to clear the data set stored in working memory. Working memory is your RAM
	memory so no data saved to your hard drive will ever be deleted by this command.
	This command is intended to be placed at the very top of a dofile, so the
	data needed could be loaded into memory after running {cmd:ieboilstart}. For the
	reasons above, {cmdab:noclear} and {cmdab:maxvar()} cannot be combined.{p_end}

{phang}{opt q:uietly} suppresses two of three outputs
this commands generates in the result window.
The first output is a disclaimer warning the user that there is
no guarantee that commands will always behave identically.
The second output is a list of all the settings applied and their values.{p_end}

{phang}{opt veryquietly} suppresses the third output this commands generates
in the result window in addition to the two that {cmd:quietly} is suppressing.
The third output is a reminder to set the version number using
{inp:`r(version)'} after running the command.

{phang}{opt maxvar(numlist)} manually sets the maximum number of
variables allowed in a data set. The default is to set the number to the highest
	allowed. Reducing this number can occasionally improve performance, but modern
	computers running Impact Evaluations analysis are more likely to
	face the problem of too few variables allowed than running out of
	memory.
  For example, the maximum number allowed in Stata 15.1 is 2047 in Stata IC;
  32,767 in Stata SE; and 120,000 in Stata MP.
  This option is ignored for users that use Stata IC or Small Stata.{p_end}

{phang}{opt matsize(numlist)} manually sets the maximum number of
	variables allowed in estimation commands, for example {help reg:regress}.
	The default is to set the number to the highest allowed in your version of Stata.
	Reducing this number can occasionally improve performance, but modern
	computers running Impact Evaluations analysis are more likely
	to run into problems by allowing too few variables than running out of memory.
	Although, this is more likely the case with {cmdab:maxvar} than
	with {cmdab:matsize}. The maximum number allowed is 800 in Stata IC and 11,000 in Stata
	MP or SE.{p_end}

{phang}{opt noperm:anently} is used to not change settings for future sessions
	of Stata. The default is that all settings are 	set as defaults so that they apply each time Stata
	starts after using this command. This option disable that. See option permanently in {help memory:memory} for
	mroe details. {cmd:set more off} is always set permanently.{p_end}

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
