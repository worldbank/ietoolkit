
capture program drop iebaltab
		program 	 iebaltab

	syntax 	varlist(numeric) [if] [in] [aw fw pw iw], 	///
			GRPVar(varname) 							///
														///
			[											///
			/*Columns and order of columns*/			///
			ORder(numlist int min=1) 					///
			COntrol(numlist int max=1) 					///
			]
	
	preserve
			
	// Settings ---------------------------------------------------------------
		
		// Minimum version for this command
		version 11
		 
		// For developers: turn local = "debug" to show debugging hints
		local debug debug
		
	// 1 Prepare dataset and options ------------------------------------------
		
	// 1.1 Data set preparation
		dataprep `varlist' `if' `in', grpvar(`grpvar') `debug'
		
		* Get outputs
		local grpvar 			r(grpvar)
		local grpvar_levels		r(grpvar_levels)
		local balancevars		r(balancevars)
		
	// 1.2 Calculate inputs based on options
		if !missing("`control'") 	local control control(`control')
		if !missing("`order'")		local order	  order(`order')
	
		grpsprep , levels(`grpvar_levels') `order' `control' `debug'
		
									local grp_order 	r(grp_order)
		if !missing("`control'")	local grps_tmt		r(grps_tmt)
									local grp_pairs		r(grp_pairs)
		
	// 2 Run regressions ------------------------------------------------------
	
	// 2.1 For unconditional means in each treatment group
		grpmeans `balancevars', grpvar(`grpvar') levels(`grpvar_levels') `debug'
		
		* Get outputs
		matrix meansMat = r(meansMat)
		
		
	restore	
		
end
	
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
		
	// Sample ------------------------------------------------------------------ <----------------------------- Sample defined here -------------------------------------------------
		
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
// Calculate pairs for differences tests ***************************************

capture program drop grpsprep
		program 	 grpsprep, rclass
		
	syntax , levels(string) [order(numlist int min=1) control(numlist int max=1) debug]

	
	// Order of groups ---------------------------------------------------------
	
	* If a control variable was specified, and no manual order was specified,
	* the control variables will be the first group
	if missing("`order'") & !missing("`control'") {
		local order `control'
	}

	* The remaining groups will be ordered from smallest to largest
	local order_code_rest : list levels - order
	
	* Compile final order. If neither order() or control() were used, the
	* order will be the same as order_code_rest
	local grp_order `order' `order_code_rest'
		
	// Pairs for differences ---------------------------------------------------
	
	// If control was used (test only control again all other groups)
	if !missing("`control'") {
		local grps_tmt: list grp_order - control
		
		foreach group of local grps_tmt {
			local grp_pairs "`grp_pairs' `control'_`group'"
		}
	}
	
	// If control was not used (test all combinations of groups)
	else {
	
		local grp_count = wordcount("`grp_order'")
		
		forvalues firstGroup = 1/`grp_count' {

			* To guarantee that all combination of groups are included, but none
			* is duplicated, start next loop one integer higher than the first group
			local nextGroup = `firstGroup' + 1

			*Storing a local of all the test pairs
			forvalues secondGroup = `nextGroup'/`grp_count' {
				
				local code_firstGroup  : word `firstGroup' of `grp_order'
				local code_secondGroup : word `secondGroup' of `grp_order'
				
				local grp_pairs "`grp_pairs' `code_firstGroup'_`code_secondGroup'"
			}
		}
	}
		
	// Outputs -----------------------------------------------------------------
	
								return local grp_order 	`grp_order'
	if !missing("`control'")	return local grps_tmt	`grps_tmt'
								return local grp_pairs	`grp_pairs'
									
	if !missing("`debug'")		di "local grp_pairs: `grp_pairs'"
	
end
