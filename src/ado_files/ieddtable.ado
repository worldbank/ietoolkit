
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
		rowlabtype(string) 									///
		rowlabtext(string)									///
		errortype(string)									///
		]
	
	/************* 
	
		Input handling
		
	*************/		
	
	*LABELS
	*Test and prepare the row lables and test how long the longest label is.
	prepRowLabels `varlist', rowlabtype("`rowlabtype'") rowlabtext("`rowlabtext'") 
	local rowlabels "`r(rowlabels)'"	
	local labmaxlen "`r(rowlabel_maxlen)'"	
	
	*ERRORTYPES
	*If error type is used test that it is only one word and that word is an allowed error type
	if "`errortype'" != "" {
		local errortype = lower("`errortype'")
		if (`: word count `errortype'' != 1) | !inlist("`errortype'", "sd", "se", "errhide") {
			noi di as error "Value in option errortype(`errortype') can only one out of the following words; se, sd, errhide."
			error 198
		}
	}
	else {
		*No errortype specified use default which is standard errors
		local errortype "se"
	}
	
	
	*DEFAULT STAR LEVELS
	*Default star levels if option not used
	if "`starlevels'" == "" local starlevels ".1 .05 .01"

	
	/************* 
		
		Initiate the result matrix
			
	*************/
	
	*Creates the template for the result matrix in a subfunction
	templateResultMatrix
	mat startRow = r(startRow)
	local colnames = "`r(colnames)'"
	
	*Remove this when ready for production
	//noi di "Start row to see headers, remove for production"
	//matlist startRow // See the default row with its column names
	
	*Initiate the result matrix with a place holder row that will not be used for anything. Matrices cannot be initiated empty
	mat ddtab_resultMap = startRow
	mat rownames ddtab_resultMap = placeholder
	
	
	/************* 
		
		Loop over all variables and prepare the data
			
	*************/
	
	foreach var of local varlist {
	
		//noi di "Variable `var'"
		
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
		
		//noi di "Rest table 2nd diff: reg `var' `tmt'#`t' `covariates'"
		//matlist resTable		
		
		**This is why this is done first. All other calculations 
		* for this outcome var should be restricted to this sample.
		gen `regsample' = e(sample)
		local N `e(N)'
		
		**Test that the dummy vars creates for valid groups for each 
		* combination of time and treat in the sample used for this outcome var
		testDDdums `t' `tmt' `regsample' `var'  //comment in when this is made into a command
		
		*Get the second differnce
		local ++colindex
		mat `var'[1,`colindex'] =  el(resTable,1,4) 
		
		*Get the standard error of second difference
		local ++colindex
		convertErrs el(resTable,2,4) `N' "`errortype'"
		mat `var'[1,`colindex'] =  `r(converted_error)' 
		
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
			
			//noi di "Rest table 1st diff: reg `var' `t' `covariates' if `tmt' == `tmt01' & `regsample' == 1"
			//matlist resTable
	
			//Get the 1st diff
			local ++colindex
			mat `var'[1,`colindex'] =  el(resTable,1,1) 
			
			*Get the standard error of 1st diff
			local ++colindex
			convertErrs el(resTable,2,1) `e(N)' "`errortype'"
			mat `var'[1,`colindex'] =  `r(converted_error)' 
			
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
				convertErrs el(resTable,2,1)  `e(N)' "`errortype'"
				mat `var'[1,`colindex'] =  `r(converted_error)' 
				
				*Get the N of the ordinary means regressions
				local ++colindex
				mat `var'[1,`colindex'] =  `e(N)' 	
			}
		}
		
		*Append this row to the result table
		mat 	ddtab_resultMap = (ddtab_resultMap \ `var')
	
	}
	
	*Remove placeholder row
	matrix ddtab_resultMap = ddtab_resultMap[2..., 1...]
	
	*Show the final matrix will all data needed to start building the output
	//noi di "Matlist with results"
	//matlist ddtab_resultMap
	
	/************* 
		
		Output table in result window
			
	*************/
	
	outputwindow `varlist' , ddtab_resultMap(ddtab_resultMap) labmaxlen(`labmaxlen') rwlbls(`rowlabels') ///
		starlevels("`starlevels'") covariates(`covariates') `errortype'

	/************* 
		
		Output table in LaTeX
			
	*************/
	
	if "`savetex'" != "" {
		
		//outputtex `varlist' , ddtab_resultMap(ddtab_resultMap) savetex(`savetex') 
	
	}
	

end


/***************************************
****************************************

	Write sub-commands for input handling
	
****************************************
***************************************/

**Program to prepare row labels for each outcome var, using variable name, 
* variable label or manually entered labels depedning on user input. Variable 
* names are used if no input.
cap program drop 	prepRowLabels
	program define	prepRowLabels, rclass
		
	syntax varlist, [rowlabtype(string) rowlabtext(string)]
	
	*First test input
	if "`rowlabtype'" == "varlab" | "`rowlabtype'" == "" | "`rowlabtype'" == "varname" {
		//All is good do nothing
	}
	else {
		noi display as error "{phang}Row label type [`rowlabtype'] is not a valid row label type. Enter either {it:varlab} or {it:varname} (the default if not specified is {it:varname}). See option {help ieddtable:rowlabtype} for details."
		error 198
	}

	/************* 
		Parse through the manually entered labels
	*************/	
	
	*Create a local with the rowlabel input to be tokenized
	local row_labels_to_tokenize `rowlabtext'
	
	while "`row_labels_to_tokenize'" != "" {

		*Parsing name and label pair
		gettoken nameAndLabel row_labels_to_tokenize : row_labels_to_tokenize, parse("@@")

		*Splitting name and label
		gettoken name label : nameAndLabel
		
		/*
			We store two locals, one with varnames and one with label. They are
			stored in the same order, so if we find varname we know we will find 
			the corresponding label in the same order in the other local.		
		*/

		*** Tests

		*Checking that the variables used in rowlabels() are included in the table
		local name_correct : list name in varlist
		if `name_correct' == 0 {
			noi display as error "{phang}Variable [`name'] listed in rowlabtext(`rowlabtext') is not found among the outcome variables."
			error 111
		}

		*Testing that no label is missing
		if "`label'" == "" {
			noi display as error "{phang}For variable [`name'] listed in rowlabtext(`rowlabels') you have not specified any label. Labels are requried for all variables listed in rowlabels(). Variables omitted from rowlabtext() will be assigned labels according to the rule in rowlabtype(). See also option {help ieddtable:rowlabtext}"
			error 198
		}
		
		*Storing the name in local to be used to get index of corresponding label in the second local
		local rowLabelNames `"`rowLabelNames' "`name'" "'
		
		*Removing leading or trailing spaces and store label with the same index as in the name local above
		local label = trim("`label'")
		local rowLabelLabels `"`rowLabelLabels' "`label'" "'

		
		*Parse char is not removed by gettoken, so remove it and start over
		local row_labels_to_tokenize = subinstr("`row_labels_to_tokenize'" ,"@@","",1)
	}
	
	**Set up locals to be returned. One with row labels without varname but in 
	* final order, and one local with length of longest label
	local preppedRowLabels
	local maxLen 0
	
	*Loop over all varaibles and prepare the labels
	foreach var of local varlist {
		
		**Get the index of this variable in manually entered labels. Index is 
		* zero if no manually entered label for this variable
		local rowLabPos : list posof "`var'" in rowLabelNames
		
		if `rowLabPos' == 0 {

			*No label was manually entered for this variable, use the other rules
			if "`rowlabtype'" == "varlab" {
				local this_label : variable label `var'		//Use variable label
			} 
			else {

				local this_label `var'						//Default, use varname

			}
		} 
		else {
			*Getting the manually defined label corresponding to this variable
			local this_label : word `rowLabPos' of `rowLabelLabels'
		}

		*Update the two locals that will be returned
		local preppedRowLabels "`preppedRowLabels' @@`this_label'"	//Prepare the final list
		local maxLen = max(strlen("`this_label'"),`maxLen')	//Store the length on the longest label, used on some outputs
	}
	
	*Return the locals
	return local rowlabels `preppedRowLabels'
	return local rowlabel_maxlen `maxLen'
	
end 	
	
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
				qui count if `treat' == `t01' & `time' == `tmt01' & `samplevar' == 1
				
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

*Sets up template for the result matrix
cap program drop 	templateResultMatrix
	program define	templateResultMatrix, rclass
	
	
	local 2ndDiff_cols 			2D 2D_err 2D_stars 2D_N
	
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
	return local colnames `colnames'
	
end 

*Take the significance levels and count number of starts	
cap program drop 	countStars
	program define	countStars, rclass
	
	args pvalue star1 star2 star3
	
	local stars 0
	foreach star_p_level in `star1' `star2' `star3' {

		if `pvalue' < `star_p_level' local ++stars
	}
	
	return local stars `stars'

end

*Take the significance levels and count number of starts	
cap program drop 	convertErrs
	program define	convertErrs, rclass
	
	args se_err N errortype
	
	*Test if custom star levels are used
	if "`errortype'" == "sd" {
		local err = `se_err' * sqrt(`N')
	}
	else {
		//For se keep se, for errhide keep se as matrix must have some value even if it will not be used
		local err = `se_err'
	}
	
	return local converted_error `err'
	
end


/***************************************
****************************************

	Write sub-commands for outputs
	
****************************************
***************************************/	
	
	
	******
	*Then the result matrix can be passed into subcommands that output in either Excel, LaTeX or in the main window.
	
	*The results can be accessed like this, which makes the sub-commands less sensitive to changing column order in the section above.
	//mat A = ddtab_resultMap[3, "C0_Mean"] // returns a 1x1 matrix with the baseline mean for the countrol grop for the thrid outcome var
	//local a = el(A,1,1)				// returns the value
	
	//matlist A
	//di `a'
	
	/*
		Column name dictionary
			Differences:
			- 2D : Second differnce coefficient (t*tmt == 1)
			- 1DC : First  differnce coefficient control (t == 0)
			- 1DT : First  differnce coefficient treatment (tmt == 0)
			
			for each coefficent these stats are also provided:
				- _err : Second differnce errors (type of errors is set in command errortype)
				- _stars :  Second Differene - The number of significance stars (sig level set in command)
				- _N : Second Difference - Number of observtions in the regression
				
			Group means:
			- C0 - Control time 0
			- T0 - Treatment time 0
			- C1 - Control time 1
			- T1 - Treatment time 1
			
			for each group these stats are also provided:
				- _mean : the mean of the group
				- _err : the error in the mean (type of errors is set in command errortype)
	
	*/
		
	
	
	cap program drop 	outputwindow
		program define	outputwindow
		
		/*
		Todo: 
			Add N somewhere
		
		
		*/
		
		syntax varlist , ddtab_resultMap(name) labmaxlen(numlist) rwlbls(string) [covariates(string) errhide sd se]
			
		if "`sd'" != "" local errlabel "SD"
		if "`se'" != "" local errlabel "SE"	
		
		local numVars = `:word count `varlist''
		
		local statlist 2D 1DT 1DC C0_mean T0_mean 2D_err 1DT_err 1DC_err C0_err T0_err
		local diformat = "%9.2f"
		
		local first_hhline = 2 + `labmaxlen' 
		local first_col = 4 + `labmaxlen'
		
		local bsln_space = 2
		local diff_space = 3
		
		local bsln_stat_right = `bsln_space' - 1
		
		local bsln_width = ((`bsln_space' * 2) + 8)
		local diff_width = ((`diff_space' * 2) + 10)		
		
		local ctrl_hline = `bsln_width' + 1 + `diff_width'
		local ctrl_space = (`ctrl_hline' - 7) / 2
		
		local tmt_hline = `bsln_width' + 1 + `diff_width'
		local tmt_space = (`tmt_hline' - 9) / 2	
	
		noi di as text "{c TLC}{hline `first_hhline'}{c TT}{hline `ctrl_hline'}{c TT}{hline `tmt_hline'}{c TT}{hline 17}{c TRC}"
		noi di as text "{c |}{col `first_col'}{c |}{dup `ctrl_space': }Control{dup `ctrl_space': }{c |}{dup `tmt_space': }Treatment{dup `tmt_space': }{c |}  Difference-in  {c |}"
		noi di as text "{c |}{col 3}{col `first_col'}{c |}{dup `bsln_space': }Baseline{dup `bsln_space': }{c |}{dup `diff_space': }Difference{dup `diff_space': }{c |}{dup `bsln_space': }Baseline{dup `bsln_space': }{c |}{dup `diff_space': }Difference{dup `diff_space': }{c |}   -difference   {c |}"

		if "`errhide'" == "" { 
			noi di as text "{c |}{col 3}Variable{col `first_col'}{c |}{dup `bsln_space': }Mean/(`errlabel'){dup `bsln_stat_right': }{c |}{dup `diff_space': }Coef/(`errlabel') {dup `diff_space': }{c |}{dup `bsln_space': }Mean/(`errlabel'){dup `bsln_stat_right': }{c |}{dup `diff_space': }Coef/(`errlabel') {dup `diff_space': }{c |}     Coef/(`errlabel')   {c |}"
		}
		else {
			noi di as text "{c |}{col 3}Variable{col `first_col'}{c |}{dup `bsln_space': }  Mean   {dup `bsln_stat_right': }{c |}{dup `diff_space': }   Coef   {dup `diff_space': }{c |}{dup `bsln_space': }  Mean   {dup `bsln_stat_right': }{c |}{dup `diff_space': }   Coef   {dup `diff_space': }{c |}       Coef      {c |}"
		}
		
		
		noi di as text "{c LT}{hline `first_hhline'}{c +}{hline `bsln_width'}{c +}{hline `diff_width'}{c +}{hline `bsln_width'}{c +}{hline `diff_width'}{c +}{hline 17}{c RT}"	
		
		//noi di "diff w : `diff_width'"
		//noi di "bsln w : `bsln_width'"
		
		forvalues row = 1/`numVars' {
			
			local rwlbls = trim(subinstr("`rwlbls'", "@@","", 1))
			gettoken label rwlbls : rwlbls, parse("@@")	
			
			foreach stat of local statlist {

				displayformatter , statname("`stat'") row(`row') ddtab_resultMap(ddtab_resultMap) diformat("`diformat'") bslnw(`bsln_width') diffw(`diff_width')	
				local `stat' `r(disp_stata)'
				local `stat'_space = `r(disp_pre_space)'
				
				//noi di "`stat' : ``stat'' : `r(disp_len)' : `r(disp_pre_space)'"	
			}
			
			*Disaplay each variable row at the same time
			noi di as text "{c |} `label'{col `first_col'}{c |}{dup `C0_mean_space': }`C0_mean'{dup `1DC_space': }`1DC'{dup `T0_mean_space': }`T0_mean'{dup `1DT_space': }`1DT'{dup `2D_space': }`2D'"
			
			if "`errhide'" == "" {  //Error hide is not nothing if errortype() is noerr
			
				noi di as text "{c |}{col `first_col'}{c |}{dup `C0_err_space': }`C0_err'{dup `1DC_err_space': }`1DC_err'{dup `T0_err_space': }`T0_err'{dup `1DT_err_space': }`1DT_err'{dup `2D_err_space': }`2D_err'"
			}
			
			
		}
	
		noi di as text "{c BLC}{hline `first_hhline'}{c BT}{hline `bsln_width'}{c BT}{hline `diff_width'}{c BT}{hline `bsln_width'}{c BT}{hline `diff_width'}{c BT}{hline 17}{c BRC}"
		
		*************************
		* Write notes below the table
		
		*Show stars levels
		local star1_value : word 1 of `starlevels'
		local star2_value : word 2 of `starlevels'
		local star3_value : word 3 of `starlevels'
		
			noi di as text "  The following variables was included as covariates [`covariates']"
		
		}
		
	end
	
	
cap program drop 	displayformatter
	program define	displayformatter, rclass
	
	syntax , statname(string) row(numlist) ddtab_resultMap(name) diformat(string)  bslnw(numlist) diffw(numlist)	
	
		mat temp = ddtab_resultMap[`row', "`statname'"]
		local `statname' = el(temp,1,1)
		local `statname' 	: display `diformat' ``statname''
		
		if inlist("`statname'", "2D", "1DT", "1DC") {
			
			mat starNumMat = ddtab_resultMap[`row', "`statname'_stars"]
			local starNum = el(starNumMat,1,1)		
		
			if `starNum' == 0 local `statname' "``statname''    "
			if `starNum' == 1 local `statname' "``statname''*   "
			if `starNum' == 2 local `statname' "``statname''**  "
			if `starNum' == 3 local `statname' "``statname''*** "	
		}
		
		local `statname' = ltrim("``statname''")
		
		if inlist("`statname'", "2D_err", "1DT_err", "1DC_err", "C0_err", "T0_err") {
			
			*Add brackets to errors
			local `statname' "(``statname'')"
		}
		
		
		local len = strlen("``statname''")
		//noi di "|``statname''|"
		//noi di `len'
		
		local numSpace 0
		
		if inlist("`statname'", "C0_mean", "T0_mean","C0_err", "T0_err") {
			local numSpace = `bslnw' - `len' - 1
		}	
		else if inlist("`statname'", "1DT", "1DC", "1DT_err", "1DC_err") {
			local numSpace = `diffw' - `len' - 1
		}
		else if inlist("`statname'", "2D", "2D_err") {
			local numSpace = 16 - `len'
		}
		
		if `numSpace' < 0 local numSpace 0
		
		
		if inlist("`statname'", "C0_err", "T0_err") {
			
			*Add brackets to errors
			return local disp_stata "``statname''{c |}"
			local ++numSpace 
		}
		else if inlist("`statname'", "2D_err", "1DT_err", "1DC_err")  {
			*Add brackets to errors
			return local disp_stata "``statname''    {c |}"
			local numSpace = `numSpace' - 3
		}
		else {
		
			return local disp_stata "``statname'' {c |}"
		
		}
		
		return local disp_pre_space = `numSpace'
		return local disp_len = `len'
		
	end
