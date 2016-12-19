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
[{cmdab:id:var(}{it:varlist}{cmd:)} {cmdab:m1} {cmdab:maxdiff(}{it:numlist}{cmd:)} {cmd:seedok}
{cmdab:matchid:name(}{it:string}{cmd:)} {cmdab:matchdi:ffname(}{it:string}{cmd:)}
{cmdab:matchre:sultname(}{it:string}{cmd:)} {cmdab:matchco:untname(}{it:string}{cmd:)}
]

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:grp:dummy(}{it:varname}{cmd:)}}The group dummy variable where 1 
	indicates base observations and 0 target observations{p_end}
{synopt :{cmdab:match:var(}{it:varname}{cmd:)}}The variable with a continous value
	to match on{p_end}
{synopt :{cmdab:id:var(}{it:varlist}{cmd:)}}The uniquely and fully identifying ID 
	varaible. Used to indicate which target observation a base observation is match 
	with. If omitted an ID variable will be created.{p_end}
{synopt :{cmdab:m1}}Allows many-to-one matches. The default is to allow only 
	one-to-one matches. See the {help iematch##desc:description} section.{p_end}
{synopt :{cmdab:maxdiff(}{it:numlist}{cmd:)}}Set a maximum difference allowed in
	{cmdab:matchvar()}. If a base observation has no match within this difference 
 then it will remain unmatched{p_end}
{synopt :{cmd:seedok}}Supresses the error maessage thrown when there are duplicates 
	in {cmd:matchvar()}. When there are duplicates, the seed needs to be set in order 
	to have a replicable match. The {help seed} should be set before this command.{p_end}
{synopt :{cmdab:matchid:name(}{it:string}{cmd:)}}Manually sets the name of the 
	variable that indicates which target observation each base observation is 
	matched with. The default is _matchID{p_end}
{synopt :{cmdab:matchdi:ffname(}{it:string}{cmd:)}}Manually sets the name of the
	variable that indicates the differnece in {cmdab:matchvar()} in each match 
	pair/group. The default is _matchDiff{p_end}
{synopt :{cmdab:matchre:sultname(}{it:string}{cmd:)}}Manually sets the name of 
	the variable that indicates if an observation was matched, or provide a reason why
	it was not. The default is _matchOrReason{p_end}
{synopt :{cmdab:matchco:untname(}{it:string}{cmd:)}}Manually sets the name of the
	variable that indicates how many observations a target obsersvation is matched 
	with in a many-to-one matches. The default is _matchCount{p_end}
{synoptline}

{marker desc}
{title:Description}

{pstd}{cmdab:iematch} matches base observations towards target observations in terms
	of nearest value in {cmd:matchvar()}. Base observations are observations with
	value 1 in {cmd:grpdummy()} and target observations are observations with value
	0. For example, in a typical p-score match, base observations are treatment and 
	target is control, however, there are many other examples of matching where it could
	be different.

{pstd}{cmdab:iematch} base its matching algorithm on the Stable Marriage algorithm.
	This algorithm was chosen because it always a solution and because it was possible
	to implement a stable matching even if multiple observations has identical match 
	values (see {cmd:seed()} option for more details). One disadvantage is of this 
	algorithm is that it only take local efficiency into account and not global. This 
	means that it is possible that other matching algorithms might generate a more 
	efficient match in terms of the sum of the difference of all matched pairs/groups.

{pstd}{hi:{ul:One-to-one matching algorithm}}{break}
	The algorithm used in a one-to-one match starts by evaluating which
	target observation each base observation is closest to and vice versa for 
	target observations. If a base and a target observation pair mutually prefer 
	each other, then those two observations are a match. The algorithm then repeats
	these two steps but excludes observations after they are matched until all base 
	observations are either matched or excluded due to the option {cmdab:maxdiff()}. 
	Matched observations ends up in pairs of exactly one base observation and one 
	target observation.

{pstd}In a one-to-one match there have to be at least as many target observations 
	as there are base observation. A one-to-one match returns three variables. One 
	variable indicates the result of the matching for each observation. For example, 
	matched, not matched, no match within the max difference etc. The other two variables 
	hold info on the matched pair. One variable is the ID of the target observation 
	in the match pair, and the other variable is the difference in {cmd:matchvar()} 
	between the two observation in the match pair. See the below in this section 
	for more details on the variables generated.

{pstd}{hi:{ul:Many-to-one matching algorithm}}{break}
	The algorithm used here is the same as in a one-to-one match. But instead 
	of matching only when there is mutual preference, all base observations are 
	matched towards their preferred target observation in the first step, as long 
	as the match is within the max-value if {cmdab:maxdff()} is used. Matched observations 
	end up in groups in which there is exactly one target observation but where there are 
	either one or several base observations.

{pstd}In a many-to-one match there is no restriction in terms of the number of 
	target observations in relation to base observations. The many-to-one matching 
	results in four variables. Three of the variables are the same as in a one-to-one 
	match. The fourth variable indicates how many base observations that were matched 
	towards each target observation. See the below in this section for more details on
	the variables generated.

{pstd}{hi:{ul:Variables generated}}{break}	
	This section explains the variables that are generated by this command. All variables 
	will be referred to by their default names, but those names can be manually set to somthing 
	else using the corresponding options. 

{pstd}{hi:_matchID}{break}	
	This variable indicates the ID if the target observations in each match pair/group. For matched 
	target observations, the value in this variable will be the same value as in teh ID 
	variable. Since the values in the ID varaible are unique and there is exactly one target 
	observation in each matched pair/group, this variable function as a unique pair/group ID. 
	In addition to indicating which observations are included in the same pair/group, this 
	varaible can be used to include a pair/group fixed effect in a regression.

{pstd}{hi:_matchDiff}{break}	
	This variable indicates the difference in {cmd:matchvar()} between matched base observations 
	and target observations. In a one-to-one match this value is the identical for 
	both the base observation and the target observation in each matched pair. 
	In a many-to-one match, this value is only indicated for base observations. It is 
	missing for target observations as there are potentially multiple matches,. and 
	then there are not one single difference. 

{pstd}{hi:_matchOrReason}{break}	
	This variable indicates the result of the match for all observations. Observations 
	that ended up in a match pair or group has the value 1. Target observations 
	not matched has the value 0. Any base observation without a valid match due to {cmdab:maxdff()} are 
	assigned the value .n with a descriptive label. Any observations excluded from the match completely, 
	either by having a missing value in {cmd:grpdummy()} or by using {inp:if} or {inp:in} are 
	assigned the value .m and a descriptive label.

{pstd}{hi:_matchCount}{break}	
	In a many-to-one match, this variable indicates how many target observations were 
	matched towards each matched base observation. This variable can be used as regression 
	weights when controlling for the fact that some observations are matched towards multiple 
	observations.
	
{marker optslong}
{title:Options}

{phang}{cmdab:grp:dummy(}{it:varname}{cmd:)} indicates which variable is the group 
	dummy. This variable, must be numeric and is only allowed to have the values 1, 
	0 or missing. 1 indicates a base observation, 0 indicates a target observation, 
	and observations with a missing value will be excluded from the missing.

{phang}{cmdab:match:var(}{it:varname}{cmd:)} indicates the variable used in the 
	matching. This must be a numeric variable, and it is typically a continuous 
	variable. This variable must not be missing for any observations that has 
	either the value 1 or 0 in the group dummy variable.

{phang}{cmdab:id:var(}{it:varlist}{cmd:)} indicates the variable that uniquely 
	and fully identifies the data set. The values in this variable is the values 
	that will be used in the variable that indicates which target observation each
	base observations matched against. 

{phang}{cmdab:m1} set the match to a many-to-one match. This allows multiple base 
	observations to be matched towards a single target observation. The default is 
	a one-to-one match when each matched target observation only is mathced towards 
	a single base observation. This option allows the number of base observations 
	to be larger then the number of target observations. See {help iematch##desc:description} 
	section for more details.

{phang}{cmdab:maxdiff(}{it:numlist}{cmd:)} sets a maximum allowed difference between 
	a base observation and a target observation for a match to be valid. Any base 
	observation without a match within this difference will end up unmatched.

{phang}{cmd:seedok} supresses the error maessage thrown when there are duplicates among 
	the base observations or the target observations in {cmd:matchvar()}. When there 
	are duplicates a random variable is used to distinguish which variable to match. 
	Setting the seed makes this randomization replicable meaning that the matching 
	is replicable. The {help seed} should be set before this command by the user. When the 
	seed is set, or if replicable matching is not important, then the option {cmd:seedok} can
	be used to supress the error message. Duplicates between base observations and 
	target observations are allowed.

{phang}{cmdab:matchid:name(}{it:string}{cmd:)} allows the user to manually set the 
	name of the variable that indicates the target observations in each match pair/group.
	If omitted, the default name is {inp:_matchID}. The names {inp:_ID}, {inp:_matchDiff}, {inp:_matchOrReason} 
	and {inp:_matchCount} are not allowed.

{phang}{cmdab:matchdi:ffname(}{it:string}{cmd:)} allows the user to manually set 
	the name of the variable that indicates the difference between the matched base observations 
	and target observations. If omitted, the default name is {inp:_matchDiff}. The 
	names {inp:_ID}, {inp:_matchID}, {inp:_matchOrReason} and {inp:_matchCount} are 
	not allowed.

{phang}{cmdab:matchre:sultname(}{it:string}{cmd:)} allows the user to manually set the 
	name of the variable that indicates the result of the match for each observation. 
	If omitted, the default name is {inp:_matchOrReason}. The names {inp:_ID}, 
	{inp:_matchID}, {inp:_matchDiff} and {inp:_matchCount} are not allowed.

{phang}{cmdab:matchco:untname(}{it:string}{cmd:)} allows the user to manually set the 
	name of the variable that indicates the number of base observations that has 
	been matched towards each matched matcehd target observation. This option may 
	only be used in combination with option {cmd:m1}. If omitted, the default 
	name is {inp:_matchCount}. The names {inp:_ID}, {inp:_matchID}, {inp:_matchDiff} 
	and {inp:_matchOrReason} are not allowed.


{title:Author}

{phang}Kristoffer Bj�rkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietools iematch" in the subject line to:{break}
		 kbjarkefur@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}



