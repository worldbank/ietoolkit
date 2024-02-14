{smcl}
{* 01 Feb 2024}{...}
{hline}
help for {hi:iedropone}
{hline}

{title:Title}

{phang2}{cmdab:iedropone} {hline 2} Same function as {help drop} but prevents
	that additional observations are unintentionally dropped.

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Iedropone":DIME Wiki}.

{title:Syntax}

{phang2}
{cmdab:iedropone} [if] , {cmdab:n:umobs(}{it:integer}{cmd:)}
	{cmdab:mvar(}{it:varname}{cmd:)} {cmdab:mval(}{it:list of values}{cmd:)}
	{cmd:zerook}]

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:n:umobs(}{it:integer}{cmd:)}}Number of observations that is allowed to be dropped. Default is 1.{p_end}
{synopt :{cmd:zerook}}Allows that no observation is dropped.{p_end}
{synopt :{cmdab:mvar(}{it:varname}{cmd:)}}Variable for which multiple values should be dropped. Must be used together with {cmdab:mval()}.{p_end}
{synopt :{cmdab:mval(}{it:list of values}{cmd:)}}The list of values in {cmdab:mvar()} that should be dropped. Must be used together with {cmdab:mvar()}.{p_end}
{synoptline}

{marker desc}
{title:Description}

{pstd}This commands might be easier to understand by following
	the {help iedropone##examples:examples below} before reading the
	description or the explanations of the options.

{pstd}{cmdab:iedropone} has the same purpose as {help drop} when dropping
	observations. However, {cmdab:iedropone} safeguards that no additional
	observations are unintentionally dropped, or that changes are made to the
	data so that the observations that are supposed to be dropped are no longer dropped.

{pstd}{cmdab:iedropone} checks that no more or fewer observations than intended are
	dropped. For example, in the case that one observation has been identified to
	be dropped, then we want to make sure that when re-running the do-file
	no other observations are dropped even if more observations are added to that data
	set or changed in any other way.

{pstd}While the default is 1, {cmdab:iedropone} allows the user to set any another number
	of observation that should be dropped. If the number of observations that fit the
	drop condition is different, then the command will throw an error.

{marker optslong}
{title:Options}

{phang}{cmdab:n:umobs(}{it:integer}{cmd:)} this allows the user to set the
	number of observation that should be dropped. The default is 1 but any
	positive integer can be used. The command throws an error if any other number
	of observations match the drop condition.

{phang}{cmd:zerook} allows that no observations are dropped. The default is that
	an error is thrown if no observations are dropped.

{phang}{cmdab:mvar(}{it:varname}{cmd:)} and {cmdab:mval(}{it:list of values}{cmd:)} allows
	that multiple values in one variable are dropped. These two options must be used together.
	If the variable in {cmd:mvar()} is a string variable and some of the values in {cmd:mval()}
	includes spaces, then the list of values in {cmd:mval()} must be listed exactly as in example 4 below. The
	command loops over the values in {cmd:mval()} and drops the observations that
	satisfy the {it:if} condition and each of the value in {cmd:mval()}. For example:{p_end}

{pmore}{inp:iedropone if village == 100 , mvar(household_id) mval(21 22 23)}

{pmore}is identical to:

{pmore}{inp:iedropone if village == 100 & household_id == 21}{break}{inp:iedropone if village == 100 & household_id == 22}{break}{inp:iedropone if village == 100 & household_id == 23}

{pmore}The default is that exactly one observation should be dropped for each
	value in {cmd:mval()} unless {cmd:numobs()} or {cmd:zerook} is used. If those
	options are used then, then they apply to all values in {cmd:mval()} separately.

{phang}{cmdab:mval(}{it:list of values}{cmd:)}, see {cmdab:mvar(}{it:varname}{cmd:)} above.

{marker examples}
{title:Examples}

{pstd} {hi:Example 1.}

{pmore}{inp:iedropone if household_id == 712047}

{pmore}Let's say that we have identified the household with the ID 712047 to be
	incorrect and it should be dropped. Identical to {inp:drop if household_id == 712047}
	but it will test that exactly one observation is dropped each time the do-file runs.
	This guarantees that we will get an error message that no observation is dropped
	if someone makes a change to the ID. Otherwise we would unknowingly keep this
	incorrect observation in our data set.

{pmore}Similarly, if a new observation is added that is the correct household with ID 712047,
	then both observation would be dropped without warning if we would have
	used {inp:drop if household_id == 712047}. {cmd:iedropone} will make sure that
	our drop condition are applied as intended even if the data set is changed.


{pstd} {hi:Example 2.}

{pmore}{inp:iedropone if household_id == 712047 & household_head == "Bob Smith"}

{pmore}Let's say we have added a new household with the ID 712047. In order to
	drop only one of those observations we must expand the if condition to
	indicate which one of them we want to drop.

{pstd} {hi:Example 3.}

{pmore}{inp:iedropone if household_id == 712047, numobs(2)}

{pmore}Let's say we added a new household  with the ID 712047 but we want to drop
	exactly both of them, then we can use the option {cmd:numobs()} like above.
	The command will now throw an error if not exactly two observations have the
	household ID 712047.

{pstd} {hi:Example 4.}

{pmore}{inp:iedropone if village == 100, mvar(household_head) mval(`" "Bob Smith" "Ann Davitt" "Blessing Johnson" "')}

{pmore}If the values in {cmd:mvar()} are strings with empty spaces then then each
	value have to be enclosed in double quotes and the full list needs to start
	with {inp:`"} and end with {inp:"'}.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I
	received in relation to this command and help file from (in alphabetic
	order):{p_end}
{pmore}Paula Gonzalez-Martinez{break}Seungmin Lee{break}Mrijan Rimal{break}

{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iedropone" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
