	
	cap program drop 	parseReadLine 
	program define		parseReadLine, rclass
		
		args line
		
		*Tokenize each line 
		tokenize  `"`line'"' , parse("*")
		
		**Parse the beginning of the line to 
		* test if this line is an iefolder line
		local divisorStar  		"`1'"
		local divisorIefoldeer  "`2'"

		if `"`divisorStar'`divisorIefoldeer'"' != "*iefolder" {
			
			*This is not a iefolder divisor
			return scalar ief_line 	= 0
			return scalar ief_end 	= 0
		}
		else {
		
			*This is a iefolder divisor, 
			return scalar ief_line 	= 1		
			
			*parse the rest of the line (from tokenize above)
			local partNum  		"`4'"
			local partName 		"`6'"
			local sectionName 	"`8'"
			local itemName 		"`10'"
			local itemAbb	 	"`12'"
			
			*Return the part name and number. All iefolder divisor lines has this
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
		*di "parseReadLine end"
	end
	
	
	
	cap program drop 	newRndFolderAndGlobals 
	program define		newRndFolderAndGlobals 
		
		args rndName rnd dtfld_glb subHandle
		
		*KBKB: test if new fodler can be written - use "cap cd"
		
		*Write title to the folder globals to this round
		file write  `subHandle'	_col(4)"*`rndName' folder globals" _n
		
		*Round main folder	
		createFolderWriteGlobal "`rndName'" 	"`dtfld_glb'"	"`rnd'" 		`subHandle'
		
		*Sub folders
		createFolderWriteGlobal "DataSets" 		"`rnd'" 		"`rnd'_dt" 		`subHandle'
		createFolderWriteGlobal "Dofiles" 		"`rnd'"			"`rnd'_do" 		`subHandle'
		createFolderWriteGlobal "Output" 		"`rnd'"			"`rnd'_out"		`subHandle'
		createFolderWriteGlobal "Documentation" "`rnd'"	 		"`rnd'_doc"	
		createFolderWriteGlobal "Questionnaire" "`rnd'"	 		"`rnd'_quest"		
	
		*Create round master dofile
		createRoundMasterDofile "$dataWorkFolder/`rndName'" "`rndName'" "`rnd'"
		
	end
	
	cap program drop 	createRoundMasterDofile 
		program define	createRoundMasterDofile 	
		
		args roundfolder rndName rnd
		
		*Create a temporary textfile
		tempname 	roundHandle
		tempfile	roundTextFile
		file open  `roundHandle' using "`roundTextFile'", text write replace	
		
		*Write intro part with description of round, 
		mdofle_p0 		`roundHandle' round
		mdofle_p1_round `roundHandle' `rndName'
		
		*Encrypted round sub-folder
		file write  `roundHandle'		_col(4)"*Encrypted round sub-folder globals" _n 
		createFolderWriteGlobal "`rndName' Encrypted Data" 			"encryptFolder" "`rnd'_encrypt" `roundHandle'
		createFolderWriteGlobal "Raw Identified Data"  			"`rnd'_encrypt" "`rnd'_dtRaw" 	`roundHandle'
		createFolderWriteGlobal "Dofiles Import"				"`rnd'_encrypt" "`rnd'_doImp" 	`roundHandle'
		
		*DataSets sub-folder
		file write  `roundHandle' _n	_col(4)"*DataSets sub-folder globals" _n
		createFolderWriteGlobal "Intermediate" 					"`rnd'_dt" 		"`rnd'_dtInt" 	`roundHandle'
		createFolderWriteGlobal "Final"  						"`rnd'_dt" 		"`rnd'_dtFin" 	`roundHandle'
		
		*Dofile sub-folder
		file write  `roundHandle' _n	_col(4)"*Dofile sub-folder globals" _n
		createFolderWriteGlobal "Dofiles Cleaning"				"`rnd'_do" 		"`rnd'_doCln" 	`roundHandle'
		createFolderWriteGlobal "Dofiles Construct"				"`rnd'_do" 		"`rnd'_doCon" 	`roundHandle'
		createFolderWriteGlobal "Dofiles Analysis"				"`rnd'_do" 		"`rnd'_doAnl" 	`roundHandle'
		
		*Output subfolders
		file write  `roundHandle' _n	_col(4)"*Output sub-folder globals" _n
		createFolderWriteGlobal "Raw" 							"`rnd'_out"	 	"`rnd'_outRaw"	`roundHandle'		
		createFolderWriteGlobal "Final" 						"`rnd'_out"	 	"`rnd'_outFin"	`roundHandle'
	
		*Questionnaire subfolders
		file write  `roundHandle' _n	_col(4)"*Questionnaire sub-folder globals" _n
		createFolderWriteGlobal "Questionnaire Develop" 		"`rnd'_quest"	 "`rnd'_qstDev"			
		createFolderWriteGlobal "Questionnaire Final" 			"`rnd'_quest"	 "`rnd'_qstFin"	
		createFolderWriteGlobal "PreloadData"	 				"`rnd'_quest"	 "`rnd'_prld"	`roundHandle'
		createFolderWriteGlobal "Questionnaire Documentation"	"`rnd'_quest"	 "`rnd'_doc"	`roundHandle'
		
		*Write sub devisor starting master and monitor data section section
		writeDevisor 	`roundHandle' 1 End_FolderGlobals	
		
		mdofle_p3 `roundHandle' round `rndName' `rnd'
		
		*Closing the new main master dofile handle
		file close 		`roundHandle'

		*Copy the new master dofile from the tempfile to the original position
		copy "`roundTextFile'"  "`roundfolder'/`rndName'_MasterDofile.do" , replace
	
	end
	
	cap program drop 	createFolderWriteGlobal 
		program define	createFolderWriteGlobal 
		
		args  folderName parentGlobal globalName subHandle
		
			*Write global in round master dofile if subHandle is specified
			if ("`subHandle'" != "") {
				
				file write  `subHandle' ///
					_col(4) `"global `globalName'"' _col(34) ///
					`"""' _char(36)`"`parentGlobal'/`folderName'" "' _n 
			}
			
			global `globalName' "$`parentGlobal'/`folderName'"
			
			mkdir "${`parentGlobal'}\\`folderName'"
			
	end
	
	
	cap program drop 	writeDevisor 
	program define		writeDevisor , rclass
		
		args  subHandle partNum partName sectionName itemName itemAbb 
		
		local devisor "*iefolder*`partNum'*`partName'*`sectionName'*`itemName'*`itemAbb'*"
		
		local devisorLen = strlen("`devisor'")
		
		*Make all devisors at least 80 characters wide by adding stars
		if (`devisorLen' < 80) {
			
			local numStars = 80 - `devisorLen'
			local addedStars _dup(`numStars') _char(42)
		}
		
		file write  `subHandle' _n "`devisor'" `addedStars'
		file write  `subHandle' _n "*iefolder will not work properly if the line above is edited"  _n _n
		
	end
	
	cap program drop 	checkFolderExists 
	program define		checkFolderExists , rclass	
		
		args folder type
		
		*Returns 0 if folder does not exist, 1 if it does
		mata : st_numscalar("r(dirExist)", direxists("`folder'"))
		
		** If type is parent folder, i.e. the folder in which we are creating a 
		*  new folder, then the parent folder should exist. Throw an error if it doesn't
		if `r(dirExist)' == 0 & "`type'" == "parent" {
		
			noi di as error `"{phang}A new folder cannot be created in "`folder'" as that folder does not exist. iefolder will not work properly if the names of the folders it depends on are changed."' 
			error 693
			exit
		}
		
		** If type is new folder, i.e. the folder we are creating, 
		*  then that folder should not exist. Throw an error if it does		
		if `r(dirExist)' == 1 & "`type'" == "new" {
			
			noi di as error `"{phang}The new folder cannot be created since the folder "`folder'" already exist. You may not use the a name twice for teh same type of folder."' 
			error 693
			exit
		}
	
	end
	
	/**************************************************************************************
		The functions below are all related to write the mostly 
		static part of the master do file
	**************************************************************************************/
	
	cap program drop 	mdofle_p0
	program define		mdofle_p0 
		
		args subHandle itemType rndName task
		
		*di "start masterDofilePart0"
		
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
				_col(32) "used across the project. Intall custom" _n ///
				_col(32) "commands needed." _n ///
				_col(25) "PART 3: Call the task specific master do-files " _n ///
				_col(32) "that call all do-files needed for that " _n ///
				_col(32) "tas. Do not include Part 0-2 in a task" _n ///
				_col(32) "specific master do-file" _n ///
				_n _n
		} 
		else if "`itemType'" == "round" {
			
			file write  `subHandle'	/// 
				_col(8)"** PURPOSE:" _col(25) "Write intro to survey round here" _n ///
				_n ///					
				_col(8)"** OUTLINE:" _col(25) "PART 0: Standardize settings and install packages" _n ///
				_col(25) "PART 1: Preparing folder path globals" _n ///
				_col(25) "PART 2: Run the master do files for each high level task" _n _n 
		}
				
		file write  `subHandle'	/// 
			_col(8)"** IDS VAR:" _col(25) "list_ID_var_here		//Uniquely identifies households (update for your project)" _n ///
			_n	///				  
			_col(8)"** NOTES:" _n /// 	  
			_n ///				  
			_col(8)"** WRITEN BY:" _col(25) "names_of_contributors" _n ///
			_n ///
			_col(8)"** Last date modified: `c(current_date)'" _n /// 
			_col(8)"*/" _n
		
		*Write devisor starting setting standardize section
		writeDevisor  `subHandle' 0 StandardSettings 
				
				
		file write  `subHandle'	/// 		
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"*" _n ///
			_col(4)"*" _col(12) "PART 0:  INSTALL PACKAGES AND STANDARDIZE SETTINGS" _n ///
			_col(4)"*" _n ///
			_col(4)"*" _col(16) "-Install packages needed to run all dofiles called" _n ///
			_col(4)"*" _col(17) "by this master dofile." _n ///
			_col(4)"*" _col(16) "-Use ieboilstart to harmonize settings across users" _n ///
			_col(4)"*" _n ///								
			_col(4)"* ******************************************************************** *" _n  

		*Write devisor ending setting standardize section
		writeDevisor `subHandle' 0 End_StandardSettings
		
		file write  `subHandle' 	///							
			_col(8)"*Install all packages that this project requires:" _n ///
			_col(8)"ssc install ietoolkit" _n ///
			_n	 ///
			_col(8)"*Standardize settings accross users" _n ///
			_col(8)"ieboilstart, version(12.1)" _col(40) "//Set the version number to the oldest version used by anyone in the project team" _n ///
			_col(8) _char(96)"r(version)'" 		_col(40) "//This line is needed to actually set the version from the command above" _n
			
		*di "masterDofilePart0a end"
		
	end
	

cap program drop 	mdofle_p1
	program define	mdofle_p1
		
		args   subHandle projectfolder 
		
		*Write devisor starting globals section
		writeDevisor  `subHandle' 1 FolderGlobals
		
		*di "masterDofilePart1 start"
		
		file write  `subHandle' 	///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"*" _n ///	
			_col(4)"*" _col(12) "PART 1:  PREPARING FOLDER PATH GLOBALS" _n ///
			_col(4)"*" _n ///			
			_col(4)"*" _col(16) "-Set the global box to point to the project folder" _n ///
			_col(4)"*" _col(17) "on each collaborators computer." _n /// 
			_col(4)"*" _col(16) "-Set other locals that point to other folders of interest." _n /// 
			_col(4)"*" _n ///	
			_col(4)"* ******************************************************************** *" _n
							
		file write  `subHandle' ///
			_n ///	
			_col(4)"* Users" _n ///
			_col(4)"* -----------" _n ///
			_n ///
			_col(4)"*User Number:" _n ///
			_col(4)"* You" _col(30) "1" _col(35) `"//Replace "You" with your name"' _n ///
			_col(4)"* Next User" _col(30) "2" _col(35) "//Assign a user number to each additional collaborator of this code" _n ///
			_n ///
			_col(4)"*Set this value to the user currently using this file" _n ///
			_col(4)"global user  1" _n ///
			_n ///
			_col(4)"* Root folder globals" _n ///
			_col(4)"* ---------------------" _n ///
			_n ///	
			_col(4)"if "_char(36)"user == 1 {" _n ///
			_col(8)`"global projectfolder "`projectfolder'""' _n ///
			_col(4)"}" _n ///	
			_n ///		
			_col(4)"if "_char(36)"user == 2 {" _n ///
			_col(8)`"global projectfolder ""  //Enter the file path to the projectfolder of next user here"' _n ///
			_col(4)"}" _n ///
			_n ///
			_n ///
			_col(4)"* Project folder globals" _n ///
			_col(4)"* ---------------------" _n _n ///
			_col(4)"global dataWorkFolder " _col(34) `"""' _char(36)`"projectfolder/DataWork""' _n
			
		
		*Write sub devisor starting master and monitor data section section
		writeDevisor `subHandle' 1 FolderGlobals master	
		
		*Create master data folder and add global to folder in master do file
		createFolderWriteGlobal "MasterData"  "dataWorkFolder"  	mastData	 	`subHandle' 

		*Write sub devisor starting master and monitor data section section
		writeDevisor `subHandle' 1 FolderGlobals rawData	
		
		*Create master data folder and add global to folder in master do file
		createFolderWriteGlobal "EncryptedData"  	"dataWorkFolder"  	encryptFolder	 		`subHandle' 

		*Create master data subfolders
		createFolderWriteGlobal "IDMasterKey"  		"encryptFolder"  		masterIdDataSets	 `subHandle'
		
		
		*Write sub devisor starting master and monitor data section section
		writeDevisor `subHandle' 1 FolderGlobals monitor			

		*Write sub devisor starting master and monitor data section section
		writeDevisor `subHandle' 1 End_FolderGlobals	
			
			
		*di "masterDofilePart1a end"
		
	end	

cap program drop 	mdofle_p1_round
	program define	mdofle_p1_round
		
		args   subHandle rndName
		
		local rndName_caps = upper("`rndName'")
		
		*Write devisor starting globals section
		writeDevisor  `subHandle' 1 FolderGlobals
		
		file write  `subHandle' 	///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"*" _n ///	
			_col(4)"*" _col(12) "PART 1:  PREPARING `rndName_caps' FOLDER PATH GLOBALS" _n ///
			_col(4)"*" _n ///			
			_col(4)"*" _col(16) "-Set global to point to the `rndName' folders" _n ///
			_col(4)"*" _col(16) "-Add to these globals as you need" _n ///
			_col(4)"*" _n ///	
			_col(4)"* ******************************************************************** *" _n _n
		
	end	
	
	
cap program drop 	mdofle_p2
	program define	mdofle_p2
		
		args   subHandle 

		di "masterDofilePart2 start"
		
		*Write devisor starting standardization globals section
		writeDevisor  `subHandle' 2 StandardGlobals		
		
		file write  `subHandle' 	///
			_col(4)"* ******************************************************************** *" _n ///
			_col(4)"*" _n ///	
			_col(4)"*" _col(12) "PART 2: - SET STANDARDIZATION GLOBALS AND OTHER CONSTANTS" _n ///
			_col(4)"*" _n ///			
			_col(4)"*" _col(16) "-Set globals with numbers or lists of " _n ///
			_col(4)"*" _col(17) "variables that is supposed to stay the" _n /// 
			_col(4)"*" _col(17) "same across the project." _n /// 
			_col(4)"*" _n ///	
			_col(4)"* ******************************************************************** *" _n
							
		file write  `subHandle' ///
			_n ///	
			_col(4)"* Set all conversion rates used in unit standardization " _n ///
			_col(4)"* accross the whole project here. " _n ///
			_n ///
			_col(4)"**Example. Expand this section with globals for all constant" _n ///
			_col(4)"* scalars used in this project. Reference these globals instead" _n ///
			_col(4)"* of hardcode values each time constant converstion rates are used." _n ///
			_col(4)"*Standardizing to meters" _n ///
			_n ///	
			_col(4)"global foot" _col(20) "= 0.3048" _n ///
			_col(4)"global mile" _col(20) "= 1609.34" _n ///
			_col(4)"global km" 	 _col(20) "= 1000" _n ///
			_n /// 
			_col(4)"**Other examples to be included here could be regression controls" _n ///
			_col(4)"* used across the project. Everything that is constant may be" _n ///
			_col(4)"* included here. One example of something not constant that should" _n ///
			_col(4)"* be included here is exchange rates. It is best practice to have one" _n ///
			_col(4)"* global with the exchange rate here, and reference this each time a" _n ///
			_col(4)"* currency conversion is done. If the currency exchange rate needs to be" _n ///
			_col(4)"* updated, then it only has to be done at one place for the whole project." _n ///
			_n
		
		*Write devisor ending standardization globals section
		writeDevisor  `subHandle' 2 End_StandardGlobals	
		
		di "masterDofilePart2 end"
		
	end	
	
	
cap program drop 	mdofle_p3
	program define	mdofle_p3
		
		args   subHandle itemType rndName rnd

		di "masterDofilePart3 start"

		if "`itemType'" == "project" 	local partNum = 3
		if "`itemType'" == "round"		local partNum = 2
		
		*Write devisor starting the section running sub-master dofiles
		writeDevisor  `subHandle' `partNum' RunDofiles	
		
			file write  `subHandle' 	///
				_col(4)"* ******************************************************************** *" _n 	///
				_col(4)"*" _n 																			///	
				_col(4)"*" _col(12) "PART `partNum': - RUN DOFILES CALLED BY THIS MASTER DO FILE" _n 	///
				_col(4)"*" _n 
				
			if "`itemType'" == "project" {	
				file write  `subHandle' 																///
					_col(4)"*" _col(16) "-When survey rounds are added, this section will" _n 			///
					_col(4)"*" _col(17) "link to the master dofile for that round." _n 					/// 
					_col(4)"*" _col(16) "-The default is that these dofiles are set to not"  _n 		///
					_col(4)"*" _col(17) "run. It is rare that all round specfic master dofiles"  _n 	///
					_col(4)"*" _col(17) "are called at the same time, the round specifc master"  _n 	///
					_col(4)"*" _col(17) "dofiles are almost always called individually. The"  _n 		///
					_col(4)"*" _col(17) "excpetion is when reviewing or replicating a full project." _n 
			} 
			else if "`itemType'" == "round" {	
				file write  `subHandle' 																///
					_col(4)"*" _col(16) "-A task master dofile has been created for each high"  _n 		///
					_col(4)"*" _col(17) "level task (cleaning, construct, analyze). By "  _n 			///
					_col(4)"*" _col(17) "running all of them all data work associated with the "  _n 	///
					_col(4)"*" _col(17) "`rndName' should be replicated, including output of "  _n 		///
					_col(4)"*" _col(17) "tablets, graphs, etc." _n 										/// 
					_col(4)"*" _col(16) "-Feel free to add to this list if you have other high"  _n 	/// 
					_col(4)"*" _col(17) "level tasks relevant to your project." _n 
			}
			
			file write  `subHandle' 	///
				_col(4)"*" _n ///	
				_col(4)"* ******************************************************************** *" _n
		
		if "`itemType'" == "round" {	
			
			file write  `subHandle' 	_n ///
				_col(4)"**Set the locals corresponding to the taks you want" _n ///
				_col(4)"* run to 1. To not run a task, set the local to 0." _n ///
				_col(4)"local cleaningDo" _col(25) "1" _n ///
				_col(4)"local constructDo" _col(25) "1" _n ///
				_col(4)"local analysisDo" _col(25) "1" _n ///
			
			*Create the references to the high level task 
			highLevelTask `subHandle'  "`rndName'" "`rnd'" "cleaning"
			highLevelTask `subHandle'  "`rndName'" "`rnd'" "construct"
			highLevelTask `subHandle'  "`rndName'" "`rnd'" "analysis"
		
		}
		
		*Write devisor ending the section running sub-master dofiles
		writeDevisor  `subHandle' `partNum' End_RunDofiles
						
		di "masterDofilePart3 end"
		
	end	
		
	cap program drop 	highLevelTask 
		program define	highLevelTask
			
			args roundHandle rndName rnd task  
			
			di "highLevelTask start"
			
			*Write section where task master files are called
			file write  `roundHandle' 	_n ///
				_col(4)"if (" _char(96) "`task'' == 1) { //Change the local above to run or not to run this file" _n ///
				_col(8) `"do ""' _char(36) `"`rnd'_do/`task'_MasterDofile.do" "' _n ///
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

			*Copy the new master dofile from the tempfile to the original position
			copy "`taskTextFile'"  "${`rnd'_do}/`rnd'_`task'_Master.do" , replace
			
			
	end		
		
cap program drop 	mdofle_task
	program define	mdofle_task
		
		args subHandle rndName rnd task
		
		local caps = upper("`rndName' `task'")
		
		local suffix 
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
			_n _col(8)"/*" _n 	/// 
			_col(4)"** IDS VAR:" _col(25) "list_ID_var_here		//Uniquely identifies households (update for your project)" _n ///			  
			_col(4)"** NOTES:" _n /// 	  			  
			_col(4)"** WRITEN BY:" _col(25) "names_of_contributors" _n ///
			_col(4)"** Last date modified: `c(current_date)'" _n _n /// 
			_col(4)"*Standardize settings accross users" _n ///
			_col(4)"ieboilstart, version(12.1)" _col(40) "//Set the version number to the oldest version used by anyone in the project team" _n ///
			_col(4) _char(96)"r(version)'" 		_col(40) "//This line is needed to actually set the version from the command above" _n ///
			_n ///
			_col(4)"* ***************************************************** *" _n ///
			_col(4)"*" _col(60) "*" _n ///
			
		
		*Create the sections that calls each tast dofile.
		mdofle_task_dosection `subHandle' "`rnd'" "`task'" 1
		mdofle_task_dosection `subHandle' "`rnd'" "`task'" 2
		mdofle_task_dosection `subHandle' "`rnd'" "`task'" 3

	file write  `subHandle' ///
		_col(4)"* ************************************" _n ///
		_col(4)"*" _col(8) "Keep adding sections for all additional dofiles needed" _n ///
		
		
	end

cap program drop 	mdofle_task_dosection
	program define	mdofle_task_dosection
	
	args subHandle rnd task number
	
	file write  `subHandle' ///
		_col(4)"* ***************************************************** *" _n ///
		_col(4)"*" _n ///
		_col(4)"*" _col(8) "`task' dofile `number'" _n ///
		_col(4)"*" _n ///
		_col(4)"*" _col(8) "The purpose of this dofiles is:" _n ///
		_col(4)"*" _col(10) "(The list below are examples on what to include here)" _n ///
		_col(4)"*" _col(11) "-what additional data sets does this file require" _n ///
		_col(4)"*" _col(11) "-what variables are created" _n ///
		_col(4)"*" _col(11) "-what corrections are made" _n ///
		_col(4)"*" _n ///
		_col(4)"* ***************************************************** *"  _n ///
		_n ///
		_col(8) `"*do ""' _char(36) `"`rnd'`suffix'/dofile`number'.do" //Give your dofile a more informative name, this is just a place holder name"' _n _n
		
	end
