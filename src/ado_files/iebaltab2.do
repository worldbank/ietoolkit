

	templateResultMatrix
	mat startRow = r(startRow)
	local colnames = "`r(colnames)'"

	*Initiate the result matrix with a place holder row that will not be used for anything. Matrices cannot be initiated empty
	mat ddtab_resultMap = startRow
	mat rownames ddtab_resultMap = placeholder

	* Loop over variables
	foreach var of varlist {
	
		*Each variable is a row in the result matrix
		mat `var' = startRow
		mat rownames `var' = `var'
		mat colnames `var' = `colnames'
				
		* Loop over treatment groups
		forvalues groupNumber = 1/`GRPVAR_NUM_GROUPS' {
		
			* Run regression for that group
			reg 	`var' if `groupOrder' == `groupNumber' [`weight'`exp'], `error_estm'
			gen `regsample' = e(sample)
			local N `e(N)'
			
			
			* Store results temporarily
			mat resTable = r(table)
				
			*Local that keeps track of which column to fill
			local colindex 0
		
			* Save mean
			local ++colindex
			mat `var'[1,`colindex'] =  el(resTable,1,1)

			* Save se (or sd if specified)
			local ++colindex
			convertErrs el(resTable,2,1) `N' "`errortype'"
			mat `var'[1,`colindex'] =  `r(converted_error)'
			
			* Save number of obs
			local ++colindex
			mat `var'[1,`colindex'] =  `N'
			
			**Increment column index regardless if clusters is
			* used. If it is not used column should be missing
			local ++colindex
			if "`vce_type'" == "cluster" {
				*Add the number of clusters if clusters are used
				mat `var'[1,`colindex'] =  `e(N_clust)'
			}
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

	
	