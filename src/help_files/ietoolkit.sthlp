{smcl}
{* 01 Feb 2024}{...}

{hline}
help for {hi:ietoolkit}
{hline}

{title:Title}

{phang}{cmdab:ietoolkit} {hline 2} Returns information on the version of ietoolkit installed

{phang}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Stata_Coding_Practices#ietoolkit":DIME Wiki}.

{title:Syntax}

{phang}
{cmdab:ietoolkit}

{pstd}Note that this command takes no arguments at all.{p_end}

{marker desc}
{title:Description}

{pstd}{cmdab:ietoolkit} This command returns the version of ietoolkit installed. It
	can be used in the beginning of a Master Do-file that is intended to be used
	by multiple users to programmatically test if ietoolkit is not installed for
	the user and therefore need to be installed, or if the version the user has
	installed is too old and needs to be upgraded.

{marker optslong}
{title:Options}

{phang}This command does not take any options.

{marker example}
{title:Examples}

{pstd}The code below is an example code that can be added to the top of any do-file.
	The example code first tests if the command is installed, and install it if not. If it is
	installed, it tests if the version is less than version 5.0. If it is, it
	replaces the ietoolkit file with the latest version. In your code you can skip
	the second part if you are not sure which version is required. But you should
	always have the first part testing that {inp:r(version)} has a value before using
	it in less than or greater than expressions.

{inp}    cap ietoolkit
{inp}    if "`r(version)'" == "" {
{inp}      *ietoolkit not installed, install it
{inp}      ssc install ietoolkit
{inp}    }
{inp}    else if `r(version)' < 5.0 {
{inp}      *ietoolkit version too old, install the latest version
{inp}      ssc install ietoolkit , replace
{inp}    }{text}

{title:Acknowledgements}

{phang}We would like to acknowledge the help in testing and proofreading we received
 in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Luiza Cardoso De Andrade{break}Seungmin Lee{break}

{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit ietoolkit" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
