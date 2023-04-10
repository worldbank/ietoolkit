{smcl}
{* 04 Apr 2023}{...}
{hline}
help for {hi:iegitaddmd}
{hline}

{title:Title}

{cmd:iegitaddmd} {hline 2} Creates a placeholder file in subfolders of a GitHub repository folder, which allows committing folder structures with empty folders.

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Iegitaddmd":DIME Wiki}.

{title:Syntax}

{phang} {cmdab:iegitaddmd} , {opt folder(full_file_path)} [{opt comparefolder(full_file_path)} {cmd:customfile(}{it:{help filename}}{cmd:)} {opt all} {opt skip} {opt replace} {opt skipfolders(folder_name)}  {opt auto:matic} {opt dry:run}]

{marker opts}{...}
{synoptset 28}{...}
{synopthdr:options}
{synoptline}
{synopt :{opt folder(full_file_path)}}Specifies the folder path to the project folder clone where placeholder files will be created{p_end}
{synopt :{opt comparefolder(full_file_path)}}Specifies the top folder of a folder tree to be compared with {opt folder()}{p_end}
{synopt :{cmd:customfile(}{it:{help filename}}{cmd:)}}Specifies a file saved on disk that is used instead of the default file as placeholder{p_end}
{synopt :{cmd:all}}Creates the placeholder file in every subfolder of {opt folder()}, whether empty or not{p_end}
{synopt :{opt skip}}If option {opt all} is used and a folder has a file with same name as placeholder file, then nothing is done{p_end}
{synopt :{opt replace}}If option {opt all} is used and a folder has a file with same name as placeholder file, then the file is overwritten{p_end}
{synopt :{opt skipfolders(folder_name)}}List of folders to be skipped. The folder {it:.git} is always added to this list, even when option is not used{p_end}
{synopt :{opt auto:matic}}Makes the command create placeholder files without prompting the user for each file{p_end}
{synopt :{opt dry:run}}Makes the command list all the files that would have been created without this option.{p_end}
{synoptline}

{marker desc}
{title:Description}

{pstd}GitHub does not sync empty folders, or folder that only contain ignored files. However, it is common in research projects that these types of folders needs to be shared anyways. {cmd:iegitaddmd} provides a solution to this by creating placeholder files in in these folders. This placeholder file can then be shared to GitHub and that way the folder is also shared. {cmd:iegitaddmd} have two ways to identify which those folders are that are developed with the two use cases described below in mind.{p_end}

{pstd}{bf:Use case 1.} It is common in the beginning of a research project that a standardized folder structure is set up (for example with {help iefolder}) where some folders are created that are not yet needed. Examples of folders like that could be the output folders. If these folders are not shared at the time they are created, there is a risk that different team members name them differently which will be confusing and could lead to errors. {cmd:iegitaddmd} can solve this by scanning a folder and all its sub-folders for completely empty folders, and create a placeholder file in that folder.{p_end}

{pstd}The solution to use case 1 in {cmd:iegitaddmd} is a Stata adaptation of {it:Solution B} in {browse "http://bytefreaks.net/gnulinux/bash/how-to-add-automatically-all-empty-folders-in-git-repository" :this post}.{p_end}

{pstd}{bf:Use case 2.} A common method when transferring an already ongoing research project to GitHub is to copy all of the data work folder from wherever the files and folders where shared before (for example DropBox) to a clone of the repository. Then only the files that are meant to be shared on GitHub are uploaded to the cloud using a {it:.gitignore file}. Empty folders or folders where all files are ignored is then not shared through GitHub. {cmd:iegitaddmd} can solve this by scanning the DropBox folder (or wherever the project folder was shared before) for sub-folders that exist in that folder but not in the clone and crate that folder in the clone and put a placeholder in it.{p_end}

{pstd}The way you differentiate between these two use cases when using {cmd:iegitaddmd} is whether the option {opt comparefolder()} is used or not. If that option is used, then {cmd:iegitaddmd} will identify all folders that are in {opt comparefolder()} that is not in {opt folder()}, and create a placeholder file there. If {opt comparefolder()} is not used, then {cmd:iegitaddmd} will identify all completely empty folders (no files or subfolders) and create a placeholder file there.{p_end}

{pstd}The default placeholder file used if no file is specified using option {opt customfile()} is called README.md, which is a name and format recognized by GitHub.com so that the content of the file is displayed on GitHub.com when navigating to that folder using a browser. The placeholder file may be removed as	soon as files that are not ignored have been added to the folder, or even better is to keep the file but edit the content of it so it documents the content of that folder for other and future team members.{p_end}

{marker optslong}
{title:Options}

{phang}{opt folder(file_path)} is the folder path to the project folder clone where the placeholder files will be created. Unless option {opt comparefolder()} or {opt all} is used, then placeholder files will be created in all empty folders. See option {opt manual} for a way to manually confirm each folder before a placeholder file is created in it.{p_end}

{phang}{opt comparefolder(file_path)} is used to compare a file tree in a different location and create the folders with placeholder files in all folders that exist in {opt comparefolder()} but not in {opt folder()}. If a folder that does no exist in {opt folder()} has a subfolder, then both the folder and the subfolder will be created and the placeholder file is only crated in the sub-folder. This is enough to share both folder and the subfolder in GitHub. If the {opt comparefolder()} and {opt folder()} ends with folders with different names, for example {opt folder(${project}/datawork/baseline)} and {opt comparefolder(${project}/datawork)}, then the command will throw an error as it is likely that the paths do not point to corresponding folders in the two folder trees. See option {opt manual} for a way to manually confirm each folder before a placeholder file is created in it.{p_end}

{phang}{cmd:customfile(}{it:{help filename}}{cmd:)} allows the user to specify a file saved on
	the computer to be used as the placeholder file	instead of the default README.md file. This
	allows people and organizations to write their own template placeholder files according to their own
	preferences. We recommend that a file of type .md (markdown) and name README.md is used as
	GitHub.com recognizes this name and format and will display the content of the file when someone
	browse to that folder on GitHub.com. But this is not a technical requirement, any file type
	and name can be used as placeholder file.{p_end}

{phang}{opt all} creates the placeholder file in {opt folder()} and in every subfolder,
	regardless if they are empty or not. This allows the user to create a placeholder file in every
	folder that can be edited with documentation and instructions to the purpose and usage of
	each subfolder. This option can also be important when .{it:gitignore} is used, as {cmd:iegitaddmd} will not
	create files to subfolders that only has ignored file -- in which case the folder will not
	be synced by GitHub.{p_end}

{phang}{opt skip} and {opt replace} tells {cmd:iegitaddmd} what to do if the option {opt all} is used
	and if any of the folders contain a file with the same name as the placeholder file the command
	is trying to create. If a file with the same name as the placeholder file exist and neither of these options
	are used, then the command will throw an error. If {opt skip} is used, then nothing is done in the
	folder where the file with the same name exists and the command proceeds to the next folder.
	If {opt replace} is used then the file with the same name is overwritten with the new placeholder
	file before the command proceeds to the next folder.{p_end}

{phang}{opt skipfolders(folder_name)} can be used to tell {cmd:iegitaddmd} which folders
in which a placeholder file should never be created. The best example of this is the {it:.git}
folder in which placeholders never should be created. That name is always skipped regardless of
this option being used or not. Use this option to list additional folders to be skipped. You
should not list the full folder path in this option, just the folder name. All folders with
that name will be skipped regardless of their location in the project folder.
Any sub-folder of these folders will also be skipped. The folder names may
be listed with or without quotation marks as long as there are no spaces in the names. If any of
the folder names has spaces, then quotation marks must be used for all folder names.

{phang}{opt auto:matic} can be used to speed up the creation of placeholders by telling the
command to not prompt the users for confirmation for each file before it is created. The
default is that the command is asking the user before creating each place holder file.
This option should only be used when you are confident you have specified the correct folder
paths. We recommend that you use the {opt dryrun} with this option to make sure that the
folder paths are correct.{p_end}

{phang}{opt dry:run} can be used to safely test that the folder paths are specified correctly
before any placeholder files are created. When this option it used the command simply lists
the file that would have been created if this option were not used. Once you are confident
that list is correct, you can remove this option and re-run the command and the files will
be created.{p_end}

{title:Example}

{pstd}{inp:global github_folder "C:/Users/JohnSmith/Documents/GitHub/ProjectA"}{break}{inp:iegitaddmd , folder({it:"$github_folder"})}{p_end}

{pstd}In the example above, there is a GitHub repository in the folder ProjectA. This
	repository has a folder structure where some folders are still empty but will later
	be populated with files. In order to have all folders, even the empty ones, synced on all
	collaborators' cloned local copies of the repository, the folders need to contain at least
	one file, which is being created by the command.{p_end}

{pstd}{inp:global github_folder "C:/Users/JohnSmith/Documents/GitHub/ProjectB"}{break}{inp:iegitaddmd , folder({it:"$github_folder"}) skipfolders("foo" "bar")}{p_end}

{pstd}In the example above, there is a GitHub repository in the folder ProjectB. This
is a project similar to ProjectA above but it has to folder, called {inp:foo} and {inp:bar}
in which no placeholder files should ever be created in. Any subfolders in {inp:foo}
or {inp:bar} will be skipped as well. The folder {inp:.git} is a system folder in git
repositories and will always be skipped.{p_end}

{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Author: DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iegitaddmd" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
