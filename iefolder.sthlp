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
	
{pmore}where {it:itemtype} is either {it:project}, {it:round} or {it:master}. See 
	details on itemtypes below.

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt :{it:new itemtype}}Specifies if you want to create a DataWork folder in a 
	new {ul:{it:project}} or add a new {ul:{it:round}} folder or new {ul:{it:master}}
	folders.{p_end}
{synopt : {cmdab:proj:ectfolder(}{it:dir}{cmd:)}}The location of 
	the project folder where the {hi:DataWork} folder should be 
	created (new projects), or where it is located (existing projects).{p_end}
{synopt : {cmdab:abb:reviation(}{it:string}{cmd:)}}Optional abbreviation 
	of round name to be used to make globals shorter. {p_end}
{synoptline}

{marker desc}{title:Description}

{pstd}{cmdab:iefolder} automizes the process of setting up the folder in a 
	project folder where all the data work will take place. The folders set 
	up will follow DIME's best practices outlined and explained here: 
	{browse "https://dimewiki.worldbank.org/wiki/DataWork_Folder"} (This page 
	is a part of a Wiki that we are in the final stage of getting approval to 
	release externally, the page is until then unfortunatelly password protected.) 

{pstd}In addition to setting up the {hi:DataWork} folder and it sub-folders the 
	command creates master do-files linking to all of these sub-folders. These 
	master do-files are updated whenever more subfolders are added using this command.
	
{pstd}{ul:{hi:itemtypes}}. This command can create either a new DataWork folder or add folders to an 
	existing DataWork folder. The existing DataWork fodler must have been created 
	with {cmd:iefolder} for the additions to work. There are two types of folders 
	that can be added to an existing folder, {ul:{round} and {ul:{master}. 
	See next paragraphs for descriptions.
	
{pstd}{ul:round} folders are folders specific to a data collection round, for example, {it:Baseline}, {it:Endline},
	{it:Follow Up} etc. When adding a new round, sub-folders are added to the DataWork 
	folder in line with the best practice described here:
	{browse "https://dimewiki.worldbank.org/wiki/DataWork_Survey_Round"}. {cmd:iefolder} also 
	creates a master do-file specific for the round with globals references the sub-folders
	specific to this round. {cmd:iefolder} is implemented so that you can keep working 
	for years with your project inbetween adding folders. The command reads the content 
	of the folder and the project master do-file and make the addition in accordance to
	that.
	
{pstd}{ul:master} folders are folders specific to the master data sets that corresponds 
	to each unit of observation. Read more about master data sets and the folder structure
	this commands sets up for you at {browse "https://dimewiki.worldbank.org/wiki/Master_Data_Set"}. A 
	master data folder for each new unit of observation is created in two places. Both in 
	the MasterData folder in the DataWork folder, and in the MasterKeyID folder in the encrypted folder.

{marker optslong}{title:Options}

{phang}{it:new itemtype} is used to specify what to create when {cmd:iefolder} is used. 
	There are three {it:itemtpyes} meaning that it can either be sepcified as {it:new project}, 
	{it:new round} or {it:new master}. {it:new project} sets up the initia

{phang}{cmdab:proj:ectfolder(}{it:dir}{cmd:)} should point to the same folder regardless 
	of which {it:itemtype}is created. If {it:new project} is specified the file path should
	point to where DataWork should be created, and if {it:new round} or {it:new project} is
	specified, it should point to where DataWork was already created. See how the file path is 
	the same both time when {cmd:iefolder} is called twice in Example 1. 

{phang}{cmdab:abb:reviation(}{it:string}{cmd:)} can be used to shorten the globals created
	in the master do-files that point to the sub-folders to {it:roundf} folders. For example, 
	if you create a new {it:round} called Baseline, as in Example 1, then a global to the 
	DataSet folder called Baseline_dt will be created in the master do-file. If the 
	abbrevation office would have been used like in Example 2, then the global would 
	have been called BL_dt.

{title:Examples}

{pstd} {hi:Example 1.}

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new project , projectfolder("$projectFolder")}{break}
{inp:iefolder new round baseline , projectfolder("$projectFolder")}

{pmore}In the example above, 

{pstd} {hi:Example 2.}

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new project , projectfolder("$projectFolder")}{break}
{inp:iefolder new round baseline , projectfolder("$projectFolder") , abbvreviation("BL")}

{pmore}In the example above, 

{pstd} {hi:Example 2.}

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new project , projectfolder("$projectFolder")}{break}
{inp:iefolder new master household , projectfolder("$projectFolder") , abbvreviation("BL")}{break}
{inp:iefolder new round baseline , projectfolder("$projectFolder") , abbvreviation("BL")}

{pmore}{inp:iefolder new round midline , projectfolder("$projectFolder") , abbvreviation("ML")}{break}
{inp:iefolder new master village , projectfolder("$projectFolder")}

{pmore}{inp:iefolder new round endline , projectfolder("$projectFolder") , abbvreviation("EL")}

{pmore}In the example above, 

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Laura Costica{break}Seungmin Lee{break}Mrijan Rimal{break}

{title:Author}

{phang}Kristoffer Bjarkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iefolder" in the subject line to:{break}
		 kbjarkefur@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}
