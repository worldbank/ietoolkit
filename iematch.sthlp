{smcl}
{* }{...}
{hline}
help for {hi:iematch}
{hline}

{title:Title}

{phang2}{cmdab:iematch} {hline 2} Match observations in one group towards observations in another group based on a single continous variable.

{title:Syntax}

{phang2}
{cmdab:iematch}
, {cmdab:grp:dummy(}{it:varname}{cmd:)} {cmdab:match:var(}{it:varname}{cmd:)} 
[{cmdab:id:var(}{it:varlist}{cmd:)} {cmdab:m1} {cmdab:maxdiff(}{it:numlist}{cmd:)} {cmdab:seed(}{it:numlist}{cmd:)}
{cmdab:matchid:name(}{it:string}{cmd:)} {cmdab:matchdi:ffname(}{it:string}{cmd:)}
{cmdab:matchre:sultname(}{it:string}{cmd:)} {cmdab:matchco:untname(}{it:string}{cmd:)}
]

{marker opts}{...}
{synoptset 28}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:grp:dummy(}{it:varname}{cmd:)}}The group variable. Obs with 1 is mathced towards obs with 0{p_end}
{synopt :{cmdab:match:var(}{it:varname}{cmd:)}}The variable with a continous value to mathc on{p_end}
{synopt :{cmdab:id:var(}{it:varlist}{cmd:)}}The uniquely and fully identifying ID varaible. Used to indicate which observation is matched with which. If omitted an ID variable will be created.{p_end}
{synopt :{cmdab:m1}}Allows many-to-one matches. The default is to only allow one-to-one matches{p_end}
{synopt :{cmdab:maxdiff(}{it:numlist}{cmd:)}}Set a maximum difference allowed in {cmdab:matchvar()}. If not match exist within this difference then the observation will remain unmatched{p_end}
{synopt :{cmdab:maxdiff(}{it:numlist}{cmd:)}}If two observations have the same value in {cmdab:matchvar()}, then they will be orderd randomly. If seed is not set already, then provide a seed so that the randomziation is stable. {p_end}
{synopt :{cmdab:matchid:name(}{it:string}{cmd:)}}Manually set the name of the variable that indicates which other observation the observations are matched with. The default is _matchID{p_end}
{synopt :{cmdab:matchdi:ffname(}{it:string}{cmd:)}}Manually set the name of the variable that indicates the differnece in {cmdab:matchvar()} in the match. The default is _matchDiff{p_end}
{synopt :{cmdab:matchre:sultname(}{it:string}{cmd:)}}Manually set the name of the variable that indicates if an observation was matched, or provide a reason if it was not. The default is _matchOrReason{p_end}
{synopt :{cmdab:matchco:untname(}{it:string}{cmd:)}}Manually set the name of the variable that indicates how many observations an obsersvation is matched with in a many-to-one match. The default is _matchCount{p_end}
{synoptline}

{title:Description}

{pstd}{cmdab:iematch} matches observations with the value 1 in the variable in {cmd:grpdummy()} towards observations with value 0. Observations with missing values will be excluded frmo the matching. 

{pstd}{cmdab:iematch} uses the Stable Marriage algorithm when performing a one-to-one match. This algorthm always have a solution and is stable in terms of replication.

{pstd}For example,

{title:Options}

{phang}{cmdab:grp:dummy(}{it:varname}{cmd:)}

{phang}{cmdab:match:var(}{it:varname}{cmd:)} 

{phang}{cmdab:id:var(}{it:varlist}{cmd:)} 

{phang}{cmdab:m1} 

{phang}{cmdab:maxdiff(}{it:numlist}{cmd:)}

{phang}{cmdab:seed(}{it:numlist}{cmd:)}

{phang}{cmdab:matchid:name(}{it:string}{cmd:)}

{phang}{cmdab:matchdi:ffname(}{it:string}{cmd:)}

{phang}{cmdab:matchre:sultname(}{it:string}{cmd:)} 

{phang}{cmdab:matchco:untname(}{it:string}{cmd:)}



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


