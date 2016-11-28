{smcl}
{* }{...}
{hline}
help for {hi:iematch}
{hline}

{title:Title}

{phang2}{cmdab:iematch} {hline 2} Matching base observations towards target observations using on a single continous variable.

{title:Syntax}

{phang2}
{cmdab:iematch}
, {cmdab:grp:dummy(}{it:varname}{cmd:)} {cmdab:match:var(}{it:varname}{cmd:)} 
[{cmdab:id:var(}{it:varlist}{cmd:)} {cmdab:m1} {cmdab:maxdiff(}{it:numlist}{cmd:)} {cmdab:seed(}{it:numlist}{cmd:)}
{cmdab:matchid:name(}{it:string}{cmd:)} {cmdab:matchdi:ffname(}{it:string}{cmd:)}
{cmdab:matchre:sultname(}{it:string}{cmd:)} {cmdab:matchco:untname(}{it:string}{cmd:)}
]

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:grp:dummy(}{it:varname}{cmd:)}}The group dummy variable where 1 indicates base observations and 0 target observations{p_end}
{synopt :{cmdab:match:var(}{it:varname}{cmd:)}}The variable with a continous value to match on{p_end}
{synopt :{cmdab:id:var(}{it:varlist}{cmd:)}}The uniquely and fully identifying ID varaible. Used to indicate which target observation a base observation is match with. If omitted an ID variable will be created.{p_end}
{synopt :{cmdab:m1}}Allows many-to-one matches. The default is to allow only one-to-one matches{p_end}
{synopt :{cmdab:maxdiff(}{it:numlist}{cmd:)}}Set a maximum difference allowed in {cmdab:matchvar()}. If a base observation has no match within this difference then it will remain unmatched{p_end}
{synopt :{cmdab:seed(}{it:numlist}{cmd:)}}If seed is not set outside the command (recommended), then this option can be used to set the seed to make matches stable even when multiple observations have the same value in {cmdab:matchvar()}{p_end}
{synopt :{cmdab:matchid:name(}{it:string}{cmd:)}}Manually sets the name of the variable that indicates which target observation each base observation is matched with. The default is _matchID{p_end}
{synopt :{cmdab:matchdi:ffname(}{it:string}{cmd:)}}Manually sets the name of the variable that indicates the differnece in {cmdab:matchvar()} in each match pair/group. The default is _matchDiff{p_end}
{synopt :{cmdab:matchre:sultname(}{it:string}{cmd:)}}Manually sets the name of the variable that indicates if an observation was matched, or provide a reason why it was not. The default is _matchOrReason{p_end}
{synopt :{cmdab:matchco:untname(}{it:string}{cmd:)}}Manually sets the name of the variable that indicates how many observations a target obsersvation is matched with in a many-to-one matches. The default is _matchCount{p_end}
{synoptline}

{title:Description}

{pstd}{cmdab:iematch} matches base observations towards base observations in terms 
	of nearest value in {cmd:matchvar()}. Base observations are observations with
	value 1 in {cmd:grpdummy()} and target observations are observations with value 
	0. In a regular p-score match for example, base observations are treatment and target 
	is control, however, there are many other examples of mathcing where it could 
	be different.



. Observations with missing 
	values will be excluded frmo the matching. 

{pstd}The algorithm used in {cmdab:iematch} when performing a one-to-one match is 
	based on the Stable Marriage algorithm. The algorithm startes by evaluating which 
	observation from the other group in {cmd:grpdummy()} is closest in terms of the 
	variable in {cmd:matchvar()}. If two observations in differnt groups prefer each 
	other, then they are a match and they are removed from the data set. The process 
	is repeated until all observations with value 1 in group dummy are mathced. This 
	algorthm always has a solution and it is implemented to keep the matches stable 
	even when mutiple observations share value in {cmd:matchvar()}.
	
{pstd}When performing a many-to-one match the algorithm does the first step in the one-to-one algorithm, and assign all observations with value 1

{pstd}For example,

{title:Options}

{phang}{cmdab:grp:dummy(}{it:varname}{cmd:)}

{phang}{cmdab:match:var(}{it:varname}{cmd:)} 

{phang}{cmdab:id:var(}{it:varlist}{cmd:)} 

{phang}{cmdab:m1} 

{phang}{cmdab:maxdiff(}{it:numlist}{cmd:)}

{phang}{cmdab:seed(}{it:numlist}{cmd:)}

{phang}{cmdab:matchid:name(}{it:string}{cmd:)} The names _ID, _matchDiff, _matchOrReason and _matchCount are not allowed.

{phang}{cmdab:matchdi:ffname(}{it:string}{cmd:)} The names _ID, _matchID, _matchOrReason and _matchCount are not allowed.

{phang}{cmdab:matchre:sultname(}{it:string}{cmd:)} The names _ID, _matchID, _matchDiff and _matchCount are not allowed.

{phang}{cmdab:matchco:untname(}{it:string}{cmd:)} The names _ID, _matchID, _matchDiff and _matchOrReason are not allowed.



{title:Stored results}

{pstd}
{cmdab:iematch} stores the following results in {hi:r()}:



{title:Examples}

{pstd}
A series of examples on how to specify command, and how to evaluate output:

{pstd}{hi:Example 1.}


{pstd}{hi:Example 2.}

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}


{title:Author}

{phang}Kristoffer Bjärkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications 
		 writing "ietools iematch" in the subject line to:{break}
		 kbjarkefur@worldbank.org
		 
{phang}You can also see the code, make comments to the code, see the version 
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}


