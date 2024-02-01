*! version 7.3 01FEB2024 DIME Analytics dimeanalytics@worldbank.org

cap program drop 	iefolder
	program define	iefolder

qui {

	syntax anything, PROJectfolder(string) [ABBreviation(string) SUBfolder(string)]

	version 12

	***Todo
	*give error message if divisor is changed

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
	local subcommand 	= trim("`subcommand'")
	local itemType 		= trim("`itemType'")
	local itemName 		= trim("`itemName'")
	local abbreviation 	= trim("`abbreviation'")

	*noi di "SubCommand `subcommand'"
	*noi di "ItemType 	`itemType'"
	*noi di "ItemName	`itemName'"

	 /***************************************************

		Test input

	***************************************************/

	*Test that the type is correct
	local sub_commands "new"
	local itemTypes "project round unitofobs subfolder"

	*Test if subcommand is valid
	if `:list subcommand in sub_commands' == 0 {

		noi di as error `"{phang}You have not used a valid subcommand. You entered "`subcommand'". See the {help iefolder:help file} for details.{p_end}"'
		error 198
	}

	*Test if item type is valid
	if `:list itemType in itemTypes' == 0 {

		noi di as error `"{phang}You have not used a valid item type. You entered "`itemType'". See the {help iefolder:help file} for details.{p_end}"'
		error 198
	}

	*Test that no name is specified with sub command project. There is nothing to be named
	else if ("`itemType'" == "project" & "`itemName'" != "" ) {

		noi di as error `"{phang}You may not specify a name [`itemName'] of when creating a new projet. See the {help iefolder:help file} for details.{p_end}"'
		error 198
	}

	*Test that item name is used when item type is anything but project
	else if ("`itemType'" != "project" & "`itemName'" == "" ) {

		noi di as error `"{phang}You must specify a name of the `itemType'. See the {help iefolder:help file} for details.{p_end}"'
		error 198
	}

	*Test that abbreviation is used only with round of unitofobs
	else if ("`abbreviation'" != "" & !("`itemType'" == "round" | "`itemType'" == "unitofobs") ) {

		noi di as error `"{phang}You may not use the option abbreviation() together with itemtype `itemType'.{p_end}"'
		error 198
	}

	*test that there is no space in itemname
	local space_pos = strpos(trim("`itemName'"), " ")
	if "`rest'" != ""  | `space_pos' != 0 {

		noi di as error `"{pstd}You have specified too many words in: [{it:iefolder `subcommand' `itemType' `itemName'`rest'}] or used a space in {it:itemname}. Spaces are not allowed in the {it:itemname}. Use under_scores or camelCase.{p_end}"'
		error 198
	}

	** Test that item name only includes numbers, letter, underscores and does
	*  not start with a number. These are simplified requirements for folder
	*  names on disk.
	if !regexm("`itemName'", "^[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9_]$") & "`itemType'" != "project" {

		noi di as error `"{pstd}Invalid {it:itemname}. The itemname [`itemName'] can only include letters, numbers, or underscores, and the first character must be a letter.{p_end}"'
		error 198
	}

	** Test that also the abbreviation has valid characters
	if !regexm("`abbreviation'", "^[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9_]$") & "`abbreviation'" != "" {

		noi di as error `"{pstd}Invalid name in the option {it:abbreviation()}. The name [`abbreviation'] can only include letters, numbers, or underscores, and the first character must be a letter.{p_end}"'
		error 198
	}

	**Only rounds can be put in a sufolder, so if subfolder is used the itemtype must be
	if ("`subfolder'" != "" & "`itemType'" != "round") {

		noi di as error `"{pstd}The option subfolder() can only be used together with item type "round" as only "round" folders can be organized in subfolders.{p_end}"'
		error 198
	}

	*test that there is no space in subfolder option
	local space_pos = strpos(trim("`subfolder'"), " ")
	if "`subfolder'" != ""  & `space_pos' != 0 {

		noi di as error `"{pstd}You have specified too many words in: [{it:subfolder(`subfolder')}]. Spaces are not allowed, use under_scores or camelCase instead.{p_end}"'
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


	*Create a global pointing to the main data folder
	global projectFolder		"`projectfolder'"
	global dataWorkFolder 		"$projectFolder/DataWork"
	global encryptFolder 		"$dataWorkFolder/EncryptedData"

	if "`subcommand'" == "new" {

		di "Subcommand: New"

		*Use the full item name if abbrevaition was not specified (this code
		*is irrelevant if not applicable)
		if "`abbreviation'" == "" local abbreviation "`itemName'"

		*Creating a new project
		if "`itemType'" == "project" {

			di "ItemType: Project"
			iefolder_newProject "$projectFolder" `newHandle'

			*Produce success output
			noi di "{pstd}Command ran succesfully, a new DataWork folder was created at:{p_end}"
			noi di "{phang2}1) [${dataWorkFolder}]{p_end}"

		}
		*Creating a new round
		else if "`itemType'" == "round" {

			di "ItemType: round"
			iefolder_newItem `newHandle' round "`itemName'" "`abbreviation'" "`subfolder'"

			*Produce success output
			noi di "{pstd}Command ran succesfully, for the round [`itemName'] the following folders and master dofile were created:{p_end}"
			noi di "{phang2}1) [${`abbreviation'}]{p_end}"
			noi di "{phang2}2) [${`abbreviation'_encrypt}]{p_end}"
			noi di "{phang2}3) [${`abbreviation'}/`itemName'_MasterDofile.do]{p_end}"
		}
		*Creating a new level of observation for master data set
		else if "`itemType'" == "unitofobs" {

			global mastData 		"$dataWorkFolder/MasterData"

			di "ItemType: untiofobs/unitofobs"
			di `"iefolder_newMaster	`newHandle' "`itemName'""'
			iefolder_newItem	`newHandle' untObs "`itemName'" "`abbreviation'"

			*Produce success output
			noi di "{pstd}Command ran succesfully, for the unit of observation [`itemName'] the following folders were created:{p_end}"
			noi di "{phang2}1) [${dataWorkFolder}/MasterData/`itemName']{p_end}"
			noi di "{phang2}2) [${encryptFolder}/Master `itemName' Encrypted]{p_end}"
		}
		*Creating a new subfolder in which rounds can be organized
		else if "`itemType'" == "subfolder" {

			di "ItemType: subfolder"
			iefolder_newItem `newHandle' subFld "`itemName'" "`abbreviation'"

			*Produce success output
			noi di "{pstd}Command ran succesfully, for the subfolder [`itemName'] the following folders were created:{p_end}"
			noi di "{phang2}1) [${dataWorkFolder}/`itemName']{p_end}"
			noi di "{phang2}2) [${encryptFolder}/Subfolder `itemName' Encrypted]{p_end}"

		}
	}

	*Closing the new main master dofile handle
	file close 		`newHandle'

	*Copy the new master dofile from the tempfile to the original position
	copy "`newTextFile'"  "$projectFolder/DataWork/Project_MasterDofile.do" , replace


}
end

/************************************************************

	Primary functions : creating each itemtype

************************************************************/

cap program drop 	iefolder_newProject
	program define	iefolder_newProject

		args projectfolder newHandle

		*Test if folder where to create new folder exist
		checkFolderExists "$projectFolder" "parent"

		*Test that the new folder does not already exist
		checkFolderExists "$dataWorkFolder" "new"

		*Create the main DataWork folder
		mkdir "$dataWorkFolder"

		******************************
		*Writing master do file header
		******************************

		*Write intro part with description of project,
		mdofle_p0 `newHandle' project

		*Write folder globals section header and the root folders
		mdofle_p1 `newHandle' "$projectFolder"

		*Write constant global section here
		mdofle_p2 `newHandle'

		*Write section that runs sub-master dofiles
		mdofle_p3 `newHandle' project

		******************************
		*Create Global Setup Dofile
		******************************

		*See this sub command below
		global_setup

end


cap program drop 	iefolder_newItem
	program define	iefolder_newItem

	args subHandle itemType itemName itemAbb subfolder

	**Test that the folder where the new folder will
	* be created exists and that a folder with the same
	* name is created there already
	if "`itemType'" == "round"  iefolder_testFolderPossible "dataWorkFolder" "`itemName'" "encryptFolder" "Round `itemName' Encrypted"
	if "`itemType'" == "untObs" iefolder_testFolderPossible "mastData" 		 "`itemName'" "encryptFolder" "Master `itemName' Encrypted"
	if "`itemType'" == "subFld" iefolder_testFolderPossible "dataWorkFolder" "`itemName'" "encryptFolder" "Subfolder `itemName' Encrypted"

	*Old file reference
	tempname 	oldHandle
	local 		oldTextFile 	"$projectFolder/DataWork/Project_MasterDofile.do"

	file open `oldHandle' using `"`oldTextFile'"', read
	file read `oldHandle' line

	*Locals needed for the section devider
	local partNum 		= 0 //Keeps track of the part number

	while r(eof)==0 {

		*Do not interpret macros
		local line : subinstr local line "\$"  "\\$"
		local line : subinstr local line "\`"  "\\`"

		//di `"`line'"'

		**Run function to read old project master dofile to check if any
		* information should be added before this line
		parseReadLine `"`line'"'

		if `r(ief_line)' == 0 {

			*This is a regular line of code. It should be copied as-is. No action needed.
			file write	`subHandle' `"`line'"' _n

		}
		else if `r(ief_line)' == 1 {

			**This is a line of code with a divisor written by
			* iefolder. New additions to a section are always added right before an end of section line.
			return list

			*Test if the line is a line with a name line
			if `r(ief_NameLine)' == 1  { // make sure that this is not confused when moved to the front

				****Test that name is not used already
				testNameAvailible "`line'" "`itemName'" "`itemAbb'"

				****Write new line
				if "`r(nameLineType)'" == "`itemType'" {

					*Test if abb is identical to name (applies to
					*when abb is not used)
					*add only name as they are identical
					if "`itemName'" == "`itemAbb'" local name "`itemName'"
					*add both name and abb
					if "`itemName'" != "`itemAbb'" local name "`itemName'*`itemAbb'"

					*write the new line
					writeNameLine `subHandle' "`itemType'" "`name'" "`line'"
				}
				else {

					*We do not add to this line so write is as it was
					file write		`subHandle' `"`line'"' _n
				}

				*If subfolder option is used for a round, test that subfolder is created
				if "`r(nameLineType)'" == "subFld"  & "`subfolder'" != "" {
					****Test that name is not used already
					testNameAvailible "`line'" "`subfolder'" "`subfolder'" "`subfolder'"
				}
			}
			else if "`itemType'" == "round" { // test if round

				**This is NOT an end of section line. Nothing will be written here
				* but we test that there is no confict with previous names
				if "`r(sectionName)'" == "endRounds" {

					*Write divisor for this section
					writeDivisor 			`subHandle' 1 RoundGlobals rounds `itemName' `itemAbb'

					*Write the globals for this round to the proejct master dofile
					newRndFolderAndGlobals 	`itemName' `itemAbb' `subHandle' round "`subfolder'"

					*Create the round master dofile and create the subfolders for this round
					createRoundMasterDofile "$dataWorkFolder/`itemName'" "`itemName'" "`itemAbb'" "`subfolder'"

					*Write an empty line before the end divisor
					file write		`subHandle' "" _n

					*Copy the line as is
					file write		`subHandle' `"`line'"' _n
				}

				**This is an end of section line. We will add the new content here
				* before writing the end of section line
				else if "`r(partName)'" == "End_RunDofiles" { //and test round

					*Write divisor for this section
					writeDivisor `subHandle' 3 RunDofiles `itemName' `itemAbb'

					*Write the
					file write  `subHandle' ///
						_col(4)"if (0) { //Change the 0 to 1 to run the `itemName' master dofile" _n ///
						_col(8) `"do ""' _char(36) `"`itemAbb'/`itemName'_MasterDofile.do" "' _n ///
						_col(4)"}" ///
						_n

					*Write an empty line before the end divisor
					file write		`subHandle' "" _n

					*Then write original line
					file write		`subHandle' `"`line'"' _n

				}
				else {
					*If none apply, just write the line
					file write		`subHandle' `"`line'"' _n
				}
			}

			*Test if this is the location to write the new master data globals
			else if "`r(sectionName)'" == "encrypted"  & "`itemType'" == "untObs" { //And new unitofobs

				*Create unit of observation data folder and add global to folder in master do file
				file write		`subHandle' _col(4)"*`itemName' folder globals" _n
				createFolderWriteGlobal "`itemName'"    "mastData"  	`itemAbb'	`subHandle'

				*Create folders that have no refrence in master do file
				*************
				*Create unit of observation data subfolders
				createFolderWriteGlobal "DataSet"  						"`itemAbb'"  	masterDataSets
				createFolderWriteGlobal "Dofiles"  	 					"`itemAbb'"  	mastDataDo

				*************
				*create folder in encrypred ID key master
				createFolderWriteGlobal "Master `itemName' Encrypted"  	"encryptFolder"  	`itemAbb'_encrypt `subHandle'
				file write		`subHandle' _col(4) _n
				createFolderWriteGlobal "DataSet"  	 					"`itemAbb'_encrypt"  mastData_E_data
				createFolderWriteGlobal "Sampling"   					"`itemAbb'_encrypt"  mastData_E_Samp
				createFolderWriteGlobal "Treatment Assignment"			"`itemAbb'_encrypt"  mastData_E_Treat

				*write the line after these lines
				file write		`subHandle' `"`line'"' _n
			}

			*Test if this is the location to write the new subfolder globals
			else if "`r(sectionName)'" == "master"  & "`itemType'" == "subFld" { //And new subfolder

				*Create unit of observation data folder and add global to folder in master do file
				file write		`subHandle' _col(4)"*`itemName' sub-folder globals" _n
				createFolderWriteGlobal "`itemName'"    					"dataWorkFolder"  	`itemAbb'	`subHandle'
				createFolderWriteGlobal "Subfolder `itemName' Encrypted"  	"encryptFolder"  	`itemAbb'_encrypt `subHandle'
				file write		`subHandle' _col(4) _n

				file write		`subHandle' `"`line'"' _n
			}
			else {
				*If none apply, just write the line
				file write		`subHandle' `"`line'"' _n
			}
		}


		*Read next file and repeat the while loop
		file read `oldHandle' line
	}

	*Close the old file.
	file close `oldHandle'

end



/************************************************************

	Sub-functions : functionality

************************************************************/

cap program drop 	iefolder_testFolderPossible
	program define	iefolder_testFolderPossible

	args mainFolderGlobal mainName encrptFolderGlobal encrptName


	*Test if folder where to create new folder exists
	checkFolderExists "$`mainFolderGlobal'" "parent"
	*Test that the new folder does not already exist
	checkFolderExists "$`mainFolderGlobal'/`mainName'" "new"

	*Encrypted branch

	*Test if folder where to create new folder exists
	checkFolderExists "$`encrptFolderGlobal'" "parent"
	*Test that the new folder does not already exist
	checkFolderExists "$`encrptFolderGlobal'/`encrptName'" "new"

end

cap program drop 	parseReadLine
	program define	parseReadLine, rclass

		args line

		*Tokenize each line
		tokenize  `"`line'"' , parse("*")

		**Parse the beginning of the line to
		* test if this line is an iefolder line
		local divisorStar  		"`1'"
		local divisorIefoldeer  "`2'"

		if `"`divisorIefoldeer'"' == "round" | `"`divisorIefoldeer'"' == "untObs" | `"`divisorIefoldeer'"' == "subFld"{

			return scalar ief_line 		= 1
			return scalar ief_end 		= 0
			return scalar ief_NameLine 	= 1
			return local  nameLineType 	= `"`divisorIefoldeer'"'

		}
		else if `"`divisorStar'`divisorIefoldeer'"' != "*iefolder" {

			*This is not a iefolder divisor
			return scalar ief_line 		= 0
			return scalar ief_end 		= 0

		}
		else {

			*This is a iefolder divisor
			return scalar ief_line 		= 1
			return scalar ief_NameLine 	= 0

			*Parse the rest of the line (from tokenize above)
			local partNum  		"`4'"
			local partName 		"`6'"
			local sectionName 	"`8'"
			local itemName 		"`10'"
			local itemAbb	 	"`12'"

			*Return the part name and number. All iefolder divisor lines have this
			return local partNum  "`partNum'"
			return local partName "`partName'"

			*Get the prefix of the section name
			local sectPrefix = substr("`partName'",1,4)

			*Test if it is an end of section divisor
			if "`sectPrefix'" == "End_" {

				return scalar ief_end 	= 1
			}
			else {

				return scalar ief_end 	= 0

				*These are returned empty if they do not apply
				return local sectionNum 	"`sectionNum'"
				return local sectionName	"`sectionName'"
				return local sectionAbb 	"`sectionAbb'"
				return local itemName		"`itemName'"
				return local itemAbb 		"`itemAbb'"
			}
		}

end



cap program drop 	newRndFolderAndGlobals
	program define	newRndFolderAndGlobals

		args rndName rnd subHandle masterType subfolder

		*Add prefix, suffux and backslash to the subfolder name so that it works in a file path
		if "`subfolder'" != "" local subfolder_encrypt 	"Subfolder `subfolder' Encrypted/"
		if "`subfolder'" != "" local subfolder 			"`subfolder'/"

		*Write title to the folder globals to this round
		file write  `subHandle'	_col(4)"*`rndName' folder globals" _n

		*Round main folder
		createFolderWriteGlobal "`rndName'" "dataWorkFolder" "`rnd'" 	`subHandle' "`subfolder'"

		*Sub folders (this onle writes globals in master dofile, folders are created when writing round master dofile)
		writeGlobal	"Round `rndName' Encrypted" 	"encryptFolder" "`rnd'_encrypt" `subHandle' "`subfolder_encrypt'"
		writeGlobal "DataSets" 						"`rnd'" 		"`rnd'_dt" 		`subHandle'
		writeGlobal "Dofiles" 						"`rnd'"			"`rnd'_do" 		`subHandle'
		writeGlobal "Output" 						"`rnd'"			"`rnd'_out"		`subHandle'

		*This are never written to the master dofile, only created
		createFolderWriteGlobal "Documentation"  "`rnd'"	"`rnd'_doc"
		createFolderWriteGlobal "Questionnaire"  "`rnd'"	"`rnd'_quest"


end

cap program drop 	createRoundMasterDofile
	program define	createRoundMasterDofile

		args roundfolder rndName rnd subfolder

		*Add prefix, suffux and backslash to the subfolder name so that it works in a file path
		if "`subfolder'" != "" local subfolder_encrypt 	"Subfolder `subfolder' Encrypted/"
		if "`subfolder'" != "" local subfolder 			"`subfolder'/"

		*Create a temporary textfile
		tempname 	roundHandle
		tempfile	roundTextFile
		file open  `roundHandle' using "`roundTextFile'", text write replace

		*Write intro part with description of round,
		mdofle_p0 	`roundHandle' round
		mdofle_p1	`roundHandle' "$projectFolder" `rndName' `rnd'

		*Create main round folder and add global to round master dofile
		file write  `roundHandle'	_n	_col(4)"*Encrypted round sub-folder globals" _n
		writeGlobal 			"`rndName'" 					"dataWorkFolder" "`rnd'" 		`roundHandle' "`subfolder'"

		*Create encrypted round sub-folder and add global to round master dofile
		file write  `roundHandle'	_n	_col(4)"*Encrypted round sub-folder globals" _n
		createFolderWriteGlobal	"Round `rndName' Encrypted" 	"encryptFolder" "`rnd'_encrypt" `roundHandle' "`subfolder_encrypt'"
		createFolderWriteGlobal "Raw Identified Data"  			"`rnd'_encrypt" "`rnd'_dtRaw" 	`roundHandle'
		createFolderWriteGlobal "Dofiles Import"				"`rnd'_encrypt" "`rnd'_doImp" 	`roundHandle'
		createFolderWriteGlobal "High Frequency Checks"			"`rnd'_encrypt" "`rnd'_HFC" 	`roundHandle'

		*Create DataSets sub-folder and add global to round master dofile
		file write  `roundHandle' _n	_col(4)"*DataSets sub-folder globals" _n
		createFolderWriteGlobal	"DataSets" 						"`rnd'" 		"`rnd'_dt" 		`roundHandle'
		createFolderWriteGlobal "Deidentified" 					"`rnd'_dt" 		"`rnd'_dtDeID" 	`roundHandle'
		createFolderWriteGlobal "Intermediate" 					"`rnd'_dt" 		"`rnd'_dtInt" 	`roundHandle'
		createFolderWriteGlobal "Final"  						"`rnd'_dt" 		"`rnd'_dtFin" 	`roundHandle'

		*Creat Dofile sub-folder and add global to round master dofile
		file write  `roundHandle' _n	_col(4)"*Dofile sub-folder globals" _n
		createFolderWriteGlobal	"Dofiles" 						"`rnd'"			"`rnd'_do" 		`roundHandle'
		createFolderWriteGlobal "Cleaning"				 		"`rnd'_do" 		"`rnd'_doCln" 	`roundHandle'
		createFolderWriteGlobal "Construct"				 		"`rnd'_do" 		"`rnd'_doCon" 	`roundHandle'
		createFolderWriteGlobal "Analysis"				 		"`rnd'_do" 		"`rnd'_doAnl" 	`roundHandle'

		*Create Output subfolders and add global to round master dofile
		file write  `roundHandle' _n	_col(4)"*Output sub-folder globals" _n
		createFolderWriteGlobal	"Output" 						"`rnd'"			"`rnd'_out"		`roundHandle'
		createFolderWriteGlobal "Raw" 							"`rnd'_out"	 	"`rnd'_outRaw"	`roundHandle'
		createFolderWriteGlobal "Final" 						"`rnd'_out"		"`rnd'_outFin"	`roundHandle'

		*Creat Questionnaire subfolders and add global to round master dofile
		file write  `roundHandle' _n	_col(4)"*Questionnaire sub-folder globals" _n
		createFolderWriteGlobal "Questionnaire Develop" 		"`rnd'_quest"	"`rnd'_qstDev"
		createFolderWriteGlobal "Questionnaire Final" 			"`rnd'_quest"	"`rnd'_qstFin"
		createFolderWriteGlobal "PreloadData"	 				"`rnd'_quest"	"`rnd'_prld"	`roundHandle'
		createFolderWriteGlobal "Questionnaire Documentation"	"`rnd'_quest"	"`rnd'_doc"		`roundHandle'

		*Write sub divisor starting master and monitor data section section
		writeDivisor 	`roundHandle' 1 End_FolderGlobals

		*Write constant global section here
		mdofle_p2 `roundHandle'
		mdofle_p3 `roundHandle' round `rndName' `rnd'

		*Closing the new main master dofile handle
		file close 		`roundHandle'

		*Copy the new master dofile from the tempfile to the original position
		copy "`roundTextFile'"  "${`rnd'}/`rndName'_MasterDofile.do" , replace

end

cap program drop 	createFolderWriteGlobal
	program define	createFolderWriteGlobal

		args  folderName parentGlobal globalName subHandle subfolder

		*Create a global for this folder
		global `globalName' "$`parentGlobal'/`subfolder'`folderName'"

		*If a subhandle is specified then write the global to the master file
		if ("`subHandle'" != "") {
			writeGlobal "`folderName'" `parentGlobal' `globalName' `subHandle' "`subfolder'"
		}

		*Create the folder
		mkdir "${`parentGlobal'}/`subfolder'`folderName'"

end

cap program drop 	writeGlobal
	program define	writeGlobal

	args  folderName parentGlobal globalName subHandle subfolder

	*Create a global for this folder
	global `globalName' "$`parentGlobal'/`subfolder'`folderName'"

	*Write global in round master dofile if subHandle is specified
	file write  `subHandle' 							///
		_col(4) `"global `globalName'"' _col(34) `"""' 	///
		_char(36)`"`parentGlobal'/`subfolder'`folderName'" "' _n

end



cap program drop 	writeDivisor
	program define	writeDivisor , rclass

		args  subHandle partNum partName sectionName itemName itemAbb

		local divisor "*iefolder*`partNum'*`partName'*`sectionName'*`itemName'*`itemAbb'*"

		local divisorLen = strlen("`divisor'")

		*Make all divisors at least 80 characters wide by adding stars (just aesthetic reasons)
		if (`divisorLen' < 80) {

			local numStars = 80 - `divisorLen'
			local addedStars _dup(`numStars') _char(42)
		}

		file write  `subHandle' _n "`divisor'" `addedStars'
		file write  `subHandle' _n "*iefolder will not work properly if the line above is edited"  _n _n

end

*Program that checks if folder exists and provides errors if not.
cap program drop 	checkFolderExists
	program define	checkFolderExists , rclass

		args folder type

		*Returns 0 if folder does not exist, 1 if it does
		mata : st_numscalar("r(dirExist)", direxists("`folder'"))

		** If type is parent folder, i.e. the folder in which we are creating a
		*  new folder, then the parent folder should exist. Throw an error if it doesn't
		if `r(dirExist)' == 0 & "`type'" == "parent" {

			noi di as error `"{phang}A new folder cannot be created in "`folder'" as that folder does not exist. iefolder will not work properly if the names of the folders it depends on are changed.{p_end}"'
			error 693
			exit
		}

		** If type is new folder, i.e. the folder we are creating,
		*  then that folder should not exist. Throw an error if it does
		if `r(dirExist)' == 1 & "`type'" == "new" {

			noi di as error `"{phang}The new folder cannot be created since the folder "`folder'" already exist. You may not use the a name twice for the same type of folder.{p_end}"'
			error 693
			exit
		}

end

*Write or update the line that lists all names used
cap program drop 	writeNameLine
	program define	writeNameLine

	args   subHandle type name line

	if "`type'" == "new" {

		*Add a white space before this section
		file write  `subHandle' "" _n

		writeNameLine `subHandle' "round"
		writeNameLine `subHandle' "untObs"
		writeNameLine `subHandle' "subFld"
	}
	else {

		*remove stars in the end of the line
		local line = substr("`line'",1,strlen("`line'") - indexnot(reverse("`line'"),"*") + 1)

		*Start the new line
		if "`name'" == "" local line "*`type'"

		*add new name (and abbrevation if applicable) to existing line
		if "`name'" != "" local line "`line'*`name'"

		*Make all divisors at least 80 characters wide by adding stars
		if (strlen("`line'") < 80) {

			local numStars = 80 - strlen("`line'")
			local addedStars _dup(`numStars') _char(42)
		}

		file write  `subHandle' "`line'" `addedStars' _n

		*If creating the lines the first time then add a warning text at the end
		if "`type'" == "subFld" & "`name'" == "" {
			file write  `subHandle' "*iefolder will not work properly if the lines above are edited" _n
		}
	}
end

* Test if the new name or abb is already used
cap program drop 	testNameAvailible
	program define	testNameAvailible

	args line name abb subfolder

	*If abb was not used or is the same, remove abb
	if "`name'" == "`abb'" local abb ""

	*Tokenize each line
	tokenize  "`line'" , parse("*")

	*Start at the second item in the list as the first is a star
	local number	1
	local item 		"``number''"

	*Local that keeps track if subfolder names is used
	local subfolderFound 0

	*Loop over all
	while "`item'" != "" {

		*Loop over name and abb (if abb is not used)
		foreach nameTest in `name' `abb' {

			*Test if the name to test is equal to something already used
			if "`item'" == "`nameTest'" & "`subfolder'" == "" {

				*name already used, throw error
				noi di as error "{phang}The name `nameTest' have already been used as a folder name or abbreviation. No new folders are created and the master do-files have not been changed.{p_end}"
				error 507
			}
			else if "`item'" == "`nameTest'" & "`subfolder'" != "" {

				local subfolderFound 1
			}
		}

		*Increment number one more step and take the nest item in the tokenized list
		local ++number

		*If both this item and the next is a * then break the while loop
		if "`item'" == "*" & "``number''" == "*" {
			local item ""
		}
		else {
			*If not both are *, take the next in the list
			local item "``number''"
		}
	}

	*Test that subfolder was found
	 if `subfolderFound' == 0 & "`subfolder'" != "" {
		noi di as error "{phang}The subfolder `name' has not been created by iefolder. Please only create subfolders with iefolder, and do not change the names once they are created. No new folders are created and the master do-files have not been changed.{p_end}"
		error 507
	 }

end

/************************************************************

	Sub-functions : writing master dofiles

************************************************************/

cap program drop 	mdofle_p0
	program define	mdofle_p0

		args subHandle itemType rndName task

		file write  `subHandle' ///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"*" _col(75) "*" _n ///
			_col(4)"*" _col(20) "your_`itemType'_name" _col(75) "*" _n ///
			_col(4)"*" _col(20) "MASTER DO_FILE" _col(75) "*" _n ///
			_col(4)"*" _col(75) "*" _n ///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"* ******************************************************************** *" _n ///
			_n _col(8)"/*" _n

		if "`itemType'" == "project" {

			file write  `subHandle'	///
				_col(8)"** PURPOSE:" _col(25) "Write intro to project here" _n ///
				_n ///
				_col(8)"** OUTLINE:" _col(25) "PART 0: Standardize settings and install packages" _n ///
				_col(25) "PART 1: Set globals for dynamic file paths" _n ///
				_col(25) "PART 2: Set globals for constants and varlist" _n ///
				_col(32) "used across the project. Install all user-contributed" _n ///
				_col(32) "commands needed." _n ///
				_col(25) "PART 3: Call the task-specific master do-files " _n ///
				_col(32) "that call all dofiles needed for that " _n ///
				_col(32) "task. Do not include Part 0-2 in a task-" _n ///
				_col(32) "specific master do-file" _n ///
				_n _n
		}
		else if "`itemType'" == "round" {

			file write  `subHandle'	///
				_col(8)"** PURPOSE:" _col(25) "Write intro to survey round here" _n ///
				_n ///
				_col(8)"** OUTLINE:" _col(25) "PART 0: Standardize settings and install packages" _n ///
				_col(25) "PART 1: Prepare folder path globals" _n ///
				_col(25) "PART 2: Run the master dofiles for each high-level task" _n _n
		}

		file write  `subHandle'	///
			_col(8)"** IDS VAR:" _col(25) "list_ID_var_here		//Uniquely identifies households (update for your project)" _n ///
			_n	///
			_col(8)"** NOTES:" _n ///
			_n ///
			_col(8)"** WRITTEN BY:" _col(25) "names_of_contributors" _n ///
			_n ///
			_col(8)"** Last date modified: `c(current_date)'" _n ///
			_col(8)"*/" _n

		*Write divisor starting setting standardize section
		writeDivisor  `subHandle' 0 StandardSettings


		file write  `subHandle'	///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"*" _n ///
			_col(4)"*" _col(12) "PART 0:  INSTALL PACKAGES AND STANDARDIZE SETTINGS" _n ///
			_col(4)"*" _n ///
			_col(4)"*" _col(16) "- Install packages needed to run all dofiles called" _n ///
			_col(4)"*" _col(17) "by this master dofile." _n ///
			_col(4)"*" _col(16) "- Use ieboilstart to harmonize settings across users" _n ///
			_col(4)"*" _n ///
			_col(4)"* ******************************************************************** *" _n

		*Write divisor ending setting standardize section
		writeDivisor `subHandle' 0 End_StandardSettings

		file write  `subHandle' 	///
			_col(4)"*Install all packages that this project requires:" _n ///
			_col(4)"*(Note that this never updates outdated versions of already installed commands, to update commands use adoupdate)" _n ///
			_col(4)"local user_commands ietoolkit iefieldkit" _col(40) "//Fill this list will all user-written commands this project requires" _n ///
			_col(4)"foreach command of local user_commands {" _n ///
			_col(8)		"cap which " _char(96) "command'" _n ///
			_col(8)		"if _rc == 111 {" _n ///
			_col(12)		"ssc install " _char(96) "command'" _n ///
			_col(8)		"}" _n ///
			_col(4)"}" _n ///
			_n	 ///
			_col(4)"*Standardize settings accross users" _n ///
			_col(4)"ieboilstart, version(12.1)" _col(40) "//Set the version number to the oldest version used by anyone in the project team" _n ///
			_col(4) _char(96)"r(version)'" 		_col(40) "//This line is needed to actually set the version from the command above" _n


end


cap program drop 	mdofle_p1
	program define	mdofle_p1

		args   subHandle projectfolder rndName rndAbb

		*Write divisor starting globals section
		writeDivisor  `subHandle' 1 FolderGlobals

		file write  `subHandle' 	///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"*" _n ///
			_col(4)"*" _col(12) "PART 1:  PREPARING FOLDER PATH GLOBALS" _n ///
			_col(4)"*" _n ///
			_col(4)"*" _col(16) "- Set the global box to point to the project folder" _n ///
			_col(4)"*" _col(17) "on each collaborator's computer." _n ///
			_col(4)"*" _col(16) "- Set other locals that point to other folders of interest." _n ///
			_col(4)"*" _n ///
			_col(4)"* ******************************************************************** *" _n

		file write  `subHandle' ///
			_n ///
			_col(4)"* Users" _n ///
			_col(4)"* -----------" _n ///
			_n ///
			_col(4)"*User Number:" _n ///
			_col(4)"* You" _col(30) "1" _col(35) `"// Replace "You" with your name"' _n ///
			_col(4)"* Next User" _col(30) "2" _col(35) "// Assign a user number to each additional collaborator of this code" _n ///
			_n ///
			_col(4)"*Set this value to the user currently using this file" _n ///
			_col(4)"global user  1" _n ///
			_n ///
			_col(4)"* Root folder globals" _n ///
			_col(4)"* ---------------------" _n ///
			_n ///
			_col(4)"if "_char(36)"user == 1 {" _n ///
			_col(8)`"global projectfolder "$projectFolder""' _n ///
			_col(4)"}" _n ///
			_n ///
			_col(4)"if "_char(36)"user == 2 {" _n ///
			_col(8)`"global projectfolder ""  // Enter the file path to the project folder for the next user here"' _n ///
			_col(4)"}" _n _n ///
			"* These lines are used to test that the name is not already used (do not edit manually)"

		*For new main master do file
		if "`rndName'" == "" {

			*Write name line only in main master do file
			writeNameLine `subHandle' new
		}

		file write  `subHandle' _n 	_n ///
			_col(4)"* Project folder globals" _n ///
			_col(4)"* ---------------------" _n _n ///
			_col(4)"global dataWorkFolder " _col(34) `"""' _char(36)`"projectfolder/DataWork""' _n

		*Write sub divisor starting master and monitor data section section
		if "`rndName'" == "" writeDivisor `subHandle' 1 FolderGlobals subfolder

		*Write sub divisor starting master and monitor data section section
		writeDivisor `subHandle' 1 FolderGlobals master

		di `" if "`rndName'" == ""  "'
		*Create master data folder and add global to folder in master do file
		if "`rndName'" == "" createFolderWriteGlobal "MasterData" "dataWorkFolder" mastData	`subHandle' //For new project
		if "`rndName'" != "" writeGlobal 			 "MasterData" "dataWorkFolder" mastData	`subHandle' //For new round

		*Write sub divisor starting master and monitor data section section
		writeDivisor `subHandle' 1 FolderGlobals encrypted

		*Create master data folder and add global to folder in master do file
		if "`rndName'" == "" createFolderWriteGlobal "EncryptedData"  "dataWorkFolder"  encryptFolder `subHandle' //For new project
		if "`rndName'" != "" writeGlobal 			 "EncryptedData"  "dataWorkFolder"  encryptFolder `subHandle' //For new rounds

		*For new main master do file
		if "`rndName'" == "" {

			*Write sub divisor starting master and monitor data section section
			writeDivisor `subHandle' 1 FolderGlobals endRounds

			*Write sub divisor starting master and monitor data section section
			writeDivisor `subHandle' 1 End_FolderGlobals

		}

		*For new round master do file
		if "`rndName'" != "" {

			*Write sub divisor starting master and monitor data section section
			writeDivisor `subHandle' 1 FolderGlobals `rndName'

		}

end


cap program drop 	mdofle_p2
	program define	mdofle_p2

		args   subHandle

		di "masterDofilePart2 start"

		*Write divisor starting standardization globals section
		writeDivisor  `subHandle' 2 StandardGlobals

		file write  `subHandle'  ///
			_col(4)"* Set all non-folder path globals that are constant accross" _n ///
			_col(4)"* the project. Examples are conversion rates used in unit" _n  	///
			_col(4)"* standardization, different sets of control variables," _n 		///
			_col(4)"* adofile paths etc." _n _n 									///
			_col(4) `"do ""' _char(36) `"dataWorkFolder/global_setup.do" "' _n _n

		*Write divisor ending standardization globals section
		writeDivisor  `subHandle' 2 End_StandardGlobals

		di "masterDofilePart2 end"

end




cap program drop 	mdofle_p3
	program define	mdofle_p3

		args   subHandle itemType rndName rnd

		di "masterDofilePart3 start"

		*Part number
		local partNum = 3

		*Write divisor starting the section running sub-master dofiles
		writeDivisor  `subHandle' `partNum' RunDofiles

			file write  `subHandle' 	///
				_col(4)"* ******************************************************************** *" _n 	///
				_col(4)"*" _n 																			///
				_col(4)"*" _col(12) "PART `partNum': - RUN DOFILES CALLED BY THIS MASTER DOFILE" _n 	///
				_col(4)"*" _n

			if "`itemType'" == "project" {
				file write  `subHandle' 																///
					_col(4)"*" _col(16) "- When survey rounds are added, this section will" _n 			///
					_col(4)"*" _col(17) "link to the master dofile for that round." _n 					///
					_col(4)"*" _col(16) "- The default is that these dofiles are set to not"  _n 		///
					_col(4)"*" _col(17) "run. It is rare that all round-specfic master dofiles"  _n 	///
					_col(4)"*" _col(17) "are called at the same time; the round specific master"  _n 	///
					_col(4)"*" _col(17) "dofiles are almost always called individually. The"  _n 		///
					_col(4)"*" _col(17) "exception is when reviewing or replicating a full project." _n
			}
			else if "`itemType'" == "round" {
				file write  `subHandle' 																///
					_col(4)"*" _col(16) "- A task master dofile has been created for each high-"  _n 		///
					_col(4)"*" _col(17) "level task (cleaning, construct, analysis). By "  _n 			///
					_col(4)"*" _col(17) "running all of them all data work associated with the "  _n 	///
					_col(4)"*" _col(17) "`rndName' should be replicated, including output of "  _n 		///
					_col(4)"*" _col(17) "tables, graphs, etc." _n 										///
					_col(4)"*" _col(16) "- Feel free to add to this list if you have other high-"  _n 	///
					_col(4)"*" _col(17) "level tasks relevant to your project." _n
			}

			file write  `subHandle' 	///
				_col(4)"*" _n ///
				_col(4)"* ******************************************************************** *" _n

		if "`itemType'" == "round" {

			file write  `subHandle' 	_n ///
				_col(4)"**Set the locals corresponding to the tasks you want" _n ///
				_col(4)"* run to 1. To not run a task, set the local to 0." _n ///
				_col(4)"local importDo" _col(25) "0" _n ///
				_col(4)"local cleaningDo" _col(25) "0" _n ///
				_col(4)"local constructDo" _col(25) "0" _n ///
				_col(4)"local analysisDo" _col(25) "0" _n ///

			*Create the references to the high level task
			highLevelTask `subHandle'  "`rndName'" "`rnd'" "import"
			highLevelTask `subHandle'  "`rndName'" "`rnd'" "cleaning"
			highLevelTask `subHandle'  "`rndName'" "`rnd'" "construct"
			highLevelTask `subHandle'  "`rndName'" "`rnd'" "analysis"

		}

		*Write divisor ending the section running sub-master dofiles
		writeDivisor  `subHandle' `partNum' End_RunDofiles

		di "masterDofilePart3 end"

end

cap program drop 	highLevelTask
	program define	highLevelTask

		args roundHandle rndName rnd task

		di "highLevelTask start"

		*Import folder is in differnt location, in the encrypted folder
		if "`task'" != "import" {

			*The location of all the task master dofile apart from import master
			local taskdo_fldr "`rnd'_do"
		}
		else {

			**The import master dofile is in the encryption folder as it is
			* likely to have identifying information
			local taskdo_fldr "`rnd'_doImp"
		}

		*Write section where task master files are called
		file write  `roundHandle' 	_n ///
			_col(4)"if (" _char(96) "`task'Do' == 1) { // Change the local above to run or not to run this file" _n ///
			_col(8) `"do ""' _char(36) `"`taskdo_fldr'/`rnd'_`task'_MasterDofile.do" "' _n ///
			_col(4)"}" _n

		*Create the task dofiles
		highLevelTaskMasterDofile `rndName' `task' `rnd'

end

cap program drop 	highLevelTaskMasterDofile
	program define	highLevelTaskMasterDofile

		di "highLevelTaskMasterDofile start"

		args rndName task rnd

		*Write the round dofile

		*Create a temporary textfile
		tempname 	taskHandle
		tempfile	taskTextFile
		file open  `taskHandle' using "`taskTextFile'", text write replace

		mdofle_task `taskHandle' `rndName' `rnd' `task'

		*Closing the new main master dofile handle
		file close 		`taskHandle'

		*Import folder is in differnt location, in the encrypted folder
		if "`task'" != "import" {

			*Copy the new task master dofile from the tempfile to the original position
			copy "`taskTextFile'"  "${`rnd'_do}/`rnd'_`task'_MasterDofile.do" , replace
		}
		else {

			*Copy the import task master do file in to the Dofile import folder.
			copy "`taskTextFile'"  "${`rnd'_doImp}/`rnd'_`task'_MasterDofile.do" , replace
		}

end

cap program drop 	mdofle_task
	program define	mdofle_task

		args subHandle rndName rnd task

		**Create local with round name and task in
		* upper case for the titel of the master dofile
		local caps = upper("`rndName' `task'")

		*Differnt global suffix for different tasks
		local suffix
		if "`task'" == "import" {
			local suffix "_doImp"
		}
		if "`task'" == "cleaning" {
			local suffix "_doCln"
		}
		if "`task'" == "construct" {
			local suffix "_doCon"
		}
		if "`task'" == "analysis" {
			local suffix "_doAnl"
		}

		file write  `subHandle' ///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"*" _col(75) "*" _n ///
			_col(4)"*" _col(20) "`caps' MASTER DO_FILE" _col(75) "*" _n ///
			_col(4)"*" _col(20) "This master dofile calls all dofiles related" _col(75) "*" _n ///
			_col(4)"*" _col(20) "to `task' in the `rndName' round." _col(75) "*" _n ///
			_col(4)"*" _col(75) "*" _n ///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"* ******************************************************************** *" _n ///
			 _n 	///
			_col(4)"** IDS VAR:" _col(25) "list_ID_var_here		// Uniquely identifies households (update for your project)" _n ///
			_col(4)"** NOTES:" _n ///
			_col(4)"** WRITTEN BY:" _col(25) "names_of_contributors" _n ///
			_col(4)"** Last date modified: `c(current_date)'" _n _n ///
			_n ///
			_col(4)"* ***************************************************** *" _n ///
			_col(4)"*" _col(60) "*" _n ///


		*Create the sections with placeholders for each dofile for this task
		mdofle_task_dosection `subHandle' "`rnd'" "`task'" "`suffix'" 1
		mdofle_task_dosection `subHandle' "`rnd'" "`task'" "`suffix'" 2
		mdofle_task_dosection `subHandle' "`rnd'" "`task'" "`suffix'" 3

	file write  `subHandle' ///
		_col(4)"* ************************************" _n ///
		_col(4)"*" _col(8) "Keep adding sections for all additional dofiles needed" _n ///

end

cap program drop 	mdofle_task_dosection
	program define	mdofle_task_dosection

	*Write the task master do-file section

	args subHandle rnd task suffix number

	file write  `subHandle' ///
		_col(4)"* ***************************************************** *" _n ///
		_col(4)"*" _n ///
		_col(4)"*" _col(8) "`task' dofile `number'" _n ///
		_col(4)"*" _n ///
		_col(4)"*" _col(8) "The purpose of this dofiles is:" _n ///
		_col(4)"*" _col(10) "(The ideas below are examples on what to include here)" _n ///
		_col(4)"*" _col(11) "- what additional data sets does this file require" _n ///
		_col(4)"*" _col(11) "- what variables are created" _n ///
		_col(4)"*" _col(11) "- what corrections are made" _n ///
		_col(4)"*" _n ///
		_col(4)"* ***************************************************** *"  _n ///
		_n ///
		_col(8) `"*do ""' _char(36) `"`rnd'`suffix'/dofile`number'.do" //Give your dofile a more informative name, this is just a placeholder name"' _n _n

end

/*****************************************************************

	Create dofile that sets all non-folder globals

*****************************************************************/

cap program drop 	global_setup
program define		global_setup

	*Create a temporary textfile
	tempname 	glbStupHandle
	tempfile	glbStupTextFile

	cap file close 	`glbStupHandle'
	file open  		`glbStupHandle' using "`glbStupTextFile'", text write append


	file write  `glbStupHandle' 	///
		_col(4)"* ******************************************************************** *" _n 	///
		_col(4)"*" _n 																			///
		_col(4)"*" _col(12) "SET UP STANDARDIZATION GLOBALS AND OTHER CONSTANTS" _n 			///
		_col(4)"*" _n 																			///
		_col(4)"*" _col(16) "- Set globals used all across the project" _n 						///
		_col(4)"*" _col(16) "- It is bad practice to define these at multiple locations" _n		///
		_col(4)"*" _n 																			///
		_col(4)"* ******************************************************************** *" _n

	file write  `glbStupHandle' 																///
		_n 																						///
		_col(4)"* ******************************************************************** *" _n 	///
		_col(4)"* Set all conversion rates used in unit standardization " _n 					///
		_col(4)"* ******************************************************************** *" _n 	///
		_n 																						///
		_col(4)"**Define all your conversion rates here instead of typing them each " _n 		///
		_col(4)"* time you are converting amounts, for example - in unit standardization. " _n 	///
		_col(4)"* We have already listed common conversion rates below, but you" _n 			///
		_col(4)"* might have to add rates specific to your project, or change the target " _n 	///
		_col(4)"* unit if you are standardizing to other units than meters, hectares," _n 		///
		_col(4)"* and kilograms." 		_n														///
		_n 																						///
		_col(4)"*Standardizing length to meters" _n 											///
		_col(8)"global foot" _col(24) "= 0.3048" _n 											///
		_col(8)"global mile" _col(24) "= 1609.34" _n 											///
		_col(8)"global km" 	 _col(24) "= 1000" _n 												///
		_col(8)"global yard" _col(24) "= 0.9144" _n 											///
		_col(8)"global inch" _col(24) "= 0.0254" _n 											///
		_n 																						///
		_col(4)"*Standardizing area to hectares" _n 											///
		_col(8)"global sqfoot"	_col(24) "= (1 / 107639)" _n 									///
		_col(8)"global sqmile"	_col(24) "= (1 / 258.999)" _n 									///
		_col(8)"global sqmtr" 	_col(24) "= (1 / 10000)" _n 									///
		_col(8)"global sqkmtr"	_col(24) "= (1 / 100)" _n 										///
		_col(8)"global acre" 	_col(24) "= 0.404686" _n 										///
		_n 																						///
		_col(4)"*Standardizing weight to kilorgrams" _n 										///
		_col(8)"global pound" 	_col(24) "= 0.453592" _n 										///
		_col(8)"global gram" 	_col(24) "= 0.001" _n 											///
		_col(8)"global impTon" 	_col(24) "= 1016.05" _n 										///
		_col(8)"global usTon" 	_col(24) "= 907.1874996" _n 									///
		_col(8)"global mtrTon" 	_col(24) "= 1000" _n 											///
		_n 																						///
		_col(4)"* ******************************************************************** *" _n 	///
		_col(4)"* Set global lists of variables" _n 											///
		_col(4)"* ******************************************************************** *" _n 	///
		_n 																						///
		_col(4)"**This is a good location to create lists of variables to be used at " _n 		///
		_col(4)"* multiple locations across the project. Examples of such lists might " _n 		///
		_col(4)"* be different list of controls to be used across multiple regressions. " _n		///
		_col(4)"* By defining these lists here, you can easliy make updates and have " _n		///
		_col(4)"* those updates being applied to all regressions without a large risk " _n		///
		_col(4)"* of copy and paste errors." _n 												///
		_n 																						///
		_col(8)"*Control Variables" _n 															///
		_col(8)"*Example: global household_controls" _col(50) "income female_headed" _n 		///
		_col(8)"*Example: global country_controls" 	 _col(50) "GDP inflation unemployment" _n 	///
		_n 																						///
		_col(4)"* ******************************************************************** *" _n 	///
		_col(4)"* Set custom adofile path" _n 													///
		_col(4)"* ******************************************************************** *" _n 	///
		_n																						///
		_col(4)"**It is possible to control exactly which version of each command that " _n 	///
		_col(4)"* is used in the project. This prevents that different versions of " _n 		///
		_col(4)"* installed commands leads to different results." _n _n							///
		_col(4)"/*"_n																			///
		_col(8)"global ado" 	_col(24) `"""' _char(36) `"dataWorkFolder/your_ado_folder""' _n	///
		_col(12)"adopath ++"	_col(24) `"""' _char(36) `"ado" "'	 _n							///
		_col(12)"adopath ++"	_col(24) `"""' _char(36) `"ado/m" "' _n							///
		_col(12)"adopath ++"	_col(24) `"""' _char(36) `"ado/b" "' _n							///
		_col(4)"*/"_n																			///
		_n 																						///
		_col(4)"* ******************************************************************** *" _n 	///
		_col(4)"* Anything else" _n 													///
		_col(4)"* ******************************************************************** *" _n 	///
		_n																						///
		_col(4)"**Everything that is constant may be included here. One example of" _n 			///
		_col(4)"* something not constant that should be included here is exchange" _n 			///
		_col(4)"* rates. It is best practice to have one global with the exchange rate" _n 		///
		_col(4)"* here, and reference this each time a currency conversion is done. If " _n 	///
		_col(4)"* the currency exchange rate needs to be updated, then it only has to" _n 		///
		_col(4)"* be done at one place for the whole project." _n 								///

	*Closing the new main master dofile handle
	file close 		`glbStupHandle'

	*Copy the new master dofile from the tempfile to the original position
	copy "`glbStupTextFile'"  "$dataWorkFolder/global_setup.do" , replace

end
