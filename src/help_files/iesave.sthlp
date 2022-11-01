{smcl}
{* }{...}
{hline}
help for {hi:iesave}
{hline}

{title:Title}

{phang2}{cmdab:iesave} {hline 2} apply best practices before saving data,
and option to save meta data report about the data saved.

{title:Syntax}

{phang2}
{cmdab:iesave} {help using} {it: "/path/to/data.dta"},
{opth id:vars(varlist)} [{opt replace} {opt dtaversion(version_number)}
{opt userinfo} {opt report} {opt reportpath("/path/to/report.md", [replace])}
{opt noalpha}{p_end}

{marker opts}{...}
{synoptset 31}{...}
{synopthdr:Options}
{synoptline}
{synopthdr:Save options}
{synopt :{opth id:vars(varlist)}} The variable(s) that uniquely identified the data set.{p_end}
{synopt :{opt replace}} Replace data file if it already exits.{p_end}
{synopt :{opt dtaversion(number)}} Indicate witch {inp:.dta} version to use when saving.{p_end}
{synopt :{opt userinfo}} Include userinfo in meta data.{p_end}

{synopthdr:Report options}
{synopt :{opt report}} Create a report with meta data about the data.{p_end}
{synopt :{opt reportpath("/path/to/report.md")}} Save the report in another location than the data file.{p_end}
{synopt :{opt noalpha}} Order variables in the report as in data set and not alphabetically.{p_end}
{synoptline}

{title:Description}

{pstd}The command {cmd:iesave} is an anhanced way of saving data sets to disk,
and it is intended to be used in stead of the built in command {help save}.
In addition to saving the data set to disk,
the command applies some best practices steps before saving it
and it compiles meta data about the data set and about each variable.
The data set meta data is always saved in {help char} characteristics.
Both the data set and the variables meta data
can be exported in a file that can be tracked using Git.
Any time the data in the variables are changed the meta data on the variables are also changed.
Therefore, tracking this report in Git allows you to know
which changes to your code made changes to the data.{p_end}

{pstd}Before saving the data {cmd:iesave} use {help compress} to
minimize the storage space the files takes when saved to disk,
and it used {help isid} to make sure that the data set can only be saved if
the ID variable(s) are uniquely and fully identifying the data.
This means that the ID variable(s) have no duplicated values and no missing values.{p_end}

{pstd}There is also an option to set the {inp:.dta} version the data set will be saved in.
This way it can be avoided that team members with a more recent version of Stata
accidently saves the data in a file format that
team members with an older version of Stata cannot open.{p_end}

{pstd}The data set meta data contains information on the ID variable(s),
the number of observations, the number of variables, the datasignature,
the time and date the file was saved and
the .dta version the data set was last saved in using {cmd:iesave}.
If the option {opt userinfo} is used then the data set meta data also
includes the username and the computer ID of the user that saved the data.{p_end}

{pstd}The data set meta data is also saved to the report that is generated
if the option {opt report} is used. Additionally, in this report,
meta data on all variables are also included.
This meta data is descriptive statistics on the data in each variable.
The descriptive statistics is different depending on the variable being a
string, date, categorical or continuous variable.
It is often not feasible or desirable to track a .dta file on GitHub
so changes to the data set cannot be tracked.
This is solved by this report as the variable meta data will change
if the data changes (corner cases when this is not true exists)
and this report is suitable to be tracked on Git.{p_end}

{title:Options}

{dlgtab:Save options:}

{phang}{opth id:vars(varlist)} indicated the variable(s) that uniquely identified the data set.
This command is intended for research data where data should always be properly identified.
The command will throw an error if, when saving, the variables specified in this command has
missing values or duplicated values (duplicated combinations of values if more than one variable).{p_end}

{phang}{opt replace} replace data file if it already exits.
If applicable, this also applies to the report file unless {opt reportpath()} is used.{p_end}

{phang}{opt dtaversion(number)} Indicate which {inp:.dta} version that will be used when saving the data set.
This allows a team that works in different version of Stata to always save in the same format no matter
which Stata version any team member have installed on their computer.
This avoids the issue of a team member saving the data in a format another team member with an older version cannot read.
The recommendation is to set the highest version number allowed in the oldest version of Stata any team member has installed.
Not every Stata version comes with a new {inp:.dta} version so only the version numbers 12, 13 and 14.
If a Stata version higher than those versions or a version in-between is specified,
then the {inp:.dta} version lower then the specified version is used.{p_end}

{phang}{opt userinfo} By default, user information -
user name {inp:c(username)} and computer name {inp:c(hostname)} -
are not included in the meta data for privacy reasons.
This option includes that information in the meta data saved to {inp:char}
(and to the report when applicable).{p_end}

{dlgtab:Report options}

{phang}{opt report} Create a report with meta data about the data.
The default is to saved the report in Markdown format in the same location as the data file
using the same name as the data file but with .md as the file extension.

{phang}{opt reportpath("/path/to/report.md", [replace])} Allows specifying a different
file location and file name than the default. The file extension must be .md or .csv.
If this option is used then the replace option used for the data file does not apply to the report file.
If a file with the same name already exists in the location specified in this option,
then the option replace needs to be used in this option as well.

{phang}{opt noalpha} By default, the variables are sorted alphabetically in the report.
If this option is used, then the variables are sorted in the same order as in the data set.


{title:Examples}


{title:Author}

{phang}All commands in iefieldkit are developed by DIME Analytics at the World Bank's Development Impact Evaluations department.

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "iefieldkit iesave" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/iefieldkit":the GitHub repository of iefieldkit}.{p_end}
