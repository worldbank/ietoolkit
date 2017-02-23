cap	program drop	ieimpgraph
	program define 	ieimpgraph
	
	syntax varlist
	
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
	
	//local count: word count `varlist'  
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
			
			noi test `var' 
			local star_`var'

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
	
	local graphname	gph_new
		graph twoway (bar mean order if order == 1, color("215 25 28")	 ) ///
			(bar mean order if order == 2 , color("253 174 97") 		) ///
			(bar mean order if order == 3 , color("255 255 191" ) 		 ) ///
			(rcap conf_int_max conf_int_min order, lc(gs) 						) ///
			(scatter  mean order, msym(none) mlab() mlabs(medium) mlabpos(10) mlabcolor(black))	, ///
			legend(order(1 2 3 4) lab(1 ) lab(2 xLabeled) lab(3 "Shared Demo Treatment")) ///
			 plotregion(margin(b+3 t+3)) ///
			xlabel(	1 `" (N = `obs_ctrl') "' ///
					2 `" "(N = `obs_reg')" " `star_reg' " "' ///
					3 `" "(N = `obs_sdp')" " `star_sdp' " "' , noticks labsize(medsmall)) ///
			graphregion( lcolor("182 222 255") fcolor("182 222 255")) ///
			plotregion(fcolor("247 247 247") ) ///
		   	xtitle("")   ///
			title("`title'") saving(`graphname'.gph, replace)
			graph export `graphname'.png, replace 
			
}
end



