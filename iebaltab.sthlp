{smcl}
{* 08 Aug 2016}{...}
{hline}
help for {hi:iebaltab}
{hline}

{title:Title}

{phang2}{cmdab:iebaltab} {hline 2} produces balance tables with multiple groups or treatment arms

{title:Syntax}

{phang2}
{cmdab:iebaltab} {it:balancevarlist} [{help if:if}] [{help in:in}]
, {cmdab:grpv:ar(}{it:varname}{cmd:)} {c -(} {cmdab:save(}{it:{help filename}}{cmd:)} | {cmdab:browse} {c )-} 
[
{cmdab:co:ntrol(}{it:groupcode}{cmd:)} {cmdab:or:der(}{it:groupcodelist}{cmd:)} {cmdab:tot:al} {cmdab:grpc:odes} 
{cmdab:grpl:abels(}{it:codetitlestring}{cmd:)} {cmdab:totall:abel(}{it:string}{cmd:)} {cmdab:rowv:arlabels} 
{cmdab:rowl:abels(}{it:nametitlestring}{cmd:)} {cmdab:missz:ero} {cmdab:missr:egzero} {cmdab:vce:(}{it:{help vce_option:vce_types}}{cmd:)}
{cmdab:fix:edeffect(}{it:varname}{cmd:)} {cmdab:cov:ariates(}{it:{help varlist}}{cmd:)} {cmd:covarmissok} {cmdab:covmissz:ero}
{cmdab:covmissr:egzero} {cmdab:ft:est} {cmdab:fm:issok} {cmd:fnoobs} {cmdab:pt:test} {cmdab:pf:test} {cmdab:pb:oth} 
{cmdab:star:levels(}{it:{help numlist:numlist}}{cmd:)} {cmdab:starsno:add} {cmdab:form:at(}{it:{help format:%fmt}}{cmd:)} 
{cmdab:tbln:ote(}{it:string}{cmd:)} {cmdab:notec:ombine} {cmdab:tblnon:ote} {cmd:replace} {cmdab:savebr:owse}
]

{phang2}where {it:balancevarlist} is one or several variables (from here on called balance variables) for which the command 
will test for differences across the catagories in grpvar({it:varname}), {it:groupcode} 
is a value used in grpvar({it:varname}), {it:groupcodelist} is a list of one or many values
used in grpvar({it:varname}), {it:codetitlestring} is a string of group codes with corresponding column title and 
{it:nametitlestring} is a string of variable names with corresponding row title.

{marker opts}{...}
{synoptset 26}{...}
{synopthdr:options}
{synoptline}
{pstd}{it:    {ul:{hi:Required options:}}}{p_end}

{synopt :{cmdab:grpv:ar(}{it:varname}{cmd:)}}Variable indicating groups (or treatment arms){p_end}

{pstd}{it:One of these options must be used but they are not allowed to be used in combination:}{p_end}
{synopt :{cmdab:save(}{it:{help filename}}{cmd:)}}Save table to file on disk. {p_end}
{synopt :{cmdab:browse}}View the table in the data browser{p_end}

{pstd}{it:    {ul:{hi:Optional options}}}{p_end}

{pstd}{it:    Columns and order of columns options:}{p_end}
{synopt :{cmdab:co:ntrol(}{it:groupcode}{cmd:)}}One group is tested against all other groups in t-tests and F-tests. Default is all groups against each other.{p_end}
{synopt :{cmdab:or:der(}{it:groupcodelist}{cmd:)}}Manually set the group column order in the table {p_end}
{synopt :{cmdab:tot:al}}Include descriptive stats on all groups combined{p_end}

{pstd}{it:    Column and row labels:}{p_end}
{synopt :{cmdab:grpc:odes}}Use the treatment arm codes as group column titles{p_end}
{synopt :{cmdab:grpl:abels(}{it:codetitlestring}{cmd:)}}Manually set the group column titles{p_end}
{synopt :{cmdab:totall:abel(}{it:string}{cmd:)}}Manually set the total column title{p_end}
{synopt :{cmdab:rowv:arlabels}}Use the variable labels instead of variable name as row titles{p_end}
{synopt :{cmdab:rowl:abels(}{it:nametitlestring}{cmd:)}}Manually set the row titles{p_end}

{pstd}{it:    Statistics and data modification:}{p_end}
{synopt :{cmdab:missz:ero}}Treat missing values in balance variables as zeros{p_end}
{synopt :{cmdab:missr:egzero}}Similar to {cmd:misszero} but treats {help missing:extended missing values} as missing{p_end}
{synopt :{cmdab:vce:(}{it:{help vce_option:vce_types}}{cmd:)}}Options for variance estimation. Robust, cluster or bootstrap{p_end}
{synopt :{cmdab:fix:edeffect(}{it:varname}{cmd:)}}Include fixed effects in the regressions for t-tests (and for F-tests if applicable){p_end}
{synopt :{cmdab:cov:ariates(}{it:{help varlist}}{cmd:)}}Include covariates (control variables) in the regressions for t-tests (and for F-tests if applicable){p_end}
{synopt :{cmd:covarmissok}}Allows for observations to be dropped due to missing values in covariate variables{p_end}
{synopt :{cmdab:covmissz:ero}}Treat missing values in covariate variables as zeros{p_end}
{synopt :{cmdab:covmissr:egzero}}Similar to {cmd:covmisszero} but treats {help missing:extended missing values} as missing{p_end}

{pstd}{it:    F-test:}{p_end}
{synopt :{cmdab:ft:est}}Include an F-test for joint significance{p_end}
{synopt :{cmdab:fm:issok}}Suppress the error caused by missing values in F-test{p_end}
{synopt :{cmd:fnoobs}}Do not display number of observations from the F-test regressions{p_end}

{pstd}{it:    Table display options:}{p_end}
{synopt :{cmdab:pt:test}}Show p-values instead of difference-in-mean between the groups in the column for t-tests{p_end}
{synopt :{cmdab:pf:test}}Show p-values instead of F-statistics in the row for F-tests{p_end}
{synopt :{cmdab:pb:oth}}Identical to specifying both {cmd:pttest} and {cmd:pftest}{p_end}
{synopt :{cmdab:star:levels(}{it:{help numlist:numlist}}{cmd:)}}Manually set the three significance levels used for significance stars{p_end}
{synopt :{cmdab:starsno:add}}Do not add any stars to the table{p_end}
{synopt :{cmdab:form:at(}{it:{help format:%fmt}}{cmd:)}}Apply Stata formats to the values outputted in the table{p_end}
{synopt :{cmdab:tbln:ote(}{it:string}{cmd:)}}Add a note to the bottom of the table{p_end}
{synopt :{cmdab:notec:ombine}}Combine all notes (manually entered or automatically generated) to one row{p_end}
{synopt :{cmdab:tblnon:ote}}Disable any notes automatically generated by the command{p_end}

{pstd}{it:    Export and browse options:}{p_end}
{synopt :{cmd:replace}}Replace file on disk if the file already exists{p_end}
{synopt :{cmdab:savebr:owse}}View the table in the browser window also after saving the table to file{p_end}

{synoptline}

{title:Description}

{pstd}{cmdab:iebaltab} is a command that generates balance tables (difference-in-means tables).
	The command tests for statistically significant difference between the categories defined in the 
	grpvar(varname). The command can either test one control group against all other groups or test
	all groups against each other. The command also allows for fixed effects, covariates and different
	types of variance estimators.

{pstd}A lot of attention has also been spent on providing helpful error messages when the command is 
	miss specified. The command will also issue errors or warnings when the command is specified 
	correctly but the nature of the data leaves potential for the results to be misinterpreted , or 
	simply invalid. For example, if an observation has a missing value in a variable that is 
	used in an F-test for joint significance, then Stata cannot do anything but drop that observation.
	This command will throw an error unless the user specify the option that suppresses that error or if 
	the user specify any of the options that tells the command how to interpret missing values.
	
{pstd}The command also attaches notes to the bottom of the table with infomration on, for example, 
	which significance levels are used for stars, which fixed effects or covariates that were included (if any) etc. 
	
{pstd}The command estimates the descriptive stats, the t-test, and the F-tests using the following regressions:

{pstd}{hi:Group means and group standard errors}
{break}In the following regression, {it:balancevarname} refers to the variables (one at the time) listed
 in {it:balancevarlist}, {it:groupvar} refers to the variable listed in option grpvar({it:varname}) and {it:groupcode}
 refers to the value corresponding to the group for which the means and standard errors are estimated for.
 
{pmore}{input:reg balancevarname if groupvar = groupcode}

{pstd}where  _b[cons] from the returned results is the group mean and _se[cons] is the standard
	error in the group mean. Fixed effects and covaraiates are never included in this regression.

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
variance estimators, {it:vcetype} is the varaince estimator specfied. See {help vce_option :vcetype} 
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
	an integer representing each category from string varaibles and/or multiple variables. Observations with missing values
	in this variable will be excluded when running this command.

{phang}{cmdab:save(}{it:{help filename}}{cmd:)} saves the balance table to file on disk using {it:filename}. This 
	command cannot be used in combinaton with {cmd:browse}. {p_end}

{phang}{cmdab:browse} displays the table in the browse window instead of saving it to file. This command cannot be 
	used in combinaton with {cmd:save()}. WARNING: Note that this option clears the data currently in working memory. Either
	save your data before using this command, use {help preserve:preserve/restore} or {help tempfile:tempfiles} to 
	not lose data.{p_end}

{pstd}{it:    {ul:{hi:Optional options}}}{p_end}

{pstd}{it:    Columns and order of columns options:}{p_end}

{phang}{cmdab:co:ntrol(}{it:groupcode}{cmd:)} specifies one group that is the control group that all other groups 
are tested against for difference in means and where {it:groupcode} is an integer used in {cmd:grpvar(}{it:varname}{cmd:)}.
The default is that all groups are tested against each other. The control group will be listed first 
(leftmost) in the table unless another order is specified in {cmd:order()}.{p_end}
	
{phang}{cmdab:or:der(}{it:groupcodelist}{cmd:)} manually sets the column order of the groups in the table. {it:groupcodelist} is
 a list of integers used in {cmd:grpvar(}{it:varname}{cmd:)}. The default order is ascending order of the group 
 codes in {cmdab:grpv:ar(}{it:varname}{cmd:)}. Any groups omitted from this option will, in ascending order, 
 follow the groups included.{p_end}
	
{phang}{cmdab:tot:al} includes a column with descriptive stats on all groups combined.{p_end}

{pstd}{it:Column and row labels:}{p_end}

{phang}{cmdab:grpc:odes} makes the integers for the group codes in {cmd:grpvar(}{it:varname}{cmd:)} the group column titles. The default 
is to use the value labels used in {cmdab:grpv:ar(}{it:varname}{cmd:)}. If no value labels are used, then this option does 
not make a difference.{p_end}

{phang}{cmdab:grpl:abels(}{it:codetitlestring}{cmd:)} manually sets the group column titles. {it:codetitlestring} is a string 
on the following format {it:"code1 title1 @ code2 title2 @ code3 title3"} etc. where code1, code2 etc. are group codes used 
in {cmd:grpvar(}{it:varname}{cmd:)} and title1, title2 etc. are the corresponding titles. The character "@" may not be used 
in any of the titles. Codes omitted from this option will be assigned a column title as if this option was not used. This option
has precedence over {cmd:grpcodes} when used together, meaning that group codes are only used for groups that are not included
in the {it:codetitlestring}. The title can consist of several words. Everything that follows the code until the end of a string 
or a "@" will be included in the title.{p_end}

{phang}{cmdab:totall:abel(}{it:string}{cmd:)} manually sets the column title for the total column.{p_end}

{phang}{cmdab:rowv:arlabels} use the variable labels instead of variable name as row titles. The default is to use the 
variable name. For variables with no variable label defined, the variable name is used regerdless.{p_end}

{phang}{cmdab:rowl:abels(}{it:nametitlestring}{cmd:)} manually sets the row titles for each of the balance variables in the 
table. {it:nametitlestring} is a string in the following format {it:"name1 title1 @ name2 title2 @ name3 title3"} etc. where
 name1, name2 etc. are variable names and title1, title2 etc. are the corresponding row titles. The character "@" may not 
 be used in any of the titles. Variables omitted from this option are assigned a row title as if this option was not used. This option
has precedence over {cmd:rowvarlabels} when used together, meaning that variable labels are only used for variables that are not included
in the {it:nametitlestring}. The title can consist of several words. Everything that follows the variable name until the end
 of a string or a "@" will be included in the title.{p_end}

{pstd}{it:    Statistics and data modification:}{p_end}

{phang}{cmdab:missz:ero} makes the command treat all missing values in balance variables as zeros. Stata always drops observations with 
missing values in the dependent variable or in any of the independent variables when estimating a regression. This option tells this 
command to interpret all missing values in the balance variables as zero. That will make it possible to include the observations with 
missing values in the balance table. WARNING: while technically possible it is far from certain this option generates a valid result. 
There is no guarantee that a missing value can correctly be assumed to be zero without making the interpretation of the balance table invalid.{p_end}

{phang}{cmdab:missr:egzero} makes the command treat all regular missing values in balance variables as zeros. See {cmd:misszero} for details and warning. 
The difference is that this option still treats {help missing:extended missing values} as missing, but regular missing values are assumed to be zero.{p_end}

{phang}{cmdab:vce:(}{it:{help vce_option:vce_types}{cmd:)}} sets the type of variance estimator to be used in all regressions for this 
command. See {help vce_option:vce_types} for more details. The only vce types allowed in this command are robust, cluster or bootstrap.{p_end}

{phang}{cmdab:fix:edeffect(}{it:varname}{cmd:)}includes the variable specified as fixed effects in the regressions for t-tests (and 
for F-tests if applicable). See the description section above for details on how the fixed effects are included in the estimation regressions. 
The variable specified must be a numeric variable. Only one varaible may be specified. See {help egen:egen group} for 
help on creating a single variable with an integer representing each category from string variables and/or multiple variables.{p_end}

{phang}{cmdab:cov:ariates(}{it:{help varlist}{cmd:)}} includes the variables specified in the regressions for t-tests (and for
F-tests if applicable) as covariate variables (control variables). See the description section above for details on how the covariates
 are included in the estimation regressions. The covariate variables must be numeric variables.{p_end}

{phang}{cmd:covarmissok} allows for observations to be dropped due to missing values in covariate variables. Stata always drops observations 
with missing values in at least one the variables used in a regression. This command throws an error if any observation has missing 
values in any of the variables specified in {cmd:covariates()}. To suppress that error, use this option and therby accept that some observations 
are excluded from the balance table. Also see {cmd:covmisszero} and {cmd:covmissregzero} for other solutions to this issue.{p_end}

{phang}{cmdab:covmissz:ero} makes the command treat all missing values in covariate variables as zeros. See {cmd:misszero} for more
details and the warning that applies to this command as well.{p_end}

{phang}{cmdab:covmissr:egzero} makes the command treat all regular missing values in covariate variables as zeros. See {cmd:misszero} for more
details and the warning that applies to this command as well. The difference from {cmd:covmisszero} that this option still treat {help missing:extended missing values} as 
missing, but regular missing values are assumed to be zero.{p_end}

{pstd}{it:    F-test:}{p_end}

{phang}{cmdab:ft:est} includes an F-test for joint significance across all balance variables. See the description section above for details on how the F-test estimation 
regressions are specified. All options specified in the {it:Statistics and data modification} section above, also applies to the F-tests.{p_end}

{phang}{cmdab:fm:issok} suppress the error caused by missing values in any of the balance variables in the F-test. Stata always drops observations 
with missing values in at least one the variables used in a regression. This command throws an error if any observation has missing 
values in any of the balance variables. To suppress that error, use this option and therby accept that some observations 
are excluded from F-tests. Also see {cmd:misszero} and {cmd:missregzero} for other solutions to this issue.{p_end}

{phang}{cmd:fnoobs} excludes the row with number of observations in the F-test regressions from displaying in the table.{p_end}

{pstd}{it:Table display options:}{p_end}

{phang}{cmdab:pt:test} makes this command show p-values instead of difference-in-mean between the groups in the column for t-tests.{p_end}

{phang}{cmdab:pf:test} makes this command show p-values instead of F-statistics in the row for F-tests.{p_end}

{phang}{cmdab:pb:oth} is identical to specifying both {cmd:pttest} and {cmd:pftest}.{p_end}

{phang}{cmdab:star:levels(}{it:{help numlist:numlist}}{cmd:)} manually sets the three significance levels 
used for significance stars. Use decimals in descending order. The default is (.1 .05 .01) where .1 corresponds 
to one star, .05 to two stars and .01 to three stars.{p_end}

{phang}{cmdab:starsno:add} makes the command not add any stars to the table. This option makes the most sense in combination 
with {cmd:pttest}, {cmd:pftest} or {cmd:pboth} but is possible to use by itself as well.{p_end}

{phang}{cmdab:form:at(}{it:{help format:%fmt}}{cmd:)} applies the Stata formats specified to all values outputted
in the table. All values apart from integers, for example number of observations, for which the format is always %9.0f.{p_end}

{phang}{cmdab:tbln:ote(}{it:string}{cmd:)} adds a manually entered note to the bottom of the table. This note will 
be added in addition to the notes automtcally generated by the command unless {cmd:tblnonote} is specified, then 
only this manually entered note will be added to the table.{p_end}

{phang}{cmdab:notec:ombine} combines all notes (manually entered or automatically generated) into one row. The default
 is that each note is added on one separate row per note.{p_end}

{phang}{cmdab:tblnon:ote} makes this command not add any of the notes automatically generated by the command to the
 table. Manually entered notes in {cmd:tblnote()} will still be added to the table.{p_end}

{pstd}{it:    Export and browse options:}{p_end}

{phang}{cmd:replace} allows for the file in {cmd:save()} to be overwritten if the file already exist on disk.{p_end}

{phang}{cmdab:savebr:owse} views the table in the browser window similarly to {cmd:browse} after saving the table to file using {cmd:save}.{p_end}

	
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
 the row title will be "Outcome variable 1", and instead of outcome2 the rowtitle will be "Second outcome variable". For balance variable 
 outcome3 that is not included in {cmd:rowlabels()}, the command will use the variable label defined for outcome3 as row title since 
 option {cms:rowarlabels} was specified. If outcome3 does not have any row variable defined, then the variable name will be used 
 as row title, just like the default.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}John Dundas{break}
	
{title:Author}

{phang}Kristoffer Bjärkefur, The World Bank, DECIE{break}
         Please email bug-reports, suggestions and requests for clarifications 
		 writing "ietools iebaltab" in the subject line to:{break}
		 kbjarkefur@worldbank.org


