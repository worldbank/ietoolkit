	

cap program drop 	iefolder
	program define	iefolder	

qui {	
	
	syntax anything, PROJectfolder(string) [ABBreviation(string)]
	
	***Todo
	*Test that old master do file exist

	
	*Create an empty line before error message or output
	noi di ""
	
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
	
	*noi di "SubCommand 	`subcommand'"
	*noi di "ItemType 	`itemType'"
	*noi di "ItemName	`itemName'"

	
	if "`rest'" != "" {

		noi di as error "{pstd}You have specified to many words in: [{it:iefolder `subcommand' `itemType' `itemName'`rest'}]. Spaces are not allowed in the {it:itemname}. Use underscores or camel case.{p_end}"
		error 198
	}
 

	 /***************************************************
	
		Test input
	
	***************************************************/	
	
	local sub_commands "new"
	local itemTypes "project round master"
	
	*Test if subcommand is valid
	if `:list subcommand in sub_commands' == 0 {

		noi di as error "{phang}You have not used a valid subcommand. See help file for details.{p_end}"
		error 198
	}	
	
	*Test if item type is valid
	if `:list itemType in itemTypes' == 0 {

		noi di as error "{phang}You have not used a valid item type. See help file for details.{p_end}"
		error 198
	} 
	
	*Test that item name is used when item type is anything but project
	else if ("`itemType'" != "project" & "`itemName'" == "" ) {
		
		noi di as error "{phang}You must specify a name of the `itemType'. See help file for details.{p_end}"
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
	
	
	*Create a global pointing to the main data folder
	global dataWorkFolder 	"`projectfolder'/DataWork"
	global encryptFolder 	"$dataWorkFolder/EncryptedData"
	
	if "`subcommand'" == "new" {
	
		di "Subcommand: New"
		
		*Creating a new project
		if "`itemType'" == "project" {
			
			di "ItemType: Project"
			iefolder_newProject "`projectfolder'" `newHandle'
			noi di "{pstd}Command ran succesfully, a new DataWork folder was created here created:{p_end}"
			noi di "{pstd}1) [${dataWorkFolder}]{p_end}"
			
		}
		*Creating a new round
		else if "`itemType'" == "round" {
			
			*Use the full item name if abbrevaition was not specified
			if "`abbreviation'" == "" local abbreviation "`itemName'"
			
			di "ItemType: round"
			iefolder_newRound `newHandle' "`itemName'" "`abbreviation'"	
			
			noi di "{pstd}Command ran succesfully, for the round `itemName' the following folders and master dofile were created:{p_end}"
			noi di "{pstd}1) [${`abbreviation'}]{p_end}"
			noi di "{pstd}2) [${encryptFolder}/`itemName' Encrypted Data]{p_end}"
			noi di "{pstd}3) [${`abbreviation'}/`itemName'_MasterDofile.do]{p_end}"
		}
		*Creating a new level of observation for master data set
		else if "`itemType'" == "master" {
			
			di "ItemType: master/unitofobs"
			di `"iefolder_newMaster	`newHandle' "`itemName'""'
			iefolder_newMaster	`newHandle' "`itemName'"
			
			noi di "{pstd}Command ran succesfully, for the master `itemName' the following folders were created:{p_end}"
			noi di "{pstd}1) [${dataWorkFolder}/MasterData/`itemName']{p_end}"
			noi di "{pstd}2) [${encryptFolder}/IDMasterKey/`itemName']{p_end}"
		}
	}
	

	*Closing the new main master dofile handle
	file close 		`newHandle'
	
	*Copy the new master dofile from the tempfile to the original position
	copy "`newTextFile'"  "$dataWorkFolder/Project_MasterDofile.do" , replace
}	
end 	

	/***************************************************
	
		Here are all functions for combination of 
		subcommand and item type
	
	***************************************************/

cap program drop 	iefolder_newProject
	program define	iefolder_newProject
		
		args projectfolder newHandle
		
		*Test if folder where to create new folder exist
		checkFolderExists "`projectfolder'" "parent"

		*Test that the new folder does not already exist
		checkFolderExists "$dataWorkFolder" "new"				
				
		mkdir "$dataWorkFolder"
		
		******************************
		*Writing master do file header
		******************************
		
		*Write intro part with description of project, 
		mdofle_p0 `newHandle' project
		
		*Write flolder globals section header and the root folders
		mdofle_p1 `newHandle' "`projectfolder'"
		
		*Write globals section header and the root folders
		mdofle_p2 `newHandle'
		
		*Write section that runs sub-master dofiles
		mdofle_p3 `newHandle' project

					
		
end 


cap program drop 	iefolder_newRound
	program define	iefolder_newRound
	
	args subHandle rndName rndAbb 
	
	di "new round command"
	
	
	*Test if folder where to create new folder exist
	checkFolderExists "$dataWorkFolder" "parent"
	
	*Test that the new folder does not already exist
	checkFolderExists "$dataWorkFolder/`rndName'" "new"		
	
	*Old file reference
	tempname 	oldHandle
	local 		oldTextFile 	"$dataWorkFolder/Project_MasterDofile.do"

	file open `oldHandle' using `"`oldTextFile'"', read
	file read `oldHandle' line
	
	*Locals needed for the section devider
	local partNum 		= 0 //Keeps track of the part number
	
	
	while r(eof)==0 {
		
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
			
			*return list
			
			**This is NOT an end of section line. Nothing will be written here 
			* but we test that there is no confict with previous names
			if `r(ief_end)' == 0 {
				
					*Test if it is an end of globals section as we are writing a new 
					if "`r(sectionName)'" == "monitor" {
					
					*Write devisor for this section
					writeDevisor 			`subHandle' 1 RoundGlobals rounds `rndName' `rndAbb' 
					
					*Write the globals to the master do file and create the folders
					newRndFolderAndGlobals 	`rndName' `rndAbb' "dataWorkFolder" `subHandle'
					
					*Write an empty line before the end devisor
					file write		`subHandle' "" _n	
					
				}
				else {
				
					*Test that the folder name about to be used is not already in use 
					if "`r(itemName)'" == "`rndName'" {
						noi di as error "{phang}The new round name `rndName' is already in use. No new folders are creaetd and the master do-files has not been changed.{p_end}"
						error 507
					}
					
					*Test that the folder name about to be used is not already in use 
					if "`r(itemAbb)'" == "`rndAbb'" {
						noi di as error "{phang}The new round abbreviation `rndAbb' is already in use. No new folders are creaetd and the master do-files has not been changed.{p_end}"
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
						_col(8) `"do ""' _char(36) `"`rndAbb'/`rndName'_MasterDofile.do" "' _n ///
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
	}
	
	*Close the old file. 
	file close `oldHandle'

end


cap program drop 	iefolder_newMaster
	program define	iefolder_newMaster
	
	args subHandle obsName 
	
	di "new master command"

	global mastData 		"$dataWorkFolder/MasterData"
	global mastDataIDKey 	"$encryptFolder/IDMasterKey"	
	
	*********************************************
	*Test if folder can be created where expected
	*********************************************
	
	
	*Test if folder where to create new folder exist
	checkFolderExists "$mastDataIDKey" "parent"

	*Test that the new folder does not already exist
	checkFolderExists "$mastDataIDKey/`obsName'" "new"
	
	*Test if folder where to create new fodler exist
	checkFolderExists "$mastData" "parent"
	
	*Test that the new folder does not already exist
	checkFolderExists "$mastData/`obsName'" "new"				
	
	*************
	*create folder in masterdata
	
	
	*Old file reference
	tempname 	oldHandle
	local 		oldTextFile 	"$dataWorkFolder/Project_MasterDofile.do"

	file open `oldHandle' using `"`oldTextFile'"', read
	file read `oldHandle' line
	
	*Locals needed for the section devider
	local partNum 		= 0 //Keeps track of the part number
	
	
	while r(eof)==0 {
		
		*Do not interpret macros
		local line : subinstr local line "\$"  "\\$"
		local line : subinstr local line "\`"  "\\`"
		
		parseReadLine `"`line'"'
	
		if `r(ief_line)' == 1 & `r(ief_line)' == 1 & `r(ief_end)' == 0  & "`r(sectionName)'" == "rawData" {
			
			*Create master data folder and add global to folder in master do file
			cap createFolderWriteGlobal "`obsName'"  "mastData"  	mastData_`obsName'	`subHandle'

			if _rc == 693 {
				
	
				
				*If that folder exist, problem 
				noi di as error "{phang}could not create new folder, folder name might already exist "
				error _rc
		
			}
			else if _rc != 0 {
				
				*Unexpected error, run the exact command name again and throw the error to user
				createFolderWriteGlobal "`obsName'"  "mastData"  	mastData_`obsName'	`subHandle'
			}
	
			
			
			file write		`subHandle' `"`line'"' _n
		
		}
		else {
			
			*Copy the line as is
			file write		`subHandle' `"`line'"' _n
		
		}
		
		
		*Read next file and repeat the while loop
		file read `oldHandle' line
	}
	
	*Close the old file. 
	file close `oldHandle'	
	
	
	*Create master data subfolders
	createFolderWriteGlobal "MasterDataSets"  	"mastData_`obsName'"  masterDataSets	
	createFolderWriteGlobal "Dofiles"  			"mastData_`obsName'"  mastDataDo

	
		*************
	*create folder in encrypred ID key master	

	
	createFolderWriteGlobal "`obsName'"  		"mastDataIDKey"  			mastData_E_`obsName'
	createFolderWriteGlobal "Data"  			"mastData_E_`obsName'"  	mastData_E_data
	createFolderWriteGlobal "Sampling"  		"mastData_E_`obsName'"  	mastData_E_Samp
	createFolderWriteGlobal "Treatment"  		"mastData_E_`obsName'"  	mastData_E_Treat	
	


end 
