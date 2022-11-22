{smcl}
{* 11 Jan 2022}{...}
{hline}
help for {hi:ieboilsave}
{hline}

{title:Title}

{phang2}{cmdab:ieboilsave} {hline 2} Checks that a dataset follows DECIE
	standards for a data set, and tags the dataset with metadata.

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Ieboilsave":DIME Wiki}.

{title:Syntax}

{phang2}
{cmdab:ieboilsave}
, {cmdab:idvar:name(}{it:varname}{cmd:)} [{cmdab:diout:put} {cmdab:missingok}
{cmdab:tagnoname} {cmdab:tagnohost}]


{marker opts}{...}
{synoptset 18}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:idvar:name(}{it:varname}{cmd:)}}specifies the ID variable
	uniquely and fully identifying the data set{p_end}
{synopt :{cmdab:missingok}}regular missing values are allowed{p_end}
{synopt :{cmdab:diout:put}}display output summarizing results of tests made and meta data stored{p_end}
{synopt :{cmdab:tagnoname}}do not tag the data set with user name or the computer (host) name{p_end}
{synopt :{cmdab:tagnohost}}do not tag the data set with the computer (host) name{p_end}
{synoptline}

{title:Description}

{pstd}{cmdab:ieboilsave} standardizes the boilerplate (section of standardized
	code) used at DECIE before saving a dataset. This includes checking that
	the ID variable is uniquely and fully identifying the dataset. The test uses the
	command {help isid}, but provides a more useful output. Only one variable
	is allowed to be the ID variable, see more in {help ieboilsave##IDnotes:Notes on ID variables} below.

{pstd}The command also checks that no regular missing values are used. Missing values should
	be replaced with the extended missing values .a, .b, ... , .z where each
	extended missing value represents a reason for why the value is missing.

{pstd}The command also tags meta data to the data set with information useful to
	future users. The meta data is tagged to the data set using {cmdab:char}.
	Char stores meta data to the data set using an associative array,
	see {help char} for an explanation on how to access data stored with
	char. The charnames (which is the equivalence to key or index in associative
	arrays) is listed below. When applicable these values are taken from the
	system parameters stored in {cmdab:c()} (see {help creturn}), and the
	{cmdab:c()} parameters used by this command are listed below. When a data
	set already have these charnames, the old values are overwritten with the
	new ones.

{p2colset 5 24 26 2}
{p2col : Charname}Meta data associated with the charname{p_end}
{p2line}
{p2col :{cmdab:_dta[ie_idvar]}}stores the name of the ID variable that uniquely
	and fully identifies the data set.{p_end}
{p2col :{cmdab:_dta[ie_version]}}stores the Stata version used (not installed,
	see {help ieboilstart: ieboilstart} for more details) to create the data
	set. Retrieved from {cmdab:c(version)}.{p_end}
{p2col :{cmdab:_dta[ie_date]}}stores the date the file was saved. Copying files,
	sharing files over sync services or emails may change the time stamp shown
	in folder. Retrieved from {cmdab:c(current_date)}.{p_end}
{p2col :{cmdab:_dta[ie_name]}}stores user name chosen when installing the
	instance of Stata that was used when generating the file. Retrieved from
	{cmdab:c(username)}. Storing this meta data is optional.{p_end}
{p2col :{cmdab:_dta[ie_host]}}stores computer name chosen when installing the
	instance of the operative system that was used when generating the file.
	Retrieved from {cmdab:c(hostname)}. Storing this meta data is optional.{p_end}
{p2col :{cmdab:_dta[ie_boilsave]}}stores a short summary of the result of
	running {cmdab:ieboilsave}. See option {cmdab:dioutput} below for more details.{p_end}
{p2line}

{title:Options}

{phang}{cmdab:idvar:name(}{it:varname}{cmd:)} specifies the ID variable that is
	supposed to be fully and uniquely identifying the data set. This command
	uses the command {help isid:isid} but provides a more helpful output in case
	the ID variable has duplicates or missing values. Using multiple ID variables
	to uniquely identify a data set is not best practice, and only one variable
	is therefore allowed in {it:varname}. See {help ieboilsave##IDnotes:Notes on ID variables} below
	read a justification for why it is bad practice.{p_end}

{phang}{cmdab:diout:put} displays the same information stored in {cmdab:_dta[ie_boilsave]} in
	the output window in Stata. This information includes the results of the ID
	variable test, the missing values test and all the meta data stored
	with {cmdab:char}. Unless this option is specified, {cmdab:ieboilsave} runs silently as
	long as it does not cause any errors.{p_end}

{phang}{cmdab:missingok} allows the data set to have the standard missing values,
	see {help missing values}. Since changing regular missing values to extended
	missing values is time consuming it might not always be a good use of a
	Stata coder's time to do this for intermediary data sets. But since it should
	be done for all final datasets, the default is to not allow regular missing
	values.{p_end}

{phang}{cmdab:tagnoname} prevents the command from tagging the data set with metadata
	containing user name and computer (host) name. Username and computer name
	can be very useful when facing issues related to replicability. For privacy
	reasons this can be disabled, but best practice is to keep it enabled at
	least for all data sets that are not meant for public dissemination.{p_end}

{phang}{cmdab:tagnohost} is similar to {cmdab:tagnoname} but it only prevents the
	command from tagging the data set with metadata containing the computer name.
	Specifying {cmdab:tagnohost} is redundant if {cmdab:tagnoname} is already
	specified.{p_end}

{title:Examples}

{pstd} {hi:Example 1.}

{pmore}{inp:ieboilsave, idvarname(respondent_ID)}

{pmore}In the example above, the command checks that the variable {it:respondent_ID}
uniquely and fully identifies that data set, checks that there is no missing
values that are not among the extended missing values and saves meta data to the
data set using char.

{pstd} {hi:Example 2.}

{pmore}{inp:ieboilsave, idvarname(respondent_ID) dioutput}

{pmore}The only difference between example 1 and this example is that in this
	example the command outputs the information stored in _dta[ie_boilsave]. The
	output will look similar to this:

{pmore}. {inp:ieboilsave, idvarname(respondent_ID) dioutput}{p_end}

{phang2}. {res:ieboilsave ran successfully. The uniquely and fully identifying ID variable is hhid. This data set was created in Stata version 13.1, by user Kristoffer using computer Kristoffer-PC, on 27 Jan 2016. There are no regular missing values in this data set}

{pstd} {hi:Example 3.}

{pmore}{inp:ieboilsave, idvarname(respondent_ID)}{p_end}
{pmore}{inp:local localname : char _dta[ie_boilsave]}{p_end}
{pmore}{inp:di "`localname'"}{p_end}

{pmore}Example 3 would generate exactly the same output as example 2 (formatted
	slightly different) but this example shows how to display the information
	in char _dta[ie_boilsave] at any point after running the command. For
	example, if you receive new data set where _dta[ie_boilsave] is already
	specified, then the two last lines of code is how you easiest access that
	information in a readable way.

{marker IDnotes}{...}
{title:Notes on ID variables}

{pstd}The concept of {it:Unique and Fully Identifying IDs} (in short unique IDs) and
	{it:Unit of Observation} are two concepts that cannot be emphasized enough in
	data management best practices. The unit of observation is what each row
	represents in a data set, and the unique ID should be unique for each
	instance of the unit of observation. This is mostly the same unit as the
	respondent during data collection.

{pstd}For example, let's say the respondents during a data collection were farmers;
	then the dataset is downloaded from the servers with farmers as the unit of observation.
	However, let's say that the analysis was carried out at the plot level. The data
	set prepared for the plot-level regressions no longer has farmer as
	unit of observation, so it is plots and the dataset should be identified using
	plot IDs not farmer IDs. If farmer IDs are unique for each farmer, and plot
	IDs are unique among the plots for each farmer those two
	IDs combined uniquely identify the data set. While it is technically true, it is
	not good practice. Impact Evaluations run over many years and there is
	likely going to be several different people working with the data set, and
	the slightest confusion in ID variables can lead to large analysis
	mistakes. It can lead to data sets merged incorrectly, that can lead to
	duplicates and it can lead to several observations included multiple times
	in a regression therefore inflating N and underestimating the p-value, causing
	false positives.

{pstd}Best practice is to always create a single variable that uniquely and fully
	identifies every unit in the unit of observation before saving a data
	set. Common practice is to make this the first variable in a data set
	using {help order:order}. It is also best practice to always start by making
	sure you fully understand the unit of observation in datasets you get from
	someone else. After you think you know the unit of observation, make sure
	that you have a single variable that uniquely and fully identifies the
	unit of observation in the data set.

{pstd}These concepts are also central to modern database design. It is approached
	somewhat differently as databases mostly consists of more than one dataset,
	but the principles are the same. There are a lot of reading material online
	search for {it:primary keys} and {it:normalization} in database design resources.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Michell Dong{break}Paula Gonzales

{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit ieboilsave" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
