
cap program drop 	ieddtable
	program define	ieddtable
	
	syntax varlist, ///
					///
		t(varname numeric) tmt(varname numeric) 			///
		[ 													///
		COVARiates(varlist numeric)							///
		STARLevels(numlist descending min=3 max=3 >0 <1)	///
		STARSNOadd											///
		firstdiff											///
		]
	
	
	/************* 
		
		Prepare the result matrix
			
	*************/
	
	templateResultMatrix
	return list
	mat startRow = r(startRow)
	
	noi di "Start row to see headers, remove for production"
	matlist startRow // See the default row with its column names
	
	*Initiate the result matrix with a place holder row that will not be used for anything. Matrices cannot be initiated empty
	mat resultMat = startRow
	mat rownames resultMat = placeholder
	
	/************* 
		
		Loop over all variables and prepare the data
			
	*************/
	
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
		qui reg `var' `tmt'#`t' `covariates'
		mat resTable = r(table)
		
		**This is why this is done first. All other calculations 
		* for this outcome var should be restricted to this sample.
		gen `regsample' = e(sample)
		local N `e(N)'
		
		**Test that the dummy vars creates for valid groups for each 
		* combination of time and treat in the sample used for this outcome var
		testDDdums `t' `tmt' `regsample' `var'  //comment in when this is made into a command
		
		//Get the second differnce
		local ++colindex
		mat `var'[1,`colindex'] =  el(resTable,1,4) 
		
		*Get the standard error of second difference
		local ++colindex
		mat `var'[1,`colindex'] =  el(resTable,2,4) 
		
		matlist resTable
		
		*Get the number of stars using sub-command countStars
		local ++colindex
		local pvalue = el(resTable,4,4) 
		countStars `pvalue' `starlevels'
		mat `var'[1,`colindex'] = `r(stars)'		
		 
		
		*Get the N of second difference regression
		local ++colindex
		mat `var'[1,`colindex'] = `N' 		
		
		
		/************* 
		
			Calculating 1st differences
			
		*************/		
		forvalues tmt01 = 0/1 {
		
			*Regress time against the outcome var one tmt group at the time
			qui reg `var' `t' `covariates' if `tmt' == `tmt01' & `regsample' == 1
			mat resTable = r(table)
	
			//Get the 1st diff
			local ++colindex
			mat `var'[1,`colindex'] =  el(resTable,1,1) 
			
			*Get the standard error of 1st diff
			local ++colindex
			mat `var'[1,`colindex'] =  el(resTable,2,1) 
			
			*Get the number of stars using sub-command countStars
			local ++colindex
			local pvalue = el(resTable,4,4) 
			countStars `pvalue' `starlevels'
			mat `var'[1,`colindex'] = `r(stars)'	
			
			*Get the N of first difference regression
			local ++colindex
			mat `var'[1,`colindex'] =  `e(N)' 	
		
		}
				
		
		/************* 
		
			Calculating standard means for all groups
			
		*************/	
		forvalues tmt01 = 0/1 {
			forvalues t01 = 0/1 {
				
				*Summary stats on this group
				qui mean `var' if `tmt' == `t01' & `t' == `tmt01' & `regsample' == 1
			
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
	noi di "Matlist with results"
	matlist resultMat
	
	
	
end

/***************************************
****************************************

	Write sub-commands for outputs
	
****************************************
***************************************/	
	
	
	******
	*Then the result matrix can be passed into subcommands that output in either Excel, LaTeX or in the main window.
	
	*The results can be accessed like this, which makes the sub-commands less sensitive to changing column order in the section above.
	//mat A = resultMat[3, "C0_Mean"] // returns a 1x1 matrix with the baseline mean for the countrol grop for the thrid outcome var
	//local a = el(A,1,1)				// returns the value
	
	//matlist A
	//di `a'

/***************************************
****************************************

	Write sub-commands for input testing
	
****************************************
***************************************/
			
	
	
cap program drop 	testDDdums
	program define	testDDdums

		args time treat samplevar outputvar
		
		*Test taht the dummies are dummies
		foreach dummy in `time' `treat' {

			cap assert inlist(`dummy',1,0) | missing(`dummy') | `samplevar' == 0
			if _rc {
				noi di as error "{phang}In the difference in differnce regression for outputvar [`outputvar'], the dummy [`dummy'] is not a real dummy as it has values differnt from 1 and 0. See tab below. The tab is restricted to the observations that are not excluded due to missing values etc. in the difference in differnce regression.{p_end}""
				noi tab `dummy' if `samplevar' == 1, missing
				error 480
			}
		}

		**Test that for only two of three dummies there are observations
		* that has only that dummy. I.e. the two that is not the
		* interaction. If the interaction is 1, all three shluld be 1.

		*Test that there is some observations in each group
		forvalues tmt01 = 0/1 {
			forvalues t01 = 0/1 {
				
				*Summary stats on this group
				count if `treat' == `t01' & `time' == `tmt01' & `samplevar' == 1
				
				//There got to be more than 1 observation in each group for the regression to make sense
				if `r(N)' < 2 {
					noi di as error "{phang}In the difference in differnce regression for outputvar [`outputvar'] there were not enough observations in each combination of treatment [`treat'] and time [`time']. The tab below is restricted to the observations that are not excluded due to missing values etc. in the difference in differnce regression.{p_end}""
					noi tab `treat' `time' if `samplevar' == 1, missing
					error 480
				
				}
			}
		}

	end

/***************************************
****************************************

	Write sub-commands for stats
	
****************************************
***************************************/
cap program drop 	templateResultMatrix
	program define	templateResultMatrix, rclass
	
	
	local 2ndDiff_cols 			2D 2D_err 2D_Stars 2D_N
	
	local 1stDiff_C_cols		1DC 1DC_err 1DC_stars 1DC_N 
	local 1stDiff_T_cols		1DT 1DT_err 1DT_stars 1DT_N 
	
	local basicMean_C0_cols		C0_mean C0_err C0_N
	local basicMean_T0_cols		T0_mean T0_err T0_N
	local basicMean_C1_cols		C1_mean C1_err C1_N
	local basicMean_T1_cols		T1_mean T1_err T1_N
	
	local colnames `2ndDiff_cols' `1stDiff_C_cols' `1stDiff_T_cols' `basicMean_C0_cols' `basicMean_T0_cols' `basicMean_C1_cols' `basicMean_T0_cols'
	
	*Define default row here. The results for each var will be one row that starts with all missing vlaues
	mat startRow = (.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.)
	mat colnames startRow = `colnames'
	
	return matrix startRow startRow
	
end 

	
cap program drop 	countStars
	program define	countStars, rclass
	
	args pvalue star1 star2 star3
	
	*Test if custom star levels are used
	if "`star1'" == "" {

		*Set default levels for 1, 2 and 3 stars
		local star1 .1
		local star2 .05
		local star3 .01
	}
	
	local stars 0
	foreach star_p_level in `star1' `star2' `star3' {

		if `pvalue' < `star_p_level' local ++stars
	}
	
	return local stars `stars'

end
	
