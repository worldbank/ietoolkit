{smcl}
{* 04 Apr 2023}{...}
{hline}
help for {hi:iematch}
{hline}

{title:Title}

{phang2}{cmdab:iematch} {hline 2} Matching base observations towards target observations using on a single continous variable.

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Iematch":DIME Wiki}.

{title:Syntax}

{phang2}
{cmdab:iematch} {ifin}
, {cmdab:grp:dummy(}{it:varname}{cmd:)} {cmdab:match:var(}{it:varname}{cmd:)}
[{cmdab:id:var(}{it:varname}{cmd:)} {cmdab:m1} {cmdab:maxdiff(}{it:numlist}{cmd:)} {cmd:seedok}
{cmdab:matchid:name(}{it:string}{cmd:)} {cmdab:matchdi:ffname(}{it:string}{cmd:)}
{cmdab:matchre:sultname(}{it:string}{cmd:)} {cmdab:matchco:untname(}{it:string}{cmd:)}
{cmdab:replace}]

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:grp:dummy(}{it:varname}{cmd:)}}The group dummy variable where 1
	indicates base observations and 0 target observations{p_end}
{synopt :{cmdab:match:var(}{it:varname}{cmd:)}}The variable with a continous value
	to match on{p_end}
{synopt :{cmdab:id:var(}{it:varname}{cmd:)}}The uniquely and fully identifying ID
	variable. Used to indicate which target observation a base observation is match
	with. If omitted an ID variable will be created. See below if you have multiple ID vars.{p_end}
{synopt :{cmdab:maxdiff(}{it:numlist}{cmd:)}}Set a maximum difference allowed in
	{cmdab:matchvar()}. If a base observation has no match within this difference
 then it will remain unmatched{p_end}
{synopt :{cmdab:m1}}Allows many-to-one matches. The default is to allow only
	one-to-one matches. See the {help iematch##desc:description} section.{p_end}
{synopt :{cmdab:maxmatch(}{it:integer}{cmd:)}}Sets the maximum number of base
	observations that each target observation is allowed to match with in a {cmd:m1}
	(many-to-one) match.{p_end}
{synopt :{cmd:seedok}}Supresses the error message thrown when there are duplicates
	in {cmd:matchvar()}. When there are duplicates, the seed needs to be set in order
	to have a replicable match. The {help seed} should be set before this command.{p_end}
{synopt :{cmdab:matchre:sultname(}{it:string}{cmd:)}}Manually sets the name of
	the variable that indicates if an observation was matched, or provide a reason why
	it was not. The default is _matchResult{p_end}
{synopt :{cmdab:matchid:name(}{it:string}{cmd:)}}Manually sets the name of the
	variable that indicates which target observation each base observation is
	matched with. The default is _matchID{p_end}
{synopt :{cmdab:matchdi:ffname(}{it:string}{cmd:)}}Manually sets the name of the
	variable that indicates the differnece in {cmdab:matchvar()} in each match
	pair/group. The default is _matchDiff{p_end}
{synopt :{cmdab:matchco:untname(}{it:string}{cmd:)}}Manually sets the name of the
	variable that indicates how many observations a target observation is matched
	with in a many-to-one matches. The default is _matchCount{p_end}
{synopt :{cmd:replace}}Replaces variables in memory if there are name conflicts
	when generating the output variables.{p_end}
{synoptline}

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

{pstd}{hi:{ul:One-to-one matching algorithm}}{break}
	The algorithm used in a one-to-one match starts by evaluating which
	target observation each base observation is closest to and vice versa for each
	target observations. If a base and target observation pair mutually prefer
	each other, then these two observations are matched. The algorithm then repeats
	the initial two evaluation steps, and excludes observations after they are matched,
	until all base observations are either matched or excluded due to the option {cmdab:maxdiff()}.
	Matched observations ends up in pairs of exactly one base observation and one
	target observation.

{pstd}In a one-to-one match, there has to be at least as many target observations
	as there are base observations. A one-to-one match returns three variables. One
	variable indicates the result of the matching for each observation, such as,
	matched, not matched, no match within the max difference, etc. The other two variables
	hold information on the matched pair. One variable is the ID of the target observation
	in the matched pair, and the other variable is the difference in {cmd:matchvar()}
	between the two observations in the match pair. See the below in this section
	for more details on the variables generated.

{pstd}{hi:{ul:Many-to-one matching algorithm}}{break}
	The algorithm used for many-to-one matching is the same as in a one-to-one match. But instead
	of matching only when there is a mutual preference, all base observations are
	matched towards their preferred target observation in the first step, as long
	as the match is within the max-value if {cmdab:maxdff()} is used. Matched observations
	end up in groups in which there is exactly one target observation but where there are
	either one or several base observations.

{pstd}In a many-to-one match, there is no restriction in terms of the number of
	base observations in relation to target observations. The many-to-one matching
	yields four variables. Three of the variables are the same as in one-to-one
	matching, and only the variable listing the difference  The fourth variable indicates how many base observations that were matched
	towards each target observation. See the below in this section for more details on
	the variables generated.

{pstd}{hi:{ul:Variables generated}}{break}
	This section explains the variables that are generated by this command. All variables
	will be referred to by their default names, but those names can be manually set to something
	else (see the options for this command).

{pstd}{hi:_matchResult}{break}
	This variable indicates the result of the match for all observations. Observations
	that ended up in a match pair/group has the value 1. Target observations not matched have the
	value 0. Base observations without a valid match due to {cmdab:maxdff()} are
	assigned the value .d. Observations excluded from the match using {inp:if}/{inp:in} are
	assigned the value .i. Observations excluded from the match due to missing value in {cmd:grpdummy()} are
	assigned the value .g. Observations excluded from the match due to missing value in {cmd:matchvar()} are
	assigned the value .m. All values have descriptive value labels.

{pstd}{hi:_matchID}{break}
	This variable indicates the ID of the target observations in each match pair/group. For matched
	target observations, the value in _matchID will be equal to the value in the ID
	variable. Since the values in the ID variable are unique and there is exactly one target
	observation in each matched pair/group, this variable functions as a unique pair/group ID.
	In addition to indicating which observations are included in the same pair/group, this
	variable can be used to include a pair/group fixed effect in a regression.

{pstd}{hi:_matchDiff}{break}
	This variable indicates the difference in {cmd:matchvar()} between matched base observations
	and target observations. In a one-to-one match this value is the identical for
	both the base observation and the target observation in each matched pair.
	In a many-to-one match, this value is only indicated for base observations. It is
	missing for target observations as there are potentially multiple matches, and
	subsequently multiple differences.

{pstd}{hi:_matchCount}{break}
	In a many-to-one match, this variable indicates how many base observations were
	matched towards each matched target observation. This variable can be used as regression
	weights when controlling for the fact that some observations are matched towards multiple
	observations.

{marker optslong}
{title:Options}

{phang}{cmdab:grp:dummy(}{it:varname}{cmd:)} is the dummy variable that indicates if an observation
	is a base or target observation. This variable, must be numeric and is only allowed to have
	the values 1, 0 or missing. 1 indicates a base observation, 0 indicates a target observation,
	and observations with a missing value will be excluded from the matching.

{phang}{cmdab:match:var(}{it:varname}{cmd:)} is the variable used to compare observations when
	matching. This must be a numeric variable, and it is typically a continuous
	variable. Observations with a missing value will be excluded from the matching.

{phang}{cmdab:id:var(}{it:varname}{cmd:)} indicates the variable that uniquely
	and fully identifies the data set. The values in this variable is the values
	that will be used in the variable that indicates which target observation each
	base observations matched against. If this option is omitted, a variable called
	_ID will be generated. The observation in the first row is given the value 1,
	the second row value 2 and so fourth.

{pmore}This command assumes only one ID variable as that is the best practice this command
	follows (see next paragraph for the exception of panel data sets). Here follows two
	suggested solutions if a data set this command will be used on has more than one ID
	variable. {bf:1.} Do not use the {cmd:idvar()} option and after the matching copy the multiple
	ID variables yourself. {bf:2.} Combine your ID variables into one ID variable. Here are two
	examples on how that can be done (the examples below work just as well when combining more
	than two ID variables to one.):

{pmore2}{inp:egen }{it:new_ID_var }{inp:= group(}{it:old_ID_var1 old_ID_var2}{inp:)}

{pmore2}{inp:gen}{space 2}{it:new_ID_var }{inp:= }{it:old_ID_var1 }{inp:+ "_" + }{it:old_ID_var2}{space 4}//Works only with string vars

{pmore}Panel data sets are one of the few cases where multiple ID variables is good practice. However,
	in the case of matching it is unlikely that it is correct to include multiple time rounds for
	the same observation. That would lead to some base observations being matched to
	one target observation in the first round, and one another in the second. In impact
	evaluations, matchings are almost exclusively done only on the baseline data.

{phang}{cmdab:maxdiff(}{it:numlist}{cmd:)} sets a maximum allowed difference between
	a base observation and a target observation for a match to be valid. Any base
	observation without a valid match within this difference will end up unmatched.

{phang}{cmdab:m1} sets the match to a many-to-one match (see {help iematch##desc:description}).
	This allows multiple base observations to be matched towards a single target observation.
	The default is the one-to-one match where a maximum one base observation is matched towards
	each target observation. This option allows the number of base observations
	to be larger than the number of target observations.

{phang}{cmdab:maxmatch(}{it:integer}{cmd:)} sets the maximum number of base observations a
	target observation is allowed to match with in a {cmd:m1} (many-to-one) match. The integer
	in {cmd:maxmatch()} is the maximum number of base observations in group but there is also a
	always a target observation in the group, so in a maxed out match group it will be {cmd:maxmatch()}
	plus one observations.

{phang}{cmd:seedok} supresses the error message thrown when there are duplicates among
	the base observations or the target observations in {cmd:matchvar()}. When there
	are duplicates a random variable is used to distinguish which variable to match.
	Setting the seed makes this randomization replicable and thereby making the matching
	also replicable. The {help seed} should be set before this command by the user. When the
	seed is set, or if replicable matching is not important, then the option {cmd:seedok} can
	be used to suppress the error message. Duplicate pairs where one observation is a base
	observation and the other is a target observations are allowed.

{phang}{cmdab:matchre:sultname(}{it:string}{cmd:)} manually sets the
	name of the variable that reports the matching result for each observation.
	If omitted, the default name is {inp:_matchResult}. The names {inp:_ID},
	{inp:_matchID}, {inp:_matchDiff} and {inp:_matchCount} are not allowed.

{phang}{cmdab:matchid:name(}{it:string}{cmd:)} manually sets the
	name of the variable that list the ID of the target observations in each match pair/group.
	If omitted, the default name is {inp:_matchID}. The names {inp:_ID}, {inp:_matchDiff}, {inp:_matchResult}
	and {inp:_matchCount} are not allowed.

{phang}{cmdab:matchdi:ffname(}{it:string}{cmd:)} manually sets the name of the variable
	that indicates the difference between the matched base observations
	and target observations. If omitted, the default name is {inp:_matchDiff}. The
	names {inp:_ID}, {inp:_matchID}, {inp:_matchResult} and {inp:_matchCount} are
	not allowed.

{phang}{cmdab:matchco:untname(}{it:string}{cmd:)} manually sets the
	name of the variable that indicates the number of base observations that has
	been matched towards each matched matched target observation. This option may
	only be used in combination with option {cmd:m1}. If omitted, the default
	name is {inp:_matchCount}. The names {inp:_ID}, {inp:_matchID}, {inp:_matchDiff}
	and {inp:_matchResult} are not allowed.

{phang}{cmdab:replace} allows {cmd:iematch} to replace variables in memory when
	encountering name conflicts while creating the variables with the results of the matching.

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

{pstd} {hi:Example 3.}

{pmore}{inp:iematch , grpdummy({it:tmt}) m1 maxmatch(5) matchvar({it:p_hat}) maxdiff(.001)}

{pmore}In the example above, the observations with value 1 in {it:tmt} will be matched
	towards the nearest, in terms of {it:p_hat}, observations with value 0 in {it:tmt} as
	long as the difference in {it:p_hat} is less than .001. So far this example is identical
	to example 2. However, in this example each target observation is allowed to match with up
	to 5 base observations. Hence, instead of a result with only pairs of exactly one target
	observation and one base observation in each pair, the result is instead match groups
	with one target observation and up to 5 base observations. If {cmd:maxmatch()} is omitted
	any number of base observations may match with each target observation.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Luiza Cardoso De Andrade{break}Seungmin Lee{break}Mrijan Rimal{break}


{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iematch" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
