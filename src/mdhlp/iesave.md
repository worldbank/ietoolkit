# Title

__iesave__ - applies best practices before saving data, with option to save meta data report about the data saved.


# Syntax

__iesave__ filename, __**id**vars__(_varlist_) __**v**ersion__(_version_number_) [ __replace__ __userinfo__ __report__(_report_options_) ]

## Save options:

| _options_ | Description |
|-----------|-------------|
| __**id**vars__(_varlist_)| The variable(s) that should identify the data set |
| __**v**ersion__(_version_number_) | Specify which __.dta__ version to use when saving |
| __replace__ | Replace the data file if it already exits |
| __userinfo__ | Include user info in meta data |
| __report__(_report_options_)  | Save a report with meta data about the data to disk. See below for opt |

## Report options:

These options are only to be used inside __report()__

| _options_ | Description |
|-----------|-------------|
|  __path__(_"/path/to/report.md"_) |  Save the report using another name and location than the data file |
| __replace__ | Replace report file if it already exists |
| __csv__ | Create the report in csv format instead of markdown |
| __noalpha__ | Order the variables in the report as in the data set and not alphabetically |

# Description

The command __iesave__ is an enhanced way of saving data sets to disk, intended to be used instead of the built in command save (see `help save`) when working with research data. In addition to saving the data set to disk, the command applies some best practices steps before saving it and it compiles meta data about the data set and about each variable. The meta data about the data set is always saved in char (see `help char`) characteristics to the data file.Both the data set and the variables meta data can be exported in a separate file that can be tracked using Git. When the data points in the data set changes, then the variable meta data also changes. Therefore, tracking this report in Git allows you to know which changes to your code made changes to the data points.

Before saving the data __iesave__ uses compress (see `help compress`) to minimize the storage space the files takes when saved to disk, and it throws and error if isid (see `help isid`) fails to confirm that the ID variable(s) are uniquely and fully identifying the data. This means testing that the ID variable(s) have no duplicated values and no missing values.

The command requires the user to explicitly set the __.dta__ version that should be used when saving the data set.This prevents that a team members with a more recent version of Stata accidently saves the data in a file format that team members with an older version of Stata cannot open.

The data set meta data contains information on the ID variable(s), the number of observations, the number of variables, the datasignature, the time and date the file was saved as well as the .dta version the data set was last saved in using iesave.  If the  option __userinfo__ is used, then the data set meta data also includes the username and the computer ID of the user that most recently used iesave to save the data.

If the option __report__ is used, then the same data set meta data is also saved to a report in a separate file. In addition to the meta data about the data set, in this report, meta data on all variables are also included.  This meta data is descriptive statistics on the data in each variable.  The descriptive statistics is different depending on the variable being a string, date, categorical or continuous variable. It is often not feasible or desirable to track a .dta file on GitHub so changes to the data set are usually not be tracked together with changes in the code.  This is solved by this report, as the variable meta data will change if the data changes (rare corner case exceptions may exist) and this report is suitable to be tracked on Git.


# Options

## Save options:

__**id**vars__(_varlist_) is used to specify the variable(s) that uniquely and fully should identify the observations in the data set. This command is intended for research data where data should always be properly identified. The command will, before saving, throw an error if the variables specified in this option have missing values or duplicated values (duplicated combinations of values if more than one ID variable).

__**v**ersion__(_stata_version_) is used to specify which __.dta__ version should be used when saving the data set. This allows a team that works in different versions of Stata to always save in the same __.dta__ format no matter which Stata version any team member have installed on their computer.  This avoids the issue of a team member saving the data in a format that another team member with an older version cannot read.The recommendation is  to set the highest version number allowed in the oldest version of Stata any team member has installed.  Not every Stata version include a new __.dta__ version. The only the __.dta__ versions used in this command is 12, 13 and 14.  If a Stata version higher than those versions or a version in-between is specified, then the highest .dta version lower than the specified version is used. For example, if 13.1 is specified, then 13 will be used.

__replace__ overwrites the data file if it already exits.  If applicable and unless __reportpath()__ is used, this also applies to the report file.

__userinfo__ includes user information - user name __c(username)__ and computer name __c(hostname)__ - in the meta data.By default, this information is omitted for privacy reasons.  This applies both to meta data saved to char values and, when applicable, meta data saved in the report.

__report__(_report_options_) is used to create a report with meta data. The default is to save the report in markdown format in the same location as the data file using the same name as the data file but with __.md__ as the file extension. See below for report_options that can be used to change any of the default behavior. Either __report()__ or __report__ can be used when keeping all default behavior.

## Report options:

These options are only to be used inside __report()__

__path__(_"/path/to/report.md"_) is used to specify a different file location and file name than the default.  The file extension must be __.md__ or __.csv__.If this option is used then the replace option used for the data file does not apply to the report file.

__replace__ is used to replace the report file if it already exists.This option only applies of the report option __path()__ is used, as otherwise the replace option for the .dta file also applies to the report file.

__csv__ is used to specify that the report should be created in CSV format instead of markdown. This option is superseded and has no effect if the option __path()__ is also used.

__noalpha__ is used to list the variables in the tables in the report in the same order as the sort order of the data set.The default is to sort the variables alphabetically.


# Examples

## Example 1

This is the most basic usage of __iesave__.  Specified like this, it saves the data set after it has checked that the variable __make__ is uniquely and  fully identifying the data and have used __compress__ (see `help compress`) to make sure the data points are stored in the most memory efficient format.

```
sysuse auto, clear
local myfolder "/path/to/folder"
iesave "`myfolder'/data1.dta", replace ///
  idvars(make) version(15)
```

## Example 2

This example is similar to example 1, but it also saves a report with the meta data about the data set and the variables to __data2.md__

```
sysuse auto, clear
local myfolder "/path/to/folder"
iesave "`myfolder'/data2.dta", replace ///
  idvars(make) version(15) report
```

## Example 3

This example is similar to example 2, but it saves the report in csv format and saves it in the custom location specified inside __path()__

```
sysuse auto, clear
local myfolder "/path/to/folder"
iesave "`myfolder'/data2.dta", replace ///
  idvars(make) version(15)                ///
  report(path("`myfolder'/reports/data-report.csv") replace)
```


# Feedback, bug reports and contributions

Please send bug-reports, suggestions and requests for clarifications writing "iefieldkit iesave" in the subject line to: dimeanalytics@worldbank.org

You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through [GitHub repository](https://github.com/worldbank/ietoolkit) for `ietoolkit`.


# Author

All commands in iefieldkit are developed by DIME Analytics at the World Bank's Development Impact Evaluations department.
