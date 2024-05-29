# help for `ieddtab`

__ieddtab__ - This command runs a Diff-in-Diff regression and displays the baseline values, the two 1st differences and the 2nd difference.

 For a more descriptive discussion on the intended usage and work flow of this command please see the [DIME Wiki](https://dimewiki.worldbank.org/Ieddtab)


# Syntax

`ieddtab` *varlist* [if] [in] [weight], `time(varname)` `treatment(varname)`   
	`covariates(varlist)` `starlevels(numlist)` `stardrop`  
	`errortype(string)` `rowl(abtype(string)` `rowlabtext(label_string)` `format(%fmt)`  
	`replace` `savetex(filepath)` `onerow` `nonumbers`  
	`nonotes` `addnotes(string)`  `texdoc(ument`  
	`texcaption(string)` `texlabel(string)` `texnotewidth(numlist)` `texvspace(string)`  


 Where varlist is a list of numeric continuous outcome variables (also called dependent variables or left hand side variables) to be used in the difference-in-difference regression(s) this command runs and presents the results from.

| Options               | Description |
|-----------------------|-------------|
| **Required options:** | |
| `time(varname)`       | Time dummy to use in diff-in-diff regression |
| `treatment(varname)`  | Treatment dummy to use in diff-in-diff regression |
| **Statistics options:** | |
| `covariates(varlist)` | Covariates to use in diff-in-diff regression |
| `vce(vce_types)`      | Options for variance estimation. Robust, cluster clustervar or bootstrap |
| `starlevels(numlist)` | Significance levels used for significance stars, default values are .1, .05, and .01 |
| `stardrop`            | Suppresses all significance stars in all tables. |
| `errortype(string)`   | Type of errors to display, default is standard errors. |
| **Output options:**   | |
| `rowlabtype(string)`  | Indicate what to use as row titles, default is variable name. |
| `rowlabtext(label_string)` | Manually enter the row titles using label strings (see below). |
| `nonote`              | Disable that the automatically generated note is displayed below the table. |
| `addnotes(string)`    | Manually add a note to be displayed below the regression result table. |
| `onerow`              | Display the number of observations on one row at the last row of the table. |
| `format(%fmt)`        | Set the rounding format of the calculated statistics in the table. |
| `replace`             | Replace the file on disk if it already exist. Has no effect if no option with file path is used. |
| **LaTeX options:**    | |
| `savetex(filepath)`   | Generate a LaTeX table of the result and save to the location of the file path. |
| `texdocument`         | Creates a stand-alone TeX document. |
| `texcaption(string)`  | Specify table's caption on TeX file. |
| `texlabel(string)`    | Specify table's label, used for meta-reference across TeX file. |
| `texnotewidth(numlist)` | Manually enter the width of the note on the TeX file. |
| `texvspace(string)`   | Manually set size of the line space between two rows on TeX output. |
| `nonumbers`           | Omit column numbers from table header in LaTeX output. |


# Description

`ieddtab` is a command that makes it easy to run and display results of differences-in-differences (diff-in-diff) regressions. The table that presents the results from the diff-in-diff regression also presents the mean when the variable in `time()` is 0 (i.e., baseline) for the two groups defined by the variable `treatment()` is 0 and 1 (i.e., control and treatment), and the table also presents the coefficient of the first difference regression in control and treatment.

The sample for each row in the table is defined by the sample included in the second difference regression shown below, where *outcome_var* is a variable the varlist (one per row) for `ieddtab`, interaction' is the interaction dummy listed in time() and the dummy listed in `treatment()`, and where `covariates` is the list of covariates included in covariates() if any. This means that any
observation that has any missing value in either of the two or in any
of the covariates will be omitted from all statistics presented in the table. The coefficient presented in the table for the diff-in-diff regression is the interaction of the time and treatment
variable.


# Options

**Required options:**

- `t(varname)` indicates which variable should be used as the time dummy to use in diff-in-diff regression. This must be a dummy variable, i.e., only have 0, 1, or missing as values, where 0 is baseline and 1 is follow-up.

- `treatment(varname)` indicates which variable should be used as the treatment dummy to use in diff-in-diff regression. This must be a dummy variable, i.e., only have 0, 1, or missing as values.

**Statistics options:**

- `covariates(varlist)` lists the variables that should be included as covariates (independent variables not reported in the table) in the two first difference regressions and the second difference regression. Unless the option `nonotes` is used a list of covariate variables is included below the table.

- `vce(vce_types)` sets the type of variance estimator to be used in all regressions for this command. See `vce_types` for more details. The only vce types allowed in this command are robust, cluster clustervar, or bootstrap. Option robust only applied to first and second difference estimators, not to baseline means.

- `starlevels(numlist)` sets the significance levels used for significance stars. Exactly three values must be listed if this option is used, all three values must be in descending order, and must be between 0 and 1. The default values are .1, .05, and .01. The levels specified in this option are ignored if `stardrop` is used.

- `stardrop` suppresses all significance stars in all tables and removes the note on significance levels from the table note.

- `errortype(string)` sets the type of error to display. Allowed values for this option are `se` for standard errors, `sd` for standard deviation, and `errhide` for not displaying any errors in the table. The default is to display standard errors.

**Output options:**

- `rowlabtype(string)` indicates what to use as row titles. The allowed values are `varname` using the variable name as row titles, `varlab` using the variable labels as row titles (varname will still be used if the variable does not have a variable label). The default is to use the variable name.

- `rowlabtext(label_string)` manually specifies the row titles using label strings. A label string is a list of variable names followed by the row title for that variable separated by "@@". For example `varA Row title variable A @@ varB Row title variable B`, where `varA` and `varB` are outcome variables used in this command. For variables not listed in `rowlabtext()` row titles will be determined by the input value or default value in `rowlabtype()`.

- `nonotes` disables that the command automatically generates and displays a note below the table describing the output in the table. The note includes a description on how the number of calculations are calculated, the significance levels used for stars and which covariates were used if any were used.

- `addnotes(string)` is used to manually add a note to be displayed below the regression result table. This note is put before the automatically generated note, unless option `nonotes` is specified, in which case only the manually added note is displayed.

- `onerow` indicates that the number of observations should be displayed on one row at the last row of the table instead of on each row. This requires that the number of observations are the same across all rows for each column.

- `format(%fmt)` sets the number formatting/rounding rule for all calculated statistics in the table, that is, all numbers in the table apart from the number of observations. Only valid Stata number formats are allowed. The default is `%9.2f`.

- `replace` if an option is used that outputs a file and a file with that name already exists at that location, then Stata will throw an error unless this option is used. If this option is used then Stata overwrites the file on disk with the new output. This option has no effect if no option with file path is used.

**LaTeX options:** 

- `savetex(filepath)` saves the table in TeX format to the location of the file path.

- `texdocument` creates a stand-alone TeX document that can be readily compiled, without the need to import it to a different file. As default, `savetex()` creates a fragmented TeX file consisting only of a tabular environment.

- `texcaption(string)` writes table's caption in TeX file. Can only be used with option `texdocument`.

- `texlabel(string)` specifies table's label, used for meta-reference across TeX file. Can only be used with option `texdocument`.

- `texnotewidth(numlist)` manually adjusts the width of the note to fit the size of the table. The note width is a multiple of text width. If not specified, default is one, which makes the table width equal to text width.

- `texvspace(string)` sets the size of the line space between two variable rows. `string` must consist of a numeric value and one of the following units: "cm", "mm", "pt", "in", "ex" or "em". Note that the resulting line space displayed will be equal to the specified value minus the height of one line of text. Default is "3ex". For more information on units, check LaTeX lengths manual.

- `nonumbers` omits column numbers from table header in LaTeX output. Default is to display column numbers.

# Examples

All the examples below can be run on Stata's built-in census data set, by first running this code:

- Open the built-in data set  
  `sysuse census`

- Calculate rates from absolute numbers  
  `replace death = 100 * death / pop`  
  `replace marriage = 100 * marriage / pop`  
  `replace divorce = 100 * divorce / pop`

- Randomly assign time and treatment dummies  
  `gen t = (runiform()<.5)`  
  `gen treatment = (runiform()<.5)`

**Example 1.**

`ieddtab death marriage divorce , t(time) treatment(treatment)`

This is the most basic way to run this command with three variables. This will output a table with the baseline means for treatment = 0 and treatment = 1, the first difference regression coefficient for treatment = 0 and treatment = 1 as well as the 2nd difference regression coefficient for treatment = 0 and treatment = 1.

**Example 2.**

`ieddtab death marriage divorce , t(time) treatment(treatment) rowlabtext("death Death Rate @@ divorce Divorce Rate") rowlabtype("varlab")`

The table generated by example 2 will have the same statistics as in example 1 but the row title for the variables death and divorce are entered manually and the row title for marriage will be its variable label instead of its variable name.

**Example 3.**

`ieddtab death marriage divorce , t(time) treatment(treatment) rowlabtype("varlab") savetex("DID table.tex") replace`

The table will be saved in the current directory under the name "DID table.tex". It will have the same statistics as in examples 1 and 2, and the row titles will be its variable labels.

### Acknowledgements

This command was initially suggested by Esteban J. Quinones, University of Wisconsin-Madison.

We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetical order):

- Benjamin Daniels

- Jonas Guthoff

- Nausheen Khan

- Varnitha Kurli

- Saori Iwamoto

- Meyhar Mohammed

- Michael Orevba

- Matteo Ruzzante

- Sakina Shibuya

- Leonardo Viotti

# Authors

All commands in ietoolkit are developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group

Please send bug-reports, suggestions, and requests for clarifications writing "ietoolkit ieddtab" in the subject line to:  
dimeanalytics@worldbank.org

You can also see the code, make comments to the code, see the version history of the code, and submit additions or edits to the code through the GitHub repository of ietoolkit:  
https://github.com/worldbank/ietoolkit

