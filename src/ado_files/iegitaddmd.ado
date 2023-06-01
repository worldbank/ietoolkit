*! version 7.2 04APR2023 DIME Analytics dimeanalytics@worldbank.org

cap program drop   iegitaddmd
	program define iegitaddmd

qui {
	syntax , folder(string) [comparefolder(string) customfile(string) all skip replace AUTOmatic DRYrun skipfolders(string)]


	*Set version
	version 12

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
		noi di as error `"{phang}The folder used in [folder(`folder')] does not exist or you have not entered the full path. For example, full paths on most Windows computers it starts with {it:C:/} and on most Mac computers with {it:/user/}. Important: Specify the whole file path to the repository folder, not just {it:C:/} or {it:/user/} as that would create the placeholder file in every empty folder on your computer!{p_end}"'
		error 693
		exit
	}

	* File paths can have both forward and/or back slash. We'll standardize them so they're easier to handle
	local folderStd			= subinstr(`"`folder'"',"\","/",.)

	******************************
	*	Test input: comparefolder

	if !missing("`comparefolder'") {
		mata : st_numscalar("r(dirExist)", direxists("`comparefolder'"))

		if (`r(dirExist)' == 0) | (length("`comparefolder'")<=10) {

			noi di as error `"{phang}The folder used in [comaparefolder(`comparefolder')] does not exist or you have not entered the full path. For example, full paths on most Windows computers it starts with {it:C:/} and on most Mac computers with {it:/user/}. Important: Specify the whole file path to the repository folder, not just {it:C:/} or {it:/user/} as that would create the placeholder file in every empty folder on your computer!{p_end}"'
			error 693
			exit
		}

		* File paths can have both forward and/or back slash. We'll standardize them so they're easier to handle
		local comparefolderStd	= subinstr(`"`comparefolder'"',"\","/",.)

		*Get the name of the last folder in both folder() and comparefolder()
		local thisLastSlash = strpos(strreverse(`"`folderStd'"'),"/")
		local thisFolder 	= substr(`"`folderStd'"', (-1 * `thisLastSlash')+1 ,.)
		local compLastSlash = strpos(strreverse(`"`comparefolderStd'"'),"/")
		local compFolder 	= substr(`"`comparefolderStd'"', (-1 * `compLastSlash')+1 ,.)

		*The last folder name should always be the same for folder() and
		* comparefolder() otherwise there it is likely that the to paths
		* point to differnet starting points in the two fodler trees that
		* are to be compared.
		if ("`compFolder'" != "`thisFolder'") {
			noi di as error `"{phang}The last folder [`thisFolder'] in [folder(`folder')] is not identical to the last folder [`compFolder'] in [comparefolder(`comparefolder')]. This is an indication that the the two fodler trees to be compared are not two versions of the same folder tree.{p_end}"'
			error 693
			exit
		}
	}

	******************************
	*	Test input: customfile

	*Test that file exist if not using default file
	if !missing("`customfile'") {
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
		local customFileName = substr(`"`customFileStd'"', (-1 * `lastSlash')+1 ,.)
		*Used for the recursive call of the command when there is a subfolder
		local customFileRecurse `"customfile(`customFileStd')"'

		*Path and name of thile regardless if customfile were used
		local newPlaceholderFile `"`customFileName'"'
	}
	else {
		*Path and name of thile regardless if customfile were not used
		local newPlaceholderFile "README.md"
	}

	******************************
	*	Test input: skip & replace

	*Options skip and replace cannot be used at the same time
	if !missing("`skip'") & !missing("`replace'") {
		noi di as error `"{phang}The options skip and replace may not be used at the same time.{p_end}"'
		error 198
		exit
	}

	*Options all, skip and replace cannot be used together with comparefolder()
	if !missing("`comparefolder'") & (!missing("`all'") | !missing("`skip'") | !missing("`replace'")) {
		noi di as error `"{phang}The options all, skip and replace may not be used when option comparefolder() is used.{p_end}"'
		error 198
		exit
	}

	* Test that paths are not used in skip folder. I.e. no slashes are used
	local anyslash = strpos("`skipfolders'","/") + strpos("`skipfolders'","\")
	if `anyslash' {
		noi di as error `"{phang}The options [skipfolders(`skipfolders')] may not include forward or backward slashes, i.e., it may not include paths. Only folder names are accepted.{p_end}"'
		error 198
		exit
	}

	* Test that paths are not used in skip folder. I.e. no slashes are used
	local anywildcard = strpos("`skipfolders'","*") + strpos("`skipfolders'","?")
	if `anywildcard' {
		noi di as error `"{phang}Wild cards like {inp:*} and {inp:?} are not supported in the [skipfolders(`skipfolders')] option. While they are valid characters in folder names in Linux and Mac systems, they are not allowed in Windows system and are therefore not accepted in foldernames in this command.may not include forward or backward slashes, i.e. may not include paths. Only folder names.{p_end}"'
		error 198
		exit
	}

	*Add .git folder to folders to be skipped
	local skipfolders `skipfolders' ".git"

	/******************************
	*******************************
		List Files and folders
	*******************************
	******************************/

	******************************
	*	List all files and folders

	*List files, directories and other files
	local flist : dir `"`folderStd'"' files "*"	, respectcase
	local dlist : dir `"`folderStd'"' dirs  "*" , respectcase
	local olist : dir `"`folderStd'"' other "*"	, respectcase

	/******************************
	*******************************
		Exectute command without compare option
	*******************************
	******************************/

	if missing("`comparefolder'") {

		******************************
		*	Call command recursively on all sub-folders

		*Use the command on each subfolder to this folder (if any)
		foreach dir of local dlist {
			*Test if directory is in
			if `:list dir in skipfolders' {
				noi di as result "{pstd}SKIPPED: Folder [`folder'/`dir'] is skipped. See option skipvars() in {help iegitaddmd}.{p_end}"
			}
			else {
				*Recursive call on each subfolder
				noi iegitaddmd , folder(`"`folderStd'/`dir'"') `all' `customFileRecurse' `skip' `replace' `automatic' `dryrun' skipfolders(`skipfolders')
			}
		}

		******************************
		*	Evaluate if file will be crated in this folder

		*Test if all of those lists are empty, meaning there are
		* no folders or files in this folder
		if `"`flist'`dlist'`olist'"' == "" noi writePlaceholder, folder(`"`folderStd'"') newfilename("`newPlaceholderFile'") customfiletocopy(`"`customFileStd'"') `automatic' `dryrun'

		*If the folder is not empty, test if option all were used.
		else if ("`all'" == "all") {

			*Test if a file with exactly that name is already used
			cap confirm file `"`folderStd'/`newPlaceholderFile'"'

			* No file with this name exists in this folder, create file without further ado
			if _rc != 0 noi writePlaceholder, folder(`"`folderStd'"') newfilename("`newPlaceholderFile'") customfiletocopy(`"`customFileStd'"') `automatic' `dryrun'

			* File exist, but no sintructions on how to deal with this has been given, throw error
			else if missing("`skip'") & missing("`replace'")  {
				noi di as error `"{phang}The file  `newPlaceholderFile' already exists. Either remove option {it:all} or use either option {it:skip} or {it:replace}. See help file before using either of these options unless you are already familiar with them.{p_end}"'
				error 602
			}

			* File exist, and instruction is to replace, create files and overwrite as needed
			else if !missing("`replace'") noi writePlaceholder,  folder(`"`folderStd'"') newfilename("`newPlaceholderFile'") customfiletocopy(`"`customFileStd'"') `automatic' `dryrun'

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
		else {
			* Folder is not empty and option all is not used, so do nothing in this folder
		}
	}
	/******************************
	*******************************
		Exectute command with compare option
	*******************************
	******************************/

	else if !missing("`comparefolder'") {

		*List folders that are in comparefolder() but not in in folder()
		local comp_dlist : dir `"`comparefolderStd'"' dirs  "*" , respectcase
		local only_in_cdlist : list comp_dlist - dlist

		*Loop over all folders only in comparefolder()
		foreach dir of local only_in_cdlist {
			*Find all leaf folders. A leaf folder is a folder with no
			*sub-folder. Think of the folder structure as a tree, and
			*each folder with no sub-folders is an end of a branch where
			*you find leaves.
			noi findLeafFolders, folder(`"`comparefolderStd'/`dir'"')

			*Loop over all leaves and create accordingly
			foreach leaf in `r(leaves)' {
				*Leaf exist in compare folder, create the path to the leaf
				* to be created in the corresponding folder
				local folderleaf = subinstr(`"`leaf'"',`"`comparefolderStd'"', `"`folder'"', 1)

				*Create placeholder file in this new leaf
				noi writePlaceholder, folder(`"`folderleaf'"') newfilename("`newPlaceholderFile'") customfiletocopy(`"`customFileStd'"') `automatic' `dryrun'
			}
		}

		*When using the comparfolder() option, only recurse over files that exist in
		*both folder() and comparefolder(). Folders only in folder() are not relevant
		*when comapring. And folders only in comaprefolder() have already been addressed.
		local in_both_dlists : list comp_dlist & dlist
		foreach dir of local in_both_dlists {
			*Recursive call on each subfolder
			noi iegitaddmd , folder(`"`folderStd'/`dir'"') comparefolder(`"`comparefolder'/`dir'"') `customFileRecurse' `automatic' `dryrun' skipfolders(`skipfolders')
		}
	}
}

end

*Write a README.md file when iegitaddmd finds an empty folder
cap program drop writePlaceholder
program define   writePlaceholder

qui {
	syntax , folder(string) newfilename(string) [customfiletocopy(string) automatic dryrun]

	*Reset locals to be used in this command
	local dryrun_prompt ""
	local createfile ""

	*Create message to show in dryrun mode
	if !missing("`dryrun'") local dryrun_prompt " NO FILE WILL BE CREATED AS OPTION {bf:dryrun} IS USED!"

	*If manual was used, get manual confirmation for each file
	if missing("`automatic'") {
		noi di ""
		global confirmation "" //Reset global

		*Keep aslking for input until the input is either Y, y, N, n or BREAK
		while (upper("${confirmation}") != "Y" & upper("${confirmation}") != "N" & "${confirmation}" != "BREAK") {
		  noi di as txt "{pstd}You are about to create a file [`newfilename'] in the folder [`folder']. If the folder does not exist it will be created. Do you want to do that? To confirm type {bf:Y} and hit enter, to abort type {bf:N} and hit enter. Type {bf:BREAK} and hit enter to stop the code. See option {help iegitaddmd:automatic} to not be prompted before creating files.`dryrun_prompt'{p_end}", _request(confirmation)
		}
		*Copy user input to local
		local createfile = upper("${confirmation}")
		* If user wrote "BREAK" then exit the code
		if ("`createfile'" == "BREAK") error 1
	}
	*Automtic is used, always create the file
	else local createfile "Y"

	*Manual was used and input was N, no file were creaetd
	if 	("`createfile'" == "N") noi di as result "{pstd}No file or folder created.{p_end}"

	*Dryrun, list where file would have been created
	else if !missing("`dryrun'") noi di as result "{pstd}DRY RUN! Without option {bf:dryrun} file [`folder'/`newfilename'] would have been created.{p_end}"

	*If "manual" were used and input was Y or if manual was not used, create the file
	else if ("`createfile'" == "Y") {

		*Recursively create folder if needed
		noi rmkdir, folder(`"`folder'"')

		*Copy custom file if custom file is used
		if !missing(`"`customfiletocopy'"') copy "`customfiletocopy'" `"`folder'/`newfilename'"', replace
		*Custom file is not used, so cretae defeault file
		else {
			*Create file
			tempname 	newHandle
			cap file close 	`newHandle'
			file open  	`newHandle' using "`folder'/`newfilename'", text write replace
			*Write the content to the file
			file write  `newHandle' ///
				"# Placeholder file" _n _n ///
				"This file has been created automatically by the command **iegitaddmd** from the Stata package [**ietoolkit**](https://worldbank.github.io/ietoolkit) to make GitHub sync this folder. GitHub does not sync empty folders or folders that only contain ignored files, but in research projects it is often important to share the full standardized folder structure along with the actual files. This command is intended to be used with **iefolder**, but it can be used in any folder structure intended to be shared on GitHub." _n _n ///
				"In recently started projects, it is typical to create data folders, script folders (do-files, r-files) and output folders, among others. The output folders are initially empty, but the script files might include a file path to them for later use. If an output folder is empty and another collaborator clones the repository, then the output folder expected by the scripts will not be included by GitHub in the cloned repository, and the script will not run properly." _n _n ///
				"## You should replace the content of this placeholder file" _n _n ///
				"The text in this file should be replaced with text that describes the intended use of this folder. This file is written in markdown (.md) format, which is suitable for GitHub syncing (unlike .doc/.docx). If the file is named *README.md*, GitHub automatically displays its contents when someone navigates to the containing folder on GitHub.com using a web browser." _n _n ///
				"If you are new to markup languages (markdown, html etc.) then this [Markdown Tutorial](https://www.markdowntutorial.com/) is a great place to start. If you have some experience with markup languages, then this [Markdown Cheat Sheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf) is a great resource." _n _n ///
				"## Add similar files in other folders" _n _n ///
				"The Stata command **iegitaddmd** does not add anything to folders that already have content unless this is explicitly requested using the option `all`. It is best practice to create a *README.md* file in any folders that have content, for example, in folders which purpose might not obvious to someone using the repository for the first time. Again, if the file is named *README.md*, then the content of the file will be shown in the browser when someone explores the repository on GitHub.com. This is a very good way to document your code and your data work." _n _n ///
				"Another great use of a *README.md* file is to use it as a documentation on how the folder it sits in and its subfolders are organized,  where its content can be found, and where new content is meant to be saved. For example, if you have a folder called `/Baseline/`, then you can give a short description of the activities conducted during the baseline and where data, scripts and outputs related to it can be found." _n _n ///
				"## Removing this file" _n _n ///
				"Our recommendation is to not remove this file, as GitHub may stop syncing the parent folder unless the folder now has other content. We recommend to not even remove this file when content that is committed to this repository is added to this folder and the file can be removed without breaking the GitHub functionality, as it is better practice to replace the content of this file with content describing this specific folder rather than deleting it." _n _n

			*Closing the file
			file close 		`newHandle'
		}
		*Output that the file was created
		noi di as result "{pstd}File [`folder'/`newfilename'] created.{p_end}"
	}
}
end

*Write a README.md file when iegitaddmd finds an empty folder
cap program drop findLeafFolders
program define   findLeafFolders, rclass

qui {
	syntax, folder(string)

	local dlist : dir `"`folder'"' dirs  "*" , respectcase

	if missing(`"`dlist'"') {
		*This is a leaf, pass it back
		return local leaves `""`folder'""'
	}
	else {
		local return_leaves
		foreach dir of local dlist {
			*Recursive call on each subfolder
			findLeafFolders, folder(`"`folder'/`dir'"')
			local return_leaves `"`return_leaves' `r(leaves)'"'
		}
		return local leaves `"`return_leaves'"'
	}
}
end

*Recursively call parent folders in folderpath needed to be created until
* folder found that already exist, then create all subfolders.
cap program drop rmkdir
program define   rmkdir, rclass

qui {
	syntax, folder(string) [folderstocreate(string)]

	*Test if this folder exists
	mata : st_numscalar("r(dirExist)", direxists(`"`folder'"'))

	*Folder does not exist, find parent folder and make recursive call
	if (`r(dirExist)' == 0) {
		*Get the parent folder of folder
		local lastSlash = strpos(strreverse(`"`folder'"'),"/")
		local parentFolder = substr(`"`folder'"',1,strlen("`folder'")-`lastSlash')
		local thisFolder = substr(`"`folder'"', (-1 * `lastSlash')+1 ,.)

		*Make the coll recursivly on the parent folder and add this folder to folderstocreate()
		noi rmkdir , folder(`"`parentFolder'"') folderstocreate(`""`thisFolder'" `folderstocreate'"')
	}
	*Folder exist, create sub-folders to create if any
	else {
		*Create the folders needed
		foreach dir of local folderstocreate {
			mkdir "`folder'/`dir'"
			local folder "`folder'/`dir'"
		}
	}
}
end
