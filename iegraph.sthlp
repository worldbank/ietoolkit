{smcl}
{* 26 Dec 2016}{...}
{hline}
help for {hi:iegraph}
{hline}

{title:Title}

{phang2}{cmdab:iegraph} {hline 2} Generates graphs based on regressions done during typical impact evaluation. 

{title:Syntax}

{phang2}
{cmdab:iegraph} {varlist} 
, [{cmd:noconfbars} {cmdab:TI:tle(}{it:string}{cmd:)}
{cmdab:save(}{it:string}{cmd:)} {cmdab:confbarsnone(}{it:varlist}{cmd:)}
]

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmd:noconfbars}}Removes the confidence interval bars from graphs for all treatments.{p_end}
{synopt :{cmdab:TI:tle(}{it:string}{cmd:)}}Manually sets the title of the graph.{p_end}
{synopt :{cmdab:save(}{it:string}{cmd:)}}Sets the filename and the directory to which the graph will be set.{p_end}
{synopt :{cmdab:confbarsnone(}{it:varlist}{cmd:)}}Removes confidence interval bars from only the {it:varlist} listed.{p_end}
{synoptline}

{marker desc}
{title:Description}

{pstd}{cmdab:iegraph}This command creates bar graphs on the average treatment effects
	for multiple treatments in a impact evaluation project. The command creates bar
	graphs for the mean of the control group and for the various treatment groups. {p_end}

{marker optslong}
{title:Options}

{phang}{cmd:noconfbars}Removes the confidence interval bars from graphs for all 
	treatments.{p_end}

{phang}{cmdab:TI:tle(}{it:string}{cmd:)}Manually sets the title of the graph.{p_end}

{phang}{cmdab:save(}{it:string}{cmd:)}Sets the filename and the directory to which
	the graph will be set.{p_end}

{phang}{cmdab:confbarsnone(}{it:varlist}{cmd:)}Removes confidence interval bars 
	from only the {it:varlist} listed. The remaining variables in the graphs which 
	have not been specified in {cmdab:confbarsnone} will still have the confidence
	interval bars. {p_end}



{title:Examples}

{pstd} {hi:Example 1.}

{pmore}{inp:iegraph treatmentVar1 treatmentVar2 , title({it:string})}

{pmore}In the example above, graphs comparing the effects of {it:treatmentVar1} and 
		{it:treatmentVar2} to the mean of the control will be generated. The option 
		title({it:string}) gives the graph the title that the user puts in the string.

{pstd} {hi:Example 2.}

{pmore}{inp:iematch if {it:baseline} == 1  , grpdummy({it:tmt}) matchvar({it:p_hat}) maxdiff(.001)}

{pmore}In the example above, the observations with value 1 in {it:tmt} will be matched
	towards the nearest, in terms of {it:p_hat}, observations with value 0 in {it:tmt} as
	long as the difference in {it:p_hat} is less than .001. Only observations that has the
	value 1 in variable {it:baseline} will be included in the match.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}{break}

{title:Author}

{phang}Kristoffer Bjarkefur & Mrijan Rimal, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietools iegraph" in the subject line to:{break}
		 kbjarkefur@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}
