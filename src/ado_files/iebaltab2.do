	
	cap program drop iebaltab
		program 	 iebaltab
	
		syntax varlist(numeric) [if] [in] [aw fw pw iw], 					///
																			///
				/*Group variable*/											///
				GRPVar(varname) 											///
																			///
			[																///
				/*Statistics and data manipulation*/						///
				vce(string) 												///
			]
	
	preserve
	
/*******************************************************************************
	INPUTS
*******************************************************************************/


	* Prepare a list of group variables and save outputs in locals -------------
		groupvar, grpvar(`grpvar')
		
		foreach output in `r(outputs)' {
			local `output' = r(`output')
		}
		
	* Prepare local with variance estimator options ----------------------------

		if !missing("`vce'") {
		
			vce_prep , vce(`vce')
			
			foreach output in `r(outputs)' {
				local `output' = r(`output')
			}
		}

	restore
	
	end program


	
/*------------------------------------------------------------------------------	
	Prepare a list of group variables
------------------------------------------------------------------------------*/


	cap program drop groupvar
		program 	 groupvar, rclass
	
		syntax , grpvar(varlist)
			
		* Make sure grpvar is numeric
		cap confirm numeric variable `grpvar'

		if _rc != 0 {

			/*Test for commands not allowed if grpvar is a string variable

			if `CONTROL_USED' == 1 {
				di as error "{pstd}The option control() can only be used if variable {it:`grpvar'} is a numeric variable. Use {help encode} to generate a numeric version of variable {it:`grpvar'}. It is best practice to store all categorical variables as labeled numeric variables.{p_end}"
				error 198
			}
			if `ORDER_USED' == 1 {
				di as error "{pstd}The option order() can only be used if variable {it:`grpvar'} is a numeric variable. Use {help encode} to generate a numeric version of variable {it:`grpvar'}. It is best practice to store all categorical variables as labeled numeric variables.{p_end}"
				error 198
			}
			if `NOGRPLABEL_USED' == 1 {
				di as error "{pstd}The option grpcodes can only be used if variable {it:`grpvar'} is a numeric variable. Use {help encode} to generate a numeric version of variable {it:`grpvar'}. It is best practice to store all categorical variables as labeled numeric variables.{p_end}"
				error 198
			}
			if `GRPLABEL_USED' == 1 {
				di as error "{pstd}The option grplabels() can only be used if variable {it:`grpvar'} is a numeric variable. Use {help encode} to generate a numeric version of variable {it:`grpvar'}. It is best practice to store all categorical variables as labeled numeric variables.{p_end}"
				error 198
			}
			*/

			* Generate a encoded tempvar version of grpvar
			tempvar grpvar_code
			encode `grpvar', gen(`grpvar_code')

			* Replace the grpvar local so that it uses the tempvar instead
			local grpvar `grpvar_code'

		}
		
		* Drop observations without treatment assignment
		drop if missing(`grpvar')
		
		* Create a local of all codes in group variable. We will use it to ...	// <---------------------------------------------------------------------
		levelsof `grpvar', local(grpvar_levels)

		* Counting how many levels there are in grpvar. We will loop over them 	// <---------------------------------------------------------------------
		local grpvar_ngroups : word count `grpvar_levels'
		
		* Saving the name of the value label of the grpvar()
		local grpvar_grplab  : value label `grpvar'
				
		return local grpvar 		`grpvar'
		return local grpvar_levels 	`grpvar_levels'
		return local grpvar_grplab 	`grpvar_grplab'
		return local grpvar_ngroups `grpvar_ngroups'
		return local outputs		grpvar grpvar_levels grpvar_grplab grpvar_ngroups
		
	end program
	
/*******************************************************************************
	INPUTS
*******************************************************************************/

	local balancevar 			close
	local weight_option			[pw = weight]
	local error_estm			vce(cluster cluster)
	local vce_type				cluster
	local groupOrder			groupOrder
	local GRPVAR_NUM_GROUPS		3
	
	gen groupOrder = tmt + 1

	templateResultMatrix
	mat startRow = r(startRow)
	local colnames = "`r(colnames)'"

	*Initiate the result matrix with a place holder row that will not be used for anything. Matrices cannot be initiated empty
	mat 		 ddtab_resultMap = startMat
	mat rownames ddtab_resultMap = placeholder

	* Loop over balance variables
	foreach balancevar in `balancevars' {
	
		* Each variable has two rows in the result matrix	
		mat 		 `balancevar' = startMat
		mat rownames `balancevar' = `balancevar'1 `balancevar'2
		mat colnames `balancevar' = `colnames'
				
		local colindex 0		
				
		* Loop over treatment groups
		forvalues groupNumber = 1/`GRPVAR_NUM_GROUPS' {
		
			* Run regression for that group
			reg 	`var' if `groupOrder' == `groupNumber' [`weight'`exp'], `error_estm'
			
			local N `e(N)'
						
			* Save number of obs
			local ++colindex
			mat `balancevar'[1,`colindex'] =  `N'
			
			* Save mean
			local ++colindex
			mat `balancevar'[1,`colindex'] =  _b[_cons]
			
			**Increment column index regardless if clusters is
			* used. If it is not used column should be missing
			local ++colindex
			if "`vce_type'" == "cluster" {
				mat `balancevar'[2,`colindex'] = e(N_clust)
			}
			
			* Save se (or sd if specified)
			local ++colindex
			convertErrs _se[_cons] `N' "`errortype'"
			mat `var'[2,`colindex'] =  `r(converted_error)'
	
		}
	}
		
	* Loop over comparison groups
			* Run regression
			* Save p-value
			* Save t stat

	
	foreach var of local varlist {

		*Get the number of stars using sub-command countStars
		local ++colindex
		local pvalue = el(resTable,4,3)
		countStars `pvalue' `starlevels' `stardrop'
		mat `var'[1,`colindex'] = `r(stars)'
		
		*Append this row to the result table
		mat 	ddtab_resultMap = (ddtab_resultMap \ `var')

	}

	*Remove placeholder row
	matrix ddtab_resultMap = ddtab_resultMap[2..., 1...]

	*Returning the result matrix for advanced users to do their own thing with
	mat returnMat = ddtab_resultMap
	return matrix ieddtabResults returnMat

	*Show the final matrix will all data needed to start building the output
	//noi di "Matlist with results"
	//matlist ddtab_resultMap

	
	
/*******************************************************************************
	TESTS
*******************************************************************************/
