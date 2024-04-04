{smcl}
{* *! version 0.0 20240404}{...}
{hline}
{pstd}help file for {hi:ietoolkit}{p_end}
{hline}

{title:Title}

{phang}{bf:ietoolkit} - Returns information on the version of {inp:ietoolkit} installed 
{p_end}

{phang}For a more descriptive discussion on the intended usage and work flow of this command please see the DIME Wiki.
{p_end}

{title:Syntax}

{phang}{bf:ietoolkit}
{p_end}

{phang}Note that this command takes no arguments at all.
{p_end}

{title:Description}

{pstd}{inp:ietoolkit} This command returns the version of {inp:ietoolkit} installed. It can be used  to programmatically test if {inp:ietoolkit} is already installed. 
{p_end}

{title:Options}

{pstd}This command does not take any options.
{p_end}

{title:Examples}

{pstd}The code below is an example code that can be added to the top of any do-file.  The example code first tests if the command is installed, and install it if not. If it is installed, it tests if the version is less than version 5.0. If it is, it replaces the {inp:ietoolkit} file with the latest version. In your code you can skip the second part if you are not sure which version is required. But you should always have the first part testing that {inp:r(version)} has a value before using it in less than or greater than expressions. 
{p_end}

{input}{space 8}cap ietoolkit
{space 8}if "`r(version)'" == "" { 
{space 8}  *ietoolkit not installed, install it
{space 8}  ssc install ietoolkit
{space 8}}
{space 8}else if `r(version)' < 5.0 { 
{space 8}  *ietoolkit version too old, install the latest version
{space 8}  ssc install ietoolkit , replace
{space 8}}
{text}
{title:Acknowledgements}

{pstd}We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetic order):
{p_end}

{pstd}  Luiza Cardoso De Andrade, Seungmin Lee
{p_end}

{title:Author}

{pstd}All commands in {inp:ietoolkit} is developed by DIME Analytics at DIME, the World Bank{c 39}s department for Development Impact. 
{p_end}

{pstd}Main author: DIME Analytics, The World Bank
{p_end}

{pstd}Please send bug-reports, suggestions and requests for clarifications writing {c 34}ietoolkit ietoolkit{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version history of the code, and submit additions or edits to the code through the GitHub repository of {inp:ietoolkit}. 
{p_end}
