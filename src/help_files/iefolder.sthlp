{smcl}
{* 01 Feb 2024}{...}
{hline}
help for {hi:iefolder}
{hline}

{title:Title}

{phang2}{cmdab:iefolder} {hline 2} sets up project folders and master do-files according to World Bank DIME's standards.{p_end}

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Iefolder":DIME Wiki}.

{title:Syntax}

{pstd} {ul:When initially setting up the {hi:DataWork} folder in a new project:}{p_end}

{phang2}{cmd:iefolder} new project, {cmdab:proj:ectfolder(}{it:directory}{cmd:)} {p_end}


{pstd} {ul:When adding folders to and already existing {hi:DataWork} folder:}{p_end}

{phang2}{cmd:iefolder} new {it:itemtype} {it:itemname} , {cmdab:proj:ectfolder(}{it:directory}{cmd:)}
	[{cmdab:abb:reviation(}{it:string}{cmd:)} {cmdab:sub:folder(}{it:folder}{cmd:)}] {p_end}

{pmore}where {it:itemtype} is either {it:round}, {it:unitofobs} or {it:subfolder}. See
	details on {it:itemtype} and {it:itemname} below.{p_end}

{marker opts}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt : {cmdab:proj:ectfolder(}{it:dir}{cmd:)}}The location of
	the project folder where the {hi:DataWork} folder should be
	created (new projects), or where it is located (new rounds, unitofobs and subfolders).{p_end}
{synopt : {cmdab:abb:reviation(}{it:string}{cmd:)}}Optional abbreviation
	of round name to be used to make globals shorter. Can only be used
	when {it:itemtype} is round.{p_end}
{synopt : {cmdab:sub:folder(}{it:folder}{cmd:)}}Creates the round folders inside
	a subfolder to DataWork. Only works with new rounds and only after the subfolder
	has been created with {it:iefolder new subfolder}.{p_end}
{synoptline}

{marker desc}{title:Description}

{pstd}{cmdab:iefolder} automates the process of setting up the folders and master do-files
	where all the data work will take place in a project folder. The folder structure set
	up by {cmdab:iefolder} follows {browse "https://dimewiki.worldbank.org/wiki/DataWork_Folder":DIME's best practices}.

{pstd}In addition to setting up the {hi:DataWork} folder and its folder structure, the
	command creates master do-files linking to all main folders in the folder structure. These
	master do-files are updated whenever more rounds, units of observations, and
	subfolders are added to the project folder using this command.

{pstd}{ul:{hi:itemtypes}}{break} This command can create either a new DataWork folder or add folders to an
	existing DataWork folder. The existing DataWork folder must have been created
	with {cmd:iefolder} for the additions to work. A new DataWork folder is created using specifying {ul:project}. There are three types of folders that can be added to an existing folder by specifying {ul:round}, {ul:unitofobs} or {ul:subfolder}. See
	next paragraphs for descriptions.

{pstd}{ul:{it:project}} sets up a new DataWork folder and its initial folder structure. You must always do this before you can do anything else. It also sets up the main master do-file for this DataWork folder. {cmd:iefolder} is implemented so that you can keep working for years with your project in between adding folders. The command reads and preserves changes made manually to the DataWork folder and master do-file before adding more folders using {cmd:iefolder}.

{pstd}{ul:{it:round}} folders are folders specific to a data collection round, for example, {it:Baseline}, {it:Endline},
	{it:Follow Up} etc. (See {it:subfolder} below if your project is more complex than that.) When adding a new round, a round folder is added to the DataWork folder, and inside it the round folder structure described {browse "https://dimewiki.worldbank.org/wiki/DataWork_Survey_Round":here} is created. {cmd:iefolder} also
	creates a master do-file specific for this round with globals referencing the main folders
	in the folder structure specific to this round. Folders are created in two places, both in the DataWork folder, and in the Encrypted folder.

{pstd}{ul:{it:unitofobs}} folders are folders specific to a unit of observation,
	for example the master data set folder. Read more about master data sets and the folder structure
	this commands sets up for you at {browse "https://dimewiki.worldbank.org/wiki/Master_Data_Set":here}. A
	master data folder for each new unit of observation is created in two places. Both in
	the MasterData folder in the DataWork folder, and in the Encrypted folder.

{pstd}{ul:{it:subfolder}} can be used to organize folders with a lot of data collections. For examples, instead of having only one baseline data collection, a project might have a student, a teacher, and a school data collections all in baseline. With {it:subfolder} you can, using this example, create a folder called Baseline in the DataWork folder, and when creating the rounds for student, teacher and school, you can create those round inside the Baseline folder using the option {cmd:subfolder(}{it:Baseline}{cmd:)}. When creating a subfolder, only a single folder is created in the DataWork folder and it is empty. The main master do-file is however updated with a global to this folder.

{marker optslong}{title:Options}

{phang}{cmdab:proj:ectfolder(}{it:dir}{cmd:)} should point to the same folder regardless
	of which {it:itemtype} is created. If {it:new project} is specified, the file path should
	point to where DataWork should be created, and if {it:new round} or {it:new project} is
	specified, it should point to where DataWork was already created. See how the file path is
	the same both time when {cmd:iefolder} is called twice in Example 1 below.

{phang}{cmdab:abb:reviation(}{it:string}{cmd:)} can be used to shorten the globals created
	in the master do-files that point to the sub-folders to {it:round} folders. For example,
	if you create a new {it:round} called Baseline, as in Example 1, then a global to the
	DataSet folder called Baseline_dt will be created in the master do-file. If the
	abbreviation option would have been used, like in Example 2, then the global would
	have been called BL_dt.

{phang}{cmdab:sub:folder(}{it:folder}{cmd:)} creates a round folder inside the folder specified in this option. This option can only be used when creating a new round. The folder specified must have been created using {cmd:iefolder}. See example 3.

{title:Examples}

{pstd}{hi:Example 1.}

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new project , projectfolder("$projectFolder")}{break}
{inp:iefolder new round baseline , projectfolder("$projectFolder")}

{pstd}In the example above, in the line the first time {cmd:iefolder} is used, a folder
	called {hi:DataWork} is created at the location of {it:"C:\Users\Documents\DropBox\ProjectABC"}.
	In the line where {cmd:iefolder} used a second time, a folder for the baseline round
	is created inside the {hi:DataWork} folder. Note that the folder provided
	in {inp:projectfolder()} is the same both times.

{pstd}Both the {hi:DataWork} folder and the {hi:baseline} folder created have sub-folders
	and master do-files creating globals pointing to these.


{pstd}{hi:Example 2.}

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new project , projectfolder("$projectFolder")}{break}
{inp:iefolder new round baseline , projectfolder("$projectFolder") abbreviation("BL")}

{pstd}The example above creates the same folder structure as in Example 1, but
	in the globals in the master do-files the abbreviation BL is used instead of
	baseline. But the folders created on disk will still be called baseline.

{pstd} {hi:Example 3.}

{pstd}This example shows how to use subfolders.

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new project , projectfolder("$projectFolder")}

{pmore}{inp:iefolder new subfolder baseline , projectfolder("$projectFolder")}{break}
{inp:iefolder new round studentBL , projectfolder("$projectFolder") subfolder("baseline")}{break}
{inp:iefolder new round teacherBL , projectfolder("$projectFolder") subfolder("baseline")}

{pstd}The code above creates a new {hi:DataWork} folder inside the folder ProjectABC. Then {hi:subfolder} is used to create a folder called baseline. Then the two baseline rounds, student and teacher, are created inside the folder baseline.

{pstd}The code below shows how the endline folder can be created in the same folder. Note that the rounds need to have unique names even across subfolders, and that is why the student and teacher round have the suffix EL.

{pmore}{inp:global projectFolder "C:\Users\Documents\DropBox\ProjectABC"}

{pmore}{inp:iefolder new subfolder endline , projectfolder("$projectFolder")}{break}
{inp:iefolder new round studentEL , projectfolder("$projectFolder") subfolder("endline")}{break}
{inp:iefolder new round teacherEL , projectfolder("$projectFolder") subfolder("endline")}

{pstd} {hi:Example 4.}

{pstd}The example below is meant to describe an intended workflow for a full
	life cycle of an impact evaluation. First we need to set up the {hi:DataWork} folder.
	We do that using {it:{cmd:iefolder} new project}. Like this:

{pmore}{inp:iefolder new project , projectfolder("C:\DropBox\ProjectABC")}

{pstd}Our first data collection will be a baseline where the unit of observation
	is households. We therefore need to set up folders for the unit of observation
	"households". In the encrypted master folder for "housholds" you can create your
	list over households and you have a subfolder called {it:Sampling} where you
	can keep do files and data with identifying information. We create all of that by
	using {it:{cmd:iefolder} new unitofobs household}.	Like this:

{pmore}{inp:iefolder new unitofobs household , projectfolder("C:\DropBox\ProjectABC") abbreviation("BL")}

{pstd}When we are ready to start preparing for the baseline we want to create the
	baseline folder. We do that using {it:{cmd:iefolder} new round baseline}. Like this:

{pmore}{inp:iefolder new round baseline , projectfolder("C:\DropBox\ProjectABC") abbreviation("BL")}

{pstd}At this point we can collect the baseline data, save the data in the folders
	we created and write the report. Then long stretches of time might pass before
	we need to use the command.

{pstd}Let's say that when we plan for midline we also want
	to collect data about the villages that the households we interview in baseline
	live in. Then we need to create a new master folder for the unit of observation
	villages. We do that using {it:{cmd:iefolder} new unitofobs village}. Like this:

{pmore}{inp:iefolder new unitofobs village , projectfolder("C:\DropBox\ProjectABC")}

{pstd}Then we need to create the rounds used for the midline round for both
	households and for villages. Since this is separate data collection (although
	they might happen at the same time). We create those folders like this:

{pmore}{inp:iefolder new round midline {space 6}, projectfolder("C:\DropBox\ProjectABC") abbreviation("ML")}{break}
{inp:iefolder new round midlineVillage, projectfolder("C:\DropBox\ProjectABC") abbreviation("MLvill")}

{pstd}Finally, in the last round of data collection, we are only collecting data
	on households again. Since we are not collecting data on any new unit
	of observation, we do not need to create any new master folder.

{pmore}{inp:iefolder new round endline , projectfolder("C:\DropBox\ProjectABC") abbreviation("EL")}

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Guadalupe Bedoya{break}Laura Costica{break}Luiza Cardoso De Andrade{break}Mrijan Rimal{break}Sakina Shibuya{break}Seungmin Lee

{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iefolder" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through  {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
