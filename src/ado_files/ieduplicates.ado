*! version 5.3 14NOV2017 Kristoffer Bjarkefur kbjarkefur@worldbank.org
	
	capture program drop ieduplicates
	program ieduplicates , rclass
	
	
	qui {

		syntax varname ,  FOLder(string) UNIQUEvars(varlist) [ KEEPvars(varlist) MINprecision(numlist >0) tostringok droprest nodaily SUFfix(string)]
		
		version 11.0
		
		*Add version of Stata fix
		//Make sure that keepvars are still saved if saved if the duplicates file 
		*	is generated on a subset of the data. For example, duplicates from  
		*	version 1, 2 . If the command is run on only version 1. Then values 
		*	for keeepvars in version 2 and 3 are dropped and not reloaded as those 
		*	obs are not in current memory
		
		**Test that observations have not been deleted from the report before readind 
		* it. Deleted in a way that the report does not make sense. Provide an error 
		* message to this that is more informative.

		preserve
			
			noi di ""
		
			** Making one macro with all variables that will be 
			*  imported and exported from the Excel file
			local agrumentVars `varlist' `uniquevars' `keepvars'
			
			** When migrating data from Stata to Excel format, time variables loose precision.
			*  If time varaibles are used for uniquely identifying observations, then this loss 
			*  of precision might make a time variable unfit to merge the observations back 
			*  to Stata after they have been exported to Excel.
			if "`minprecision'" != "" local milliprecision = `minprecision' * 1000 * 60
			
			local excelvars dupListID dateListed dateFixed correct drop newID initials notes
			
			local  date = subinstr(c(current_date)," ","",.)
			
			/***********************************************************************
			************************************************************************
			
				Section 1
				
				Storing format and type of the variables that will be imported and 
				exported from the Excel file. The export and import function may 
				sometimes alter type and format. Merging with different types results
				in an error and format is required for date and time variabels. 
				By using the information stored in this loop, the code can enusre
				that the variables have correct type and format before merging. 
				For more information, see below.
			
			************************************************************************
			***********************************************************************/
			
			local i 0
			foreach var in `agrumentVars' {
			
				local type_`i'		: type		`var'
				local format_`i'	: format 	`var'
				
				if substr("`format_`i''",1,2) == "%t" & substr("`format_`i''",1,3) != "%td" {
		
					if "`minprecision'" != "" replace `var' =  (floor(`var' / `milliprecision')*`milliprecision')
				}
				
				local ++i
			}
			
			/***********************************************************************
			************************************************************************
			
				Section 2
				
				Saving a version of the data to be used before mergin and 
				before correcting duplicates
			
			************************************************************************
			***********************************************************************/		

			tempfile restart
			save 	`restart'
			
			/***********************************************************************
			************************************************************************
				
				Section 3
				
				Import and prepare Corrections (if file exists)
			
			************************************************************************
			***********************************************************************/				
			
			/******************
				Section 3.1
				Check if earlier report exists.
			******************/		
			
			cap confirm file "`folder'/iedupreport`suffix'.xlsx"
			
			if !_rc {
				local fileExists 1
			}
			else {
				local fileExists 0
			}

			/******************
				Section 3.2
				If report exist, load file and check input
			******************/		

			if `fileExists' {
				
				*Load excel file. Load all vars as string and use meta data from Section 1 
				import excel "`folder'/iedupreport`suffix'.xlsx"	, clear firstrow allstring
								
				*dupListID is always numeric
				destring dupListID, replace

				/******************
					Section 3.2.1
					Make sure that the
					ID variable and 
					the uniquevars are 
					not changed since 
					last report.
				******************/										
				
				ds
				local existingexcelvars  `r(varlist)' 
				
				if `:list varlist in existingexcelvars' == 0 {
				
					noi display as error "{phang}ID variable [`varlist'] does not exist in the previously exported Excle file. If you renamed or changed the ID variable, you need to start over with a new file. Rename or move the already existing file. Create a new file and carefully copy any corrections from the old file to the new.{p_end}"
					noi di ""
					error 111
					exit
				 
				}
				if `:list uniquevars in existingexcelvars' == 0 {
				
					noi display as error "{phang}One or more unique variables in [`uniquevars'] do not exist in the previously exported Excel file. If you renamed or changed any variable used in uniquevars(), you need to start over with a new file. Rename or move the already existing file. Create a new file and carefully copy any corrections from the old file to the new.{p_end}"
					noi di ""
					error 111
					exit
				}				
				
				/******************
					Section 3.2.2
					Make sure that all variables are same 
					type and format as in original Stata 
					file regardless of how they were 
					imported from Excel.
				******************/				
				
				local i 0
				foreach argVar in `agrumentVars' {
				
					
					cap confirm variable `argVar' //In case the variable was added since last export
					if !_rc {

						if substr("`type_`i''",1,3) == "str" {
							
							*No need for any action since all varaibles are loaded as string
							
						}
						else if substr("`format_`i''",1,2) == "%t" {
						
							** All variables are loaded as strings. The letters 
							*  in date/time varibles makes -destring- not 
							*  applicable. The code generates a new variable 
							*  that read the date/time string using the date() 
							*  and clock() functions. Then the format from 
							*  Section 1 is applied to the new variable. The old
							*  string variable is dropped and the newly 
							*  generated variable takes its place.
							if substr("`format_`i''",1,3) == "%td" {
								
								*Read date var from string
								gen double	`argVar'_tmp = date(`argVar', "MDY")
							}
							else {
								
								*Read time var from string
								gen double	`argVar'_tmp = clock( `argVar', "MDY hm")
								*Manually applying lower precision. Read more in Section 0 for details
								
								if "`minprecision'" != "" replace `argVar'_tmp =  (floor(`argVar'_tmp / `milliprecision')*`milliprecision')
								
							}
							
							** Order the newly generated var after the imported 
							*  string var, and then drop the string var
							order 	`argVar'_tmp, after(`argVar')
							drop 	`argVar'
							
							** Format the new variable to match its format in 
							*  the original Stata file and then take away the 
							*  _tmp suffix
							format  `argVar'_tmp `format_`i''
							rename 	`argVar'_tmp `argVar'
							
						}
						else {
						
							*Destring numeric variables
							destring `argVar' , replace
						}
					}
					local ++i
				}
				
				/******************
					Section 3.3
					Make sure input is correct
				******************/						
				
				*Temporary variables needed for checking input
				tempvar tmpvar_multiInp tmpvar_inputNotYes tmpvar_maxMultiInp tmpvar_notDrop tempvar_yescorrect tempvar_numcorrect
				
				*Locals indicating in which ways input is incorrect (if any)
				local local_multiInp 		0
				local local_multiCorr		0
				local local_inputNotYes		0
				local local_notDrop			0

				
				/******************
					Section 3.3.1
					Make sure there are not too many corrections
				******************/						
				
				* Count the number of corrections (correct drop newID) per 
				* observation. Only one correction per observation is allowed.
				egen `tmpvar_multiInp' = rownonmiss(correct drop newID), strok
				
				*Check that all rows have utmost one correction
				cap assert `tmpvar_multiInp' == 0 | `tmpvar_multiInp' == 1
				
				if _rc {
				
					*Error will be outputted below
					local local_multiInp 	1
				}
				
				
				/******************
					Section 3.3.2
					Make sure string input is yes or y
				******************/		
				
				* Make string input lower case and change "y" to "yes"
				replace correct = lower(correct)
				replace drop 	= lower(drop)
				replace correct = "yes" if correct 	== "y"
				replace drop 	= "yes" if drop 	== "y"		
				
				*Check that varaibles are wither empty or "yes"
				gen `tmpvar_inputNotYes' = !((correct  == "yes" | correct == "") & (drop  == "yes" | drop == ""))
				
				cap assert `tmpvar_inputNotYes' == 0 
				if _rc {
				
					*Error will be outputted below
					local local_inputNotYes 	1
				}				
				

				/******************
					Section 3.3.3
					Make sure that either option droprest is specified, or that 
					drop was correctly indicated for all observations. i.e.; if 
					correct or newID was indicated for at least one duplicate in
					a duplicate group, then all other observations should be 
					indicated as drop (unless droprest is specified)
					
				******************/		
				
				*Check if any other duplicate in duplicate group has at least one correction
				gen `tempvar_yescorrect' = (correct == "yes")
				bys `varlist' : egen `tempvar_numcorrect' =  total(`tempvar_yescorrect')
				count if `tempvar_numcorrect' > 1
				if `r(N)' != 0 local local_multiCorr 1 
				
				
				*Check if any other duplicate in duplicate group has at least one correction
				bys `varlist' : egen `tmpvar_maxMultiInp' = max(`tmpvar_multiInp')
				
				*Check that drops are explicitly indicated
				gen `tmpvar_notDrop' = (`tmpvar_multiInp' == 0 & `tmpvar_maxMultiInp' > 0)

				* Check if option droprest is specified
				if "`droprest'" != "" {
					cap assert `tmpvar_notDrop' == 0 
					if _rc {

						*Error will be outputted below
						local local_notDrop 	1
					}					
				}
				else {

					** Option -droprest- specified. Drop will be changed to yes 
					*  for any observations without drop or any other correction
					*  explicitly specified if the observation is in a duplicate
					*  group with at least one observation has a correction
					replace drop 	= "yes" if `tmpvar_notDrop' 	== 1

				}
				
				
				/******************
					Section 3.4
					Throw errors if any of the tests were not passed
				******************/		
				
				*Was any error detected
				if `local_multiInp' == 1 | `local_inputNotYes' == 1 | `local_notDrop' == 1 | `local_multiCorr' == 1  {
				
					*Error multiple input
					if `local_multiInp' == 1 {
						noi {
							display as error "{phang}The following observations have more than one correction. Only one correction (correct, drop or newID) per row is allowed{p_end}"
							list `varlist' dupListID correct drop newID if `tmpvar_multiInp' > 1
							di ""
						}
					}
					
					*Error multiple correct
					if `local_multiCorr' == 1 {
						noi {
							display as error "{phang}The following observations are in a duplicate group where more than one observation is listed as correct. Only one observation per duplicate group can be correct{p_end}"
							list `varlist' dupListID correct drop newID if `tempvar_numcorrect' > 1
							di ""
						}

					}                                                              
					
					*Error in incorrect string
					if `local_inputNotYes' == 1 {
						noi {
							display as error "{phang}The following observations have an answer in either correct or drop that is neither yes nor y{p_end}"
							list `varlist' dupListID correct drop if `tmpvar_inputNotYes' == 1
							di ""
						}                                                                              
					}
					
					*Error is not specfied as drop
					if `local_notDrop' == 1 {
						noi {
							display as error "{phang}The following observations are not explicitly indicated as drop while other duplicates in the same duplicate group are corrected. Either manually indicate as drop or see option droprest{p_end}"
							list `varlist' dupListID correct drop newID if `tmpvar_notDrop' == 1
							di ""
						}                                                                              
					}
				
				*Same error for any incorrect input
				error 119
				exit
				}

				
				*Keep only the variables needed for matching and variables used for input in the Excel file
				keep 	`varlist' `uniquevars' `excelvars'
			
				*Save imported data set with all corrections
				tempfile imputfile_merge
				save	`imputfile_merge'
			}
			
			
			/***********************************************************************
			************************************************************************
				
				Section 4
				
				Merge corrections with original data
			
			************************************************************************
			***********************************************************************/				
			

			*Re-load original
			use `restart', clear 
			
			* Merge original data with imported Excel file (if Excel file exists)
			if `fileExists'  {
				
				*Create a tempvar for merging results
				tempvar iedup_merge
				
				*Merge the corrections with the data set
				merge 1:1 `varlist' `uniquevars' using `imputfile_merge', generate(`iedup_merge')
				
				*Make sure that obsrevations listed in the duplicate report is still in the data set
				cap assert `iedup_merge' != 2
				
				*Display error message if assertion is not true and some duplicates in the excle file are no longer in the data set
				if _rc {
				
					display as error "{phang}One or several observations in the Excel report are no longer found in the data set. Always run ieduplicates on the raw data set that include all the duplicates, both new duplicates and those you have already identified. After removing duplicates, save the data set using a different name. You might also recieve this error if you are using an old ieduplicates Excel report on a new data set.{p_end}"
					error 9
					exit
					
				
				}
				
				*Explicitly drop temporary variable. Temporary variables might 
				*be exported to excel so delete explicitly before that. Only 
				*using tempvar here to create a name with no conflicts
				drop `iedup_merge'
				
			}
		
			/***********************************************************************
			************************************************************************
				
				Section 5
				
				Drop all but one observations that are duplicates in all variables
			
			************************************************************************
			***********************************************************************/				
			
			tempvar id_string allDup  
			
			/******************
				Section 5.1
				Next section 5.2 needs the ID var in the same type for the 
				if statement in duplicates drop. And since all numeric variables 
				can be expressed as string, we generate an temporary variable 
				that is always string.
			******************/		
			
			*Test if ID var is already string
			cap confirm string variable `varlist'
			
			*if ID var not string:
			if _rc {
				*Generate string copy of ID var
				tostring `varlist' , generate(`id_string') force
			}
			
			*if ID var is string:
			else {
				*Simply copy the ID var to the temporary variable
				gen `id_string' = `varlist'
			}

			/******************
				Section 5.2
				Throw errors if any of the tests was not passed
			******************/		
			
			** Generate variables that are not 0 if any observations are 
			*  duplicates in all variables
			duplicates tag , gen(`allDup')

			*Test if any observations is duplicates in all variables	
			count if `allDup' != 0
			if `r(N)' != 0 {
				
				* Output message indicating that some observations 
				* were dropped automatically as they were duplicates 
				* in all variables.
				noi di "{phang}The following IDs are duplicates in all variable so only one version is kept. The other observations in the same duplicate group are automatically dropped:{p_end}"
				
				*Create a local of all IDs that are to be deleted.
				levelsof `id_string' if `allDup' != 0
				foreach alldupID in `r(levels)' {
					
					*Output the ID
					noi di "{phang2}ID: `alldupID'{p_end}"
					
					*Drop all but one duplicates in duplicate 
					*groups that are duplicated in all variables
					duplicates drop 	if `id_string' == "`alldupID'",  force
				}
				
				*Add an empty row after the output
				noi di ""
			}
			
			
			** Save data set including dropping duplicates in all variables. 
			*  The command returns the data set without these observations.
			save `restart', replace

			/***********************************************************************
			************************************************************************
				
				Section 6
				
				Test if there are duplicates in ID var. If any duplicates exist, 
				tehn update the Excel file with new and unaddressed cases
			
			************************************************************************
			***********************************************************************/				

			/******************
				Section 6.1
				Test if there are any duplicates in ID var
			******************/	
			
			* Generate variable that is not 0 
			* if observation is a duplicate
			tempvar dup
			duplicates tag `varlist', gen(`dup')
			
			*Test if there are any duplicates
			cap assert `dup'==0
			if _rc { 
				
				/******************
					Section 6.2
					Test if the variables passed as ID var and unique var 
					uniquely and fully identify the data set. It should be 
					possible to merge corrections back to the main file.
					
				******************/					
				
				cap isid 	`varlist' `uniquevars'
				if _rc {

					display as error "{phang}ID variable `varlist' does not uniquely identify the observations in the data set together with the uniquevars: `uniquevars'. This is needed for exactly merging the right correction to the right observation{p_end}"
					error 119
					exit
				}
			
				/******************
					Section 6.3
					Keep only duplicates for the report
				******************/				
				
				*Keep if observation is part of duplicate group 
				keep if `dup' != 0
				
				if `fileExists'  {
					* If Excel file exists keep excel vars and
					* variables passed as arguments in the
					* command 
					keep 	`agrumentVars' `excelvars' 
				}
				else {
					* Keep only variables passed as arguments in 
					* the command and the string ID var as no Excel file exists
					keep 	`agrumentVars'
					
					*Generate the excel variables used for indicating correction 
					foreach excelvar of local excelvars {
						
						*Create all variables apart from dupListID as string vars
						if "`excelvar'" == "dupListID" {
							gen `excelvar' = .
						}
						else {
							gen `excelvar' = ""
						}
					}
				
				}

				/******************
					Section 6.4
					Update the excel vars that are not updated manually
				******************/		
				
				* Generate a local that is 1 if there are new duplicates
				local unaddressedNewExcel 0
				count if dateFixed == ""
				if `r(N)' > 0 local unaddressedNewExcel 1
				
				/******************
					Section 6.4.1 Date variables
				******************/		
				
				* Add date first time duplicvate was identified
				replace dateListed 	= "`date'" if dateListed == ""
		
				** Add today's date to variable dateFixed if dateFixed 
				*  is empty and at least one correction is added
				replace dateFixed 	= "`date'" if dateFixed == "" & (correct != "" | drop != "" | newID != "")

				/******************
					Section 6.4.2 Duplicate report list ID
				******************/	
				
				** Sort after dupListID and after ID var for 
				*  duplicates currently without dupListID 
				sort dupListID `varlist'
				
				** Assign dupListID 1 to the top row if no duplicate 
				*  list IDs have been generated so far.
				replace dupListID = 1 if _n == 1 & dupListID == .
				
				** Generate new IDs based on the row above instead of directly
				*  from the row number. That prevents duplicates in the list in
				*  case an observation is deleted. The first observation with 
				*  missing value will have an ID that is one digit higher than 
				*  the highest ID already in the list
				replace dupListID = dupListID[_n - 1] + 1 if dupListID == .		

				
				/******************
					Section 6.5
					Keep and order the variables and output the Excel files
				******************/
				
				* If cases unaddressed then update the Excel file
				if `unaddressedNewExcel'  {

					keep 	`agrumentVars' `excelvars'
					order	`varlist' `excelvars' `uniquevars' `keepvars' 

					if "`daily'" == "" { 
							
							
						*Returns 0 if folder does not exist, 1 if it does
						mata : st_numscalar("r(dirExist)", direxists("`folder'/Daily"))
						
						** If the daily folder is not created, just create it
						if `r(dirExist)' == 0  {
							
							*Create the folder since it does not exist
							mkdir "`folder'/Daily"
						}
						
						*Export the daily file
						cap export excel using "`folder'/Daily/iedupreport`suffix'_`date'.xlsx"	, firstrow(variables) replace nolabel 
						
						*Print error if daily report cannot be saved
						if _rc {
							
							display as error "{phang}There the Daily copy could not be saved to the `folder'/Daily folder. Make sure to close any old daily copy or see the option nodaily{p_end}"	
							error 603
							exit
						
						}
						
						*Prepare local for output
						local daily_output "and a daily copy have been saved to the Daily folder"
					}
					
					
					*Export main report
					export excel using "`folder'/iedupreport`suffix'.xlsx"	, firstrow(variables) replace  nolabel 
					
					*Produce output
					noi di `"{phang}Excel file created at: {browse "`folder'/iedupreport`suffix'.xlsx":`folder'/iedupreport`suffix'.xlsx} `daily_output'{p_end}"'
					noi di ""
				}
			}
		
		
		
		/***********************************************************************
		************************************************************************
			
			Section 7
			
			Update the data set and with the new corrections.
		
		************************************************************************
		***********************************************************************/	

		* Load the original data set merged with correction. Duplicates 
		* in all variables are already dropped in this data set
		use 	`restart', clear
		
		* If excel file exists, apply any corrections indicated (if any)
		if `fileExists' {
			
			/******************
				Section 7.1
				Drop duplicates listed for drop
			******************/
				
			drop if drop == "yes"

			/******************
				Section 7.2
				Update new ID. ID var can be either numeric or 
				string. All numbers can be made strings but not 
				all strings can be numeric. Therefore this 
				section is complicated.
			******************/			
			
			/******************
				Section 7.2.1
				ID var in original file is string. Either 
				newID was imported as string or the variable
				is made string. Easy.
			******************/	
			
			* If ID variable is string in original Stata file
			if substr("`type_0'",1,3) == "str" {
				
				* Tostring the newID
				tostring newID , replace
				* Replace missing value with the empty string
				replace  newID = "" if newID == "."
				* Update ID
				replace `varlist' = newID if newID != ""
			}
			
			
			/******************
				Section 7.2.2
				ID var in original file is numeric. Test first
				if newID is numeric or can be made numeric.
			******************/				
			
			* ID var is numeric
			else {
				
				** Trying to convert newID. If newID is already numeric, nothing
				*  happens. If it is not possible to make it numeric (having 
				*  non-numeric characters), then it will remain as string.
				destring newID, replace
				* Test if newID now is numeric
				cap confirm numeric variable newID

				
				/******************
					Section 7.2.2.1
					newID is numeric and original ID can easily be updated.
				******************/		
				
				if !_rc {
					replace `varlist' = newID if newID != .
				}

				/******************
					Section 7.2.2.2
					newID cannot be made numeric but origianl ID var is numeric.
					To update original ID var, it has to be made a string, but 
					that will be allowed only if option tostringok is specified.
				******************/						
				
				else {

					* Check if -tostringok- is specificed:
					if "`tostringok'" != "" {
						
						* Make original ID var string
						tostring `varlist' , replace
						* Replace any missing values with empty string
						replace  `varlist' = "" if `varlist' == "."
						* Update the original ID var with value in newID
						replace  `varlist' = newID if newID != ""
						
					}
					
					* Error, IDvar can not be updated
					else {
						
						* Create a local with all non-numeric values
						levelsof newID if missing(real(newID)), local(NaN_values) 

						* Output error message
						di as error "{phang}`varlist' is numeric but newID has thes non-numeric values `NaN_values'. Update newID to only contain numeric values or see option tostringok{p_end}"
						error 109
						exit
					}
				}
			}
			
			/******************
				Section 7.3
				Test that values in newID
				were neither used twice 
				nor already existed
			******************/
			
			* Loop over all values in newID
			levelsof newID 
			foreach  newID in `r(levels)' {
				
				/******************
					Section 7.1
					Different test depending on ID var being string 
					or numeric. Count number of observations with each
					of the values used in newID and test that that 
					the number is exactly one for each value.
				******************/				
				
				if substr("`type_0'",1,3) == "str" {
					count if `varlist' 	== "`newID'"
				}
				else {
					count if `varlist' 	== `newID'					
				}
				
				if `r(N)'	== 1 {
				
					*Do nothing, each value in newID should be used exactly once.
				}
				else if `r(N)' 	== 0 {
				
					di as error "{phang}New ID value `newID' used as a correction in the Excel file is after corrections was never used. Please ensure that `newID' is a valid input. If problem remains, please report this bug to kbjarkefur@worldbank.org{p_end}"
					error 119
					exit
				}
				else {
				
					di as error "{phang}New ID value `newID' used as a correction in the Excel file is after corrections used in `r(N)' obsevations. New ID value `newID' is already used in original data or is used more than once in the Excel file to correct duplicates{p_end}"
					error 119
					exit
				}
			}
			
			/******************
				Section 7.4
				Drop Excel vars 
			******************/	
			
			drop `excelvars'
		}
		
		/***********************************************************************
		************************************************************************
			
			Section 8
			
			Return the data set without duplicates and 
			output information regarding unresolved duplicates.  
		
		************************************************************************
		***********************************************************************/	

		* Generate a variable that is 1 if the observation is a duplicate in varlist
		tempvar dropDup
		duplicates tag `varlist',  gen(`dropDup')
		* Generate a list of the IDs that are still duplicates
		levelsof `varlist' 			if `dropDup' != 0 , local(dup_ids) clean
		* Drop the duplicates (they are exported in Excel)
		drop 						if `dropDup' != 0
		
		* Test if varlist is now uniqely and fully identifying the data set 
		cap isid `varlist'
		if _rc {
		
			di as error "{phang}The data set is not returned with `varlist' uniqely and fully identifying the data set. Please report this bug to kbjarkefur@worldbank.org{p_end}"
			error 119
			exit
			
		}
		
		if `:list sizeof dup_ids' == 0 {
		
			noi di	"{phang}There are no unresolved duplicates in this data set. The data set is returned with `varlist' uniqely and fully identifying the data set.{p_end}"
		}
		else {
			noi di	"{phang}There are `:list sizeof dup_ids' duplicates unresolved. IDs still contining duplicates: `dup_ids'. The unresolved duplicate observations were exported in the Excel file. The data set is returned without those duplicates and with `varlist' uniquely and fully identifying the data set.{p_end}"
		}
		
		return scalar numDup	= `:list sizeof dup_ids'
		
		/***********************************************************************
		************************************************************************
			
			Section 9
			
			Save data set to be returned outside preserve/restore. 
			Preserve/restore is used so that original data is returned 
			in case an error is thrown.
		
		************************************************************************
		***********************************************************************/	

		tempfile returndata
		save 	`returndata'
		
		restore
		
		** Using restore above to return the data to 
		*  the orignal data set in case of error.
		use `returndata', clear
	
	}
	end
	
