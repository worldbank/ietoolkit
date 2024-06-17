{smcl}
{* *! version 7.3 20240404}{...}
{hline}
{pstd}help file for {hi:iefolder}{p_end}
{hline}

{title:Title}

{phang}{bf:iefolder} - sets up project folders and master do-files according to World Bank DIME{c 39}s standards.
{p_end}

{phang}For a more descriptive discussion on the intended usage and work flow of this command please see the {browse "https://dimewiki.worldbank.org/Iefolder":DIME Wiki}
{p_end}

{title:Syntax}

{phang}{it:When initially setting up the {inp:DataWork} folder in a new project}: 
{p_end}

{phang}{bf:iefolder} new {it:project_name} , {bf:{ul:proj}ectfolder}({it:directory})
{p_end}

{phang}{it:When adding folders to and already existing {inp:DataWork} folder}: 
{p_end}

{phang}{bf:iefolder} new {it:item_type} {it:item_name} , {bf:{ul:proj}ectfolder}({it:directory}) [{bf:abbreviation}({it:string}) {bf:subfolder}({it:folder})]
{p_end}

{phang}where {it:item_type} is either {it:round}, {it:unitofobs} or {it:subfolder}. See details on {it:item_type} and {it:item_name} below.
{p_end}

{synoptset 24}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:proj}ectfolder}({it:directory})}The location of the project folder where the {it:DataWork} folder should be created (new projects), or where it is located (new rounds, unitofobs and subfolders).{p_end}
{synopt: {bf:abbreviation}({it:string})}Optional abbreviation of round name to be used to make globals shorter. Can only be used with {inp:iefolder new round}.{p_end}
{synopt: {bf:subfolder}({it:folder})}Creates the round folders inside a subfolder to {it:DataWork}. Only works with new rounds and only after the subfolder has been created with {inp:iefolder new subfolder}.{p_end}
{synoptline}

{title:Description}

{pstd}{inp:iefolder} automates the process of setting up the folders and 
master do-files where all the data work will take place in a project folder.
The folder structure set up by {inp:iefolder} follows DIME{c 39}s best practices. 
{p_end}

{pstd}In addition to setting up the {it:DataWork} folder and its folder structure,
the command creates master do-files linking to
all main folders in the folder structure.
These master do-files are updated whenever more rounds,
units of observations, and subfolders are added to
the project folder using this command.
{p_end}

{dlgtab:Item types}

{pstd}This command can create either a new {it:DataWork} folder or add folders
to an existing {it:DataWork} folder.
The existing {it:DataWork} folder must have been created with
{inp:iefolder} for the additions to work. 
A new {it:DataWork} folder is created using specifying project.
There are three types of folders that can be added to an existing folder
by specifying {it:round}, {it:unitofobs} or {it:subfolder}.
See the next paragraphs for descriptions.
{p_end}

{pstd}{bf:project} sets up a new {it:DataWork} folder and its initial folder structure.
You must always do this before you can do anything else.
It also sets up the main master do-file for this {it:DataWork} folder.
{inp:iefolder} is implemented so that you can keep working for years 
with your project in between adding folders.
The command reads and preserves changes made manually to the {it:DataWork} folder
and master do-file before adding more folders using {inp:iefolder}. 
{p_end}

{pstd}{bf:round} folders are folders specific to a data collection round,
for example, Baseline, Endline, Follow Up etc.
(See subfolder below if your project is more complex than that.)
When adding a new round, a round folder is added to the {it:DataWork} folder,
and inside it the round folder structure described
{browse "https://dimewik/wiki/DataWork_Survey_Round":here} is created.
{inp:iefolder} also creates a master do-file specific for this round with 
globals referencing the main folders in the folder structure
specific to this round.
Folders are created in two places, both in the {it:DataWork} folder,
and in the Encrypted folder.
{p_end}

{pstd}{bf:unitofobs} folders are folders specific to a unit of observation,
for example the master data set folder.
Read more about master data sets and the folder structure
this commands sets up for you at here.
A master data folder for each new unit of observation is created in two places.
Both in the MasterData folder in the {it:DataWork} folder,
and in the Encrypted folder.
{p_end}

{pstd}{bf:subfolder} can be used to organize project folders with
a lot of data collections.
For examples, instead of having only one baseline data collection,
a project might have a student, a teacher,
and a school data collections during baseline.
You can then first create a baseline folder in the project folder using
{it:subfolder} and then creating round-folders for student, teacher, school, etc.,
inside the sub-folder suing {it:round} with the option {bf:subfolder}({it:baseeline}).
When creating a subfolder,
only a single folder is created in the {it:DataWork} folder which is empty.
The main master do-file is however updated with a global to this folder.
{p_end}

{title:Options}

{pstd}{bf:{ul:proj}ectfolder}({it:directory}) should point to the same folder
regardless of which {it:item_type} is created.
If new project is specified,
the file path should point to where {it:DataWork} should be created,
and if new round or new project is specified,
it should point to where {it:DataWork} was already created.
See how the file path is the same both time when {inp:iefolder} 
is called twice in Example 1 below.
{p_end}

{pstd}{bf:abbreviation}({it:string}) can be used to shorten the globals created
in the master do-files that point to the sub-folders to round folders.
For example, if you create a new round called Baseline,
as in Example 1, then a global to the {it:DataSet} folder called Baseline{it:dt
will be created in the master do-file.
If the abbreviation option would have been used,
like in Example 2, then the global would have been called BL{it:dt.
{p_end}

{pstd}{bf:subfolder}({it:folder}) creates a round folder inside
the folder specified in this option.
This option can only be used when creating a new round.
The folder specified must have been created using {inp:iefolder}. See example 3. 
{p_end}

{title:Examples}

{dlgtab:Example 1}

{input}{space 8}global projectFolder "C:/Users/Documents/DropBox/ProjectABC"
{space 8}
{space 8}iefolder new project , projectfolder("$projectFolder")
{space 8}iefolder new round baseline , projectfolder("$projectFolder")
{text}
{pstd}In the example above, in the line the first time {inp:iefolder} is used, 
a folder called {it:DataWork} is created at the location of
{inp:C:/Users/Documents/DropBox/ProjectABC}. 
In the line where {inp:iefolder} used a second time, 
a folder for the baseline round is created inside the {it:DataWork} folder.
Note that the folder provided in {inp:projectfolder()} is the same both times. 
{p_end}

{pstd}Both the {it:DataWork} folder and the baseline folder created have
sub-folders and master do-files creating globals pointing to these.
{p_end}

{dlgtab:Example 2}

{input}{space 8}global projectFolder "C:/Users/Documents/DropBox/ProjectABC"
{space 8}
{space 8}iefolder new project , projectfolder("$projectFolder")
{space 8}iefolder new round baseline , projectfolder("$projectFolder") abbreviation("BL")
{text}
{pstd}The example above creates the same folder structure as in Example 1,
but in the globals in the master do-files the abbreviation BL
is used instead of baseline.
But the folders created on disk will still be called baseline.
{p_end}

{dlgtab:Example 3}

{pstd}This example shows how to use subfolders.
{p_end}

{input}{space 8}global projectFolder "C:/Users/Documents/DropBox/ProjectABC"
{space 8}
{space 8}iefolder new project , projectfolder("$projectFolder")
{space 8}
{space 8}iefolder new subfolder baseline , projectfolder("$projectFolder")
{space 8}iefolder new round studentBL , projectfolder("$projectFolder") subfolder("baseline")
{space 8}iefolder new round teacherBL , projectfolder("$projectFolder") subfolder("baseline")
{text}
{pstd}The code above creates a new {it:DataWork} folder inside the folder ProjectABC.
Then subfolder is used to create a folder called baseline.
Then the two baseline rounds, student and teacher,
are created inside the folder baseline.
{p_end}

{pstd}The code below shows how the endline folder can be created in the same folder.
Note that the rounds need to have unique names even across subfolders,
and that is why the student and teacher round have the suffix EL.
{p_end}

{input}{space 8}global projectFolder "C:/Users/Documents/DropBox/ProjectABC"
{space 8}
{space 8}iefolder new subfolder endline , projectfolder("$projectFolder")
{space 8}iefolder new round studentEL , projectfolder("$projectFolder") subfolder("endline")
{space 8}iefolder new round teacherEL , projectfolder("$projectFolder") subfolder("endline")
{text}
{dlgtab:Example 4}

{pstd}The example below is meant to describe an intended workflow
for a full life cycle of an impact evaluation.
First we need to set up the {it:DataWork} folder.
We do that using {inp:iefolder new project}. Like this: 
{p_end}

{input}{space 8}iefolder new project , projectfolder("C:/DropBox/ProjectABC")
{text}
{pstd}Our first data collection will be a baseline
where the unit of observation is households.
We therefore need to set up folders for the unit of observation {c 34}households{c 34}.
In the encrypted master folder for {c 34}households{c 34}
you can create your list over households and you have a subfolder called Sampling
where you can keep do files and data with identifying information.
We create all of that by using {inp:iefolder new unitofobs household}. Like this: 
{p_end}

{input}{space 8}iefolder new unitofobs household , projectfolder("C:/DropBox/ProjectABC") abbreviation("BL")
{text}
{pstd}When we are ready to start preparing for the baseline
we want to create the baseline folder.
We do that using {inp:iefolder new round baseline}. Like this: 
{p_end}

{input}{space 8}iefolder new round baseline , projectfolder("C:/DropBox/ProjectABC") abbreviation("BL")
{text}
{pstd}At this point we can collect the baseline data,
save the data in the folders we created and write the report.
Then long stretches of time might pass before we need to use the command.
{p_end}

{pstd}Let{c 39}s say that when we plan for midline
we also want to collect data about the villages
that the households we interview in baseline live in.
Then we need to create a new master folder for the unit of observation villages.
We do that using {inp:iefolder new unitofobs village}. Like this: 
{p_end}

{input}{space 8}iefolder new unitofobs village , projectfolder("C:/DropBox/ProjectABC")
{text}
{pstd}Then we need to create the rounds used for the midline round
for both households and for villages.
Since this is separate data collection
(although they might happen at the same time).
We create those folders like this:
{p_end}

{input}{space 8}iefolder new round midline       , projectfolder("C:/DropBox/ProjectABC") abbreviation("ML")
{space 8}iefolder new round midlineVillage, projectfolder("C:/DropBox/ProjectABC") abbreviation("MLvill")
{text}
{pstd}Finally, in the last round of data collection,
we are only collecting data on households again.
Since we are not collecting data on any new unit of observation,
we do not need to create any new master folder.
{p_end}

{input}{space 8}iefolder new round endline , projectfolder("C:/DropBox/ProjectABC") abbreviation("EL")
{text}
{title:Acknowledgements}

{pstd}This command was initially suggested by Esteban J. Quinones, University of Wisconsin-Madison.
{p_end}

{pstd}We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetical order):
{p_end}

{pstd}Guadalupe Bedoya
{p_end}

{pstd}Laura Costica
{p_end}

{pstd}Mrijan Rimal
{p_end}

{pstd}Sakina Shibuya
{p_end}

{pstd}Seungmin Lee
{p_end}

{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions and requests for clarifications
writing {c 34}ietoolkit iefolder{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {inp:ietoolkit}. 
{p_end}

{title:Author}

{pstd}All commands in {inp:ietoolkit} are developed by DIME Analytics at DIME, The World Bank{c 39}s department for Development Impact Evaluations. 
{p_end}

{pstd}Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group
{p_end}
