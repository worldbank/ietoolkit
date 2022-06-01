{smcl}
{* 5 Nov 2019}{...}
{hline}
help for {hi:iebaltab}
{hline}

{title:Title}

{phang2}{cmdab:iebaltab} {hline 2} produces balance tables with multiple groups or treatment arms

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Iebaltab":DIME Wiki}.

{title:Syntax}

{phang2}
{cmd:iebaltab} {it:balancevarlist} [{help if:if}] [{help in:in}] [{help weight}]
, {opt grpv:ar(varname)} [
{it:{help iebaltab##columnoptions:column_options}}
{it:{help iebaltab##regoptions:regression_options}}
{it:{help iebaltab##displayoptioins:display_options}}
{it:{help iebaltab##labeloptions:label_options}}
{it:{help iebaltab##exportoptions:export_options}}
{it:{help iebaltab##latexoptions:latex_options}}
]

{phang2}where {it:balancevarlist} is one or several continuous or binary variables (from here on called balance variables) for which the command
will test for differences across the categories in grpvar({it:varname}). See note on non-binary categorical balance variables in the description section below.

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{pstd}{it:    {ul:{hi:Required options:}}}{p_end}

{synopt :{opth grpv:ar(varname)}}Variable indicating groups (or treatment arms){p_end}

{pstd}{it:    {ul:{hi:Optional options}}}{p_end}

{marker columnoptions}{...}
{synopthdr:Columns options}
{synopt :{opt co:ntrol(groupcode)}}Indicate a single group that all other groups are tested against. Default is all groups are tested against each other.{p_end}
{synopt :{opt or:der(groupcodelist)}}Manually set the order the groups appear in the table. Default is ascending. See details on {it:groupcodelist} below.{p_end}
{synopt :{opt tot:al}}Include descriptive stats on all observations included in the table.{p_end}

{marker regoptions}{...}
{synopthdr:Regression options}
{synopt :{opth vce:(vce_option:vce_types)}}Options for variance estimation.{p_end}
{synopt :{opth fix:edeffect(varname)}}Include fixed effects in the regressions for t-tests (and for F-tests if applicable){p_end}
{synopt :{opth cov:ariates(varlist)}}Include covariates (control variables) in the regressions for t-tests (and for F-tests if applicable){p_end}
{synopt :{opt ft:est}}Include a row with the F-test for joint significance across all balance variables{p_end}
{synopt :{opt feqt:est}}Include a row with the F-test for joint significance across all groups for each variable {p_end}

{marker displayoptions}{...}
{synopthdr:Table display options}
{synopt :{cmd:stats(}{it:{help iebaltab##statstr:stats_string}}{cmd:)}}Specify which statistics to display in the tables.{p_end}
{synopt :{opt onerow}}Write number of observations (and number of clusters if applicable) in one row at the bottom of the table.{p_end}
{synopt :{opth star:levels(numlist)}}Manually set the three significance levels used for significance stars{p_end}
{synopt :{opt starsno:add}}Do not add any stars to the table{p_end}
{synopt :{opth form:at(format:%fmt)}}Apply Stata formats to the values outputted in the table{p_end}
{synopt :{opt tbln:ote(string)}}Replace the default note at the bottom of the table{p_end}
{synopt :{opt tbladdn:ote(string)}}Add note to the default note at the bottom of the table{p_end}
{synopt :{opt tblnon:ote}}Suppresses any note at the bottom of the table{p_end}

{marker labeloptions}{...}
{synopthdr:Row/col label options}
{synopt :{opt grpc:odes}}Use the values in the {opt grpvar()} variable as column titles even if the variable has value labels.{p_end}
{synopt :{opt grpl:abels(codetitles)}}Manually set the group column titles. See details on {it:codetitles} below.{p_end}
{synopt :{opt totall:abel(string)}}Manually set the title of the total column.{p_end}
{synopt :{opt rowv:arlabels}}Use the variable labels instead of variable name as row titles.{p_end}
{synopt :{opt rowl:abels(nametitles)}}Manually set the row titles. See details on {it:nametitles} below.{p_end}

{marker exportoptions}{...}
{synopthdr:Export options}
{synopt :{opt browse}}View the table in the data browser{p_end}
{synopt :{opth savex:lsx(filename)}}Save table to Excel file on disk.{p_end}
{synopt :{opth savec:sv(filename)}}Save table to csv-file on disk{p_end}
{synopt :{opth savet:ex(filename)}}Save table to LaTeX file on disk{p_end}
{synopt :{opth texnotefile(filename)}}Save table note in a separate LaTeX file on disk{p_end}
{synopt :{opt replace}}Replace file on disk if the file already exists{p_end}

{marker latexoptions}{...}
{synopthdr:LaTeX options}
{synopt :{opth texn:otewidth(numlist)}}Manually adjust width of note{p_end}
{synopt :{opt texc:aption(string)}}Specify LaTeX table caption{p_end}
{synopt :{opt texl:abel(string)}}Specify LaTeX label{p_end}
{synopt :{opt texdoc:ument}}Creates a stand-alone LaTeX document{p_end}
{synopt :{opt texvspace(string)}}Manually set size of the line space between two rows on LaTeX output{p_end}
{synopt :{opt texcolwidth(string)}}Limit width of the first column on LaTeX output{p_end}

{synoptline}

{title:Description}

{pstd}{cmd:iebaltab} is a command that generates balance tables (difference-in-means tables).
The command tests for statistically significant difference in the balance variables between
the categories defined in the {opt grpvar(varname)}. The command can either test one control group
against all other groups, using the {opt control(groupcode)} option,
or test all groups against each other. The command also allows for
fixed effects, covariates and different types of variance estimators.{p_end}

{pstd}The balance variables are expected to be continuous or binary variables.
Categorical variables (for example 1=single, 2=married, 3=divorced) will not
generate an error but will be treated like a continuous variable
which is most likely statistically invalid.
Consider converting each category to binary variables.{p_end}

{pstd}The command also attaches notes to the bottom of the table that
documents how the command was specified, what fixed effects and covariates were used (if any),
what level of significance was used etc.
This automatic note is meant to be used during explorative analysis only and
be replaced with a manual note suitable for publication using {opt tblnote(string)}.{p_end}

{title:Options (detailed descriptions)}

{pstd}{it:{ul:{hi:Required options:}}}{p_end}

{phang}{opth grpv:ar(varname)} specifies the variable indicating groups (or treatment arms) across which
	the command will test for difference in mean of the balance var. The group variable can only be one variable and
	it must be numeric and may only hold integers. See {help egen:egen group} for help on creating a single variable with
	an integer representing each category from string variables and/or multiple variables. Observations with missing values
	in this variable will be excluded when running this command.

{pstd}{it:{ul:{hi:Optional options}}}{p_end}

{pstd}{it:Columns options:}{p_end}

{phang}{opt co:ntrol(groupcode)} specifies one group that is the control group that all other groups
are tested against for difference in means and where {it:groupcode} is an integer used in {opt grpvar()}.
The default is that all groups are tested against each other. The control group will be listed first
(leftmost) in the table unless another order is specified in {opt order()}.
When using {opt control()} the order if the pair in the pair-wise are (non-control)-(control)
so that a positive statistic (for example {it:diff} or {it:beta}) indicates that
the mean for the non-control is larger than for the control.{p_end}

{phang}{opt or:der(groupcodelist)} manually sets the column order of the groups in the table. {it:groupcodelist} may
be any or all of the values in the group variable specified in {opt grpvar()}.
The default order if this option is omitted is ascending order of the values in the group variable.
Any values omitted from this option will be sorted in ascending order after the values included.{p_end}

{phang}{opt tot:al} includes a column with descriptive stats on the full sample.{p_end}

{pstd}{it:Regression options:}{p_end}

{phang}{opth vce:(vce_option:vce_types)} sets the type of variance estimator to be used in all regressions for this
command. See {help vce_option:vce_types} for more details, but the only types allowed in this command are {hi:robust}, {hi:cluster} {it:clustervar} or {hi:bootstrap}. See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how these vce types are included in the regression.{p_end}

{phang}{opth fix:edeffect(varname)} specifies a single variable to be used as fixed effects in all regressions
part from descriptive stats regressions.
The variable specified must be a numeric variable.
If more than one variable is needed as fixed effects, and it is not desirable to combine multiple variables into one
(using for example {help egen:egen group}),
then they can be included using the {opt i.} notation in the {opt covariates()} option.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how the fixed effects are included in the regressions.{p_end}

{phang}{opth cov:ariates(varlist)}} includes the variables specified in the regressions for t-tests (and for
F-tests if applicable) as covariate variables (control variables). See the description section above for details on how the covariates
are included in the estimation regressions. The covariate variables must be numeric variables.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how the covariates are included in the regressions.{p_end}

{phang}{opt ft:est} add a single row in the table with one F-test for each test pair,
testing for joint significance across all balance variables.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how these tests are estimated.{p_end}

{phang}{opt feqt:est} adds a single column in the table with an F-test for each balance variable,
testing for joint significance across all groups in {opt grpvar()}.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how these tests are estimated.{p_end}

{pstd}{it:Table display options:}{p_end}

{marker statstr}{...}
{phang}{cmd:stats(}{it:{help iebaltab##statstr:stats_string}}{cmd:)}} is the option where which statistics to display are specified. The {it:stats_string} is expected to be on this format (where at least one of the sub-arguements
{opt desc}, {opt pair}, {opt f} and {opt feq} are required): {cmd: stats(desc({it:desc_stats}) pair({it:pair_stats}) f({it:f_stats}) feq({it:feq_stats))}}.
The table below lists the valid values for {it:desc_stats}, {it:pair_stats}, {it:f_stats} and {it:feq_stats}.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how these values are estimated/calculated.{p_end}

{p2colset 9 21 23 0}{...}
{p2col:{it:desc_stats:}}{cmd:se var sd}{p_end}
{p2col:{it:pair_stats:}}{cmd:diff beta t p nrmd nrmb se sd none}{p_end}
{p2col:{it:f_stats:}}{cmd:f p}{p_end}
{p2col:{it:feq_stats:}}{cmd:f p}{p_end}

{phang}{opt onerow} displays the number of observations in an additional row at the bottom of the table.
If some number of observations are not identical within a column this option throws an error.
This also applies to number of clusters.
If not specified, the number of observations (and clusters) per variable per group
is displayed on the same row in additional column besides the mean value.{p_end}

{phang}{opth star:levels(numlist)} manually sets the three significance levels
used for significance stars. Use decimals in descending order. The default is (.1 .05 .01) where .1 corresponds
to one star, .05 to two stars and .01 to three stars.{p_end}

{phang}{opt starsno:add} makes the command not add any stars to the table. This option makes the most sense in combination
with {cmd:pttest}, {cmd:pftest} or {cmd:pboth} but is possible to use by itself as well.{p_end}

{phang}{opth form:at(format:%fmt)} applies the Stata formats specified to all values outputted
in the table. All values apart from integers, for example number of observations, for which the format is always %9.0f.{p_end}

{phang}{opt tbln:ote(string)} replaces the default note at the bottom of the table with this manually entered string.{p_end}

{phang}{opt tbladdn:ote(string)} adds the manually entered string to the deafult note at the bottom of the table.{p_end}

{phang}{opt tblnon:ote} makes this command not add any automatically generated or manually specified notes to the table.{p_end}

{pstd}{it:Column and row labels:}{p_end}

{phang}{opt grpc:odes}} makes the integers for the group codes in {cmd:grpvar(}{it:varname}{cmd:)} the group column titles. The default
is to use the value labels used in {cmdab:grpv:ar(}{it:varname}{cmd:)}. If no value labels are used, then this option does
not make a difference.{p_end}

{phang}{opt grpl:abels(codetitles)} manually sets the group column titles. {it:codetitles} is a string
on the following format {it:"code1 title1 @ code2 title2 @ code3 title3"} etc. where code1, code2 etc. are values for each group used
in {opt grpvar()} and title1, title2 etc. are the corresponding titles. The character "@" may not be used
in any of the titles. Codes omitted from this option will be assigned a column title as if this option was not used. This option
has precedence over {cmd:grpcodes} when used together, meaning that group codes are only used for groups that are not included
in the {it:codetitlestring}. The title can consist of several words. Everything that follows the code until the end of a string
or a "@" will be included in the title.{p_end}

{phang}{opt totall:abel(string)}} manually sets the column title for the total column.{p_end}

{phang}{opt rowv:arlabels} use the variable labels instead of variable name as row titles. The default is to use the
variable name. For variables with no variable label defined, the variable name is used regardless.{p_end}

{phang}{opt rowl:abels(nametitles)} manually sets the row titles for each of the balance variables in the
table. {it:nametitles} is a string in the following format {it:"name1 title1 @ name2 title2 @ name3 title3"} etc. where
name1, name2 etc. are variable names and title1, title2 etc. are the corresponding row titles. The character "@" may not
be used in any of the titles. Variables omitted from this option are assigned a row title as if this option was not used. This option
has precedence over {cmd:rowvarlabels} when used together, meaning that variable labels are only used for variables that are not included
in the {it:nametitlestring}. The title can consist of several words. Everything that follows the variable name until the end
of a string or a "@" will be included in the title.{p_end}

{pstd}{it:Export options:}{p_end}

{phang}{opt  browse} views the table in the browser window similarly to {opt browse} instead of saving the table to disk.{p_end}

{phang}{opth savex:lsx(filename)} exports the table to an Excel (.xsl/.xlsx) file and saves it on disk.{p_end}

{phang}{opth savec:sv(filename)} exports the table to a comma seperated (.csv) file and saves it on disk.{p_end}

{phang}{opth savet:ex(filename)} exports the table to a LaTeX (.tex) file and saves it on disk.{p_end}

{phang}{opth texnotefile(filename)} exports the table note in a separate LaTeX file on disk.
This allows importing the table using the {it:threeparttable} LaTeX package which
is an easy way to make sure the note always has the same width as the table.
See example in the example section below.{p_end}

{phang}{opt replace} allows for the file in {opt savexlsx()}, {opt savexcsv()} or {opt savetex()} to be overwritten if the file already exist on disk.{p_end}

{pstd}{it:LaTeX options:}{p_end}

{phang}{opth texn:otewidth(numlist)} manually adjusts the width of the note to fit the size of the table.
The note width is a multiple of text width. If not specified, default is one, which makes the table width equal to text width.
Consider also using {opth texnotefile()} and the LaTeX package {it:threeparttable}.{p_end}

{phang}{opt texc:aption(string)} writes table's caption in LaTeX file. Can only be used with option {opt texdocument}.{p_end}

{phang}{opt texl:abel(string)} specifies table's label, used for meta-reference across LaTeX file. Can only be used with option {opt texdocument}.{p_end}

{phang}{opt texdoc:ument}  creates a stand-alone LaTeX document that can be readily compiled, without the need to import it to a different file.
As default, {opt savetex()} creates a fragmented LaTeX file consisting only of a tabular environment.
This fragment is then meant to be importet to a main LaTeX file that holds text and imports other tables.{p_end}

{phang}{opt texvspace(string)} sets the size of the line space between table rows. {it:string} must consist of a numeric value
and one of the following units: "cm", "mm", "pt", "in", "ex" or "em". Note that the resulting line space displayed will be equal to the
specified value minus the height of one line of text. Default is "3ex". For more information on units,
{browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX lengths manual}. {p_end}

{phang}{cmd:texcolwidth(}{it:string}{cmd:)} limits the width of table's first column so that a line break is added when a variable's name
or label is too long. {it:string} must consist of a numeric value and one of the following units: "cm", "mm", "pt", "in", "ex" or "em".
For more information on these units, {browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX lengths manual}. {p_end}

{marker est_defs}{...}
{title:Estimation definitions and display options}

{pstd}This section details regressions are used to estimate
the statistics displayed in the in the generated balance tables.
For each test there is a {it:basic form} example to highlight the core of the test,
and an {it:all options} example that shows exactly how all options are applied.
Here is a glossary for the terms used in this section:{p_end}

{p2colset 5 23 23 0}{...}
{p2col:{it:balance variable}}The variables listed as {it:balancevarlist}{p_end}
{p2col:{it:groupvar}}The variable specified in {opt grpvar(varname)}{p_end}
{p2col:{it:group code}}Each value in {it:groupvar}{p_end}
{p2col:{it:test pair}}Combination of {it:group codes} to be used in pair wise tests{p_end}
{p2col:{it:test pair dummy}}A dummy variable where the first {it:group code} in a {it:test pair}
has the value 1 and the second {it:group code} has the value 0,
and all other observations has missing values.{p_end}


{pstd}{ul:{it:Group descriptive statistics}}{break}
Descriptive statistics for all groups are always displayed in the table.
If option {opt total} is used then these statistics are also calculated on the full sample.
For each balance variable and for each value group code,
the descriptive statistics is calculated using the following code:{p_end}

{pstd}{it:basic form:}
{break}{input:reg balancevar if groupvar = groupcode}{p_end}

{pstd}{it:all options:}
{break}{input:reg balancevar if groupvar = groupcode weights, vce(vce_option)}{p_end}

{pstd}{it:Statistics displayed in table:}{p_end}
{p2colset 5 12 14 0}{...}
{p2col:{it:mean}}Always displayed. Retrieved from {cmd:_b[cons]} after {cmd:reg}.{p_end}
{p2col:{it:se}}Displayed if {cmd: stats(desc(se))} is specified (default if nothing specified). Retrieved from {cmd:_se[cons]} after {cmd:reg}.{p_end}
{p2col:{it:var}}Displayed if {cmd: stats(desc(var))} is specified. Calculated as {cmd:e(rss)/e(df_r)} after {cmd:reg}{p_end}
{p2col:{it:sd}}Displayed if {cmd:stats(desc(sd))} is specified. Calculated as {cmd:_se[_cons] * sqrt(e(N))} after {cmd:reg}{p_end}

{pstd}{ul:{it:Pair-wise test statistics}}{break}
Pair-wise test statistics is always displayed in the table unless {cmd:stats(pair({it:none}))} is used.
For each balance variable and for each test pair, this code is used.
Since observations not included in the test pair has missing values in the test pair dummy,
they are excluded from the regression without using an if-statement.

{pstd}{it:basic form:}
{break}{input:reg balancevar testpairdummy}
{break}{input:test testgroupdummy}{p_end}

{pstd}{it:all options:}
{break}{input:reg balancevar testpairdummy covariates i.fixedeffect weights, vce(vce_option)}
{break}{input:test testgroupdummy}{p_end}

{pstd}{it:Statistics displayed in table:}{p_end}
{p2colset 5 12 14 0}{...}
{p2col:{it:diff}}Displayed if {cmd:stats(pair(diff))} is specified (default if nothing specified). Calculated as the mean of first group minus the mean of the second group. Means as from the descriptive statistics explained above.{p_end}
{p2col:{it:beta}}Displayed if {cmd:stats(pair(beta))} is specified. Retrieved from {cmd:e(b)[1,1]} after {cmd:reg}.{p_end}
{p2col:{it:t}}Displayed if {cmd:stats(pair(t))} is specified. Calculated as {cmd:_b[testpairdummy]/_se[testpairdummy]} after {cmd:reg}.{p_end}
{p2col:{it:p}}Displayed if {cmd:stats(pair(p))} is specified. Retrieved from {cmd:e(p)} after {cmd:test}{p_end}
{p2col:{it:nrmd}}Displayed if {cmd:stats(pair(nrmd))} is specified. Calculated as {cmd: diff/sqrt(.5*(var_code1+var_code2))} where diff is the same as diff in this table, and var_code1 and var_code2 are the variance from group 1 and 2 as described in the descriptive statistics section.{p_end}
{p2col:{it:nrmb}}Displayed if {cmd:stats(pair(nrmb))} is specified. Calculated as {cmd: beta/sqrt(.5*(var_code1+var_code2))} where beta is the same as beta in this table, and var_code1 and var_code2 are the variance from group 1 and 2 as described in the descriptive statistics section.{p_end}
{p2col:{it:se}}Displayed if {cmd:stats(pair(se))} is specified. Retrieved from {cmd:_se[testpairdummy]} after {cmd:reg}.{p_end}
{p2col:{it:sd}}Displayed if {cmd:stats(pair(sd))} is specified. Calculated as {cmd:_se[testpairdummy] * sqrt(e(N))} after {cmd:reg}.{p_end}

{pstd}{ul:{it:F-test statistics for balance across all groups}}{break}
Dipslayed in the table if the option {opt feqtest} is used.
For each balance variable this code is used.
{it:feqtestinput} is a list on the format
{input:x2.groupvar=x3.groupvar...xn.groupvar=0}, where {input:x2}, {input:x3} ... {input:xn},
represents all group codes apart from the first code.

{pstd}{it:basic form:}
{break}{input:reg balancevar i.groupvar}
{break}{input:test feqtestinput}{p_end}

{pstd}{it:all options:}
{break}{input:reg balancevar i.groupvar covariates i.fixedeffect weights, vce(vce_option)}
{break}{input:test feqtestinput}{p_end}

{pstd}{it:Statistics displayed in table:}{p_end}
{p2colset 5 12 14 0}{...}
{p2col:{it:f}}Displayed if {cmd: stats(feq(f))} is specified (default if nothing specified). Retrieved from {cmd:r(F)} after {cmd:test}.{p_end}
{p2col:{it:p}}Displayed if {cmd: stats(feq(p))} is specified. Retrieved from {cmd:r(p)} after {cmd:test}.{p_end}

{pstd}{ul:{it:F-test statistics for balance across all balance variables}}{break}
Displayed if option {opt ftest} is used.
For each test pair the following code is used.

{pstd}{it:basic form:}
{break}{input:reg testgroupdummy balancevars }
{break}{input:testparm balancevars}{p_end}

{pstd}{it:all options:}
{break}{input:reg testgroupdummy balancevars covariates i.fixedeffect weights, vce(vce_option)}
{break}{input:testparm balancevars}{p_end}

{pstd}{it:Statistics displayed in table:}{p_end}
{p2colset 5 12 14 0}{...}
{p2col:{it:f}}Displayed if {cmd: stats(feq(f))} is specified (default if nothing specified). Retrieved from {cmd:r(F)} after {cmd:testparm}.{p_end}
{p2col:{it:p}}Displayed if {cmd: stats(feq(p))} is specified. Retrieved from {cmd:r(p)} after {cmd:testparm}.{p_end}

{title:Examples}

{pstd} {hi:Example 1.}

{phang2}{inp:iebaltab {it:outcome_variable}, grpvar({it:treatment_variable}) browse}{p_end}

{pmore}In the example above, let's assume that {it:treatment_variable} is a variable that is 0 for observations in
 the control group, and 1 for observations in the treatment group. Then in this example, the command will
 show the mean of {it:outcome_variable} and the standard error of that mean for the control group and the treatment
 group separately, and it will show the difference between the two groups and test if that difference is statistically significant.


{pstd} {hi:Example 2.}

{phang2}{inp:global project_folder "C:\Users\project\baseline\results"}{p_end}
{phang2}{inp:iebaltab {it:outcome_variable}, grpvar({it:treatment_variable}) savexlsx("$project_folder\balancetable.xlsx")}{p_end}

{pmore}The only difference between example 1 and this example is that in this example the table is saved to file instead of being shown in the browser window.{p_end}

{pstd} {hi:Example 3.}

{phang2}{inp:iebaltab {it:outcome1 outcome2 outcome3}, grpvar({it:treatment_variable}) savexlsx({it:"$project_folder\balancetable.xlsx"}) rowvarlabels rowlabels({it:"outcome1 Outcome variable 1 @ outcome2 Second outcome variable"})}{p_end}

{pmore}Example 3 builds on example 2. There are now 3 variables listed as balance variables. In option {opt rowlabels()} two
 of those balance variables have been given a new label to be displayed as row title instead of the variable name. Instead of outcome1
 the row title will be "Outcome variable 1", and instead of outcome2 the row title will be "Second outcome variable". For balance variable
 outcome3 that is not included in {cmd:rowlabels()}, the command will use the variable label defined for outcome3 as row title since
 option {cms:rowarlabels} was specified. If outcome3 does not have any row variable defined, then the variable name will be used
 as row title, just like the default.{p_end}

 {pstd} {hi:Example 4.}

{phang2}{inp:global project_folder "C:\Users\project\baseline\results"}{p_end}
{phang2}{inp:iebaltab {it:outcome_variable}, grpvar({it:treatment_variable}) savetex({it:"$project_folder\balancetable.tex"}) texcolwidth({it:"$project_folder\balancetable_note.tex"})}{p_end}

{pmore}In example 4 the table is exported to the file {it:"$project_folder\balancetable.tex"}
but the table note is exported to {it:"$project_folder\balancetable_note.tex"}.
This allows you to import your table and note like this in your LaTeX code
which is a an easy way to align your table note with the rest of the table.
Something that is surprisingly difficult.

	{input}
	\begin{table}
	  \centering
	  \caption{Balance table}
	  \begin{adjustbox}{max width=\textwidth}
	    \begin{threeparttable}[!h]
		  \input{./balancetable.tex}
		  \begin{tablenotes}[flushleft]
		    \item\hspace{-.25em}\input{./balancetable_note.tex}
		  \end{tablenotes}
	    \end{threeparttable}
	  \end{adjustbox}
	\end{table}
	{text}

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
