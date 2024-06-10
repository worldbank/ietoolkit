{smcl}
{* *! version 0.0 20240404}{...}
{hline}
{pstd}help file for {hi:iekdensity}{p_end}
{hline}

{title:Title}

{phang}{bf:iekdensity} - This command plots univariate kernel density estimates by treatment assignment.
{p_end}

{title:Syntax}

{phang}{bf:iekdensity} {it:yvar} [if] [in] [weight] , {bf:by}({it:treatmentvar})
  [ {bf:stat}({it:string}) {bf:statstyle}({it:string}) {bf:effect} {bf:control}({it:numlist}) {bf:effectformat}({it:%fmt}) {bf:{ul:abs}orb}({it:varname}) {bf:{ul:reg}ressionoptions}({it:string}) {bf:{ul:kdensity}options}({it:string}) {bf:color}({it:string})
            {it:twoway_options} ]
{p_end}

{phang}Where {it:yvar} is a numeric continuous outcome variable, whose distribution is to be plotted by treatment assignment.
{p_end}

{synoptset 16}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:by}({it:treatmentvar})}Treatment (dummy or factor) variable.{p_end}
{synoptline}

{dlgtab:Content options:}

{synoptset 18}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:stat}({it:string})}Add vertical lines for each treatment group with statistic specified.{p_end}
{synopt: {bf:statstyle}({it:string})}Specify graphic style of statistic lines.{p_end}
{synopt: {bf:effect}}Add note with treatment effect, containing point estimate, standard error, and p-value.{p_end}
{synopt: {bf:control}({it:numlist})}Specify value of variable for control group.{p_end}
{synopt: {bf:effectformat}({it:%fmt})}Specify format of point estimate and standard error of the treatment effect.{p_end}
{synoptline}

{dlgtab:Estimation options:}
{synoptset 25}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:abs}orb}({it:varname})}Specify fixed effects variable, if any.{p_end}
{synopt: {bf:{ul:reg}ressionoptions}({it:string})}Specify regression options.{p_end}
{synopt: {bf:{ul:kdensity}options}({it:string})}Specify kernel estimation options.{p_end}
{synoptline}

{dlgtab:Graphic options:}
{synoptset 14}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:color}({it:string})}Specify colors for each group.{p_end}
{synopt: {it:twoway_options}}Specify graph options.{p_end}
{synoptline}

{title:Description}

{pstd}{bf:iekdensity} is a command that allows to easily plot the distribution of a variable by treatment group.  It also allows to include additional information, such as descriptive statistics and treatment effect(s).
{p_end}

{title:Options}

{dlgtab:Required options:}

{pstd}{bf:by}(treatmentvar) indicates which variable should be used to idenfity the treatment assignment. This can be a dummy variable (0/1) or a factor variable, when there are multiple treatments.
{p_end}

{dlgtab:Content options}

{pstd}{bf:stat}({it:string}) specifies a descriptive statitistic to be plotted over the kernel density graph. In particular, vertical lines for each treatment group are added. Accepted statistics are: {it:mean, p1, p5, p50, p75, p90, p95, p99, min} and {it:max}.
{p_end}

{pstd}{bf:statstyle}({it:string}) specifies the graphic style to be used for the statistic lines. Namely, you will be able to use {bf:lpattern}(linepatternstyle) and {bf:lwidth}(linewidthstyle) opt ad controlled by option {bf:color}({it:string}).
{p_end}

{pstd}{bf:effect} adds a note with treatment effect, containing point estimate, standard error, and p-value, to the graph.
{p_end}

{pstd}{bf:control}({it:numlist}) indicates which value the variable {bf:by}({it:treatmentvar}) takes for the control group. This is usually equal to 0 when the treatment is binary, but may vary when dealing wi arms.
{p_end}

{pstd}{bf:effectformat}({it:%fmt}) specify the format in which treatment effect point estimate and standard error should be displayed in the graph note.
{p_end}

{dlgtab:Estimation options:}

{pstd}{bf:{ul:abs}orb}({it:varname}) indicates the fixed effects variable (for example, the experimental strata when the treatment was stratified) to be included in the estimation. This variable must be numerical.
{p_end}

{pstd}{bf:{ul:reg}ressionoptions}({it:string}) indicates other options to be employed for the treatment effect estimations, for example suppress constant term ({bf:{ul:nocons}tant}) or clustered standard errors ({bf:{ul:cl}uster}({it:varname})). Al regress (or areg when option {bf:absorb()} is specified) are accepted.
{p_end}

{pstd}{bf:{ul:kdensity}options}({it:string}) specifies kernel estimation options, such as kernel function and half-width of kernel. The default kernel function is {bf:kernel}({it:epanechnikov}). Many options accepted by kdensity are : {bf:kernel}({it:kernel}), {bf:bwidth}({it:#}), {bf:n}({it:#}), and all the {it:cline_options} (see {inp:help cline_options}) for univariate kernel density estimation. 
{p_end}

{dlgtab:Graphic options:}

{pstd}{bf:color}({it:string}) indicates the colors to be used for each treatment arm. The colors should come in the order of the values in {bf:by}({it:treatmentvar}). For instance, if the treatment is binary, you can set the line colors (color1 color2). See {it:colorstyle} ({inp:help colorstyle}). 
{p_end}

{pstd}{it:twoway_options} indicates other options to be applied to the graph, such as additional text and lines, changes axes, titles, and legend, etc. (See {inp:help twoway_options}) 
{p_end}

{title:Examples}
{pstd}All the examples below can be run on the Stata{c 39}s built in automobile data set, by first running this code:
{p_end}

{pstd}* Open the built in data set
{p_end}

{input}{space 8}sysuse auto
{text}
{pstd}* Randomly assign time and treatment dummies
{p_end}

{input}{space 8}gen treatment = (runiform() < .5)
{text}
{dlgtab:Example 1}

{input}{space 8}iekdensity auto , by(treatment)
{text}
{pstd}This is the most basic way to run this command. This will output a graph with the distributions of of the variable of interests (price in this case) by treatment assignment.
{p_end}

{dlgtab:Example 2}

{input}{space 8}iekdensity auto , by((treatment) stat(p50)
{text}
{pstd}This is an easy way to add descriptive information to the graph. This will output the same graph as above with the addition of two vertical lines for the medians of the control and treatment groups.
{p_end}

{dlgtab:Example 2.1}

{input}{space 8}iekdensity auto , by(treatment) stat(p50) statstyle(lpattern(dash) lwithd(2))
{text}
{pstd}This changes the style of the median vertical lines.
{p_end}

{dlgtab:Example 2.2}

{input}{space 8}iekdensity auto , by(treatment) stat(p50) statstyle(lpattern(dash) lwithd(2)) color(eltblue edkblue)
{text}
{pstd}This sets the colors of the control and treatment lines to different shades of blue.
{p_end}

{dlgtab:Example 2.3}

{input}{space 8}iekdensity auto , by(treatment) stat(p50) statstyle(lpattern(dash) lwithd(2)) title(auto distribution) subtitle(By Treatment Assignment)
{space 8}graphregion(color(white)) plotregion(color(white))
{text}
{pstd}This changes some of the graphical options.
{p_end}

{dlgtab:Example 3}

{input}{space 8}iekdensity auto , by(treatment) stat(p50) effect
{text}
{pstd}This adds a note to the graph, displaying the treatment effect in terms of point estimate, standard error and statistical significance.
{p_end}

{dlgtab:Example 3.1}

{input}{space 8}iekdensity auto , by(treatment) stat(p50) effect effectformat(%9.0fc)
{text}
{pstd}This changes the format of the treatment effect in the note. The point estimate and the standard error now do not include any decimal points.
{p_end}

{dlgtab:Example 4}

{input}{space 8}iekdensity auto , by(treatment) effect absorb(foreign)
{text}
{pstd}The treatment effect is now derived from a regression controlling for the variable {it:foreign} fixed effects.
{p_end}

{dlgtab:Example 4.1}

{input}{space 8}iekdensity auto , by(treatment) effect absorb(foreign) regressionoptions(cluster(foreign))
{text}
{pstd}The treatment effect is now derived from a regression controlling for the variable foreign fixed effects and clustering standard errors at {it:foreign} level.
{p_end}

{dlgtab:Example 5}

{input}{space 8}iekdensity auto , by(treatment) kdensityoptions(epan2 bwidth(5))
{text}
{pstd}The kernel density is estimated through the alternative Epanechnikov kernel function and half-width of the kernel is specified to be equal to 5.
{p_end}

{title:Acknowledgements}

{pstd}We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetic order):
Luiza Andrade
{p_end}

{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions and requests for clarifications writing {c 34}ietoolkit iekdensity{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version history of the code, and submit additions or edits to the code through  {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {inp:ietoolkit}. 
{p_end}

{title:Authors}

{pstd}All commands in {inp:ietoolkit} are developed by DIME Analytics at DIME, The World Bank{c 39}s department for Development Impact Evaluations. 
{p_end}

{pstd}Main author: Matteo Ruzzante, DIME, The World Bank Group.
{p_end}
