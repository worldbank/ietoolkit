{smcl}
{* 26 Dec 2016}{...}
{hline}
help for {hi:iedropone}
{hline}

{title:Title}

{phang2}{cmdab:iedropone} {hline 2} Same function as {help drop} but prevents that additional observation are unintentionally dropped

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
{synopt :{cmdab:mvar(}{it:varname}{cmd:)}}Variable for which multiple values should be dropped. Must be used together with {cmdab:mval()}.{p_end}
{synopt :{cmdab:mval(}{it:list of values}{cmd:)}}The list of values in {cmdab:mvar()} that should be dropped. Must be used together with {cmdab:mvar()}.{p_end}
{synopt :{cmd:zerook}}Allows that no observation is dropped.{p_end}
{synoptline}

{marker desc}
{title:Description}

{pstd}{cmdab:iedropone} has the identical purpose as {drop help} when dropping 
	observations. However, {cmdab:iedropone} safeguards that no additional 
	observations are unintentionally dropped, or that changes are made to that 
	data that observations that are suppoed to be dropped are no longer dropped. 
	
{pstd}{cmdab:iedropone} checks that no more or fewer observations than intended are 
	dropped. For example, in the case that one observation has been identified to
	be dropped, then we want to make sure that when re-running the do-file only 
	that observations is dropped even if more observations are added to that data 
	set or changed in any other way. 

{pstd}While the default is 1, {cmdab:iedropone} allows the user to set another number
	of observation that should exactly be dropped. It also alows for dropping an exact
	number of observations for multiple values in a variable.

{marker optslong}
{title:Options}

{phang}{cmdab:n:umobs(}{it:integer}{cmd:)}} this allows the user to set the 
	number of observation that should be dropped. The default is 1 but any 
	positive integer can be used. The command throws an error if any other number
	of observations are dropped.

{phang}{cmdab:mvar(}{it:varname}{cmd:)} indicates a variables where multiple 
	values should be dropped. It must be exactly one observation for each value that is dropped, unless {cmd:

{phang}{cmdab:mval(}{it:list of values}{cmd:)} 
	
{pmore}{cmd:zerook} allows that no observations are dropped. The default is that an error is thrown if no observations are dropped.

{title:Examples}

{pstd} {hi:Example 1.}

{pmore}{inp:iematch , grpdummy({it:tmt}) matchvar({it:p_hat})}

{pmore}In the example above, the observations with value 1 in {it:tmt} will be matched
	towards the nearest, in terms of {it:p_hat}, observations with value 0 in {it:tmt}.

{pstd} {hi:Example 2.}

{pmore}{inp:iematch if {it:baseline} == 1  , grpdummy({it:tmt}) matchvar({it:p_hat}) maxdiff(.001)}

{pmore}In the example above, the observations with value 1 in {it:tmt} will be matched
	towards the nearest, in terms of {it:p_hat}, observations with value 0 in {it:tmt} as
	long as the difference in {it:p_hat} is less than .001. Only observations that has the
	value 1 in variable {it:baseline} will be included in the match.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Mrijan Rimal{break}

{title:Author}

{phang}Kristoffer Bjarkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietools iematch" in the subject line to:{break}
		 kbjarkefur@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}
