*! version 6.2 31JAN2019 DIME Analytics dimeanalytics@worldbank.org

cap program drop   iegitaddmd
	program define iegitaddmd

	qui {

		syntax , folder(string) [all file(string) skip replace]

		/******************************

			Test user input

		******************************/

		*Test that folder exist
		mata : st_numscalar("r(dirExist)", direxists("`folder'"))

		if (`r(dirExist)' == 0) | (length("`folder'")<=10) {

			noi di as error `"{phang}The "`folder'" folder does not exist or is too short. You must enter the full path. For example, on most Windows computers it starts with {it:C:/} and on most Mac computers with {it:/user/}. Important: Specify the whole file path to the repository folder, not just {it:C:/} or {it:/user/} as that would create the placeholder file in every empty folder on your computer!{p_end}"'
			error 693
			exit
		}

		* File paths can have both forward and/or back slash. We'll standardize them so they're easier to handle
		local folderStd	= subinstr("`folder'","\","/",.)


		*Test that file exist if not using default file
		if "`file'" != "" {
			*File option used test if file exists
			capture confirm file "`file'"
			if _rc {
				*File does not exist, throw error
				noi di as error `"{phang}File "`file'" was not found. Remember that you must enter the full path. For example, on most Windows computers it starts with {it:C:/} and on most Mac computers with {it:/user/}.{p_end}"'
				error 693
				exit
			}

			* Get the name of file (include path to keep )

			* File paths can have both forward and/or back slash. We'll standardize them so they're easier to handle
			local fileStd	= subinstr("`file'","\","/",.)

			*File path can have both forward and back slash
			local slash = strpos(strreverse("`fileStd'"),"/")

			*Use that position to get the file name. Multiply with minus one as we count from the back
			local userfilename = substr("`fileStd'", (-1 * `slash') ,.)

			*Used for the recursive call of the command when there is a subfolder
			local fileRecurse `"file(`fileStd')"'
		}

		*Options skip and replace cannot be used together
		if "`skip'" != "" & "`replace'" != "" {

			noi di as error `"{phang}The options skip and replace may not be used together.{p_end}"'
			error 198
			exit
		}

		/******************************

			Execute command

		******************************/

		*List files, directories and other files
		local flist : dir `"`folderStd'"' files "*"	, respectcase
		local dlist : dir `"`folderStd'"' dirs "*" 	, respectcase
		local olist : dir `"`folderStd'"' other "*"	, respectcase

		*Test if all of those lists are empty.
		if `"`flist'`dlist'`olist'"' == "" | ("`all'" == "all") {

			** If all those lists are empty then we are in an
			*  empty folder or [all] is specified and we should write the placeholder file

			if "`file'" == "" {

				*Write default README.md file
				writeGitKeep `"`folderStd'"' `skip' `replace'
			}
			else {

				*Use user provided file. First test if it already exists

				cap confirm file `"`folderStd'`userfilename'"'
				if _rc == 0 & "`skip'" == "" & "`replace'" == "" {

					*File exist and neither skip or replace is used
					local fileNameNoSlash = substr("`userfilename'",2,.)

					noi di as error `"{phang}A file with name `fileNameNoSlash' already exist in `folder'. Either remove option {it:all} or use either option {it:skip} or {it:replace}. See help file before using either of these options.{p_end}"'
					error 602
					exit
				}
				else if _rc == 0 & "`skip'" == "skip" {

					*File exists but option skip is used so do nothing, move to next folder

				}
				else if _rc == 0 & "`fileStd'" == `"`folderStd'`userfilename'"' {

					*If the custom template is inside the specified folder, we won't replace it

				}
				else{

					**Either file does not exist or replace is used, so write
					* placeholder file provided by user in folder location
					copy "`fileStd'" `"`folderStd'`userfilename'"', replace

				}
			}
		}

		*Use the command on each subfolder to this folder (if any)
		foreach dir of local dlist {

			*Recursive call on each subfolder
			iegitaddmd , folder(`"`folderStd'/`dir'"') `all' `fileRecurse' `skip' `replace'

		}
	}

end

*Write a README.md file when iegitaddmd finds an empty folder
cap program drop   writeGitKeep
	program define writeGitKeep

		args folder skipreplace

		* Test if README.md already exists, and if it does test if [skip] or [replace] is specified
		cap confirm file `"`folder'/README.md"'
		if _rc == 0 & "`skipreplace'" == "" {

			noi di as error `"{phang}A file with name README.md already exist in `folder'. Either remove option {it:all} or use either option {it:skip} or {it:replace}. See help file before using either of these options{p_end}"'
			error 602
			exit

		}
		else if _rc == 0 & "`skipreplace'" == "skip" {

			*Do nothing as option [skip] is specified, move to next folder

		}
		else {

			*If file does not exist or {replace} is specified, then write the file in this location

			*Create file
			tempname 	newHandle
			cap file close 	`newHandle'
				file open  	`newHandle' using "`folder'/README.md", text write replace

			*Add some text to the file
			file write  `newHandle' ///
				"# Placeholder file" _n _n ///
				"This file has been created automatically by the command **iegitaddmd** from the Stata package [**ietoolkit**](https://worldbank.github.io/ietoolkit) to make GitHub sync this folder. GitHub does not sync empty folders or folders that only contain ignored files, but in research projects it is often important to share the full standardized folder structure along with the actual files. This command is intended to be used with **iefolder**, but it can be used in any folder structure intended to be shared on GitHub." _n _n ///
				"In recently started projects, it is typical to create data folders, script folders (do-files, r-files) and output folders, among others. The output folders are initially empty, but the script files might include a file path to them for later use. If an output folder is empty and another collaborator clones the repository, then the output folder expected by the scripts will not be included by GitHub in the cloned repository, and the script will not run properly." _n _n ///
				"## You should replace the content of this placeholder file" _n _n ///
				"The text in this file should be replaced with text that describes the intended use of this folder. This file is written in markdown (.md) format, which is suitable for GitHub syncing (unlike .doc/.docx). If the file is named *README.md*, GitHub automatically displays its contents when someone opens the containing folder on GitHub.com using a web browser." _n _n ///
				"If you are new to markup languages (markdown, html etc.) then this [Markdown Tutorial](https://www.markdowntutorial.com/) is a great place to start. If you have some experience with markup languages, then this [Markdown Cheat Sheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf) is a great place to start." _n _n ///
				"## Add similar files in other folders" _n _n ///
				"The Stata command **iegitaddmd** does not add anything to folders that already have content unless this is explicitly requested using the option `all`. It is best practice to create a *README.md* file in any folders that have content, for example, in folders whose purpose might not obvious to someone using the repository for the first time. Again, if the file is named *README.md*, then the content of the file will be shown in the browser when someone explores the repository on GitHub.com." _n _n ///
				"Another great use of a *README.md* file is to use it as a documentation on how the folder it sits in and its subfolders are organized,  where its content can be found, and where new content is meant to be saved. For example, if you have a folder called `/Baseline/`, then you can give a short description of the activities conducted during the baseline and where data, scripts and outputs related to it can be found." _n _n ///
				"## Removing this file" _n _n ///
				"Removing this file is not recommended, as GitHub may stop syncing the parent folder unless the folder now has other content. However, even when content is added and the file can be removed without breaking the GitHub functionality, our recommendation is to replace the content with more relevant content rather than deleting it." _n _n

			*Closing the file
			file close 		`newHandle'

		}

end
