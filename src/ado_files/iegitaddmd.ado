*! version 6.2 31JAN2019 DIME Analytics dimeanalytics@worldbank.org

cap program drop   iegitaddmd
	program define iegitaddmd

qui {

		syntax , folder(string) [customfile(string) all skip replace manual]

		/******************************
		*******************************
			Test user input
		*******************************
		******************************/

		******************************
		*	Test input: folder

		*Test that folder exist
		mata : st_numscalar("r(dirExist)", direxists("`folder'"))

		if (`r(dirExist)' == 0) | (length("`folder'")<=10) {

			noi di as error `"{phang}The "`folder'" folder does not exist or you have not entered the full path. For example, full paths on most Windows computers it starts with {it:C:/} and on most Mac computers with {it:/user/}. Important: Specify the whole file path to the repository folder, not just {it:C:/} or {it:/user/} as that would create the placeholder file in every empty folder on your computer!{p_end}"'
			error 693
			exit
		}

		* File paths can have both forward and/or back slash. We'll standardize them so they're easier to handle
		local folderStd	= subinstr("`folder'","\","/",.)

		******************************
		*	Test input: customfile

		*Test that file exist if not using default file
		if "`customfile'" != "" {
			*File option used test if file exists
			capture confirm file "`customfile'"
			if _rc {
				*File does not exist, throw error
				noi di as error `"{phang}File "`customfile'" was not found. Remember that you must enter the full path. For example, on most Windows computers it starts with {it:C:/} and on most Mac computers with {it:/user/}.{p_end}"'
				error 693
				exit
			}

			* Get the name of file (include path to keep )
			* File paths can have both forward and/or back slash. We'll standardize them so they're easier to handle
			local customFileStd	= subinstr("`customfile'","\","/",.)
			*Find the last slash in the file name
			local lastSlash = strpos(strreverse(`"`customFileStd'"'),"/")
			*Use that position to get the file name. Multiply with minus one as we count from the back
			local customFileName = substr(`"`customFileStd'"', (-1 * `lastSlash') ,.)
			*Used for the recursive call of the command when there is a subfolder
			local customFileRecurse `"customfile(`customFileStd')"'

			*Path and name of thile regardless if customfile were used
			local newPlaceholderFile `"`folderStd'`customFileName'"'
		}
		else {
			*Path and name of thile regardless if customfile were not used
			local newPlaceholderFile `"`folderStd'/README.md"'
		}

		******************************
		*	Test input: skip & replace

		*Options skip and replace cannot be used together
		if "`skip'" != "" & "`replace'" != "" {
			noi di as error `"{phang}The options skip and replace may not be used together.{p_end}"'
			error 198
			exit
		}

		/******************************
		*******************************
			Execute command
		*******************************
		******************************/

		******************************
		*	List all files and folders

		*List files, directories and other files
		local flist : dir `"`folderStd'"' files "*"	, respectcase
		local dlist : dir `"`folderStd'"' dirs  "*" , respectcase
		local olist : dir `"`folderStd'"' other "*"	, respectcase

		******************************
		*	Call command recursively on all sub-folders

		*Use the command on each subfolder to this folder (if any)
		foreach dir of local dlist {
			*Recursive call on each subfolder
			noi iegitaddmd , folder(`"`folderStd'/`dir'"') `all' `customFileRecurse' `skip' `replace' `manual'
		}

		******************************
		*	Evaluate if file will be crated in this folder

		*Test if all of those lists are empty, meaning there are
		* no folders or files in this folder
		if `"`flist'`dlist'`olist'"' == "" noi writeDefaultPlaceholder, newfileinclone(`"`newPlaceholderFile'"') customfile(`"`customFileStd'"') `manual'

		*If the folder is not empty, test if option all were used.
		else if ("`all'" == "all") {

				cap confirm file `"`newPlaceholderFile'"'

				* No file with this name exists in this folder, create file without further ado
				if _rc != 0 noi writeDefaultPlaceholder, newfileinclone(`"`newPlaceholderFile'"') customfile(`"`customFileStd'"') `manual'

				* File exist, but no sintructions on how to deal with this has been given, throw error
				else if missing("`skip'") & missing("`replace'")  {
					noi di as error `"{phang}The file  `newPlaceholderFile' already exists. Either remove option {it:all} or use either option {it:skip} or {it:replace}. See help file before using either of these options unless you are already familiar with them.{p_end}"'
					error 602
				}

				* File exist, and instruction is to replace, create files and overwrite as needed
				else if !missing("`replace'") noi writeDefaultPlaceholder, newfileinclone(`"`newPlaceholderFile'"') customfile(`"`customFileStd'"') `manual'

				* File exist, and instruction is to skip, do nothing
				else if !missing("`skip'") {
						*Nothing is done, this if-block is only included for readability and completion
				}

				* The code should nevere get to this point
				else  {
					noi di as error `"{phang}Coding error in if-chain in "All" block.Please report this error to dimeanalytics@worldbank.org or here: https://github.com/worldbank/ietoolkit/issues/new{p_end}"'
					error 602
				}

		}
}

end



	*Write a README.md file when iegitaddmd finds an empty folder
cap program drop writeDefaultPlaceholder
program define   writeDefaultPlaceholder

qui {

	syntax , newfileinclone(string) [customfile(string) manual]

	*Get the current folder name from newfileinclone
	local lastSlash = strpos(strreverse(`"`newfileinclone'"'),"/")
	local folder = substr(`"`newfileinclone'"',1,strlen("`newfileinclone'")-`lastSlash')
	local fileName = substr(`"`newfileinclone'"', (-1 * `lastSlash')+1 ,.)

	*If manual was used, get manual confirmation for each file
	if !missing("`manual'") {
		noi di ""
		global confirmation "" //Reset global

		*Keep aslking for input until the input is either Y, y, N, n or BREAK
		while (upper("${confirmation}") != "Y" & upper("${confirmation}") != "N" & "${confirmation}" != "BREAK") {
		  noi di as txt "{pstd}You are about to create a file [`fileName'] in the folder [`folder']. Do you want to do that? To confirm type {bf:Y} and hit enter, to abort type {bf:N} and hit enter. Type {bf:BREAK} and hit enter to stop the code.{p_end}", _request(confirmation)
		}
		*Copy user input to local
		local createfile = upper("${confirmation}")
		* If user wrote "BREAK" then exit the code
		if ("`createfile'" == "BREAK") error 1
	}

	*If "manual" were used and input was Y or if manual was not used, create the file
	if ("`createfile'" == "Y") | (missing("`manual'")) {

		*Copy custom file if custom file is used
		if !missing(`"`customfile'"') copy "`customfile'" `"`newfileinclone'"', replace
		*Custom file is not used, so cretae defeault file
		else {
			*Create file
			tempname 	newHandle
			cap file close 	`newHandle'
			file open  	`newHandle' using "`newfileinclone'", text write replace
			*Write the content to the file
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
		*Uoutput that the file was created
		noi di as result "{pstd}File [`newfileinclone'] created.{p_end}"
	}
	*Manual was used and input was N, no file were creaetd
	else noi di as result "{pstd}No file created.{p_end}"
}
end
