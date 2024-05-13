# Title

__iebaltab__ - produces balance tables with multiple groups or treatment arms

# Syntax

__iebaltab__ _balancevarlist_ [if] [in] [weight], __**group**var__(_varname_) [ _columnrow_options_ _estimation_options_ _stat_display_options_ _label_note_options_ _export_options_
_latex_options_ ]

where _balancevarlist_ is one or several continuous or binary variables (from here on called balance variables) for which the command
will test for differences across the categories in __groupvar__(_varname_).

## Required options

| _options_ | Description |
|-----------|-------------|
| __**group**var__(_varname_) | Variable indicating the groups (ex. treatment arms) to test across |

## Column and row option

| _options_ | Description |
|-----------|-------------|
| __**co**ntrol__(_groupcode_) | Indicate a single group that all other groups are tested against. Default is all groups are tested against each other |
| __**or**der__(_groupcodelist_) | Manually set the order the groups appear in the table. Default is ascending. See details on _groupcodelist_ below |
| __tot:al__ | Include descriptive stats on all observations included in the table |
| __onerow__ | Write number of observations (and number of clusters if applicable) in one row at the bottom of the table |

## Estimation options

| _options_ | Description |
|-----------|-------------|
| __vce__(_vce_types_) | Options for estimating variance. See below and `help vce_options` for supported options |
| __**fix**edeffect__(_varname_) | Include fixed effects in the pair-wise regressions (and for F-tests if applicable) |
| __**cov**ariates__(_varlist_) | Include covariates (control variables) in the pair-wise regressions (and for F-tests if applicable) |
| __**ft**est__ | Include a row with the F-test for joint significance across all balance variables for each test pair |
| __**feqt**est__ | Include a column with the F-test for joint significance across all groups for each variable |

## Statistics display options

| _options_ | Description |
|-----------|-------------|
| __stats__(_stats_string_) | Specify which statistics to display in the tables. See options for _stats_string_ below |
| __**star**levels__(_numlist_) | Manually set the three significance levels used for significance stars |
| __**nostar**s__ | Do not add any stars to the table |
| __**form**at__(_%fmt_) | Apply Stata formats to the non-integer values outputted in the table. See `help format` for format options. |

## Label/notes option

| _options_ | Description |
|-----------|-------------|
| __**groupc**odes__ | Use the values in the `groupvar()` variable as column titles. Default is to use value labels if any |
| __**groupl**abels__(_codetitles_) | Manually set the group column titles. See details on _codetitles_ below |
| __**totall**abel__(_string_) | Manually set the title of the total column |
| __**rowv**arlabels__ | Use the variable labels instead of variable name as row titles |
| __**rowl**abels__(_nametitles_) | Manually set the row titles. See details on _nametitles_ below |
| __nonote__ | Suppress the default not at the bottom of the table |
| __addnote__(_string_) | Add a manual note to the bottom of the table |

## Export options

| _options_ | Description |
|-----------|-------------|
| __browse__ | View table in the data browser |
| __**savex**lsx__(_filename_) | Save table to Excel file on disk |
| __**savec**sv__(_filename_) | Save table to csv-file on disk |
| __**savet**ex__(_filename_) | Save table to LaTeX file on disk |
| __texnotefile__(_filename_) | Save table note in a separate LaTeX file on disk |
| __replace__ | Replace file on disk if the file already exists |

## LaTeX options

| _options_ | Description |
|-----------|-------------|
| __**texn**otewidth__(_numlist_) | Manually adjust width of note |
| __**texc**aption__(_string_) | Specify LaTeX table caption |
| __**texl**abel__(_string_) | Specify LaTeX label |
| __**texdoc**ument__ | Create a stand-alone LaTeX document |
| __texcolwidth__(_string_) | Limit width of the first column on LaTeX output |

# Description

`iebaltab` is a command that generates balance tables (difference-in-means tables).
The command tests for statistically significant difference in the balance variables between
the categories defined in the `groupvar()`. The command can either test one control group
against all other groups, using the `control()` option,
or test all groups against each other (the default). The command also allows for
fixed effects, covariates and different types of variance estimators.

The balance variables are expected to be continuous or binary variables.
Categorical variables (for example 1=single, 2=married, 3=divorced) will not
generate an error but will be treated like a continuous variable
which is most likely statistically invalid.
Consider converting each category to binary variables.

The command can also add a note to the bottom of the table.
The default note is not meant to be included in the final publication.
It includes technical information about how the command was specified.
This is helpful in the early stage of research where several specifications
are often explored, but should be replace with a more human readable note
in the final version.

See the :estimation/statistics definitions
section below for a detailed documentation of what statistics this command
calculates and how they are calculated.

# Options

## Required options

__**group**var__(_varname_) specifies the variable indicating groups
(for example treatment arms) across which the command will
test for difference in mean of the balance variable.
The group variable can only be one variable and
it must be numeric and may only hold integers.
See `group()` in `help egen` for help on creating a single variable where
each integer represents a category from string variables and/or multiple variables.
Observations with missing values in this variable will be excluded when running this command.

## Column and row options

__**co**ntrol__(_groupcode_) specifies one group that is the control group
that all other groups are tested against for difference in means and
where _groupcode_ is an integer used in `groupvar()`.
The default is that all groups are tested against each other.
The control group will be listed first (leftmost) in the table
unless another order is specified in `order()`.
When using `control()` the order of the groups in the pair is (non-control)-(control)
so that a positive statistic (in for example _diff_ or _beta_) indicates that
the mean for the non-control is larger than for the control.

__**or**der__(_groupcodelist_) manually sets the column order of the groups in the table. _groupcodelist_ may
be any or all of the values in the group variable specified in `groupvar()`.
The default order if this option is omitted is ascending order of the values in the group variable.
If any values in `groupvar()` are omitted when using this option,
they will be sorted in ascending order after the values included.

__tot:al__ includes a column with descriptive statistics on the full sample.
This column still exclude observations with missing values in `groupvar()`.

__onerow__ displays the number of observations in an additional row
at the bottom of the table. If the number of observations are not identical
across all rows within a column, then this option throws an error.
This also applies to number of clusters.
If not specified, the number of observations (and clusters) per variable per group
is displayed on the same row in an additional column
next to the descriptive statistics.

## Estimation options

__vce__(_vce_types_) sets the type of variance estimator
to be used in all regressions for this command.
See `help vce_option` for more details.
However, the types allowed in this command are only
`robust`, `cluster clustervar` or `bootstrap`.
See the estimation definition section
for exact definitions on how these vce types are included in the regressions.

 __**fix**edeffect__(_varname_) specifies a single variable to be used as fixed effects in all regressions
part from descriptive stats regressions.
The variable specified must be a numeric variable.
If more than one variable is needed as fixed effects, and it is not desirable to combine multiple variables into one
(using for example `group()` in `egen` - see `help egen`),
then they can be included using the {opt i.} notation in the `covariates()` option.
See the estimation definition section for exact definitions on how the fixed effects are included in the regressions.

__**cov**ariates__(_varlist_) includes the variables specified in the regressions for t-tests (and for
F-tests if applicable) as covariate variables (control variables). See the description section above for details on how the covariates
are included in the estimation regressions. The covariate variables must be numeric variables.
See the estimation definition section for exact definitions on how the covariates are included in the regressions.

__**ft**est__ adds a single row at the bottom of the table with
one F-test for each test pair, testing for joint significance across all balance variables.
See the estimation definition section for exact definitions on how these tests are estimated.

__**feqt**est__ adds a single column in the table with an F-test for each balance variable,
testing for joint significance across all groups in `groupvar()`.
See the estimation definition section for exact definitions on how these tests are estimated.

## Statistics display options

__stats__(_stats_string_)
indicates which statistics to be displayed in the table.
The _stats_string_ is expected to be on this format (where at least one of the sub-arguments `desc`, `pair`, `f` and `feq` are required):

```
stats(desc(desc_stats) pair(pair_stats) f(f_stats) feq(feq_stats))
```

The table below lists the valid values for
_desc_stats_, _pair_stats_, _f_stats_ and _feq_stats_.
See the estimation definition section
for exact definitions of these values and how they are estimated/calculated.

| Type | Options
|-----------|-------------|
| _desc_stats_ | `se` `var` `sd` |
| _pair_stats_ | `diff` `beta` `t` `p` `nrmd` `nrmb` `se` `sd` `none` |
| _f_stats_ | `f` `p` |
| _feq_stats_ | `f` `p` |

__**star**levels__(_numlist_) manually sets the
three significance levels used for significance stars.
Expected input is decimals (between the value 0 and 1) in descending order.
The default is (.1 .05 .01) where .1 corresponds
to one star, .05 to two stars and .01 to three stars.

 __**nostar**s__ makes the command not add any stars to the table
regardless of significance levels.

__**form**at__(_%fmt_) applies the Stata formats specified to all values outputted
in the table apart from values that always are integers.
See `help format` for format options
Example of values that always are integers is number of observations.
For these integer values the format is always %9.0f.
The default for all other values when this option is not used is %9.3f.

## Label/notes option

__**groupc**odes__ makes the integer values used for the group codes in
`groupvar()` the group column titles.
The default is to use the value labels used in `groupvar()`.
If no value labels are used for the variable in `groupvar()`,
then this option does not make a difference.

 __**groupl**abels__(_codetitles_) manually sets the group column titles.
_codetitles_ is a string on the following format:

```
grouplabels("code1 title1 @ code2 title2 @ code3 title3")
```

Where code1, code2 etc. must correspond to the integer values used for each
group used in the variable `groupvar()`,
and title1, title2 etc. are the titles to be used for the corresponding integer value.
The character `@` may not be used in any title.
Codes omitted from this option will be assigned a column title
as if this option was not used.
This option takes precedence over _groupcodes_ when used together,
meaning that group codes are only used for groups
that are not included in the _codetitlestring_.
The title can consist of several words.
Everything that follows the code until the end of a string
or a `@` will be included in the title.

__**totall**abel__(_string_) manually sets the column title for the total column.

__**rowv**arlabels__ use the variable labels instead of variable name as row titles.
The default is to use the variable name. For variables with no variable label defined,
the variable name is used as row label even when this option is specified.

__**rowl**abels__(_nametitles_) manually sets the row titles for each
of the balance variables in the table.
_nametitles_ is a string in the following format:

```
rowlabels("name1 title1 @ name2 title2 @ name3 title3")
```

Where name1, name2 etc. are variable names used as balance variables,
and title1, title2 etc. are the titles to be used for the corresponding variable.
The character `@` may not be used in any of the titles.
Variables omitted from this option are assigned a row title as if this option was not used.
This option takes precedence over `rowvarlabels` when used together,
meaning that default labels are only used for variables
that are not included in the _nametitlestring_.
The title can consist of several words.
Everything that follows the variable name until
the end of a string or a `@` will be included in the title.

__nonote__ suppresses the default note that the command adds to
the bottom of the table with technical information
on how the command was specified.
This note is great during explorative analysis as it documents how
`iebaltab` was specified to generate exactly that table.
Eventually however, this note should probably be replaced with
a note more suitable for publication.

__addnote__(_string_) adds the string provided in this option
to the note at the bottom of table.
If `nonote` is not used, then this manually provided note
is added to the end of the default note.

## Export options

__browse__ replaces the data in memory with the table
so it can be viewed using the command `browse` instead of saving it to disk.
This is only meant to be used during explorative analysis
when figuring out how to specify the command.
Note that this overwrites data in memory.

__**savex**lsx__(_filename_) exports the table to an Excel (.xsl/.xlsx) file and saves it on disk.

__**savec**sv__(_filename_) exports the table to a comma separated (.csv) file and saves it on disk.

__**savet**ex__(_filename_) exports the table to a LaTeX (.tex) file and saves it on disk.

__texnotefile__(_filename_) exports the table note in a separate LaTeX file on disk.
When this option is used, no note is included in the `savetex()` file.
This allows importing the table using the `threeparttable` LaTeX package which
is an easy way to make sure the note always has the same width as the table.
See example in the example section below.

__replace__ allows for the file in `savexlsx()`, `savexcsv()`, `savetex()` or `texnotefile()`
to be overwritten if the file already exist on disk.

## LaTeX options

__**texn**otewidth__(_numlist_) manually adjusts the width of the note
to fit the size of the table.
The note width is a multiple of text width.
If not specified, default is one, which makes the table width equal to text width.
However, when the table is resized when rendered in LaTeX
this is not always the same as the table width.
Consider also using `texnotefile()` and the LaTeX package `threeparttable`.

__**texc**aption__(_string_) writes the table's caption in LaTeX file.
Can only be used with option `texdocument`.

__**texl**abel__(_string_) specifies table's label,
used for meta-reference across LaTeX file.
Can only be used with option `texdocument`.

__**texdoc**ument__ creates a stand-alone LaTeX document ready to be compiled.
The default is that `savetex()` creates a fragmented LaTeX file
consisting only of a tabular environment.
This fragment is then meant to be imported to a main LaTeX file
that holds text and may import other tables.

__texcolwidth__(_string_) limits the width of table's first column
so that a line break is added when a variable's name or label is too long.
{it:string} must consist of a numeric value with one of the following units:
"cm", "mm", "pt", "in", "ex" or "em".
For more information on these units,
[check LaTeX length's manual](https://en.wikibooks.org/wiki/LaTeX/Lengths).

# Estimation/statistics definitions

This section details the regressions that are used to estimate
the statistics displayed in the balance tables generated by this command.
For each test there is a "basic form" example to highlight the core of the test,
and an "all options" example that shows exactly how all options are applied.
Here is a glossary for the terms used in this section:

| Term | Definition |
|-----------|-------------|
| _balance variable_ | The variables listed as _balancevarlist_ |
| _groupvar_ | The variable specified in `groupvar()` |
| _groupcode_ | Each value in _groupvar_ |
| _testpair_ | Combination of _group codes_ to be used in pair wise tests |
| _tp_dummy_ | A dummy variable where the first _group code_ in a _test pair_ has the value 1 and the second _group code_ has the value 0, and all other observations has missing values |

Each section below has a table that shows how the stats are estimated/calculated for each type of statistics. This is what each column means.
A star (*) in the _Stat_ column indicate that is the optional statistics displayed by default if the `stats()` option is not used.
The _Display option_ column shows what sub-option to use in `stats()` to display this statistic.
The _Mat col_ column shows what the column name in the result matrix for the column that stores this stat. See more about the result matrices in the _Result matrices_ section.

## Group descriptive statistics

Descriptive statistics for all groups are always displayed in the table.
If option `total` is used then these statistics are also calculated on the full sample.
For each balance variable and for each value group code,
the descriptive statistics is calculated using the following code:

_basic form:_
```
reg balancevar if groupvar = groupcode
```

_all options:_
```
reg balancevar if groupvar = groupcode weights, vce(vce_option)
```

See above for description of each column in this table.
_gc_ stands for _groupcode_ (see definition of _groupcode_ above).
If the option `total` is used,
then _gc_ will also include _t_ for stats on the full sample.
The last column shows how the command obtains the statistic in the Stata code.
These statistics are stored in
a the result matrix called `r(iebtab_rmat)`.


| Stat | Display option | Mat col | Estimation/calculation |
| --- | --- | --- | --- |
| # obs | Always displayed | n_gc | `e(N)` after `reg` |
| cluster | Displayed if used | cl_gc | `e(N_clust)` after `reg` |
| mean | Always displayed | mean_gc | `_b[cons]` after `reg` |
| se * | `stats(desc(se))` | se_gc | `_se[cons]` after `reg` |
| var | `stats(desc(var))` | var_gc | `e(rss)/e(df_r)` after `reg` |
| sd | `stats(desc(sd))` | sd_gc | `_se[_cons]*sqrt(e(N))` after `reg` |


## Pair-wise test statistics

Pair-wise test statistics is always displayed in the table
unless `stats(pair(none))` is used.
For each balance variable and for each test pair, this code is used.
Since observations not included in the test pair have missing values in the test pair dummy,
they are excluded from the regression without using an if-statement.

_basic form:_
```
reg balancevar tp_dummy
test tp_dummy
```

_all options:_
```
reg balancevar tp_dummy covariates i.fixedeffect weights, vce(vce_option)
test tp_dummy
```

See above for description of each column in this table.
_tp_ stands for _test pair_, see definition above.
The last column shows how the command obtains the stat in the Stata code.
See the group descriptive statistics above for definitions on
_mean_1_, _mean_2_, _var_1_ and _var_2_
also used in the table below.
These statistics are stored in
a the result matrix called `r(iebtab_rmat)`.

| Stat | Display option | Mat col | Estimation/calculation |
| --- | --- | --- | --- |
| diff * | `stats(pair(diff))` | diff_tp | If pair 1_2: `mean_1`-`mean_2` |
| beta | `stats(pair(beta))` | beta_tp | `e(b)[1,1]` after `reg` |
| t | `stats(pair(t))` | t_tp | `_b[tp_dummy]/_se[tp_dummy]` after `reg` |
| p | `stats(pair(p))` | p_tp | `e(p)` after `test` |
| nrmd | `stats(pair(nrmd))` | nrmd_tp | If pair 1_2: `diff_tp/sqrt(.5*(var_1+var_2))` |
| nrmb | `stats(pair(nrmb))` | nrmb_tp | If pair 1_2: `beta_tp/sqrt(.5*(var_1+var_2))` |
| se | `stats(pair(se))` | se_tp | `_se[tp_dummy]` after `reg` |
| sd | `stats(pair(sd))` | sd_tp | `_se[tp_dummy] * sqrt(e(N))` after `reg` |



## F-test statistics for balance across all balance variables

Displayed in the balance table if the option `ftest` is used.
For each test pair the following code is used.

_basic form:_
```
reg tp_dummy balancevars
testparm balancevars
```

_all options:_
```
reg tp_dummy balancevars covariates i.fixedeffect weights, vce(vce_option)
testparm balancevars
```

See above for description of each column in this table.
_tp_ stands for _test pair_, see definition above.
These statistics are stored in
a the result matrix called `r(iebtab_fmat)`.

| Stat | Display option | Mat col | Estimation/calculation |
| --- | --- | --- | --- |
| # obs | Always displayed | fn_tp | `e(N)` after `reg` |
| cluster | Displayed if used | fcl_tp | `e(N_clust)` after `reg` |
| f * | `stats(f(f))` | ff_tp | `r(F)` after `testparm` |
| p | `stats(f(p))` | fp_tp | `r(p)` after `testparm` |


## F-test statistics for balance across all groups

Displayed in the balance table if the option `feqtest` is used.
For each balance variable the below code is used where
`feqtestinput` is a list on the format
`x2.groupvar = x3.groupvar ... xn.groupvar = 0`,
and where _x2_, _x3_ ... _xn_,
represents all group codes apart from the first code.

_basic form:_
```
reg balancevar i.groupvar
test feqtestinput
```

_all options:_
```
reg balancevar i.groupvar covariates i.fixedeffect weights, vce(vce_option)
test feqtestinput
```

See above for description of each column in this table.
These statistics are stored in
a the result matrix called `r(iebtab_fmat)`.

| Stat | Display option | Mat col | Estimation/calculation |
| --- | --- | --- | --- |
| # obs | Always displayed | feqn | `e(N)` after `reg` |
| cluster | Displayed if used | feqcl | `e(N_clust)` after `reg` |
| f * | `stats(feq(f))` | feqf | `r(F)` after `test` |
| p | `stats(feq(p))` | feqp | `r(p)` after `test` |

# Result matrices

There is an unlimited variation in preferences for
how a balance table should be structured or look.
A single command like `iebaltab` simply cannot satisfy them all.
To still enable infinite customization this commands return two matrices
with all the stats calculated by this command.
From these matrices all values can be extracted and
put into any output of your liking.

The two returned matrices are called `iebtab_rmat` and `iebtab_fmat`.
All stats related to the F-test  across all balance variables (option `ftest`)
are stored in the `iebtab_fmat` matrix,
all other stats are stored in the `iebtab_rmat` matrix.
The `iebtab_fmat` matrix always has exactly one row with the row name `fstats`.
The `iebtab_rmat` matrix has one row per balance variable
and each row is named after each balance var.
In both matrices the column names corresponds to a statistics.
The column name for each statistics and its definition can be found
in the _Estimation/statistics definitions_ section above.

See examples in the end of this help file for how to access the values.

# Missing values

When statistics are estimated/calculated they can be missing for multiple reasons.
This section explain what each (`.c`,`.v` etc.) represents.
See `help missing` if you are not familiar with extended missing values.
The exported tables or the result matrices should never include
the standard missing value (`.`).
If you ever encounter the standard missing value in any of them,
please report that using the contact information at the bottom of this help file.

## Missing value: .b

Missing value `.b` means that the statistics
could not be estimated/calculated as bootstrapping was set
to be used as the variance estimator in `vce(bootstrap)`.
When bootstrap is used there is no single value for variance
to be reported in stat `desc(var)`.
As a result of that, the stats `pair(nrmd)` and `pair(nrmb)`
are not reported either as they use the variance as input.

## Missing value: .c

Missing value `.c` are only used when there is
no number of clusters to report as the errors estimations were not cluster.
A value for number of clusters are only reported if the
variance estimator option is set to `vce(cluster clustervar)`.

## Missing value: .f

Missing value `.f` is used to indicate that F-test option for
that statistics (either `fstat` or `feqstat`) was not used,
and the value was therefore not calculated.

## Missing value: .m

Missing value `.m` is used to indicate that an option to skip
a full section was used. For example, `stats(pair(none))` where all
pair-wise statistics are skipped.

## Missing value: .n

Missing value `.n` is used to indicate that the R-squared value
was not defined in the pair-wise regression for this test pair.
This is most likely caused by no variance in the balance variable.
Here is an example:

```
sysuse census
gen constant = 1
iebaltab medage constant, groupvar(region) browse
```

In this example the variable _constant_ has no variance.
This variable has the mean 1 and 0 variance in the descriptive statistics
and statistics can be reported in the descriptive statistics section.
However, the R-square value is not defined for any test pair
in the pair-wise regression,
and no pair-wise stats are reported for the _constant_ variable.

## Missing value: .o
Missing value `.o` is used to indicate that in the F-test regression
for joint significance across all balance variables (see option `ftest`)
for this test pair and at least one balance variable was omitted.
This is most likely caused by no variance in that balance variable.
Here is an example:

```
sysuse census
replace pop = 0 if (region == 1) | (region == 2)
iebaltab medage pop, groupvar(region) ftest browse
```

In this example the variable _pop_ has no variance in test pair 1_2,
and that variable will be omitted from the F-test regression and
no stats are reported for this F-test for this test pair.

## Missing value: .t

Missing value `.t` is used to indicate that no descriptive statistics
were calculated for the full sample since the option `total` was not used.

## Missing value: .v

Missing value `.v` is used to indicate that
all variance in the balance variable can be explained by one or several
other variables included in the regression.
This is defined as the R-squared value is 1.
Here are a few examples:

```sysuse census
gen region2 = region
gen pop_neg = 0
replace pop_neg = pop * -1 if (region == 1) | (region == 2)
iebaltab medage pop region2, groupvar(region) covar(pop_neg) browse
```

The variance in variable _region2_ is perfectly explained
by the group variable _region_ for each test pair
and the R-squared is 1 in all pair-wise regressions and no statistics are reported.
Similarly, _pop_neg_ that is included as a covariate control variable
has prefect negative correlation with the balance variable _pop_ in test pair 1_2.
The R-squared is 1 in the regression for pair 1_2 and no pair-wise statistics are reported for that pair.

# Examples

## Example 1

```
sysuse census
gen group = runiform() < .5
iebaltab pop medage, groupvar(group) browse
browse
```

In the example above, Stata's built in census data is used.
First a dummy variable is created at random.
Using this random group variable a balance table is created testing for
differences in _pop_ and _medage_.
By using `browse` the data in memory is replaced with the table so that
the table can be used in the browse window.
You most likely never should use the `browse` option in your final code
but it is convenient in examples like this and when first testing the command.
See examples on how to save the table to a file on disk below.

## Example 2

```
sysuse census
{inp:iebaltab pop medage, groupvar(region) browse
browse
```

In this example we use the variable region as group variable that has four categories.
All groups are tested against each other.

## Example 3

```
sysuse census
iebaltab pop medage, groupvar(region) browse control(4)
browse
```

Comparing all groups against each other becomes unfeasible when the number of
categories in the group variable grows.
The option `control()` overrides this behavior so that the category indicated
in this options are tested against all other groups,
but the other groups are not tested against each other.
For statistics where the direction matters (for example _diff_ or _beta_)
the order is changed so that the test is (_other_group_ - _control_)
such that a positive value indicates that the other group has a higher
mean in the balance variable.

## Example 4

```
sysuse census
iebaltab pop medage, groupvar(region) browse control(4) stats(desc(var) pair(p))
browse
```

You can control which statistics to output in using the `stats()` option.
In this example, the sub-option `desc(var)` indicates that
the variance should be displayed in the descriptive statistics section
instead of standard error which is the default.
The sub-option `pair(p)` indicates that
the p-value in from the t-tests in the pairwise test section should be displayed
instead of the difference in mean between the groups which is the default.
See above in this help file for full details on the sub-options you may use.

## Example 5

```
sysuse census
local outfld "path/to/folder"
iebaltab pop medage, groupvar(region) control(4) ///
  stats(desc(var) pair(p)) replace ///
  savecsv("`outfld'/iebtb.csv") savexlsx("`outfld'/iebtb.xlsx") ///
  savetex("`outfld'/iebtb.tex") texnotefile("`outfld'/iebtb_note.tex")
```

This example shows how to export the tables to the three formats supported.
CSV, Excel and LaTeX.
To run this code you must update the path _"path/to/folder"_ to point
to a folder on your computer where the tables can be exported to.
This is what we recommend over using the `browse` options for final code.
When exporting to LaTeX we recommend exporting the note to a separate file
using the option `texnotefile()` and then import it in LaTeX using the
package `threeparttable` like the code below.
It makes it easier to align the note with the table when LaTeX adjust the size
of the table to fit a page.
```
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
```

## Example 6

```
sysuse census
iebaltab pop medage, groupvar(region)
local rnum = rownumb(r(iebtab_rmat),"medage")
local cnum = colnumb(r(iebtab_rmat),"p_2_4")
local p_medage_2_4 = el(r(iebtab_rmat),`rnum',`cnum')
di "The p-value in the test for medage between region 2 and 4 is: `p_medage_2_4'"
```

In this example none of the export options (`browse`, `savecsv()` etc.) are used
and the only place where the results are stored
is in the `r(iebtab_rmat)` matrix.
The `rownumb()` and the `colnumb()` functions can be used to get
the row and column number from the row and column names.
These row and column numbers can be used to get the individual value in the function `el()`.
If you know the row and column number you can use the `el()` function directly.

# Feedback, bug reports and contributions

Please send bug-reports, suggestions and requests for clarifications
writing "ietoolkit iebaltab" in the subject line to: dimeanalytics@worldbank.org

You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through [GitHub repository](https://github.com/worldbank/ietoolkit) for `ietoolkit`.

# Author

All commands in `ietoolkit` are developed by DIME Analytics at DIME, The World Bank's department for Development Impact Evaluations.

Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group
