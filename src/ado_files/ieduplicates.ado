*! version 5.5 26APR2018 DIME Analytics lcardosodeandrad@worldbank.org

	capture program drop ieduplicates
	program ieduplicates , rclass


	qui {

		syntax varname ,  FOLder(string) UNIQUEvars(varlist) [KEEPvars(varlist) tostringok droprest nodaily SUFfix(string)]

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
			
			/***********************************************************************
			************************************************************************

				Section 1 - Set up locals needed in data

				Saving a version of the data to be used before merging corrections 
				back to the original data set and before correcting duplicates

			************************************************************************
			***********************************************************************/
			
			*Tempfiles to be uses
			tempfile originalData preppedReport datawithreportmerged dataToReturn
			
			** Save a version of original data that can be brought 
			*  back withing the preserve/restore section
			save 	`originalData'		
			
			* Create a local with todays date to date the reports
			local  date = subinstr(c(current_date)," ","",.)
			
			*Put idvar in a local with a more descriptive name
			local idvar `varlist'

			** Making one macro with all variables that will be
			*  imported and exported from the Excel file
			local argumentVars `idvar' `uniquevars' `keepvars'
			
			* Create a list of the varaibles created by this command to put in the report
			local excelvars dupListID dateListed dateFixed correct drop newID initials notes			
			
			/***********************************************************************
			************************************************************************

				Section 2 - Test unique vars

				Test the unique vars so that they are identifying the data set and 
				are not in a time format that might get corrupted by exporting to 
				and importing from Excel. This is needed as the uniquevars are needed
				to merge the correct correction to the correct duplicat

			************************************************************************
			***********************************************************************/
			
			*Test that the unique vars fully and uniquely identifies the data set
			cap isid `uniquevars'
			if _rc {
			
				noi display as error "{phang}The variable(s) listed in uniquevars() does not uniquely and fully identifies all observations in the data set.{p_end}"
				isid `uniquevars'
				error 198
				exit			
			}
			
			** Test that no unique vars are time format. Time values might be corrupted 
			*  and changed a tiny bit when importing and exporting to Excel, which make merge not possible
			foreach uniquevar of local uniquevars {
			
				*Test if format is time format
				local format : format `uniquevar'
				if substr("`format'",1,2) == "%t" {
				
					noi display as error `"{phang}The variable {inp:`uniquevar'} listed in {inp:uniquevars()} is using time format which is not allowed. Stata and Excel stores and displays time slightly differently which can lead to small changes in the value when the value is imported and exported between Stata and Excel, and then the variable can no longer be used to merge the report back to the original data. Use another variable or create a string variable out of your time variable using this code: {inp: generate `uniquevar'_str = string(`uniquevar',"%tc")}.{p_end}"'
					noi di ""
					error 198
					exit	
				}
			}			
			

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
				import excel "`folder'/iedupreport`suffix'.xlsx"	, clear firstrow
				
				** All excelvars but dupListID and newID should be string. dupListID 
				*  should be numeric and the type of newID should be based on the user input
				foreach excelvar of local excelvars {
					if !inlist("`excelvar'", "dupListID", "newID") {
						
						* Make original ID var string
						tostring `excelvar' , replace
						replace  `excelvar' = "" if `excelvar' == "."
					}
				}

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

				
				/******************
					Section 3.5
					Save the prepared report to be used later
				******************/				
				
				*Keep only the variables needed for matching and variables used for input in the Excel file
				keep 	`idvar' `uniquevars' `excelvars' `groupAnyCorrection'
				
				*Save imported data set with all corrections
				save	`preppedReport'
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
				merge 1:1 `uniquevars' using `preppedReport', generate(`iedup_merge')

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
			
			*save the data set to be used when correcting the data
			save `datawithreportmerged'

			/***********************************************************************
			************************************************************************

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

			*Test if there are any corrections by new ID
			cap assert missing(newID)
			if _rc {

				local idtype 	: type `idvar'
				local idtypeNew : type newID
				
				*If ID var is string but newID is not, then just make it string
				if substr("`idtype'",1,3) == "str" & substr("`idtypeNew'",1,3) != "str" {

					tostring newID , replace
					replace  newID = "" if newID == "."
				}
				
				*If ID var is numeric but the newID is loaded as string
				else if substr("`idtype'",1,3) != "str" & substr("`idtypeNew'",1,3) == "str" {
				
					* Check if -tostringok- is specificed:
					if "`tostringok'" != "" {

						* Make original ID var string
						tostring `idvar' , replace
						replace  `idvar' = "" if `idvar' == "."

					}

					* Error, IDvar can not be updated
					else {

						* Create a local with all non-numeric values
						levelsof newID if missing(real(newID)), local(NaN_values) clean

						* Output error message
						di as error "{phang}The ID varaible `idvar' is numeric but newID has thes non-numeric values: `NaN_values'. Update newID to only contain numeric values or see option tostringok.{p_end}"
						error 109
						exit
					}
				}
		
				*After making sure that type is ok, update the IDs
				replace `idvar' = newID if !missing(newID)
				


				/******************
				******************/
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

		* Test if varlist is now uniquely and fully identifying the data set
		cap isid `varlist'
		if _rc {

			di as error "{phang}The data set is not returned with `varlist' uniquely and fully identifying the data set. Please report this bug to kbjarkefur@worldbank.org{p_end}"
			error 119
			exit

		}

		if `:list sizeof dup_ids' == 0 {

			noi di	"{phang}There are no unresolved duplicates in this data set. The data set is returned with `varlist' uniquely and fully identifying the data set.{p_end}"
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
