{smcl}
{* 16 Aug 2017}{...}
{hline}
help for {hi:ieaddgittxt}
{hline}

{title:Title}

{phang}{cmdab:iegitaddtxt} {hline 2} Creates a placeholder .txt file in each empty subfolder, which is often needed to sync standardized folder structures to GitHub.

{title:Syntax}

{phang} {cmdab:iegitaddtxt} , {cmd:folder(}{it:file_path}{cmd:)}

{marker opts}{...}
{synoptset 18}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmd:folder(}{it:file_path}{cmd:)}}Specifies the folder path to the repository folder{p_end}

{synoptline}

{marker desc}
{title:Description}

{pstd}GitHub does not sync empty folders. However, it is common in research projects 
	that a folder structure is added to the repository at the beginning of a project. At 
	the time the folder structure is added to the repository, several folders might still 
	be empty and GitHub will not sync them, meaning that they will not be available to the full
	team. {cmd:iegitaddtxt} is a Stata adaptation of {it:Solution B} in {browse "http://bytefreaks.net/gnulinux/bash/how-to-add-automatically-all-empty-folders-in-git-repository" :this post}.

{pstd}{cmd:iegitaddtxt} creates a placeholder .txt file called {it:gitkeep.txt} in all empty subfolders of 
	the folder specified in {cmd:folder()}. The placeholder .txt file may be removed as 
	soon as actual files have been added to the folder.

{marker optslong}
{title:Options}

{phang}{cmd:folder(}{it:file_path}{cmd:)} is the folder path to the repository with empty folders where the file {it:gitkeep.txt} will be created in each empty folder.

{title:Example}

{pstd}{inp:global github_folder "C:\Users\JohnSmith\Documents\GitHub\ProjectA"}{break}{inp:iegitaddtxt , folder({it:"$github_folder"})}

{pstd}In the example above, there is a GitHub repository in the folder ProjectA. This 
	repository has a folder structure where some folders are still empty but will later 
	be populated with files. In order to have all folders, even the empty ones, synced on all 
	collaborators cloned local copies of the repository, the folders need to be filled with 
	something and that is what the example above is doing.

{title:Acknowledgements}

{pstd}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Guadalupe Bedoya{break}Luiza Cardoso De Andrade{break}Mrijan Rimal{break}

{title:Author}

{phang}Kristoffer Bjarkefur, The World Bank, DECIE

{pstd}Please send bug-reports, suggestions and requests for clarifications
		 writing "ietoolkit iegitaddtxt" in the subject line to:{break}
		 kbjarkefur@worldbank.org

{pstd}You can also see the code, make comments to the code, see the version
		 history of the code, and submit additions or edits to the code through
		 the {browse "https://github.com/worldbank/ietoolkit" :github repository} of ietoolkit.
		 
