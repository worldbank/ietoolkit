
capture program drop iebaltab
		program 	 iebaltab

	syntax 	varlist(numeric) [if] [in] [aw fw pw iw], 	///
			GRPVar(varname) 							///
														///
			[											///
			/*Columns and order of columns*/			///
			ORder(numlist int min=1) 					///
			COntrol(numlist int max=1) 					///
			TOTal										///
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
	
		* Prepare inputs
		if !missing("`control'") 	local control control(`control')
		if !missing("`order'")		local order	  order(`order')
	
		* Prepare options
		grpsprep , levels(`grpvar_levels') `order' `control' `debug'
		
		* Get outputs
									local grpvar_order 	=	r(grpvar_order)
		if !missing("`control'")	local grps_tmt		=	r(grps_tmt)
									local grp_pairs		=	r(grp_pairs)
		
	// 2 Run regressions ------------------------------------------------------
	
	// 2.1 For unconditional means in each treatment group
		grpmeans `balancevars', grpvar(`grpvar') pairs(`grpvar_pairs') `debug' `total'
		
		* Get outputs
		matrix meansMat = r(meansMat)
	
	// 2.2 For group differences
		grpdiff  `balancevars', grpvar(`grpvar') pairs(`grpvar_pairs') `debug'
		
		
	// 3 Deal with results -----------------------------------------------------
	
	// 3.1 Save
	
	// 3.2 Print
	
	// 3.3 Browse
		
	restore	
		
end
	
/*******************************************************************************
								SUBPROGRAMS
*******************************************************************************/	
	
******************** Prepare the dataset for the command ***********************

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


***************** Calculate the means for each treatment group *****************

capture program drop grpmeans
		program 	 grpmeans, rclass
		
	syntax 	varlist(numeric), grpvar(varname) levels(string) [debug total]

	if !missing("`debug'") di "Group means subprogram started"
	
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
				mat 	 levelMat = [_b[_cons]				, ///
									 _se[_cons]				, ///
									 _se[_cons] * sqrt(e(N)), ///
									 e(N)					  ///
									]
							
			local colnames `"beta`level' se`level' sd`level' n`level'"'
			
			 * Add number of clusters and column names if clusters were used
			if "`vce_type'" == "cluster"  {				
				mat levelMat[1, 5] = e(N_clust)					
				local colnames `"`colnames' nclust`level'"'
			}
			
			mat colnames levelMat = `colnames'
			mat rownames levelMat = `var'
			
			if !missing("`debug'") mat list levelMat // Developer option
			
			// Append to results matrix				
			if varMat[1,1] == . {
				mat varMat = levelMat
			}
			else {
				mat varMat = [varMat, levelMat]
			}
		}
		
	// Calculate overall mean if total was seleted -----------------------------

		if !missing("`total'") {
		
			reg 	`balancevar'  // `weight_option', `error_estm'
			
			* Basic matrix
			cap mat drop totalMat
				mat 	 totalMat = [_b[_cons]				, ///
									 _se[_cons]				, ///
									 _se[_cons] * sqrt(e(N)), ///
									 e(N)					  ///
									]
							
			local colnames `"betatot setot sdtot' ntot"'
			
			 * Add number of clusters and column names if clusters were used
			if "`vce_type'" == "cluster"  {				
				mat totalMat[1, 5] = e(N_clust)					
				local colnames `"`colnames' nclusttot"'
			}
			
			mat colnames totalMat = `colnames'
			mat rownames totalMat = `var'
			
			if !missing("`debug'") mat list totalMat // Developer option
			
			mat varMat = [varMat, totalMat]
		}
		
	if !missing("`debug'") mat list varMat // Developer option
	
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
	
	if !missing("`debug'") di "Group means subprogram successful"
		
end

************************ Calculate group differences ***************************

capture program drop grpdiff
		program 	 grpdiff, rclass
		
	syntax 	varlist(numeric), grpvar(varname) pairs(string) [debug]
	
	if !missing("`debug'") di "Subprogram grpdiff started"
	
	* Create blank matrix to add results	
	cap mat drop diffMat
		mat 	 diffMat = J(1,1,.)
			
	foreach var in `varlist' {
		
		* Create blank matrix to add results	
		cap mat drop varMat
			mat 	 varMat = J(1,1,.)
		
	// Test each pair ---------------------------------------------------------
		foreach pair in `pairs' {
		
			// Prepare pair dummy to add to the regression
			
			* Create a local for each group in the test pair
			local undscrPos   = strpos("`pair'","_")
			local firstGroup  = substr("`pair'",1,`undscrPos'-1)
			local secondGroup = substr("`pair'",  `undscrPos'+1,.)
		
			* Create a temporary variable used as the dummy to indicate which 
			* observations are in each of the two groups being tested.
			* It will be missing for all observations that are not in any of the two groups,
			* meaning they will not be considered in the regression
			tempvar  grp_dummy
			gen 	`grp_dummy' = .	//default is missing, and obs not in this pair will remain missing
			replace `grp_dummy' = 0 if `grpvar' == `firstGroup'		// if control if used, control will be 0
			replace `grp_dummy' = 1 if `grpvar' == `secondGroup'	// and each treatment group will be 1

			// Run regression and store results for this pair
			reg `var' `grp_dummy'											//	<-------------------------------------- Difference regression ----------------------------------------------
			
		// Save result to a matrix ---------------------------------------------
	
			* Create matrix with regression output
			cap mat drop resultMat
				mat		 resultMat = r(table)
			
			* Select results we will use in the command and save to a new matrix 
			cap mat drop pairMat
				mat		 pairMat = [resultMat["b", "`grp_dummy'"]  		, ///
									resultMat["se", "`grp_dummy'"] 		, ///
									resultMat["t", "`grp_dummy'"]  		, ///
									resultMat["pvalue", "`grp_dummy'"]	, ///
									resultMat["ul", "`grp_dummy'"]		, ///
									resultMat["ll", "`grp_dummy'"]		, ///
									e(N)								  ///
								   ]

			// Identify columns and rows in results matrix so we can call them later
			local colnames `"beta`pair' se`pair' t`pair' pval`pair' ul`pair' ll`pair' n`pair'"'
								   
			* There's an extra column if clusters were used					   
			if "`vce_type'" == "cluster" {
				mat		 	 pairMat[1, 8] = e(N_clust)	
				
				local colnames `"`colnames' nclust`pair'"'
			}
			
			mat colnames pairMat = `colnames'
			mat rownames pairMat = `var'
			
			* normalized difference
			* f-test
			
			// Append to other results from the same variable
			if varMat[1,1] == . {
				mat varMat = pairMat
			}
			else {
				mat varMat = [varMat, pairMat]
			}
			
			if !missing("`debug'") mat list varMat // Developer option

		}
				
		// Create final matrix -----------------------------------------------------
		if diffMat[1,1] == . {
			mat diffMat = varMat
		}
		else {
			mat diffMat = [diffMat \ varMat]
		}
		
		if !missing("`debug'")  mat list diffMat
			
	}
	
	// Outputs -----------------------------------------------------------------
	return matrix diffMat diffMat
	
	if !missing("`debug'") di "Subprogram grpdiff completed"
	
end

********************* Calculate pairs for differences tests ********************

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
	local grpvar_order `order' `order_code_rest'
		
	// Pairs for differences ---------------------------------------------------
	
	// If control was used (test only control again all other groups)
	if !missing("`control'") {
		local grps_tmt: list grpvar_order - control
		
		foreach group of local grps_tmt {
			local grpvar_pairs "`grpvar_pairs' `control'_`group'"
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
				
				local grpvar_pairs "`grpvar_pairs' `code_firstGroup'_`code_secondGroup'"
			}
		}
	}
		
	// Outputs -----------------------------------------------------------------
	
								return local grpvar_order 	`grpvar_order'
	if !missing("`control'")	return local grps_tmt		`grps_tmt'
								return local grpvar_pairs	`grpvar_pairs'
									
	if !missing("`debug'")		di "local grp_pairs: `grp_pairs'"
	
end
