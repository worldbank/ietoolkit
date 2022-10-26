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
{opth id:vars(varlist)} [{opt replace} {opt saveversion(version_number)}
{opt userinfo} {opt noalpha} {opt report("/path/to/report.md")}
{p_end}

{marker opts}{...}
{synoptset 27}{...}
{synopthdr:Options}
{synoptline}
{synopthdr:Save options}
{synopt :{opth id:vars(varlist)}} The variable(s) that uniquely identified the data set.{p_end}
{synopt :{opt replace}} Replace data file if it already exits.{p_end}
{synopt :{opt dtaversion(number)}} Indicate with {inp:.dta} version to use when saving.{p_end}
{synopt :{opt userinfo}} Include userinfo in meta data.{p_end}

{synopthdr:Report options}
{synopt :{opt report}} Create a report with meta data about the data.{p_end}
{synopt :{opt reportpath("/path/to/report.md")}} Save the report in another location than the data file.{p_end}
{synopt :{opt reportreplace}} Replace report file if it already exits.{p_end}
{synopt :{opt noalpha}} Order variables in the report as in data set and not alphabetically.{p_end}
{synoptline}

{title:Description}
The command {cmd:iesave} is an anhanced way of saving data sets to disk,
and it is intended to be used in stead of the built in command {help save}.
In addition to saving the data set to disk,
the command applies some best practices steps before saving it
and it compiles meta data about the data set and about each variable.
The data set meta data is always saved in {help char} characteristics.
Both the data set and the variables meta data
can be exported in a file that can be tracked using Git.
Any time the data in the variables are changed the meta data on the variables are also changed.
Therefore, tracking this report in Git allows you to know
which changes to your code made changes to the data.

Before saving the data {cmd:iesave} use {help compress} to
minimize the storage space the files takes when saved to disk,
and it used {help isid} to make sure that the data set can only be saved if
the ID variable(s) are uniquely and fully identifying the data.
This means that the ID variable(s) have no duplicated values and no missing values.

There is also an option to set the {inp:.dta} version the data set will be saved in.
This way it can be avoided that team members with a more recent version of Stata
accidently saves the data in a file format that
team members with an older version of Stata cannot open.

The data set meta data contains information on the ID variable(s),
the number of observations, the number of variables, the datasignature,
the time and date the file was saved and
the .dta version the data set was last saved in using {cmd:iesave}.
If the option {opt userinfo} is used then the data set meta data also
includes the username and the computer ID of the user that saved the data.

The data set meta data is also saved to the report that is generated
if the option {opt report} is used. Additionally, in this report,
meta data on all variables are also included.
This meta data is descriptive statistics on the data in each variable.
The descriptive statistics is different depending on the variable being a
string, date, categorical or continuous variable.
It is often not feasible or desirable to track a .dta file on GitHub
so changes to the data set cannot be tracked.
This is solved by this report as the variable meta data will change
if the data changes (corner cases when this is not true exists)
and this report is suitable to be tracked on Git.


{title:Examples}


{title:Author}

{phang}All commands in iefieldkit are developed by DIME Analytics at the World Bank's Development Impact Evaluations department.

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "iefieldkit iesave" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/iefieldkit":the GitHub repository of iefieldkit}.{p_end}
