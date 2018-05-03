	
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
	
	
	local varlist var_a var_b var_c var_d

	
	/* the rest will be inside the command */
	
	local colnames BC_Mean BC_err BT_Mean BT_err EC_Mean EC_err ET_Mean ET_err B1stDiff B1stDiff_err E1stDiff E1stDiff_err 2ndDiff 2ndDiff_err
	
	*Define default row here. The results for each var will be one row that starts with all missing vlaues
	mat startRow = (.,.,.,.,.,.,.,.,.,.,.,.,.,.)
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
		
		*Get the means in each group
		forvalues t01 = 0/1 {
			forvalues tmt01 = 0/1 {
				
				*Summary stats on this group
				qui sum `var' if tmt == `t01' & t == `tmt01'
				
				*Store the mean. Stored for all groups regardless if means or first differences will be displayed. Output sub-commands will select which one to use according to options used by user
				local ++colindex
				mat `var'[1,`colindex'] = `r(mean)'
				
				*Store the standard deviation (allow the option for different variance here)
				local ++colindex
				mat `var'[1,`colindex'] = `r(sd)'				
			}
		}
		
		*Run the regression to get the double difference
		reg `var' tmt#t
		mat resTable = r(table)
		matlist resTable
		
		*Loop over the two first difference coefficients and then over the second difference
		forvalues coeffcolumn = 2/4 {
		
			//Get the second differnce
			local ++colindex
			mat `var'[1,`colindex'] =  el(resTable,1,`coeffcolumn') 
			
			*Get the standard error fo
			local ++colindex
			mat `var'[1,`colindex'] =  el(resTable,2,`coeffcolumn') 
			
		}
		
		*Append this row to the result table
		mat 	resultMat = (resultMat \ `var')
	
	}
	
	*Show the final matrix will all data needed to start building the output
	matlist resultMat
	
	******
	*Then the result matrix can be passed into subcommands that output in either Excel, LaTeX or in the main window.
	
	*The results can be accessed like this, which makes the sub-commands less sensitive to changing column order in the section above.
	mat A = resultMat[3, "BC_Mean"] // returns a 1x1 matrix
	local a = el(A,1,1)				// returns the value
	
	matlist A
	di `a'

