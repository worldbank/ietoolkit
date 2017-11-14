{smcl}
{* 14 Nov 2017}{...}
{hline}
help for {hi:iecompdup}
{hline}

{title:Title}

{phang2}{cmdab:iecompdup} {hline 2} Compares two duplicates and generate a list
of the variables where the duplicates are identical and a list of the variables where the 
duplicates differ

{title:Syntax}

{phang2}
{cmdab:iecompdup}
{it:idvariable}
, {cmdab:id(}{it:string}{cmd:)} [{cmdab:didi:fference} {cmdab:keepdiff:erence} 
{cmdab:keepoth:er(}{it:varlist}{cmd:)} {cmdab:more2ok}]

{marker opts}{...}
{synoptset 28}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:id(}{it:string}{cmd:)}}value in the ID variables that is duplicated{p_end}
{synopt :{cmdab:didi:fference}}outputs the list with the variables for which the two observation differs. The default is to only store them in a local{p_end}
{synopt :{cmdab:keepdiff:erence}}drops all but the variables for which the two observations differ{p_end}
{synopt :{cmdab:keepoth:er(}{it:varlist}{cmd:)}}used together with {cmdab:keepdifference}. Variables included in {it:varlist} are also kept{p_end}
{synopt :{cmdab:more2ok}}allows running the command on groups of more than two observations, although only the first two duplicates (in the order the data is sorted) are compared{p_end}
{synoptline}

{title:Description}

{pstd}{cmdab:iecompdup} compare all variables for observations that are duplicates in 
ID variable {it:varname} and the duplicated value is {cmdab:id(}{it:string}{cmd:)}. Duplicates can 
be identified and corrected with its sister command {help ieduplicates}. {cmdab:iecompdup} 
is intended to assist in the process of investigating why two observations are duplicates in 
the ID variable, and what correction is appropriate. 

{pstd}{cmdab:iecompdup} returns two locals {cmd:r(matchvars)} and {cmd:r(diffvars)}. {cmd:r(matchvars)} returns 
a list of the names of all variables for which the two observations 
have identical values, unless both values are missing values or the empty
string. {cmd:r(diffvars)} returns a list of the names 
of all variables where the two observations are not identical. 

{pstd}For example, if a duplicate is found in a dataset downloaded from a data 
collection server (ODK or similar) and the duplicates were due to redundant submissions 
of the same data, then {cmd:r(diffvars)} would only include the submission time 
variable and any unique key used by the server. In such case, one observation can be 
dropped without risking losing information, since it is an identical submission of 
the exact same observation. (See Examples section below for a more detailed suggestion
on how to use the command. )

{title:Options}

{phang}{cmdab:id(}{it:string}{cmd:)} is used to specify the ID value that the 
duplicates share. Both text strings and numeric values are allowed.

{phang}{cmdab:didi:fference} is used to display the list of all variables for which 
the ID variable duplicates differ. The default is to provide this list in a local, and only 
display the number of variables that differ.

{phang}{cmdab:keepdiff:erence} is used to return the data set with only the ID 
variable and variables that differs between the duplicates. This means that the 
command would drop all variables where the duplicates are identical or both 
missing. It also drops all observations but the two duplicates compared.

{phang}{cmdab:keepoth:er(}{it:varlist}{cmd:)} is used to keep more variables than the variables 
that differs between the duplicates when {cmdab:keepdifference} is specified. The command can keep,
for example, a variable with information about who collected these data. This 
option returns an error if it is specified not in conjunction with {cmdab:keepdifference}.

{phang}{cmdab:more2ok} allows running the command on groups of more than two observations, 
although only the first two duplicates (in the order the data is sorted) are compared. In a group of three duplicates, 
run the command three times on each combination of the three duplicates. A future update that 
includes the possibility to compare more than one case is under consideration{p_end}

{title:Stored results}

{pstd}
{cmdab:iecompdup} stores the following results in {hi:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Locals}{p_end}
{synopt:{cmd:r(matchvars)}}a list of the variables where the duplicates has the same value{p_end}
{synopt:{cmd:r(diffvars)}}a list of the variables where the duplicates has different values{p_end}

{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(nummatch)}}The number of variables in {cmd:r(matchvars)}{p_end}
{synopt:{cmd:r(numdiff)}}The number of variables in {cmd:r(matchvars)}{p_end}
{synopt:{cmd:r(numnomiss)}}The number of variables for which at least one of 
the duplicates has a non-missing value. By definition, {cmd:r(numnomiss)} equals
 the sum of {cmd:r(nummatch)} and {cmd:r(numdiff)}{p_end}
{p2colreset}{...}

{title:Examples}

{pstd}
A series of examples on how to specify command, and how to evaluate output:

{pstd}{hi:Example 1.}

{phang2}{inp:iecompdup HH_ID , id(55424) didifference}{p_end}

{pmore}In the example above, let's say that there are two observations in the data set with the value 55424 
for variable HH_ID. HH_ID holds an ID that was uniquely assigned to each household. Before continuing the analysis, one must 
investigate why two observations were assigned the same ID. iecompdup is a great place to start.

{pmore}Specifying the command as above compares the two observations that both 
have value 55424 in the ID variable. The output displayed will 
only be number of non-missing variables for which the two observations have identical 
values, and the number of non-missing variables for which the two observations 
have different values. The list of those two sets of variables are stored as locals. 
The data set is returned exactly as it was.

{pmore}The locals stored in {cmd:r(diffvars)} and {cmd:r(nummatch)} can be used 
to provide information on why the two observations are duplicates. A suggested 
method to evaluate these two lists are presented in Example 2 below.

{pstd}{hi:Example 2.}

{phang2}{inp:iecompdup HH_ID , id(55424) didifference}{p_end}

{pmore}This example makes the same assumptions as example 1 that there are two 
observations in the data set with the value 55424 for variable HH_ID. The only 
difference is that the option didifference is specified. The output is the same 
as example 1 but with the addition that the list stored in {cmd:r(diffvars)} is 
displayed in the output window. The data set is returned exactly as it was.

{pmore}The method to evaluate the output presented in this example focus on the 
variables for which the duplicates are different. Therefore, start by looking at 
the list of variables displayed by {inp:didifference}. Do the variables with different values across the duplicates
contain observation data like "number of household members" or "annual income", or are they
submission information such as "submission ID", "server key" or "submission time"? 
The answer to this question could suggest one of the three solutions below. Note 
that this method should only be used as a guiding rule of thumb, all suggested 
solutions should be evaluated qualitatively as well.

{pmore}{ul:Solution 1. All variables contain submission information data.} The 
far most common mistake leading to duplicates in household surveys is that the same 
observation data is submitted to the server twice. If that is the case, then only submission 
information variables would be outputted by the command, not any observation data. 
If this is the case, then you can safely delete either of the observations.
 
{pmore}{ul:Solution 2. Most variables contain submission information data, but a few contain observation data.} If a 
few observation data variables are displayed together with submission information 
variables then it is likely that it is the same observation but some variables 
were edited after the first submission. Follow up with your field team to see 
why some variables were changed. See the tips in example 3 below before following up.

{pmore}{ul:Solution 3. Many variables contain observation data.} If many 
observation data variables are displayed together with submission data variables, 
then it is likely that two different observations have accidently been given the
same ID. That is especially likely if location variables or name variables are 
different, or if the values for enumerator and/or supervisor are different. See the 
tips in example 3 below before following up.

{pmore}The cases listed above will solve the vast majority of duplicates encountered in
household surveys. The appropriate correction can afterwards be applied using the command {help ieduplicates}.

{pstd}{hi:Example 3.}

{phang2}{inp:iecompdup HH_ID , id(55424) didifference keepdifference keepother(village enumerator supervisor)}{p_end}

{pmore}This example again makes the same assumptions as example 1 and example 2 that there are two 
observations in the data set with the value 55424 for variable HH_ID. This 
time {inp:keepdifference} and {inp:keepother()} are specified. Those two options 
can be used to provide additional information to the field team when following up 
based on solution 2 and solution 3 in example 2. {inp:keepdifference} drops all 
variables apart from the ID variable and the variables in {cmd:r(diffvars)}. Any 
variables in {inp:keepother()} are also kept. All observations apart from the 
duplicates with the ID specified in {inp:id()} are also dropped. This data can be 
exported to excel and sent to a field team that can see how the observations differ. 
In this example the field team can also see in which village the data was collected, 
as well as the name of the enumerator and the supervisor. Any other information 
helpful to the field team can be entered in {inp:keepother()}.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Michell Dong{break}Carlos Goes{break}Paula Gonzales

{title:Author}

{phang}Kristoffer Bjärkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications 
		 writing "ietools iecompdup" in the subject line to:{break}
		 kbjarkefur@worldbank.org
		 
{phang}You can also see the code, make comments to the code, see the version 
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}


