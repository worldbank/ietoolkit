{smcl}
{* 20 Oct 2016}{...}
{hline}
help for {hi:ieboilstart}
{hline}

{title:Title}

{phang2}{cmdab:ieboilstart} {hline 2} Creates a dofile with the DECIE standardized boilerplate 
settings used to standardize settings across different contributers to the code.

{title:Syntax}

{phang2}Note that without running both the main part and the second part this command 
doesn't standardize any settings. The dofile will still be generated without the main 
part, but no changes will be made to settings without the second part.

{phang2}{it:Main part:}{break}
{cmdab:ieboilstart} using {help filename :filename}{it:.do}
, {cmdab:v:ersionnumber(}{it:string}{cmd:)}  [{cmdab:maxvar(}{it:numlist}{cmd:)}
{cmdab:matsize(}{it:numlist}{cmd:)} {cmd:noclear} {cmdab:qui:etdo} {cmdab:cust:om(}{it:string}{cmd:)}]

{phang2}{it:Second part if following immediately after main part (recommended):}{break}
{cmdab:do} "`r(ieboil_dofile)'"

{phang2}{it:Second part anywhere in a dofile:}{break}
{cmdab:do} {help filename :filename}{it:.do}

{pstd}The reason we need a second part on a separate row is due to Stata 
	resetting any changes made to the version setting inside a command. More 
	details below.

{marker opts}{...}
{synoptset 20}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:v:ersionnumber(}{it:string}{cmd:)}}sets a stable version of Stata 
	that always applies regardless of which [newer] version of Stata the 
	dofile is executed in after running this command.{p_end}
{synopt :{cmdab:maxvar(}{it:numlist}{cmd:)}}manually sets the maximum number of 
	variables allowed in a data set. Default is to set it to the maximum that 
	your version of Stata allows.{p_end}
{synopt :{cmdab:matsize(}{it:numlist}{cmd:)}}manually sets the maximum number of 
	variables allowed in an estimation command, for example {help regress:regress}. Default 
	is to set it to the maximum that your version of Stata allows.{p_end}
{synopt :{cmdab:noclear}}prevents the command from clearing data in memory. The 
	memory must be cleared in order to modify settings maxvar, min_memory, max_memory 
	and segmentsize. Clearing all data from working memory is therefore the default.{p_end}
{synopt :{cmdab:quietly}}includes quietly tags in the dofile, so that the dofile runs without displaying output.{p_end}
{synopt :{cmdab:cust:om(}{it:string}{cmd:)}}allows the user to enter custom lines 
of code to be added to the dofile this command creates.{p_end}
{synoptline}

{title:Description}

{pstd}{cmdab:ieboilstart} standardizes the boilerplate (section of standardized 
	code) used to standardize settings in dofiles written for Impact Evaluations 
	at World Bank DECIE. 

{pstd}Note that witout the second part of the syntax above this command does nothing.
	In Stata, most types of memory settings and the version setting are discarded if set inside a user written command 
	after the command is done running. This is due to settings made inside of a command may be 
	be unwanted in the rest of the dofile. The version setting and most memory 
	settings are therefore restored to its original value by Stata when the any user written command
	comes to an end. As such rollback applies to ieboilstart as well, ieboilstart
	only prepares a dofile including all the recommended settings that should be used after ieboilstart.
	
{pstd}This command addresses three types of settings: Version Setting, Memory
	Settings, Other Settings. Each type is explained separately below:
	
{pstd}{hi:{ul:Version Setting:}}{break}Since Impact Evaluations generally span over several years, 
	the same dofile are often used in different versions of Stata. The only way to 
	guarantee that all commands in the dofile will be executed similarly throughout 
	the duration of the Impact Evaluation is to explicitly set the version number. 
	All versions of Stata can be set to run any older version of Stata but not a
	newer. It is therefore best practice to set the version number to be a few 
	versions older than the latest, even if the person writing the code uses the 
	latest version. This will prevent that team members with slightly older versions 
	of Stata will still be able to run the same code.
	
{pstd}The command checks whether the version number is valid, and whether the version number 
	is not too old for a large number of commands to be executed very differently compared
	to more recent versions of Stata. Therefore, DECIE policy is to never set the version
	number to older than 10.0, and the recommended practice is to use version 12.1 or newer,
	as long as there is no risk that any team member will need to use a version of Stata 
	older than 12.1. There are no exact rules on which version to select for a dofile but a little 
	more guidance is given in the Option section below.

{pstd}{hi:Warning 1:} Any dofiles containing randomization {ul:{hi:MUST}} set the version number 
	as Stata occasionally makes updates to how randomization works. A dofile including random assignment 
	or random sampling is therefore not necessarily stable across different versions of Stata, 
	unless the dofile has a version number explicitly set in the beginning of 
	the file.
	
{pstd}{hi:Warning 2:} Note that version settings has the same scope as a local. That means that 
	as soon as a dofile comes to an end (after running all the sub-dofiles that the dofile calls) 
	the Stata version is restored to its original value. Hence, DIME recommended best practice is to set the version 
	number in the master dofile for each project and in any individual dofile that 
	depends on randomization. It would only rarely be necessary to set version number in each
	individual dofile if the version number is set in the master dofile, in most projects this would 
	create a lot of work to a very small gain. If ieboilstart is included in the master dofile, 
	then it would be sufficient to use the command {help version:version} in individual dofiles 
	with randomization instead of running the dofile generated by ieboilstart.
	
{pstd}{hi:{ul:Memory Settings:}}{break}Memory Settings are divided into basic and advanced 
	settings (see the list below). Even highly advanced users rarely have to worry about the advanced 
	settings as long as they are set to the recommended default values (which 
	this command ensures that they are).
	
{pstd}The basic settings will be set to the maximum value allowed in your
	version of Stata unless option {cmdab:maxvar()} or option {cmdab:matsize()} are specified.
	If you are running Stata on an old computer, or if you have to simultaneously 
	run memory-intensive programs, then you can set a lower value than the 
	maximum using the {cmdab:maxvar()} and {cmdab:matsize()} options. However,
	the difference that makes on a modern computer is usually marginal.

{pstd}In earlier versions of Stata memory was assigned statically from the 
	computer memory, meaning that Stata could only use as much memory as the 
	default value of the version of Stata used, or a value explicitly set by the
	user. This is no longer the case as Stata gets memory assigned dynamically. 
	The operative system assigns a small amount of the computer's memory when Stata starts,
	and increase the assigned memory automatically when needed. The command {cmdab:set memory} 
	that all users previously had to be aware of is therefore now ignored by 
	Stata. {cmdab:set memory} was replaced with {cmdab:set min_memory} and 
	{cmdab:set max_memory} but as memory is now assigned dynamically, those are 
	only relevant to the very advanced user in very specific contexts.{p_end}
{p2colset 5 22 24 2}
{p2col : Memory Setting}Short explanation{p_end}
{p2line}
{pstd}{it: Basic Settings:}{p_end}
{p2col :{cmdab:set maxvar}}sets the maximum number of variables allowed. The 
	default value is the maximum allowed in your version of Stata; 2047 in Stata 
	IC and 32,767 in Stata MP or SE. The maximum number can manually be set by the
	option {cmdab:maxvar()} as long as the number does not violate the limitations
	in your version of Stata. See {help set maxvar:set maxvar}{p_end}
{p2col :{cmdab:set matsize}}sets the maximum number of variables allowed in a 
	regression or in any other of Stata's estimation commands. The default value is
	the maximum allowed in your version of Stata; 800 in Stata IC and 11,000 in 
	Stata MP or SE. The maximum number can manually be set by the option {cmdab:matsize()} 
	as long as the number does not violate the limitations in your version of 
	Stata. See {help set matsize:set matsize}{p_end}
{break}
{pstd}{it: Advanced Settings:}{p_end}
{pstd}All advanced settings are set to the default values described here {help memory:memory}{p_end}
{p2col :{cmdab:set min_memory}}sets a lower bound for the dynamic memory assignment{p_end}
{p2col :{cmdab:set max_memory}}sets an upper bound for the dynamic memory assignment{p_end}
{p2col :{cmdab:set niceness}}defines how quickly Stata releases unused memory back to the computer{p_end}
{p2col :{cmdab:set segmentsize}}defines how large bundles of data is assigned each time
			Stata request more memory. Too large bundles make Stata occupy an 
			unnecessary large part of the computer's memory (that otherwise could 
			have been used by other applications), and too small bundles make
			Stata frequently consume processing power requesting new bundles.{p_end}
{p2line}
	
{pstd}{hi:{ul:Other Settings:}}{break}The other settings are included as they are either very 
	commonly preferred or reduces the risk of errors for users that do not yet fully understand 
	the implication of setting these settings to other values than what is recommended. These 
	settings can be reverted to personal preferences after running the dofile created 
	by {cmdab:ieboilstart} or by using the {cmd:custom()} option.{p_end}
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
		way. See {help set varabbrev:set varabbrev} for more details and carfully 
		consider this caution before enabling variable abbreviations in a 
		collaborative dofile.{p_end}
{p2line}

{title:Options}

{phang}{cmdab:v:ersionnumber(}{it:string}{cmd:)} sets a version number of 
	Stata for the rest of the dofile. This option ensures that the dofile will 
	generates a consistent result regardless of which version of Stata that is used. 
	The version number should be set to the oldest version used by anyone
	in the team that will work on this dofile. However, a too low number might
	risk that some commands will not work as expected in more recent versions. Best 
	practice is to keep the same version number throughout a project, unless there is something specific 
	to a newer version that is required for any dofile. Only major and recent 
	versions are allowed in order to reduce errors and complexity. The valid versions 
	are 10.0, 10.1, 11.0, 11.1, 11.2, 12.0, 12.1, 13.0, 13.1, 14.0 and 14.1. All
	versions of Stata can be set to run any older version of Stata but not a 
	newer. It is recommended to use a .1 over a .0 version. .1 is free of charge
	if you already have the corresponding .0 and .1 includes bug fixes to the 
	functions introduced in .0{p_end}

{phang}{cmdab:maxvar(}{it:numlist}{cmd:)} manually sets the maximum number of 
	variables allowed in a data set. The default is to set the number to the highest 
	allowed. Reducing this number can occasionally imrpove performance, but modern 
	computers running Impact Evaluations analysis are more likely to
	face the problem of too few variables allowed than running out of 
	memory. The maximum number allowed is 2047 in Stata IC and 32,767 in Stata MP or SE.{p_end}

{phang}{cmdab:matsize(}{it:numlist}{cmd:)} manually sets the maximum number of 
	variables allowed in estimation commands, for example {help reg:regress}. 
	The default is to set the number to the highest allowed in your version of Stata.
	Reducing this number can occasionally imrpove performance, but modern 
	computers running Impact Evaluations analysis are more likely
	to run into problems allowing too few variables than running out of memory. 
	Although, this is more likely the case with {cmdab:maxvar} than 
	with {cmdab:matsize}. The maximum number allowed is 800 in Stata IC and 11,000 in Stata 
	MP or SE.{p_end}

{phang}{cmdab:noclear} prevents the command from clearing/deleting the data set 
	in working memory. No data may be in working memory in order to modify
	settings for maxvar, min_memory, max_memory and segmentsize. That is why the default
	is to clear the data set stored in working memory. Working memory is your RAM
	memory so no data saved to your hard drive will ever be deleted by this command.
	This command is intended to be placed at the very top of a dofile, so the 
	data needed could be loaded into memory after running ieboilstart. For the 
	reasons above, {cmdab:noclear} and {cmdab:maxvar()} cannot be combined.{p_end}
	
{phang}{cmd:quietdo} encapsulates the do-file created in a {help quietly} block so 
	that the do-file runs without displaying any output.{p_end}
	
{phang}{cmdab:cust:om(}{it:string}{cmd:)} allows the user to add one or multiple custom lines of code 
	to the do-file. Each line of code should be seperated with a "@". See example 4 
	below for more details.{p_end}	

{title:Examples}

{pmore}In all examples below {it:localname1} and {it:localname2} may be changed 
	to any other valid macro name.

{pstd}{hi:Example 1.}

{pmore}{inp:ieboilstart using }{it:myfile}{inp:.do, versionnumber(11.1)}
{break}{cmdab:do} "`r(ieboil_dofile)'"

{pmore}In the example above, a dofile named myfile.do will be saved to the current 
	directory (see {help cd:help cd}). After running iboil_settings.do the rest of the code 
	will be run as if the version of Stata was version 11.1. That means that anyone who 
	bought or upgraded Stata after June 2010 can use this dofile and all commands will 
	behave identically for all those users. Maxvar and matsize have been set to 
	highest allowed values (note that this might differ across users) and advanced
	memory settings is set to Stata's recommended values. More is set to off, 
	pause is on and variable abbreviation is disabled. 

{pstd}{hi:Example 2.}

{pmore}{inp:global dofile_folder "C:\User\Example Project Folder\dofiles"}

{pmore}{inp:ieboilstart using "$dofile_folder/ieboil_settings.do", versionnumber(13.1) maxvar(20000)}
{break}{cmdab:do} "`r(ieboil_dofile)'"

{pmore}In the example above, a dofile named ieboil_settings.do will be saved to the 
	folder that the global {it:dofile_folder} is pointing to. The rest of the code will be run as if the 
	version of Stata was version 13.1. That means that anyone who bought or upgraded 
	Stata after October 2013 can use this dofile. Matsize has been set to 
	highest allowed values, but maxvar is restricted to 20,000 variables. Advanced
	memory settings is set to Stata's recommended values. More is set to off,
	pause is on and variable abbreviation is disabled. 

{pstd}{hi:Example 3.}	
	
{pmore}If the same settings as in example 2 needs to be applied somewhere else in
	the code, then the do-file can be referenced by its name like below:

{pmore}{cmdab:do} "$dofile_folder/ieboil_settings.do"

{pstd}{hi:Example 4.}

{pmore}{inp:ieboilstart using "$dofile_folder/ieboil_settings.do", versionnumber(13.1) custom(ssc install estout @ ssc install winsor)}
{break}{cmdab:do} "`r(ieboil_dofile)'"

{pmore}In the example above, two lines of code is manually entered to the do-file.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading and suggestions I 
	received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Michell Dong{break}John Dundas{break}Paula Gonzales{break}Srujith Lingala{break}William Lisowski


{title:Author}

{phang}Kristoffer Bjärkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications 
		 writing "ietools ieboilstart" in the subject line to:{break}
		 kbjarkefur@worldbank.org
		 
{phang}You can also see the code, make comments to the code, see the version 
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}


