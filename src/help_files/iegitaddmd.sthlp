{smcl}
{* 31 Jan 2019}{...}
{hline}
help for {hi:iegitaddmd}
{hline}

{title:Title}

{cmd:iegitaddmd} {hline 2} Creates a placeholder file in subfolders of a GitHub repository folder, which allows committing folder structures with empty folders.

{phang2}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/Iegitaddmd":DIME Wiki}.

{title:Syntax}

{phang} {cmdab:iegitaddmd} , {opt folder(file_path)} [{cmd:customfile(}{it:{help filename}}{cmd:)} {opt all} {opt skip} {opt replace}]

{marker opts}{...}
{synoptset 20}{...}
{synopthdr:options}
{synoptline}
{synopt :{opt folder(file_path)}}Specifies the folder path to the repository folder{p_end}
{synopt :{cmd:customfile(}{it:{help filename}}{cmd:)}}Specifies a file saved on disk that is used instead of the default file as placeholder{p_end}
{synopt :{cmd:all}}Creates the placeholder file in every subfolder of {opt folder()}, whether empty or not{p_end}
{synopt :{opt skip}}If option {opt all} is used and a folder has a file with same name as placeholder file, then nothing is done{p_end}
{synopt :{opt replace}}If option {opt all} is used and a folder has a file with same name as placeholder file, then the file is overwritten{p_end}
{synopt :{opt manual}}If option {opt manual} is used then the user is prompted before each placeholder file is created.{p_end}
{synoptline}

{marker desc}
{title:Description}

{pstd}GitHub does not sync empty folders, or folder that only contain ignored files.
	However, it is common in research projects
	that a folder structure is added to the GitHub repository at the beginning of a project. At
	the time the folder structure is added to the repository, several folders might still
	be empty and GitHub will not sync them, meaning that they will not be available to the full
	team. {cmd:iegitaddmd} is a Stata adaptation of {it:Solution B} in {browse "http://bytefreaks.net/gnulinux/bash/how-to-add-automatically-all-empty-folders-in-git-repository" :this post}.

{pstd}{cmd:iegitaddmd} creates a placeholder file in all empty subfolders of
	the folder specified in {opt folder()}. The default file used if no file is specified
	using option {opt customfile()} is called README.md, which is a name and format recognized by
	GitHub.com so that the content of the file is displayed if the folder with that file is
	browsed on GitHub.com. The placeholder file may be removed as
	soon as actual files have been added to the folder. Alternatively, if the option
	{opt all} is used, {cmd:iegitaddmd} will create the placeholder file in each subfolder
	of {opt folder()}, regardless of them being empty or not.

{marker optslong}
{title:Options}

{phang}{opt folder(file_path)} is the folder path to the project folder where the
	placeholder file will be created in each empty folder.

{phang}{cmd:file(}{it:{help filename}}{cmd:)} allows the user to specify a file saved on
	the computer to be used as the placeholder file	instead of the default README.md file. This
	allows people and organizations to write their own template placeholder files according to their own
	preferences. We recommend that a file of type .md (markdown) and name README.md is used as
	GitHub.com recognizes this name and format and will display the content of the file when someone
	browse to that folder on GitHub.com. But this is not a technical requirement, any file type
	and name can be used as placeholder file.

{phang}{opt all} creates the placeholder file in {opt folder()} and in every subfolder,
	regardless if they are empty or not. This allows the user to create a placeholder file in every
	folder that can be edited with documentation and instructions to the purpose and usage of
	each subfolder. This option can also be important when .{it:gitignore} is used, as {cmd:iegitaddmd} will not
	create files to subfolders that only has ignored file -- in which case the folder will not
	be synced by GitHub.

{phang}{opt skip} and {opt replace} tells {cmd:iegitaddmd} what to do if the option {opt all} is used
	and if any of the folders contain a file with the same name as the placeholder file the command
	is trying to create. If a file with the same name as the placeholder file exist and neither of these options
	are used, then the command will throw an error. If {opt skip} is used, then nothing is done in the
	folder where the file with the same name exists and the command proceeds to the next folder.
	If {opt replace} is used then the file with the same name is overwritten with the new placeholder
	file before the command proceeds to the next folder.

{phang}{opt manual} can be used to exactly control in which folders a placeholder file will be created. This
allows that this command is run on a the top folder of the repository, but then only selected folders get a placeholder.

{title:Example}

{pstd}{inp:global github_folder "C:\Users\JohnSmith\Documents\GitHub\ProjectA"}{break}{inp:iegitaddmd , folder({it:"$github_folder"})}

{pstd}In the example above, there is a GitHub repository in the folder ProjectA. This
	repository has a folder structure where some folders are still empty but will later
	be populated with files. In order to have all folders, even the empty ones, synced on all
	collaborators' cloned local copies of the repository, the folders need to contain at least
	one file, which is being created by the command.

{title:Acknowledgements}

{pstd}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Guadalupe Bedoya{break}Luiza Cardoso de Andrade{break}Mrijan Rimal{break}Benjamin Daniels{break}

{title:Author}

{phang}All commands in ietoolkit is developed by DIME Analytics at DECIE, The World Bank's unit for Development Impact Evaluations.

{phang}Main author: Kristoffer Bjarkefur, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iegitaddmd" in the subject line to:{break}
		 dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
