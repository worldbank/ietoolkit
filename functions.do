	
	cap program drop 	parseReadLine 
	program define		parseReadLine, rclass
		
		args line
		
		tokenize  `"`line'"' , parse("*")
		
		
		if `"`1'"' == "*" & `"`2'"' == "iefolder" {
			
			*di 1
			
			local partNum  		"`4'"
			local partName 		"`6'"
			local sectionNum 	"`8'"
			local sectionName 	"`10'"
			local sectionAbb 	"`12'"

			return scalar ief_line 	= 1			
			
			return local partNum  "`partNum'"
			return local partName "`partName'" 			
			
			*di 2
			
			local sectPrefix = substr("`partName'",1,4)
			
			if "`sectPrefix'" == "End_" {
			
				*di 3
			
				return scalar ief_end 	= 1
				

				
			}
			else {
			
				*di 4
			
				return scalar ief_end 	= 0
				 
				return local sectionNum 	"`sectionNum'" 
				return local sectionName	"`sectionName'" 
				return local sectionAbb 	"`sectionAbb'" 
		
			}
		
		}
		else {
		
			*di 5 
			return scalar ief_line 	= 0
			return scalar ief_end 	= 0
		
		}
		
		*di "parseReadLine end"
		
	end
	
	
	
	cap program drop 	newRndFolderAndGlobals 
	program define		newRndFolderAndGlobals 
		
		args rndName rnd dtfld_glb subHandle
		
		*KBKB: test if new fodler can be written - use "cap cd"
		
		*di 1
		
		*Round main folder
	*di `"createFolderWriteGlobal "`rndName'" 	 		"`dtfld_glb'"  "`rnd'" 		`subHandle'"'	
		
		createFolderWriteGlobal "`rndName'" 	 		"`dtfld_glb'"  "`rnd'" 		`subHandle'
		
		*di 2
		
		*Round Data folder
		createFolderWriteGlobal "DataSets" 			 	"`rnd'" 		"`rnd'_dt" 		//`subHandle'
		
		*di 2.1
		
		*Round Data sub-folder
		createFolderWriteGlobal "Raw"  					"`rnd'_dt" 		"`rnd'_dtRaw" 	`subHandle'
		createFolderWriteGlobal "Intermediate" 			"`rnd'_dt" 		"`rnd'_dtInt" 	`subHandle'
		createFolderWriteGlobal "Final"  				"`rnd'_dt" 		"`rnd'_dtFinal" `subHandle'
		
		*di 3
		
		*Round dofile folder
		createFolderWriteGlobal "Dofiles" 				"`rnd'"			"`rnd'_do" 		`subHandle'
		
		*di 3.1
		
		*Round Data sub-folder
		createFolderWriteGlobal "Dofiles Import "		"`rnd'_do" 		"`rnd'_doImp" 	`subHandle'
		createFolderWriteGlobal "Dofiles Cleaning "		"`rnd'_do" 		"`rnd'_doCln" 	`subHandle'
		createFolderWriteGlobal "Dofiles Construct "	"`rnd'_do" 		"`rnd'_doCon" 	`subHandle'
		createFolderWriteGlobal "Dofiles Analyze "		"`rnd'_do" 		"`rnd'_doAnl" 	`subHandle'
		
		*di 4
		
		*Round Output folder
		createFolderWriteGlobal "Output" 				"`rnd'"			"`rnd'_Out"		`subHandle'
		
		*Round Survey Documentation folder
		createFolderWriteGlobal "Survey Documentation" "`rnd'"	 		"`rnd'_doc"	

		*Questionnaire
		createFolderWriteGlobal "Questionnaire" 		"`rnd'"	 		"`rnd'_quest"		
		
		*Questionnaire subfolders
		createFolderWriteGlobal "QuestionnaireProgramming" 	"`rnd'_quest"	 	"`rnd'_questPro"			
		createFolderWriteGlobal "FinalQuestionnaire" 			"`rnd'_quest"	 	"`rnd'_questFin"	
		createFolderWriteGlobal "PreloadData"	 				"`rnd'_quest"	 	"`rnd'_preload"	
		
	end
	
	
	cap program drop 	createFolderWriteGlobal 
		program define	createFolderWriteGlobal 
		
		args  folderName parentGlobal globalName subHandle
			
			*di "createFolderWriteGlobal start `folderName'"
			
			if ("`subHandle'" != "") {
				
				file write  `subHandle' ///
					_col(4) `"global `globalName'"' _col(34) ///
					`"""' _char(36)`"`parentGlobal'/`folderName'" "' _n 

			}
			
			global `globalName' "$`parentGlobal'/`folderName'"
			
			*noi di `"mkdir "${`parentGlobal'}\\`folderName'""'
			
			mkdir "${`parentGlobal'}\\`folderName'"
			
			*di "createFolderWriteGlobal end `folderName'"
	end
	
	
	cap program drop 	writeDevisor 
	program define		writeDevisor , rclass
		
		args  subHandle partNum partName sectionNum sectionName sectionAbb
		
		*di "devisor start"
		
		file write  `subHandle' _n "*iefolder*`partNum'*`partName'*`sectionNum'*`sectionName'*`sectionAbb'****************************" 
		file write  `subHandle' _n "*iefolder wont work properly if the line above is edited"  _n _n
		
		*di "devisor end"
		
	end
	
	
	


	/*
	
		The functions below are all related to write the mostly 
		static part of the master do file

	*/
	
	
	cap program drop 	masterDofilePart0
	program define		masterDofilePart0 
		
		args subHandle	
		
		*di "start masterDofilePart0"
		
		file write  `subHandle' ///
				_col(4)"* ******************************************************************** *" _n ///
				_col(4)"* ******************************************************************** *" _n ///
				_col(4)"*" _col(75) "*" _n ///
				_col(4)"*" _col(20) "your_project_name" _col(75) "*" _n ///
				_col(4)"*" _col(20) "MASTER DO_FILE" _col(75) "*" _n ///
				_col(4)"*" _col(75) "*" _n ///
				_col(4)"* ******************************************************************** *" _n ///
				_col(4)"* ******************************************************************** *" _n ///
				_n
				
		file write  `subHandle'	/// 
				_col(8)"/*" _n ///
				_col(8)"** PURPOSE:" _col(25) "Write intro to project here" _n ///
				_n ///					
				_col(8)"** OUTLINE:" _col(25) "PART 0: Configure settings for memory etc." _n ///
				_col(25) "PART 1: Set globals for dynamic file paths" _n ///
				_col(25) "PART 2: Set globals for constants and varlist" _n ///
				_col(32) "used across the project. Intall custom" _n ///
				_col(32) "commands needed." _n ///
				_col(25) "PART 3: Call the task specific master do-files " _n ///
				_col(32) "that call all do-files needed for that " _n ///
				_col(32) "tas. Do not include Part 0-2 in a task" _n ///
				_col(32) "specific master do-file" _n ///
				_n _n
		
		file write  `subHandle'	/// 
				_col(8)"** REQUIRES:" _col(25) "List all data sets using the globals that you " _n ///
				_col(25) "define below to indicate what data you will need" _n ///
				_n ///					
				_col(25) "Example:" _n ///
				_col(25) _char(36)"BL_dtRaw/baseline_survey_v1.csv" _n ///
				_col(25) _char(36)"BL_dtRaw/baseline_survey_v2.csv" _n ///
				_col(25) _char(36)"moniData/monitor2016_data.xlsx" _n ///
				_n 
				
		file write  `subHandle'	/// 		
				_col(8)"** CREATES:" _col(25) "List all data sets using the globals that you " _n ///
				_col(25) "define below to indicate what data set are " _n ///
				_col(25) "created by the do-files this master do-file calls" _n ///
				_n ///					
				_col(25) "Example:" _n ///
				_col(25) _char(36)"BL_dtFinal/baseline_clean.dta" _n ///
				_col(25) _char(36)"BL_dtFinal/baseline_constructs.dta" _n ///
				_col(25) "Multiple tables and grahps in \$BL_Out" _n ///
				_n
				
		file write  `subHandle'	/// 
				_col(8)"** IDS VAR:" _col(25) "list_ID_var_here		//Uniquely identifies households (update for your proejct)" _n ///
				_n	///				  
				_col(8)"** NOTES:" _n /// 	  
				_n ///				  
				_col(8)"** WRITEN BY:" _col(25) "names_of_contributors" _n ///
				_n ///
				_col(8)"** Last date modified:" _n /// 
				_n ///
				_col(8)"*/" _n
		
		*di "masterDofilePart0 end"
		
	end
				
	cap program drop 	masterDofilePart0a
	program define		masterDofilePart0a
		
		args subHandle	
		
		*di "start masterDofilePart0"			
				
				
		file write  `subHandle'	/// 		
				_col(4)"* ******************************************************************** *" _n ///
				_col(4)"*" _n ///
				_col(4)"*" _col(12) "PART 0:  Install packages and standardizer settings" _n ///
				_col(4)"*" _n ///
				_col(4)"*" _col(16) "-Install packages needed to run all dofiles called" _n ///
				_col(4)"*" _col(17) "by this master dofile." _n ///
				_col(4)"*" _col(16) "-Use ieboilstart to harmonize settings" _n ///
				_col(4)"*" _n ///								
				_col(4)"* ******************************************************************** *" _n  


		
		file write  `subHandle' 	///							
							_col(8)"*Install all packages that this project requires:" _n ///
							_col(8)"ssc install ietoolkit" _n ///
							_n	 ///
							_n	 ///
							_col(8)"*Standardize settings accross users" _n ///
							_col(8)"ieboilstart, version(12.1)" _col(40) "//Set the version number to the oldes version used by anyone in the project team" _n ///
							_col(8) _char(96)"r(version)'" 				_col(40) "//This line is needed to actually set the version from the command above" _n
							
		
		*di "masterDofilePart0a end"
		
	end


cap program drop 	masterDofilePart1
	program define	masterDofilePart1
		
		args   subHandle projectDir

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
							_col(8)`"global projectfolder "`projectDir'""' _n ///
							_col(4)"}" _n ///	
							_n ///		
							_col(4)"if "_char(36)"user == 2 {" _n ///
							_col(8)`"global projectfolder ""  //Enter the file path to the projectfolder of next user here"' _n ///
							_col(4)"}" _n ///
							_n ///
							_n ///
							_col(4)"* Project folder globals" _n ///
							_col(4)"* ---------------------" _n 
							
		*di "masterDofilePart1a end"
		
	end	

	
cap program drop 	masterDofilePart2
	program define	masterDofilePart2
		
		args   subHandle 

		di "masterDofilePart2 start"
		
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
							_col(4)"* currency conversion is done. If the currency exchange reate needs to be" _n ///
							_col(4)"* updated, then it only has to be done at one place for the whole project." _n ///
							_n
							
		di "masterDofilePart2 end"
		
	end	
	
	
cap program drop 	masterDofilePart3
	program define	masterDofilePart3
		
		args   subHandle 

		di "masterDofilePart3 start"
		
		file write  `subHandle' 	///
							_col(4)"* ******************************************************************** *" _n ///
							_col(4)"*" _n ///	
							_col(4)"*" _col(12) "PART 3: - RUN ROUND SPECIFIC MASTER DOFILES " _n ///
							_col(4)"*" _n ///			
							_col(4)"*" _col(16) "-When survey rounds are added, this section will" _n ///
							_col(4)"*" _col(17) "link to the master dofile for that round." _n /// 
							_col(4)"*" _col(16) "-The dofiles for the master data set is not" _n ///
							_col(4)"*" _col(17) "linked to by default, as the master data set" _n ///
							_col(4)"*" _col(17) "should be updated with great care." _n /// 
							_col(4)"*" _n ///	
							_col(4)"* ******************************************************************** *" _n
							
						
		di "masterDofilePart3 end"
		
	end	
		
	
	*******************************************************************************************************************************************
*										(the do-files here is just an example)
*
*										This section should run all dofiles needed from raw 
*										data to analysis to outputs. This section should be 
*										written in a way that anyone new to the project should
*										still be able to follow what is going on in the data folder.
*******************************************************************************************************************************************	 
	
	
	

