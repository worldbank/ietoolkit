	

cap program drop 	iefolder
	program define	iefolder	
	
	syntax anything, projectfolder(string) [abb(string)]
	
	gettoken subcommand item : anything
	
	gettoken itemType itemName : item
	
	
	
	local subcomand = trim("`subcommand'")
	local itemType 	= trim("`itemType'")
	local itemName 	= trim("`itemName'")
	
	di "SubCommand 	`subcommand'"
	di "ItemType 	`itemType'"
	di "ItemName	`itemName'"	
	
	
	local sub_commands "new rename"
	local itemTypes "project round"
		
	if `:list subcommand in sub_commands' == 0 {

		di as error "{phang}You have not used a valid subcommand. See help file for details.{p_end}"
		error 198
	}	
	
	if `:list itemType in itemTypes' == 0 {

		di as error "{phang}You have not used a valid item type. See help file for details.{p_end}"
		error 198
	}	
	


	

	*Create a temporary textfile
	tempname 	newHandle	
	tempfile	newTextFile
	
	cap file close 	`newHandle'	
		file open  	`newHandle' using "`newTextFile'", text write append	
	
	
	*Creating a new project
	if "`itemType'" == "project" {
		
		di "THIS: Project"
		
		mkdir "`projectfolder'/DataWork"
	
		global projectfolder "`projectfolder'/DataWork"
		
		******************************
		*Writing master do file header
		******************************
		
		*Write intro part with description of project
		masterDofilePart0 `newHandle'
	
		*Write devisor starting standardize section
		writeDevisor  `newHandle' 0 Standardize 	
	
		*Write section with ssc install and ieboilstart
		masterDofilePart0a `newHandle'
		
		*Write devisor ending standardize section
		writeDevisor `newHandle' 0 End_Standardize
		
		*Write devisor starting globals section
		writeDevisor  `newHandle' 1 Globals
		
		*Write globals section header and the root folders
		masterDofilePart1 `newHandle' "$projectfolder"
		
		*Write sub devisor starting master and monitor data section section
		writeDevisor `newHandle' 1 Globals 1 MastMon
		
		*Create master data folder and add global to folder in master do file
		createFolderWriteGlobal "Master Data"  "projectfolder"  mastData  `newHandle'
		
		*Create monitor data folder and add global to folder in master do file
		createFolderWriteGlobal "Monitor Data" "projectfolder"  moniData  `newHandle'	
		
		*Write devisor ending globals section
		writeDevisor `newHandle' 1 End_Globals
		
		file close 		`newHandle'
		copy "`newTextFile'"  "$projectfolder/testMasterDofile.do"
		
	}
	
	*Creating a new round
	else if "`itemType'" == "round" {
		
		di "THIS: round"
		
		iefolder_updateMaster `newHandle' "`itemName'" "`abb'"
		
		file close 		`newHandle'
		copy "`newTextFile'"  "$projectfolder/testMasterDofile.do" , replace
		
	}
	else {
		di "THIS: No item"
	}
	
	
end 	


cap program drop 	iefolder_updateMaster
	program define	iefolder_updateMaster

	args subHandle rndName rndAbb 
	
	*Old file reference
	tempname 	oldHandle
	local 		oldTextFile 	"$projectfolder/testMasterDofile.do"

	
	local sectionNum = 0
	local linenum = 0
	
	
	file open `oldHandle' using `"`oldTextFile'"', read
	file read `oldHandle' line
	
	
	while r(eof)==0 {
		
		*Do not interpret macros
		local line : subinstr local line "\$"  "\\$"
		local line : subinstr local line "\`"  "\\`"
		
		parseReadLine `"`line'"'
	
		
		if `r(ief_line)' == 1 | 0 {
			
			*Output the the result of each line that is not a devisor
			di  `"`line'"'
			
			return list 
			
			di ""
			di ""
			di "********************************"
		}

		
		if `r(ief_line)' == 0 {
			
			
			
			*Line that should only be copies
			file write	`subHandle' `"`line'"' _n
		
		}
		else if `r(ief_end)' == 1 {
			
			di "`r(partName)'"
			
			if "`r(partName)'" == "End_Globals" {
				
				local ++sectionNum
			
				writeDevisor 			`subHandle' 1 Globals `sectionNum' `rndName' `rndAbb' 
				newRndFolderAndGlobals 	`rndName' `rndAbb' "projectfolder" `subHandle'
				
			}
			
			file write		`subHandle' `"`line'"' _n	
		
		}
		else {
			
			file write		`subHandle' `"`line'"' _n
			
			if "`r(sectionNum)'" != "*" {
			
				local sectionNum = `r(sectionNum)'
				
			} 
		
		}
	
		file read `oldHandle' line
		
	}
	file close `oldHandle'

	
end
