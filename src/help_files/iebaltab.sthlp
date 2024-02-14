{smcl}
{* 01 Feb 2024}{...}
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
, {opt group:var(varname)} [
{it:{help iebaltab##columnrowoptions:columnrow_options}}
{it:{help iebaltab##estimateoptions:estimation_options}}
{it:{help iebaltab##statoptions:stat_display_options}}
{it:{help iebaltab##labeloptions:label_note_options}}
{it:{help iebaltab##exportoptions:export_options}}
{it:{help iebaltab##latexoptions:latex_options}}
]

{phang2}where {it:balancevarlist} is one or several continuous or binary variables (from here on called balance variables) for which the command
will test for differences across the categories in {opt groupvar(varname)}.

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:Options}
{synoptline}
{pstd}{it:    {ul:{hi:Required options:}}}{p_end}

{synopt :{opth group:var(varname)}}Variable indicating the groups (ex. treatment arms) to test across{p_end}

{pstd}{it:    {ul:{hi:Optional options}}}{p_end}

{marker columnrowoptions}{...}
{synopthdr:Column and row options}
{synopt :{opt co:ntrol(groupcode)}}Indicate a single group that all other groups are tested against. Default is all groups are tested against each other{p_end}
{synopt :{opt or:der(groupcodelist)}}Manually set the order the groups appear in the table. Default is ascending. See details on {it:groupcodelist} below{p_end}
{synopt :{opt tot:al}}Include descriptive stats on all observations included in the table{p_end}
{synopt :{opt onerow}}Write number of observations (and number of clusters if applicable) in one row at the bottom of the table{p_end}

{marker estimateoptions}{...}
{synopthdr:Estimation options}
{synopt :{opth vce:(vce_option:vce_types)}}Options for estimating variance{p_end}
{synopt :{opth fix:edeffect(varname)}}Include fixed effects in the pair-wise regressions (and for F-tests if applicable){p_end}
{synopt :{opth cov:ariates(varlist)}}Include covariates (control variables) in the pair-wise regressions (and for F-tests if applicable){p_end}
{synopt :{opt ft:est}}Include a row with the F-test for joint significance across all balance variables for each test pair{p_end}
{synopt :{opt feqt:est}}Include a column with the F-test for joint significance across all groups for each variable{p_end}

{marker statoptions}{...}
{synopthdr:Stat display options}
{synopt :{cmd:stats(}{it:{help iebaltab##statstr:stats_string}}{cmd:)}}Specify which statistics to display in the tables. See options for {it:stats_string} below{p_end}
{synopt :{opth star:levels(numlist)}}Manually set the three significance levels used for significance stars{p_end}
{synopt :{opt nostar:s}}Do not add any stars to the table{p_end}
{synopt :{opth form:at(format:%fmt)}}Apply Stata formats to the non-integer values outputted in the table{p_end}

{marker labeloptions}{...}
{synopthdr:Label/notes options}
{synopt :{opt groupc:odes}}Use the values in the {opt groupvar()} variable as column titles. Default is to use value labels if any{p_end}
{synopt :{opt groupl:abels(codetitles)}}Manually set the group column titles. See details on {it:codetitles} below{p_end}
{synopt :{opt totall:abel(string)}}Manually set the title of the total column{p_end}
{synopt :{opt rowv:arlabels}}Use the variable labels instead of variable name as row titles{p_end}
{synopt :{opt rowl:abels(nametitles)}}Manually set the row titles. See details on {it:nametitles} below{p_end}
{synopt :{opt nonote}}Suppress the default not at the bottom of the table{p_end}
{synopt :{opt addnote(string)}}Add a manual note to the bottom of the table{p_end}

{marker exportoptions}{...}
{synopthdr:Export options}
{synopt :{opt browse}}View table in the data browser{p_end}
{synopt :{opth savex:lsx(filename)}}Save table to Excel file on disk{p_end}
{synopt :{opth savec:sv(filename)}}Save table to csv-file on disk{p_end}
{synopt :{opth savet:ex(filename)}}Save table to LaTeX file on disk{p_end}
{synopt :{opth texnotefile(filename)}}Save table note in a separate LaTeX file on disk{p_end}
{synopt :{opt replace}}Replace file on disk if the file already exists{p_end}

{marker latexoptions}{...}
{synopthdr:LaTeX options}
{synopt :{opth texn:otewidth(numlist)}}Manually adjust width of note{p_end}
{synopt :{opt texc:aption(string)}}Specify LaTeX table caption{p_end}
{synopt :{opt texl:abel(string)}}Specify LaTeX label{p_end}
{synopt :{opt texdoc:ument}}Create a stand-alone LaTeX document{p_end}
{synopt :{opt texcolwidth(string)}}Limit width of the first column on LaTeX output{p_end}

{synoptline}

{title:Description}

{pstd}{cmd:iebaltab} is a command that generates balance tables (difference-in-means tables).
The command tests for statistically significant difference in the balance variables between
the categories defined in the {opt groupvar(varname)}. The command can either test one control group
against all other groups, using the {opt control(groupcode)} option,
or test all groups against each other (the default). The command also allows for
fixed effects, covariates and different types of variance estimators.{p_end}

{pstd}The balance variables are expected to be continuous or binary variables.
Categorical variables (for example 1=single, 2=married, 3=divorced) will not
generate an error but will be treated like a continuous variable
which is most likely statistically invalid.
Consider converting each category to binary variables.{p_end}

{pstd}The command can also add a note to the bottom of the table.
The default note is not meant to be included in the final publication.
It includes technical information about how the command was specified.
This is helpful in the early stage of research where several specifications
are often explored, but should be replace with a more human readable note
in the final version.{p_end}

{pstd}See the {help iebaltab##est_defs:estimation/statistics definitions}
section below for a detailed documentation of what statistics this command
calculates and how they are calculated.{p_end}

{title:Options (detailed descriptions)}

{pstd}{it:{ul:{hi:Required options:}}}{p_end}

{phang}{opth group:var(varname)} specifies the variable indicating groups
(for example treatment arms) across which the command will
test for difference in mean of the balance variable.
The group variable can only be one variable and
it must be numeric and may only hold integers.
See {help egen:egen group} for help on creating a single variable where
each integer represents a category from string variables and/or multiple variables.
Observations with missing values in this variable will be excluded when running this command.

{pstd}{it:{ul:{hi:Optional options}}}{p_end}

{pstd}{it:Column and row options:}{p_end}

{phang}{opt co:ntrol(groupcode)} specifies one group that is the control group
that all other groups are tested against for difference in means and
where {it:groupcode} is an integer used in {opt groupvar()}.
The default is that all groups are tested against each other.
The control group will be listed first (leftmost) in the table
unless another order is specified in {opt order()}.
When using {opt control()} the order of the groups in the pair is (non-control)-(control)
so that a positive statistic (in for example {it:diff} or {it:beta}) indicates that
the mean for the non-control is larger than for the control.{p_end}

{phang}{opt or:der(groupcodelist)} manually sets the column order of the groups in the table. {it:groupcodelist} may
be any or all of the values in the group variable specified in {opt groupvar()}.
The default order if this option is omitted is ascending order of the values in the group variable.
If any values in {opt groupvar()} are omitted when using this option,
they will be sorted in ascending order after the values included.{p_end}

{phang}{opt tot:al} includes a column with descriptive statistics on the full sample.
This column still exclude observations with missing values in {opt groupvar()}.{p_end}

{phang}{opt onerow} displays the number of observations in an additional row
at the bottom of the table. If the number of observations are not identical
across all rows within a column, then this option throws an error.
This also applies to number of clusters.
If not specified, the number of observations (and clusters) per variable per group
is displayed on the same row in an additional column
next to the descriptive statistics.{p_end}

{pstd}{it:Estimation options:}{p_end}

{phang}{opth vce:(vce_option:vce_types)} sets the type of variance estimator
to be used in all regressions for this command.
See {help vce_option:vce_types} for more details.
However, the types allowed in this command are only
{hi:robust}, {hi:cluster} {it:clustervar} or {hi:bootstrap}.
See the {help iebaltab##est_defs:estimation definition} section
for exact definitions on how these vce types are included in the regressions.{p_end}

{phang}{opth fix:edeffect(varname)} specifies a single variable to be used as fixed effects in all regressions
part from descriptive stats regressions.
The variable specified must be a numeric variable.
If more than one variable is needed as fixed effects, and it is not desirable to combine multiple variables into one
(using for example {help egen:egen group}),
then they can be included using the {opt i.} notation in the {opt covariates()} option.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how the fixed effects are included in the regressions.{p_end}

{phang}{opth cov:ariates(varlist)} includes the variables specified in the regressions for t-tests (and for
F-tests if applicable) as covariate variables (control variables). See the description section above for details on how the covariates
are included in the estimation regressions. The covariate variables must be numeric variables.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how the covariates are included in the regressions.{p_end}

{phang}{opt ft:est} adds a single row at the bottom fo the the table with
one F-test for each test pair, testing for joint significance across all balance variables.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how these tests are estimated.{p_end}

{phang}{opt feqt:est} adds a single column in the table with an F-test for each balance variable,
testing for joint significance across all groups in {opt groupvar()}.
See the {help iebaltab##est_defs:estimation definition} section for exact definitions on how these tests are estimated.{p_end}

{pstd}{it:Statistics display options:}{p_end}

{marker statstr}{...}
{phang}{cmd:stats(}{it:{help iebaltab##statstr:stats_string}}{cmd:)}
indicates which statistics to be displayed in the table.
The {it:stats_string} is expected to be on this format (where at least one of the sub-arguements
{opt desc}, {opt pair}, {opt f} and {opt feq} are required):{p_end}

{pmore}{cmd: stats(desc({it:desc_stats}) pair({it:pair_stats}) f({it:f_stats}) feq({it:feq_stats))}}{p_end}

{pmore}The table below lists the valid values for
{it:desc_stats}, {it:pair_stats}, {it:f_stats} and {it:feq_stats}.
See the {help iebaltab##est_defs:estimation definition} section
for exact definitions of these values and how they are estimated/calculated.{p_end}

{p2colset 9 21 23 0}{...}
{p2col:{it:desc_stats:}}{cmd:se var sd}{p_end}
{p2col:{it:pair_stats:}}{cmd:diff beta t p nrmd nrmb se sd none}{p_end}
{p2col:{it:f_stats:}}{cmd:f p}{p_end}
{p2col:{it:feq_stats:}}{cmd:f p}{p_end}

{phang}{opth star:levels(numlist)} manually sets the
three significance levels used for significance stars.
Expected input is decimals (between the value 0 and 1) in descending order.
The default is (.1 .05 .01) where .1 corresponds
to one star, .05 to two stars and .01 to three stars.{p_end}

{phang}{opt nostar:s} makes the command not add any stars to the table
regardless of significance levels.{p_end}

{phang}{opth form:at(format:%fmt)} applies the Stata formats specified to all values outputted
in the table apart from values that always are integers.
Example of values that always are integers is number of observations.
For these integer values the format is always %9.0f.
The default for all other values when this option is not used is %9.3f.{p_end}

{pstd}{it:Label and notes options:}{p_end}

{phang}{opt groupc:odes} makes the integer values used for the group codes in
{opt groupvar()} the group column titles.
The default is to use the value labels used in {opt groupvar()}.
If no value labels are used for the variable in {opt groupvar()},
then this option does not make a difference.{p_end}

{phang}{opt groupl:abels(codetitles)} manually sets the group column titles.
{it:codetitles} is a string on the following format:{p_end}

{pmore}{opt grouplabels("code1 title1 @ code2 title2 @ code3 title3")}{p_end}

{pmore}Where code1, code2 etc. must correspond to the integer values used for each
group used in the variable {opt groupvar()},
and title1, title2 etc. are the titles to be used for the corresponding integer value.
The character "@" may not be used in any title.
Codes omitted from this option will be assigned a column title
as if this option was not used.
This option takes precedence over {cmd:groupcodes} when used together,
meaning that group codes are only used for groups
that are not included in the {it:codetitlestring}.
The title can consist of several words.
Everything that follows the code until the end of a string
or a "@" will be included in the title.{p_end}

{phang}{opt totall:abel(string)} manually sets the column title for the total column.{p_end}

{phang}{opt rowv:arlabels} use the variable labels instead of variable name as row titles.
The default is to use the variable name. For variables with no variable label defined,
the variable name is used as row label even when this option is specified.{p_end}

{phang}{opt rowl:abels(nametitles)} manually sets the row titles for each
of the balance variables in the table.
{it:nametitles} is a string in the following format:{p_end}

{pmore}{opt rowlabels("name1 title1 @ name2 title2 @ name3 title3")}{p_end}

{pmore}Where name1, name2 etc. are variable names used as balance variables,
and title1, title2 etc. are the titles to be used for the corresponding variable.
The character "@" may not be used in any of the titles.
Variables omitted from this option are assigned a row title as if this option was not used.
This option takes precedence over {cmd:rowvarlabels} when used together,
meaning that default labels are only used for variables
that are not included in the {it:nametitlestring}.
The title can consist of several words.
Everything that follows the variable name until
the end of a string or a "@" will be included in the title.{p_end}

{phang}{opt nonote} suppresses the default note that the command adds to
the bottom of the table with technical information
on how the command was specified.
This note is great during explorative analysis as it documents how
{opt iebaltab} was specified to generate exactly that table.
Eventually however, this note should probably be replaced with
a note more suitable for publication.{p_end}

{phang}{opt addnote(string)} adds the string provided in this option
to the note at the bottom of table.
If {opt nonote} is not used, then this manually provided note
is added to the end of the default note.

{pstd}{it:Export options:}{p_end}

{phang}{opt browse} replaces the data in memory with the table
so it can be viewed using the command {h browse} instead of saving it to disk.
This is only meant to be used during explorative analysis
when figuring out how to specify the command.
Note that this overwrites data in memory.{p_end}

{phang}{opth savex:lsx(filename)} exports the table to an Excel (.xsl/.xlsx) file and saves it on disk.{p_end}

{phang}{opth savec:sv(filename)} exports the table to a comma separated (.csv) file and saves it on disk.{p_end}

{phang}{opth savet:ex(filename)} exports the table to a LaTeX (.tex) file and saves it on disk.{p_end}

{phang}{opth texnotefile(filename)} exports the table note in a separate LaTeX file on disk.
When this option is used, no note is included in the {opt savetex()} file.
This allows importing the table using the {it:threeparttable} LaTeX package which
is an easy way to make sure the note always has the same width as the table.
See example in the example section below.{p_end}

{phang}{opt replace} allows for the file in {opt savexlsx()}, {opt savexcsv()},
{opt savetex()} or {opt texnotefile()}
to be overwritten if the file already exist on disk.{p_end}

{pstd}{it:LaTeX options:}{p_end}

{phang}{opth texn:otewidth(numlist)} manually adjusts the width of the note
to fit the size of the table.
The note width is a multiple of text width.
If not specified, default is one, which makes the table width equal to text width.
However, when the table is resized when rendered in LaTeX
this is not always the same as the table width.
Consider also using {opt texnotefile()} and the LaTeX package {it:threeparttable}.{p_end}

{phang}{opt texdoc:ument} creates a stand-alone LaTeX document ready to be compiled.
The default is that {opt savetex()} creates a fragmented LaTeX file
consisting only of a tabular environment.
This fragment is then meant to be imported to a main LaTeX file
that holds text and may import other tables.{p_end}

{phang}{opt texc:aption(string)} writes the table's caption in LaTeX file.
Can only be used with option {opt texdocument}.{p_end}

{phang}{opt texl:abel(string)} specifies table's label,
used for meta-reference across LaTeX file.
Can only be used with option {opt texdocument}.{p_end}

{phang}{cmd:texcolwidth(}{it:string}{cmd:)} limits the width of table's first column
so that a line break is added when a variable's name or label is too long.
{it:string} must consist of a numeric value with one of the following units:
"cm", "mm", "pt", "in", "ex" or "em".
For more information on these units,
{browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX lengths manual}.{p_end}

{marker est_defs}{...}
{title:Estimation/statistics definitions}

{pstd}This section details the regressions that are used to estimate
the statistics displayed in the balance tables generated by this command.
For each test there is a {it:basic form} example to highlight the core of the test,
and an {it:all options} example that shows exactly how all options are applied.
Here is a glossary for the terms used in this section:{p_end}

{p2colset 5 23 23 0}{...}
{p2col:{it:balance variable}}The variables listed as {it:balancevarlist}{p_end}
{p2col:{it:groupvar}}The variable specified in {opt groupvar(varname)}{p_end}
{p2col:{it:groupcode}}Each value in {it:groupvar}{p_end}
{p2col:{it:test pair}}Combination of {it:group codes} to be used in pair wise tests{p_end}
{p2col:{it:tp_dummy}}A dummy variable where the first {it:group code} in a {it:test pair}
has the value 1 and the second {it:group code} has the value 0,
and all other observations has missing values{p_end}

{pstd}{ul:{it:Group descriptive statistics}}{break}
Descriptive statistics for all groups are always displayed in the table.
If option {opt total} is used then these statistics are also calculated on the full sample.
For each balance variable and for each value group code,
the descriptive statistics is calculated using the following code:{p_end}

{pstd}{it:basic form:}
{break}{input:reg balancevar if groupvar = groupcode}{p_end}

{pstd}{it:all options:}
{break}{input:reg balancevar if groupvar = groupcode weights, vce(vce_option)}{p_end}

{pstd}The table below shows the stats estimated/calculated based on this regression.
A star (*) in the {it:Stat} column indicate that is the optional statistics displayed by default
if the {inp:stats()} option is not used.
The {it:Display option} column shows what sub-option to use in {inp:stats()} to display this statistic.
The {it:Mat col} column shows what the column name in the result matrix for the column that stores this stat.
{it:gc} stands for {it:groupcode}, see definition above.
If the option {inp:total} is used,
then {it:gc} will also include {it:t} for stats on the full sample.
See more about the result matrices in the {it:Result matrices} section below.
The last column shows how the command obtains the stat in the Stata code.{p_end}

{c TLC}{hline 9}{c TT}{hline 19}{c TT}{hline 9}{c TT}{hline 33}{c TRC}
{c |} Stat {col 11}{c |} Display option {col 31}{c |} Mat col {col 37}{c |} Estimation/calculation {col 75}{c |}
{c LT}{hline 9}{c +}{hline 19}{c +}{hline 9}{c +}{hline 33}{c RT}
{c |} # obs {col 11}{c |} Always displayed {col 31}{c |} n_{it:gc} {col 41}{c |} {cmd:e(N)} after {cmd:reg} {col 75}{c |}
{c |} cluster {col 11}{c |} Displayed if used {col 31}{c |} cl_{it:gc} {col 41}{c |} {cmd:e(N_clust)} after {cmd:reg} {col 75}{c |}
{c |} mean {col 11}{c |} Always displayed {col 31}{c |} mean_{it:gc} {col 41}{c |} {cmd:_b[cons]} after {cmd:reg} {col 75}{c |}
{c |} se * {col 11}{c |} {inp:stats(desc(se))} {col 31}{c |} se_{it:gc} {col 41}{c |} {cmd:_se[cons]} after {cmd:reg} {col 75}{c |}
{c |} var {col 11}{c |} {inp:stats(desc(var))} {col 31}{c |} var_{it:gc} {col 41}{c |} {cmd:e(rss)/e(df_r)} after {cmd:reg} {col 75}{c |}
{c |} sd {col 11}{c |} {inp:stats(desc(sd))} {col 31}{c |} sd_{it:gc} {col 41}{c |} {cmd:_se[_cons]*sqrt(e(N))} after {cmd:reg} {col 71}{c |}
{c BLC}{hline 9}{c BT}{hline 19}{c BT}{hline 9}{c BT}{hline 33}{c BRC}


{pstd}{ul:{it:Pair-wise test statistics}}{break}
Pair-wise test statistics is always displayed in the table
unless {cmd:stats(pair({it:none}))} is used.
For each balance variable and for each test pair, this code is used.
Since observations not included in the test pair have missing values in the test pair dummy,
they are excluded from the regression without using an if-statement.

{pstd}{it:basic form:}
{break}{input:reg balancevar tp_dummy}
{break}{input:test tp_dummy}{p_end}

{pstd}{it:all options:}
{break}{input:reg balancevar tp_dummy covariates i.fixedeffect weights, vce(vce_option)}
{break}{input:test tp_dummy}{p_end}

{pstd}The table below shows the stats estimated/calculated based on this regression.
A star (*) in the {it:Stat} column indicate that is the optional statistics displayed by default
if the {inp:stats()} option is not used.
The {it:Display option} column shows what sub-option to use in {inp:stats()} to display this statistic.
The {it:Mat col} column shows what the column name in the result matrix for the column that stores this stat.
{it:tp} stands for {it:test pair}, see definition above.
See more about the result matrices in the {it:Result matrices} section below.
The last column shows how the command obtains the stat in the Stata code.
See the group descriptive statistics above for definitions on
{inp:mean_1}, {inp:mean_2}, {inp:var_1} and {inp:var_2}
also used in the table below.{p_end}

{c TLC}{hline 8}{c TT}{hline 19}{c TT}{hline 9}{c TT}{hline 45}{c TRC}
{c |} Stat {col 10}{c |} Display option {col 30}{c |} Mat col {col 37}{c |} Estimation/calculation {col 86}{c |}
{c LT}{hline 8}{c +}{hline 19}{c +}{hline 9}{c +}{hline 45}{c RT}
{c |} diff * {col 8}{c |} {inp:stats(pair(diff))} {col 27}{c |} diff_{it:tp} {col 37}{c |} If pair 1_2: {inp:mean_1}-{inp:mean_2} {col 86}{c |}
{c |} beta {col 10}{c |} {inp:stats(pair(beta))} {col 27}{c |} beta_{it:tp} {col 37}{c |} {inp:e(b)[1,1]} after {inp:reg}{col 86}{c |}
{c |} t {col 10}{c |} {inp:stats(pair(t))} {col 30}{c |} t_{it:tp} {col 40}{c |} {inp:_b[tp_dummy]/_se[tp_dummy]} after {inp:reg}{col 86}{c |}
{c |} p {col 10}{c |} {inp:stats(pair(p))} {col 30}{c |} p_{it:tp} {col 40}{c |} {cmd:e(p)} after {cmd:test}{col 86}{c |}
{c |} nrmd {col 10}{c |} {inp:stats(pair(nrmd))} {col 30}{c |} nrmd_{it:tp} {col 40}{c |} If pair 1_2: {inp:diff_{it:tp}/sqrt(.5*(var_1+var_2))} {col 86}{c |}
{c |} nrmb {col 10}{c |} {inp:stats(pair(nrmb))} {col 30}{c |} nrmb_{it:tp} {col 40}{c |} If pair 1_2: {inp:beta_{it:tp}/sqrt(.5*(var_1+var_2))}{col 86}{c |}
{c |} se {col 10}{c |} {inp:stats(pair(se))} {col 30}{c |} se_{it:tp} {col 40}{c |} {cmd:_se[tp_dummy]} after {cmd:reg}{col 86}{c |}
{c |} sd {col 10}{c |} {inp:stats(pair(sd))} {col 30}{c |} sd_{it:tp} {col 40}{c |} {cmd:_se[tp_dummy] * sqrt(e(N))} after {cmd:reg}{col 86}{c |}
{c BLC}{hline 8}{c BT}{hline 19}{c BT}{hline 9}{c BT}{hline 45}{c BRC}


{pstd}{ul:{it:F-test statistics for balance across all balance variables}}{break}
Displayed in the balance table if the option {opt ftest} is used.
For each test pair the following code is used.

{pstd}{it:basic form:}
{break}{input:reg tp_dummy balancevars }
{break}{input:testparm balancevars}{p_end}

{pstd}{it:all options:}
{break}{input:reg tp_dummy balancevars covariates i.fixedeffect weights, vce(vce_option)}
{break}{input:testparm balancevars}{p_end}

{pstd}The table below shows the stats estimated/calculated based on this regression.
A star (*) in the {it:Stat} column indicate that is the optional statistics displayed by default
if the {inp:stats()} option is not used.
The {it:Display option} column shows what sub-option to use in {inp:stats()} to display this statistic.
The {it:Mat col} column shows what the column name in the result matrix for the column that stores this stat.
{it:tp} stands for {it:test pair}, see definition above.
The F-test statistics is stored in
a separate result matrix called {inp:r(iebtab_fmat)}.
See more about the result matrices in the {it:Result matrices} section below.
The last column shows how the command obtains the stat in the Stata code.{p_end}

{c TLC}{hline 9}{c TT}{hline 19}{c TT}{hline 9}{c TT}{hline 24}{c TRC}
{c |} Stat {col 11}{c |} Display option {col 31}{c |} Mat col {col 41}{c |} Estimation/calculation {col 66}{c |}
{c LT}{hline 9}{c +}{hline 19}{c +}{hline 9}{c +}{hline 24}{c RT}
{c |} # obs {col 11}{c |} Always displayed {col 31}{c |} fn_{it:tp} {col 41}{c |} {cmd:e(N)} after {cmd:reg} {col 66}{c |}
{c |} cluster {col 11}{c |} Displayed if used {col 31}{c |} fcl_{it:tp} {col 41}{c |} {cmd:e(N_clust)} after {cmd:reg} {col 66}{c |}
{c |} f * {col 11}{c |} {inp:stats(f(f))} {col 31}{c |} ff_{it:tp} {col 41}{c |} {cmd:r(F)} after {cmd:testparm} {col 66}{c |}
{c |} p {col 11}{c |} {inp:stats(f(p))} {col 31}{c |} fp_{it:tp} {col 41}{c |} {cmd:r(p)} after {cmd:testparm} {col 66}{c |}
{c BLC}{hline 9}{c BT}{hline 19}{c BT}{hline 9}{c BT}{hline 24}{c BRC}

{pstd}{ul:{it:F-test statistics for balance across all groups}}{break}
Dipslayed in the balance table if the option {opt feqtest} is used.
For each balance variable the below code is used where
{it:feqtestinput} is a list on the format
{input:x2.groupvar = x3.groupvar ... xn.groupvar = 0},
and where {input:x2}, {input:x3} ... {input:xn},
represents all group codes apart from the first code.

{pstd}{it:basic form:}
{break}{input:reg balancevar i.groupvar}
{break}{input:test feqtestinput}{p_end}

{pstd}{it:all options:}
{break}{input:reg balancevar i.groupvar covariates i.fixedeffect weights, vce(vce_option)}
{break}{input:test feqtestinput}{p_end}

{pstd}The table below shows the stats estimated/calculated based on this regression.
A star (*) in the {it:Stat} column indicate that is the optional statistics displayed by default
if the {inp:stats()} option is not used.
The {it:Display option} column shows what sub-option to use in {inp:stats()} to display this statistic.
The {it:Mat col} column shows what the column name in the result matrix for the column that stores this stat.
See more about the result matrices in the {it:Result matrices} section below.
The last column shows how the command obtains the stat in the Stata code.{p_end}

{c TLC}{hline 9}{c TT}{hline 19}{c TT}{hline 9}{c TT}{hline 24}{c TRC}
{c |} Stat {col 11}{c |} Display option {col 31}{c |} Mat col {col 41}{c |} Estimation/calculation {col 66}{c |}
{c LT}{hline 9}{c +}{hline 19}{c +}{hline 9}{c +}{hline 24}{c RT}
{c |} # obs {col 11}{c |} Always displayed {col 31}{c |} feqn {col 41}{c |} {cmd:e(N)} after {cmd:reg} {col 66}{c |}
{c |} cluster {col 11}{c |} Displayed if used {col 31}{c |} feqcl {col 41}{c |} {cmd:e(N_clust)} after {cmd:reg} {col 66}{c |}
{c |} f * {col 11}{c |} {inp:stats(feq(f))} {col 31}{c |} feqf {col 41}{c |} {cmd:r(F)} after {cmd:test} {col 66}{c |}
{c |} p {col 11}{c |} {inp:stats(feq(p))} {col 31}{c |} feqp {col 41}{c |} {cmd:r(p)} after {cmd:test} {col 66}{c |}
{c BLC}{hline 9}{c BT}{hline 19}{c BT}{hline 9}{c BT}{hline 24}{c BRC}

{title:Result matrices}

{pstd}There is an unlimited variation in preferences for
how a balance table should be structured or look.
A single command like {inp:iebaltab} simply cannot satisfy them all.
To still enable infinite customization this commands return two matrices
with all the stats calculated by this command.
From these matrices all values can be extracted and
put into any output of your liking.{p_end}

{pstd}The two returned matrices are called {inp:iebtab_rmat} and {inp:iebtab_fmat}.
All stats related to the F-test  across all balance variables (option {inp:ftest})
are stored in the {inp:iebtab_fmat} matrix,
all other stats are stored in the {inp:iebtab_rmat} matrix.
The {inp:iebtab_fmat} matrix always has exactly one row with the row name {it:fstats}.
The {inp:iebtab_rmat} matrix has one row per balance variable
and each row is named after each balance var.
In both matrices the column names corresponds to a statistics.
The column name for each statistics and its definition can be found
in the {it:Estimation/statistics definitions} section above.{p_end}

{pstd}See examples below for how to access the values.{p_end}

{title:Missing values}

{pstd}When statistics are estimated/calculated they can be missing for multiple reasons.
This section explain what each
{help missing:extended missing values} ({inp:.c},{inp:.v} etc.) represents.
The exported tables or the result matrices should never include
the standard missing value ({inp:.}).
If you ever encounter the standard missing value in any of them,
please report that using the contact information at the bottom of this help file.{p_end}

{pstd}{ul:{it:Missing value: .b}}{break}
Missing value {inp:.b} means that the statistics
could not be estimated/calculated as bootstrapping was set
to be used as the variance estimator in {inp:vce(bootstrap)}.
When bootstrap is used there is no single value for variance
to be reported in stat {inp:desc(var)}.
As a result of that, the stats {inp:pair(nrmd)} and {inp:pair(nrmb)}
are not reported either as they use the variance as input.{p_end}

{pstd}{ul:{it:Missing value: .c}}{break}
Missing value {inp:.c} are only used when there is
no number of clusters to report as the errors estimations were not cluster.
A value for number of clusters are only reported if the
variance estimator option is set to {inp:vce(cluster {it:clustervar})}.{p_end}

{pstd}{ul:{it:Missing value: .f}}{break}
Missing value {inp:.f} is used to indicate that F-test option for
that statistics (either {inp:fstat} or {inp:feqstat}) was not used,
and the value was therefore not calculated.{p_end}

{pstd}{ul:{it:Missing value: .m}}{break}
Missing value {inp:.m} is used to indicate that an option to skip
a full section was used. For example, {inp:stats(pair(none))} where all
pair-wise statistics are skipped.{p_end}

{pstd}{ul:{it:Missing value: .n}}{break}
Missing value {inp:.n} is used to indicate that the R-squared value
was not defined in the pair-wise regression for this test pair.
This is most likely caused by no variance in the balance variable.
Here is an example:{p_end}

{pstd}{inp:sysuse census}{break}
{inp:gen constant = 1}{break}
{inp:iebaltab medage constant, groupvar(region) browse}{p_end}

{pstd}In this example the variable {inp:constant} has no variance.
This variable has the mean 1 and 0 variance in the descriptive statistics
and statistics can be reported in the descriptive statistics section.
However, the R-square value is not defined for any test pair
in the pair-wise regression,
and no pair-wise stats are reported for the {inp:constant} variable.{p_end}

{pstd}{ul:{it:Missing value: .o}}{break}
Missing value {inp:.o} is used to indicate that in the F-test regression
for joint significance across all balance variables (see option {inp:ftest})
for this test pair and at least one balance variable was omitted.
This is most likely caused by no variance in that balance variable.
Here is an example:{p_end}

{pstd}{inp:sysuse census}{break}
{inp:replace pop = 0 if (region == 1) | (region == 2)}{break}
{inp:iebaltab medage pop, groupvar(region) ftest browse}{p_end}

{pstd}In this example the variable {inp:pop} has no variance in test pair 1_2,
and that variable will be omitted from the F-test regression and
no stats are reported for this F-test for this test pair.{p_end}

{pstd}{ul:{it:Missing value: .t}}{break}
Missing value {inp:.t} is used to indicate that no descriptive statistics
were calculated for the full sample since the option {inp:total} was not used.{p_end}

{pstd}{ul:{it:Missing value: .v}}{break}
Missing value {inp:.v} is used to indicate that
all variance in the balance variable can be explained by one or several
other variables included in the regression.
This is defined as the R-squared value is 1.
Here are a few examples:{p_end}

{pstd}{inp:sysuse census}{break}
{inp:gen region2 = region}{break}
{inp:gen pop_neg = 0}{break}
{inp:replace pop_neg = pop * -1 if (region == 1) | (region == 2)}{break}
{inp:iebaltab medage pop region2, groupvar(region) covar(pop_neg) browse}{p_end}

{pstd}The variance in variable {inp:region2} is perfectly explained
by the group variable {inp:region} for each test pair
and the R-sqaured is 1 in all pair-wise regressions and no statistics are reported.
Similarly, {inp:pop_neg} that is included as a covariate control variable
has prefect negative correlation with the balance variable {inp:pop} in test pair 1_2.
The R-sqaured is 1 in the regression for pair 1_2 and no pair-wise statistics are reported for that pair.{p_end}

{title:Examples}

{pstd}{hi:Example 1.}

{pmore}{inp:sysuse census}{break}
{inp:gen group = runiform() < .5}{break}
{inp:iebaltab pop medage, groupvar(group) browse}{break}
{inp:browse}{p_end}

{pmore}In the example above, Stata's built in census data is used.
First a dummy variable is created at random.
Using this random group variable a balance table is created testing for
differences in {inp:pop} and {inp:medage}.
By using {inp:browse} the data in memory is replaced with the table so that
the table can be used in the browse window.
You most likely never should use the {inp:browse} option in your final code
but it is convenient in examples like this and when first testing the command.
See examples on how to save the table to a file on disk below.{p_end}

{pstd}{hi:Example 2.}

{pmore}{inp:sysuse census}{break}
{inp:iebaltab pop medage, groupvar(region) browse}{break}
{inp:browse}{p_end}

{pmore}In this example we use the variable region as group variable that has four categories.
All groups are tested against each other.{p_end}

{pstd}{hi:Example 3.}

{pmore}{inp:sysuse census}{break}
{inp:iebaltab pop medage, groupvar(region) browse control(4)}{break}
{inp:browse}{p_end}

{pmore}Comparing all groups against each other becomes unfeasible when the number of
categories in the group variable grows.
The option {inp:control()} overrides this behavior so that the category indicated
in this options are tested against all other groups,
but the other groups are not tested against each other.
For statistics where the direction matters (for example {it:diff} or {it:beta})
the order is changed so that the test is ({it:other_group} - {it:control})
such that a positive value indicates that the other group has a higher
mean in the balance variable.{p_end}

{pstd}{hi:Example 4.}

{pmore}{inp:sysuse census}{break}
{inp:iebaltab pop medage, groupvar(region) browse control(4) stats(desc(var) pair(p))}{break}
{inp:browse}{p_end}

{pmore}You can control which statistics to output in using the {inp:stats()} option.
In this example, the sub-option {inp:desc(var)} indicates that
the variance should be displayed in the descriptive statistics section
instead of standard error which is the default.
The sub-option {inp:pair(p)} indicates that
the p-value in from the t-tests in the pairwise test section should be displayed
instead of the difference in mean between the groups which is the default.
See above in this help file for full details on the sub-options you may use.{p_end}

{pstd}{hi:Example 5.}

{pmore}{inp:sysuse census}{break}
{inp:local outfld {it:"path/to/folder"}}{break}
{inp:iebaltab pop medage, groupvar(region) control(4) ///}{break}
{space 2}{inp:stats(desc(var) pair(p)) replace ///}{break}
{space 2}{inp:savecsv("`outfld'/iebtb.csv") savexlsx("`outfld'/iebtb.xlsx") ///}{break}
{space 2}{inp:savetex("`outfld'/iebtb.tex") texnotefile("`outfld'/iebtb_note.tex")}{p_end}

{pmore}This example shows how to export the tables to the three formats supported.
CSV, Excel and LaTeX.
To run this code you must update the path {it:"path/to/folder"} to point
to a folder on your computer where the tables can be exported to.
This is what we recommend over using the {inp:browse} options for final code.
When exporting to LaTeX we recommend exporting the note to a seperate file
using the option {inp:texnotefile()} and then import it in LaTeX using the
package {inp:threeparttable} like the code below.
It makes it easier to align the note with the table when LaTeX adjust the size
of the table to fit a page.

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

{pstd}{hi:Example 6.}

{pmore}{inp:sysuse census}{break}
{inp:iebaltab pop medage, groupvar(region)}{break}
{inp:local rnum = rownumb(r(iebtab_rmat),"medage")}{break}
{inp:local cnum = colnumb(r(iebtab_rmat),"p_2_4")}{break}
{inp:local p_medage_2_4 = el(r(iebtab_rmat),`rnum',`cnum')}{break}
{inp:di "The p-value in the test for medage between region 2 and 4 is: `p_medage_2_4'"}{p_end}

{pmore}In this example none of the export options ({inp:browse}, {inp:savecsv()} etc.) are used
and the only place where the results are stored
is in the {inp:r(iebtab_rmat)} matrix.
The {inp:rownumb()} and the {inp:colnumb()} functions can be used to get
the row and column number from the row and column names.
These row and and column numbers can be used to get the individual value in the function {inp:el()}.
If you know the row and column number you can use the {inp:el()} function directly.{p_end}


{title:Author}

{phang}All commands in ietoolkit are developed by DIME Analytics at DIME, The World Bank's department for Development Impact Evaluations.

{phang}Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iebaltab" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
