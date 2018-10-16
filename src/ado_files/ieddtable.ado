
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
		diformat(string)									///
															///
		/* Output display */								///
		SAVETex(string)										///
		onerow												///
															///
		/* Tex output options */							///
		TEXDOCument											///
		TEXCaption(string)									///
		TEXLabel(string)									///
		TEXNotewidth(numlist min=1 max=1)					///
		texreplace											///
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
	
	** If the format option is specified, then test if there is a valid format specified
	if "`diformat'" != "" {

			** Creating a numeric mock variable that we attempt to apply the format
			*  to. This allows us to piggy back on Stata's internal testing to be
			*  sure that the format specified is at least one of the valid numeric
			*  formats in Stata
				tempvar  formattest
				gen 	`formattest' = 1
			cap	format  `formattest' `diformat'
			
			** Some error with the format
			if _rc == 120 {
				di as error "{phang}The format specified in diformat(`diformat') is not a valid Stata format. See {help format} for a list of valid Stata formats. This command only accept the f, fc, g, gc and e format.{p_end}"
				error 120
			}
			else if _rc != 0 {
				di as error "{phang}Something unexpected happened related to the option diformat(`diformat'). Make sure that the format you specified is a valid format. See {help format} for a list of valid Stata formats. If this problem remains, please report this error at https://github.com/worldbank/ietoolkit.{p_end}"
				error _rc
			}
			
			** Format is a valid format, but is it one we allow
			else {
				
				local fomrmatAllowed 0
				local charLast  = substr("`diformat'", -1,.)
				local char2Last = substr("`diformat'", -2,.)

				if  "`charLast'" == "f" | "`charLast'" == "e" {
					local fomrmatAllowed 1
				}
				else if "`charLast'" == "g" {
					if "`char2Last'" == "tg" {
						*format tg not allowed. all other valid formats ending on g are allowed
						local fomrmatAllowed 0
					}
					else {

						*Formats that end in g that is not tg can only be g which is allowed.
						local fomrmatAllowed 1
					}
				}
				else if  "`charLast'" == "c" {
					if "`char2Last'" != "gc" & "`char2Last'" != "fc" {
						*format ends on c but is neither fc nor gc
						local fomrmatAllowed 0
					}
					else {

						*Formats that end in c that are either fc or gc are allowed.
						local fomrmatAllowed 1
					}
				}
				else {
					*format is neither f, fc, g, gc nor e
					local fomrmatAllowed 0
				}
				if `fomrmatAllowed' == 0 {
					di as error "{phang}The format specified in diformat(`diformat') is not allowed. Only format f, fc, g, gc and e are allowed. See {help format} for details on Stata formats.{p_end}"
					error 120
				}
			}
		}
		else {
			*Default value if fomramt not specified
			local diformat = "%9.2f"
		}

	
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
		
		Test the matrix
			
	*************/
	
	*Test that onerow option is valid, i.e. the N in each column is the same across all rows

	if "`onerow'" != "" {
		noi testonerow `varlist', ddtab_resultMap(ddtab_resultMap) 
	}
	
	
	/************* 
		
		Output table in result window
			
	*************/
	
	outputwindow `varlist' , ddtab_resultMap(ddtab_resultMap) labmaxlen(`labmaxlen') rwlbls(`rowlabels') ///
		starlevels("`starlevels'") covariates(`covariates') `errortype' diformat(`diformat')

	/************* 
		
		Output table in LaTeX
			
	*************/
	if "`savetex'" != "" {
		
		outputtex `varlist', 	ddtab_resultMap(ddtab_resultMap) 	///
								savetex(`savetex') `texreplace'  ///
								`texdocument' texcaption("`texcaption'") texlabel("`texlabel'") texnotewidth(`texnotewidth') ///
								`onerow' starlevels("`starlevels'") diformat(`diformat') rwlbls("`rowlabels'") 
	
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

** Program that test the t and tmt variables are valid dummies 
*  for a Diff-in-Diff. I.e. they are both dummies and there are 
*  at least 2 observations in each combination (0,0), (1,0), 
*  (0,1) and (1,1) 
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
	
	
	*Set the names of the different columns in the result Matrix
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

**Convert the errors to the display stats picked 
* by the user. Standard errors is the default.
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

cap program drop 	testonerow
	program define	testonerow, rclass
	
	syntax varlist, ddtab_resultMap(name) 

qui {	
	local numVars :word count `varlist'
	
	*List of all columns that must be the same in case onerow is used
	local ncols 2D_N 1DC_N 1DT_N  C0_N T0_N
	
	*Loop over the columns with N
	foreach ncolname of local ncols {

		*Loop over the rows in the matrix
		forvalues row = 1/`numVars' {
			
			*Get the value from the matrix
			mat temp = ddtab_resultMap[`row', "`ncolname'"]
			local ncol = el(temp,1,1)
			
			*If it is the first row, save to be compared to later rows
			if `row' == 1 {
				local n = `ncol'
			}
			
			*If not the first row, compare this row to the first row, if it is not the same for all rows, then the option onerow is not valid.
			else if `n' != `ncol' {
			
				*Prepare string with explanatory column name
				if "`ncolname'" == "2D_N"	local colstring "2nd difference regregression"
				if "`ncolname'" == "1DC_N"	local colstring "1st difference regregression in control group"
				if "`ncolname'" == "1DT_N"	local colstring "1st difference regregression in treatment group"
				if "`ncolname'" == "C0_N"	local colstring "mean of control group in time = 0"
				if "`ncolname'" == "T0_N"	local colstring "mean of treatment group in time = 0"
				if "`ncolname'" == "C1_N"	local colstring "mean of control group in time = 1"
				if "`ncolname'" == "T1_N"	local colstring "mean of treatment group in time = 1"

				*Name of the variables
				local firstVar : word 1 	of `varlist'
				local thisVar  : word `row' of `varlist'
				
				noi di as error "{phang}There are different number of observations in the variables `firstVar' and `thisVar' in the `colstring'. The number of observations for each statistic must be same in all variables for the option {inp:onerow} to be valid. Either remove the {inp:onerow} option or investigate why the N is different accross variables.{p_end}"
				error 480				
			}
		}
	}
}
end

/***************************************
****************************************

	Write sub-commands for outputs
	
****************************************
***************************************/	
	
	
	/******
	The result matrix can be passed into subcommands that output in either Excel, LaTeX or in the main window.
	
	The name of the result matrix is ddtab_resultMap. It can be refernced like this ddtab_resultMap[row, col] where 
	row is the variable order where 1 is the first varaible in the varlist and col is the name of the stat.
	
	You always must make it first in to a 1x1 matrix, and then make that a local.
	
	*/
	
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
				- _N : number of observations in baseline means
	
	*/
		
		
	/************* 
		
		Output table in result window
			
	*************/	
	
	cap program drop 	outputwindow
		program define	outputwindow
		
		syntax varlist , ddtab_resultMap(name) labmaxlen(numlist) rwlbls(string) starlevels(string) diformat(string) [covariates(string) errhide sd se] 
		
		*Prepare lables for the erorrs to be displayed (in case any)
		if "`sd'" != "" local errlabel "SD"
		if "`se'" != "" local errlabel "SE"	
		
		*Count numbers of variables to loop over
		local numVars = `:word count `varlist''
		
		*List of variabls to display and loop over when formatting
		local statlist 2D 1DT 1DC C0_mean T0_mean 2D_err 1DT_err 1DC_err C0_err T0_err 2D_N 1DT_N 1DC_N C0_N T0_N
		
		*************************
		* Table width for label column
		
		local first_hhline = 2 + `labmaxlen' 
		local first_col = 4 + `labmaxlen'
		
		*************************
		* Table width for basline columns
		
		local bsln_space = 2
		local bsln_stat_left = `bsln_space' + 1
		local bsln_width = ((`bsln_space' * 2) + 8)	
		
		*************************
		* Table width for first difference column
		
		local diff_space = 3
		local diff_stat_left = `diff_space' + 1
		local diff_width = ((`diff_space' * 2) + 10)
		
		*************************
		* Table width control column
		
		local ctrl_hline = `bsln_width' + 1 + `diff_width'
		local ctrl_space = (`ctrl_hline' - 7) / 2
		
		*************************
		* Table width treatment column		
		
		local tmt_hline = `bsln_width' + 1 + `diff_width'
		local tmt_space = (`tmt_hline' - 9) / 2	
		
		*************************
		* Table width diff diff column	
		
		local didi_stat_left = 4
		local diffdiff_width  = 17
		
		*************************
		* Calculate stats column indexes	
		
		local bsln_c_col	= `first_col'  + `bsln_width' + 1
		local diff_c_col	= `bsln_c_col' + `diff_width' + 1
		local bsln_t_col	= `diff_c_col' + `bsln_width' + 1
		local diff_t_col	= `bsln_t_col' + `diff_width' + 1
		local didi_col		= `diff_t_col' + `diffdiff_width' + 1
		
		
		*************************
		* Start writing table	
		
		*Three title rows
		noi di as text "{c TLC}{hline `first_hhline'}{c TT}{hline `ctrl_hline'}{c TT}{hline `tmt_hline'}{c TT}{hline 17}{c TRC}"
		noi di as text "{c |}{col `first_col'}{c |}{dup `ctrl_space': }Control{dup `ctrl_space': }{c |}{dup `tmt_space': }Treatment{dup `tmt_space': }{c |}  Difference-in  {c |}"
		noi di as text "{c |}{col `first_col'}{c |}{dup `bsln_space': }Baseline{dup `bsln_space': }{c |}{dup `diff_space': }Difference{dup `diff_space': }{c |}{dup `bsln_space': }Baseline{dup `bsln_space': }{c |}{dup `diff_space': }Difference{dup `diff_space': }{c |}   -difference   {c |}"

		*Stats titels, show the stats displayed for each column in the order they are displayed
		noi di as text "{c |}{col `first_col'}{c |}{dup `bsln_stat_left': } Mean{col `bsln_c_col'}{c |}{dup `diff_stat_left': } Coef{col `diff_c_col'}{c |}{dup `bsln_stat_left': } Mean{col `bsln_t_col'}{c |}{dup `diff_stat_left': } Coef{col `diff_t_col'}{c |}{dup `didi_stat_left': } Coef{col `didi_col'}{c |}"
		if "`errhide'" == "" { 
			noi di as text "{c |}{col `first_col'}{c |}{dup `bsln_stat_left': }(`errlabel'){col `bsln_c_col'}{c |}{dup `diff_stat_left': }(`errlabel'){col `diff_c_col'}{c |}{dup `bsln_stat_left': }(`errlabel'){col `bsln_t_col'}{c |}{dup `diff_stat_left': }(`errlabel'){col `diff_t_col'}{c |}{dup `didi_stat_left': }(`errlabel'){col `didi_col'}{c |}"
		}	
		noi di as text "{c |}{col 3}Variable{col `first_col'}{c |}{dup `bsln_stat_left': } N{col `bsln_c_col'}{c |}{dup `diff_stat_left': } N{col `diff_c_col'}{c |}{dup `bsln_stat_left': } N{col `bsln_t_col'}{c |}{dup `diff_stat_left': } N{col `diff_t_col'}{c |}{dup `didi_stat_left': } N{col `didi_col'}{c |}"
		
		*Bottom row to table header
		noi di as text "{c LT}{hline `first_hhline'}{c +}{hline `bsln_width'}{c +}{hline `diff_width'}{c +}{hline `bsln_width'}{c +}{hline `diff_width'}{c +}{hline 17}{c RT}"	
		
		
		*Loop over each variable and prepare the row
		forvalues row = 1/`numVars' {
			
			*Get lables from the list of lables previosly prepared
			local rwlbls = trim(subinstr("`rwlbls'", "@@","", 1))
			gettoken label rwlbls : rwlbls, parse("@@")	
			
			*Loop over all the stats for this variable
			foreach stat of local statlist {
				
				**Run sub command that gets value from matrix and prepares it 
				* in the format suitable for the result window table (and adding
				* stars if applicable)
				windowdiformat , statname("`stat'") row(`row') ddtab_resultMap(ddtab_resultMap) diformat("`diformat'") bslnw(`bsln_width') diffw(`diff_width') ddw(`diffdiff_width')		
				
				*The main stat
				local `stat' `r(disp_stata)'
				
				*The number of spaces before the stat in the colum
				local `stat'_space = `r(disp_pre_space)'	
			}
			
			*Disaplay each variable row at the same time
			noi di as text "{c |} `label'{col `first_col'}{c |}{dup `C0_mean_space': }`C0_mean'{dup `1DC_space': }`1DC'{dup `T0_mean_space': }`T0_mean'{dup `1DT_space': }`1DT'{dup `2D_space': }`2D'"
			
			*Unless error type is errhide, show the errors on a seperate row
			if "`errhide'" == "" { 
				noi di as text "{c |}{col `first_col'}{c |}{dup `C0_err_space': }`C0_err'{dup `1DC_err_space': }`1DC_err'{dup `T0_err_space': }`T0_err'{dup `1DT_err_space': }`1DT_err'{dup `2D_err_space': }`2D_err'"
			}
			
			*The number of observations are shown on a separate row
			noi di as text "{c |}{col `first_col'}{c |}{dup `C0_N_space': }`C0_N'{dup `1DC_N_space': }`1DC_N'{dup `T0_N_space': }`T0_N'{dup `1DT_N_space': }`1DT_N'{dup `2D_N_space': }`2D_N'"
			
			
		}
		
		*Add bottom notes to the table
		noi di as text "{c BLC}{hline `first_hhline'}{c BT}{hline `bsln_width'}{c BT}{hline `diff_width'}{c BT}{hline `bsln_width'}{c BT}{hline `diff_width'}{c BT}{hline 17}{c BRC}"
		
		*************************
		* Write notes below the table
		
		noi di as text "  The baseline means only includes observations not omitted in the 1st and 2nd differences."
		
		*Show stars levels
		local star1_value : word 1 of `starlevels'
		local star2_value : word 2 of `starlevels'
		local star3_value : word 3 of `starlevels'
		noi di as text "  ***, **, and * indicate significance at the `star3_value', `star2_value', and `star1_value' percent critical level. "
		
		*List covariates used
		if ("`covariates'" != "") {
			noi di as text "  The following variable(s) was included as covariates [`covariates']"
		}

	end
	
	
cap program drop 	windowdiformat
	program define	windowdiformat, rclass
	
	syntax , statname(string) row(numlist) ddtab_resultMap(name) diformat(string)  bslnw(numlist) diffw(numlist) ddw(numlist)
	
		local numSpace 0
	
		mat temp = ddtab_resultMap[`row', "`statname'"]
		local `statname' = el(temp,1,1)
		
		if substr("`statname'", -2,.) == "_N" {
			local `statname'	: display %9.0f ``statname''
		}
		else {
			local `statname' 	: display `diformat' ``statname''
		}
		
		*Trime spaces on left from left.
		local `statname' = ltrim("``statname''")
		
		*For coefficients, add stars if applicable
		if inlist("`statname'", "2D", "1DT", "1DC") {
			
			mat starNumMat = ddtab_resultMap[`row', "`statname'_stars"]
			local starNum = el(starNumMat,1,1)		
		
			if `starNum' == 0 local `statname' "``statname''    "
			if `starNum' == 1 local `statname' "``statname''*   "
			if `starNum' == 2 local `statname' "``statname''**  "
			if `starNum' == 3 local `statname' "``statname''*** "	
		}
		
		*Add brackets to errors
		if inlist("`statname'", "2D_err", "1DT_err", "1DC_err", "C0_err", "T0_err") {
			local `statname' "(``statname'')"
		}
		
		*Get the lengt of the characters to display
		local len = strlen("``statname''")

		*Which column for this stat
		local colName = substr("`statname'", 1, 2)
		
		*Get corresponding width for that col
		if "`colName'" == "C0" local colw = `bslnw'
		if "`colName'" == "T0" local colw = `bslnw'
		if "`colName'" == "1D" local colw = `diffw'
		if "`colName'" == "2D" local colw = `ddw'
		
		* Calculate the number of spaces needed bofore 
		* the value and add spaces after it
		if inlist("`statname'", "C0_mean", "T0_mean", "C0_N", "T0_N") {
			*Baseline mean values
			return local disp_stata "``statname''  {c |}"
			local numSpace = `colw' - `len' - 2
		}
		else if inlist("`statname'", "C0_err", "T0_err") {
			*Baseline mean values errors
			return local disp_stata "``statname'' {c |}"
			local numSpace = `colw' - `len' - 1
		}
		else if inlist("`statname'", "1DT", "1DC", "2D") {
			*First difference coefficent
			return local disp_stata "``statname''{c |}"
			local numSpace = `colw' - `len'
		}
		else if inlist("`statname'", "1DT_N", "1DC_N", "2D_N") {
			*First difference coefficent
			return local disp_stata "``statname''    {c |}"
			local numSpace = `colw' - `len' - 4
		}
		else if inlist("`statname'", "1DT_err", "1DC_err", "2D_err")  {
			*First difference coefficient error
			return local disp_stata "``statname''   {c |}"
			local numSpace = `colw' - `len' - 3
		}
				
		
		**If numbers are so big that numSapce is negative, set it to 0 as
		* numSpace cannot be negative. Table will show incorrectly but 
		* will display.
		if `numSpace' < 0 local numSpace 0
		
		return local disp_pre_space = `numSpace'
		return local disp_len = `len'
		
	end

	/************* 
		
		Output table in LaTeX
			
	*************/
		
	***************
	* Output header
	***************
cap program drop 	outputtex
	program define	outputtex	
	
	syntax varlist, ddtab_resultMap(name) savetex(string) ///
					[texreplace onerow starlevels(string) diformat(string) rwlbls(string) ///
					texdocument texcaption(string) texlabel(string) texnotewidth(numlist)]
	
	******** Prepare inputs
	
		if "`texreplace'" != ""		local texreplace	replace
	
		* Test filename input
		**Find the last . in the file path and assume that
		* the file extension is what follows. If a file path has a . then
		* the file extension must be explicitly specified by the user.

		*Copy the full file path to the file suffix local
		local tex_file_suffix 	= "`savetex'"

		** Find index for where the file type suffix start
		local tex_dot_index 	= strpos("`tex_file_suffix'",".")

		*If no dot then no file extension
		if `tex_dot_index' == 0  local tex_file_suffix 	""

		**If there is one or many . in the file path than loop over
		* the file path until we have found the last one.
		while `tex_dot_index' > 0 {

			*Extract the file index
			local tex_file_suffix 	= substr("`tex_file_suffix'", `tex_dot_index' + 1, .)

			*Find index for where the file type suffix start
			local tex_dot_index 	= strpos("`tex_file_suffix'",".")
		}

		*If no file format suffix is specified, use the default .tex
		if "`tex_file_suffix'" == "" {

			local savetex `"`savetex'.tex"'
		}

		*If a file format suffix is specified make sure that it is one of the two allowed.
		else if !("`tex_file_suffix'" == "tex" | "`tex_file_suffix'" == "txt") {

			noi display as error "{phang}The file format specified in savetex(`savetex') is other than .tex or .txt. Only those two formats are allowed. If no format is specified .tex is the default. If you have a . in your file path, for example in a folder name, then you must specify the file extension .tex or .txt.{p_end}"
			error 198
		}


		tempname 	texname
		tempfile	texfile
		
	cap file close `texname'	
		file open  `texname' using 	"`texfile'", text write replace
		file write `texname' 		`"%%% Table created in Stata by ieddtable (https://github.com/worldbank/ietoolkit)"' _n _n
		file close `texname'
		
		* Create preamble for standalone document
		if "`texdocument'" != "" {
			texpreamble, texname("`texname'") texfile("`texfile'") texcaption("`texcaption'") texlabel("`texlabel'")
		}
		
			texheader, texname("`texname'") texfile("`texfile'") `onerow'
		
			texresults `varlist', ddtab_resultMap(ddtab_resultMap) ///
								  diformat("`diformat'") rwlbls("`rwlbls'") ///
								  texname("`texname'") texfile("`texfile'") ///
								  `onerow' 

		if "`onerow'" != "" {
			texonerow, ddtab_resultMap(ddtab_resultMap) texname("`texname'") texfile("`texfile'")
		}
			texfooter, texname("`texname'") texfile("`texfile'") texnotewidth(`texnotewidth') `onerow'
		
	copy "`texfile'" `"`savetex'"', `texreplace'

	noi di as result `"{phang}Balance table saved to: {browse "`savetex'":`savetex'} "'
	
end

cap program drop	texresults
	program define	texresults
	
	syntax	varlist, ddtab_resultMap(name) texname(string) texfile(string) diformat(string) rwlbls(string) [onerow]

		*Count numbers of variables to loop over
		local numVars = `:word count `varlist''
		
		*List of variabls to display and loop over when formatting
		local statlist 2D 1DT 1DC C0_mean T0_mean 2D_err 1DT_err 1DC_err C0_err T0_err 2D_N 1DT_N 1DC_N C0_N T0_N

		* Loop over variables
		forvalues row = 1/`numVars' {
		
			*Get lables from the list of lables previosly prepared
			local rwlbls = trim(subinstr("`rwlbls'", "@@","", 1))
			gettoken label rwlbls : rwlbls, parse("@@")	
			
			foreach stat of local statlist {
			
				**Run sub command that gets value from matrix and prepares it 
				* in the format suitable for the LaTeX table (and adding
				* stars if applicable)
				texdiformat , statname("`stat'") row(`row') ddtab_resultMap(ddtab_resultMap) diformat("`diformat'")	`onerow'
				
				*The main stat
				local `stat' `r(disp_tex)'
				
			}
				

			file open  `texname' using 	"`texfile'", text write append
			file write `texname'		"`label' `C0_N'  & \begin{tabular}[t]{@{}c@{}} `C0_mean' \\ `C0_err'  \end{tabular}" ///
											   " `1DC_N' & \begin{tabular}[t]{@{}c@{}} `1DC'     \\ `1DC_err' \end{tabular}" ///
											   " `T0_N'  & \begin{tabular}[t]{@{}c@{}} `T0_mean' \\ `T0_err'  \end{tabular}" ///
											   " `1DT_N' & \begin{tabular}[t]{@{}c@{}} `1DT'     \\ `1DT_err' \end{tabular}" ///
											   " `2D_N'  & \begin{tabular}[t]{@{}c@{}} `2D'      \\ `2D_err'  \end{tabular} \rule{0pt}{0pt}\\" _n
			file close `texname'
		}
		
end

cap program drop 	texdiformat
	program define	texdiformat, rclass
	
	syntax , statname(string) row(numlist) ddtab_resultMap(name) diformat(string) [onerow]
	
		mat temp = ddtab_resultMap[`row', "`statname'"]
		local `statname' = el(temp,1,1)
		
		if substr("`statname'", -2,.) == "_N" {
			local `statname'	: display %9.0f ``statname''
		}
		else {
			local `statname' 	: display `diformat' ``statname''
		}
		
		*Trime spaces on left from left.
		local `statname' = ltrim("``statname''")
		
		*For coefficients, add stars if applicable
		if inlist("`statname'", "2D", "1DT", "1DC") {
			
			mat starNumMat = ddtab_resultMap[`row', "`statname'_stars"]
			local starNum = el(starNumMat,1,1)		
		
			if `starNum' == 0 local `statname' "``statname''    "
			if `starNum' == 1 local `statname' "``statname''*   "
			if `starNum' == 2 local `statname' "``statname''**  "
			if `starNum' == 3 local `statname' "``statname''*** "	
		}
		
		*Add brackets to errors
		if inlist("`statname'", "2D_err", "1DT_err", "1DC_err", "C0_err", "T0_err") {
			local `statname' "(``statname'')"
		}
		
		*Only add number of observations of onerow is not specified
		if inlist("`statname'", "2D_N", "1DT_N", "1DC_N", "C0_N", "T0_N") {
			if "`onerow'" == "" {
				local `statname' `" & ``statname'' "'
			}
			else {
				local `statname'	""
			}
		}
		
		return local disp_tex "``statname''"
end

cap program drop	texpreamble
	program define	texpreamble
	
	syntax	, texname(string) texfile(string)[texcaption(string) texlabel(string)]
					
		file open  `texname' using 	`"`texfile'"', text write append
		file write `texname' 		`"\documentclass{article}"' _n ///
									`""' _n ///
									`"% ----- Preamble "' _n ///
									`"\usepackage[utf8]{inputenc}"' _n ///
									`"\usepackage{adjustbox}"' _n ///
									`"% ----- End of preamble "' _n ///
									`""' _n ///
									`" \begin{document}"' _n ///
									`""' _n ///
									`"\begin{table}[!htbp]"' _n ///
									`"\centering"' _n
									
		* Write tex caption if specified
		if "`texcaption'" != "" {
		
			* Make sure special characters are displayed correctly
			local texcaption : subinstr local texcaption "%"  "\%" , all
			local texcaption : subinstr local texcaption "_"  "\_" , all
			local texcaption : subinstr local texcaption "&"  "\&" , all

			file write `texname' 	`"\caption{`texcaption'}"' _n

		}
		
		* Write tex label if specified
		if "`texlabel'" != "" {

			file write `texname' 	`"\label{`texlabel'}"' _n

		}

		
		file write `texname'		`"\begin{adjustbox}{max width=\textwidth}"' _n
		file close `texname'
	
end

cap program drop	texheader
	program define	texheader
	
	syntax	, texname(string) texfile(string) [onerow]
	
			
		if "`onerow'" != "" {
		
			local	toprowcols		2
			local	bottomrowcols	1
			local 	colstring		lccccc
			local	ncol			""
		
		}
		else {
			
			local	toprowcols		4
			local	bottomrowcols	2
			local 	colstring		lcccccccccc
			local	ncol			"& N "

		}
		
	
		* Write tex header
		file open  `texname' using 	"`texfile'", text write append
		file write `texname'		"\begin{tabular}{@{\extracolsep{5pt}}`colstring'}" _n ///
									"\hline \hline \\[-1.8ex]" _n ///
									"& \multicolumn{`toprowcols'}{c}{Control} & \multicolumn{`toprowcols'}{c}{Treatment}  & \multicolumn{`bottomrowcols'}{c}{Difference-in-differences} \\" _n ///
									"& \multicolumn{`bottomrowcols'}{c}{Baseline} & \multicolumn{`bottomrowcols'}{c}{Difference} & \multicolumn{`bottomrowcols'}{c}{Baseline} & \multicolumn{`bottomrowcols'}{c}{Difference} & \multicolumn{`bottomrowcols'}{c}{} \\" _n ///
									"Variable `ncol' & Mean`errortitle' `ncol' & Coef`errortitle' `ncol' & Mean`errortitle' `ncol' & Coef`errortitle' `ncol' & Coef`errortitle' \\ \hline \\[-1.8ex]" _n
		file close `texname'
		
end

cap program drop	texfooter
	program define	texfooter
	
	syntax	, texname(string) texfile(string) [texnotewidth(numlist) onerow]

		if "`onerow'" != "" {
			local	countcols		6
		}
		else {
			local 	countcols		11
		}
		
		if "`texnotewidth'" == "" {
			local 	texnotewidth 	1
		}
			
		file open  `texname' using 	"`texfile'", text write append		
		file write `texname'		"\hline \hline \\[-1.8ex]" _n ///
									"%%% This is the note. If it does not have the correct margins, use texnotewidth() option or change the number before '\textwidth' in line below to fit it to table size." _n ///
									"\multicolumn{`countcols'}{@{} p{`texnotewidth'\textwidth}}" _n ///
									"{\textit{Notes}: `tblnote'}" _n ///
									"\end{tabular}" _n ///
									"\end{adjustbox}" _n ///
									"\end{table}" _n _n ///
									"\end{document}" _n

		file close `texname'
		
end

cap program drop	texonerow
	program define	texonerow
	
	syntax	, texname(string) texfile(string) ddtab_resultMap(name)
	
		*Check that all rows have the same number of obs

		*List of variabls to add
		local statlist 2D_N 1DT_N 1DC_N C0_N T0_N

		*Get their values
		foreach stat of local statlist {
		
			mat temp = ddtab_resultMap[`row', "`statname'"]
			local `statname' = el(temp,1,1)
			
			if substr("`statname'", -2,.) == "_N" {
				local `statname'	: display %9.0f ``statname''
			}
			else {
				local `statname' 	: display `diformat' ``statname''
			}
			
			*Trime spaces on left from left.
			local `statname' = ltrim("``statname''")
			
		}
			
		file open  `texname' using 	"`texfile'", text write append
		file write `texname'		
		file close `texname'
	
		
end

