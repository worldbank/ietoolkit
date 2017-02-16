	

cap program drop 	iefolder
	program define	iefolder	
	
	syntax anything, projectfolder(string) [abb(string)]
	
	gettoken subcommand item : anything
	
	local subcomand = trim("`subcommand'")
	local item 		= trim("`item'")
	
	di "Sub `subcommand'"
	di "Item `item'"
	
	local sub_commands "new rename"
	local items "project round"
		
	if `:list subcommand in sub_commands' == 0 {

		di as error "{phang}You have not used a valid subcommand. See help file for details.{p_end}"
		error 198
	}	
	
	if `:list item in items' == 0 {

		di as error "{phang}You have not used a valid item. See help file for details.{p_end}"
		error 198
	}	
	


	

	*Create a temporary textfile
	tempname 	newHandle	oldHandle
	tempfile	newTextFile
	
	
	*Creating a new project
	if "`item'" == "project" {
		
		di "THIS: Project"
		
		mkdir "`projectfolder'/DataWork"
	
		global projectfolder "`projectfolder'/DataWork"


		
		*Write the title rows defined above	
		cap file close 	`newHandle'
		file open  		`newHandle' using "`newTextFile'", text write replace
		file write  	`newHandle' "*Intro to text" _n 			
		file close 		`newHandle'
		
		masterDofilePart0 `newTextFile' `newHandle'	
		
		writeDevisor `newTextFile' `newHandle' 0 End_Standardize
		
		masterDofilePart1 `newTextFile' `newHandle'	"$projectfolder"
		
		writeDevisor `newTextFile' `newHandle' 1 Globals 1 MastMon

		createFolderWriteGlobal "Master Data"  "projectfolder"  mastData `newTextFile' `newHandle'
		createFolderWriteGlobal "Monitor Data" "projectfolder"  moniData `newTextFile' `newHandle'	
		
		writeDevisor `newTextFile' `newHandle' 1 End_Globals
			
	}
	
	*Creating a new round
	else if "`item'" == "round" {
		
		di "THIS: round"
		
		*Write the title rows defined above	
		cap file close 	`newHandle'
		file open  		`newHandle' using "`newTextFile'", text write replace
		file write  	`newHandle' "*Intro to text" _n 			
		file close 		`newHandle'
	
		local roundCount 1

		foreach rndName of local surveyRounds {
			
			local rndAbb 	`rndName'
			
			if "`rndAbb'" == "baseline" local rndAbb BL
			if "`rndAbb'" == "endline"  local rndAbb EL
			
			local ++roundCount
			
			writeDevisor `newTextFile' `newHandle' 1 Globals `roundCount' `rndName' `rndAbb' 
			
			newRndFolderAndGlobals `rndName' `rndAbb' projectfolder `newTextFile' `newHandle'
		
		}
	
	
	}
	else {
		di "THIS: No item"
	}
	
	
	copy "`newTextFile'"  "$projectfolder/testMasterDofile.do"
	
	doedit "$projectfolder\testMasterDofile.do" 
end 	

