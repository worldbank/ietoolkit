{smcl}
{* *! version 0.0 20240404}{...}
{hline}
{pstd}help file for {hi:ieddtab}{p_end}
{hline}

{title:Title}

{phang}{bf:ieddtab} - This command runs a Diff-in-Diff regression and displays the baseline values, the two 1st differences and the 2nd difference.
{p_end}

{phang}For a more descriptive discussion on the intended usage and work flow of this command please see the {browse "https://dimewiki.worldbank.org/Ieddtab":DIME Wiki}
{p_end}

{title:Syntax}

{phang}{bf:ieddtab} {it:varlist} [if] [in] [weight], {bf:{ul:t}ime}({it:varname}) {bf:{ul:treat}ment}({it:varname}) [ {bf:{ul:covar}iates}({it:varlist}) {bf:{ul:vce}}({it:vce_types}) {bf:{ul:star}levels}({it:numlist}) {bf:stardrop} {bf:{ul:err}ortype}({it:string}) {bf:{ul:rowl}abtype}({it:string}) {bf:rowlabtext}({it:label_string}) {bf:format}({it:%fmt}) {bf:replace} {bf:{ul:savet}ex}({it:filepath}) {bf:onerow} {bf:nonumbers}  {bf:nonotes} {bf:{ul:addn}otes}({it:string})  {bf:{ul:texdoc}ument} {bf:{ul:texc}aption}({it:string}) {bf:{ul:texl}abel}({it:string}) {bf:{ul:texn}otewidth}({it:numlist}) {bf:texvspace}({it:string}) ]  
{p_end}

{phang}Where varlist is a list of numeric continuous outcome variables (also called dependent variables or left hand side variables) to be used in the difference-in-difference regression(s) this command runs and presents the results from.
{p_end}

{dlgtab:Required options:}

{synoptset 18}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:t}ime}({it:varname})}Time dummy to use in diff-in-diff regression{p_end}
{synopt: {bf:{ul:treat}ment}({it:varname})}Treatment dummy to use in diff-in-diff regression{p_end}
{synoptline}

{dlgtab:Statistics options:}

{synoptset 19}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:covar}iates}({it:varlist})}Covariates to use in diff-in-diff regression{p_end}
{synopt: {bf:{ul:vce}}({it:vce_types})}Options for variance estimation. {bf:Robust}, {bf:cluster} {it:clustervar} or {bf:bootstrap}{p_end}
{synopt: {bf:{ul:star}levels}({it:numlist})}Significance levels used for significance stars, default values are .1, .05, and .01{p_end}
{synopt: {bf:stardrop}}Suppresses all significance stars in all tables.{p_end}
{synopt: {bf:{ul:err}ortype}({it:string})}Type of errors to display, default is standard errors.{p_end}
{synoptline}

{dlgtab:Output options:}

{synoptset 24}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:rowl}abtype}({it:string})}Indicate what to use as row titles, default is variable name.{p_end}
{synopt: {bf:rowlabtext}({it:label_string})}Manually enter the row titles using label strings (see below).{p_end}
{synopt: {bf:nonotes}}Disable that the automatically generated note is displayed below the table.{p_end}
{synopt: {bf:{ul:addn}otes}({it:string})}Manually add a note to be displayed below the regression result table.{p_end}
{synopt: {bf:onerow}}Display the number of observations on one row at the last row of the table.{p_end}
{synopt: {bf:format}({it:%fmt})}Set the rounding format of the calculated statistics in the table.{p_end}
{synopt: {bf:replace}}Replace the file on disk if it already exist. Has no effect if no option with file path is used.{p_end}
{synoptline}

{dlgtab:LaTeX options:}

{synoptset 21}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:savet}ex}({it:filepath})}Generate a LaTeX table of the result and save to the location of the file path.{p_end}
{synopt: {bf:{ul:texdoc}ument}}Creates a stand-alone TeX document.{p_end}
{synopt: {bf:{ul:texc}aption}({it:string})}Specify table{c 39}s caption on TeX file.{p_end}
{synopt: {bf:{ul:texl}abel}({it:string})}Specify table{c 39}s label, used for meta-reference across TeX file.{p_end}
{synopt: {bf:{ul:texn}otewidth}({it:numlist})}Manually enter the width of the note on the TeX file.{p_end}
{synopt: {bf:texvspace}({it:string})}Manually set size of the line space between two rows on TeX output.{p_end}
{synopt: {bf:nonumbers}}Omit column numbers from table header in LaTeX output.{p_end}
{synoptline}

{title:Description}

{pstd}{bf:ieddtab} is a command that makes it easy to run and display results of differences-in-differences (diff-in-diff) regressions. The table that presents the results from the diff-in-diff regression also presents the mean when the variable in {bf:time()} is 0 (i.e., baseline) for the two groups defined by the variable {bf:treatment()} is 0 and 1 (i.e., control and treatment), and the table also presents the coefficient of the first difference regression in control and treatment.
{p_end}

{pstd}The sample for each row in the table is defined by the sample included in the second difference regression shown below, where {it:outcome_var} is a variable the varlist (one per row) for {bf:ieddtab}, {bf:interaction} is the interaction dummy listed in {bf:time()} and the dummy listed in {bf:treatment()}, and where {bf:covariates} is the list of covariates included in {bf:covariates()} if any. This means that any observation that has any missing value in either of the two or in any of the covariates will be omitted from all statistics presented in the table. The coefficient presented in the table for the diff-in-diff regression is the interaction of the time and treatment variable.
{p_end}

{input}{space 8}tempvar interaction
{space 8}generate `interaction' = `time' * `treatment' 
{space 8}regress outcome_var `time' `treatment' `interaction' `covariates' 
{text}
{pstd}The baseline means are then calculated using the following code where the first line is control and the second line is treatment, and the variable {bf:regsample} is dummy indicating if the observation was included in the second difference on.
{p_end}

{input}{space 8}mean outcome_var if `treatment' == 0 & `time' == 0 & regsample == 1 
{space 8}mean outcome_var if `treatment' == 1 & `time' == 0 & regsample == 1 
{text}
{pstd}The first difference coefficients are then calculated using the following code where the first line is control and the second line is treatment. The coefficient displayed in the table is the coefficient of the variable {bf:time} which is the variable listed in {bf:t()}.
{p_end}

{input}{space 8}regress outcome_var `time' `covariates' if `treatment' == 0 & regsample == 1 
{space 8}regress outcome_var `time' `covariates' if `treatment' == 1 & regsample == 1 
{text}
{title:Options}

{dlgtab:Required options:}

{pstd}{bf:t}({it:varname}) indicates which variable should be used as the time dummy to use in diff-in-diff regression. This must be a dummy variable, i.e., only have 0, 1, or missing as values, where 0 is baseline and 1 is follow-up.
{p_end}

{pstd}{bf:treatment}({it:varname}) indicates which variable should be used as the treatment dummy to use in diff-in-diff regression. This must be a dummy variable, i.e., only have 0, 1, or missing as values.
{p_end}

{pstd}{bf:{ul:Statistics options:}}
{p_end}

{pstd}{bf:{ul:covar}iates}({it:varlist}) lists the variables that should be included as covariates (independent variables not reported in the table) in the two first difference regressions and the second difference regression. Unless the option {bf:nonotes} is used a list of covariate variables is included below the table.
{p_end}

{pstd}{bf:{ul:vce}}({it:vce_types}) sets the type of variance estimator to be used in all regressions for this command. See {bf:vce_types} ({inp:help vce_types}) for more details. The only vce types allowed in this command are robust, cluster clustervar, or bootstrap. Option robust only applied to first and second difference estimators, not to baseline means. 
{p_end}

{pstd}{bf:{ul:star}levels}({it:numlist}) sets the significance levels used for significance stars. Exactly three values must be listed if this option is used, all three values must be in descending order, and must be between 0 and 1. The default values are .1, .05, and .01. The levels specified in this option are ignored if {bf:stardrop} is used.
{p_end}

{pstd}{bf:stardrop} suppresses all significance stars in all tables and removes the note on significance levels from the table note.
{p_end}

{pstd}{bf:{ul:err}ortype}({it:string}) sets the type of error to display. Allowed values for this option are {bf:se} for standard errors, {bf:sd} for standard deviation, and {bf:errhide} for not displaying any errors in the table. The default is to display standard errors.
{p_end}

{dlgtab:Output options:}

{pstd}{bf:{ul:rowl}abtype}({it:string}) indicates what to use as row titles. The allowed values are {bf:varname} using the variable name as row titles, {bf:varlab} using the variable labels as row titles (varname will still be used if the variable does not have a variable label). The default is to use the variable name.
{p_end}

{pstd}{bf:rowlabtext}({it:label_string}) manually specifies the row titles using label strings. A label string is a list of variable names followed by the row title for that variable separated by {c 34}@@{c 34}. For example {it:varA Row title variable A @@ varB Row title variable B}, where {it:varA} and {it:varB} are outcome variables used in this command. For variables not listed in {bf:rowlabtext()} row titles will be determined by the input value or default value in {bf:rowlabtype()}.
{p_end}

{pstd}{bf:nonotes} disables that the command automatically generates and displays a note below the table describing the output in the table. The note includes a description on how the number of calculations are calculated, the significance levels used for stars and which covariates were used if any were used.
{p_end}

{pstd}{bf:{ul:addn}otes}({it:string}) is used to manually add a note to be displayed below the regression result table. This note is put before the automatically generated note, unless option {bf:nonotes} is specified, in which case only the manually added note is displayed.
{p_end}

{pstd}{bf:onerow} indicates that the number of observations should be displayed on one row at the last row of the table instead of on each row. This requires that the number of observations are the same across all rows for each column.
{p_end}

{pstd}{bf:format}({it:%fmt}) sets the number formatting/rounding rule for all calculated statistics in the table, that is, all numbers in the table apart from the number of observations. Only valid Stata number formats (see {inp:help format}) are allowed. The default is {it:%9.2f}. 
{p_end}

{pstd}{bf:replace} if an option is used that outputs a file and a file with that name already exists at that location, then Stata will throw an error unless this option is used. If this option is used then Stata overwrites the file on disk with the new output. This option has no effect if no option with file path is used.
{p_end}

{dlgtab:LaTeX options:}

{pstd}{bf:{ul:savet}ex}({it:filepath}) saves the table in TeX format to the location of the file path.
{p_end}

{pstd}{bf:{ul:texdoc}ument} creates a stand-alone TeX document that can be readily compiled, without the need to import it to a different file. As default, {bf:savetex()} creates a fragmented TeX file consisting only of a tabular environment.
{p_end}

{pstd}{bf:{ul:texc}aption}({it:string}) writes table{c 39}s caption in TeX file. Can only be used with option texdocument.
{p_end}

{pstd}{bf:{ul:texl}abel}({it:string}) specifies table{c 39}s label, used for meta-reference across TeX file. Can only be used with option texdocument.
{p_end}

{pstd}{bf:{ul:texn}otewidth}({it:numlist}) manually adjusts the width of the note to fit the size of the table. The note width is a multiple of text width. If not specified, default is one, which makes the table width equal to text width.
{p_end}

{pstd}{bf:texvspace}({it:string}) sets the size of the line space between two variable rows. {it:string} must consist of a numeric value and one of the following units: {c 34}cm{c 34}, {c 34}mm{c 34}, {c 34}pt{c 34}, {c 34}in{c 34}, {c 34}ex{c 34} or {c 34}em{c 34}. Note that the resulting line space displayed will be equal to the specified value minus the height of one line of text. Default is {c 34}3ex{c 34}. For more information on units, check {browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":LaTeX lengths manual}.
{p_end}

{pstd}{bf:nonumbers} omits column numbers from table header in LaTeX output. Default is to display column numbers.
{p_end}

{title:Examples}

{pstd}All the examples below can be run on Stata{c 39}s built-in census data set, by first running this code:
{p_end}

{pstd}* Open the built-in data set  
{p_end}

{input}{space 8}sysuse census
{text}
{pstd}* Calculate rates from absolute numbers  
{p_end}

{input}{space 8}replace death = 100 * death / pop
{space 8}replace marriage = 100 * marriage / pop  
{space 8}replace divorce = 100 * divorce / pop
{text}
{pstd}* Randomly assign time and treatment dummies
{p_end}

{input}{space 8}gen t = (runiform()<.5)
{space 8}gen treatment = (runiform()<.5)
{text}
{dlgtab:Example 1.}

{input}{space 8}ieddtab death marriage divorce , t(time) treatment(treatment)
{text}
{pstd}This is the most basic way to run this command with three variables. This will output a table with the baseline means for treatment = 0 and treatment = 1, the first difference regression coefficient for treatment = 0 and treatment = 1 as well as the 2nd difference regression coefficient for treatment = 0 and treatment = 1.
{p_end}

{dlgtab:Example 2.}

{input}{space 8}ieddtab death marriage divorce , t(time) treatment(treatment) rowlabtext("death Death Rate @@ divorce Divorce Rate") rowlabtype("varlab")
{text}
{pstd}The table generated by example 2 will have the same statistics as in example 1 but the row title for the variables death and divorce are entered manually and the row title for marriage will be its variable label instead of its variable name.
{p_end}

{dlgtab:Example 3.}

{input}{space 8}ieddtab death marriage divorce , t(time) treatment(treatment) rowlabtype("varlab") savetex("DID table.tex") replace
{text}
{pstd}The table will be saved in the current directory under the name {c 34}DID table.tex{c 34}. It will have the same statistics as in examples 1 and 2, and the row titles will be its variable labels.
{p_end}

{title:Acknowledgements}

{pstd}This command was initially suggested by Esteban J. Quinones, University of Wisconsin-Madison.
{p_end}

{pstd}We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetical order):
{p_end}

{pstd}Benjamin Daniels
{p_end}

{pstd}Jonas Guthoff
{p_end}

{pstd}Nausheen Khan
{p_end}

{pstd}Varnitha Kurli
{p_end}

{pstd}Saori Iwamoto
{p_end}

{pstd}Meyhar Mohammed
{p_end}

{pstd}Michael Orevba
{p_end}

{pstd}Matteo Ruzzante
{p_end}

{pstd}Sakina Shibuya
{p_end}

{pstd}Leonardo Viotti
{p_end}

{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions, and requests for clarifications writing {c 34}ietoolkit ieddtab{c 34} in the subject line to:  
dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {bf:ietoolkit}.
{p_end}

{title:Author}

{pstd}All commands in ietoolkit are developed by DIME Analytics at DECIE, The World Bank{c 39}s unit for Development Impact Evaluations.
{p_end}

{pstd}Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group
{p_end}
