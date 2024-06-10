{smcl}
{* *! version 7.3 20240404}{...}
{hline}
{pstd}help file for {hi:iesave}{p_end}
{hline}

{title:Title}

{phang}{bf:iesave} - applies best practices before saving data, with option to save meta data report about the data saved.
{p_end}

{title:Syntax}

{phang}{bf:iesave} filename, {bf:{ul:id}vars}({it:varlist}) {bf:{ul:v}ersion}({it:version_number}) [ {bf:replace} {bf:userinfo} {bf:report}({it:report_options}) ]
{p_end}

{dlgtab:Save options:}

{synoptset 23}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:id}vars}({it:varlist})}The variable(s) that should identify the data set{p_end}
{synopt: {bf:{ul:v}ersion}({it:version_number})}Specify which {bf:.dta} version to use when saving{p_end}
{synopt: {bf:replace}}Replace the data file if it already exits{p_end}
{synopt: {bf:userinfo}}Include user info in meta data{p_end}
{synopt: {bf:report}({it:report_options})}Save a report with meta data about the data to disk. See below for opt{p_end}
{synoptline}

{dlgtab:Report options:}

{phang}These options are only to be used inside {bf:report()}
{p_end}

{synoptset 26}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:path}({it:{c 34}/path/to/report.md{c 34}})}Save the report using another name and location than the data file{p_end}
{synopt: {bf:replace}}Replace report file if it already exists{p_end}
{synopt: {bf:csv}}Create the report in csv format instead of markdown{p_end}
{synopt: {bf:noalpha}}Order the variables in the report as in the data set and not alphabetically{p_end}
{synoptline}

{title:Description}

{pstd}The command {bf:iesave} is an enhanced way of saving data sets to disk, intended to be used instead of the built in command save (see {inp:help save}) when working with research data. In addition to saving the data set to disk, the command applies some best practices steps before saving it and it compiles meta data about the data set and about each variable. The meta data about the data set is always saved in char (see {inp:help char}) characteristics to the data file.Both the data set and the variables meta data can be exported in a separate file that can be tracked using Git. When the data points in the data set changes, then the variable meta data also changes. Therefore, tracking this report in Git allows you to know which changes to your code made changes to the data points. 
{p_end}

{pstd}Before saving the data {bf:iesave} uses compress (see {inp:help compress}) to minimize the storage space the files takes when saved to disk, and it throws and error if isid (see {inp:help isid}) fails to confirm that the ID variable(s) are uniquely and fully identifying the data. This means testing that the ID variable(s) have no duplicated values and no missing values. 
{p_end}

{pstd}The command requires the user to explicitly set the {bf:.dta} version that should be used when saving the data set.This prevents that a team members with a more recent version of Stata accidently saves the data in a file format that team members with an older version of Stata cannot open.
{p_end}

{pstd}The data set meta data contains information on the ID variable(s), the number of observations, the number of variables, the datasignature, the time and date the file was saved as well as the .dta version the data set was last saved in using iesave.  If the  option {bf:userinfo} is used, then the data set meta data also includes the username and the computer ID of the user that most recently used iesave to save the data.
{p_end}

{pstd}If the option {bf:report} is used, then the same data set meta data is also saved to a report in a separate file. In addition to the meta data about the data set, in this report, meta data on all variables are also included.  This meta data is descriptive statistics on the data in each variable.  The descriptive statistics is different depending on the variable being a string, date, categorical or continuous variable. It is often not feasible or desirable to track a .dta file on GitHub so changes to the data set are usually not be tracked together with changes in the code.  This is solved by this report, as the variable meta data will change if the data changes (rare corner case exceptions may exist) and this report is suitable to be tracked on Git.
{p_end}

{title:Options}

{dlgtab:Save options:}

{pstd}{bf:{ul:id}vars}({it:varlist}) is used to specify the variable(s) that uniquely and fully should identify the observations in the data set. This command is intended for research data where data should always be properly identified. The command will, before saving, throw an error if the variables specified in this option have missing values or duplicated values (duplicated combinations of values if more than one ID variable).
{p_end}

{pstd}{bf:{ul:v}ersion}({it:stata_version}) is used to specify which {bf:.dta} version should be used when saving the data set. This allows a team that works in different versions of Stata to always save in the same {bf:.dta} format no matter which Stata version any team member have installed on their computer.  This avoids the issue of a team member saving the data in a format that another team member with an older version cannot read.The recommendation is  to set the highest version number allowed in the oldest version of Stata any team member has installed.  Not every Stata version include a new {bf:.dta} version. The only the {bf:.dta} versions used in this command is 12, 13 and 14.  If a Stata version higher than those versions or a version in-between is specified, then the highest .dta version lower than the specified version is used. For example, if 13.1 is specified, then 13 will be used.
{p_end}

{pstd}{bf:replace} overwrites the data file if it already exits.  If applicable and unless {bf:reportpath()} is used, this also applies to the report file.
{p_end}

{pstd}{bf:userinfo} includes user information - user name {bf:c(username)} and computer name {bf:c(hostname)} - in the meta data.By default, this information is omitted for privacy reasons.  This applies both to meta data saved to char values and, when applicable, meta data saved in the report.
{p_end}

{pstd}{bf:report}({it:report_options}) is used to create a report with meta data. The default is to save the report in markdown format in the same location as the data file using the same name as the data file but with {bf:.md} as the file extension. See below for report{it:options that can be used to change any of the default behavior. Either {bf:report()} or {bf:report} can be used when keeping all default behavior.
{p_end}

{dlgtab:Report options:}

{pstd}These options are only to be used inside {bf:report()}
{p_end}

{pstd}{bf:path}({it:{c 34}/path/to/report.md{c 34}}) is used to specify a different file location and file name than the default.  The file extension must be {bf:.md} or {bf:.csv}.If this option is used then the replace option used for the data file does not apply to the report file.
{p_end}

{pstd}{bf:replace} is used to replace the report file if it already exists.This option only applies of the report option {bf:path()} is used, as otherwise the replace option for the .dta file also applies to the report file.
{p_end}

{pstd}{bf:csv} is used to specify that the report should be created in CSV format instead of markdown. This option is superseded and has no effect if the option {bf:path()} is also used.
{p_end}

{pstd}{bf:noalpha} is used to list the variables in the tables in the report in the same order as the sort order of the data set.The default is to sort the variables alphabetically.
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}This is the most basic usage of {bf:iesave}.  Specified like this, it saves the data set after it has checked that the variable {bf:make} is uniquely and  fully identifying the data and have used {bf:compress} (see {inp:help compress}) to make sure the data points are stored in the most memory efficient format. 
{p_end}

{input}{space 8}sysuse auto, clear
{space 8}local myfolder "/path/to/folder"
{space 8}iesave "`myfolder'/data1.dta", replace /// 
{space 8}  idvars(make) version(15)
{text}
{dlgtab:Example 2}

{pstd}This example is similar to example 1, but it also saves a report with the meta data about the data set and the variables to {bf:data2.md}
{p_end}

{input}{space 8}sysuse auto, clear
{space 8}local myfolder "/path/to/folder"
{space 8}iesave "`myfolder'/data2.dta", replace /// 
{space 8}  idvars(make) version(15) report
{text}
{dlgtab:Example 3}

{pstd}This example is similar to example 2, but it saves the report in csv format and saves it in the custom location specified inside {bf:path()}
{p_end}

{input}{space 8}sysuse auto, clear
{space 8}local myfolder "/path/to/folder"
{space 8}iesave "`myfolder'/data2.dta", replace /// 
{space 8}  idvars(make) version(15)                ///
{space 8}  report(path("`myfolder'/reports/data-report.csv") replace) 
{text}
{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions and requests for clarifications writing {c 34}iefieldkit iesave{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {inp:ietoolkit}. 
{p_end}

{title:Author}

{pstd}All commands in iefieldkit are developed by DIME Analytics at the World Bank{c 39}s Development Impact Evaluations department.
{p_end}
