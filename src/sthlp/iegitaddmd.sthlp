{smcl}
{* *! version 7.3 20240404}{...}
{hline}
{pstd}help file for {hi:iegitaddmd}{p_end}
{hline}

{title:Title}

{phang}{bf:iegitaddmd} - Creates a placeholder file in subfolders of a GitHub repository folder, which allows committing folder structures with empty folders.
{p_end}

{phang}For a more descriptive discussion on the intended usage and work flow of this command please see the {browse "https://dimewiki.worldbank.org/Iegitaddmd":DIME Wiki}.
{p_end}

{title:Syntax}

{phang}{bf:iegitaddmd} , {bf:folder}({it:full_file_path}) [ {bf:comparefolder}({it:full_file_path}) {bf:customfile}({it:filename}) {bf:all} {bf:skip} {bf:replace} {bf:skipfolders}({it:folder_name}) {bf:{ul:auto}matic} {bf:{ul:dry}run} ]
{p_end}

{synoptset 29}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:folder}({it:full_file_path})}Specifies the folder path to the project folder clone where placeholder files will be created{p_end}
{synopt: {bf:comparefolder}({it:full_file_path})}Specifies the top folder of a folder tree to be compared with {inp:folder()}{p_end}
{synopt: {bf:customfile}({it:filename})}Specifies a file saved on disk that is used instead of the default file as placeholder{p_end}
{synopt: {bf:all}}Creates the placeholder file in every subfolder of {inp:folder()}, whether empty or not{p_end}
{synopt: {bf:skip}}If option {inp:all} is used and a folder has a file with same name as placeholder file, then nothing is done{p_end}
{synopt: {bf:replace}}If option {inp:all} is used and a folder has a file with same name as placeholder file, then the file is overwritten{p_end}
{synopt: {bf:skipfolders}({it:folder_name})}List of folders to be skipped. The hidden folder {it:.git} is always added to this list, even when option {inp:skip} is not used{p_end}
{synopt: {bf:{ul:auto}matic}}Makes the command create placeholder files without prompting the user for each file{p_end}
{synopt: {bf:{ul:dry}run}}Makes the command list all the files that would have been created without this option{p_end}
{synoptline}

{title:Description}

{pstd}Git/GitHub does not {c 34}{it:sync}{c 34} empty folders, or folder that only contain ignored files.
However, it is common in research projects that these types of folders needs to be shared anyways.
{inp:iegitaddmd} provides a solution to this by creating placeholder files in in these folders. 
This placeholder file can then be shared to GitHub and that way the folder is also shared.
{inp:iegitaddmd} is developed with two use cases in mind described below. 
{p_end}

{pstd}{inp:Use case 1.} It is common in the beginning of a research project that 
a standardized folder structure is set up (for example with {inp:iefolder}) 
where some folders that are created are not yet needed.
A common example, is output folders.
If these folders are not shared at the time they are created,
different team members will create them ad-hoc when needed.
That typically leads to them being named differently
which is confusing and could in turn lead to errors.
{inp:iegitaddmd} can solve this by scanning a project folder for all sub-folders 
that are completely empty, and create a placeholder file in those folder.
{p_end}

{pstd}The solution to this use case in {inp:iegitaddmd} is a Stata adaptation of Solution B in 
{browse "https://bytefreaks.net/gnulinux/bash/how-to-add-automatically-all-empty-folders-in-git-repository":this post}.
{p_end}

{pstd}{inp:Use case 2.} The second use case is when an already ongoing project is transferred to Git/GitHub. 
Then, many files and folders are copied from wherever
they were stored before (for example DropBox) to a clone of the repository.
Files not meant to be shared on GitHub can (and should) be ignored using the {it:.gitignore} file.
However, this is likely to create empty folders that are not shared on GitHub.
A clone of this repo would then miss those folder but they might be required folders like
 output folder or folders for intermediate data.
{inp:iegitaddmd} can solve this by scanning the project folder in the old location 
and for each sub-folder that exist in the old location but not in the clone
create that folder and put a place holder file in it.
In this use case the option {inp:comparefolder()} is used to indicate that 
the clone should be compared to another folder.
{p_end}

{pstd}The default placeholder file used is named {inp:README.md} and its content explains that it is a placeholder file. 
That file name is a special name on GitHub,
and whenever one navigate to a folder on GitHub.com with a {inp:README.md} file, 
the content of that file is displayed on that web page.
The placeholder file may be removed as soon as files have been added to the folder.
Or perhaps even better is to keep the file, but edit the content of it such that
it documents the content of that folder for all other team members.
{p_end}

{title:Options}

{pstd}{bf:folder}({it:full_file_path}) is the folder path to the project folder clone where the placeholder files will be created.
{p_end}

{pstd}{bf:comparefolder}({it:full_file_path}) is used to compare a file tree in a different location
and create folders with placeholder files in all folders that exist in
{inp:comparefolder()} but not in {inp:folder()}. 
If a folder that does no exist in {inp:folder()} has a subfolder, 
then both the folder and the subfolder will be created,
 but the placeholder file is only crated in the sub-folder.
 This is sufficient for sharing both the folder and the subfolder in GitHub.
 If the {inp:comparefolder()} and {inp:folder()} ends with folders with different names, 
 for example {inp:folder(/datawork/baseline)} and {inp:comparefolder(/datawork)}, 
 then the command will throw an error as it is likely that
 the paths do not point to corresponding folders in the two folder trees.
{p_end}

{pstd}{bf:customfile}({it:filename}) allows the user to specify a file saved on the computer
to be used as the placeholder file instead of the default {inp:README.md} file. 
This allows anyone to write their own template placeholder files according to their own preferences.
We recommend that a file of type .md (markdown)
and name README.md is used such that the content is displayed when someone navigate to that folder on GitHub.com.
But this is not a technical requirement, any file type and name can be used as placeholder file.
{p_end}

{pstd}{bf:all} creates the placeholder file in {inp:folder()} and in every subfolder, regardless if they are empty or not. 
This allows the user to create a placeholder file in every folder that can be
edited with documentation and instructions to the purpose and usage of each subfolder.
This option can also be important when {it:.gitignore} is used,
as {inp:iegitaddmd} will not create files to subfolders that 
only has ignored file -- in which case the folder will not be synced by GitHub.
{p_end}

{pstd}{bf:skip} and {bf:replace} tells {inp:iegitaddmd} what to do if the option {inp:all} is used 
and if any of the folders contain a file with the exact same name as the file the command is trying to create.
If a file with the same name as the placeholder file exist and neither of these options are used,
then the command will throw an error.
If {inp:skip} is used, then nothing is done in the folder where the file with the same name exists 
and the command proceeds to the next folder.  
If {inp:replace} is used then the file with the same name is overwritten with 
the new placeholder file before the command proceeds to the next folder.
{p_end}

{pstd}{bf:skipfolders}({it:folder_names}) is used to list folders in which a placeholder file should never be created.
You should not list the full folder path in this option, just the folder name.
All folders with that name will be skipped regardless of their location in the project folder.
Any sub-folder of these folders will also be skipped.
A folder name may be listed with or without quotation marks as long as there are no spaces in the names.
If any of the folder names has spaces, then quotation marks must be used for all folder names.
{p_end}

{pstd}{bf:{ul:auto}matic} can be used to speed up the creation of placeholders by
telling the command to not prompt the users for confirmation for each file before it is created.
The default is that the command is asking the user before creating each place holder file.
This option should only be used when you are confident you have specified the correct folder paths.
We recommend that you use the {inp:dryrun} with this option to make sure that the folder paths are correct. 
{p_end}

{pstd}{bf:{ul:dry}run} can be used to safely test that the folder paths are
specified correctly before any placeholder files are created.
When this option it used the command simply lists the file
that would have been created if this option were not used.
Once you are confident that list is correct,
you can remove this option and re-run the command and the files will be created.
{p_end}

{title:Stored results}

{title:Examples}

{dlgtab:Example 1}

{pstd}In this example, there is a GitHub repository in the folder {it:ProjectA}.
This repository has a folder structure where
some folders are still empty but will later be populated with files.
In order to have all folders, even the empty ones,
synced on all collaborators{c 39} cloned local copies of the repository,
the folders need to contain at least one file,
which is being created by the command.
{p_end}

{input}{space 8}global github_folder "C:/Users/JohnSmith/Documents/GitHub/ProjectA"
{space 8}iegitaddmd , folder("$github_folder")
{text}
{dlgtab:Example 2}

{pstd}In this example, there is a GitHub repository in the folder {it:ProjectB}.
This is a project similar to {it:ProjectA} above but it has two folders,
called foo and bar in which no placeholder files should ever be created in.
Any subfolders in foo or bar will be skipped as well.
The folder {it:.git} is a system folder in git repositories and will always be skipped.
{p_end}

{input}{space 8}global github_folder "C:/Users/JohnSmith/Documents/GitHub/ProjectB"
{space 8}iegitaddmd , folder("$github_folder") skipfolders("foo" "bar")
{text}
{title:Feedback, bug reports and contributions}

{pstd}Please send bug-reports, suggestions and requests for clarifications
writing {c 34}ietoolkit iegitaddmd{c 34} in the subject line to: dimeanalytics@worldbank.org
{p_end}

{pstd}You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":GitHub repository} for {inp:ietoolkit}. 
{p_end}

{title:Author}

{pstd}All commands in {inp:ietoolkit} are developed by DIME Analytics at DIME, The World Bank{c 39}s department for Development Impact Evaluations. 
{p_end}

{pstd}Main authors: DIME Analytics, The World Bank Group
{p_end}
