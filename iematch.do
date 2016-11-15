	
	clear all

	
	
	*command starts here
	
	cap program drop 	iematch
	    program define	iematch
		
		syntax  [if] [in]  , ///
			GRPdummy(varname) 		///
			MATCHvar(varname) 		///
			[						///
			idvar(varname)			///
			m1						///
			matchidname(string)		///
			matchdiffname(string)	///
			matchnoname(string)		///
			matchcount(string)		///
			maxdiff(numlist max = 1 min = 1) ///
			]						
		
		*****
		*1 format errors as smcl
		*2 option to disable countdown
		*3 test not matchcount without m1
		*4 test that tmt are not more than ctrl if one to one
		
		noi di "Syntax OK!"
		
		pause on
		
		qui {
		
		********************************
		*
		*	Gen temp sort and merge var
		*
		********************************		
		
		tempvar originalSort
		
		gen `originalSort' = _n
		
		preserve
		
*Testing input
if 1 {		
		
			if "`if'`in'" != "" keep `if'`in'
			
			********************************
			*
			*	Checking group dummy
			*
			********************************
			
			*Test that the group dummy is 1, 0 or missing
			cap assert inlist(`grpdummy', 1, 0, .) | `grpdummy' > .
			if _rc != 0 {
			
				di as error "The variable in grpdummy(`grpdummy') is not a dummy variable. The variable is only allowed to have the values 1, 0 or missing. Observations with missing varaibles in the grpdummy are ignored by this command."
				error _rc
			}
			
			**Exclude obs with missing value in groupdummy
			
			*Count number of obs to be dropped and and output that number if more than zero
			count if missing(`grpdummy')
			if `r(N)' > 0 {
				*This is not an error just outputting the number
				noi di "{pstd}`r(N)' observation(s) were excluded due to missing value in group dummy{p_end}"
			}
			*Drop obs with missing
			drop if missing(`grpdummy')
		
			
			********************************
			*
			*	Checking match continous var
			*
			********************************
			
			*Test that the continous is numeric
			cap confirm numeric variable `matchvar'
			if _rc != 0 {
				
				di as error "The variable to match on specified in matchvar(`matchvar') is not a numeric variable."
				error 109
			
			}

			**Exclude obs with missing value in groupdummy
		
			*Count number of obs to be dropped and and output that number if more than zero
			count if missing(`matchvar')
			if `r(N)' > 0 {
				*This is not an error just outputting the number
				noi di "{pstd}`r(N)' observation(s) were excluded due to missing value in match varaible{p_end}"
			}
			*Drop obs with missing
			drop if missing(`matchvar')
			
			********************************
			*
			*	Checking duplicates in varaible names in options
			*
			********************************			
		
			*Create a local of all varnames used in any option
			local allnewvars `idvar' `matchidname' `matchdiffname' `matchnoname'
			
			*Check if there are any duplicates in the local of all varnames in options
			local dupnewvars : list dups allnewvars
			
			*Throw error if there were any duplicates
			if "`dupnewvars'" != "" {
			
				di as error "The same variable name was used twice or more in the options. Go back and check syntax"
				error 198

			}
		
		
			********************************
			*
			*	Checking ID var
			*
			********************************
			
			
			*Checking set-up for the ID var used for _matchID
			if "`idvar'" == "" {

				*Copy this name 
				local idvar _ID		
			
				*Make sure that the default name _ID is not already used
				cap confirm variable `idvar'
				if _rc == 0 {
				
					di as error "A variable with name `idvar' is already defined. Either drop this variable or specify a variable using idvar() that fully and uniquely identifies the data set."
					error 110
				
				}
				
				*Generate the ID var from row number
				gen `idvar' = _n
				
			} 
			else {
				
				*Make sure that user specified ID is uniquely and fully identifying the observations
				cap isid `idvar'
				if _rc != 0 {
				
					di as error "Variable `idvar' specified in idvar() does not fully and uniquely identify the observations in the data set. Meaning that `idvar' is not allowed to have any duplicates or missing values. Make `idvar' uniquly and fully idnetifying or exclude the varaibleas using if or in."
					error 450
				
				}
			}
			
			********************************
			*
			*	Checking and generating the MatchID and the MatchDiff var
			*
			********************************		

			
			*Test input from user or test if deafault value is valiable			
			iematchMatchVarCheck _matchID `matchidname' 
			local matchIDname "`r(validVarName)'"
			gen  `matchIDname' = .
	
			if "`m1'" != "" {
			
				iematchMatchVarCheck _matchCount `matchcount' 
				local matchCountName "`r(validVarName)'"
				gen `matchCountName' = .	
				
			}	
	
			iematchMatchVarCheck _matchDiff `matchdiffname' 
			local matchDiffName "`r(validVarName)'"
			gen `matchDiffName' = .
			
			iematchMatchVarCheck _matchOrReason `matchnoname' 
			local matchReasonName "`r(validVarName)'"
			gen `matchReasonName' = .	
			


			*Create a label for missing values that explains no match
			label define matchLabel 0 "Not Matched" 1 "Matched" .n "Obs not included in match" .m "No match within maxdiff" 
			
			*Apply the label
			label value `matchReasonName' matchLabel
		
}		

		
		
			********************************
			*
			*	Creating tempvar used
			*
			********************************
			
			*Initiate the temporary variables used by this command
			tempvar prefID prefDiff matched  
		
			gen `prefID' 		= .
			gen `prefDiff' 		= .
			gen byte `matched' 	= 0
			
			
			** Generate the inverse of the matchvar to sort descending (gsort is too slow),
			*  a random var to seperate two values with the same match var, and the inverse 
			*  of the random var for when sorting descending.
			tempvar rand invsort invrand
			
			sort `matchvar'
			gen  `invsort' = -1 * `matchvar'
			
			gen    `rand' = uniform()
			gen `invrand' = -1 * `rand'

			
			
			tempvar					 diffup   diffdo   valUp_0   valDo_0   valUp_1   valDo_1   IDup   IDdo   IDup_0   IDdo_0   IDup_1   IDdo_1
			local 	 updownTempVars `diffup' `diffdo' `valUp_0' `valDo_0' `valUp_1' `valDo_1' `IDup' `IDdo' `IDup_0' `IDdo_0' `IDup_1' `IDdo_1'
			
			foreach tempVar of local updownTempVars {
			
				gen `tempVar' = .
			
			}
			
			
			
		********************************
		*	Start matching
		********************************		
						
			***************************
			*
			*	One to one match
			*
			***************************
			
			if "`m1'" == "" {
			
				noi di ""
				noi di "{pstd}Observations left to match: {p_end}"
				count if `grpdummy' == 1 & `matched' == 0
				local left2Match = `r(N)'		
				noi di "{pstd}`left2Match' " _c		
				
				while (`left2Match' > 0) {
					
					**For all observations still to be matched, assign the preferred 
					* match among the other unmatched observations
					qui updatePrefDiffPreffID `prefID' `prefDiff' `matchvar' `invsort' `idvar' `grpdummy' `matched' `rand' `invrand' `updownTempVars'
								
					if "`maxdiff'" != "" {
					
						replace `matched' 			= 1		if `prefDiff' > `maxdiff' & `grpdummy' == 1
						replace `prefID'			= .		if `prefDiff' > `maxdiff'  
						replace `matchReasonName' 	= .m 	if `prefDiff' > `maxdiff' & `grpdummy' == 1
					}
					
					replace `matched' = 1 if `matched' == 0 & `prefID' == `idvar'[_n-1] & `prefID'[_n-1] == `idvar'
					replace `matched' = 1 if `matched' == 0 & `prefID' == `idvar'[_n+1] & `prefID'[_n+1] == `idvar'
					
					count if `grpdummy' == 1 & `matched' == 0
					local left2Match = `r(N)'
					noi di "`left2Match' " _c	
					
				}
				noi di "{p_end}" _c
			
			}
			
			***************************
			*
			*	Many to one match
			*
			***************************
			else {
				
				
				updatePrefDiffPreffID `prefID' `prefDiff' `matchvar' `invsort' `idvar' `grpdummy' `matched' `rand' `invrand' `updownTempVars'
				
				if "`maxdiff'" != "" {
				
					replace `matched' 			= 1		if `prefDiff' > `maxdiff' & `grpdummy' == 1
					replace `prefID'			= .		if `prefDiff' > `maxdiff'  
					replace `matchReasonName' 	= .m 	if `prefDiff' > `maxdiff' & `grpdummy' == 1
				}
				
				replace `prefID'			=  `idvar' if `grpdummy' == 0
				bys 	`prefID' 			:   replace `matchCountName' = _N
				replace `prefID' 			= . if  	`matchCountName' == 1
				replace  `matchCountName'	= . if  	`matchCountName' == 1

				replace `matched' = 1 if !missing(`prefID')				
			}
			
			
			*Return vars
			replace `matchDiffName' 	= `prefDiff'	if `matched' == 1
			replace `matchIDname' 		= `idvar' 		if `matched' == 1 & `grpdummy' == 0 
			replace `matchIDname' 		= `prefID' 		if `matched' == 1 & `grpdummy' == 1			
			
			*Target obs not used
			replace `matchReasonName' = 0 if `matched' == 0 & `grpdummy' == 0

			*only keep output vars
			keep `matchIDname' `matchDiffName' `idvar' `originalSort' `matchReasonName' `matchCountName' 
			
			tempfile mergefile
			
			save `mergefile'

		restore
		
		tempvar mergevar
		
		merge 1:1  `originalSort' using `mergefile', gen(`mergevar')
		
		replace `matchReasonName' = .n if `mergevar' == 1
		
		replace `matchReasonName' = 1 if `matchReasonName' == .
		
		noi tab `matchReasonName' `grpdummy', m
		
		sort `originalSort'
		
	}
	
	end

*Testing input (functions)
 if 1 {
	*Cheack matchVar input
	cap program drop 	iematchMatchVarCheck 
		program define 	iematchMatchVarCheck  , rclass
		
		args defaultName userName
		
		if "`defaultName'" == "_matchID" 		local optionName matchidname
		if "`defaultName'" == "_matchDiff" 		local optionName matchdiffname
		if "`defaultName'" == "_matchOrReason" 	local optionName matchnoname
		if "`defaultName'" == "_matchCount" 	local optionName matchcount
		
		*All the default names
		local dfltNms _noMatchReason _matchDiff _matchOrReason _matchCount
		
		*The other two default names
		local othDfltNms : list dfltNms - defaultName
		
		*Creating two locals with the deafult name in each local
		local Oth1 : word 1 of `othDfltNms'
		local Oth2 : word 2 of `othDfltNms'
		local Oth3 : word 3 of `othDfltNms'
		
		*Testing that the option name is not the same as the other variable's default name.
		if ("`userName'" == "`Oth1'" | "`userName'" == "`Oth2'" | "`userName'" == "`Oth3'" | "`userName'" == "_ID")  {
			
			noi di as error "{phang}The new name specified in `optionName'(`userName') is not allowed to be _ID, `Oth1', `Oth2', or `Oth3'{p_end}"
			error 198
		}
	
		*Checking set-up for the ID var used for _matchID
		if "`userName'" == "" {
			
			*CSet the default name
			local validMatchVarname `defaultName'	
		
			*Make sure that the default name _ID is not already used
			cap confirm variable `validMatchVarname'
			if _rc == 0 {
			
				noi di as error "A variable with name `validMatchVarname' is already defined. Either drop this variable or specify a new variable name using `optionName'()."
				error 110
			
			}

		} 
		
		else {
			
			*CSet the default name
			local validMatchVarname `userName'	
		
			*Make sure that the default name _ID is not already used
			cap confirm variable `validMatchVarname'
			if _rc == 0 {
			
				noi di as error "The variable name specified in `optionName'(`userName') is already defined in the data set. Either drop this variable or specify a another variable name using `optionName'()."
				error 110
			
			}
			
		}
		
		*Testing that the new name is valid by creating a variable that is dropped immedeatly afterwards
		cap gen `validMatchVarname' = .
		
		if _rc != 0 {
			
			noi di as error "The variable name specified in `optionName'(`userName') is not a valid variable name."
			error _rc
		
		}
		drop `validMatchVarname'
		
		return local validVarName 	"`validMatchVarname'"
		
	end
}
	

	
	
*Matching functions
if 1 {

	
	** This function is called to assign the preferred match for all unmatched 
	*  observations to any other unmatched observation. Returns a variable pref that is the 
	cap program drop 	updatePrefDiffPreffID
		program define 	updatePrefDiffPreffID
		
		args prefID prefDiff matchvar invsort idvar grpvar matched rand invrand diffup diffdo valUp_0 valDo_0 valUp_1 valDo_1 IDup IDdo IDup_0 IDdo_0 IDup_1 IDdo_1
		
		*****************
		*Update possible matches with higher rank value
		sort `matched' `matchvar' `rand'
		
		updateBestValID 0 `matchvar' `idvar' `grpvar' `matched' `valUp_0' `IDup_0'
		updateBestValID 1 `matchvar' `idvar' `grpvar' `matched' `valUp_1' `IDup_1'

		*****************
		*Update possible matches with lower rank value
		sort `matched' `invsort' `invrand'
		
		updateBestValID 0 `matchvar' `idvar' `grpvar' `matched' `valDo_0' `IDdo_0'
		updateBestValID 1 `matchvar' `idvar' `grpvar' `matched' `valDo_1' `IDdo_1'

		*****************
		*Create one varaible common for both groups with diff upwards
		replace `diffup' 	= abs(`matchvar' - `valUp_1') if `grpvar' == 1
		replace `diffup' 	= abs(`matchvar' - `valUp_0') if `grpvar' == 0 
		
		*Create one varaible common for both groups with diff downwards
		replace `diffdo' 	= abs(`matchvar' - `valDo_1') if `grpvar' == 1 
		replace `diffdo' 	= abs(`matchvar' - `valDo_0') if `grpvar' == 0 
		
		*Create one varaible common for both groups with ID upwards
		replace `IDup' 		= `IDup_1' 	if `grpvar' == 1
		replace `IDup' 		= `IDup_0' 	if `grpvar' == 0 
		
		*Create one varaible common for both groups with ID downwards
		replace `IDdo' 		= `IDdo_1' 	if `grpvar' == 1 
		replace `IDdo' 		= `IDdo_0' 	if `grpvar' == 0 
		
		replace `prefID' 	= `IDdo' 	if `matched' == 0 & `diffdo' <= `diffup'
		replace `prefID' 	= `IDup' 	if `matched' == 0 & `diffdo' >  `diffup'	

		replace `prefDiff' 	= `diffdo' 	if `matched' == 0 & `diffdo' <= `diffup'
		replace `prefDiff' 	= `diffup' 	if `matched' == 0 & `diffdo' >  `diffup'			
		
	end

	
	** This function goes through the observatioins from top to down and copying 
	*  the match value of the closest observation of the other group above to 
	*  (bestVal) and the ccoprresponding ID to (bestID) for obe group at the time. 
	*  To go from bottuom to top sort with invsort and apply this command.
	cap program drop 	updateBestValID
		program define 	updateBestValID
		
		args grpvl matchval idvar grpvar matched bestVal bestID

		*Reset all values
		replace `bestVal' 	= .
		replace `bestID' 	= .
		
		*Set the match value and ID of observations that are in the other group
		replace `bestVal'   = `matchval' 		if `grpvar' != `grpvl' & `matched' == 0
		replace `bestID'  	= `idvar' 			if `grpvar' != `grpvl' & `matched' == 0
		
		*Fill in that value from the observation in the other group until getting to another observation of the other group
		replace `bestVal'   = `bestVal'[_n-1]	if `bestVal' == . & `matched' == 0
		replace `bestID'  	= `bestID'[_n-1] 	if `bestID'	 == . & `matched' == 0
		
	end
	
}	
	

	
	
	
	clear
	
	set seed 125345324
	
	
	set obs 30000
	
	gen id = _n
	
	gen rand1 = uniform()
	
	gen tmt = (rand1 < .40)
	
	*replace tmt = . if (rand1 < .45)
	
	drop rand1
	tab tmt
	
	gen p_hat = uniform()
	
	*replace p_hat = p_hat + .03 if tmt == 1
	
	*replace p_hat = . if p_hat < .2
	
	iematch  , grp(tmt) match(p_hat) idvar(id)   maxdiff(.01)  //matchidname(Kallefille)

