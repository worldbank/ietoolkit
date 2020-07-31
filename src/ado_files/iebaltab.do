
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
		
	// 2 Run regressions ------------------------------------------------------
	
	// 2.1 For unconditional means in each treatment group
		grpmeans `balancevars', grpvar(`grpvar') levels(`grpvar_levels') `debug'
		
		* Get outputs
		matrix meansMat = r(meansMat)
		
		
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

// Calculate the means for each treatment group ********************************

capture program drop grpmeans
		program 	 grpmeans, rclass
		
	syntax 	varlist(numeric), grpvar(varname) levels(string) [debug]

	* Create blank matrices to add the results	
	cap mat drop meansMat
		mat 	 meansMat = J(1,1,.)
	
	
	// Loop level 1: variables -------------------------------------------------
	foreach var of varlist `varlist' {
		
		* Create blank matrices to add the results	
		cap mat drop varMat
			mat 	 varMat = J(1,1,.)
		
		
	// Loop level 2: Treatment groups ------------------------------------------
		foreach level in `levels' {
						
			// Run the regression
			reg `var' if `grpvar' == `level' //`weight_option', `error_estm'	<---------------------------- Regression for group means -------------------------------------------
			
			// Save results in a matrix
			
			* Basic matrix
			cap mat drop levelMat
				mat 	 levelMat = [_b[_cons], _se[_cons], _se[_cons] * sqrt(e(N)), e(N)]
							 
			 * Add number of clusters and column names if clusters were used
			if !missing("`error_estm'") {				
				mat 		 levelMat[1, 5] = e(N_clust)					
				mat colnames levelMat = beta`level' se`level' sd`level' n`level' nclust`level'
			}
			* Only four column names if clusters were not used
			else {
				mat colnames levelMat = beta`level' se`level' sd`level' n`level'
			}
			
				mat rownames levelMat = `var'
			
			if !missing("`debug'") mat list levelMat // Developer option
			
			// Append to results matrix				
			if varMat[1,1] == . {
				mat varMat = levelMat
			}
			else {
				mat varMat = [varMat, levelMat]
			}
			
			if !missing("`debug'") mat list varMat // Developer option
		}

	// Create final matrix -----------------------------------------------------
		if meansMat[1,1] == . {
			mat meansMat = varMat
		}
		else {
			mat meansMat = [meansMat \ varMat]
		}
		
		if !missing("`debug'")  mat list meansMat
			
	}
	
	// Outputs -----------------------------------------------------------------
	return matrix meansMat meansMat
		
end
