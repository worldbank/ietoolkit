{smcl}
{* 14 Nov 2017}{...}
{hline}
help for {hi:iegitaddmd}
{hline}

{title:Title}

{phang}{cmdab:iegitaddmd} {hline 2} Creates a placeholder README.md file in subfolders of a GitHub repository folder, which is often needed to sync standardized folder structures.

{title:Syntax}

{phang} {cmdab:iegitaddmd} , {cmd:folder(}{it:file_path}{cmd:)} [all]

{marker opts}{...}
{synoptset 18}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmd:folder(}{it:file_path}{cmd:)}}Specifies the folder path to the repository folder{p_end}
{synopt :{cmd:all}}Creates one {it:README.md} file in every subfolder of {cmd:folder()}, whether empty or not{p_end}
{synoptline}

{marker desc}
{title:Description}

{pstd}GitHub does not sync empty folders, or folder that only contain ignored files.
	However, it is common in research projects 
	that a folder structure is added to the GitHub repository at the beginning of a project. At 
	the time the folder structure is added to the repository, several folders might still 
	be empty and GitHub will not sync them, meaning that they will not be available to the full
	team. {cmd:iegitaddmd} is a Stata adaptation of {it:Solution B} in {browse "http://bytefreaks.net/gnulinux/bash/how-to-add-automatically-all-empty-folders-in-git-repository" :this post}.

{pstd}{cmd:iegitaddmd} creates a placeholder README.md file in all empty subfolders of 
	the folder specified in {cmd:folder()}. The placeholder file may be removed as 
	soon as actual files have been added to the folder. Alternatively, if the option
	{cmd:all} is used, {cmd:iegitaddmd} will create one README.md file in each subfolder
	of {cmd:folder()}, regardless of them being empty or not.

{marker optslong}
{title:Options}

{phang}{cmd:folder(}{it:file_path}{cmd:)} is the folder path to the repository with empty folders where the file {it:README.md} will be created in each empty folder.

{phang}{cmd:all} creates one {it:README.md} in every subfolder of {cmd:folder()}, whether empty or not. This allows the user to edit the {it:README.md} files and 
	add instructions on the purpose and usage of each subfolder. It is also important when a .{it:gitignore} is used, as {cmd:iegitaddmd} will not
	create add files to subfolders that are not empty, but only contain ignored files -- in which case the subfolder will not be synced.
				 

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

{phang}Kristoffer Bjarkefur, The World Bank, DECIE

{pstd}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iegitaddmd" in the subject line to:{break}
		 lcardosodeandrad@worldbank.org

{pstd}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the {browse "https://github.com/worldbank/ietoolkit" :ietoolkit github repository}.
		 
