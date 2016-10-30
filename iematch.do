
	clear 

	
	
	*command starts here
	
	cap program drop 	iematch
	    program define	iematch
		
		syntax    , ///
			GRPdummy(varname) 		///
			MATCHcont(varname) 		///
			[						///
			idvar(varname)			///
			matchidname(string)		///
			matchdiffname(string)	///
			]						
		
		*****
		*1. [if] [in]
		*2 make match only on obs with group
		*3 m:1 match
		
		noi di "Syntax OK!"
		
		qui {
		
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
		
		*See function below
		iematchMatchVarCheck `matchidname' _matchID
		local matchIDname "`r(validVarName)'"
		gen  `matchIDname' = .
		
		iematchMatchVarCheck `matchdiffname' _matchDiff
		local matchDiffName "`r(validVarName)'"
		gen `matchDiffName' = .

		
		********************************
		*
		*	Creating tempvar used
		*
		********************************
		
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
			
			*pause
			
		}
	}
	
	end
	
	
	*Cheack matchVar input
	cap program drop 	iematchMatchVarCheck 
		program define 	iematchMatchVarCheck  , rclass
		
		args defaultName optionName 	
		
		*Testing that the option name is not the same as the other variable's default name.
		if "`defaultName'" == "_matchID" & "`optionName'" == "_matchDiff" {
		
			noi di as error "The new name specified in matchidname() is not allowed to be _matchDiff"
			error 198
		}
		if "`defaultName'" == "_matchDiff" & "`optionName'" == "_matchID" {
		
			noi di as error "The new name specified in matchdiffname() is not allowed to be _matchID"
			error 198
		}		
		
		*Checking set-up for the ID var used for _matchID
		if "``optionName''" == "" {
			
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
			local validMatchVarname `optionName'	
		
			*Make sure that the default name _ID is not already used
			cap confirm variable `validMatchVarname'
			if _rc == 0 {
			
				noi di as error "The variable name `validMatchVarname' specified in `optionName'() is already defined in the data set. Either drop this variable or specify a another variable name using `optionName'()."
				error 110
			
			}
			
		}
		
		*Testing that the new name is valid by creating a variable that is dropped immedeatly afterwards
		cap gen `validMatchVarname' = .
		
		if _rc != 0 {
			
			noi di as error "The variable name specified is not a valid variable name."
			error _rc
		
		}
		drop `validMatchVarname'
		
		return local validVarName 	"`validMatchVarname'"
		
	end
	
	clear
	
*	set seed 1235324
	
	
	set obs 10000
	
	gen id = _n
	
	gen rand1 = uniform()
	
	gen tmt = (rand1 < .40)
	replace tmt = . if (rand1 < .2)
	replace tmt = .a if (rand1 < .1)
	
	drop rand1
	tab tmt
	
	gen p_hat = uniform()
	
	iematch if id < 5532  , grp(tmt) match(p_hat) idvar(id)
