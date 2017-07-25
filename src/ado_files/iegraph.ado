*! version 5.1 31MAY2017  Kristoffer Bjarkefur kbjarkefur@worldbank.org
	
cap	program drop	iegraph
	program define 	iegraph , rclass
	
	syntax varlist, [noconfbars BASICTItle(string) save(string) confbarsnone(varlist) 	///
						confintval(numlist min=1 max=1 >0 <1) VARLabels BAROPTions(string) norestore  	///
						GREYscale yzero *]
	
	
	if "`restore'" == "" preserve
	
	qui {
	
	version 11
	
	*Load regression results
	mat beta_ = e(b)

	local counter = 0

	*Checking to see if the noconfbars option has been used and assigning 1 and 0 based
	*on that to the CONFINT_BAR variable.
	if "`confbars'" 		!= "" {
		local CONFINT_BAR 	= 0 
	}
	else if "`confbars'" 	== "" {
		local CONFINT_BAR 	= 1 
	}
	
	*Testing to see if the variables used in confbarsnone are 
	*actually in the list of 
	*variables used for the regression/graph.
	local varTest : list confbarsnone in varlist

	if `varTest' == 0 {
		*Error displayed if variables defined in confbarsnone aren't in the list of variables for the graph.
		noi display as error "{phang} Variables defined in confbarsnone(`confbarsnone') cannot be found in the graph variable list. {p_end}"
		noi display ""
		error 111
	}
	
	
	*Testing to see if the variables used in the regressions are actual dummy variables as treatment vars need to be dummy variables. 
	foreach var of local varlist{
		cap assert inlist(`var',0,1) | missing(`var')
		if _rc {
			noi display as error "{phang} The variable `var' is not a dummy. Treatment variable needs to be a dummy (0 or 1) variable. {p_end}"
			noi display ""
			error 149
		}
					
		local counter = `counter' + 1
		
		*Assigning variable coefficient/standard errors/no of obs. to scalars with the name Coeff_(`variable name') 
		*coeff_se_(`variable name'), obs_(`variable name').
		
		scalar coeff_`var' 		= _b[`var'] 
		scalar coeff_se_`var' 	= _se[`var']
		
		count if e(sample) == 1 & `var' == 1 //Count one tmt group at the time
		scalar obs_`var' = r(N)

	} 
		
	*Checking to see if the save option is used what is the extension related to it. 
	if "`save'" != "" {
	
		**Find the last . in the path name and assume that
		* the file extension is what follows. However, with names
		* that have multiple dots in it, the user has to explicitly 
		* specify the file name. 
		
		**First, will extract the file names from the combination of file
		* path and files names. We will use both backslash and forward slash  
		* to account for differences in Windows/Unix file paths
		local backslash = strpos(reverse("`save'"), "\")
		local forwardslash = strpos(reverse("`save'"), "/")
		
		** Replacing the value of forward/back slash with the other value if one of the
		*  values is equal to zero. 	
        if `forwardslash' == 0  local forwardslash = `backslash'
        if `backslash' == 0     local backslash = `forwardslash'
        
		**Extracting the file name from the full file path by  reversing and breaking the path
		* at the first occurence of slash. 
		local file_name = substr(reverse("`save'"), 1, (min(`forwardslash', `backslash')-1))
		local file_name = reverse("`file_name'")

		**If no slashes it means that there is no file path and just a file name, so the name of the file will be
		* the local save.
		if (`forwardslash' == 0 & `backslash' == 0) local file_name = "`save''"  
		
		*Assign the full file path to the local file_suffix
		local file_suffix = "`file_name'"
				
        *Find index for where the file type suffix start
        local dot_index     = strpos("`file_name'",".") 
		
		local file_suffix = substr("`file_name'", `dot_index' + 1, .)
		
		*If no dot in the name, then no file extension
		if `dot_index' == 0 {
			local save `"`save'.gph"'
			local file_suffix "gph"
			local save_export = 0
		}
		
		**If there is one or many . in the file path than loop over 
		* the file path until we have found the last one.
		
		**Find index for where the file type suffix start. We are re-checking
		* to see if there are any more dots than the first one. If there are, 
		* then there needs to be an error message saying remove the dots.
		local dot_index 	= strpos("`file_suffix'",".")
		
		*Extract the file index
					
		if (`dot_index' > 0) {
			di as error "{pstd}File names cannot have more than one dot. Please only use the dot to separate the filename and file format.{p_end}"
			error 198
		}
				
        *List of formats to which the file can be exported
        local nonGPH_formats png tiff gph ps eps pdf wmf emf

        *If no file format suffix is specified, use the default .gph
        if "`file_suffix'" == "gph" {
			local save_export = 0
		}

        *If a file format suffix is specified make sure that it is one of the eight formats allowed.
        else if `:list file_suffix in nonGPH_formats' != 0  {
            local save_export = 1
			
			if ("`file_suffix'" == "wmf" | "`file_suffix'" == "emf") & "`c(os)'" != "Windows" {
				di as error "{pstd}The file formats .wmf and .emf are only allowed when using Stata on a Windows computer.{p_end}"
                error 198
			} 
		}
		*If a different extension was used then displaying an error. 
        else {
		
            di as error "{pstd}You are not using a allowed file format in save(`save'). Only the following formats are allowed: gph `nonGPH_formats'. {p_end}"
            error 198
        }
    }
	else {
		
		*Save option is not used, therefore save export will not be used
		local save_export = 0
		
	}
	
	
	local count: word count `varlist' // Counting the number of total vars used as treatment.
	local graphCount = `count' + 1 // Number of vars needed for the graph is total treatment vars plus one(control).

	//Make all vars tempvars (maybe do later)
	//Make sure that missing is properly handled
	
	tempvar anyTMT control
	egen `anyTMT' = rowmax(`varlist') 	if e(sample) == 1
	gen `control' = (`anyTMT' == 0) 	if !missing(`anyTMT')

	sum `e(depvar)' if e(sample) == 1 & `control' == 1
	scalar ctl_N		= r(N)
	scalar ctl_mean	  	= r(mean)
	scalar ctl_mean_sd 	= r(sd)	

	
	/**
	 Calculate t-statistics
	**/
	
	*If not set in options, use default of 95%
	if "`confintval'" == "" {
		local confintval = .95
	}
	
	**Since we calculating each tail separetely we need to convert
	* the two tail % to one tail %
	local conintval_1tail = ( `confintval' + (1-`confintval' ) / 2)

	*degreeds of freedom in regression
	local df = `e(df_r)'
	
	*Calculate t-stats to be used
	local tstats = invt(`df' , `conintval_1tail'  )

	
	foreach var of local varlist {
		
		*Caculating confidnece interval
		scalar  conf_int_min_`var'   =	(coeff_`var'-(`tstats'*coeff_se_`var') + ctl_mean) 
		scalar  conf_int_max_`var'   =	(coeff_`var'+(`tstats'*coeff_se_`var') + ctl_mean) 
		**Assigning stars to the treatment vars.
		
		*Perform the test to get p-values
		test `var' 
		local star_`var' " "
		
		scalar  pvalue =r(p)
		if pvalue < 0.10 {
			local star_`var' "*"
		}
		if pvalue < 0.05 {
			local star_`var' "**"
		}
		if pvalue < 0.01 {
			local star_`var' "***"
		}

		scalar tmt_mean_`var' = ctl_mean + coeff_`var'
	}

	/*************************************
	
		Set up temp file where results are written
	
	*************************************/	

	tempfile		 newTextFile
	tempname 		 newHandle	
	cap file close 	`newHandle'	
	file open  		`newHandle' using "`newTextFile'", text write append
	
	*Write headers and control value
	file write `newHandle' ///
		"position" 	_tab "xLabeled"	_tab "mean" _tab "coeff" _tab "conf_int_min" _tab "conf_int_max" _tab "obs" _tab "star" _n 	///
		%9.3f (1) _tab "Control"  _tab %9.3f (ctl_mean)      _tab  	_tab   _tab _tab %9.3f (ctl_N) 	 _tab  _n 

	tempvar newCounter 
	gen `newCounter' = 2  //First tmt group starts at 2 (1 is control)
	
	foreach var in `varlist' {
	
		if "`varlabels'" == "" {
		
			*Default is to use the varname in legend
			local var_legend "`var'"
		
		}
		else {
			
			*Option to use the variable label in the legen instead
			local var_legend : variable label `var'
			
		}
		
		*Writing the necessary tables for the graph to list to file.
	    if `: list var in confbarsnone' { 
			file write `newHandle' 	%9.3f (`newCounter') _tab `"`var_legend'"'  ///
			_tab %9.3f (tmt_mean_`var') _tab  %9.3f (coeff_`var')  _tab _tab ///
			_tab %9.3f (obs_`var') _tab "`star_`var''"  _n 
			
			replace `newCounter' = `newCounter' + 1	
		}
		else {	
			file write `newHandle' %9.3f (`newCounter') _tab `"`var_legend'"' ///
			_tab %9.3f (tmt_mean_`var') _tab  %9.3f (coeff_`var')  			///
			_tab %9.3f (conf_int_min_`var') _tab %9.3f (conf_int_max_`var')	///
			_tab %9.3f (obs_`var')   _tab "`star_`var''"  _n 
			
			replace `newCounter' = `newCounter' + 1
		}
	}
	
	file close `newHandle'	
	
	/*************************************
	
		Create the graph
	
	*************************************/
	
	*Read file with results
	insheet using `newTextFile', clear
	
	*Defining various options to go on the graph option. 
	
	local tmtGroupBars 	""
	local xAxisLabels 	`"xlabel( "'
	local legendLabels	""
	local legendNumbers	""
	
	forval tmtGroupCount = 1/`graphCount' {
	
		************
		*Create the bar for this group
		
		if "`greyscale'" == "" {
			colorPicker `tmtGroupCount' `graphCount' 
		}
		else {
			greyPicker `tmtGroupCount' `graphCount' 
		}
		
		local tmtGroupBars `"`tmtGroupBars' (bar mean position if position == `tmtGroupCount', `baroptions' color("`r(color)'") lcolor(black) ) "' 
		
		************
		*Create labels etc. for this group	

		local obs 			= obs[`tmtGroupCount'] 
		local stars 		= star[`tmtGroupCount']
		local legendLabel 	= xlabeled[`tmtGroupCount']
		
		local xAxisLabels 	`"`xAxisLabels' `tmtGroupCount' "(N = `obs') `stars'" "'
		local legendLabels 	`"`legendLabels' lab(`tmtGroupCount' "`legendLabel'") "'
		local legendNumbers	`"`legendNumbers' `tmtGroupCount'"' 
	}
	
	*Close or comple some strings
	local xAxisLabels `"`xAxisLabels' ,noticks labsize(medsmall)) "'
	local legendOption `"legend(order(`legendNumbers') `legendLabels')"'


	*Create the confidence interval bars

	if `CONFINT_BAR' == 0 {

		local confIntGraph = ""
	} 
		else if `CONFINT_BAR' == 1 {
		local confIntGraph = `"(rcap conf_int_max conf_int_min position, lc(gs)) (scatter mean position,  msym(none)  mlabs(medium) mlabpos(10) mlabcolor(black))"'
	}
	
	local titleOption `" , xtitle("") ytitle("`e(depvar)'") "'

	if "`save'" != "" {
		local saveOption saving("`save'", replace)
	}
	
	*******************************************************************************
	*** Generating the graph axis labels for the y-zero option used..
	*******************************************************************************
	**Checking to verify if the minimum value is less than 0.
	* This is useful if the minimum value is less than 0, and
	* y-zero is used. 
	
	gen minvalue = min(mean, conf_int_min, conf_int_max)
	sum minvalue
	
	*Finding the max value that is needed in the Y-axis. 
		
	gen maxvalue = max(mean , conf_int_max, conf_int_min)
	sum maxvalue 
		
	local signcheck = ((`r(max)' * `r(min)') >= 0)
		
	if  ("`yzero'" != "" & `signcheck' == 0 ) {
		noi di in red "WARNING:"
		noi di "{pstd} Some values are positive and some values are negative, yzero option will be ignored. {p_end}"
	}
	else if ( "`yzero'" != "" & `signcheck' == 1 )  {
		
		*From the max of mean values and conf_int_max values.
		sum maxvalue
		local max = `r(max)'
		sum minvalue
		local min = abs(`r(min)')
		
		*Log10 of the Max value to find the order necessary.
		local logmax = log10(`max')
		local logmax = round(`logmax') - 1
		
		local logmin = (log10(`min'))
		local logmin = round(`logmin') - 1
		
		*Generating tenpower which is 1 order smaller than the max value,
		*so we can log to that. 
		local tenpower = 10 ^ (`logmax')
		local tenpower_min = (10 ^ `logmin') 
		
		*Rounding up for max value.
		local up = `tenpower' * ceil(`max' / `tenpower')
		local down = `tenpower_min' * (ceil(`min'/ `tenpower_min'))
		
		*Generating quarter value for y-axis markers.
		local quarter = (`up') / 4
		
		local quarter_min = (`down') / 4
		
		local down = `down' * (-1)
		
		*Specifying the option itself. 
		if `r(max)' > 0 & `r(min)' > 0 { 
			local yzero_option ylabel(0(`quarter')`up')
		}
			else {
			local yzero_option ylabel(`down'(`quarter_min')0)
		}
	}

	*******************************************************************************
	***Graph generation based on if the option save has a export or a save feature.
	*******************************************************************************
	
	*Store all the options in one local
	local commandline 		`" `tmtGroupBars' `confIntGraph' `titleOption'  `legendOption' `xAxisLabels' title("`basictitle'") `yzero_option' `options'  "'
	noi di `"`commandline'"'
	*Error message used in both save-option cases below.
	local graphErrorMessage `" Something went wrong while trying to generate the graph. Click {stata di r(cmd) :display graph options } to see what graph options iegraph used. This can help in locating the source of the error in the command. "'
	
	if `save_export' == 0 {
		
		*Generate a return local with the code that will be used to generate the graph
		return local cmd `"graph twoway `commandline' `saveOption'"'
		
		*Generate the graph
		cap graph twoway `commandline' `saveOption'
		
		*If error, provide error message and then run the code again allowing the program to crash
		if _rc { 
			
			di as error "{pstd}`graphErrorMessage'{p_end}"
            graph twoway `commandline' `saveOption'
		}
	}
	else if `save_export' == 1 {
		
		*Generate a return local with the code that will be used to generate the graph
		return local cmd `"graph twoway `commandline'"'
		
		*Generate the graph
		cap graph twoway `commandline'
		
		*If error, provide error message and then run the code again allowing the program to crash
		if _rc { 
			
			di as error "{pstd}`graphErrorMessage'{p_end}"
            graph twoway `commandline'
		}
		
		*Export graph to preferred option
		graph export "`save'", replace
		
	}	
	
	if "`restore'" == "" restore
}

end
	*******************************************
	*******************************************
		******* To pick colours based *******
		******* on the number of vars *******
	*******************************************
	*******************************************
	cap	program drop	colorPicker
		program define 	colorPicker , rclass
		
		args groupCount totalNumGroups 
		
		if `totalNumGroups' == 2 {
			
			if `groupCount' == 1 return local color "215 25 28"
			if `groupCount' == 2 return local color "43 123 182"
		}
		else if `totalNumGroups' == 3 {

			if `groupCount' == 1 return local color "215 25 28"
			if `groupCount' == 2 return local color "255 255 191"
			if `groupCount' == 3 return local color "43 123 182"
		}
		else if `totalNumGroups' == 4 {
		
			if `groupCount' == 1 return local color "215 25 28"
			if `groupCount' == 2 return local color "255 255 191"
			if `groupCount' == 3 return local color "171 217 233"
			if `groupCount' == 4 return local color "43 123 182"
		}
		else {
			
			*For five or more colors we repeat the same pattern

			local colourNum = mod(`groupCount', 5)
			if `colourNum' == 1 return local color "215 25 28"
			if `colourNum' == 2 return local color "253 174 93"
			if `colourNum' == 3 return local color "255 255 191"
			if `colourNum' == 4 return local color "171 217 233"
			if `colourNum' == 0 return local color "43 123 182"
			
		}
		
	end
	*******************************************
	*******************************************
		******* Greyscale Option *******
		******* Colour Picker    *******	
	*******************************************
	*******************************************

	cap	program drop	greyPicker
		program define 	greyPicker , rclass
		
		args groupCount totalNumGroups 
		
		if `groupCount' == 1 {
			
			return local color "black"
		}
		else if `groupCount' == 2 & `totalNumGroups' <= 3 {
			
			return local color "gs14"
		}
		else {
		
			local grayscale =  round( (`groupCount'-1) * (100 / (`totalNumGroups'-1) )) 
		
			return local color "`grayscale' `grayscale' `grayscale' `grayscale'"
		}
		
	end
