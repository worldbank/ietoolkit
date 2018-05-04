	
	/* Create some dummy datat */
	
	clear 
	
	*set seed 12345
	set obs 10000
	
	gen tmt = (runiform()<.5)
	gen t	= (runiform()<.5)
	
	gen var_a = runiform()
	gen var_b = runiform()
	gen var_c = runiform()
	gen var_d = runiform()

	gen cov_a = runiform()
	gen cov_b = runiform()	
	
	
	local varlist 		var_a var_b var_c var_d
	local covariates 	cov_a cov_b 

	
	/* the rest will be inside the command */
	
	local colnames 2ndDiff 2ndDiff_err 2ndDiff_N B1stDiff B1stDiff_err B1stDiff_N E1stDiff E1stDiff_err E1stDiff_N BC_Mean BC_err BC_N BT_Mean BT_err BT_N EC_Mean EC_err EC_N ET_Mean ET_err ET_N  
	
	*Define default row here. The results for each var will be one row that starts with all missing vlaues
	mat startRow = (.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.)
	mat colnames startRow = `colnames'
	
	matlist startRow // See the default row with its column names
	
	*Initiate the result matrix with a place holder row that will not be used for anything. Matrices cannot be initiated empty
	mat resultMat = startRow
	mat rownames resultMat = placeholder
	
	*Loop over all varlist
	foreach var of local varlist {
		
		*Each variable is a row in the result matrix
		mat `var' = startRow
		mat rownames `var' = `var'
		mat colnames `var' = `colnames'
		
		*Local that keeps track of which column to fill
		local colindex 0
		
		tempvar regsample
		
		/************* 
		
			Calculating 2nd difference and restict the sample 
			for this output var 
			
		*************/
		
		*Run the regression to get the double difference
		qui reg `var' tmt#t `covariates'
		mat resTable = r(table)
		
		**This is why this is done first. All other calculations 
		* for this outcome var should be restricted to this sample.
		gen `regsample' = e(sample)
		
		//Get the second differnce
		local ++colindex
		mat `var'[1,`colindex'] =  el(resTable,1,4) 
		
		*Get the standard error of second difference
		local ++colindex
		mat `var'[1,`colindex'] =  el(resTable,2,4) 
		
		*Get the N of second difference regression
		local ++colindex
		mat `var'[1,`colindex'] =  `e(N)' 		
		
		/************* 
		
			Calculating 1st differences
			
		*************/		
		
		forvalues tmt01 = 0/1 {
		
			qui reg `var' t `covariates' if tmt == `tmt01' & `regsample' == 1
			mat resTable = r(table)
	
			//Get the 1st diff
			local ++colindex
			mat `var'[1,`colindex'] =  el(resTable,1,1) 
			
			*Get the standard error of 1st diff
			local ++colindex
			mat `var'[1,`colindex'] =  el(resTable,2,1) 
			
			*Get the N of first difference regression
			local ++colindex
			mat `var'[1,`colindex'] =  `e(N)' 	
		
		}
				
		
		*Get the means for each group
		forvalues tmt01 = 0/1 {
			forvalues t01 = 0/1 {
				
				*Summary stats on this group
				qui mean `var' if tmt == `t01' & t == `tmt01' & `regsample' == 1
			
				mat resTable = r(table)

				//Get the mean
				local ++colindex
				mat `var'[1,`colindex'] =  el(resTable,1,1) 
				
				*Get the standard error of the mean
				local ++colindex
				mat `var'[1,`colindex'] =  el(resTable,2,1) 	
				
				*Get the N of the ordinary means regressions
				local ++colindex
				mat `var'[1,`colindex'] =  `e(N)' 	
			}
		}
		
		*Append this row to the result table
		mat 	resultMat = (resultMat \ `var')
	
	}
	
	*Remove placeholder row
	matrix resultMat = resultMat[2..., 1...]
	
	*Show the final matrix will all data needed to start building the output
	matlist resultMat
	
	******
	*Then the result matrix can be passed into subcommands that output in either Excel, LaTeX or in the main window.
	
	*The results can be accessed like this, which makes the sub-commands less sensitive to changing column order in the section above.
	mat A = resultMat[3, "BC_Mean"] // returns a 1x1 matrix
	local a = el(A,1,1)				// returns the value
	
	matlist A
	di `a'

