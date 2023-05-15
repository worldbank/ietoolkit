* This file can delete all your folders on your computer if used incorrectly.

cap program drop ie_recurse_rmdir
	program define ie_recurse_rmdir

qui {
	syntax , folder(string) [DRYrun okifnotexist]

	/*
		folder - full path to folder which should be deleted with all its content
		dryrun - just list and do not delete all files that would have been deleted without this option
		okifnotexist - it is ok that the top folder does not exist, do not throw erroe

	*/

	*Test that folder exist
	mata : st_numscalar("r(dirExist)", direxists("`folder'"))

	if (`r(dirExist)' == 0) {
		if missing("`okifnotexist'") {
			noi di as error `"{phang}The folder used in [folder(`folder')] does not exist.{p_end}"'
			error 693
			exit
		}
		else {
			*Folder is missin and that is ok, just output a confirmation that it does not exists
			noi di as result `"{phang}The folder used in [folder(`folder')] is already deleted.{p_end}"'
		}
	}
	else {

		 if (length("`folder'")<=10) {
			noi di as error `"{phang}The folder used in [folder(`folder')] does not exist or you have not entered the full path.{p_end}"'
			error 693
			exit
		}

		* File paths can have both forward and/or back slash. We'll standardize them so they're easier to handle
		local folderStd			= subinstr(`"`folder'"',"\","/",.)

		*List files, directories and other files
		local flist : dir `"`folderStd'"' files "*"	, respectcase
		local dlist : dir `"`folderStd'"' dirs  "*" , respectcase
		local olist : dir `"`folderStd'"' other "*"	, respectcase

		*Use the command on each subfolder to this folder (if any)
		foreach dir of local dlist {
			*Recursive call on each subfolder
			noi ie_recurse_rmdir , folder(`"`folderStd'/`dir'"') `automatic' `dryrun'
		}

		*REmove all files
		local files `"`flist' `olist'"'
		foreach file of local files {
			*If dryrun then list otherwise delete
			if !missing("`dryrun'") noi di as result "{pstd}DRY RUN! Without option {bf:dryrun} file [`folderStd'/`file'] would have been deleted.{p_end}"
			else rm `"`folderStd'/`file'"'
		}

		* Remove this folder as it is now empty
		if missing("`dryrun'") {
			rmdir `"`folderStd'"'
			noi di as result "{pstd}Folder [`folderStd'] and all its content were deleted.{p_end}"
		}
	}
}
end




* This create folders recursively. If path "c:/folder1/folder2/folder3" is
* passed then the command creates folder1 if it does not exists, and then
* folder2 if it does not exists and then folder3 if it does not exist

cap program drop ie_recurse_mkdir
	program define ie_recurse_mkdir

qui {
	syntax, folder(string) [dryrun]

	/*
		folder - full path to folder which should be created
		dryrun - just list and do not create the folder that would have been created without this option
	*/

	*Standardiize to forward slashes
	local folder = subinstr(`"`folder'"',"\","/",.)

	*Test if this folder exists
	mata : st_numscalar("r(dirExist)", direxists(`"`folder'"'))

	*Folder does not exist, find parent folder and make recursive call
	if (`r(dirExist)' == 0) {

		*Get the parent folder of folder
		local lastSlash = strpos(strreverse(`"`folder'"'),"/")
		local parentFolder = substr(`"`folder'"',1,strlen("`folder'")-`lastSlash')
		local thisFolder = substr(`"`folder'"', (-1 * `lastSlash')+1 ,.)

		*Recursively make sure that the partent folders and its parent folders exists
		noi ie_recurse_mkdir , folder(`"`parentFolder'"') `dryrun'

		*Create this folder as the parent folder is ceratain to exist now
		if missing("`dryrun'") {
			noi mkdir "`folder'"
			noi di as result "{pstd}Folder created: [`folder']{p_end}"
		}
		else {
			noi di as result "{pstd}DRY RUN! Without option {bf:dryrun} folder [`folder'] would have been created.{p_end}"
		}
	}
	else {
	  if missing("`dryrun'") noi di as result "{pstd}Folder existed: [`folder']{p_end}"
		else noi di as result "{pstd}DRY RUN! Folder [`folder'] already existed.{p_end}"
	}
}
end
