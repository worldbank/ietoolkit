cap	program drop	ieimpgraph
	program define 	ieimpgraph
*	preserve
	syntax varlist, [TItle(string)]
	
	mat beta_ = e(b)

	local counter = 0
	local textfile = "Mrijan"
	local date = "$S_DATE"
	
	qui{

		
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
		noi display coeff_`var'

		scalar coeff_se_`var' = _se[`var']
		noi display coeff_se_`var'
		
		count if e(sample) == 1 & `var' == 1 //Count one tmt group at the time
		scalar obs_`var' = r(N)
		noi display obs_`var'

	} 
	
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

	noi sum `e(depvar)' if e(sample) == 1 & `control' == 1
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
			noi display "`star_`var''"
			scalar tmt_mean_`var' = ctl_mean + coeff_`var'
		}
	
	tempname 	newHandle	
	tempfile	newTextFile
	cap file close 	`newHandle'	
	
	
	file open  	`newHandle' using "`newTextFile'", text write append
	file write `newHandle' ///
		"order" 	_tab "xLabeled"	_tab "mean" _tab "coeff" _tab "conf_int_min" _tab "conf_int_max" _tab "obs" _tab "star" _n 	///
		%9.3f (1) _tab "Control"  _tab %9.3f (ctl_mean)      _tab  		 			_tab 		 			  	  _tab 			 				_tab %9.3f (ctl_N) 	   _tab			  	  _n 
	file close `newHandle'
	
	
	tempvar newCounter 
	gen `newCounter' = 2
		foreach var in `varlist' {
			file open  	`newHandle' using "`newTextFile'", text write append
			file write `newHandle' ///
			%9.3f (`newCounter') _tab "`var'" _tab %9.3f (tmt_mean_`var') _tab  %9.3f (coeff_`var')  _tab %9.3f (conf_int_min_`var') _tab %9.3f (conf_int_max_`var') _tab %9.3f (obs_`var')   _tab "`star_`var''"  _n 
			file close `newHandle'	
			replace `newCounter' = `newCounter' + 1
			}
	
		copy "`newTextFile'"  "mainMasterDofile.txt" , replace
		
		insheet using mainMasterDofile.txt, clear
	
		if order == 1 local obsControl = obs
		local obsLabelControl = xlabeled[1]
		
		local starOption `" xlabel(1 " `obsLabelControl'(N=`obsControl')" "'
		*noi di "`starOption'" /
	
	forval x = 2/`graphCount' {
	
			
			list obs if order == `x'
			local obsTreat = obs[`x'] 
			
			local starTreat = star[`x']
			local starLabel = xlabeled[`x']
			
			local starOption `" `starOption' `x' " `starLabel' (N= `obsTreat')  `starTreat'" "'
						
		}
	
	local starOption `" `starOption' , noticks labsize(medsmall) ) "'
	/* noi di "Mrijan rimal"
	noi di `" "`starOption'"  "'
	noi di "Mrijan rimal" */

	local graphname gph_new 
	local colourOption ""
	
	forval colourLoop = 1/`graphCount' {
		
		local colour
		
		noi di 0
		
		local colourNum = mod(`colourLoop', 5)
		
		if `colourNum' == 1 local colour = "215 25 28"
		if `colourNum' == 2 local colour = "253 174 93"
		if `colourNum' == 3 local colour = "255 255 191"
		if `colourNum' == 4 local colour = "171 217 233"
		if `colourNum' == 0 local colour = "43 123 182"
		
		noi di 1
		
		local colourOption `"`colourOption' (bar mean order if order == `colourLoop', color("`colour'") yscale(range(0)) ) "' 
		
		noi di 2
		
		noi di `"`colourOption'"'
		
		
	}
	
	noi di 3
	
	local confIntGraph = "(rcap conf_int_max conf_int_min order, yscale(range(0)) lc(gs)) (scatter mean order,  msym(none)  mlabs(medium) mlabpos(10) mlabcolor(black)), "
	
	local orderOption = "legend(order("
	
	forval y = 1(1)`graphCount'{
		local orderOption  "`orderOption' `y'"
	}
	
	local orderOption "`orderOption' ))"
	
	noi di 4
	
	noi di `" graph twoway `colourOption' `confIntGraph' `orderOption' "'
	
	graph twoway `colourOption' `confIntGraph' `orderOption' `starOption' saving("newfile.gph", replace) title("`title'") 
	
	noi di 5
	
	graph export graphname.png, replace	
}
*restore
end



