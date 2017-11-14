*! version 5.3 14NOV2017 Kristoffer Bjarkefur kbjarkefur@worldbank.org

cap program drop   iegitaddmd
	program define iegitaddmd

	qui {

		syntax , folder(string) [all]

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
		if `"`flist'`dlist'`olist'"' == "" | ("`all'" == "all") {

			** If all those lists are empty then we are in an
			*  empty folder and should write README.md
			writeGitKeep `"`folder'"'

		}

		*Use the command on each subfolder to this folder (if any)
		foreach dir of local dlist {

			*Recursive call on each subfolder
			iegitaddmd , folder(`"`folder'//`dir'"') `all'
		}
	}

end

*Write a README.md file iegitaddmd have found an empty folder
cap program drop   writeGitKeep
	program define writeGitKeep

		args folder
		
		* Do not create a README.md file if one already exist. This issue could
		* happen if the option [all] is used on a repository that already has at
		* least one README.md file
		cap confirm file `"`folder'/README.md"'
		if _rc {
		
			*Create file
			tempname 	newHandle
			cap file close 	`newHandle'
				file open  	`newHandle' using "`folder'/README.md", text write replace

			*Add some text to the file
			file write  `newHandle' ///
				"# Placeholder file" _n _n ///
				"This file has been created automatically by the command **iegitaddmd** from Stata package [**ietoolkit**](https://worldbank.github.io/ietoolkit) to make GitHub sync this folder. GitHub does not sync empty folders or folders that only contain ignored files, but in research projects it is often important to share the full standardized folder structure along with the actual files. This command is intended to be used with **iefolder**, but it can be used in any folder structure intended to be shared on GitHub." _n _n ///
				"In recently started projects, it is typical to create data folders, script folders (do-files, r-files) and output folders, among others. The output folders are initially empty, but the script files might include a file path to them for later use. If an output folder is empty and another collaborator clones the repository, then the output folder expected by the scripts will not be included by GitHub in the cloned repository, and the script will not run properly." _n _n ///
				"## You should replace the content of this placeholder file" _n _n ///
				"The text in this file should be replaced with text that describes the intended use of this folder. This file is written in markdown (.md) format, which is suitable for GitHub syncing (unlike .doc/.docx). If the file is named *README.md*, GitHub automatically displays its contents when someone opens the containing folder on GitHub.com using a web browser." _n _n ///
				"If you are new to markup languages (markdown, html etc.) then this [Markdown Tutorial](https://www.markdowntutorial.com/) is a great place to start. If you have some experience with markup languages, then this [Markdown Cheat Sheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf) is great place to start." _n _n ///
				"## Add similar files in other folders" _n _n ///
				"The Stata command **iegitaddmd** does not add anything to folders that already have content unless this is explicitly requested using the option `all`. It is best practice to create a *README.md* file in any folders that have content, for example, in folders whose purpose might not obvious to someone using the repository for the first time. Again, if the file is named *README.md*, then the content of the file will be shown in the browser when someone explores the repository on GitHub.com." _n _n ///
				"Another great use of a *README.md* file is to use it as a documentation on how the folder it sits in and its subfolders are organized,  where its content can be found, and where new content is meant to be saved. For example, if you have a folder called `/Baseline/`, then you can give a short description of the activities conducted during the baseline and where data, scripts and outputs related to it can be found." _n _n ///
				"## Removing this file" _n _n ///
				"Removing this file is not recommended, as GitHub may stop syncing the parent folder unless the folder now has other content. However, even when content is added and the file can be removed without breaking the GitHub functionality, our recommendation is to replace the content with more relevant content rather than deleting it." _n _n

			*Closing the file
			file close 		`newHandle'
			
		}

end
