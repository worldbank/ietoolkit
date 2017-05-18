{smcl}
{* 26 Dec 2016}{...}
{hline}
help for {hi:iematch}
{hline}

{title:Title}

{phang2}{cmdab:iefolder} {hline 2} Sets up project folders and master do-files according to World Bank DIME's standards.

{title:Syntax}

{phang2}
{cmd:iefolder} new {it:itemtype} , {cmdab:proj:ectfolder(}{it:directory}{cmd:)} 
	[{cmdab:abb:reviation(}{it:string}{cmd:)}] 
	
{pmore} Where {it:itemtype} is either {it:project}, {it:round}, {it:master} or 
	{it:unitofobs}. See details below.

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt : {cmdab:proj:ectfolder(}{it:dir}{cmd:)}}The location where 
	the {hi:DataWork} folder should be created (new projects), or 
	where it is located (existing projects). {p_end}
{synopt : {cmdab:abb:reviation(}{it:string}{cmd:)}}Optional abbreviation 
	of round name to be used to make globals shorter. {p_end}

{marker desc}
{title:Description}

{pstd}{cmdab:iefolder} automizes the process of setting up the folder in a 
	project folder where all the data work will take place. The folders set 
	up will follow DIME's best practices outlined and explained here: 
	{browse "https://dimewiki.worldbank.org/wiki/DataWork_Folder"} (This page 
	is a part of a Wiki that we are in the final stage of getting approval to 
	release externally, the page is until then unfortunatelly password protected.) 

{pstd}In addition to setting up the {hi:DataWork} folder and it sub-folders the 
	command creates master do-files linking to all of these sub-folders. These 
	master do-files are updated whenever more subfolders are added using this command.
	
{pstd}This command can create either a new DataWork folder or add folders to an 
	existing DataWork folder. The existing DataWork fodler must have been created 
	with {cmd:iefolder} for the additions to work. There are two types of folders 
	that can be added to an existing folder, {ul:{hi:round}} and {ul:{hi:master}}. 
	See next paragraphs for descriptions.
	
{pstd}{ul:{hi:round}} folders are folders specific to a data collection round, for example, {it:Baseline}, {it:Endline},
	{it:Follow Up} etc. When adding a new round, sub-folders are added to the DataWork 
	folder in line with the best practice described here:
	{browse "https://dimewiki.worldbank.org/wiki/DataWork_Survey_Round"}. {cmd:iefolder} also 
	creates a master do-file specific for the round with globals references the sub-folders
	specific to this round. {cmd:iefolder} is implemented so that you can keep working 
	for years with your project inbetween adding folders. The command reads the content 
	of the folder and the project master do-file and make the addition in accordance to
	that.
	
{pstd}{ul:{hi:master}} folder is folders specific to the master data sets that corresponds 
	to each unit of observation. Read more about master data sets and the folder structure
	this commands sets up for you at {browse "https://dimewiki.worldbank.org/wiki/Master_Data_Set"}. A 
	master data folder for each new unit of observation is created in two places. Both in 
	the MasterData folder in the DataWork folder, and in the MasterKeyID folder in the encrypted folder.

{marker optslong}
{title:Options}

{phang}{cmdab:proj:ectfolder(}{it:dir}{cmd:)} is 

{phang}{cmdab:abb:reviation(}{it:string}{cmd:)} is 

{title:Examples}

{pstd} {hi:Example 1.}

{pmore}{inp:iematch , grpdummy({it:tmt}) matchvar({it:p_hat})}

{pmore}In the example above, the observations with value 1 in {it:tmt} will be matched
	towards the nearest, in terms of {it:p_hat}, observations with value 0 in {it:tmt}.

{pstd} {hi:Example 2.}

{pmore}{inp:iematch if {it:baseline} == 1  , grpdummy({it:tmt}) matchvar({it:p_hat}) maxdiff(.001)}

{pmore}In the example above, the observations with value 1 in {it:tmt} will be matched
	towards the nearest, in terms of {it:p_hat}, observations with value 0 in {it:tmt} as
	long as the difference in {it:p_hat} is less than .001. Only observations that has the
	value 1 in variable {it:baseline} will be included in the match.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Mrijan Rimal, Seungmin Lee, Laura Costica{break}

{title:Author}

{phang}Kristoffer Bjarkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iefolder" in the subject line to:{break}
		 kbjarkefur@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}
