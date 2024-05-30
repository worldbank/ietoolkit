# Title

__ieddtab__ - This command runs a Diff-in-Diff regression and displays the baseline values, the two 1st differences and the 2nd difference.

For a more descriptive discussion on the intended usage and work flow of this command please see the [DIME Wiki](https://dimewiki.worldbank.org/Ieddtab)


# Syntax

__ieddtab__ _varlist_ [if] [in] [weight], __**t**ime__(_varname_) __**treat**ment__(_varname_) [ __**covar**iates__(_varlist_) __**vce**__(_vce_types_) __**star**levels__(_numlist_) __stardrop__ __**err**ortype__(_string_) __**rowl**abtype__(_string_) __rowlabtext__(_label_string_) __format__(_%fmt_) __replace__ __**savet**ex__(_filepath_) __onerow__ __nonumbers__  __nonotes__ __**addn**otes__(_string_)  __**texdoc**ument__ __**texc**aption__(_string_) __**texl**abel__(_string_) __**texn**otewidth__(_numlist_) __texvspace__(_string_) ]  


Where varlist is a list of numeric continuous outcome variables (also called dependent variables or left hand side variables) to be used in the difference-in-difference regression(s) this command runs and presents the results from.


## Required options:

| Options               | Description |
|-----------------------|-------------|
| __**t**ime__(_varname_) | Time dummy to use in diff-in-diff regression |
| __**treat**ment__(_varname_) | Treatment dummy to use in diff-in-diff regression |

## Statistics options:

| Options               | Description |
|-----------------------|-------------|
| __**covar**iates__(_varlist_) | Covariates to use in diff-in-diff regression |
| __**vce**__(_vce_types_) | Options for variance estimation. __Robust__, __cluster__ _clustervar_ or __bootstrap__ |
| __**star**levels__(_numlist_) | Significance levels used for significance stars, default values are .1, .05, and .01 |
| __stardrop__ | Suppresses all significance stars in all tables. |
| __**err**ortype__(_string_) | Type of errors to display, default is standard errors. |


## Output options:

| Options               | Description |
|-----------------------|-------------|
| __**rowl**abtype__(_string_) | Indicate what to use as row titles, default is variable name. |
| __rowlabtext__(_label_string_) | Manually enter the row titles using label strings (see below). |
| __nonotes__ | Disable that the automatically generated note is displayed below the table. |
| __**addn**otes__(_string_) | Manually add a note to be displayed below the regression result table. |
| __onerow__| Display the number of observations on one row at the last row of the table. |
| __format__(_%fmt_) | Set the rounding format of the calculated statistics in the table. |
| __replace__ | Replace the file on disk if it already exist. Has no effect if no option with file path is used. |


## LaTeX options:

| Options               | Description |
|-----------------------|-------------|
| __**savet**ex__(_filepath_) | Generate a LaTeX table of the result and save to the location of the file path. |
| __**texdoc**ument__ | Creates a stand-alone TeX document. |
| __**texc**aption__(_string_) | Specify table's caption on TeX file. |
| __**texl**abel__(_string_)   | Specify table's label, used for meta-reference across TeX file. |
| __**texn**otewidth__(_numlist_) | Manually enter the width of the note on the TeX file. |
| __texvspace__(_string_) | Manually set size of the line space between two rows on TeX output. |
| __nonumbers__ | Omit column numbers from table header in LaTeX output. |


# Description

__ieddtab__ is a command that makes it easy to run and display results of differences-in-differences (diff-in-diff) regressions. The table that presents the results from the diff-in-diff regression also presents the mean when the variable in __time()__ is 0 (i.e., baseline) for the two groups defined by the variable __treatment()__ is 0 and 1 (i.e., control and treatment), and the table also presents the coefficient of the first difference regression in control and treatment.

The sample for each row in the table is defined by the sample included in the second difference regression shown below, where _outcome_var_ is a variable the varlist (one per row) for __ieddtab__, __interaction__ is the interaction dummy listed in __time()__ and the dummy listed in __treatment()__, and where __covariates__ is the list of covariates included in __covariates()__ if any. This means that any observation that has any missing value in either of the two or in any of the covariates will be omitted from all statistics presented in the table. The coefficient presented in the table for the diff-in-diff regression is the interaction of the time and treatment variable.

```
tempvar interaction
generate `interaction' = `time' * `treatment'
regress outcome_var `time' `treatment' `interaction' `covariates'
```

The baseline means are then calculated using the following code where the first line is control and the second line is treatment, and the variable __regsample__ is dummy indicating if the observation was included in the second difference on.

```
mean outcome_var if `treatment' == 0 & `time' == 0 & regsample == 1
mean outcome_var if `treatment' == 1 & `time' == 0 & regsample == 1
```

The first difference coefficients are then calculated using the following code where the first line is control and the second line is treatment. The coefficient displayed in the table is the coefficient of the variable __time__ which is the variable listed in __t()__.


```
regress outcome_var `time' `covariates' if `treatment' == 0 & regsample == 1
regress outcome_var `time' `covariates' if `treatment' == 1 & regsample == 1
```

# Options

## Required options:

__t__(_varname_) indicates which variable should be used as the time dummy to use in diff-in-diff regression. This must be a dummy variable, i.e., only have 0, 1, or missing as values, where 0 is baseline and 1 is follow-up.

__treatment__(_varname_) indicates which variable should be used as the treatment dummy to use in diff-in-diff regression. This must be a dummy variable, i.e., only have 0, 1, or missing as values.

__**Statistics options:**__

__**covar**iates__(_varlist_) lists the variables that should be included as covariates (independent variables not reported in the table) in the two first difference regressions and the second difference regression. Unless the option __nonotes__ is used a list of covariate variables is included below the table.

__**vce**__(_vce_types_) sets the type of variance estimator to be used in all regressions for this command. See __vce_types__ (`help vce_types`) for more details. The only vce types allowed in this command are robust, cluster clustervar, or bootstrap. Option robust only applied to first and second difference estimators, not to baseline means.

__**star**levels__(_numlist_) sets the significance levels used for significance stars. Exactly three values must be listed if this option is used, all three values must be in descending order, and must be between 0 and 1. The default values are .1, .05, and .01. The levels specified in this option are ignored if __stardrop__ is used.

__stardrop__ suppresses all significance stars in all tables and removes the note on significance levels from the table note.

__**err**ortype__(_string_) sets the type of error to display. Allowed values for this option are __se__ for standard errors, __sd__ for standard deviation, and __errhide__ for not displaying any errors in the table. The default is to display standard errors.

## Output options:

__**rowl**abtype__(_string_) indicates what to use as row titles. The allowed values are __varname__ using the variable name as row titles, __varlab__ using the variable labels as row titles (varname will still be used if the variable does not have a variable label). The default is to use the variable name.

__rowlabtext__(_label_string_) manually specifies the row titles using label strings. A label string is a list of variable names followed by the row title for that variable separated by "@@". For example _varA Row title variable A @@ varB Row title variable B_, where _varA_ and _varB_ are outcome variables used in this command. For variables not listed in __rowlabtext()__ row titles will be determined by the input value or default value in __rowlabtype()__.

__nonotes__ disables that the command automatically generates and displays a note below the table describing the output in the table. The note includes a description on how the number of calculations are calculated, the significance levels used for stars and which covariates were used if any were used.

__**addn**otes__(_string_) is used to manually add a note to be displayed below the regression result table. This note is put before the automatically generated note, unless option __nonotes__ is specified, in which case only the manually added note is displayed.

__onerow__ indicates that the number of observations should be displayed on one row at the last row of the table instead of on each row. This requires that the number of observations are the same across all rows for each column.

__format__(_%fmt_) sets the number formatting/rounding rule for all calculated statistics in the table, that is, all numbers in the table apart from the number of observations. Only valid Stata number formats (see `help format`) are allowed. The default is _%9.2f_.

__replace__ if an option is used that outputs a file and a file with that name already exists at that location, then Stata will throw an error unless this option is used. If this option is used then Stata overwrites the file on disk with the new output. This option has no effect if no option with file path is used.

## LaTeX options:

__**savet**ex__(_filepath_) saves the table in TeX format to the location of the file path.

__**texdoc**ument__ creates a stand-alone TeX document that can be readily compiled, without the need to import it to a different file. As default, __savetex()__ creates a fragmented TeX file consisting only of a tabular environment.

__**texc**aption__(_string_) writes table's caption in TeX file. Can only be used with option texdocument.

__**texl**abel__(_string_) specifies table's label, used for meta-reference across TeX file. Can only be used with option texdocument.

__**texn**otewidth__(_numlist_) manually adjusts the width of the note to fit the size of the table. The note width is a multiple of text width. If not specified, default is one, which makes the table width equal to text width.

__texvspace__(_string_) sets the size of the line space between two variable rows. _string_ must consist of a numeric value and one of the following units: "cm", "mm", "pt", "in", "ex" or "em". Note that the resulting line space displayed will be equal to the specified value minus the height of one line of text. Default is "3ex". For more information on units, check [LaTeX lengths manual](https://en.wikibooks.org/wiki/LaTeX/Lengths).

__nonumbers__ omits column numbers from table header in LaTeX output. Default is to display column numbers.

# Examples

All the examples below can be run on Stata's built-in census data set, by first running this code:

* Open the built-in data set  

```
sysuse census
```

* Calculate rates from absolute numbers  

```
replace death = 100 * death / pop
replace marriage = 100 * marriage / pop  
replace divorce = 100 * divorce / pop
```

* Randomly assign time and treatment dummies

```
gen t = (runiform()<.5)
gen treatment = (runiform()<.5)
```  

## Example 1.

```
ieddtab death marriage divorce , t(time) treatment(treatment)
```

This is the most basic way to run this command with three variables. This will output a table with the baseline means for treatment = 0 and treatment = 1, the first difference regression coefficient for treatment = 0 and treatment = 1 as well as the 2nd difference regression coefficient for treatment = 0 and treatment = 1.

## Example 2.

```
ieddtab death marriage divorce , t(time) treatment(treatment) rowlabtext("death Death Rate @@ divorce Divorce Rate") rowlabtype("varlab")
```

The table generated by example 2 will have the same statistics as in example 1 but the row title for the variables death and divorce are entered manually and the row title for marriage will be its variable label instead of its variable name.

## Example 3.

```
ieddtab death marriage divorce , t(time) treatment(treatment) rowlabtype("varlab") savetex("DID table.tex") replace
```

The table will be saved in the current directory under the name "DID table.tex". It will have the same statistics as in examples 1 and 2, and the row titles will be its variable labels.

# Acknowledgements

This command was initially suggested by Esteban J. Quinones, University of Wisconsin-Madison.

We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetical order):

Benjamin Daniels

Jonas Guthoff

Nausheen Khan

Varnitha Kurli

Saori Iwamoto

Meyhar Mohammed

Michael Orevba

Matteo Ruzzante

Sakina Shibuya

Leonardo Viotti

# Feedback, bug reports and contributions

Please send bug-reports, suggestions, and requests for clarifications writing "ietoolkit ieddtab" in the subject line to:  
dimeanalytics@worldbank.org

You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through [GitHub repository](https://github.com/worldbank/ietoolkit) for __ietoolkit__.


# Author

All commands in ietoolkit are developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group
