	

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
	file open  		`newHandle' using "`newTextFile'", text write replace
	file write  	`newHandle' "*Intro to text" _n 	
	file close 		`newHandle'
	
	cap file close 	`newHandle'	
	file open  		`newHandle' using "`newTextFile'", text write append	
	
	
	*Creating a new project
	if "`itemType'" == "project" {
		
		di "THIS: Project"
		
		mkdir "`projectfolder'/DataWork"
	
		global projectfolder "`projectfolder'/DataWork"

		di 1
		
		*Write the title rows defined above	
		
		masterDofilePart0 `newHandle'
		
		writeDevisor  `newHandle' 0 Standardize 
		
		masterDofilePart0a `newHandle'
		
		writeDevisor `newHandle' 0 End_Standardize
		


		
		

		
		masterDofilePart1 `newHandle'
		
		writeDevisor  `newHandle' 1 Globals
		
		

		masterDofilePart1a `newHandle'	"$projectfolder"
		
		writeDevisor `newHandle' 1 Globals 1 MastMon
		

		
		createFolderWriteGlobal "Master Data"  "projectfolder"  mastData  `newHandle'
		createFolderWriteGlobal "Monitor Data" "projectfolder"  moniData  `newHandle'	
		
		writeDevisor `newHandle' 1 End_Globals

		file close 		`newHandle'
		copy "`newTextFile'"  "$projectfolder/testMasterDofile.do", replace			
		di "Yes Man"
		asdf
		
	}
	
	*Creating a new round
	else if "`itemType'" == "round" {
		
		di "THIS: round"
		
	
		local roundCount 5
			
		local rndAbb 	`rndName'
		
		*local ++roundCount
		
		iefolder_updateMaster 5 baseline BL
		
		
	
	
	}
	else {
		di "THIS: No item"
	}
	
	file close 		`newHandle'
	
	copy "`newTextFile'"  "$projectfolder/testMasterDofile.do"
	
	
end 	


cap program drop 	iefolder_updateMaster
	program define	iefolder_updateMaster

	args roundCount rndName rndAbb 
	
	*Old file reference
	tempname 	newHandle oldHandle
	
	local 		oldTextFile 	"$projectfolder/testMasterDofile.do"
	tempfile	newTextFile
	
	file open  		`newHandle' using "`newTextFile'", text write replace
	file close 		`newHandle'	
	
	
	
	local linenum = 0
	file open `oldHandle' using `"`oldTextFile'"', read
	file read `oldHandle' line
	
	
	while r(eof)==0 {
		
		*Do not interpret macros
		local line : subinstr local line "\$"  "\\$"
		local line : subinstr local line "\`"  "\\`"
		
		parseReadLine `"`line'"'
		
		if `r(ief_line)' {
			di  `"`line'"'
			
			return list 
			
			di ""
			di ""
			di "********************************"
		}
		
		
		
		if `r(ief_line)' == 0 {
			
			file open  		`newHandle' using "`newTextFile'", text write append
			file write		`newHandle' `"`line' new 1"' _n
			file close 		`newHandle'	
		
		}
		else if `r(ief_end)' == 1 {
				
			file open  		`newHandle' using "`newTextFile'", text write append
			
			di "`r(partName)'"
			
			if "`r(partName)'" == "End_Globals" {
				
				di "hit"
			
				writeDevisor 			`newTextFile' `newHandle' 1 Globals `roundCount' `rndName' `rndAbb' 
				
				
				di "yes man 1"
				newRndFolderAndGlobals 	`rndName' `rndAbb' "projectfolder" `newTextFile' `newHandle'
				
				di "yes man 2"
			}
			
			di "no man 2"
			
			file write		`newHandle' `"`line'  line 2"' _n
			
			file close 		`newHandle'	
		
		}
		else {
			
			file open  		`newHandle' using "`newTextFile'", text write append
			file write		`newHandle' `"`line' new 3"' _n
			file close 		`newHandle'	
		
		}
		
		
		
		file read `oldHandle' line
		
		
	}
	file close `oldHandle'
	
	
	copy "`newTextFile'"  "$projectfolder/testMasterDofile2.do" , replace
	
end
