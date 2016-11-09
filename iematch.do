
	clear all

	
	
	*command starts here
	
	cap program drop 	iematch
	    program define	iematch
		
		syntax  [if] [in]  , ///
			GRPdummy(varname) 		///
			MATCHcont(varname) 		///
			[						///
			idvar(varname)			///
			matchidname(string)		///
			matchdiffname(string)	///
			matchnoname(string)		///
			]						
		
		*****
		*1 format errors as smcl
		*2 make match only on obs with value in group dummy
		*3 m:1 match
		
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
			
			*Exclude obs with missing value in groupdummy
			drop if missing(`grpdummy')
		
			
			********************************
			*
			*	Checking match continous var
			*
			********************************
			
			*Test that the continous is numeric
			cap confirm numeric variable `matchcont'
			if _rc != 0 {
				
				di as error "The variable to match on specified in matchcont(`matchcont') is not a numeric variable."
				error 109
			
			}

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
	
			iematchMatchVarCheck _matchDiff `matchdiffname' 
			local matchDiffName "`r(validVarName)'"
			gen `matchDiffName' = .
			
			iematchMatchVarCheck _matchOrReason `matchnoname' 
			local noMatchReasonName "`r(validVarName)'"
			gen `noMatchReasonName' = .			

			*Create a label for missing values that explains no match
			label define matchLabel 0 "Not Matched" 1 "Matched" .n "Obs not included in match" 
			
			*Apply the label
			label value `noMatchReasonName' matchLabel
		
			********************************
			*
			*	Creating tempvar used
			*
			********************************
			
			*Initiate the temporary variables used by this command
			tempvar hi_diff lo_diff pref match newMatch rand
		
			gen `hi_diff' = .
			gen `lo_diff' = .
			
			gen `pref' = .
			gen byte `match' = 0
			gen byte `newMatch' = 0
			
			** Generate random variable that seperate two obs 
			*  with the same value in the continuos variable
			gen `rand' = uniform()
			

			********************************
			*
			*	Start matching
			*
			********************************		
			
			count if `grpdummy' == 1 & `match' == 0
			local left2Match = `r(N)'		

			while (`left2Match' > 0) {
			
				sort `match' `matchcont' `rand' 
				
				replace `lo_diff' 	= .
				replace `hi_diff' 	= .
				replace `pref'		= . if `match' == 0
				replace `newMatch' 	= 0
				
				replace `lo_diff' = abs(`matchcont' - `matchcont'[_n-1]) if `match' == 0 & `grpdummy' != `grpdummy'[_n-1] 
				replace `hi_diff' = abs(`matchcont' - `matchcont'[_n+1]) if `match' == 0 & `grpdummy' != `grpdummy'[_n+1]
				
				replace `pref' = `idvar'[_n-1] if `match' == 0 & `lo_diff' <  `hi_diff'
				replace `pref' = `idvar'[_n+1] if `match' == 0 & `lo_diff' >= `hi_diff'
				
				replace `newMatch' = 1 if `match' == 0 & `pref' == `idvar'[_n-1] & `pref'[_n-1] == `idvar'
				replace `newMatch' = 1 if `match' == 0 & `pref' == `idvar'[_n+1] & `pref'[_n+1] == `idvar'
				
				replace `match' = 1 							if `newMatch' == 1
				replace `matchDiffName' = min(`lo_diff', `hi_diff') 	if `newMatch' == 1
				replace `matchIDname' = `idvar' 						if `newMatch' == 1 & `grpdummy' == 1
				replace `matchIDname' = `pref' 						if `newMatch' == 1 & `grpdummy' == 0
				
				*order _match* , last
				
			noi	count if `grpdummy' == 1 & `match' == 0
				local left2Match = `r(N)'
				
				
				
			}
			

			replace `noMatchReasonName' = 0 if `match' == 0 & `grpdummy' == 0

			keep `matchIDname' `matchDiffName' `idvar' `originalSort' `noMatchReasonName'
			
			tempfile mergefile
			
			save `mergefile'
			
			*pause
			
		restore
		
		tempvar mergevar
		
		noi merge 1:1  `originalSort' using `mergefile', gen(`mergevar')
		
		replace `noMatchReasonName' = .n if `mergevar' == 1
		
		replace `noMatchReasonName' = 1 if `noMatchReasonName' == .
		
		sort `originalSort'
		
	}
	
	end
	
	
	*Cheack matchVar input
	cap program drop 	iematchMatchVarCheck 
		program define 	iematchMatchVarCheck  , rclass
		
		args defaultName userName
		
		if "`defaultName'" == "_matchID" 		local optionName matchidname
		if "`defaultName'" == "_matchDiff" 		local optionName matchdiffname
		if "`defaultName'" == "_matchOrReason" 	local optionName matchnoname
		
		*All the default names
		local dfltNms _noMatchReason _matchDiff _matchOrReason
		
		*The other two default names
		local othDfltNms : list dfltNms - defaultName
		
		*Creating two locals with the deafult name in each local
		local Oth1 : word 1 of `othDfltNms'
		local Oth2 : word 2 of `othDfltNms'
		
		*Testing that the option name is not the same as the other variable's default name.
		if ("`defaultName'" == "_matchID" & ("`userName'" == "`Oth1'" | "`userName'" == "`Oth2'" | "`userName'" == "_ID"))  {
			
			noi di as error `" ("`defaultName'" == "_matchID" & ("`userName'" == "`Oth1'" | "`userName'" == "`Oth2'" | "`userName'" == "_ID")) "'
			
			noi di as error "The new name specified in `optionName'() is not allowed to be _ID, `Oth1', nor `Oth2'"
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
	
	clear
	
*	set seed 1235324
	
	
	set obs 50000
	
	gen id = _n
	
	gen rand1 = uniform()
	
	gen tmt = (rand1 < .40)
	
	replace tmt = . if (rand1 < .05)
	
	drop rand1
	tab tmt
	
	gen p_hat = uniform()
	
	iematch  , grp(tmt) match(p_hat) idvar(id) matchidname(kalle)

