{smcl}
{* 31 Jan 2019}{...}
{hline}
help for {hi:ieboilstart}
{hline}

{title:Title}

{phang}{cmdab:ieboilstart} {hline 2} harmonizes Stata settings across team members in the same project.

{phang2}For a more descriptive discussion on the intended usage and workflow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Ieboilstart":DIME Wiki}.

{phang}{hi:DISCLAIMER} {hline 1} Due to technical reasons, it is
impossible to guarantee that different types of Stata (version number, Small/IC/SE/MP
or PC/Mac/Linux) work exactly the same in every possible context. This command does not
guarantee against any version discrepancies in Stata or in under-contributed commands,
it is solely a collection of common practices to reduce the risk of the same code running
differently on different computers. See more details {help ieboilstart##comp:below}.

{marker synt}{...}
{title:Syntax}

{phang}Note that due to technical requirements in Stata, to include the most
	important setting - version() - in this command you must include the second line below.{p_end}

{pmore}
{cmdab:ieboilstart} , {cmdab:v:ersionnumber(}{it:version_number}{cmd:)}  [{it:optional_options}]{break}
`r(version)'

{phang}The second line "`r(version)'" uses the command {help version} to set the same Stata version across all
	users. "`r(version)'" is identical to setting the version to the version number set in {cmdab:v:ersionnumber()} but
	both helps standardize this setting across different parts in the project and function as a reminder to
	set the version number. {p_end}

{marker opts}{...}
{synoptset 20}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:v:ersionnumber(}{it:string}{cmd:)}}sets a stable version of Stata
	for all users. This option does {ul:nothing} unless "`r(version)'" is included as in the example above.{p_end}
{synopt :{cmdab:maxvar(}{it:numlist}{cmd:)}}manually sets the maximum number of
	variables allowed in a data set. The default if omitted is the maximum number of variables
	allowed depending on the version of Stata used.{p_end}
{synopt :{cmdab:matsize(}{it:numlist}{cmd:)}}manually sets the maximum number of
	variables allowed in an estimation command, for example {help regress:regress}.
	The default if omitted is 400.{p_end}
{synopt :{cmdab:noclear}}prevents the command from clearing all data which some settings
	require. Best practice is to use this command before opening any data.{p_end}
{synopt :{cmdab:q:uietly}}suppresses the output with the disclaimer and the list
	of settings.{p_end}
{synopt :{cmdab:veryquietly}}does what {cmdab:quietly} does, but also suppresses the
	reminder to include "`r(version)'".{p_end}
{synopt :{cmdab:setmem(}{it:string}{cmd:)}}manually sets the memory for	Stata 11 users.{p_end}
{synopt :{cmdab:c:ustom(}{it:string}{cmd:)}}allows the user to enter custom lines
	of code to be added.{p_end}
{synopt :{cmdab:noperm:anently(}{it:string}{cmd:)}}is used to not change settings for future sessions of Stata.{p_end}
{synoptline}

{marker desc}{...}
{title:Description}

{pstd}{cmdab:ieboilstart} standardizes best practice settings across all users using for a project.
	Such standardized code is usually referred to as boilerplate code, and that is
	where {cmdab:ieboilstart} gets its name. Standardizing the boilerplate code
	in a project reduces the risk that code behaves differently across users regardless of
	what version and type of Stata they are running.

{pstd}A command like this is impossible to make comprehensive in terms of versions control. Therefore,
	the ambition of this command is only to provide a convenient way to include boilerplate code based
	on commonly used best practices, which is much better than having no boilerplate code at all. The default
	values used are the values that are standard in boilerplate code for dofiles written for Impact
	Evaluations at DIME, World Bank. Suggestions for additions or improvements are very welcomed. See
	the {help ieboilstart##auth:author} section	for contact details.

{marker comp}{...}
{title:Compatibility Across Different Stata:}

{pstd}{cmdab:ieboilstart} sets settings that increases compatibility between Stata 11.0-15.0, Stata Small/IC/SE/MP and Stata for	PC/Mac/Linux. {it:Increase compatibility} does not mean an absolute guarantee that all code will always
	work the same in different types of Stata. That is technically impossible. {it:Increase compatibility} here means reducing the risk of code working differently in different types of Stata.

{pstd}{cmdab:ieboilstart} does sometimes apply different settings for different users as all settings does not work for all versions and types of Stata. For example, new memory settings were introduced in Stata 12 and {inp:set maxvar} is not allowed in Stata IC. {cmdab:ieboilstart} is implemented to set the settings in each version and type of Stata that reduces the risk of errors when different users run the same code, but the only way to eliminate the risk completely, is to use exactly the same version of Stata.

{pstd}In addition to version control, {cmdab:ieboilstart} allows a project to 	standardize user preference settings such as {help set varabbrev:varabbrev} that 		can cause code to behave differently across users.

{title:Important Details on Version Setting:}

{pstd}Impact Evaluations and other research projects often span over many
	years, which means that the same code is likely to run in different versions
	of Stata. Stata provides a method to reduce the risk of discrepancies due to this. See {help version:version} settings for more details. This method is included in {cmdab:ieboilstart}, however, {cmd:version} is mainly intended for making code written in Stata 11 work
	in Stata 14 and not necessarily the other way around. Setting the version is still best practice and perhaps the most important setting in {cmdab:ieboilstart}. Read the {help ieboilstart##synt:syntax section} on the extra step required for {cmdab:ieboilstart} to set the version.{p_end}

{pstd}{hi:Warning:} Any dofiles containing randomization {ul:{hi:MUST}} set the version number
	as Stata occasionally makes updates to its randomization algorithm between versions. A dofile including random assignment
	or random sampling is therefore not necessarily stable across different versions of Stata,
	unless the dofile has a version number explicitly set in the beginning of the file.{p_end}

	{pstd}The version setting has the scope of a local, meaning that it expires when a dofile and all sub-dofiles it is calling are completed. Therefore, set the version in your master dofile {ul:and} in every single dofile using randomization. This will make your randomization stable even if another user would only run the specific dofile with the randomization.{p_end}

{title:Details on Memory Settings:}

{pstd}In Stata versions before Stata 12, memory was assigned statically from the
	computer memory, meaning that there was a fixed amount of memory assigned to Stata
	regardless if required it or not. Stata would crash if it went over that fixed limit
	when for example increasing the data set or running a complex calculation. In Stata
	12 and more recent versions, this is done dynamically, meaning that Stata is assigned
	a little bit of memory when it is starts and assigned additional memory dynamically
	as needed. The only memory limit is the hardware limits on the computer it is running
	on.

{pstd}The fixed memory in Stata 11 was assigned by the command {cmdab:set memory}. This
	command is simply ignored in Stata 12 or later. Instead the dynamic memory setting
	can be fine tuned with {cmdab:min_memory}, {cmdab:max_memory}, {cmdab:niceness} and
	{cmdab:segmentsize}, although even highly advanced users rarely have to worry about these settings as long as they are set to the recommended default values
	(which this command ensures that they are).

{p2colset 5 22 24 2}
{p2col : Memory Settings}Short explanation{p_end}
{p2line}
{pstd}{it: Basic Settings:}{p_end}
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
{pstd}{it: Static Memory Settings (only applicable in Stata 11)}{p_end}
{p2col :{cmdab:set memory}}sets the amount of static memory assigned to Stata. {p_end}
{p2line}

{pstd}{hi:{ul:Other Settings:}}{break}The other settings are included as they are either very
	commonly preferred or reduces the risk of errors for users that do not yet fully understand
	the implication of setting these settings to other values than what is recommended. These
	settings can be reverted to personal preferences after running {cmdab:ieboilstart} or by using the {cmd:custom()} option.{p_end}
{p2colset 5 24 26 2}
{p2col : Other Settings}Short explanation{p_end}
{p2line}
{p2col :{cmdab:set more off}}disables the default setting that Stata stops and
	waits for the user to press any key each time the output window is full. Long
	dofiles would take a very long time to run and require constant attention from
	the user without this setting. Most Stata users always disable the default
	which is {cmdab:set more on}. See {help set more:set more}.{p_end}
{p2col :{cmdab:pause on}}allows the usage of the command {cmdab:pause} which can
	be very useful during debugging. See {help pause:pause}.{p_end}
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
{p2line}

{title:Options}

{phang}{cmdab:v:ersionnumber(}{it:string}{cmd:)} sets a stable version of Stata
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
	dofile. Only major and recent versions are allowed in order to reduce errors and
	complexity. The valid versions are 11.0, 11.1, 11.2, 12.0, 12.1, 13.0, 13.1,
	14.0, 14.1, 14.2, 15.0, 15.1, and all versions without decimals. However, it is recommended
	to use a .1 over a .0 version. .1 is free of charge if you already have the
	corresponding .0 and .1 includes bug fixes to the functions introduced in .0.
	All versions of Stata can be set to run any older version of Stata but not a newer. {p_end}

{phang}{cmdab:maxvar(}{it:numlist}{cmd:)} manually sets the maximum number of
	variables allowed in a data set. The default is to set the number to the highest
	allowed. Reducing this number can occasionally improve performance, but modern
	computers running Impact Evaluations analysis are more likely to
	face the problem of too few variables allowed than running out of
	memory. The maximum number allowed in Stata 15.1 is 2047 in Stata IC; 32,767 in Stata SE;
	and 120,000 in Stata MP. This setting is ignored for users that use Stata IC or Small Stata.{p_end}

{phang}{cmdab:matsize(}{it:numlist}{cmd:)} manually sets the maximum number of
	variables allowed in estimation commands, for example {help reg:regress}.
	The default is to set the number to the highest allowed in your version of Stata.
	Reducing this number can occasionally improve performance, but modern
	computers running Impact Evaluations analysis are more likely
	to run into problems by allowing too few variables than running out of memory.
	Although, this is more likely the case with {cmdab:maxvar} than
	with {cmdab:matsize}. The maximum number allowed is 800 in Stata IC and 11,000 in Stata
	MP or SE.{p_end}

{phang}{cmdab:noclear} prevents the command from clearing/deleting the data set
	in working memory. No data may be in working memory in order to modify
	settings for maxvar, min_memory, max_memory and segmentsize. That is why the default
	is to clear the data set stored in working memory. Working memory is your RAM
	memory so no data saved to your hard drive will ever be deleted by this command.
	This command is intended to be placed at the very top of a dofile, so the
	data needed could be loaded into memory after running {cmd:ieboilstart}. For the
	reasons above, {cmdab:noclear} and {cmdab:maxvar()} cannot be combined.{p_end}

{phang}{cmdab:q:uietly} suppresses two of three outputs this commands generates in the result window. The first output is a disclaimer warning the user that there is no guarantee that commands will always behave identically. The second output is a list of all the settings applied and their values..{p_end}

{phang}{cmd:veryquietly} suppresses the third output this commands generates in the result window in addition to the two that {cmd:quietly} is suppressing. The third output is a reminder to set the version number using "`r(version)'" after running the command.

{phang}{cmdab:c:ustom(}{it:string}{cmd:)} allows the user to add one or multiple custom lines of code. Each line of code should be separated with a "@". See example 2
	below for more details.{p_end}

{phang}{cmdab:setmem(}{it:string}{cmd:)}This option is only relevant for users of Stata 11. This value must be an integer followed by the letter B, K, M or G. The default if omitted is 50M. Cannot be used if
	versionnumber() is set to version 12.0 or more recent. See {help set memory} for more details. This link will only display options relevant to Stata 11 when clicking it in Stata 11. Otherwise it will show the options relevant to Stata 12 and later.

{phang}{cmdab:noperm:anently(}{it:string}{cmd:)} is used to not change settings for future sessions
	of Stata. The default is that all settings are 	set as defaults so that they apply each time Stata
	starts after using this command. This option disable that. See option permanently in {help memory:memory} for
	mroe details. {cmd:set more off} is always set permanently.{p_end}

{title:Examples}

{pstd}{hi:Example 1.}

{pmore}{inp:ieboilstart, versionnumber(11.1)}
{break}`r(version)'

{pmore}After running the two lines of code above all users will run their version
 of Stata as if the version was  11.1. That means that anyone who bought or
 upgraded Stata after June 2010 can use the command and all commands will behave
  identically for all those users. All other settings have been set to common
	best practice values.

{pstd}{hi:Example 2.}

{pmore}{inp:ieboilstart, versionnumber(12.1) custom(ssc install estout @ ssc install winsor)}
{break}`r(version)'

{pmore}In the example above, the version is set to 12.1. When running this command, it also makes sure that the user has the two commands {inp:estout} and {inp:winsor} installed.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading and suggestions I
	received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Michell Dong{break}John Dundas{break}Paula Gonzales{break}Seungmin Lee{break}Srujith Lingala{break}William Lisowski{break}Daniel Klein

{marker auth}{...}
{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit ieboilstart" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
