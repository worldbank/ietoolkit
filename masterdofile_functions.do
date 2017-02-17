
	cap program drop 	masterDofilePart0
	program define		masterDofilePart0 
		
		args subHandle	
		
		di "start masterDofilePart0"
		
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

		di "masterDofilePart0 end"
		
		end	
		
		
	cap program drop 	masterDofilePart0a
	program define		masterDofilePart0a
		
		args subHandle	
		
		di "masterDofilePart0a start"
		
		file write  `subHandle' 	///							
							_col(8)"*Install all packages that this project requires:" _n ///
							_col(8)"ssc install ietoolkit" _n ///
							_n	 ///
							_n	 ///
							_col(8)"*Standardize settings accross users" _n ///
							_col(8)"ieboilstart, version(12.1)" _col(40) "//Set the version number to the oldes version used by anyone in the project team" _n ///
							_col(8) _char(96)"r(version)'" 				_col(40) "//This line is needed to actually set the version from the command above" _n
							
		
		di "masterDofilePart0a end"
		
	end


cap program drop 	masterDofilePart1
	program define	masterDofilePart1
		
		args   subHandle 

		di "masterDofilePart1 start"
		
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
							
		di "masterDofilePart1 end"
							
end

cap program drop 	masterDofilePart1a
	program define	masterDofilePart1a	
		
		args   subHandle projectDir
		
		di "masterDofilePart1a start"
							
		file write  `subHandle' ///							
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
							
		di "masterDofilePart1a end"
		
	end	
