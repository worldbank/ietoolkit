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
	0. For example, in a typical p-score match, base observations are treatment and target is control, however, there are many other examples of matching where it could
	be different.

{pstd}{cmdab:iematch} base its matching on algorithm on the Stable Marriage algorithm. This algorithm was chosen because it always a solution and because it was possible to implement a stable matching even if multiple observations has identical match values (see {cmd:seed()} option for more details). One disadvantage is of this algorithm is that it only take local efficiency into account and not global. This means that it is possible that other matching algorithms might generate a more efficient match in terms of the sum of the difference of all matched pairs.

{pstd}{hi:{ul:One-to-one matching algorithm}}{p_end}
{pstd}The algorithm used in a one-to-one match starts by evaluating which
	target observation each base observation is closest to and vice versa for target observations. If a base and a target observation pair mutually prefer each other, then those two observations are a match. The algorithm then repeats these two steps but excludes observations after they are matched until all base observations are either matched or excluded due to the option {cmdab:maxdiff()}.

{pstd}In a one-to-one match there have to be at least as many target observations as there are base observation. A one-to-one match returns three variables. One variable indicates the result of the matching for each observation. For example, matched, not matched, no match within the max difference etc. The other two variables hold info on the matched pair. One variable is the ID of the target observation in the match pair, and the other variable is the difference in {cmd:matchvar()} between the two observation in the match pair. See the {help iematch##rtrnvrs:options} for more details.

{pstd}{hi:{ul:Many-to-one matching algorithm}}{p_end}
{pstd}The algorithm used here is the same as in a one-to-one match. But instead of matching only when there is mutual preference, all base observations are matched towards their preferred target observation in the first step, as long as the match is within the max-value if {cmdab:maxdiff()} is used.

{pstd}In a many-to-one match there is no restriction in terms of the number of target observations in relation to base observations. The many-to-one matching results in four variables. Three of the variables are the same as in a one-to-one match. The fourth variable indicates how many base observations that were matched towards each target observation. See the {help iematch##rtrnvrs:options} for more details.

{title:Options}

{phang}{cmdab:grp:dummy(}{it:varname}{cmd:)} 

{phang}{cmdab:match:var(}{it:varname}{cmd:)}

{phang}{cmdab:id:var(}{it:varlist}{cmd:)}

{phang}{cmdab:m1}

{phang}{cmdab:maxdiff(}{it:numlist}{cmd:)}

{phang}{cmdab:seed(}{it:numlist}{cmd:)}

{marker rtrnvrs}{...}
{phang}{cmdab:matchid:name(}{it:string}{cmd:)} The names {inp:_ID}, {inp:_matchDiff}, {inp:_matchOrReason} and {inp:_matchCount} are not allowed.

{phang}{cmdab:matchdi:ffname(}{it:string}{cmd:)} The names {inp:_ID}, {inp:_matchID}, {inp:_matchOrReason} and {inp:_matchCount} are not allowed.

{phang}{cmdab:matchre:sultname(}{it:string}{cmd:)} The names {inp:_ID}, {inp:_matchID}, {inp:_matchDiff} and {inp:_matchCount} are not allowed.

{phang}{cmdab:matchco:untname(}{it:string}{cmd:)} The names {inp:_ID}, {inp:_matchID}, {inp:_matchDiff} and {inp:_matchOrReason} are not allowed.



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

{phang}Kristoffer Bj�rkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietools iematch" in the subject line to:{break}
		 kbjarkefur@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}
