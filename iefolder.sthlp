{smcl}
{* 26 Dec 2016}{...}
{hline}
help for {hi:iematch}
{hline}

{title:Title}

{phang2}{cmdab:iefolder} {hline 2} Sets up folders and master do-files according to World Bank DIME's standards.

{title:Syntax}

{phang2}
{cmd:iefolder} new {it:itemtype} , {cmdab:proj:ectfolder(}{it:directory}{cmd:)} 
	[{cmdab:abb:reviation(}{it:string}{cmd:)}] 
	
{pmore} Where {it:itemtype} is either {it:project}, {it:round}, {it:master} or 
	{it:unitofobs}. See details below.

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt : {cmdab:proj:ectfolder(}{it:dir}{cmd:)}}The location where 
	the {hi:DataWork} folder should be created (new projects), or 
	where it is located (existing projects). {p_end}
{synopt : {cmdab:abb:reviation(}{it:string}{cmd:)}}Optional abbreviation 
	of round name to be used to make globals shorter. {p_end}

{marker desc}
{title:Description}

{pstd}{cmdab:iematch} matches base observations towards target observations in terms
	of nearest value in {cmd:matchvar()}. Base observations are observations with
	value 1 in {cmd:grpdummy()} and target observations are observations with value
	0. For example, in a typical p-score match, base observations are treatment and
	target is control, however, there are many other examples of matching where it could
	be different.

{pstd}{cmdab:iematch} bases its matching algorithm on the Stable Marriage algorithm.
	This algorithm was chosen because it always provides a solution and allows stable
	matching even if multiple observations have identical match
	values (see {cmd:seed()} option for more details). One disadvantage of this
	algorithm is that it takes into account local efficiency only, and not global efficiency. This
	means that it is possible that other matching algorithms might generate a more
	efficient match in terms of the sum of the difference of all matched pairs/groups.

{marker optslong}
{title:Options}

{phang}{cmdab:proj:ectfolder(}{it:dir}{cmd:)} is 

{phang}{cmdab:abb:reviation(}{it:string}{cmd:)} is 

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
{pmore}Mrijan Rimal, Seungmin Lee, Laura Costica{break}

{title:Author}

{phang}Kristoffer Bjarkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iefolder" in the subject line to:{break}
		 kbjarkefur@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}
