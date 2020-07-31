
capture program drop iebaltab
		program 	 iebaltab

	syntax 	varlist(numeric) [if] [in] [aw fw pw iw], ///
			GRPVar(varname)
	
	preserve
			
	// Settings ---------------------------------------------------------------
		
		// Minimum version for this command
		version 11
		 
		// For developers: turn local = "debug" to show debugging hints
		local debug debug
		
	// 1 Prepare dataset ------------------------------------------------------
		dataprep `varlist' `if' `in', grpvar(`grpvar') `debug'
		
		* Get outputs
		local grpvar 			r(grpvar)
		local grpvar_levels		r(grpvar_levels)
		local balancevars		r(balancevars)
	restore	
/*******************************************************************************
								SUBPROGRAMS
*******************************************************************************/	
	
// Prepare the dataset for the command *****************************************

capture program drop dataprep
		program 	 dataprep, rclass
	
	syntax 	varlist(numeric) [if] [in] [aw fw pw iw], grpvar(varname) [debug]
					
	// Treatment variable -----------------------------------------------------
		cap confirm numeric variable `grpvar'

		// If not numeric, create a numeric version
		if _rc {

			* Generate a encoded tempvar version of grpvar
			tempvar grpvar_code
			encode `grpvar' , gen(`grpvar_code')

			* Replace the grpvar local so that it uses the tempvar instead
			local grpvar `grpvar_code'

		}
		
		// List of treatment groups
		levelsof `grpvar', local(grpvar_levels)
		
	// Balance variables -------------------------------------------------------	
		local balancevars `varlist'		
		
	// Sample ------------------------------------------------------------------	
		
		// Remove observations with no treatment assignment
		drop if missing(`grpvar')
		
		// Remove observations excluded by if and in
		marksample touse,  novarlist
		keep if `touse'
			
	// Outputs -----------------------------------------------------------------
		return local grpvar 		`grpvar'
		return local grpvar_levels	`grpvar_levels'
		return local balancevars	`balancevars'
		
	if !missing("`debug'") di "Data prep subprogram sucessful" // Developer option 
	
end
