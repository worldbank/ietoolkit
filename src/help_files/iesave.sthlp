{smcl}
{* 04 Apr 2023}{...}
{hline}
help for {hi:iesave}
{hline}

{title:Title}

{phang2}{cmdab:iesave} {hline 2} applies best practices before saving data,
with option to save meta data report about the data saved.

{title:Syntax}

{phang2}
{cmdab:iesave} {help filename},
{opth id:vars(varlist)} {opt dta:version(version_number)} [{opt replace}
{opt userinfo} {opt report(report_options)}]{p_end}

{marker opts}{...}
{synoptset 25}{...}
{synopthdr:Options}
{synoptline}
{synopthdr:Save options}
{synopt :{opth id:vars(varlist)}} The variable(s) that should identify the data set{p_end}
{synopt :{opt dta:version(stata_version)}} Specify which {inp:.dta} version to use when saving{p_end}
{synopt :{opt replace}} Replace the data file if it already exits{p_end}
{synopt :{opt userinfo}} Include user info in meta data{p_end}
{synopt :{opt report(report_options)}} Save a report with meta data about the data to disk. See below for opt{p_end}

{synopthdr:Report options}
{pstd}These options are only to be used inside {inp:report()}{p_end}
{synopt :{opt path("/path/to/report.md")}} Save the report using another name and location than the data file{p_end}
{synopt :{opt replace}} Replace report file if it already exists{p_end}
{synopt :{opt csv}} Create the report in csv format instead of markdown{p_end}
{synopt :{opt noalpha}} Order the variables in the report as in the data set and not alphabetically{p_end}

{synoptline}

{title:Description}

{pstd}The command {cmd:iesave} is an enhanced way of saving data sets to disk,
intended to be used instead of the built in command {help save}
when working with research data.
In addition to saving the data set to disk,
the command applies some best practices steps before saving it
and it compiles meta data about the data set and about each variable.
The meta data about the data set is always saved
in {help char} characteristics to the data file.
Both the data set and the variables meta data
can be exported in a separate file that can be tracked using Git.
When the data points in the data set changes,
then the variable meta data also changes.
Therefore, tracking this report in Git allows you to know
which changes to your code made changes to the data points.{p_end}

{pstd}Before saving the data {cmd:iesave} uses {help compress} to
minimize the storage space the files takes when saved to disk,
and it throws and error if {help isid} fails to confirm that the
ID variable(s) are uniquely and fully identifying the data.
This means testing that the ID variable(s) have no duplicated values and no missing values.{p_end}

{pstd}The command requires the user to explicitly set the {inp:.dta} version
that should be used when saving the data set.
This prevents that a team members with a more recent version of Stata
accidently saves the data in a file format that
team members with an older version of Stata cannot open.{p_end}

{pstd}The data set meta data contains information on the ID variable(s),
the number of observations, the number of variables, the datasignature,
the time and date the file was saved as well as
the .dta version the data set was last saved in using {cmd:iesave}.
If the option {opt userinfo} is used, then the data set meta data also
includes the username and the computer ID of the user that
most recently used {cmd:iesave} to save the data.{p_end}

{pstd}If the option {opt report} is used, then the same data set meta data
is also saved to a report in a separate file.
In addition to the meta data about the data set, in this report,
meta data on all variables are also included.
This meta data is descriptive statistics on the data in each variable.
The descriptive statistics is different depending on the variable
being a string, date, categorical or continuous variable.
It is often not feasible or desirable to track a .dta file on GitHub
so changes to the data set are usually not be tracked
together with changes in the code.
This is solved by this report, as the variable meta data will change
if the data changes (rare corner case exceptions may exist)
and this report is suitable to be tracked on Git.{p_end}

{title:Options}

{dlgtab:Save options:}

{phang}{opth id:vars(varlist)} is used to specify the variable(s) that
uniquely and fully should identify the observations in the data set.
This command is intended for research data where data
should always be properly identified.
The command will, before saving, throw an error if
the variables specified in this option have
missing values or duplicated values
(duplicated combinations of values if more than one ID variable).{p_end}

{phang}{opt dta:version(stata_version)} is used to specify which
{inp:.dta} version should be used when saving the data set.
This allows a team that works in different versions of Stata
to always save in the same {inp:.dta} format no matter
which Stata version any team member have installed on their computer.
This avoids the issue of a team member saving the data in a format that
another team member with an older version cannot read.
The recommendation is to set the highest version number allowed
in the oldest version of Stata any team member has installed.
Not every Stata version include a new {inp:.dta} version.
The only the {inp:.dta} versions used in this command is 12, 13 and 14.
If a Stata version higher than those versions
or a version in-between is specified,
then the highest {inp:.dta} version lower than
the specified version is used.
For example, if 13.1 is specified, then 13 will be used.{p_end}

{phang}{opt replace} overwrites the data file if it already exits.
If applicable and unless {opt reportpath()} is used,
this also applies to the report file.{p_end}

{phang}{opt userinfo} includes user information -
user name {inp:c(username)} and computer name {inp:c(hostname)} -
in the meta data.
By default, this information is omitted for privacy reasons.
This applies both to meta data saved to {inp:char} values and,
when applicable, meta data saved in the report.{p_end}

{phang}{opt report(report_options)} is used to create a report with meta data.
The default is to save the report in markdown format
in the same location as the data file
using the same name as the data file but with {inp:.md} as the file extension.
See below for {it:report_options} that can be used to
change any of the default behavior.
Either {opt report()} or {opt report} can be used
when keeping all default behavior.

{dlgtab:Report options}

{pstd}These options are only to be used inside {opt report()}{p_end}

{phang}{opt path("/path/to/report.md")} is used to
specify a different file location and file name than the default.
The file extension must be {inp:.md} or {inp:.csv}.
If this option is used then the replace option used for the data file
does not apply to the report file.

{phang}{opt replace} is used to replace the report file if it already exists.
This option only applies of the report option {opt path()} is used,
as otherwise the replace option for the {inp:.dta} file
also applies to the report file.

{phang}{opt csv} is used to specify that the report should be
created in CSV format instead of markdown.
This option is superseded and has no effect
if the option {opt path()} is also used.

{phang}{opt noalpha} is used to list the variables in the tables in the report
in the same order as the sort order of the data set.
The default is to sort the variables alphabetically.

{title:Examples}

{pstd}{bf:{ul:Example 1}}{p_end}

{pstd}This is the most basic usage of {cmd:iesave}.
Specified like this, it saves the data set
after it has checked that the variable {inp:make} is
uniquely and fully identifying the data and
have used {help compress} to make sure the data points are stored
in the most memory efficient format.{p_end}

{pstd}{inp:sysuse auto, clear}{break}
{inp:local myfolder {it:"/path/to/folder"}}{break}
{inp:iesave {it:"`myfolder'/data1.dta"}, replace ///}{break}
{space 2}{inp:idvars(make) dtaversion(15)}{p_end}

{pstd}{bf:{ul:Example 2}}{p_end}

{pstd}This example is similar to example 1, but it also saves a report
with the meta data about the data set and the variables
to {it:"`myfolder'/data2.md"}.{p_end}

{pstd}{inp:sysuse auto, clear}{break}
{inp:local myfolder {it:"/path/to/folder"}}{break}
{inp:iesave {it:"`myfolder'/data2.dta"}, replace  ///}{break}
{space 2}{inp:idvars(make) dtaversion(15) report}{p_end}

{pstd}{bf:{ul:Example 3}}{p_end}

{pstd}This example is similar to example 2, but it saves the report in csv format
and saves it in the custom location {it:"`myfolder'/reports/data-report.csv"}.{p_end}

{pstd}{inp:sysuse auto, clear}{break}
{inp:local myfolder {it:"/path/to/folder"}}{break}
{inp:iesave {it:"`myfolder'/data2.dta"}, replace  ///}{break}
{space 2}{inp:idvars(make) dtaversion(15) {space 15}///}{break}
{space 2}{inp:report(path({it:"`myfolder'/reports/data-report.csv")  replace})}{p_end}

{title:Author}

{phang}All commands in iefieldkit are developed by DIME Analytics at the World Bank's Development Impact Evaluations department.

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "iefieldkit iesave" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/iefieldkit":the GitHub repository of iefieldkit}.{p_end}
