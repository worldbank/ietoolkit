{smcl}
{* 31 Jan 2019}{...}
{hline}
help for {hi:iebaltab}
{hline}

{title:Title}

{phang2}{cmdab:iebaltab} {hline 2} produces balance tables with multiple groups or treatment arms

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Iebaltab":DIME Wiki}.

{title:Syntax}

{phang2}
{cmdab:iebaltab} {it:balancevarlist} [{help if:if}] [{help in:in}] [{help weight}]
, {cmdab:grpv:ar(}{it:varname}{cmd:)} {c -(} {cmdab:save(}{it:{help filename}}{cmd:)} | {cmdab:savet:ex(}{it:{help filename}}{cmd:)} | {cmdab:browse} {c )-}
[
{it:{help iebaltab##columnoptions:column_options} {help iebaltab##labeloptions:label_options}}
{it:{help iebaltab##statsoptions:stats_options} {help iebaltab##ftestoptions:ftest_options}}
{it: {help iebaltab##displayoptioins:display_options} {help iebaltab##exportoptions:export_options}}
]

{phang2}where {it:balancevarlist} is one or several variables (from here on called balance variables) for which the command
will test for differences across the catagories in grpvar({it:varname}).

{marker opts}{...}
{synoptset 23}{...}
{synopthdr:options}
{synoptline}
{pstd}{it:    {ul:{hi:Required options:}}}{p_end}

{synopt :{cmdab:grpv:ar(}{it:varname}{cmd:)}}Variable indicating groups (or treatment arms){p_end}

{pstd}{it:One of these options must be used:}{p_end}
{synopt :{cmdab:save(}{it:{help filename}}{cmd:)}}Save table to Excel file on disk {p_end}
{synopt :{cmdab:savet:ex(}{it:{help filename}}{cmd:)}}Save table to LaTeX file on disk {p_end}
{synopt :{cmdab:browse}}View the table in the data browser{p_end}

{pstd}{it:    {ul:{hi:Optional options}}}{p_end}

{marker columnoptions}{...}
{pstd}{it:    Columns and order of columns options:}{p_end}
{synopt :{cmdab:co:ntrol(}{it:groupcode}{cmd:)}}One group is tested against all other groups in t-tests and F-tests. Default is all groups against each other.{p_end}
{synopt :{cmdab:or:der(}{it:groupcodelist}{cmd:)}}Manually set the group column order in the table. Default is ascending. See details on {it:groupcodelist} below.{p_end}
{synopt :{cmdab:tot:al}}Include descriptive stats on all groups combined{p_end}

{marker labeloptions}{...}
{pstd}{it:    Column and row labels:}{p_end}
{synopt :{cmdab:grpc:odes}}Use the treatment arm codes as group column titles{p_end}
{synopt :{cmdab:grpl:abels(}{it:codetitles}{cmd:)}}Manually set the group column titles. See details on {it:codetitles} below.{p_end}
{synopt :{cmdab:totall:abel(}{it:string}{cmd:)}}Manually set the total column title{p_end}
{synopt :{cmdab:rowv:arlabels}}Use the variable labels instead of variable name as row titles{p_end}
{synopt :{cmdab:rowl:abels(}{it:nametitles}{cmd:)}}Manually set the row titles. See details on {it:nametitles} below.{p_end}
{synopt :{cmdab:onerow}}Write number of observations (and number of clusters if applicable) in one row at the bottom of the table.{p_end}

{marker statsoptions}{...}
{pstd}{it:    Statistics and data modification:}{p_end}
{synopt :{cmdab:balmiss:(}{it:reptype}{cmd:)}}Replaces missing values in balance variables with either zeros, the mean or the group mean. See details on {it:reptype} below.{p_end}
{synopt :{cmdab:balmissr:eg(}{it:reptype}{cmd:)}}Similar to {cmd:balmiss()} but treats {help missing:extended missing values} still as missing.  See details on {it:reptype} below.{p_end}
{synopt :{cmdab:vce:(}{it:{help vce_option:vce_types}}{cmd:)}}Options for variance estimation. {hi:Robust}, {hi:cluster} {it:clustervar} or {hi:bootstrap}{p_end}
{synopt :{cmdab:fix:edeffect(}{it:varname}{cmd:)}}Include fixed effects in the regressions for t-tests (and for F-tests if applicable){p_end}
{synopt :{cmdab:cov:ariates(}{it:{help varlist}}{cmd:)}}Include covariates (control variables) in the regressions for t-tests (and for F-tests if applicable){p_end}
{synopt :{cmd:covarmissok}}Allows for observations to be dropped due to missing values in covariate variables{p_end}
{synopt :{cmdab:covmiss:(}{it:reptype}{cmd:)}}Replaces missing values in covariate variables with either zeros, the mean or the group mean. See details on {it:reptype} below.{p_end}
{synopt :{cmdab:covmissr:eg(}{it:reptype}{cmd:)}}Similar to {cmd:covmiss()} but treats {help missing:extended missing values} still as missing. See details on {it:reptype} below.{p_end}
{synopt :{cmdab:missmin:mean(}{it:{help numlist:numlist}}{cmd:)}}Sets a minimum number of observations that a mean or group mean must be based on in options requiring {it:reptype}.{p_end}

{marker ftestoptions}{...}
{pstd}{it:    F-test:}{p_end}
{synopt :{cmdab:ft:est}}Include a row with the F-test for joint significance of all balance variables{p_end}
{synopt :{cmdab:fm:issok}}Suppress the error caused by missing values in F-test{p_end}
{synopt :{cmd:fnoobs}}Do not display number of observations from the F-test regressions{p_end}

{marker displayoptions}{...}
{pstd}{it:    Table display options:}{p_end}
{synopt :{cmdab:pt:test}}Show p-values instead of difference-in-means between the groups in the column for t-tests{p_end}
{synopt :{cmdab:not:test}}Suppresses the column for pairwise t-tests{p_end}
{synopt :{cmdab:normd:iff}}Adds a column with pairwise normalized differences{p_end}
{synopt :{cmdab:feqt:est}}Adds a column with F-test for joint orthogonality of each balance variable across all treatment arms{p_end}
{synopt :{cmdab:pf:test}}Show p-values instead of F-statistics for all F-tests{p_end}
{synopt :{cmdab:pb:oth}}Identical to specifying both {cmd:pttest} and {cmd:pftest}{p_end}
{synopt :{cmdab:std:ev}}Displays standard deviations instead of standard errors{p_end}
{synopt :{cmdab:star:levels(}{it:{help numlist:numlist}}{cmd:)}}Manually set the three significance levels used for significance stars{p_end}
{synopt :{cmdab:starsno:add}}Do not add any stars to the table{p_end}
{synopt :{cmdab:form:at(}{it:{help format:%fmt}}{cmd:)}}Apply Stata formats to the values outputted in the table{p_end}
{synopt :{cmdab:tbln:ote(}{it:string}{cmd:)}}Add a note to the bottom of the table{p_end}
{synopt :{cmdab:notec:ombine}}Combine all notes (manually entered or automatically generated) to one row{p_end}
{synopt :{cmdab:tblnon:ote}}Disable any notes automatically generated by the command{p_end}

{marker exportoptions}{...}
{pstd}{it:    Export and browse options:}{p_end}
{synopt :{cmd:replace}}Replace file on disk if the file already exists{p_end}
{synopt :{cmdab:savebr:owse}}View the table in the browser window also after saving the table to file{p_end}
{synopt :{cmdab:texn:otewidth(}{it:{help numlist:numlist}}{cmd:)}}Manually adjust width of note{p_end}
{synopt :{cmdab:texc:aption(}{it:string}{cmd:)}}Specify TeX table caption{p_end}
{synopt :{cmdab:texl:abel(}{it:string}{cmd:)}}Specify TeX label{p_end}
{synopt :{cmdab:texdoc:ument}}Creates a stand-alone TeX document{p_end}
{synopt :{cmd:texvspace(}{it:string}{cmd:)}}Manually set size of the line space between two rows on TeX output{p_end}
{synopt :{cmd:texcolwidth(}{it:string}{cmd:)}}Limit width of the first column on TeX output{p_end}

{synoptline}

{title:Description}

{pstd}{cmdab:iebaltab} is a command that generates balance tables (difference-in-means tables).
	The command tests for statistically significant difference between the categories defined in the
	grpvar(varname). The command can either test one control group against all other groups or test
	all groups against each other. The command also allows for fixed effects, covariates and different
	types of variance estimators.

{pstd}A lot of attention has also been spent on providing helpful error messages when the command is
	misspecified. The command will also issue errors or warnings when the command is specified
	correctly but the nature of the data leaves potential for the results to be misinterpreted , or
	simply invalid. For example, if an observation has a missing value in a variable that is
	used in an F-test for joint significance, then Stata cannot do anything but drop that observation.
	This command will throw an error unless the user specify the option that suppresses that error or if
	the user specify any of the options that tells the command how to interpret missing values.

{pstd}The command also attaches notes to the bottom of the table with information on, for example,
	which significance levels are used for stars, which fixed effects or covariates that were included (if any) etc.

{pstd}The command estimates the descriptive stats, the t-test, and the F-tests using the following regressions:

{pstd}{hi:Group means and group standard errors}
{break}In the following regression, {it:balancevarname} refers to the variables (one at the time) listed
 in {it:balancevarlist}, {it:groupvar} refers to the variable listed in option grpvar({it:varname}) and {it:groupcode}
 refers to the value corresponding to the group for which the means and standard errors are estimated for.

{pmore}{input:reg balancevarname if groupvar = groupcode}

{pstd}where  _b[cons] from the returned results is the group mean and _se[cons] is the standard
	error in the group mean. Fixed effects and covariates are never included in this regression.

{pstd}{hi:t-tests}
{break}In the following t-test regression, {it:balancevarname} refers to the variables (one at the time)
listed in {it:balancevarlist}. {it:testgroupdummy} is a dummy variable with the value 0 for one of the
groups compared in this t-test and 1 for the other group. All other groups have missing values
 and are therefore excluded from the regression.

{pmore}{input:reg balancevarname testgroupdummy}
{break}{input:test testgroupdummy}

{pstd}where r(p), from the returned results, is used when adding stars to the tables
according to the thresholds specified in option starlevels().

{pstd}{hi:F-test}
{break}In the following F-test regression, {it:balancevarlist} refers to the list of all {it:balancevars} specified
for the command. {it:testgroupdummy} is a dummy variable with the value 0 for one of the groups compared
in this t-test and 1 for the other group. All other groups have missing values and are therefore
excluded from the regression.

{pmore}{input:reg testgroupdummy balancevarlist}
{break}{input:testparm balancevarlist}

{pstd}where r(p), from the returned results, is used when adding stars to the tables
according to the thresholds specified in option starlevels().

{pstd}{hi:Fixed effects}
{break}In the following t-test and F-test regressions with fixed effects, {it:fixed}
refers to the variable included as the fixed effects in option fixedeffects(). The p-values
for the tests are obtained in the same way as described above.

{pmore}{input:xi : reg balancevarname testgroupdummy i.fixed}
{break}{input:test testgroupdummy}

{pmore}{input:xi : reg testgroupdummy balancevarlist i.fixed}
{break}{input:testparm balancevarlist}

{pstd}{hi:Covariates}
{break}In the following t-test and F-test regressions which include covariates, {it:covariatesvarlist}
refers to the variables included as the control variables in option covariates(). The p-values
for the tests are obtained in the same way as described above.

{pmore}{input:reg balancevarname testgroupdummy covariatesvarlist}
{break}{input:test testgroupdummy}

{pmore}{input:reg testgroupdummy balancevarlist covariatesvarlist}
{break}{input:testparm balancevarlist}

{pstd}{hi:Standard errors estimators}
{break}In the following t-test and F-test regressions including the non-default
variance estimators, {it:vcetype} is the variance estimator specified. See {help vce_option :vcetype}
for more details.

{pmore}{input:reg balancevarname testgroupdummy, vce(vcetype)}
{break}{input:test testgroupdummy}

{pmore}{input:reg testgroupdummy balancevarlist, vce(vcetype)}
{break}{input:testparm balancevarlist}

{pstd}{hi:Combining them all}
{break}All options described above can be included in the same regression, for example:

{pmore}{input:xi : reg balancevarname testgroupdummy i.fixed covariatesvarlist, vce(vcetype)}
{break}{input:test testgroupdummy}


{title:Options (detailed descriptions)}

{pstd}{it:    {ul:{hi:Required options:}}}{p_end}

{phang}{cmdab:grpv:ar(}{it:varname}{cmd:)} specifies the variable indicating groups (or treatment arms) across which
	the command will test for difference in mean of the balance var. The group variable can only be one variable and
	it must be numeric and may only hold integers. See {help egen:egen group} for help on creating a single variable with
	an integer representing each category from string variables and/or multiple variables. Observations with missing values
	in this variable will be excluded when running this command.

{phang}{cmdab:save(}{it:{help filename}}{cmd:)} saves the balance table to an Excel file on disk using {it:filename}. This
	command cannot be used in combination with {cmd:browse}. {p_end}

{phang}{cmdab:savetex(}{it:{help filename}}{cmd:)} saves the balance table to a LaTeX file on disk using {it:filename}. This
	command cannot be used in combination with {cmd:browse}.

{phang}{cmdab:browse} displays the table in the browse window instead of saving it to file. This command cannot be
	used in combination with {cmd:save()}. WARNING: Note that this option clears the data currently in working memory. Either
	save your data before using this command, use {help preserve:preserve/restore} or {help tempfile:tempfiles} to
	not lose data.{p_end}

{pstd}{it:    {ul:{hi:Optional options}}}{p_end}

{pstd}{it:    Columns and order of columns options:}{p_end}

{phang}{cmdab:co:ntrol(}{it:groupcode}{cmd:)} specifies one group that is the control group that all other groups
are tested against for difference in means and where {it:groupcode} is an integer used in {cmd:grpvar(}{it:varname}{cmd:)}.
The default is that all groups are tested against each other. The control group will be listed first
(leftmost) in the table unless another order is specified in {cmd:order()}.{p_end}

{phang}{cmdab:or:der(}{it:codetitles}{cmd:)} manually sets the column order of the groups in the table. {it:codetitles} is
 a list of integers used in {cmd:grpvar(}{it:varname}{cmd:)}. The default order is ascending order of the group
 codes in {cmdab:grpv:ar(}{it:varname}{cmd:)}. Any groups omitted from this option will, in ascending order,
 follow the groups included.{p_end}

{phang}{cmdab:tot:al} includes a column with descriptive stats on all groups combined.{p_end}

{pstd}{it:Column and row labels:}{p_end}

{phang}{cmdab:grpc:odes} makes the integers for the group codes in {cmd:grpvar(}{it:varname}{cmd:)} the group column titles. The default
is to use the value labels used in {cmdab:grpv:ar(}{it:varname}{cmd:)}. If no value labels are used, then this option does
not make a difference.{p_end}

{phang}{cmdab:grpl:abels(}{it:codetitles}{cmd:)} manually sets the group column titles. {it:codetitles} is a string
on the following format {it:"code1 title1 @ code2 title2 @ code3 title3"} etc. where code1, code2 etc. are group codes used
in {cmd:grpvar(}{it:varname}{cmd:)} and title1, title2 etc. are the corresponding titles. The character "@" may not be used
in any of the titles. Codes omitted from this option will be assigned a column title as if this option was not used. This option
has precedence over {cmd:grpcodes} when used together, meaning that group codes are only used for groups that are not included
in the {it:codetitlestring}. The title can consist of several words. Everything that follows the code until the end of a string
or a "@" will be included in the title.{p_end}

{phang}{cmdab:totall:abel(}{it:string}{cmd:)} manually sets the column title for the total column.{p_end}

{phang}{cmdab:rowv:arlabels} use the variable labels instead of variable name as row titles. The default is to use the
variable name. For variables with no variable label defined, the variable name is used regardless.{p_end}

{phang}{cmdab:rowl:abels(}{it:nametitles}{cmd:)} manually sets the row titles for each of the balance variables in the
table. {it:nametitles} is a string in the following format {it:"name1 title1 @ name2 title2 @ name3 title3"} etc. where
name1, name2 etc. are variable names and title1, title2 etc. are the corresponding row titles. The character "@" may not
be used in any of the titles. Variables omitted from this option are assigned a row title as if this option was not used. This option
has precedence over {cmd:rowvarlabels} when used together, meaning that variable labels are only used for variables that are not included
in the {it:nametitlestring}. The title can consist of several words. Everything that follows the variable name until the end
of a string or a "@" will be included in the title.{p_end}

{phang}{cmdab:onerow} displays the number of observations in additional row at the bottom of the table if each group has the same
number of observations for all variables in {it:balancevarlist}. This also applies to number of clusters. If not specified, the
number of observations (and clusters) per variable per group is displayed on the same row in additional column besides the mean value.{p_end}

{pstd}{it:    Statistics and data modification:}{p_end}

{phang}{cmdab:balmiss:(}{it:reptype}{cmd:)} makes the command replace all missing values in balance variables with either zeros, the mean or the group
mean of the variable. {it:reptype} can either be {it:zero}, {it:mean} or {it:groupmean}. {it:zero} makes the command replace all missing values with a zero. {it:mean} makes
the command replace all missing values with the mean value of this variable. {it:groupmean} makes the command replace all missing values with the mean
value in each group in {cmd:grpvar(}{it:varname}{cmd:)} of this variable. Stata always drops observations with
missing values in the dependent variable or in any of the independent variables when estimating a regression. This option tells this
command to replace all missing values in the balance variables with a non-missing value. That will make it possible to include the observations with
missing values in the balance table. WARNING: while technically possible it is far from certain this option generates a valid result.
There is no guarantee that a missing value can correctly be assumed to be zero without making the interpretation of the balance table invalid. Best
practice is most certainly to manually replace or omit these values manually before running this command. This option is only included to enable
quick balance tables on raw data before the data has been cleaned.{p_end}

{phang}{cmdab:balmissr:eg(}{it:reptype}{cmd:)} makes the command replace all regular missing values in balance variables with either zeros, the mean or
the group mean of the variable. See {cmd:balmiss()} for details and warning.
The difference is that this option still treats {help missing:extended missing values} as missing, but regular missing values will be replaced.{p_end}

{phang}{cmdab:missmin:mean(}{it:{help numlist:numlist}}{cmd:)} sets a minimum number of observations that a mean or group mean must be based
on in {cmd:balmiss()}, {cmd:balmissreg()}, {cmd:covmiss()} and {cmd:covmissreg()}. The arbitrary default is 10.{p_end}

{phang}{cmdab:vce:(}{it:{help vce_option:vce_types}{cmd:)}} sets the type of variance estimator to be used in all regressions for this
command. See {help vce_option:vce_types} for more details. The only vce types allowed in this command are {hi:robust}, {hi:cluster} {it:clustervar} or {hi:bootstrap}.{p_end}

{phang}{cmdab:fix:edeffect(}{it:varname}{cmd:)}includes the variable specified as fixed effects in the regressions for t-tests (and
for F-tests if applicable). See the description section above for details on how the fixed effects are included in the estimation regressions.
The variable specified must be a numeric variable. Only one variable may be specified. See {help egen:egen group} for
help on creating a single variable with an integer representing each category from string variables and/or multiple variables.{p_end}

{phang}{cmdab:cov:ariates(}{it:{help varlist}{cmd:)}} includes the variables specified in the regressions for t-tests (and for
F-tests if applicable) as covariate variables (control variables). See the description section above for details on how the covariates
 are included in the estimation regressions. The covariate variables must be numeric variables.{p_end}

{phang}{cmd:covarmissok} allows for observations to be dropped due to missing values in covariate variables. Stata always drops observations
with missing values in at least one the variables used in a regression. This command throws an error if any observation has missing
values in any of the variables specified in {cmd:covariates()}. To suppress that error, use this option and thereby accept that some observations
are excluded from the balance table. Also see {cmd:covmiss()} and {cmd:covmissreg()} for other solutions to this issue.{p_end}

{phang}{cmdab:covmiss(}{it:reptype}{cmd:)} makes the command replace all missing values in covariate variables with either zeros, the mean or the group mean of the variable. See {cmd:balmiss} for more
details and the warning that applies to this command as well.{p_end}

{phang}{cmdab:covmissr:eg(}{it:reptype}{cmd:)} makes the command replace all regular missing values in covariate variables with either zeros, the mean or the group mean of the variable. See {cmd:balmiss} for more
details and the warning that applies to this command as well. The difference from {cmd:covmiss()} that this option still treat {help missing:extended missing values} as
missing, but regular missing values will be replaced.{p_end}

{pstd}{it:    F-test:}{p_end}

{phang}{cmdab:ft:est} includes a row with an F-test for joint significance of all balance variables. See the description section above for details on how the F-test estimation
regressions are specified. All options specified in the {it:Statistics and data modification} section above also apply to the F-tests.{p_end}

{phang}{cmdab:fm:issok} suppress the error caused by missing values in any of the balance variables in the F-test. Stata always drops observations
with missing values in at least one the variables used in a regression. This command throws an error if any observation has missing
values in any of the balance variables. To suppress that error, use this option and thereby accept that some observations
are excluded from F-tests. Also see {cmd:balmiss()} and {cmd:balmissreg()} for other solutions to this issue.{p_end}

{phang}{cmd:fnoobs} excludes the row with number of observations in the F-test regressions from displaying in the table.{p_end}

{pstd}{it:Table display options:}{p_end}

{phang}{cmdab:pt:test} makes this command show p-values instead of difference-in-mean between the groups in the column for t-tests.{p_end}

{phang}{cmdab:not:test} suppresses the column for pairwise t-tests across treatment arms.{p_end}

{phang}{cmdab:normd:iff} adds a column with pairwise normalized difference across treatment arms.{p_end}

{phang}{cmdab:feqt:est} adds a column with an F-test for joint orthogonality of each variable across all treatment arms. Please note that this F-test is different from the one performed by option {cmd:ftest},
which adds a row indicating if all variables are jointly significant when each pair of treatment arms is compared.{p_end}

{phang}{cmdab:pf:test} makes this command show p-values instead of F-statistics in the row for F-tests created using option {cmd:ftest} and/or the columns for F-test created using option {cmd:feqtest}.{p_end}

{phang}{cmdab:pb:oth} is identical to specifying both {cmd:pttest} and {cmd:pftest}.{p_end}

{phang}{cmdab:std:ev} displays standard deviations in parenthesis instead of standard errors.{p_end}

{phang}{cmdab:star:levels(}{it:{help numlist:numlist}}{cmd:)} manually sets the three significance levels
used for significance stars. Use decimals in descending order. The default is (.1 .05 .01) where .1 corresponds
to one star, .05 to two stars and .01 to three stars.{p_end}

{phang}{cmdab:starsno:add} makes the command not add any stars to the table. This option makes the most sense in combination
with {cmd:pttest}, {cmd:pftest} or {cmd:pboth} but is possible to use by itself as well.{p_end}

{phang}{cmdab:form:at(}{it:{help format:%fmt}}{cmd:)} applies the Stata formats specified to all values outputted
in the table. All values apart from integers, for example number of observations, for which the format is always %9.0f.{p_end}

{phang}{cmdab:tbln:ote(}{it:string}{cmd:)} adds a manually entered note to the bottom of the table. This note will
be added in addition to the notes automatcally generated by the command unless {cmd:tblnonote} is specified, then
only this manually entered note will be added to the table.{p_end}

{phang}{cmdab:notec:ombine} combines all notes (manually entered or automatically generated) into one row. The default
 is that each note is added on one separate row per note.{p_end}

{phang}{cmdab:tblnon:ote} makes this command not add any of the notes automatically generated by the command to the
 table. Manually entered notes in {cmd:tblnote()} will still be added to the table.{p_end}

{pstd}{it:    Export and browse options:}{p_end}

{phang}{cmd:replace} allows for the file in {cmd:save()} to be overwritten if the file already exist on disk.{p_end}

{phang}{cmdab:savebr:owse} views the table in the browser window similarly to {cmd:browse} after saving the table to file using {cmd:save}.{p_end}

{phang}{cmdab:texn:otewidth(}{it:{help numlist:numlist}}{cmd:)} manually adjusts the width of the note to fit the size of the table.
The note width is a multiple of text width. If not specified, default is one, which makes the table width equal to text width.{p_end}

{phang}{cmdab:texc:aption(}{it:string}{cmd:)} writes table's caption in TeX file. Can only be used with option texdocument.{p_end}

{phang}{cmdab:texl:abel(}{it:string}{cmd:)} specifies table's label, used for meta-reference across TeX file. Can only be used with option texdocument.{p_end}

{phang}{cmdab:texdoc:ument}  creates a stand-alone TeX document that can be readily compiled, without the need to import it to a different file.
 As default, {cmd:savetex()} creates a fragmented TeX file consisting only of a tabular environment.{p_end}

{phang}{cmd:texvspace(}{it:string}{cmd:)} sets the size of the line space between two variable rows. {it:string} must consist of a numeric value
and one of the following units: "cm", "mm", "pt", "in", "ex" or "em". Note that the resulting line space displayed will be equal to the
specified value minus the height of one line of text. Default is "3ex". For more information on units,
{browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX lengths manual}. {p_end}

{phang}{cmd:texcolwidth(}{it:string}{cmd:)} limits the width of table's first column so that a line break is added when a variable's name
or label is too long. {it:string} must consist of a numeric value and one of the following units: "cm", "mm", "pt", "in", "ex" or "em".
For more information on these units, {browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX lengths manual}. {p_end}

{title:Examples}

{pstd} {hi:Example 1.}

{pmore}{inp:iebaltab {it:outcome_variable}, grpvar({it:treatment_variable}) browse}

{pmore}In the example above, let's assume that {it:treatment_variable} is a variable that is 0 for observations in
 the control group, and 1 for observations in the treatment group. Then in this example, the command will
 show the mean of {it:outcome_variable} and the standard error of that mean for the control group and the treatment
 group separately, and it will show the difference between the two groups and test if that difference is statistically significant.


{pstd} {hi:Example 2.}

{pmore}{inp:global project_folder "C:\Users\project\baseline\results"}
{break}{inp:iebaltab {it:outcome_variable}, grpvar({it:treatment_variable}) save("$project_folder\balancetable.xlsx")}

{pmore}The only difference between example 1 and this example is that in this example the table is saved to file instead of being shown in the browser window.

{pstd} {hi:Example 3.}

{pmore}{inp:iebaltab {it:outcome1 outcome2 outcome3}, grpvar({it:treatment_variable}) save("$project_folder\balancetable.xlsx") rowvarlabels rowlabels({it:"outcome1 Outcome variable 1 @ outcome2 Second outcome variable"})}

{pmore}Example 3 builds on example 2. There are now 3 variables listed as balance variables. In option {cmd:rowlabels()} two
 of those balance variables have been given a new label to be displayed as row title instead of the variable name. Instead of outcome1
 the row title will be "Outcome variable 1", and instead of outcome2 the row title will be "Second outcome variable". For balance variable
 outcome3 that is not included in {cmd:rowlabels()}, the command will use the variable label defined for outcome3 as row title since
 option {cms:rowarlabels} was specified. If outcome3 does not have any row variable defined, then the variable name will be used
 as row title, just like the default.

{title:Acknowledgements}

{phang}We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}John Dundas{break}Seungmin Lee{break}

{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iebaltab" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
