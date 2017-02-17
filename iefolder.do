	

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
		
		*Write intro part and standardize section header
		masterDofilePart0 `newHandle'
		
		*Write devisor starting standardize section
		writeDevisor  `newHandle' 0 Standardize 
		
		*Write section with ssc install and ieboilstart
		masterDofilePart0a `newHandle'
		
		*Write devisor ending standardize section
		writeDevisor `newHandle' 0 End_Standardize
		
		*Write globals section header
		masterDofilePart1 `newHandle'
		
		*Write devisor starting globals section
		writeDevisor  `newHandle' 1 Globals
		
		*Write section with root folder
		masterDofilePart1a `newHandle'	"$projectfolder"
		
		*Write sub devisor starting master and monitor data section section
		writeDevisor `newHandle' 1 Globals 1 MastMon
		
		*Create master data folder and add global to folder in master do file
		createFolderWriteGlobal "Master Data"  "projectfolder"  mastData  `newHandle'
		
		*Create monitor data folder and add global to folder in master do file
		createFolderWriteGlobal "Monitor Data" "projectfolder"  moniData  `newHandle'	
		
		*Write devisor ending globals section
		writeDevisor `newHandle' 1 End_Globals
		
	}
	
	*Creating a new round
	else if "`itemType'" == "round" {
		
		di "THIS: round"
		
		iefolder_updateMaster `newHandle' baseline BL
		
	}
	else {
		di "THIS: No item"
	}
	
	
	file close 		`newHandle'
	copy "`newTextFile'"  "$projectfolder/testMasterDofile.do"
	
	
end 	


cap program drop 	iefolder_updateMaster
	program define	iefolder_updateMaster

	args subHandle rndName rndAbb 
	
	*Old file reference
	tempname 	newHandle oldHandle
	
	local 		oldTextFile 	"$projectfolder/testMasterDofile.do"
	tempfile	newTextFile
	
	local sectionNum = 0
	
	
	local linenum = 0
	file open `oldHandle' using `"`oldTextFile'"', read
	file read `oldHandle' line
	
	
	while r(eof)==0 {
		
		*Do not interpret macros
		local line : subinstr local line "\$"  "\\$"
		local line : subinstr local line "\`"  "\\`"
		
		parseReadLine `"`line'"'
		
		if `r(ief_line)' {
			
			*Output the the result of each line that is not a devisor
			di  `"`line'"'
			
			return list 
			
			di ""
			di ""
			di "********************************"
		}
		
		
		
		if `r(ief_line)' == 0 {
			
			*Line that should only be copies
			file write		`subHandle' `"`line' new 1"' _n
		
		}
		else if `r(ief_end)' == 1 {
				

			di "`r(partName)'"
			
			if "`r(partName)'" == "End_Globals" {
				
				
			
				local ++sectionNum
			
				writeDevisor 			`newHandle' 1 Globals `sectionNum' `rndName' `rndAbb' 
				
				
				di "yes man 1"
				newRndFolderAndGlobals 	`rndName' `rndAbb' "projectfolder" `newTextFile' `newHandle'
				
				di "yes man 2"
			}
			
			di "no man 2"
			
			file write		`newHandle' `"`line'  line 2"' _n
			
			file close 		`newHandle'	
		
		}
		else {
			
			file write		`newHandle' `"`line' new 3"' _n
			
			local sectionNum = `r(sectionNum)'
		
		}
		
		
		
		file read `oldHandle' line
		
		
	}
	file close `oldHandle'
	
	
	copy "`newTextFile'"  "$projectfolder/testMasterDofile2.do" , replace
	
end
