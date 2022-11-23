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
