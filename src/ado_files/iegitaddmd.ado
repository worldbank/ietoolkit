
cap program drop   iegitaddmd
	program define iegitaddmd
	
	qui {
		
		syntax , folder(string)
		
		*Test that folder exist
		mata : st_numscalar("r(dirExist)", direxists("`folder'"))
		
		if `r(dirExist)' == 0 {
		
			noi di as error `"{phang}The "`folder'" folder does not exist. You must enter the full path. For example, on most Windows computers it starts with {it:C:} and on most Mac computers with {it:/user/}. Important: Specify the whole file path to the repository folder, not just {it:C:} or {it:/user/} as that would creaet the .txt file in every empty folder on your computer.{p_end}"' 
			error 693
			exit
		}
		
		*List files, directories and other files
		local flist : dir `"`folder'"' files "*" 
		local dlist : dir `"`folder'"' dirs "*" 
		local olist : dir `"`folder'"' other "*"
	
		*Test if all of those lists are empty.
		if `"`flist'`dlist'`olist'"' == "" {
			
			** If all those lists are empty then we are in an 
			*  empty folder and should write README.md
			writeGitKeep `"`folder'"'
			
		}
		
		*Use the command on each subfolder to this folder (if any)
		foreach dir of local dlist {
			
			*Recursive call on each subfolder
			iegitaddmd , folder(`"`folder'//`dir'"')
		}	
	}
	
end 
	
*Write a README.md file iegitaddmd have found an empty folder	
cap program drop   writeGitKeep
	program define writeGitKeep
	
		args folder
		
		*Create file
		tempname 	newHandle
		cap file close 	`newHandle'	
			file open  	`newHandle' using "`folder'/README.md", text write replace
		
		*Add some text to the file
		file write  `newHandle' ///
			"# Placeholder file" _n _n ///
			///
			"This file has been created automatically by the command **iegitaddmd** in the package **ietoolkit** (see https://github.com/worldbank/ietoolkit) to make GitHub sync this folder. GitHub does not sync empty folders, but standardized folder structures are in reserach projects often important to share together with the actual files." _n _n ///
			///
			"For example, if we create a folder for a project that we have just started, we often create data folders, script (do-files, r-files) folders and output folders. The output folders are initially empty but the script files might include a file path to them for later use. If an output folder is empty and another collaborator would clone the repository then that output folder expected by the scripts are not included by GitHub in the cloned repository and the script will not run properly." _n _n ///
			///
			"This command is intended to be used with **iefolder** but it can be used in any folder structure with temporarily empty folders intended to be shared on GitHub." _n _n ///
			///
			"## We recommend you to replace the content of this file" _n _n ///
			///
			"The practice that we recommend is that the text in this file is replaced with a text that describes what this empty folder is intended to be used for. This file is written in markdown (.md) format, which is suitable for GitHub. If a markdown file is called *README.md* then GitHub displays this file when someone opens the containing folder on GitHub.com using a web browser." _n _n ///
			///
			"If you are new to markup languages (markdown, html etc.) then this [Markdown Tutorial](https://www.markdowntutorial.com/) is a great place to start. If you have some experience with markup languages, then this [Markdown Cheat Sheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf) is great place to start." _n _n ///
			///
			"## Add similar files in other folders" _n _n ///
			///
			"The Stata command **iegitaddmd** does not add anything to folders that already have content, but it is a great practice to create a similar file in a few folders that has content. For example in folders which purpose might not obvious to someone using the repository for the first time. If the file is named *README.md* then the content of the file will be shown in the browser when someone explores the repository on GitHub.com." _n _n ///
			///
			"Another great use of a *README.md* file is to use it as an documentation on how the folder it sits in and its subfolders are organized, and where its content can be found and where new content is meant to be saved. For example, if you have a folder called *Baseline* then you can give a short description of the activities conducted during the baseline and where data, scripts and outputs related to it can be found." _n _n ///
			///
			"## Removing this file" _n _n ///
			///
			"It is not recommended to remove this file as GitHub will then not sync the folder is sits in anymore, unless the folder now has content. But even when content is added and the file can be removed without breaking the GitHub functionality, our recommendation is to replace the content with more relevant content rather than deleting it." _n _n
		
		*Closing the file
		file close 		`newHandle'
	
end 

