cap	program drop	iegraph
	program define 	iegraph
	preserve
	syntax varlist, [noconfbars TItle(string) save(string) confbarsnone(varlist) GREYscale yzero *]
	mat beta_ = e(b)

	local counter = 0
	//local textfile = "Mrijan"
	qui{
		if "`confbars'" 			!= "" {
		local CONFINT_BAR 	= 0 
		}
		else if "`confbars'" 			== "" {
		local CONFINT_BAR 	= 1 
		}
		
		local varTest : list confbarsnone in varlist
		
		if `varTest' == 0 {
					noi display as error "{phang} Variables defined in confbarsnone cannot be found in the graph variable list. {p_end}"
					noi display ""
					error 111
					 }
		
		foreach var of local varlist{
			cap assert inlist(`var',0,1) | missing(`var')
				if _rc {
					noi display as error "{phang} The variable `var' is not a dummy. Treatment variable needs to be a dummy(0 or 1) variable. {p_end}"
					noi display ""
					error 149
					}
				else {
					}
						
		local counter = `counter' + 1
		di `counter'
		
		scalar coeff_`var' = _b[`var'] 
		//noi display coeff_`var'

		scalar coeff_se_`var' = _se[`var']
		//noi display coeff_se_`var'
		
		count if e(sample) == 1 & `var' == 1 //Count one tmt group at the time
		scalar obs_`var' = r(N)
		//noi display obs_`var'

			} 
	if "`save'" != "" {
	
        *Find index for where the file type suffix start
        local dot_index     = strpos("`save'",".") + 1
		 
        *Extract the file index

        local file_suffix   = substr("`save'", `dot_index', .)
		noi di "`file_suffix'"
	        

        local nonGPH_formats png tiff gph ps eps pdf wmf emf

        

        *If no file format suffix is specified, use the default .xlsx

        if `dot_index' == 1 | "`file_suffix'" == "gph" {
                   local save_export = 0
				}

        *If a file format suffix is specified make sure that it is one of the two allowed.

        else if `:list file_suffix in nonGPH_formats' != 0  {
            local save_export = 1
			
			if ("`file_suffix'" == "wmf" | "`file_suffix'" == "emf") & "`c(os)'" != "Windows" {
				di as error ""
                error
                   } 
			}

        else {
  
            di as error "You are not using a allowed file format in save(`save'). Only the following formats are allowed: gph `nonGPH_formats'"
            error
        }
    }
	
	//noi di `"iegraph `varlist', `noconfbars' title(`title') save(`save') `confbarsnone' `yzero' `anything'"'	

	local count: word count `varlist' 
	local graphCount = `count' + 1
	//tokenize "`varlist'"
	//noi di `count'

	//Make all vars tempvars (maybe do later)
	//Make sure that missing is properly handled
	tempvar anyTMT
	egen `anyTMT' = rowmax(`varlist') if e(sample) == 1
	tempvar control
	gen `control' = (`anyTMT' == 0) if !missing(`anyTMT')

	sum `e(depvar)' if e(sample) == 1 & `control' == 1
	scalar ctl_N		= r(N)
	scalar ctl_mean	  	= r(mean)
	scalar ctl_mean_sd 	= r(sd)	

		foreach var of local varlist {
			scalar  conf_int_min_`var'   =	coeff_`var'-(1.96*coeff_se_`var') + ctl_mean
			scalar  conf_int_max_`var'   =	coeff_`var'+(1.96*coeff_se_`var') + ctl_mean
			
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
			*noi display "`star_`var''"
			scalar tmt_mean_`var' = ctl_mean + coeff_`var'
		}
	
	tempname 	newHandle	
	tempfile	newTextFile
	cap file close 	`newHandle'	
	file open  	`newHandle' using "`newTextFile'", text write append
	
	*Write headers and control value
	file write `newHandle' ///
		"order" 	_tab "xLabeled"	_tab "mean" _tab "coeff" _tab "conf_int_min" _tab "conf_int_max" _tab "obs" _tab "star" _n 	///
		%9.3f (1) _tab "Control"  _tab %9.3f (ctl_mean)      _tab  		 			_tab 		 			  	  _tab 			 				_tab %9.3f (ctl_N) 	   _tab			  	  _n 

	tempvar newCounter 
	gen `newCounter' = 2  //First tmt group starts at 2 (1 is control)
	
	foreach var in `varlist' {
	     if `: list var in confbarsnone' { 
		file write `newHandle' ///
			%9.3f (`newCounter') _tab "`var'" _tab %9.3f (tmt_mean_`var') _tab  %9.3f (coeff_`var')  _tab %9.3f  _tab _tab %9.3f (obs_`var')   _tab "`star_`var''"  _n 
		
		replace `newCounter' = `newCounter' + 1	
			}
		else {	
		file write `newHandle' ///
			%9.3f (`newCounter') _tab "`var'" _tab %9.3f (tmt_mean_`var') _tab  %9.3f (coeff_`var')  _tab %9.3f (conf_int_min_`var') _tab %9.3f (conf_int_max_`var') _tab %9.3f (obs_`var')   _tab "`star_`var''"  _n 
		
		replace `newCounter' = `newCounter' + 1
		}
	}
	
	file close `newHandle'	
	
	copy "`newTextFile'"  "mainMasterDofile.txt" , replace
	
	/*************************************
	
		Create the graph
	
	*************************************/
	
	insheet using mainMasterDofile.txt, clear
		
	local tmtGroupBars 	""
	local xAxisLabels 	`"xlabel( "'
	local legendLabels	`"lab(1 "`obsLabelControl'")"'
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
		
		local tmtGroupBars `"`tmtGroupBars' (bar mean order if order == `tmtGroupCount', color("`r(color)'") lcolor(black) ) "' 
		
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
		//local confIntGraph == `"(scatter mean order,  msym(none)  mlabs(medium) mlabpos(10) mlabcolor(black)), xtitle("") ytitle("`e(depvar)'") "'
		local confIntGraph = ""
	} 
		else if `CONFINT_BAR' == 1 {
		local confIntGraph = `"(rcap conf_int_max conf_int_min order, lc(gs)) (scatter mean order,  msym(none)  mlabs(medium) mlabpos(10) mlabcolor(black))"'
	}
	
	local titleOption `" , xtitle("") ytitle("`e(depvar)'") "'

	if "`save'" != "" {
		local saveOption saving("`save'", replace)
	}
	
	if "`yzero'" != "" {
	
		gen maxvalue = max(mean , conf_int_max)
		
		sum maxvalue 
		local max = `r(max)'
		
		local logmax = log10(`max')
		
		local logmax = round(`logmax') - 1
		
		local tenpower = 10 ^ (`logmax')
		
		local up = `tenpower' * ceil(`max' / `tenpower')

		local quarter = (`up') / 4
		
		noi di "up: `up'"
		noi di "quarter: `quarter'"
			
		local yzero_option ylabel(0(`quarter')`up')
	}
	
	
		//noi di `" graph twoway `tmtGroupBars' `confIntGraph' `titleOption' `options' `legendOption' `xAxisLabels' `saveOption' title("`title'") `yzero_option'  "'
	if `save_export' == 0 {
		graph twoway `tmtGroupBars' `confIntGraph' `titleOption'  `legendOption' `xAxisLabels' `saveOption' title("`title'") `yzero_option' `options'
		noi di `" graph twoway `tmtGroupBars' `confIntGraph' `titleOption' `options' `legendOption' `xAxisLabels' `saveOption' title("`title'") `yzero_option'  "'

		}
	else if `save_export' == 1 {
		graph twoway `tmtGroupBars' `confIntGraph' `titleOption'  `legendOption' `xAxisLabels' title("`title'") `yzero_option' `options'
		graph export "`save'", replace
		}	
		
	restore
}

end

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
