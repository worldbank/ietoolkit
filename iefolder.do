	

cap program drop 	iefolder
	program define	iefolder	
	
	syntax anything, projectfolder(string) [abb(string)]
	
	
	/***************************************************
	
		Parse input
	
	***************************************************/	
	
	gettoken subcommand item : anything
	
	gettoken itemType itemName : item
	
	local subcomand = trim("`subcommand'")
	local itemType 	= trim("`itemType'")
	local itemName 	= trim("`itemName'")
	
	di "SubCommand 	`subcommand'"
	di "ItemType 	`itemType'"
	di "ItemName	`itemName'"	

	/***************************************************
	
		Test input
	
	***************************************************/	
	
	local sub_commands "new rename"
	local itemTypes "project round master admin monitor "
	
	*Test if subcommand is valid
	if `:list subcommand in sub_commands' == 0 {

		di as error "{phang}You have not used a valid subcommand. See help file for details.{p_end}"
		error 198
	}	
	
	*Test if item type is valid
	if `:list itemType in itemTypes' == 0 {

		di as error "{phang}You have not used a valid item type. See help file for details.{p_end}"
		error 198
	} 
	
	*Test that item name is used when item type is anything but project
	else if ("`itemType'" != "project" & "`itemName'" == "" ) {
		
		di as error "{phang}You must specify a name of the `itemType'. See help file for details.{p_end}"
		error 198
	
	}
	
	
	/***************************************************
	
		Start making updates to the project folder
	
	***************************************************/
	

	*Create a temporary textfile
	tempname 	newHandle	
	tempfile	newTextFile
	
	cap file close 	`newHandle'	
		file open  	`newHandle' using "`newTextFile'", text write append	
	
	if "`sub_commands'" == "new" {
		*Creating a new project
		if "`itemType'" == "project" {
			
			di "THIS: Project"
			iefolder_newProject "`projectfolder'" `newHandle'
		}
		*Creating a new round
		else if "`itemType'" == "round" {
			
			*Use the full item name if abbrevaition was not specified
			if "`abb'" == "" local abb "`itemName'"
			
			di "THIS: round"
			iefolder_newRound `newHandle' "`itemName'" "`abb'"	
		}
		*Creating a new master data set
		else if "`itemType'" == "master" {
			
			di "THIS: master"
			iefolder_newMaster	
		}
		*Creating a new admin
		else if "`itemType'" == "admin" {
			
			di "THIS: admin"
			iefolder_newAdmin 	
		}
		*Creating a new monitor
		else if "`itemType'" == "monitor" {
			
			di "THIS: monitor"
			iefolder_newMonitor		
		}
	}
	

	*Closing the new main master dofile handle
	file close 		`newHandle'
	
	*Copy the new master dofile from the tempfile to the original position
	copy "`newTextFile'"  "$projectfolder/testMasterDofile.do" , replace
	
	
end 	

	/***************************************************
	
		Here are all functions for combination of 
		subcommand and item type
	
	***************************************************/

cap program drop 	iefolder_newProject
	program define	iefolder_newProject
		
		args projectfolder newHandle
		
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
		
	
end 


cap program drop 	iefolder_newRound
	program define	iefolder_newRound

	args subHandle rndName rndAbb 
	
	*Old file reference
	tempname 	oldHandle
	local 		oldTextFile 	"$projectfolder/testMasterDofile.do"

	file open `oldHandle' using `"`oldTextFile'"', read
	file read `oldHandle' line
	
	*Locals needed for the section devider
	local sectionNum 	= 0 //Keeps track of the section number
	local partNum 		= 0 //Keeps track of the part number
	
	
	while r(eof)==0 {
		
		di `"`line'"'
		
		*Do not interpret macros
		local line : subinstr local line "\$"  "\\$"
		local line : subinstr local line "\`"  "\\`"
		
		parseReadLine `"`line'"'
	
		if `r(ief_line)' == 0 {
			
			*This is a regular line of code. It should be copied as-is. No action needed. 
			file write	`subHandle' `"`line'"' _n
		
		}
		else if `r(ief_line)' == 1 {
			
			**This is a line of code with a devisor written by 
			* iefodler. New additions to a section are always added right before an end of section line. 
			
			return list
			
			**This is NOT an end of section line. Nothing will be written here 
			* but we test that there is no confict with previous names
			if `r(ief_end)' == 0 {
				
				
			
				*Test that the folder name about to be used is not already in use 
				if "`r(sectionName)'" == "`rndName'" {
					di as error "{phang}The new round name `rndName' is already in use. No new folders are creaetd and the master do-files has not been changed.{p_end}"
					error 507
				}
				
				*Test that the folder name about to be used is not already in use 
				if "`r(sectionAbb)'" == "`rndAbb'" {
					di as error "{phang}The new round abbreviation `rndAbb' is already in use. No new folders are creaetd and the master do-files has not been changed.{p_end}"
					error 507
				}
				
				*Copy the line as is
				file write		`subHandle' `"`line'"' _n
				
				*Update the section counter
				if "`r(sectionNum)'" != "*" {
					local sectionNum = `r(sectionNum)'
				} 
			}
			
			**This is an end of section line. We will add the new content here 
			* before writing the end of section line
			else if `r(ief_end)' == 1 {
				
				*Test if it is an end of globals section as we are writing a new 
				if "`r(partName)'" == "End_Globals" {
					
					*Increment the section number for the new section
					local ++sectionNum
					
					*Write devisor for this section
					writeDevisor 			`subHandle' 1 Globals `sectionNum' `rndName' `rndAbb' 
					
					*Write the globals to the master do file and create the folders
					newRndFolderAndGlobals 	`rndName' `rndAbb' "projectfolder" `subHandle'
					
					*Write an empty line before the end devisor
					file write		`subHandle' "" _n	
					
				}
				
				*Write the end of section line
				file write		`subHandle' `"`line'"' _n	
			}
		
		}
		
		*Read next file and repeat the while loop
		file read `oldHandle' line
		
		di "new line read"
		
	}
	
	*Close the old file. 
	file close `oldHandle'

	
end
