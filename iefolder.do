	

cap program drop 	iefolder
	program define	iefolder	
	
	syntax anything, projectfolder(string) [abb(string)]
	
	***Todo
	*Test that a folder called DataWork already exist (unless new project)
	*Test that old master do file exist
	*allow to specifiy other place for master do file
	
	/***************************************************
	
		Parse input
	
	***************************************************/	
	
	*Parse out the sub-command
	gettoken subcommand item : anything
	
	*Parse out the item type and the item name
	gettoken itemType itemName : item
    
	*Make sure that the item name is only one word
	gettoken itemName rest : itemName
	
	*Clean up the input
	local subcomand = trim("`subcommand'")
	local itemType 	= trim("`itemType'")
	local itemName 	= trim("`itemName'")
	
	di "SubCommand 	`subcommand'"
	di "ItemType 	`itemType'"
	di "ItemName	`itemName'"

	
	if "`rest'" != "" {

		di as error "You have specified to many words. Spaces are not allowed."
		error 198
	}
 

	 /***************************************************
	
		Test input
	
	***************************************************/	
	
	local sub_commands "new rename"
	local itemTypes "project round master monitor "
	
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
	
	di "All tests ok"
	
	/***************************************************
	
		Start making updates to the project folder
	
	***************************************************/

	*Create a temporary textfile
	tempname 	newHandle	
	tempfile	newTextFile
	
	cap file close 	`newHandle'	
		file open  	`newHandle' using "`newTextFile'", text write append	
	
	if "`subcommand'" == "new" {
	
		di "Subcommand: New"
	
		*Creating a new project
		if "`itemType'" == "project" {
			
			di "ItemType: Project"
			iefolder_newProject "`projectfolder'" `newHandle'
		}
		*Creating a new round
		else if "`itemType'" == "round" {
			
			*Use the full item name if abbrevaition was not specified
			if "`abb'" == "" local abb "`itemName'"
			
			di "ItemType: round"
			iefolder_newRound `newHandle' "`itemName'" "`abb'"	
		}
		*Creating a new master data set
		else if "`itemType'" == "master" {
			
			di "ItemType: master"
			iefolder_newMaster	
		}
		*Creating a new monitor
		else if "`itemType'" == "monitor" {
			
			di "ItemType: monitor"
			iefolder_newMonitor		
		}
	}
	

	*Closing the new main master dofile handle
	file close 		`newHandle'
	
	*Copy the new master dofile from the tempfile to the original position
	copy "`newTextFile'"  "$projectfolder/Project_MasterDofile.do" , replace
	
	
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
		
		*Write intro part with description of project, 
		mdofle_p0 `newHandle' project
		
		*Write flolder globals section header and the root folders
		mdofle_p1 `newHandle' "$projectfolder"
		
		*Write globals section header and the root folders
		mdofle_p2 `newHandle'
		
		*Write section that runs sub-master dofiles
		mdofle_p3 `newHandle' project

					
		
end 


cap program drop 	iefolder_newRound
	program define	iefolder_newRound

	args subHandle rndName rndAbb 
	
	*Old file reference
	tempname 	oldHandle
	local 		oldTextFile 	"$projectfolder/Project_MasterDofile.do"

	file open `oldHandle' using `"`oldTextFile'"', read
	file read `oldHandle' line
	
	*Locals needed for the section devider
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
				
					*Test if it is an end of globals section as we are writing a new 
					if "`r(sectionName)'" == "monitor" {
					
					*Write devisor for this section
					writeDevisor 			`subHandle' 1 RoundGlobals rounds `rndName' `rndAbb' 
					
					*Write the globals to the master do file and create the folders
					newRndFolderAndGlobals 	`rndName' `rndAbb' "projectfolder" `subHandle'
					
					*Write an empty line before the end devisor
					file write		`subHandle' "" _n	
					
				}
				else {
				
					*Test that the folder name about to be used is not already in use 
					if "`r(itemName)'" == "`rndName'" {
						di as error "{phang}The new round name `rndName' is already in use. No new folders are creaetd and the master do-files has not been changed.{p_end}"
						error 507
					}
					
					*Test that the folder name about to be used is not already in use 
					if "`r(itemAbb)'" == "`rndAbb'" {
						di as error "{phang}The new round abbreviation `rndAbb' is already in use. No new folders are creaetd and the master do-files has not been changed.{p_end}"
						error 507
					}
					
				}
				
				*Copy the line as is
				file write		`subHandle' `"`line'"' _n
			}
			
			**This is an end of section line. We will add the new content here 
			* before writing the end of section line
			else if `r(ief_end)' == 1 {
				
				*Test if it is an end of globals section as we are writing a new 
				if "`r(partName)'" == "End_RunDofiles" {
					
					*Write devisor for this section
					writeDevisor 			`subHandle' 3 RunDofiles `rndName' `rndAbb' 
					
					*Write the 
					file write  `subHandle' ///
						_col(4)"if (0) { //Change the 0 to 1 to run the `rndName' master dofile" _n ///
						_col(8) `"do ""' _char(36) `"`rndAbb'/`rndName'_master_dofile.do" "' _n ///
						_col(4)"}" ///
						_n
					
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
