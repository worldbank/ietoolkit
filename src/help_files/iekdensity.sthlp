{smcl}
{* 04 Apr 2023}{...}
{hline}
help for {hi:iekdensity}
{hline}

{title:Title}

{phang2}{cmd:iekdensity} {hline 2} This command plots univariate kernel density estimates by treatment assignment.

{* {phang2}For a more descriptive discussion on the intended usage and work flow of this command please see the {browse "https://dimewiki.worldbank.org/wiki/Iekdensity":DIME Wiki}.}

{title:Syntax}

	{phang2} {cmd:iekdensity} {it:yvar} [{help if}] [{help in}] [{help weight}],
		{opt by(treatmentvar)}
			{break}[
			{opt stat(string)}
			{opt statstyle(string)}
			{opt effect}
			{cmdab:control(}{it:{help numlist:numlist}}{cmd:)}
			{cmdab:effectformat(}{it:{help format:%fmt}}{cmd:)}
			{opt abs:orb(varname)}
			{opt reg:ressionoptions(string)}
			{opt kdensity:options(string)}
			{opt color(string)}
			{it:{help twoway_options}}
		]

	{pmore}Where {it:yvar} is a numeric continuous outcome variable, whose distribution is to be plotted by treatment assignment.{p_end}


{marker opts}{...}
{synoptset 24}{...}
{synopthdr:options}
{synoptline}

{pstd}{it:Required options:}{p_end}
	{synopt :{opt by(treatmentvar)}}Treatment (dummy or factor) variable.{p_end}

{pstd}{it:Content options:}{p_end}
	{synopt :{opt stat(string)}}Add vertical lines for each treatment group with statistic specified.{p_end}
	{synopt :{opt statstyle(string)}}Specify graphic style of statistic lines.{p_end}
	{synopt :{opt effect}}Add note with treatment effect, containing point estimate, standard error, and p-value.{p_end}
	{synopt :{cmdab:control(}{it:{help numlist:numlist}}{cmd:)}}Specify value of variable for control group.{p_end}
	{synopt :{cmdab:effectformat(}{it:{help format:%fmt}}{cmd:)}}Specify format of point estimate and standard error of the treatment effect.{p_end}

{pstd}{it:Estimation options:}{p_end}
	{synopt :{opt abs:orb(varname)}}Specify fixed effects variable, if any.{p_end}
	{synopt :{opt reg:ressionoptions(string)}}Specify regression options.{p_end}
	{synopt :{opt kdensity:options(string)}}Specify kernel estimation options.{p_end}

{pstd}{it:Graphic options:}{p_end}
	{synopt :{opt color(string)}}Specify colors for each group.{p_end}
	{synopt :{help twoway_options}}Specify graph options.{p_end}

{synoptline}

{marker desc}
{title:Description}

	{pstd}{cmd:iekdensity} is a command that allows to easily plot the distribution of a variable by treatment group.
	It also allows to include additional information, such as descriptive statistics and treatment effect(s).{p_end}

{marker optslong}
{title:Options}

	{pstd}{it:{ul:{hi:Required options:}}}{p_end}
		{phang}{opt by(treatmentvar)} indicates which variable should be used to idenfity the treatment assignment. This can be a dummy variable (0/1) or a factor variable, when there are multiple treatments.{p_end}

	{pstd}{it:{ul:{hi:Content options:}}}{p_end}
		{phang}{opt stat(string)} specifies a descriptive statitistic to be plotted over the kernel density graph. In particular, vertical lines for each treatment group are added. Accepted statistics are: {it:mean}, {it:p1}, {it:p5}, {it:p10}, {it:p25}, {it:p50}, {it:p75}, {it:p90}, {it:p95}, {it:p99}, {it:min} and {it:max}.{p_end}

		{phang}{opt statstyle(string)} specifies the graphic style to be used for the statistic lines. Namely, you will be able to use {cmdab:lpattern(}{help linepatternstyle}{cmdab:)} and {cmdab:lwidth(}{help linewidthstyle}{cmdab:)} options. Colors are instead controlled by option {opt color(string)}.{p_end}

		{phang}{opt effect} adds a note with treatment effect, containing point estimate, standard error, and p-value, to the graph.{p_end}

		{phang}{cmdab:control(}{it:{help numlist:numlist}}{cmd:)} indicates which value the variable {opt by(treatmentvar)} takes for the control group. This is usually equal to 0 when the treatment is binary, but may vary when dealing with multiple treatment arms.{p_end}

		{phang}{cmdab:effectformat(}{it:{help format:%fmt}}{cmd:)} specify the format in which treatment effect point estimate and standard error should be displayed in the graph note.{p_end}

	{pstd}{it:{ul:{hi:Estimation options:}}}{p_end}

		{phang}{opt abs:orb(varname)} indicates the fixed effects variable (for example, the experimental strata when the treatment was stratified) to be included in the estimation. This variable must be numerical.{p_end}

		{phang}{opt reg:ressionoptions(string)} indicates other options to be employed for the treatment effect estimations, for example suppress constant term ({opt nocons:tant}) or clustered standard errors ({opt cl:uster(varname)}). All options accepted by {help regress} (or {help areg} when option {opt absorb()} is specified) are accepted.{p_end}

		{phang}{opt kdensity:options(string)} specifies kernel estimation options, such as kernel function and half-width of kernel. The default kernel function is {opt kernel(epanechnikov)}. Many options accepted by {help kdensity} are allowed (namely, {cmdab:kernel(}{help kdensity##kernel:kernel}{cmdab:)}, {opt bwidth(#)}, {opt n(#)}, and all the {help cline_options} for univariate kernel density estimation.{p_end}

	{pstd}{it:{ul:{hi:Graphic options:}}}{p_end}

		{phang}{opt color(string)} indicates the colors to be used for each treatment arm. The colors should come in the order of the values in {opt by(treatmentvar)}. For instance, if the treatment is binary, you can set the line colors by typing {opt color(color1 color2)}. See {help colorstyle}. {p_end}

		{phang}{it:{help twoway_options}} indicates other options to be applied to the graph, such as additional text and lines, changes axes, titles, and legend, etc.{p_end}

{marker optslong}
{title:Examples}

	{pstd}All the examples below can be run on the Stata's built in automobile data set, by first running this code:{p_end}

	{pstd}* Open the built in data set{p_end}
	{pstd}{inp:sysuse auto}{p_end}

	{pstd}* Randomly assign time and treatment dummies{p_end}
	{pstd}{inp:gen treatment = (runiform() < .5)}{p_end}

	{pstd} {hi:Example 1.}

	{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)}

	{pstd} This is the most basic way to run this command. This will output a graph with the distributions of of the variable of interests ({it:price} in this case) by treatment assignment.

	{pstd} {hi:Example 2.}

	{pstd} {inp:iekdensity} {it:auto} , {inp:by((}{it:treatment}{inp:)} {inp:stat(}{it:p50}{inp:)}

	{pstd} This is an easy way to add descriptive information to the graph. This will output the same graph as above with the addition of two vertical lines for the medians of the control and treatment groups.

		{pstd} {hi:Example 2.1}

		{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:stat(}{it:p50}{inp:)} {inp:statstyle(}lpattern(dash) lwithd(2){inp:)}

		{pstd} This changes the style of the median vertical lines.

		{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:stat(}{it:p50}{inp:)} {inp:statstyle(}lpattern(dash) lwithd(2){inp:)}

		{pstd} {hi:Example 2.2}

		{pstd} This sets the colors of the control and treatment lines to different shades of blue.

		{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:stat(}{it:p50}{inp:)} {inp:statstyle(}lpattern(dash) lwithd(2){inp:)} {inp:color(}eltblue edkblue{inp:)}

		{pstd} {hi:Example 2.3}

		{pstd} This changes some of the graphical options.

		{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:stat(}{it:p50}{inp:)} {inp:statstyle(}lpattern(dash) lwithd(2){inp:)} {inp:title(}auto distribution{inp:)} {inp:subtitle(}By Treatment Assignment{inp:)} {inp:ylab(}, angle(horizontal){inp:)} {inp:graphregion(}color(white){inp:)} {inp:plotregion(}color(white){inp:)}

	{pstd} {hi:Example 3.}

	{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:stat(}{it:p50}{inp:)} {inp:effect}

	{pstd} This adds a note to the graph, displaying the treatment effect in terms of point estimate, standard error and statistical significance.

		{pstd} {hi:Example 3.1}

		{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:stat(}{it:p50}{inp:)} {inp:effect} {inp:effectformat(}%9.0fc{inp:)}

		{pstd} This changes the format of the treatment effect in the note. The point estimate and the standard error now do not include any decimal points.


	{pstd} {hi:Example 4.1}

	{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:effect} {inp:absorb(}{it:foreign}{inp:)}

	{pstd} The treatment effect is now derived from a regression controlling for the variable {it:foreign} fixed effects.

	{pstd} {hi:Example 4.2}

	{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:effect} {inp:absorb(}{it:foreign}{inp:)} {inp:regressionoptions(}{it:cluster(foreign)}{inp:)}

	{pstd} The treatment effect is now derived from a regression controlling for the variable {it:foreign} fixed effects and clustering standard errors at {it:foreign} level.

	{pstd} {hi:Example 5}

	{pstd} {inp:iekdensity} {it:auto} , {inp:by(}{it:treatment}{inp:)} {inp:kdensityoptions(}epan2 bwidth(5){inp:)}

	{pstd} The kernel density is estimated through the alternative Epanechnikov kernel function and half-width of the kernel is specified to be equal to 5.

{title:Acknowledgements}

	{phang}We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetic order):{p_end}
	{pmore}Luiza Andrade{break}

{title:Authors}

	{phang}All commands in ietoolkit are developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.{p_end}

	{phang}Main author: Matteo Ruzzante, DIME, The World Bank Group.{p_end}

	{phang}Please send bug-reports, suggestions and requests for clarifications
			 writing "ietoolkit iekdensity" in the subject line to:{break}
			 dimeanalytics@worldbank.org{p_end}

	{phang}You can also see the code, make comments to the code, see the version
			 history of the code, and submit additions or edits to the code through
			 the GitHub repository of ietoolkit:{break}
	{browse "https://github.com/worldbank/ietoolkit"}{p_end}
