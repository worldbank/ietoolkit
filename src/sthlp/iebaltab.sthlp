{smcl}
{* *! version 0.0 20240404}{...}
{hline}
{pstd}help file for {hi:iebaltab}{p_end}
{hline}

{title:Title}

{phang}{bf:iebaltab} - produces balance tables with multiple groups or treatment arms
{p_end}

{title:Syntax}

{phang}{bf:iebaltab} {it:balance_varlist} [if] [in] [weight], {bf:{ul:group}var}({it:varname}) [ {it:column/row_options} {it:estimation_options} {it:stat_display_options} {it:labe/notel_options} {it:export_options} {it:latex_options} ]
{p_end}

{phang}where {it:balance_varlist} is one or several continuous or binary variables (from here on called balance variables) for which the command
will test for differences across the categories in {bf:groupvar}({it:varname}).
{p_end}

{phang}For a more descriptive discussion on the intended usage and work flow of this command please see the {browse "https://dimewiki.worldbank.org/Iebaltab":DIME Wiki}.
{p_end}

{dlgtab:Required options}

{synoptset 17}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:group}var}({it:varname})}Variable indicating the groups (ex. treatment arms) to test across{p_end}
{synoptline}

{dlgtab:Column and row option}

{synoptset 22}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:co}ntrol}({it:group_code})}Indicate a single group that all other groups are tested against. Default is all groups are tested against each other{p_end}
{synopt: {bf:{ul:or}der}({it:group_code_list})}Manually set the order the groups appear in the table. Default is ascending. See details on {it:group_code_list} below{p_end}
{synopt: {bf:{ul:tot}al}}Include descriptive stats on all observations included in the table{p_end}
{synopt: {bf:onerow}}Write number of observations (and number of clusters if applicable) in one row at the bottom of the table{p_end}
{synoptline}

{dlgtab:Estimation options}

{synoptset 20}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:vce}({it:vce_types})}Options for estimating variance. See below and {inp:help vce_options} for supported options{p_end}
{synopt: {bf:{ul:fix}edeffect}({it:varname})}Include fixed effects in the pair-wise regressions (and for F-tests if applicable){p_end}
{synopt: {bf:{ul:cov}ariates}({it:varlist})}Include covariates (control variables) in the pair-wise regressions (and for F-tests if applicable){p_end}
{synopt: {bf:{ul:ft}est}}Include a row with the F-test for joint significance across all balance variables for each test pair{p_end}
{synopt: {bf:{ul:feqt}est}}Include a column with the F-test for joint significance across all groups for each variable{p_end}
{synoptline}

{dlgtab:Statistics display options}

{synoptset 19}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:stats}({it:stats_string})}Specify which statistics to display in the tables. See options for {it:stats_string} below{p_end}
{synopt: {bf:{ul:star}levels}({it:numlist})}Manually set the three significance levels used for significance stars{p_end}
{synopt: {bf:{ul:nostar}s}}Do not add any stars to the table{p_end}
{synopt: {bf:{ul:form}at}({it:%fmt})}Apply Stata formats to the non-integer values outputted in the table. See {inp:help format} for format options.{p_end}
{synoptline}

{dlgtab:Label/notes option}

{synoptset 24}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:groupc}odes}}Use the values in the {inp:groupvar()} variable as column titles. Default is to use value labels if any{p_end}
{synopt: {bf:{ul:groupl}abels}({it:code_titles})}Manually set the group column titles. See details on {it:code_titles} below{p_end}
{synopt: {bf:{ul:totall}abel}({it:string})}Manually set the title of the total column{p_end}
{synopt: {bf:{ul:rowv}arlabels}}Use the variable labels instead of variable name as row titles{p_end}
{synopt: {bf:{ul:rowl}abels}({it:name_titles})}Manually set the row titles. See details on {it:name_titles} below{p_end}
{synopt: {bf:nonote}}Suppress the default not at the bottom of the table{p_end}
{synopt: {bf:addnote}({it:string})}Add a manual note to the bottom of the table{p_end}
{synoptline}

{dlgtab:Export options}

{synoptset 21}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:browse}}View table in the data browser{p_end}
{synopt: {bf:{ul:savex}lsx}({it:filename})}Save table to Excel file on disk{p_end}
{synopt: {bf:{ul:savec}sv}({it:filename})}Save table to csv-file on disk{p_end}
{synopt: {bf:{ul:savet}ex}({it:filename})}Save table to LaTeX file on disk{p_end}
{synopt: {bf:texnotefile}({it:filename})}Save table note in a separate LaTeX file on disk{p_end}
{synopt: {bf:replace}}Replace file on disk if the file already exists{p_end}
{synoptline}

{dlgtab:LaTeX options}

{synoptset 21}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:texn}otewidth}({it:numlist})}Manually adjust width of note{p_end}
{synopt: {bf:{ul:texc}aption}({it:string})}Specify LaTeX table caption{p_end}
{synopt: {bf:{ul:texl}abel}({it:string})}Specify LaTeX label{p_end}
{synopt: {bf:{ul:texdoc}ument}}Create a stand-alone LaTeX document{p_end}
{synopt: {bf:texcolwidth}({it:string})}Limit width of the first column on LaTeX output{p_end}
{synoptline}

{title:Description}

{pstd}{inp:iebaltab} is a command that generates balance tables (difference-in-means tables). 
The command tests for statistically significant difference in the balance variables between
the categories defined in the {inp:groupvar()}. The command can either test one control group 
against all other groups, using the {inp:control()} option, 
or test all groups against each other (the default). The command also allows for
fixed effects, covariates and different types of variance estimators.
{p_end}

{pstd}The balance variables are expected to be continuous or binary variables.
Categorical variables (for example 1=single, 2=married, 3=divorced) will not
generate an error but will be treated like a continuous variable
which is most likely statistically invalid.
Consider converting each category to binary variables.
{p_end}

{pstd}The command can also add a note to the bottom of the table.
The default note is not meant to be included in the final publication.
It includes technical information about how the command was specified.
This is helpful in the early stage of research where several specifications
are often explored, but should be replace with a more human readable note
in the final version.
{p_end}

{pstd}See the {it:Estimation/Statistics Definitions_
section below for a detailed documentation of what statistics this command
calculates and how they are calculated.
{p_end}

{title:Options}

{dlgtab:Required options}

{pstd}{bf:{ul:group}var}({it:varname}) specifies the variable indicating groups
(for example treatment arms) across which the command will
test for difference in mean of the balance variable.
The group variable can only be one variable and
it must be numeric and may only hold integers.
See {inp:group()} in {inp:help egen} for help on creating a single variable where 
each integer represents a category from string variables and/or multiple variables.
Observations with missing values in this variable will be excluded when running this command.
{p_end}

{dlgtab:Column and row options}

{pstd}{bf:{ul:co}ntrol}({it:group_code}) specifies one group that is the control group
that all other groups are tested against for difference in means and
where {it:group_code} is an integer used in {inp:groupvar()}. 
The default is that all groups are tested against each other.
The control group will be listed first (leftmost) in the table
unless another order is specified in {inp:order()}. 
When using {inp:control()} the order of the groups in the pair is (non-control)-(control) 
so that a positive statistic (in for example {it:diff} or {it:beta}) indicates that
the mean for the non-control is larger than for the control.
{p_end}

{pstd}{bf:{ul:or}der}({it:group_code_list}) manually sets the column order of the groups in the table. {it:group_code_list} may
be any or all of the values in the group variable specified in {inp:groupvar()}. 
The default order if this option is omitted is ascending order of the values in the group variable.
If any values in {inp:groupvar()} are omitted when using this option, 
they will be sorted in ascending order after the values included.
{p_end}

{pstd}{bf:{ul:tot}al} includes a column with descriptive statistics on the full sample.
This column still exclude observations with missing values in {inp:groupvar()}. 
{p_end}

{pstd}{bf:onerow} displays the number of observations in an additional row
at the bottom of the table. If the number of observations are not identical
across all rows within a column, then this option throws an error.
This also applies to number of clusters.
If not specified, the number of observations (and clusters) per variable per group
is displayed on the same row in an additional column
next to the descriptive statistics.
{p_end}

{dlgtab:Estimation options}

{pstd}{bf:vce}({it:vce_types}) sets the type of variance estimator
to be used in all regressions for this command.
See {inp:help vce_option} for more details. 
However, the types allowed in this command are only
{inp:robust}, {inp:cluster} {it:cluster_var} or {inp:bootstrap}. 
See the estimation definition section
for exact definitions on how these vce types are included in the regressions.
{p_end}

{pstd} {bf:{ul:fix}edeffect}({it:varname}) specifies a single variable to be used as fixed effects in all regressions
part from descriptive stats regressions.
The variable specified must be a numeric variable.
If more than one variable is needed as fixed effects, and it is not desirable to combine multiple variables into one
(using for example {inp:group()} in {inp:egen} - see {inp:help egen}), 
then they can be included using the {c -(}opt i.{c )-} notation in the {inp:covariates()} option. 
See the estimation definition section for exact definitions on how the fixed effects are included in the regressions.
{p_end}

{pstd}{bf:{ul:cov}ariates}({it:varlist}) includes the variables specified in the regressions for t-tests (and for
F-tests if applicable) as covariate variables (control variables). See the description section above for details on how the covariates
are included in the estimation regressions. The covariate variables must be numeric variables.
See the estimation definition section for exact definitions on how the covariates are included in the regressions.
{p_end}

{pstd}{bf:{ul:ft}est} adds a single row at the bottom of the table with
one F-test for each test pair, testing for joint significance across all balance variables.
See the estimation definition section for exact definitions on how these tests are estimated.
{p_end}

{pstd}{bf:{ul:feqt}est} adds a single column in the table with an F-test for each balance variable,
testing for joint significance across all groups in {inp:groupvar()}. 
See the estimation definition section for exact definitions on how these tests are estimated.
{p_end}

{dlgtab:Statistics display options}

{pstd}{bf:stats}({it:stats_string})
indicates which statistics to be displayed in the table.
The {it:stats_string} is expected to be on this format (where at least one of the sub-arguments {inp:desc}, {inp:pair}, {inp:f} and {inp:feq} are required): 
{p_end}

{input}{space 8}stats(desc(desc_stats) pair(pair_stats) f(f_stats) feq(feq_stats))
{text}
{pstd}The table below lists the valid values for
{it:desc_stats}, {it:pair_stats}, {it:f_stats} and {it:feq_stats}.
See the estimation definition section
for exact definitions of these values and how they are estimated/calculated.
{p_end}

{synoptset 10}{...}
{p2coldent:Type}Options{p_end}
{synoptline}
{synopt: {it:desc_stats}}{inp:se} {inp:var} {inp:sd}{p_end}
{synopt: {it:pair_stats}}{inp:diff} {inp:beta} {inp:t} {inp:p} {inp:nrmd} {inp:nrmb} {inp:se} {inp:sd} {inp:none}{p_end}
{synopt: {it:f_stats}}{inp:f} {inp:p}{p_end}
{synopt: {it:feq_stats}}{inp:f} {inp:p}{p_end}
{synoptline}

{pstd}{bf:{ul:star}levels}({it:numlist}) manually sets the
three significance levels used for significance stars.
Expected input is decimals (between the value 0 and 1) in descending order.
The default is (.1 .05 .01) where .1 corresponds
to one star, .05 to two stars and .01 to three stars.
{p_end}

{pstd} {bf:{ul:nostar}s} makes the command not add any stars to the table
regardless of significance levels.
{p_end}

{pstd}{bf:{ul:form}at}({it:%fmt}) applies the Stata formats specified to all values outputted
in the table apart from values that always are integers.
See {inp:help format} for format options 
Example of values that always are integers is number of observations.
For these integer values the format is always %9.0f.
The default for all other values when this option is not used is %9.3f.
{p_end}

{dlgtab:Label/notes option}

{pstd}{bf:{ul:groupc}odes} makes the integer values used for the group codes in
{inp:groupvar()} the group column titles. 
The default is to use the value labels used in {inp:groupvar()}. 
If no value labels are used for the variable in {inp:groupvar()}, 
then this option does not make a difference.
{p_end}

{pstd} {bf:{ul:groupl}abels}({it:code_titles}) manually sets the group column titles.
{it:code_titles} is a string on the following format:
{p_end}

{input}{space 8}grouplabels("code1 title1 @ code2 title2 @ code3 title3")
{text}
{pstd}Where code1, code2 etc. must correspond to the integer values used for each
group used in the variable {inp:groupvar()}, 
and title1, title2 etc. are the titles to be used for the corresponding integer value.
The character {inp:@} may not be used in any title. 
Codes omitted from this option will be assigned a column title
as if this option was not used.
This option takes precedence over {it:group_codes} when used together,
meaning that group codes are only used for groups
that are not included in the {it:code_title_string}.
The title can consist of several words.
Everything that follows the code until the end of a string
or a {inp:@} will be included in the title. 
{p_end}

{pstd}{bf:{ul:totall}abel}({it:string}) manually sets the column title for the total column.
{p_end}

{pstd}{bf:{ul:rowv}arlabels} use the variable labels instead of variable name as row titles.
The default is to use the variable name. For variables with no variable label defined,
the variable name is used as row label even when this option is specified.
{p_end}

{pstd}{bf:{ul:rowl}abels}({it:name_title_string}) manually sets the row titles for each
of the balance variables in the table. {it:name_title_string} is a string in the following format:
{p_end}

{input}{space 8}rowlabels("name1 title1 @ name2 title2 @ name3 title3")
{text}
{pstd}Where name1, name2 etc. are variable names used as balance variables,
and title1, title2 etc. are the titles to be used for the corresponding variable.
The character {inp:@} may not be used in any of the titles. 
Variables omitted from this option are assigned a row title as if this option was not used.
This option takes precedence over {inp:rowvarlabels} when used together, 
meaning that default labels are only used for variables
that are not included in the {it:name_title_string}.
The title can consist of several words.
Everything that follows the variable name until
the end of a string or a {inp:@} will be included in the title. 
{p_end}

{pstd}{bf:nonote} suppresses the default note that the command adds to
the bottom of the table with technical information
on how the command was specified.
This note is great during explorative analysis as it documents how
{inp:iebaltab} was specified to generate exactly that table. 
Eventually however, this note should probably be replaced with
a note more suitable for publication.
{p_end}

{pstd}{bf:addnote}({it:string}) adds the string provided in this option
to the note at the bottom of table.
If {inp:nonote} is not used, then this manually provided note 
is added to the end of the default note.
{p_end}

{dlgtab:Export options}

{pstd}{bf:browse} replaces the data in memory with the table
so it can be viewed using the command {inp:browse} instead of saving it to disk. 
This is only meant to be used during explorative analysis
when figuring out how to specify the command.
Note that this overwrites data in memory.
{p_end}

{pstd}{bf:{ul:savex}lsx}({it:filename}) exports the table to an Excel (.xsl/.xlsx) file and saves it on disk.
{p_end}

{pstd}{bf:{ul:savec}sv}({it:filename}) exports the table to a comma separated (.csv) file and saves it on disk.
{p_end}

{pstd}{bf:{ul:savet}ex}({it:filename}) exports the table to a LaTeX (.tex) file and saves it on disk.
{p_end}

{pstd}{bf:texnotefile}({it:filename}) exports the table note in a separate LaTeX file on disk.
When this option is used, no note is included in the {inp:savetex()} file. 
This allows importing the table using the {inp:threeparttable} LaTeX package which 
is an easy way to make sure the note always has the same width as the table.
See example in the example section below.
{p_end}

{pstd}{bf:replace} allows for the file in {inp:savexlsx()}, {inp:savexcsv()}, {inp:savetex()} or {inp:texnotefile()} 
to be overwritten if the file already exist on disk.
{p_end}

{dlgtab:LaTeX options}

{pstd}{bf:{ul:texn}otewidth}({it:numlist}) manually adjusts the width of the note
to fit the size of the table.
The note width is a multiple of text width.
If not specified, default is one, which makes the table width equal to text width.
However, when the table is resized when rendered in LaTeX
this is not always the same as the table width.
Consider also using {inp:texnotefile()} and the LaTeX package {inp:threeparttable}. 
{p_end}

{pstd}{bf:{ul:texc}aption}({it:string}) writes the table{c 39}s caption in LaTeX file.
Can only be used with option {inp:texdocument}. 
{p_end}

{pstd}{bf:{ul:texl}abel}({it:string}) specifies table{c 39}s label,
used for meta-reference across LaTeX file.
Can only be used with option {inp:texdocument}. 
{p_end}

{pstd}{bf:{ul:texdoc}ument} creates a stand-alone LaTeX document ready to be compiled.
The default is that {inp:savetex()} creates a fragmented LaTeX file 
consisting only of a tabular environment.
This fragment is then meant to be imported to a main LaTeX file
that holds text and may import other tables.
{p_end}

{pstd}{bf:texcolwidth}({it:string}) limits the width of table{c 39}s first column
so that a line break is added when a variable{c 39}s name or label is too long.
{c -(}it:string{c )-} must consist of a numeric value with one of the following units:
{c 34}cm{c 34}, {c 34}mm{c 34}, {c 34}pt{c 34}, {c 34}in{c 34}, {c 34}ex{c 34} or {c 34}em{c 34}.
For more information on these units,
{browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX length{c 39}s manual}.
{p_end}

{title:Estimation/statistics definitions}

{pstd}This section details the regressions that are used to estimate
the statistics displayed in the balance tables generated by this command.
For each test there is a {c 34}basic form{c 34} example to highlight the core of the test,
and an {c 34}all options{c 34} example that shows exactly how all options are applied.
Here is a glossary for the terms used in this section:
{p_end}

{synoptset 16}{...}
{p2coldent:Term}Definition{p_end}
{synoptline}
{synopt: {it:balance variable}}The variables listed as {it:balance_varlist}{p_end}
{synopt: {it:groupvar}}The variable specified in {inp:groupvar()}{p_end}
{synopt: {it:group_code}}Each value in {it:groupvar}{p_end}
{synopt: {it:test_pair}}Combination of {it:group codes} to be used in pair wise tests{p_end}
{synopt: {it:tp_dummy}}A dummy variable where 1 means that the obs{c 39} value in {inp:groupvar()} equals the first value in {it:test_pair}, 0 means it equals the second value, and missing means is matches neither{p_end}
{synoptline}

{pstd}Each section below has a table that shows how the stats are estimated/calculated for each type of statistics. This is what each column means.
A star (*) in the {it:Stat} column indicate that is the optional statistics displayed by default if the {inp:stats()} option is not used. 
The {it:Display option} column shows what sub-option to use in {inp:stats()} to display this statistic. 
The {it:Mat col} column shows what the column name in the result matrix for the column that stores this stat. See more about the result matrices in the {it:Result matrices} section.
{p_end}

{dlgtab:Group descriptive statistics}

{pstd}Descriptive statistics for all groups are always displayed in the table.
If option {inp:total} is used then these statistics are also calculated on the full sample. 
For each balance variable and for each value group code,
the descriptive statistics is calculated using the following code:
{p_end}

{pstd}Basic form:
{p_end}

{input}{space 8}reg balancevar if groupvar = groupcode
{text}
{pstd}All options:
{p_end}

{input}{space 8}reg balancevar if groupvar = groupcode weights, vce(vce_option)
{text}
{pstd}See above for description of each column in this table.
{it:gc} stands for {it:group_code} (see definition of {it:group_code} above).
If the option {inp:total} is used, 
then {it:gc} will also include {it:t} for stats on the full sample.
The last column shows how the command obtains the statistic in the Stata code.
These statistics are stored in
a the result matrix called {inp:r(iebtab_rmat)}. 
{p_end}

{col 4}{c TLC}{hline 9}{c TT}{hline 19}{c TT}{hline 9}{c TT}{hline 33}{c TRC}
{col 4}{c |} Stat{col 14}{c |} Display option{col 34}{c |} Mat col{col 44}{c |} Estimation/calculation{col 78}{c |}
{col 4}{c LT}{hline 9}{c +}{hline 19}{c +}{hline 9}{c +}{hline 33}{c RT}
{col 4}{c |} # obs{col 14}{c |} Always displayed{col 34}{c |} {inp:n_gc}{col 44}{c |} {inp:e(N)} after {inp:reg}{col 78}{c |}
{col 4}{c |} cluster{col 14}{c |} Displayed if used{col 34}{c |} {inp:cl_gc}{col 44}{c |} {inp:e(N_clust)} after {inp:reg}{col 78}{c |}
{col 4}{c |} mean{col 14}{c |} Always displayed{col 34}{c |} {inp:mean_gc}{col 44}{c |} {inp:_b[cons]} after {inp:reg}{col 78}{c |}
{col 4}{c |} se *{col 14}{c |} {inp:stats(desc(se))}{col 34}{c |} {inp:se_gc}{col 44}{c |} {inp:_se[cons]} after {inp:reg}{col 78}{c |}
{col 4}{c |} var{col 14}{c |} {inp:stats(desc(var))}{col 34}{c |} {inp:var_gc}{col 44}{c |} {inp:e(rss)/e(df_r)} after {inp:reg}{col 78}{c |}
{col 4}{c |} sd{col 14}{c |} {inp:stats(desc(sd))}{col 34}{c |} {inp:sd_gc}{col 44}{c |} {inp:_se[_cons]*sqrt(e(N))} after {inp:reg}{col 78}{c |}
{col 4}{c BLC}{hline 9}{c BT}{hline 19}{c BT}{hline 9}{c BT}{hline 33}{c BRC}

{dlgtab:Pair-wise test statistics}

{pstd}Pair-wise test statistics is always displayed in the table
unless {inp:stats(pair(none))} is used. 
For each balance variable and for each test pair, this code is used.
Since observations not included in the test pair have missing values in the test pair dummy,
they are excluded from the regression without using an if-statement.
{p_end}

{pstd}Basic form:
{p_end}

{input}{space 8}reg balancevar tp_dummy
{space 8}test tp_dummy
{text}
{pstd}All options:
{p_end}

{input}{space 8}reg balancevar tp_dummy covariates i.fixedeffect weights, vce(vce_option)
{space 8}test tp_dummy
{text}
{pstd}See above for description of each column in this table.
{it:tp} stands for {it:test_pair}, see definition above.
The last column shows how the command obtains the stat in the Stata code.
See the group descriptive statistics above for definitions on
{it:mean_1}, {it:mean_2}, {it:var_1} and {it:var_2_
also used in the table below.
These statistics are stored in
a the result matrix called {inp:r(iebtab_rmat)}. 
{p_end}

{col 4}{c TLC}{hline 8}{c TT}{hline 19}{c TT}{hline 9}{c TT}{hline 45}{c TRC}
{col 4}{c |} Stat{col 13}{c |} Display option{col 33}{c |} Mat col{col 43}{c |} Estimation/calculation{col 89}{c |}
{col 4}{c LT}{hline 8}{c +}{hline 19}{c +}{hline 9}{c +}{hline 45}{c RT}
{col 4}{c |} diff *{col 13}{c |} {inp:stats(pair(diff))}{col 33}{c |} {inp:diff_tp}{col 43}{c |} If pair {it:1_2}: {inp:mean_1}-{inp:mean_2}{col 89}{c |}
{col 4}{c |} beta{col 13}{c |} {inp:stats(pair(beta))}{col 33}{c |} {inp:beta_tp}{col 43}{c |} {inp:e(b)[1,1]} after {inp:reg}{col 89}{c |}
{col 4}{c |} t{col 13}{c |} {inp:stats(pair(t))}{col 33}{c |} {inp:t_tp}{col 43}{c |} {inp:_b[tp_dummy]/_se[tp_dummy]} after {inp:reg}{col 89}{c |}
{col 4}{c |} p{col 13}{c |} {inp:stats(pair(p))}{col 33}{c |} {inp:p_tp}{col 43}{c |} {inp:e(p)} after {inp:test}{col 89}{c |}
{col 4}{c |} nrmd{col 13}{c |} {inp:stats(pair(nrmd))}{col 33}{c |} {inp:nrmd_tp}{col 43}{c |} If pair {it:1_2}: {inp:diff_tp/sqrt(.5*(var_1+var_2))}{col 89}{c |}
{col 4}{c |} nrmb{col 13}{c |} {inp:stats(pair(nrmb))}{col 33}{c |} {inp:nrmb_tp}{col 43}{c |} If pair {it:1_2}: {inp:beta_tp/sqrt(.5*(var_1+var_2))}{col 89}{c |}
{col 4}{c |} se{col 13}{c |} {inp:stats(pair(se))}{col 33}{c |} {inp:se_tp}{col 43}{c |} {inp:_se[tp_dummy]} after {inp:reg}{col 89}{c |}
{col 4}{c |} sd{col 13}{c |} {inp:stats(pair(sd))}{col 33}{c |} {inp:sd_tp}{col 43}{c |} {inp:_se[tp_dummy] * sqrt(e(N))} after {inp:reg}{col 89}{c |}
{col 4}{c BLC}{hline 8}{c BT}{hline 19}{c BT}{hline 9}{c BT}{hline 45}{c BRC}

{dlgtab:F-test statistics for balance across all balance variables}

{pstd}Displayed in the balance table if the option {inp:ftest} is used. 
For each test pair the following code is used.
{p_end}

{pstd}Basic form:
{p_end}

{input}{space 8}reg tp_dummy balancevars
{space 8}testparm balancevars
{text}
{pstd}All options:
{p_end}

{input}{space 8}reg tp_dummy balancevars covariates i.fixedeffect weights, vce(vce_option)
{space 8}testparm balancevars
{text}
{pstd}See above for description of each column in this table.
{it:tp} stands for {it:test_pair}, see definition above.
These statistics are stored in
a the result matrix called {inp:r(iebtab_fmat)}. 
{p_end}

{col 4}{c TLC}{hline 9}{c TT}{hline 19}{c TT}{hline 9}{c TT}{hline 24}{c TRC}
{col 4}{c |} Stat{col 14}{c |} Display option{col 34}{c |} Mat col{col 44}{c |} Estimation/calculation{col 69}{c |}
{col 4}{c LT}{hline 9}{c +}{hline 19}{c +}{hline 9}{c +}{hline 24}{c RT}
{col 4}{c |} # obs{col 14}{c |} Always displayed{col 34}{c |} {inp:fn_tp}{col 44}{c |} {inp:e(N)} after {inp:reg}{col 69}{c |}
{col 4}{c |} cluster{col 14}{c |} Displayed if used{col 34}{c |} {inp:fcl_tp}{col 44}{c |} {inp:e(N_clust)} after {inp:reg}{col 69}{c |}
{col 4}{c |} f *{col 14}{c |} {inp:stats(f(f))}{col 34}{c |} {inp:ff_tp}{col 44}{c |} {inp:r(F)} after {inp:testparm}{col 69}{c |}
{col 4}{c |} p{col 14}{c |} {inp:stats(f(p))}{col 34}{c |} {inp:fp_tp}{col 44}{c |} {inp:r(p)} after {inp:testparm}{col 69}{c |}
{col 4}{c BLC}{hline 9}{c BT}{hline 19}{c BT}{hline 9}{c BT}{hline 24}{c BRC}

{dlgtab:F-test statistics for balance across all groups}

{pstd}Displayed in the balance table if the option {inp:feqtest} is used. 
For each balance variable the below code is used where
{inp:feqtestinput} is a list on the format 
{inp:x2.groupvar = x3.groupvar ... xn.groupvar = 0}, 
and where {it:x2}, {it:x3} ... {it:xn},
represents all group codes apart from the first code.
{p_end}

{pstd}Basic form:
{p_end}

{input}{space 8}reg balancevar i.groupvar
{space 8}test feqtestinput
{text}
{pstd}All options:
{p_end}

{input}{space 8}reg balancevar i.groupvar covariates i.fixedeffect weights, vce(vce_option)
{space 8}test feqtestinput
{text}
{pstd}See above for description of each column in this table.
These statistics are stored in
a the result matrix called {inp:r(iebtab_fmat)}. 
{p_end}

{col 4}{c TLC}{hline 9}{c TT}{hline 19}{c TT}{hline 9}{c TT}{hline 24}{c TRC}
{col 4}{c |} Stat{col 14}{c |} Display option{col 34}{c |} Mat col{col 44}{c |} Estimation/calculation{col 69}{c |}
{col 4}{c LT}{hline 9}{c +}{hline 19}{c +}{hline 9}{c +}{hline 24}{c RT}
{col 4}{c |} # obs{col 14}{c |} Always displayed{col 34}{c |} {inp:feq_n}{col 44}{c |} {inp:e(N)} after {inp:reg}{col 69}{c |}
{col 4}{c |} cluster{col 14}{c |} Displayed if used{col 34}{c |} {inp:feq_cl}{col 44}{c |} {inp:e(N_clust)} after {inp:reg}{col 69}{c |}
{col 4}{c |} f *{col 14}{c |} {inp:stats(feq(f))}{col 34}{c |} {inp:feq_f}{col 44}{c |} {inp:r(F)} after {inp:test}{col 69}{c |}
{col 4}{c |} p{col 14}{c |} {inp:stats(feq(p))}{col 34}{c |} {inp:feq_p}{col 44}{c |} {inp:r(p)} after {inp:test}{col 69}{c |}
{col 4}{c BLC}{hline 9}{c BT}{hline 19}{c BT}{hline 9}{c BT}{hline 24}{c BRC}

{title:Result matrices}

{pstd}There is an unlimited variation in preferences for
how a balance table should be structured or look.
A single command like {inp:iebaltab} simply cannot satisfy them all. 
To still enable infinite customization this commands return two matrices
with all the stats calculated by this command.
From these matrices all values can be extracted and
put into any output of your liking.
{p_end}

{pstd}The two returned matrices are called {inp:iebtab_rmat} and {inp:iebtab_fmat}. 
All stats related to the F-test  across all balance variables (option {inp:ftest}) 
are stored in the {inp:iebtab_fmat} matrix, 
all other stats are stored in the {inp:iebtab_rmat} matrix. 
The {inp:iebtab_fmat} matrix always has exactly one row with the row name {inp:fstats}. 
The {inp:iebtab_rmat} matrix has one row per balance variable 
and each row is named after each balance var.
In both matrices the column names corresponds to a statistics.
The column name for each statistics and its definition can be found
in the {it:Estimation/statistics definitions} section above.
{p_end}

{pstd}See examples in the end of this help file for how to access the values.
{p_end}

{title:Missing values}

{pstd}When statistics are estimated/calculated they can be missing for multiple reasons.
This section explain what each ({inp:.c},{inp:.v} etc.) represents. 
See {inp:help missing} if you are not familiar with extended missing values. 
The exported tables or the result matrices should never include
the standard missing value ({inp:.}). 
If you ever encounter the standard missing value in any of them,
please report that using the contact information at the bottom of this help file.
{p_end}

{dlgtab:Missing value: .b}

{pstd}Missing value {inp:.b} means that the statistics 
could not be estimated/calculated as bootstrapping was set
to be used as the variance estimator in {inp:vce(bootstrap)}. 
When bootstrap is used there is no single value for variance
to be reported in stat {inp:desc(var)}. 
As a result of that, the stats {inp:pair(nrmd)} and {inp:pair(nrmb)} 
are not reported either as they use the variance as input.
{p_end}

{dlgtab:Missing value: .c}

{pstd}Missing value {inp:.c} are only used when there is 
no number of clusters to report as the errors estimations were not cluster.
A value for number of clusters are only reported if the
variance estimator option is set to {inp:vce(cluster clustervar)}. 
{p_end}

{dlgtab:Missing value: .f}

{pstd}Missing value {inp:.f} is used to indicate that F-test option for 
that statistics (either {inp:fstat} or {inp:feqstat}) was not used, 
and the value was therefore not calculated.
{p_end}

{dlgtab:Missing value: .m}

{pstd}Missing value {inp:.m} is used to indicate that an option to skip 
a full section was used. For example, {inp:stats(pair(none))} where all 
pair-wise statistics are skipped.
{p_end}

{dlgtab:Missing value: .n}

{pstd}Missing value {inp:.n} is used to indicate that the R-squared value 
was not defined in the pair-wise regression for this test pair.
This is most likely caused by no variance in the balance variable.
Here is an example:
{p_end}

{input}{space 8}sysuse census
{space 8}gen constant = 1
{space 8}iebaltab medage constant, groupvar(region) browse
{text}
{pstd}In this example the variable {it:constant} has no variance.
This variable has the mean 1 and 0 variance in the descriptive statistics
and statistics can be reported in the descriptive statistics section.
However, the R-square value is not defined for any test pair
in the pair-wise regression,
and no pair-wise stats are reported for the {it:constant} variable.
{p_end}

{dlgtab:Missing value: .o}
{pstd}Missing value {inp:.o} is used to indicate that in the F-test regression 
for joint significance across all balance variables (see option {inp:ftest}) 
for this test pair and at least one balance variable was omitted.
This is most likely caused by no variance in that balance variable.
Here is an example:
{p_end}

{input}{space 8}sysuse census
{space 8}replace pop = 0 if (region == 1) | (region == 2)
{space 8}iebaltab medage pop, groupvar(region) ftest browse
{text}
{pstd}In this example the variable {it:pop} has no variance in test pair 1{it:2,
and that variable will be omitted from the F-test regression and
no stats are reported for this F-test for this test pair.
{p_end}

{dlgtab:Missing value: .t}

{pstd}Missing value {inp:.t} is used to indicate that no descriptive statistics 
were calculated for the full sample since the option {inp:total} was not used. 
{p_end}

{dlgtab:Missing value: .v}

{pstd}Missing value {inp:.v} is used to indicate that 
all variance in the balance variable can be explained by one or several
other variables included in the regression.
This is defined as the R-squared value is 1.
Here are a few examples:
{p_end}

{input}{space 8}gen region2 = region
{space 8}gen pop_neg = 0
{space 8}replace pop_neg = pop * -1 if (region == 1) | (region == 2)
{space 8}iebaltab medage pop region2, groupvar(region) covar(pop_neg) browse
{text}
{pstd}The variance in variable {it:region2} is perfectly explained
by the group variable {it:region} for each test pair
and the R-squared is 1 in all pair-wise regressions and no statistics are reported.
Similarly, {it:pop_neg} that is included as a covariate control variable
has prefect negative correlation with the balance variable {it:pop} in test pair 1{it:2.
The R-squared is 1 in the regression for pair 1{it:2 and no pair-wise statistics are reported for that pair.
{p_end}

{title:Examples}

{dlgtab:Example 1}

{input}{space 8}sysuse census
{space 8}gen group = runiform() < .5
{space 8}iebaltab pop medage, groupvar(group) browse
{space 8}browse
{text}
{pstd}In the example above, Stata{c 39}s built in census data is used.
First a dummy variable is created at random.
Using this random group variable a balance table is created testing for
differences in {it:pop} and {it:medage}.
By using {inp:browse} the data in memory is replaced with the table so that 
the table can be used in the browse window.
You most likely never should use the {inp:browse} option in your final code 
but it is convenient in examples like this and when first testing the command.
See examples on how to save the table to a file on disk below.
{p_end}

{dlgtab:Example 2}

{input}{space 8}sysuse census
{space 8}iebaltab pop medage, groupvar(region) browse
{space 8}browse
{text}
{pstd}In this example we use the variable region as group variable that has four categories.
All groups are tested against each other.
{p_end}

{dlgtab:Example 3}

{input}{space 8}sysuse census
{space 8}iebaltab pop medage, groupvar(region) browse control(4)
{space 8}browse
{text}
{pstd}Comparing all groups against each other becomes unfeasible when the number of
categories in the group variable grows.
The option {inp:control()} overrides this behavior so that the category indicated 
in this options are tested against all other groups,
but the other groups are not tested against each other.
For statistics where the direction matters (for example {it:diff} or {it:beta})
the order is changed so that the test is ({it:other_group} - {it:control})
such that a positive value indicates that the other group has a higher
mean in the balance variable.
{p_end}

{dlgtab:Example 4}

{input}{space 8}sysuse census
{space 8}iebaltab pop medage, groupvar(region) browse control(4) stats(desc(var) pair(p))
{space 8}browse
{text}
{pstd}You can control which statistics to output in using the {inp:stats()} option. 
In this example, the sub-option {inp:desc(var)} indicates that 
the variance should be displayed in the descriptive statistics section
instead of standard error which is the default.
The sub-option {inp:pair(p)} indicates that 
the p-value in from the t-tests in the pairwise test section should be displayed
instead of the difference in mean between the groups which is the default.
See above in this help file for full details on the sub-options you may use.
{p_end}

{dlgtab:Example 5}

{input}{space 8}sysuse census
{space 8}local outfld "path/to/folder"
{space 8}iebaltab pop medage, groupvar(region) control(4) ///
{space 8}  stats(desc(var) pair(p)) replace ///
{space 8}  savecsv("`outfld'/iebtb.csv") savexlsx("`outfld'/iebtb.xlsx") /// 
{space 8}  savetex("`outfld'/iebtb.tex") texnotefile("`outfld'/iebtb_note.tex") 
{text}
{pstd}This example shows how to export the tables to the three formats supported.
CSV, Excel and LaTeX.
To run this code you must update the path {it:{c 34}path/to/folder{c 34}} to point
to a folder on your computer where the tables can be exported to.
This is what we recommend over using the {inp:browse} options for final code. 
When exporting to LaTeX we recommend exporting the note to a separate file
using the option {inp:texnotefile()} and then import it in LaTeX using the 
package {inp:threeparttable} like the code below. 
It makes it easier to align the note with the table when LaTeX adjust the size
of the table to fit a page.
{p_end}

{input}{space 8}\begin{table}
{space 8}  \centering
{space 8}  \caption{Balance table}
{space 8}  \begin{adjustbox}{max width=\textwidth}
{space 8}    \begin{threeparttable}[!h]
{space 8}	  \input{./balancetable.tex}
{space 8}	  \begin{tablenotes}[flushleft]
{space 8}	    \item\hspace{-.25em}\input{./balancetable_note.tex}
{space 8}	  \end{tablenotes}
{space 8}    \end{threeparttable}
{space 8}  \end{adjustbox}
{space 8}\end{table}
{text}
{dlgtab:Example 6}

{input}{space 8}sysuse census
{space 8}iebaltab pop medage, groupvar(region)
{space 8}local rnum = rownumb(r(iebtab_rmat),"medage")
{space 8}local cnum = colnumb(r(iebtab_rmat),"p_2_4")
{space 8}local p_medage_2_4 = el(r(iebtab_rmat),`rnum',`cnum') 
{space 8}di "The p-value in the test for medage between region 2 and 4 is: `p_medage_2_4'" 
{text}
{pstd}In this example none of the export options ({inp:browse}, {inp:savecsv()} etc.) are used 
and the only place where the results are stored
is in the {inp:r(iebtab_rmat)} matrix. 
The {inp:rownumb()} and the {inp:colnumb()} functions can be used to get 
the row and column number from the row and column names.
These row and column numbers can be used to get the individual value in the function {inp:el()}. 
If you know the row and column number you can use the {inp:el()} function directly. 
{p_end}

{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions and requests for clarifications
writing {c 34}ietoolkit iebaltab{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {inp:ietoolkit}. 
{p_end}

{title:Author}

{pstd}All commands in {inp:ietoolkit} are developed by DIME Analytics at DIME, The World Bank{c 39}s department for Development Impact Evaluations. 
{p_end}

{pstd}Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group
{p_end}
