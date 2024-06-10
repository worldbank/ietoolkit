{smcl}
{* *! version 0.0 20240404}{...}
{hline}
{pstd}help file for {hi:iematch}{p_end}
{hline}

{title:Title}

{phang}{bf:iematch} - Matching base observations towards target observations using on a single continous variable.
{p_end}

{phang}For a more descriptive discussion on the intended usage and work flow of this command please see the {browse "https://dimewiki.worldbank.org/Iematch":DIME Wiki}.
{p_end}

{title:Syntax}

{phang}{bf:iematch} [if] [in] , {bf:{ul:grp}dummy}({it:varname}) {bf:{ul:match}var}({it:varname}) [ {bf:{ul:id}var}({it:varname}) {bf:m1} {bf:maxdiff}({it:numlist}) {bf:maxmatch}({it:integer}) {bf:seedok} {bf:{ul:matchid}name}({it:string}) {bf:{ul:matchdi}ffname}({it:string}) {bf:{ul:matchre}sultname}({it:string}) {bf:{ul:matchco}untname}({it:string}) {bf:replace} ]
{p_end}

{synoptset 23}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:grp}dummy}({it:varname})}The group dummy variable where 1 indicates base observations and 0 target observations{p_end}
{synopt: {bf:{ul:match}var}({it:varname})}The variable with a continous value to match on{p_end}
{synopt: {bf:{ul:id}var}({it:varname})}The uniquely and fully identifying ID variable. Used to indicate which target observation a base observation is match with. If omitted an ID variable will be created. See below if you have multiple ID vars.{p_end}
{synopt: {bf:maxdiff}({it:numlist})}Set a maximum difference allowed in {bf:matchvar()}. If a base observation has no match within this difference then it will  remain unmatched{p_end}
{synopt: {bf:m1}}Allows many-to-one matches. The default is to allow only one-to-one matches. See the description section.{p_end}
{synopt: {bf:maxmatch}({it:integer})}Sets the maximum number of base observations that each target observation is allowed to match with in a {bf:m1} (many-to-one) match.{p_end}
{synopt: {bf:seedok}}Supresses the error message thrown when there are duplicates in {bf:matchvar()}. When there are duplicates, the seed needs to be set in order to have a replicable match. The {bf:seed} (see {inp:help set seed}) should be set before this command.{p_end}
{synopt: {bf:{ul:matchre}sultname}({it:string})}Manually sets the name of the variable that indicates if an observation was matched, or provide a reason why it was not. The  default is {it:matchResult{p_end}
{synopt: {bf:{ul:matchid}name}({it:string})}Manually sets the name of the variable that indicates which target observation each base observation is matched with. The default is {it:matchID{p_end}
{synopt: {bf:{ul:matchdi}ffname}({it:string})}Manually sets the name of the variable that indicates the differnece in {bf:matchvar()} in each match pair/group. The default is {it:matchDiff{p_end}
{synopt: {bf:{ul:matchco}untname}({it:string})}Manually sets the name of the variable that indicates how many observations a target observation is matched with in a many-to-one matches. The default is {it:matchCount{p_end}
{synopt: {bf:replace}}Replaces variables in memory if there are name conflicts when generating the output variables.{p_end}
{synoptline}

{title:Description}

{pstd}{bf:iematch} matches base observations towards target observations in terms of nearest value in {bf:matchvar()}. Base observations are observations with value 1 in {bf:grpdummy()} and target observations are observations with value 0. For example, in a typical p-score match, base observations are treatment and target is control, however, there are many other examples of matching where it could be different.
{p_end}

{pstd}{bf:iematch} bases its matching algorithm on the Stable Marriage algorithm.  This algorithm was chosen because it always provides a solution and allows stable matching even if multiple observations have identical match values (see {bf:seed()} option for more details). One disadvantage of this algorithm is that it takes into account local efficiency only, and not global efficiency. This means that it is possible that other matching algorithms might generate a more efficient match in terms of the sum of the difference of all matched pairs/groups.
{p_end}

{dlgtab:One-to-one matching algorithm}

{pstd}The algorithm used in a one-to-one match starts by evaluating which target observation each base observation is closest to and vice versa for each target observations. If a base and target observation pair mutually prefer each other, then these two observations are matched. The algorithm then repeats the initial two evaluation steps, and excludes observations after they are matched, until all base observations are either matched or excluded due to the option {bf:maxdiff()}. Matched observations ends up in pairs of exactly one base observation and one target observation.
{p_end}

{pstd}In a one-to-one match, there has to be at least as many target observations as there are base observations. A one-to-one match returns three variables. One variable indicates the result of the matching for each observation, such as, matched, not matched, no match within the max difference, etc. The other two variables hold information on the matched pair. One variable is the ID of the target observation in the matched pair, and the other variable is the difference in {bf:matchvar()} between the two observations in the match pair. See the below in this section for more details on the variables generated.
{p_end}

{dlgtab:Many-to-one matching algorithm}

{pstd}The algorithm used for many-to-one matching is the same as in a one-to-one match. But instead of matching only when there is a mutual preference, all base observations are matched towards their preferred target observation in the first step, as long as the match is within the max-value if {bf:maxdff()} is used. Matched observations end up in groups in which there is exactly one target observation but where there are either one or several base observations.
{p_end}

{pstd}In a many-to-one match, there is no restriction in terms of the number of base observations in relation to target observations. The many-to-one matching yields four variables. Three of the variables are the same as in one-to-one matching, and only the variable listing the difference The fourth variable indicates how many base observations that were matched towards each target observation. See the below in this section for more details on the variables generated.
{p_end}

{dlgtab:Variables generated}

{pstd}This section explains the variables that are generated by this command. All variables will be referred to by their default names, but those names can be manually set to something else (see the options for this command).
{p_end}

{pstd}{inp:_matchResult}: This variable indicates the result of the match for all observations. Observations that ended up in a match pair/group has the value 1. Target observations not matched have the value 0. Base observations without a valid match due to {bf:maxdff()} are assigned the value .d. Observations excluded from the match using if/in are assigned the value .i. Observations excluded from the match due to missing value in {bf:grpdummy()} are assigned the value .g. Observations excluded from the match due to missing value in {bf:matchvar()} are assigned the value .m. All values have descriptive value labels. 
{p_end}

{pstd}{inp:_matchID}: This variable indicates the ID of the target observations in each match pair/group. For matched target observations, the value in {it:matchID will be 
equal to the value in the ID variable. Since the values in the ID variable are unique and there is exactly one target observation in each matched
pair/group, this variable functions as a unique pair/group ID.  In addition to indicating which observations are included in the same pair/group,
this variable can be used to include a pair/group fixed effect in a regression.
{p_end}

{pstd}{inp:_matchDiff}: This variable indicates the difference in {bf:matchvar()} between matched base observations and target observations. In a one-to-one match this value is the identical for both the base observation and the target observation in each matched pair.  In a many-to-one match, this value is only indicated for base observations. It is missing for target observations as there are potentially multiple matches, and subsequently multiple differences. 
{p_end}

{pstd}{inp:_matchCount}: In a many-to-one match, this variable indicates how many base observations were matched towards each matched target observation. This variable can be used as regression weights when controlling for the fact that some observations are matched towards multiple observations. 
{p_end}

{title:Options}

{pstd}{bf:{ul:grp}dummy}({it:varname}) is used for xyz. Longer description (paragraph length) of all options, their intended use case and best practices related to them.
{p_end}

{pstd}{bf:{ul:matc}hvar}({it:varname}) is the variable used to compare observations when matching. This must be a numeric variable, and it is typically a continuous variable. Observations with a missing value will be excluded from the matching.
{p_end}

{pstd}{bf:{ul:id}var}({it:varname}) indicates the variable that uniquely and fully identifies the data set. The values in this variable is the values that will be used in the variable that indicates which target observation each base observations matched against. If this option is omitted, a variable called {it:ID will be generated. The observation in the first row is given the value 1, the second row value 2 and so fourth.
{p_end}

{pstd}This command assumes only one ID variable as that is the best practice this command follows (see next paragraph for the exception of panel data sets). Here follows two suggested solutions if a data set this command will be used on has more than one ID variable. 1. Do not use the idvar() option and after the matching copy the multiple ID variables yourself. 2. Combine your ID variables into one ID variable. Here are two examples on how that can be done (the examples below work just as well when combining more than two ID variables to one.):
{p_end}

{input}{space 8}egen new_ID_var = group(old_ID_var1 old_ID_var2)
{space 8}
{space 8}gen  new_ID_var = old_ID_var1 + "_" + old_ID_var2    //Works only with string vars
{space 8}
{text}
{pstd}Panel data sets are one of the few cases where multiple ID variables is good practice. However, in the case of matching it is unlikely that it is correct to include multiple time rounds for the same observation. That would lead to some base observations being matched to one target observation in the first round, and one another in the second. In impact evaluations, matchings are almost exclusively done only on the baseline data.
{p_end}

{pstd}{bf:maxdiff}({it:numlist}) sets a maximum allowed difference between a base observation and a target observation for a match to be valid. Any base observation without a valid match within this difference will end up unmatched.
{p_end}

{pstd}{bf:m1} sets the match to a many-to-one match (see description).  This allows multiple base observations to be matched towards a single target observation. The default is the one-to-one match where a maximum one base observation is matched towards each target observation. This option allows the number of base observations to be larger than the number of target observations.
{p_end}

{pstd}{bf:maxmatch}({it:integer}) sets the maximum number of base observations a target observation is allowed to match with in a {bf:m1} (many-to-one) match. The integer in {bf:maxmatch()} is the maximum number of base observations in group but there is also a always a target observation in the group, so in a maxed out match group it will be {bf:maxmatch()} plus one observations.
{p_end}

{pstd}{bf:seedok} supresses the error message thrown when there are duplicates among the base observations or the target observations in {bf:matchvar()}. When there are duplicates a random variable is used to distinguish which variable to match.  Setting the seed makes this randomization replicable and thereby making the matching also replicable. The seed (see {inp:help set seed}) should be set before this command by the user. When the seed is set, or if replicable matching is not important, then the option {bf:seedok} can be used to suppress the error message. Duplicate pairs where one observation is a base observation and the other is a target observations are allowed. 
{p_end}

{pstd}{bf:{ul:matchre}sultname}({it:string}) manually sets the name of the variable that reports the matching result for each observation.  If omitted, the default name is {inp:_matchResult}. The names {inp:_ID}, {inp:_matchID}, {inp:_matchDiff} and {inp:_matchCount} are not allowed. 
{p_end}

{pstd}{bf:{ul:matchid}name}({it:string}) manually sets the name of the variable that list the ID of the target observations in each match pair/group.  If omitted, the default name is {inp:_matchID}. The names {inp:_ID}, {inp:_matchDiff}, {inp:_matchResult} and {inp:_matchCount} are not allowed. 
{p_end}

{pstd}{bf:{ul:matchdi}ffname}({it:string}) manually sets the name of the variable that indicates the difference between the matched base observations and target observations. If omitted, the default name is {inp:_matchDiff}. The names {inp:_ID}, {inp:_matchID}, {inp:_matchResult} and {inp:_matchCount} are not allowed. 
{p_end}

{pstd}{bf:{ul:matchco}untname}({it:string}) manually sets the name of the variable that indicates the number of base observations that has been matched towards each matched matched target observation. This option may only be used in combination with option m1. If omitted, the default name is {inp:_matchCount}. The  names {inp:_ID}, {inp:_matchID}, {inp:_matchDiff} and {inp:_matchResult} are not allowed. 
{p_end}

{pstd}{bf:replace} allows {bf:iematch} to replace variables in memory when encountering name conflicts while creating the variables with the results of the matching.
{p_end}

{title:Examples}

{dlgtab:Example 1}

{input}{space 8}iematch , grpdummy(tmt) matchvar(p_hat)
{text}
{pstd}In the example above, the observations with value 1 in tmt will be matched towards the nearest, in terms of p{it:hat, observations with value 0 in tmt.
{p_end}

{dlgtab:Example 2}

{input}{space 8} iematch if baseline == 1 , grpdummy(tmt) matchvar(p_hat) maxdiff(.001)
{text}
{pstd}In the example above, the observations with value 1 in tmt will be matched towards the nearest, in terms of p{it:hat, observations with value 0 in tmt as long as the difference in p_hat is less than .001. Only observations that has the value 1 in variable baseline will be included in the match.
{p_end}

{dlgtab:Example 3}

{input}{space 8} iematch , grpdummy(tmt) m1 maxmatch(5) matchvar(p_hat) maxdiff(.001)
{text}
{pstd}In the example above, the observations with value 1 in tmt will be matched towards the nearest, in terms of p{it:hat, observations with value 0 in tmt as long as the difference in p_hat is less than .001. So far this example is identical to example 2. However, in this example each target observation is allowed to match with up to 5 base observations. Hence, instead of a result with only pairs of exactly one target observation and one base observation in each pair, the result is instead match groups with one target observation and up to 5 base observations. If {bf:maxmatch()} is omitted any number of base observations may match with each target observation.
{p_end}

{title:Acknowledgements}

{pstd}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):
{p_end}

{pstd}Luiza Cardoso De Andrade
{p_end}

{pstd}Seungmin Lee
{p_end}

{pstd}Mrijan Rimal
{p_end}

{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions and requests for clarifications writing {c 34}ietoolkit iematch{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {inp:ietoolkit}. 
{p_end}

{title:Authors}

{pstd}All commands in ietoolkit is developed by DIME Analytics at DIME, The World Bank{c 39}s unit for Development Impact Evaluations.
{p_end}

{pstd}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group
{p_end}
