{smcl}
{* 26 Dec 2016}{...}
{hline}
help for {hi:iefolder}
{hline}

{title:Title}

{phang2}{cmdab:iefolder} {hline 2} Sets up project folders and master do-files according to World Bank DIME's standards.

{title:Syntax}

{pstd} {ul:When initially setting up the {hi:DataWork} folder in a new project:}

{phang2}{cmd:iefolder} new project, {cmdab:proj:ectfolder(}{it:directory}{cmd:)} 


{pstd} {ul:When adding folders to and already existing {hi:DataWork} folder:}

{phang2}{cmd:iefolder} new {it:itemtype} {it:itemname} , {cmdab:proj:ectfolder(}{it:directory}{cmd:)} 
	[{cmdab:abb:reviation(}{it:string}{cmd:)}] 
	
{pmore}where {it:itemtype} is either {it:round} or {it:master}. See 
	details on {it:itemtype} and {it:itemname} below.

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt : {cmdab:proj:ectfolder(}{it:dir}{cmd:)}}The location of 
	the project folder where the {hi:DataWork} folder should be 
	created (new projects), or where it is located (existing projects).{p_end}
{synopt : {cmdab:abb:reviation(}{it:string}{cmd:)}}Optional abbreviation 
	of round name to be used to make globals shorter. Can only be used 
	when {it:itemtype} is round.{p_end}
{synoptline}

{marker desc}{title:Description}

{pstd}{cmdab:iefolder} automates the process of setting up the folder in a 
	project folder where all the data work will take place. The folders set 
	up will follow DIME's best practices outlined and explained here: 
	{browse "https://dimewiki.worldbank.org/wiki/DataWork_Folder"} (This page 
	is a part of a Wiki that we are in the final stage of getting approval to 
	release externally, the page is until then unfortunately password protected.) 

{pstd}In addition to setting up the {hi:DataWork} folder and it sub-folders the 
	command creates master do-files linking to all of these sub-folders. These 
	master do-files are updated whenever more subfolders are added using this command.
	
{pstd}{ul:{hi:itemtypes}}. This command can create either a new DataWork folder or add folders to an 
	existing DataWork folder. The existing DataWork folder must have been created 
	with {cmd:iefolder} for the additions to work. There are two types of folders 
	that can be added to an existing folder, {ul:{round} and {ul:{master}. 
	See next paragraphs for descriptions.
	
{pstd}{ul:round} folders are folders specific to a data collection round, for example, {it:Baseline}, {it:Endline},
	{it:Follow Up} etc. When adding a new round, sub-folders are added to the DataWork 
	folder in line with the best practice described here:
	{browse "https://dimewiki.worldbank.org/wiki/DataWork_Survey_Round"}. {cmd:iefolder} also 
	creates a master do-file specific for the round with globals references the sub-folders
	specific to this round. {cmd:iefolder} is implemented so that you can keep working 
	for years with your project in between adding folders. The command reads the content 
	of the folder and the project master do-file and make the addition in accordance to
	that.
	
{pstd}{ul:master} folders are folders specific to the master data sets that corresponds 
	to each unit of observation. Read more about master data sets and the folder structure
	this commands sets up for you at {browse "https://dimewiki.worldbank.org/wiki/Master_Data_Set"}. A 
	master data folder for each new unit of observation is created in two places. Both in 
	the MasterData folder in the DataWork folder, and in the MasterKeyID folder in the encrypted folder.

{marker optslong}{title:Options}

{phang}{cmdab:proj:ectfolder(}{it:dir}{cmd:)} should point to the same folder regardless 
	of which {it:itemtype} is created. If {it:new project} is specified the file path should
	point to where DataWork should be created, and if {it:new round} or {it:new project} is
	specified, it should point to where DataWork was already created. See how the file path is 
	the same both time when {cmd:iefolder} is called twice in Example 1. 

{phang}{cmdab:abb:reviation(}{it:string}{cmd:)} can be used to shorten the globals created
	in the master do-files that point to the sub-folders to {it:round} folders. For example, 
	if you create a new {it:round} called Baseline, as in Example 1, then a global to the 
	DataSet folder called Baseline_dt will be created in the master do-file. If the 
	abbreviation option would have been used, like in Example 2, then the global would 
	have been called BL_dt.

{title:Examples}

{pstd}{hi:Example 1.}

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new project , projectfolder("$projectFolder")}{break}
{inp:iefolder new round baseline , projectfolder("$projectFolder")}

{pstd}In the example above, in the line the first time {cmd:iefolder} is used, a folder 
	called {hi:DataWork} is created at the location of "C:\Users\Documents\DropBox\ProjectABC". 
	The second time {cmd:iefolder} a folder for the baseline round is created inside the {hi:DataWork} 
	folder. Note that the folder provided in {inp:projectfolder()} is the same both times.
	
{pstd}Both the {hi:DataWork} folder and the {hi:baseline} folder created have sub-folders 
	and master do-files greating globals pointing to these.

	
{pstd}{hi:Example 2.}

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new project , projectfolder("$projectFolder")}{break}
{inp:iefolder new round baseline , projectfolder("$projectFolder") , abbvreviation("BL")}

{pstd}The example above creates the same folder structure as in Example 1, but 
	in the globals in the master do-files the abbreviation BL is used instead of 
	baseline. But the folders created on disk will still be called baseline.

	
{pstd} {hi:Example 3.}

{pstd}The example below is meant to describe an intended workflow for a full 
	life cycle of an impact evaluation. First we need to set up the {hi:DataWork} folder. 
	We do that using {it:{cmd:iefolder} new project}. Like this:

{pmore}{inp:iefolder new project , projectfolder("C:\Users\Documents\DropBox\ProjectABC")}

{pstd}Our first data collection will be a baseline where the unit of observation 
	is households. We therefore need to set up a master file for houesholds that
	we can sample from. We do that using {it:{cmd:iefolder} new master household}.
	Like this:

{pmore}{inp:iefolder new master household , projectfolder("C:\Users\Documents\DropBox\ProjectABC") , abbvreviation("BL")}

{pstd}When we are ready to start preparing for the baseline we want to create the 
	baseline folder. We do that using {it:{cmd:iefolder} new round baseline}. Like this:

{pmore}{inp:iefolder new round baseline , projectfolder("C:\Users\Documents\DropBox\ProjectABC") , abbvreviation("BL")}

{pstd}At this point we can collect the baseline data, save the data in the folders
	we created and write the report. Then long streches of time might pass before 
	we need to use the command. 
	
{pstd}Let's say that when we plan for midline we also want
	to collect data about the villages that the households we interview in baseline 
	lives in. Then we need to create a new master folder for the unit of observation 
	villages. We do that using {it:{cmd:iefolder} new master village}. Like this:

{pmore}{inp:iefolder new master village , projectfolder("$projectFolder")}

{pstd}Then we need to create the rounds used for the midline round for both 
	households and for villages. Since this is seperate data collection (although 
	they might happen at the same time). We create those folders like this:

{pmore}{inp:iefolder new round midlineVillage , projectfolder("$projectFolder") , abbvreviation("ML")}{break}
{inp:iefolder new round midline {space 6}     , projectfolder("$projectFolder") , abbvreviation("MLvill")}

{pstd}Finally, in the last round of data collection we are only collecting data 
	on households again. Since we are not collecting data on any new unit 
	of observation we do not need to create any new master folder.

{pmore}{inp:iefolder new round endline , projectfolder("$projectFolder") , abbvreviation("EL")}

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
