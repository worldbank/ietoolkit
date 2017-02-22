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
	
	local count: word count `varlist'  
	tokenize "`varlist'"
	noi di `count'

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
		"Variable" 	_tab "Tmt-Status"	_tab "mean" _tab "coeff" _tab "conf_int_min" _tab "conf_int_max" _tab "obs" _tab "star" _n 	
	file close `newHandle'
	copy "`newTextFile'"  "mainMasterDofile.txt" , replace
}
end

