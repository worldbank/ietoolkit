{smcl}
{* *! version 0.0 20240404}{...}
{hline}
{pstd}help file for {hi:iegraph}{p_end}
{hline}

{title:Title}

{phang}{bf:iegraph} - Generates graphs based on regressions with treatment dummies common in impact evaluations.
{p_end}

{phang}For a more descriptive discussion on the intended usage and work flow of this command please see the {browse "https://dimewiki.worldbank.org/Ietoolkit":DIME Wiki}.
{p_end}

{title:Syntax}

{phang}{bf:iegraph} , {it:varlist} , [ {bf:{ul:basicti}tle}({it:string}) {bf:{ul:varl}abels} {bf:save}({it:string}) {bf:{ul:gray}scale} {bf:yzero} {bf:{ul:barl}abel} {bf:{ul:mlabc}olor}({it:colorname}) {bf:{ul:mlabp}osition}({it:clockpos}) {bf:{ul:mlabs}ize}({it:size}) {bf:barlabelformat} {bf:noconfbars} {bf:confbarsnone}({it:varlist}) {bf:confintval}({it:numlist}) {bf:norestore} {bf:{ul:baropt}ions}({it:string}) {bf:ignoredummytest} {it:twoway_scatter_options} ]
{p_end}

{synoptset 27}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:basicti}tle}({it:string})}Manually sets the title of the graph{p_end}
{synopt: {bf:{ul:varl}abels}}Uses variable labels for legends instead of variable names{p_end}
{synopt: {bf:save}({it:string})}Sets the filename and the directory to which the graph will be set/exported{p_end}
{synopt: {bf:{ul:gray}scale}}Uses grayscales for the bars instead of colors{p_end}
{synopt: {bf:yzero}}Forces y-axis on the graph to start at 0{p_end}
{synopt: {bf:{ul:barl}abel}}Adds a label on top of the bars with their respective values{p_end}
{synopt: {bf:{ul:mlabc}olor}({it:colorname})}Manually set the colors of the bars{p_end}
{synopt: {bf:{ul:mlabp}osition}({it:clockposstyle})}Set color of bar label{p_end}
{synopt: {bf:{ul:mlabs}ize}({it:size})}Set position of bar label{p_end}
{synopt: {bf:barlabelformat}}Set font size of bar label{p_end}
{synopt: {bf:noconfbars}}Customizes format of bar label. Must be used with {inp:barlabel}{p_end}
{synopt: {bf:confbarsnone}({it:varlist})}Removes the confidence interval bars from graphs for all treatments{p_end}
{synopt: {bf:confintval}({it:numlist})}Sets the confidence interval for the confidence interval bars. Default is .95{p_end}
{synopt: {bf:norestore}}Allows you to debug your two way graph settings on the data set prepared by iegraph. To be used with {inp:r(cmd)}{p_end}
{synopt: {bf:{ul:baropt}ions}({it:string})}Allows you to add formatting to the bars{p_end}
{synopt: {bf:ignoredummytest}}Ignores the tests that tests if the dummies fits one of the two models below{p_end}
{synoptline}

{phang}Any {it:twoway graph scatter} options that can be used with
regular {it:twoway graph scatter} commands can also be used.
If any of these commands conflict with any of the built in options,
then the user specified settings have precedence.
See example 2 for details.
{p_end}

{title:Description}

{pstd}{inp:iegraph} is a command creates bar graphs based on 
coefficients of treatment dummies in regression results.
This command is developed for reading stored results from
two types of common impact evaluation regression models,
but there are countless of other examples where the command also can be used.
{inp:iegraph} must be used immediately after running the regression 
or after the regression result is restored using Stata{c 39}s {it:ereturn results}.
{p_end}

{dlgtab:Model 1: OLS with Treatment Dummies}
{pstd}The most typical impact evaluation regression is to have the outcome variable
as the dependent variable and one dummy for each treatment arm
where control is the omitted category.
These regressions can also include covariates, fixed effects etc.,
but as long as the treatment status is defined by mutually exclusive dummy variables.
See especially examples 1 and 2 below.
This command works with any number of treatment arms
but works best from two arms (treatment and control)
to five treatment arms (4 different treatments and control).
More arms than that may result in a still correct but perhaps cluttered graph.
{p_end}

{dlgtab:Model 2: Difference-in-Differences}
{pstd}Another typical regression model in impact evaluations
are difference-in-difference (Diff-in-Diff)
models with two treatment arms (treatment and control) and two time periods.
If the Diff-in-Diff regression is specified as having the outcome variable
as the dependent variable and three dummy variables (time, treatment and time*treatment)
as the independent variables,
then this command will produce a nice graph.
Controls, treatment effects etc. may be added to the regression model.
See especially example 3.
{p_end}

{dlgtab:Graph Output}
{pstd}The graph generated by this command is created using the following values.
The control bar is the mean of the outcome variable for the control group.
It is not the constant from the regression as those are not identical if,
for example, fixed effects and covariates were used.
For each treatment group the bar is the sum of the value of the control bar
and the beta coefficient in the regression of the corresponding treatment dummy.
The confidence intervals are calculated from the variance in
the beta coefficients in the regression.
{p_end}

{pstd}The graph also includes the N for each treatment arm in the regression
and uses that value as labels on the x-axis.
Stars are added to this value if the corresponding
coefficient is statistically different from zero in the regression
{p_end}

{title:Options}

{pstd}{bf:{ul:basicti}tle}({it:string}) manually sets the title of the graph.
To apply formatting like title size, position, etc.,
use Stata{c 39}s built in {inp:title()} option instead. 
{p_end}

{pstd} {bf:{ul:varl}abels} sets the legends to the variable labels for the variables
 instead of the variable names.
{p_end}

{pstd} {bf:save}({it:string}) sets the legends to the variable labels
 for the variables instead of the variable names.
{p_end}

{pstd} {bf:{ul:gray}scale} uses grayscale for the bars instead of colors.
 The color of the control bar will be black and the treatment bar will
 run in equal shade differences from light grey to dark grey.
{p_end}

{pstd} {bf:yzero} manually sets the y-axis of the graph to start at zero instead of the Stata default.
 In many cases, we expect that neither
 the default settings nor this option will make the axes look perfect,
 but you may use Stata{c 39}s built in axis options
 that allow you to set the axes to perfectly fit your data.
 The command will ignore the {inp:yzero} option in cases where the graph cannot 
 be forced to zero i.e. where the values in the graph extend beyond zero,
 both positively or negatively.
 A warning will be displayed telling the user that the option has been ignored.
 Despite the warning, the graph will be produced correctly.
{p_end}

{pstd} {bf:{ul:barl}abel} adds a label on top of the bars with their respective values.
 Equivalent to specifying option {inp:blabel(bar)} in a {it:bar graph} (see {inp:help graph_bar}). 
{p_end}

{pstd} {bf:{ul:mlabc}olor}({it:colorname}) sets color of bar label.
 May only be used with the {inp:barlabel} option. 
 See {inp:help colorname} for valid values. 
{p_end}

{pstd} {bf:{ul:mlabp}osition}({it:clockpos}) sets position of bar label.
 May only be used with the {inp:barlabel} option. 
 See {inp:help clockposstyle} for valid values. 
{p_end}

{pstd} {bf:{ul:mlabs}ize}({it:size}) sets size of bar label.
 May only be used with the {inp:barlabel} option. 
 See {inp:help textsizestyle} for valid values. 
{p_end}

{pstd} {bf:barlabelformat} customizes {inp:barlabel} format. 
 May only be used with the {inp:barlabel} option. 
 Options allowed have the formats {it:%#.#f} or {it:%#.#e}.
 Default if {it:%9.1f}. See {inp:help format} for valid formats. 
{p_end}

{pstd} {bf:noconfbars} removes the confidence interval bars from graphs for all treatments.
 The default value for the confidence interval bars is 95%.
{p_end}

{pstd} {bf:confbarsnone}({it:varlist}) removes confidence interval bars
 from only the {it:varlist} listed.
 The remaining variables in the graphs which have not been specified
 in option {inp:confbarsnone} will still have the confidence interval bars. 
{p_end}

{pstd} {bf:confintval}({it:numlist}) sets the confidence interval for the confidence interval bars.
 Default is .95. Values between 0 and 1 are allowed.
{p_end}

{pstd} {bf:norestore} returns the data set that {inp:iegraph} prepares to create the graph. 
 This is helpful when de-bugging how one of Stata{c 39}s many graph options
 can be applied to an {inp:iegraph} graph. 
 This option is meant to be used in combination with
 the returned result in {inp:r(cmd)}. 
 {inp:r(cmd)} gives you the line of code {inp:iegraph} prepares to create the graph 
 and {inp:norestore} gives you access to the data that code is meant to be used on. 
 This approach will help you de-bug how to apply
 Stata{c 39}s built in graph options to an {inp:iegraph} graph. 
 Note that this option deletes any unsaved changes made to your data in memory.
{p_end}

{pstd} {bf:{ul:baropt}ions}({it:string}) allows you to add formatting options
 that are applied to each bar and not the graph itself.
 Example of such option are {it:twoway_bar} options and {it:axis_options} options.
 It is not possible to use this option to add formatting to individual bars.
 Everything added in this option is added to all bars.
 Formatting added in this option takes precedence over
 any default formatting or formatting set in any other option.
{p_end}

{pstd} {bf:ignoredummytest} ignores the tests that test if the dummies
 fits one of the two models this command is intended for.
 The two models are described in detail above.
 There might be models we have not thought of for which this command is helpful as well.
 Use this option to lift the restrictions of those two models.
 But be careful, this command has not been tested for other models than the two described.
{p_end}

{title:Stored results}

{title:Examples}

{dlgtab:Example 1}

{input}{space 8}regress outcomevar treatment_dummy
{space 8}iegraph treatment_dummy , basictitle("Treatment Effect on Outcome")
{text}
{pstd}In the example above, there are only two treatment arms (treatment and control).
{it:treatment_dummy} has a 1 for all treatment observations and a 0 for all control observations.
The graph will have one bar for control and it shows
the mean for {it:outcomevar} for all observations in control.
The second bar in the graph will be the sum of that mean
and the coefficient for {it:treatment_dummy} in the regression.
The graph will also have the title: {it:Treatment Effect on Outcome}.
{p_end}

{dlgtab:Example 2}

{input}{space 8}regress income tmt_1 tmt_2 age education, cluster(district)
{space 8}iegraph tmt_1 tmt_2, noconfbars yzero basictitle("Treatment effect on income")
{text}
{pstd}In the example above, the treatment effect on income in researched.
There are three treatment arms; control, treatment 1 ({it:tmt_1}) and treatment 2 ({it:tmt_2}).
It is important that no observation has the value 1 in both {it:tmt_1} and {it:tmt_2_
(i.e. no observation is in more than one treatment)
and some observations must have the value 0 in both {it:tmt_1} and {it:tmt_2_
(i.e. control observations).
The variables age and education are covariates (control variables)
and are not included in {inp:iegraph}. 
The option {inp:noconfbars} omits the confidence interval bars, 
and {inp:yzero} sets the y-axis to start at 0. 
{p_end}

{dlgtab:Example 3}

{input}{space 8}regress chld_wght time treat timeXtreat
{space 8}iegraph time treat timeXtreat , basictitle("Treatment effect on Child Weight (Diff-in-Diff)")
{text}
{pstd}In the example above, the data set is a panel data set
with two time periods and the regression estimates the treatment effect
on child weight using a {it:Difference-in-Differences} model.
The dummy variable time indicates if it is time period 0 or 1.
The dummy variable treat indicates if the observation is treatment or control.
{it:timeXtreat} is the interaction term of time and treat.
This the standard way to set up a {it:Difference-in-Differences} regression model.
{p_end}

{dlgtab:Example 4}

{input}{space 8}regress harvest T1 T2 T3
{space 8}iegraph T1 T2 T3 , basictitle("Treatment effect on harvest") xlabel(,angle(45)) yzero ylabel(minmax) save("Graph1.gph")}
{text}
{pstd}The example above shows how to save a graph to disk.
It also shows that most two-way graph options can be used.
In this example,
the {inp:iegraph} option {inp:yzero} conflicts with the two-way option {inp:ylabel(minmax)}. 
In such a case the user specified option takes precedence over {inp:iegraph} options like {inp:yzero}. 
{p_end}

{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions and requests for clarifications
writing {c 34}ietoolkit iegraph{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {inp:ietoolkit}. 
{p_end}

{title:Author}

{pstd}All commands in {inp:ietoolkit} are developed by DIME Analytics at DIME, The World Bank{c 39}s department for Development Impact Evaluations. 
{p_end}

{pstd}Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group
{p_end}
