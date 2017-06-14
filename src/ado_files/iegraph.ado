*! version 5.1 31MAY2017  Kristoffer Bjarkefur kbjarkefur@worldbank.org
	
cap	program drop	iegraph2
	program define 	iegraph2 , rclass
	
	preserve
	
	syntax varlist, [noconfbars BASICTItle(string) save(string) confbarsnone(varlist) VARLabels BAROPTions(string) GREYscale yzero *]
	
	qui{
	
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
	
	*Testing to see if the variables used in confbarsnone are actually in the list of 
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
		
		scalar coeff_`var' = _b[`var'] 

		scalar coeff_se_`var' = _se[`var']
		
		count if e(sample) == 1 & `var' == 1 //Count one tmt group at the time
		scalar obs_`var' = r(N)

	} 
		
	*Checking to see if the save option is used what is the extension related to it. 
	if "`save'" != "" {
	
        *Find index for where the file type suffix start
        local dot_index     = strpos("`save'",".") + 1
		 
        *Extract the file index
        local file_suffix   = substr("`save'", `dot_index', .)
	        
		*List of formats to which the file can be exported
        local nonGPH_formats png tiff gph ps eps pdf wmf emf

        *If no file format suffix is specified, use the default .gph
        if `dot_index' == 1 | "`file_suffix'" == "gph" {
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
		
            di as error "{pstd}You are not using a allowed file format in save(`save'). Only the following formats are allowed: gph `nonGPH_formats'{p_end}"
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

	foreach var of local varlist {
		
		*Caculating confidnece interval
		scalar  conf_int_min_`var'   =	coeff_`var'-(1.96*coeff_se_`var') + ctl_mean
		scalar  conf_int_max_`var'   =	coeff_`var'+(1.96*coeff_se_`var') + ctl_mean

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
		"order" 	_tab "xLabeled"	_tab "mean" _tab "coeff" _tab "conf_int_min" _tab "conf_int_max" _tab "obs" _tab "star" _n 	///
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
	
	*Rread file with results
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
		
		local tmtGroupBars `"`tmtGroupBars' (bar mean order if order == `tmtGroupCount', `baroptions' color("`r(color)'") lcolor(black) ) "' 
		
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
		local confIntGraph = `"(rcap conf_int_max conf_int_min order, lc(gs)) (scatter mean order,  msym(none)  mlabs(medium) mlabpos(10) mlabcolor(black))"'
	}
	
	local titleOption `" , xtitle("") ytitle("`e(depvar)'") "'

	if "`save'" != "" {
		local saveOption saving("`save'", replace)
	}
	
	*******************************************************************************
	*** Generating the graph axis labels for the y-zero option used..
	*******************************************************************************
	
	if "`yzero'" != "" {
		
		*Finding the max value that is needed in the Y-axis. 
		gen maxvalue = max(mean , conf_int_max)
		sum maxvalue 
		
		*From the max of mean values and conf_int_max values.
		local max = `r(max)'
		
		*Log10 of the Max value to find the order necessary.
		local logmax = log10(`max')
		local logmax = round(`logmax') - 1
		
		*Generating tenpower which is 1 order smaller than the max value,
		*so we can log to that. 
		local tenpower = 10 ^ (`logmax')
		
		*Rounding up for max value.
		local up = `tenpower' * ceil(`max' / `tenpower')
		
		*Generating quarter value for y-axis markers.
		local quarter = (`up') / 4
		
		*Specifying the option itself. 
		local yzero_option ylabel(0(`quarter')`up')
	}

	*******************************************************************************
	***Graph generation based on if the option save has a export or a save feature.
	*******************************************************************************
	
	*Store all the options in one local
	local commandline 		`" `tmtGroupBars' `confIntGraph' `titleOption'  `legendOption' `xAxisLabels' title("`basictitle'") `yzero_option' `options'  "'
	
	*Error message used in both save-option cases below.
	local graphErrorMessage `" Something went wrong while trying to generate the graph. Click {stata di r(cmd) :display graph options } to see what graph options iegraph used. This can help in de-bugging your code. "'
	
	if `save_export' == 0 {
		
		*Generate a return local with the code that will be used to generate the graph
		return local cmd `"graph twoway `tmtGroupBars' `confIntGraph' `titleOption'  `legendOption' `xAxisLabels' `saveOption' title("`basictitle'") `yzero_option' `options'"'
		
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
	
	restore
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
