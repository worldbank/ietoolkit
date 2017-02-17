	
	do "$ief\masterdofile_functions.do"
	
	cap program drop 	parseReadLine 
	program define		parseReadLine, rclass
		
		*di "Command ok"
		
		args line
		
		*di "Args ok"
		
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
		
	end
	
	
	
	cap program drop 	newRndFolderAndGlobals 
	program define		newRndFolderAndGlobals 
		
		args rndName rnd dtfld_glb textfile textname
		
		local file_name `textfile' `textname'
		
		*KBKB: test if new fodler can be written - use "cap cd"
		
		*di 1
		
		*Round main folder
	di `"createFolderWriteGlobal "`rndName'" 	 		"`dtfld_glb'"  "`rnd'" 		`file_name'"'	
		
		createFolderWriteGlobal "`rndName'" 	 		"`dtfld_glb'"  "`rnd'" 		`file_name'
		
		*di 2
		
		*Round Data folder
		createFolderWriteGlobal "DataSets" 			 	"`rnd'" 		"`rnd'_dt" 		//`file_name'
		
		*di 2.1
		
		*Round Data sub-folder
		createFolderWriteGlobal "Raw"  					"`rnd'_dt" 		"`rnd'_dtRaw" 	`file_name'
		createFolderWriteGlobal "Intermediate" 			"`rnd'_dt" 		"`rnd'_dtInt" 	`file_name'
		createFolderWriteGlobal "Final"  				"`rnd'_dt" 		"`rnd'_dtFinal" `file_name'
		
		*di 3
		
		*Round dofile folder
		createFolderWriteGlobal "Dofiles" 				"`rnd'"			"`rnd'_do" 		`file_name'
		
		*di 3.1
		
		*Round Data sub-folder
		createFolderWriteGlobal "Dofiles Import "		"`rnd'_do" 		"`rnd'_doImp" 	`file_name'
		createFolderWriteGlobal "Dofiles Cleaning "		"`rnd'_do" 		"`rnd'_doCln" 	`file_name'
		createFolderWriteGlobal "Dofiles Construct "	"`rnd'_do" 		"`rnd'_doCon" 	`file_name'
		createFolderWriteGlobal "Dofiles Analyze "		"`rnd'_do" 		"`rnd'_doAnl" 	`file_name'
		
		*di 4
		
		*Round Output folder
		createFolderWriteGlobal "Output" 				"`rnd'"			"`rnd'_Out"		`file_name'
		
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
			
			di "createFolderWriteGlobal start `folderName'"
			
			if ("`subHandle'" != "") {
				
				file write  `subHandle' ///
					_col(4) `"global `globalName'"' _col(34) ///
					`"""' _char(36)`"`parentGlobal'/`folderName'" "' _n 

			}
			
			global `globalName' "$`parentGlobal'/`folderName'"
			
			noi di `"mkdir "${`parentGlobal'}\\`folderName'""'
			
			mkdir "${`parentGlobal'}\\`folderName'"
			
			di "createFolderWriteGlobal end `folderName'"
	end
	
	
	cap program drop 	writeDevisor 
	program define		writeDevisor , rclass
		
		args  subHandle partNum partName sectionNum sectionName sectionAbb
		
		di "devisor start"
		
		file write  `subHandle' _n "*iefolder*`partNum'*`partName'*`sectionNum'*`sectionName'*`sectionAbb'****************************" 
		file write  `subHandle' _n "*iefolder wont work properly if the line above is edited"  _n _n
		
		di "devisor end"
		
	end
	
	
	
	cap program drop   deleteFolder
		program define deleteFolder
	
		args folder
		
		noi di "`folder'"
		
		local flist : dir `"`folder'"' files "*"
		local dlist : dir `"`folder'"' dirs "*" 
		local olist : dir `"`folder'"' other "*"
		
		
		foreach file of local flist {
			noi di "`folder'\\`file'"
			if "`c(os)'" == "Windows" erase "`folder'\\`file'"
			if "`c(os)'" != "Windows" rm 	"`folder'\\`file'"
		}
		foreach file of local olist {
			noi di "`folder'\\`file'"
			if "`c(os)'" == "Windows" erase "`folder'\\`file'"
			if "`c(os)'" != "Windows" rm 	"`folder'\\`file'"
		}	
		foreach dir of local dlist {
			
			deleteFolder "`folder'\\`dir'"	
		}	
		
		rmdir "`folder'"

	end 
