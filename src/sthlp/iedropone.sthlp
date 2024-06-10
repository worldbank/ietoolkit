{smcl}
{* *! version 0.0 20240404}{...}
{hline}
{pstd}help file for {hi:iedropone}{p_end}
{hline}

{title:Title}

{phang}{bf:iedropone} - an extension of the command {inp:drop} with features preventing additional observations are unintentionally dropped. 
{p_end}

{phang}For a more descriptive discussion on the intended usage and work flow of this command please see the {browse "https://dimewiki.worldbank.org/Iedropone":DIME Wiki}.
{p_end}

{title:Syntax}

{phang}{bf:iedropone} [{bf:if}] , [ {bf:{ul:n}umobs}({it:integer}) {bf:mvar}({it:varname}) {bf:mval}({it:list of values}) {bf:zerook} ]
{p_end}

{synoptset 20}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:n}umobs}({it:integer})}Number of observations that is allowed to be dropped - default is 1{p_end}
{synopt: {bf:mvar}({it:varname})}Allows that no observation is dropped{p_end}
{synopt: {bf:mval}({it:list of values})}Variable for which multiple values should be dropped - must be used together with {inp:mval()}{p_end}
{synopt: {bf:zerook}}The list of values in {inp:mvar()} that should be dropped - must be used together with {inp:mvar()}{p_end}
{synoptline}

{title:Description}

{pstd}This commands might be easier to understand by following the examples below before reading the description or the explanations of the options.
{p_end}

{pstd}{inp:iedropone} has the same purpose as the Stata built-in command {inp:drop} when dropping observations. 
However, {inp:iedropone} safeguards that no additional observations are unintentionally dropped, 
or that changes are made to the data so that the observations that are supposed to be dropped are no longer dropped.
{p_end}

{pstd}{inp:iedropone} checks that no more or fewer observations than intended are dropped. 
For example, in the case that one observation has been identified to be dropped,
then we want to make sure that when re-running the do-file no other observations are dropped
even if more observations are added to that data set or changed in any other way.
{p_end}

{pstd}While the default is 1,
{inp:iedropone} allows the user to set any another number of observation that should be dropped. 
If the number of observations that fit the drop condition is different,
then the command will throw an error.
{p_end}

{title:Options}

{pstd}{bf:{ul:n}umobs}({it:integer}) this allows the user to set the number of observation that should be dropped.
The default is 1 but any positive integer can be used.
The command throws an error if any other number of observations match the drop condition.
{p_end}

{pstd}{bf:mvar}({it:varname}) and {bf:mval}({it:list of values}) allows that multiple values in one variable are dropped.
These two options must be used together.  
If the variable in {inp:mvar()} is a string variable 
and some of the values in {inp:mval()} includes spaces, 
then the list of values in mval() must be listed exactly as in example 4 below.
The command loops over the values in {inp:mval()} 
and drops the observations that satisfy the if condition and each of the value in {inp:mval()}. 
For example:
{p_end}

{input}{space 8}iedropone if village == 100 , mvar(household_id) mval(21 22 23)
{text}
{pstd}is identical to:
{p_end}

{input}{space 8}iedropone if village == 100 & household_id == 21
{space 8}iedropone if village == 100 & household_id == 22
{space 8}iedropone if village == 100 & household_id == 23
{text}
{pstd}The default is that exactly one observation should be dropped for each value in {inp:mval()} 
unless {inp:numobs()} or {inp:zerook} is used. 
If those options are used then, then they apply to all values in {inp:mval()} separately. 
{p_end}

{pstd}{bf:mval}({it:list of values}) - see {bf:mvar}({it:varname}) above.
{p_end}

{pstd}{bf:zerook} allows that no observations are dropped.
The default is that an error is thrown if no observations are dropped.
{p_end}

{title:Stored results}

{title:Examples}

{dlgtab:Example 1.}

{pstd}Let{c 39}s say that we have identified the household with the ID 712047 to be incorrect and it should be dropped.
Identical to {inp:drop if household_id == 712047} but it will test that 
exactly one observation is dropped each time the do-file runs.
This guarantees that we will get an error message that
no observation is dropped if someone makes a change to the ID.
Otherwise we would unknowingly keep this incorrect observation in our data set.
{p_end}

{pstd}Similarly, if a new observation is added that is the correct household with ID 712047,
then both observation would be dropped without warning if we would have used {inp:drop if household_id == 712047}. 
{inp:iedropone} can be used as below to make sure that only that one observations is dropped. 
And if the data changes such that two observations are dropped,
then the command will throw and error.
{p_end}

{input}{space 8}iedropone if household_id == 712047
{text}
{dlgtab:Example 2.}

{pstd}Let{c 39}s say we have added a new household with the ID 712047.
In order to drop only one of those observations we must expand
the if-condition to indicate which one of them we want to drop.
{p_end}

{input}{space 8}iedropone if household_id == 712047 & household_head == "Bob Smith"
{text}
{dlgtab:Example 3.}

{pstd}Let{c 39}s say we added a new household with the ID 712047 but we want to drop exactly both of them,
then we can use the option {inp:numobs()}.   
The command will now throw an error if not exactly
two observations have the household ID 712047.
{p_end}

{input}{space 8}iedropone if household_id == 712047, numobs(2)
{text}
{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions and requests for clarifications
writing {c 34}ietoolkit iedropone{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {inp:ietoolkit}. 
{p_end}

{title:Author}

{pstd}All commands in {inp:ietoolkit} are developed by DIME Analytics at DIME, The World Bank{c 39}s department for Development Impact Evaluations. 
{p_end}

{pstd}Main authors: DIME Analytics, The World Bank Group
{p_end}
