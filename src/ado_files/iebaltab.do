
capture program drop iebaltab
		program 	 iebaltab

	syntax 	varlist(numeric) [if] [in] [aw fw pw iw], 	///
			GRPVar(varname) 							///
														///
			[											///
			* Columns and order of columns				///
			ORder(numlist int min=1) 					///
			COntrol(numlist int max=1) 					///
			TOTal										///
														///
			* Statistics and data manipulation			///
			FIXedeffect(varname)						///
			COVariates(varlist ts fv)					///
			vce(string)									///
			WEIGHTold(string)							/// For backward compatibility
														///
			* Output display 							///
			NORMDiff									///
			FEQTest										///			
			]

	
	preserve
			
	// Settings ---------------------------------------------------------------
		
		// Minimum version for this command
		version 11
		 
		// For developers: turn local = "debug" to show debugging hints
		local debug debug
		
	// 1 Prepare dataset and options ------------------------------------------
	
	// 1.0 Test options
	
		* Backwards compatibility for weight option
		if !missing("`exp'") {
			local exp 	 = subinstr("`exp'", "=", "", .)
			local weight `weight' `exp'
		}
		else if "`weightold'" != "" & "`exp'" == "" {
			tokenize `weightold', parse(=)
			local weight "`1'"
			local exp 	 "`3'"
		}

		foreach option in fixedeffect vce weight covariates {
			test`option' ``option''
			local 		  `option' `r(`option')'
			
			if !missing("`debug'") di "Option `option' tested successfully. Output: ``option''."
		}
		
	// 1.1 Data set preparation
		dataprep `varlist' `if' `in', grpvar(`grpvar') `debug' `fixedeffect'
		
		* Get outputs
		foreach argument in grpvar grpvar_levels balancevars fixedeffect {
			local `argument' `r(`argument')'
			if !missing("`debug'") di "Argument `argument': ``argument''."
		}		

	// 1.2 Calculate inputs based on options
	
		* Prepare inputs
		if !missing("`control'") 	local control control(`control')
		if !missing("`order'")		local order	  order(`order')
	
		* Prepare options
		grpsprep , levels(`grpvar_levels') `order' `control' `debug'
	
		* Get outputs
									local grp_order 		`r(grp_order)'
		if !missing("`control'")	local grps_tmt			`r(grps_tmt)'
									local grp_pairs			`r(grp_pairs)'
		
	// 2 Run regressions ------------------------------------------------------
	
	// 2.1 For unconditional means in each treatment group
		grpmeans 	`balancevars' `weight', ///
					grpvar(`grpvar') levels(`grpvar_levels') ///
					`debug' `total' `vce'
		
		* Get outputs
		matrix meansMat = r(meansMat)
	
	// 2.2 For group differences
		grpdiff  	`balancevars' `weight', ///
					grpvar(`grpvar') pairs(`grp_pairs') ///
					`debug' `fixedeffect' `vce' `covariates' ///
					`normdiff' `feqtest'
		
		* Get outputs
		matrix diffMat = r(diffMat)

		
	// 3 Deal with results -----------------------------------------------------
	
	// 3.1 Save
	
	// 3.2 Print
	
	// 3.3 Browse
		
	restore	
		
end
	
/*******************************************************************************
********************************************************************************
								
								SUBPROGRAMS
								
********************************************************************************
*******************************************************************************/	
	
/*******************************************************************************
								MAIN FEATURES
*******************************************************************************/
	
******************** Prepare the dataset for the command ***********************

capture program drop dataprep
		program 	 dataprep, rclass
	
	syntax 	varlist(numeric) [if] [in] [aw fw pw iw], grpvar(varname) [debug fixedeffect(varname)]
					
	if !missing("`debug'") di "Data prep subprogram started" // Developer option 

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
			
	// Fixed effects -----------------------------------------------------------

		* If fixed effects are not used, create a constant fe variable, so we
		* can still use areg, but won't change the result
		if missing("`fixedeffect'") {
			local  	 fixedeffect	__0fe
			gen 	`fixedeffect' = 1
			if !missing("`debug'") di "Fixed effect variable created: `fixedeffect'" 
		}
			
	// Outputs -----------------------------------------------------------------
							return local grpvar 		`grpvar'
							return local grpvar_levels	`grpvar_levels'
							return local balancevars	`balancevars'
							return local fixedeffect	fixedeffect(`fixedeffect')
		
	if !missing("`debug'") di "Data prep subprogram sucessful" // Developer option 
	
end


***************** Calculate the means for each treatment group *****************

capture program drop grpmeans
		program 	 grpmeans, rclass
		
	syntax 	varlist(numeric) [aw fw pw iw], grpvar(varname) levels(string) [debug total vce(string)]

	// Prepare inputs ----------------------------------------------------------
	
	if !missing("`debug'") 	di "Group means subprogram started"

	* Check if ses are clustered
	local 	   vce_type = subinstr("`vce'", "vce(", "", . )
	tokenize "`vce_type'"
	local 	   vce_type `1'

	* Prepare weight option
	if !missing("`weight'")	local weight [`weight' `exp']
	
	* Prepare vce option: when used, need to add a comma for the regression command
	if !missing("`vce'") 	local vce	, vce(`vce')
	
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
			qui reg `var' `weight' if `grpvar' == `level' `vce' 				//	<---------------------------- Regression for group means -------------------------------------------
			
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
				mat levelMat = [levelMat, e(N_clust)]
				local colnames `"`colnames' nclust`level'"'
			}
			
			mat colnames levelMat = `colnames'
			mat rownames levelMat = `var'
						
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
		
			qui reg `balancevar' `weight' `vce'
			
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
				mat totalMat = [totalMat, e(N_clust)]
				local colnames `"`colnames' nclusttot"'
			}
			
			mat colnames totalMat = `colnames'
			mat rownames totalMat = `var'
						
			mat varMat = [varMat, totalMat]
		}
		
	
	// Create final matrix -----------------------------------------------------
		if meansMat[1,1] == . {
			mat meansMat = varMat
		}
		else {
			mat meansMat = [meansMat \ varMat]
		}		
	}
	
	if !missing("`debug'")  mat list meansMat
	
	// Outputs -----------------------------------------------------------------
	return matrix meansMat meansMat
	
	if !missing("`debug'") di "Group means subprogram successful"
		
end

************************ Calculate group differences ***************************

capture program drop grpdiff
		program 	 grpdiff, rclass
		
	syntax 	varlist(numeric) [aw fw pw iw], ///
			grpvar(varname) pairs(string) fixedeffect(varname) ///
			[debug vce(string) covariates(varlist ts fv)	   ///
			 normdiff feqtest]
	
	// Prepare options ---------------------------------------------------------
	if !missing("`debug'") di "Group differences subprogram started"
	
	* Prepare error type
	local 	   vce		vce(`vce')
	local 	   vce_type = subinstr("`vce'", "vce(", "", . )
	tokenize "`vce_type'"
	local 	   vce_type `1'
	
	* Prepare weight option
	if !missing("`weight'")	local weight [`weight' `exp']
	
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
			
			//default is missing, and obs not in this pair will remain missing
			gen 	`grp_dummy' = .	
			
			// if control if used, control will be 0
			replace `grp_dummy' = 0 if `grpvar' == `firstGroup'	
			
			// and each treatment group will be 1
			replace `grp_dummy' = 1 if `grpvar' == `secondGroup'

			// Run regression and store results for this pair
			qui areg 	`var' `grp_dummy' `covariates' `weight', ///
						absorb(`fixedeffect') `vce'								//	<-------------------------------------- Difference regression ---------------------------------------------
			
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
				mat		pairMat = [pairMat, e(N_clust)]
				local 	colnames `"`colnames' nclust`pair'"'
			}
			
			mat colnames pairMat = `colnames'
			mat rownames pairMat = `var'
			
			//  Normalized difference
			if !missing("`normdiff'") {
			
				// if control if used, control will be 0
				sum `var' if `grpvar' == `firstGroup'
				local meanFirstGroup = r(mean)
				
				// and each treatment group will be 1
				sum `var' if `grpvar' == `secondGroup'
				local meanSecondGroup = r(mean)
				
				*Calculate standard deviation for sample of interest
				sum `var' if inlist(`grpvar',`firstGroup',`secondGroup')

				*Testing result and if valid, write to file with or without stars
				if r(sd) == 0 {
					local warn_means_num  	= `warn_means_num' + 1
				}
				else {
					*Create the local with the normalized difference
					local normDiff = (`meanFirstGroup' - `meanSecondGroup')/r(sd)
					
					mat		pairMat = [pairMat, `normDiff']
					local 	colnames `"`colnames' normdiff`pair'"'
				}				
				mat colnames pairMat = `colnames'
			}
			
			// Append to other results from the same variable
			if varMat[1,1] == . {
				mat varMat = pairMat
			}
			else {
				mat varMat = [varMat, pairMat]
			}
			
			// Test all groups if F test was selected 
			if !missing("`feqtest'") {

				// Run regression
				* Regression includes all treatment arms
				qui areg 	`var' i.`grpvar' `covariates' `weight', ///
							absorb(`fixedeffect') `vce'				

				// Prepare input for F-test
				* i. in the regression will drop the lowest value of the group
				* variable, so we need to test only the remaining groups
				levelsof `grpvar', local(groups)
				local lower_grp  `: word 1 of `groups''
				local groups = "`groups'" - "`lower_grp'"
				local groups : list groups - lower_grp
				
				* Loop through levels to create input
				local ftest_input ""
				
				foreach grp of local groups {
					local ftest_input = " `ftest_input' `grp'.`grpvar' = "
				}

				// This is the actual test
				test `ftest_input' 0

				// Print output
				* Check if the test is valid. If not, print N/A and error message.
				if "`ffeqtest'" == "." {
					local warn_ftest_num = `warn_ftest_num' + 1
					local warn_ftest_bvar`warn_ftest_num'	"`balancevar'"
				}
				* If yes, add result to the matrix
				else {
					mat 		 ftestMat 	= [r(p) , r(F)]
					mat colnames ftestMat	= "pfeqtest" "feqtest"
					mat 		 varMat 	= [varMat , ftestMat]
				}
			}		
		}
				
		// Create final matrix -----------------------------------------------------
		if diffMat[1,1] == . {
			mat diffMat = varMat
		}
		else {
			mat diffMat = [diffMat \ varMat]
		}
	}
	
	if !missing("`debug'")  mat list diffMat
		
	// Outputs -----------------------------------------------------------------
	return matrix diffMat diffMat
	
	if !missing("`debug'") di "Subprogram grpdiff successful"
	
end

********************* Calculate pairs for differences tests ********************

capture program drop grpsprep
		program 	 grpsprep, rclass
		
	syntax , levels(string) [order(numlist int min=1) control(numlist int max=1) debug]

	if !missing("`debug'") di "Groups prep subprogram started" // Developer option 
	
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
									
	if !missing("`debug'")	{
		di "local grp_pairs: `grp_pairs'"
		di "Groups prep subprogram successful" // Developer option 
	}	
	
end


/*******************************************************************************
								TEST INPUTS
*******************************************************************************/

capture program drop testvce
		program 	 testvce, rclass
		
	syntax [anything]
		
	if !missing("`anything'") {
		local vce 		= subinstr("`anything'", ",", " ", . )
		
		tokenize "`vce'"
		local vce_type `1'

		// Check that inputs are correct -------------------------------------------
		
		// Robust and bootstrap are allowed and no tests are needed
		if inlist("`vce_type'", "robust", "bootstrap") {
			local vce vce(`vce_type')
		}
		// If clustering ses, check that cluster variable is defined	
		else if "`vce_type'" == "cluster" {

						   local	 cluster_var `2'
			cap confirm variable  	`cluster_var'

			* Return error if the variable doesn't exit
			if _rc {
				noi display as error "{phang}The cluster variable in vce(`vce') does not exist or is invalid for any other reason. See {help vce_option :help vce_option} for more information. "
				error _rc
			}
			else {
				local vce	vce(cluster `cluster_var')
			}
		}
		// These are all the options allowed
		else {
			noi display as error "{phang}The vce type `vce_type' in vce(`vce') is not allowed. Only robust, cluster and bootstrap are allowed. See {help vce_option :help vce_option} for more information."
			error 198
		}
	}
	
	// Calculate outputs -------------------------------------------------------
	
	return local vce "`vce'"
	
end

capture program drop testweight
		program 	 testweight, rclass

	syntax [anything]
	
	if !missing("`anything'") {
	
	// Prepare weight option ---------------------------------------------------
		tokenize `anything'
		local weight `1'
		local exp	 `2'
	
	// Test if weight type specified is valid ----------------------------------
		local weight_options "fweights pweights aweights iweights fweight pweight aweight iweight fw freq weight pw aw iw"

		if `:list weight in weight_options' == 0 {
			noi display as error  "{phang} The option `weight' specified in weight() is not a valid weight option. Weight options are: fweights, fw, freq, weight, pweights, pw, aweights, aw, iweights, and iw. {p_end}"
			error 198
		}

	// Test if weight variable specified if valid ------------------------------
		capture confirm variable `exp'
		if _rc {
			noi display as error  "{phang} The weight variable `exp' was not found. {p_end}"
			error 198
		}
		else {
			capture confirm numeric variable `exp'
			if _rc	{
				noi display as error  "{phang} Variable `exp' is not a numeric variable and therefore cannot be used for weighting. {p_end}"
				error 109
			}
		}
		
	// Return output -----------------------------------------------------------
		return local weight	[`weight' = `exp']
	}
	
end

capture program drop testcovariates
		program 	 testcovariates, rclass
		
	syntax [anything]
	
	if !missing("`anything'") {
		return local covariates covariates(`anything')
	}
	
end

capture program drop testfixedeffect
		program 	 testfixedeffect, rclass
		
	syntax [anything]
	
	if !missing("`anything'") {
		cap assert !missing(`anything')
		if _rc == 9 {

			noi display as error  "{phang}The variable in fixedeffect(`anything') is missing for some observations. This would cause observations to be dropped in the estimation regressions. See tabulation of `anything' below:{p_end}"
			noi tab `anything', m
			error 109
		}
		
		local fe	fixedeffect(`anything')	
	}
	
	return local fixedeffect `fe'

end

  