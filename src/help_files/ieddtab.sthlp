{smcl}
{* 01 Feb 2024}{...}
{hline}
help for {hi:ieddtab}
{hline}

{title:Title}

{phang2}{cmdab:ieddtab} {hline 2} This command runs a Diff-in-Diff regression and displays the baseline values, the two 1st differences and the 2nd difference.

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/ieddtab":DIME Wiki}.

{title:Syntax}

{phang2} {cmdab:ieddtab} {it:varlist} [{help if}] [{help in}] [{help weight}],
	{cmdab:t:ime(}{it:varname}{cmd:)} {cmdab:treat:ment(}{it:varname}{cmd:)}
		{break}[
		{cmdab:covar:iates(}{it:varlist}{cmd:)} {cmdab:starl:evels(}{it:numlist}{cmd:)}
		{cmdab:stardrop}
		{cmdab:err:ortype(}{it:string}{cmd:)} {cmdab:rowl:abtype(}{it:string}{cmd:)}
		{cmdab:rowlabtext(}{it:label_string}{cmd:)} {cmdab:format(}{it:{help format:%fmt}}{cmd:)}
		{cmdab:replace} {cmdab:savet:ex(}{it:filepath}{cmd:)} {cmdab:onerow} {cmdab:nonumbers}
		{cmdab:nonotes} {cmdab:addn:otes(}{it:string}{cmd:)}  {cmdab:texdoc:ument}
		{cmdab:texc:aption(}{it:string}{cmd:)} {cmdab:texl:abel(}{it:string}{cmd:)}
		{cmdab:texn:otewidth(}{it:numlist}{cmd:)} {cmdab:texvspace(}{it:string}{cmd:)}
	]

{pmore}Where {it:varlist} is a list of numeric continuous outcome variables (also called dependent variables or left hand side variables) to be used in the difference-in-difference regression(s) this command runs and presents the results from.{p_end}

{marker opts}{...}
{synoptset 24}{...}
{synopthdr:options}
{synoptline}
{pstd}{it:Required options:}{p_end}
{synopt :{cmdab:t:ime(}{it:varname}{cmd:)}}Time dummy to use in diff-in-diff regression{p_end}
{synopt :{cmdab:treat:ment(}{it:varname}{cmd:)}}Treatment dummy to use in diff-in-diff regression{p_end}

{pstd}{it:Statistics options:}{p_end}
{synopt :{cmdab:covar:iates(}{it:varlist}{cmd:)}}Covariates to use in diff-in-diff regression{p_end}
{synopt :{cmdab:vce:(}{it:{help vce_option:vce_types}}{cmd:)}}Options for variance estimation. {hi:Robust}, {hi:cluster} {it:clustervar} or {hi:bootstrap}{p_end}
{synopt :{cmdab:starl:evels(}{it:numlist}{cmd:)}}Significance levels used for significance stars, default values are .1, .05 and .01{p_end}
{synopt :{cmdab:stardrop}}Suppresses all significance stars in all tables.{p_end}
{synopt :{cmdab:err:ortype(}{it:string}{cmd:)}}Type of errors to display, default is standard errors.{p_end}

{pstd}{it:Output options:}{p_end}
{synopt :{cmdab:rowl:abtype(}{it:string}{cmd:)}}Indicate what to use as row titles, default is variable name.{p_end}
{synopt :{cmdab:rowlabtext(}{it:label_string}{cmd:)}}Manually enter the row titles using label strings (see below).{p_end}
{synopt :{cmdab:nonote}}Disable that the automatically generated note is displayed below the table.{p_end}
{synopt :{cmdab:addn:otes(}{it:string}{cmd:)}}Manually add a note to be displayed below the regression result table.{p_end}
{synopt :{cmdab:onerow}}Display the number of observations on one row at the last row of the table.{p_end}
{synopt :{cmdab:format(}{it:{help format:%fmt}}{cmd:)}}Set the rounding format of the calculated statistics in the table.{p_end}
{synopt :{cmdab:replace}}Replace the file on disk if it already exist. Has no effect if no option with file path is used.{p_end}

{pstd}{it:LaTeX options:}{p_end}
{synopt :{cmdab:savet:ex(}{it:filepath}{cmd:)}}Generate a LaTeX table of the result and save to the location of the file path.{p_end}
{synopt :{cmdab:texdoc:ument}}Creates a stand-alone TeX document.{p_end}
{synopt :{cmdab:texc:aption(}{it:string}{cmd:)}}Specify table's caption on TeX file.{p_end}
{synopt :{cmdab:texl:abel(}{it:string}{cmd:)}}Specify table's label, used for meta-reference across TeX file.{p_end}
{synopt :{cmdab:texn:otewidth(}{it:numlist}{cmd:)}}Manually enter the width of the note on the TeX file.{p_end}
{synopt :{cmd:texvspace(}{it:string}{cmd:)}}Manually set size of the line space between two rows on TeX output.{p_end}
{synopt :{cmdab:nonumbers}}Omit column numbers from table header in LaTeX output.{p_end}
{synoptline}

{marker desc}
{title:Description}

{pstd}{cmdab:ieddtab} is a command that makes it easy to run and display results of differences-in-differences (diff-in-diff) regressions. The table that presents the results from the diff-in-diff regression also presents the mean when the variable in {inp:time()} is 0 (i.e. baseline) for the two groups defined by the variable {inp:treatment()} is 0 and 1 (i.e. control and treatment), and the table also presents the coefficient of the first difference regression in control and treatment.{p_end}

{pstd}The sample for each row in the table is defined by the sample included in the second difference regression shown below, where {it:outcome_var} is a variable the varlist (one per row) for {inp:ieddtab}, {inp:`interaction'} is the interaction of the dummy listed in {inp:time()} and the dummy listed in {inp:treatment()}, and where {inp:`covariates'} is the list of covariates included in {inp:covariates()} if any. This means that any observation that has any missing value in either of the two dummies or in any of the covariates will be omitted from all statistics presented in the table. The coefficient presented in the table for the diff-in-diff regression is the interaction of the time and treatment variable.{p_end}

{pstd}{inp:tempvar} {it:interaction}{p_end}
{pstd}{inp:generate `interaction' = `time' * `treatment'}{p_end}
{pstd}{inp:regress} {it:outcome_var} {inp:`time' `treatment' `interaction' `covariates'}{p_end}

{pstd}The baseline means are then calculated using the following code where the first line is control and the second line is treatment, and the variable {inp:regsample} is dummy indicating if the observation was included in the second difference regression.{p_end}

{pstd}{inp:mean} {it:outcome_var} {inp:if `treatment' == 0 & `time' == 0 & regsample == 1}{p_end}
{pstd}{inp:mean} {it:outcome_var} {inp:if `treatment' == 1 & `time' == 0 & regsample == 1}{p_end}

{pstd}The first difference coefficients are then calculated using the following code where the first line is control and the second line is treatment. The coefficient displayed in the table is the coefficient of the variable `time' which is the variable listed in {inp:t()}.{p_end}

{pstd}{inp:regress} {it:outcome_var} {inp: `time' `covariates' if `treatment' == 0 & regsample == 1}{p_end}
{pstd}{inp:regress} {it:outcome_var} {inp: `time' `covariates' if `treatment' == 1 & regsample == 1}{p_end}


{marker optslong}
{title:Options}

{pstd}{it:{ul:{hi:Required options:}}}{p_end}
{phang}{cmdab:t(}{it:varname}{cmd:)} indicates which variable should be used as the time dummy to use in diff-in-diff regression. This must be a dummy variable, i.e. only have 0, 1 or missing as values, where 0 is baseline and 1 is follow-up.{p_end}

{phang}{cmdab:treatment(}{it:varname}{cmd:)} indicates which variable should be used as the treatment dummy to use in diff-in-diff regression. This must be a dummy variable, i.e. only have 0, 1 or missing as values.{p_end}

{pstd}{it:{ul:{hi:Statistics options:}}}{p_end}
{phang}{cmdab:covar:iates(}{it:varlist}{cmd:)} lists the variables that should be included as covariates (independent variables not reported in the table) in the two first difference regressions and the second diffrence regression. Unless the option {cmdab:nonotes} is used a list of covariate variables is included below the table.{p_end}

{phang}{cmdab:vce:(}{it:{help vce_option:vce_types}{cmd:)}} sets the type of variance estimator to be used in all regressions for this
command. See {help vce_option:vce_types} for more details. The only vce types allowed in this command are {hi:robust}, {hi:cluster} {it:clustervar} or {hi:bootstrap}.
Option {hi:robust} only applied to first and second difference estimators, not to baseline means.{p_end}


{phang}{cmdab:starl:evels(}{it:numlist}{cmd:)} sets the significance levels used for significance stars. Exactly three values must be listed if this option is used, all three values must be descending order, and must be between 0 and 1. The default values are .1, .05 and .01. The levels specified in this option is ignored if {cmdab:stardrop} is used.{p_end}

{phang}{cmdab:stardrop}} suppresses all significance stars in all tables and remove the note on significance levels from the table note.{p_end}

{phang}{cmdab:err:ortype(}{it:string}{cmd:)} sets the type of error to display. Allowed values for this iption is {inp:se} for standard errors, {inp:sd} for standard deviation and {inp:errhide} for not displaying any errors in the table. The default is to display standard errors.{p_end}

{pstd}{it:{ul:{hi:Output options:}}}{p_end}
{phang}{cmdab:rowl:abtype(}{it:string}{cmd:)} indicates what to use as row titles. The allowed values are {inp:varname} using the variable name as row titles, {inp:varlab} using the variable labels as row titles (varname will still be used if the variable does not have a variable label). The default is to use the variable name.{p_end}

{phang}{cmdab:rowlabtext(}{it:label_string}{cmd:)} manually specifies the row titles using label strings. A label string is a list of variable names followed by the row title for that variable separated by "@@". For example {it:varA Row title variable A @@ varB Row title variable B}, where {it:varA} and {it:varB} are outcome variables used in this command. For variable not listed in {cmdab:rowlabtext()} row titles will be determined by the input value or default value in {cmdab:rowl:abtype()}.{p_end}

{phang}{cmdab:nonotes} disable that the command automatically generates and displays a note below the table describing the output in the table. The note includes description on how number of calculations are calculated, the significance levels used for stars and which covariates were uses if any were used.{p_end}

{phang}{cmdab:addn:otes(}{it:string}{cmd:)} is used to manually add a note to be displayed below the regression result table. This note is put before the automatically generated note, unless option {cmdab:nonotes} is specified, in which case only the manually added note is displayed.{p_end}

{phang}{cmdab:onerow} indicates that the number of observations should be displayed on one row at the last row of the table instead on each row. This requires that the number of observations are the same across all rows for each column.{p_end}

{phang}{cmdab:format(}{it:{help format:%fmt}}{cmd:)} sets the number formatting/rounding rule for all calculated statistics in the table, that is all numbers in the table apart from the number of observations. Only valid {help format:Stata number formats} are allowed. The default is {it:%9.2f}.{p_end}

{phang}{cmdab:replace} if an option is used that output a file and a file with that name already exists at that location, then Stata will throw an error unless this option is used. If this option is used then Stata overwrites the file on disk with the new output. This option has no effect if no option with file path is used.{p_end}

{pstd}{it:{ul:{hi:LaTeX options:}}}{p_end}
{phang}{cmdab:savet:ex(}{it:filepath}{cmd:)} saves the table in TeX format to the location of the file path.{p_end}

{phang}{cmdab:texdoc:ument} creates a stand-alone TeX document that can be readily compiled, without the need to import it to a different file.
 As default, {cmd:savetex()} creates a fragmented TeX file consisting only of a tabular environment.

{phang}{cmdab:texc:aption(}{it:string}{cmd:)} writes table's caption in TeX file. Can only be used with option texdocument. {p_end}

{phang}{cmdab:texl:abel(}{it:string}{cmd:)} specifies table's label, used for meta-reference across TeX file. Can only be used with option texdocument.{p_end}

{phang}{cmdab:texn:otewidth(}{it:numlist}{cmd:)} manually adjusts the width of the note to fit the size of the table.
The note width is a multiple of text width. If not specified, default is one, which makes the table width equal to text width.{p_end}

{phang}{cmd:texvspace(}{it:string}{cmd:)} sets the size of the line space between two variable rows. {it:string} must consist of a numeric value
and one of the following units: "cm", "mm", "pt", "in", "ex" or "em". Note that the resulting line space displayed will be equal to the
specified value minus the height of one line of text. Default is "3ex". For more information on units,
{browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX lengths manual}. {p_end}

{phang}{cmdab:nonumbers} ommits column numbers from table header in LaTeX output. Default is to display column numbers.{p_end}

{marker optslong}
{title:Examples}

{pstd}All the examples below can be run on the Stata's built in census data set, by first running this code:{p_end}

{pstd}*Open the built in data set{p_end}
{pstd}{inp:sysuse census}{p_end}

{pstd}*Calculate rates from absolute numbers{p_end}
{pstd}{inp:replace death = 100 * death / pop}{p_end}
{pstd}{inp:replace marriage = 100 * marriage / pop}{p_end}
{pstd}{inp:replace divorce = 100 * divorce / pop}{p_end}

{pstd}*Randomly assign time and treatment dummies{p_end}
{pstd}{inp:gen t	= (runiform()<.5)}{p_end}
{pstd}{inp:gen treatment = (runiform()<.5)}{p_end}


{pstd} {hi:Example 1.}

{pstd} {inp:ieddtab} {it:death marriage divorce} , {inp:t(}{it:time}{inp:)} {inp:treatment(}{it:treatment}{inp:)}

{pstd}This is the most basic way to run this command with three variables. This will output a table with the baseline means for treatment = 0 and treatment = 1, the first difference regression coefficient for treatment = 0 and treatment = 1 as well as the 2nd difference regression coefficient for treatment = 0 and treatment = 1.

{pstd} {hi:Example 2.}

{pstd} {inp:ieddtab} {it:death marriage divorce} ,  {inp:t(}{it:time}{inp:)} {inp:treatment(}{it:treatment}{inp:)}  {inp:rowlabtext(}{it:"death Death Rate @@ divorce Divorce Rate"}{inp:)} {inp:rowlabtype(}{it:"varlab"}{inp:)}

{pstd}The table generated by example 2 will have the same statistics as in example 1 but the row title for the variables death and divorce are entered manually and the row title for marriage will be its variable label instead of its variable name.

{pstd} {hi:Example 3.}

{pstd} {inp:ieddtab} {it:death marriage divorce} ,  {inp:t(}{it:time}{inp:)} {inp:treatment(}{it:treatment}{inp:)}  {inp:rowlabtype(}{it:"varlab"}{inp:)} {inp:savetex(}{it:"DID table.tex"}{inp:)} {inp:replace}

{pstd}The table will be saved in the current directory under the name "DID table.tex". It will will have the same statistics as in examples 1 and 2, and the row titles will be its variable labels.

{title:Acknowledgements}

{phang}This command was initally suggested by Esteban J. Quinones, University of Wisconsin-Madison{p_end}

{phang}We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Benjamin Daniels{break}Jonas Guthoff{break}Nausheen Khan{break}Varnitha Kurli{break}Saori Iwamoto{break}Meyhar Mohammed{break}Michael Orevba{break}Matteo Ruzzante{break}Sakina Shibuya{break}Leonardo Viotti{break}

{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.{p_end}

{phang}Main author: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group{p_end}

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit ieddtab" in the subject line to:{break}
		 dimeanalytics@worldbank.org{p_end}

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the GitHub repository of ietoolkit:{break}
{browse "https://github.com/worldbank/ietoolkit"}{p_end}
