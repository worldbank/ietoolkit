cap	program drop	ieimpgraph
	program define 	ieimpgraph
	
	syntax varlist
	
	mat beta_ = e(b)

	local counter = 0
	local textfile = "Mrijan"
	local date = "$S_DATE"
qui{

foreach var of local varlist{
		
		//Test that var is dummy (i.e. 0 or 1 or missing)
			
		local counter = `counter' + 1
		di `counter'
		
		scalar beta_`var' = _b[`var'] 
		noi display beta_`var'

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
gen anyTMT = rowmax(`varlist') if e(sample) == 1
gen control = (anyTmt == 0) if !missing(anyTMT)

noi sum `e(depvar)' if e(sample) == 1 & control == 1
scalar ctl_N		= r(N)
scalar ctl_mean	  	= r(mean)
scalar ctl_mean_sd 	= r(sd)	


}
end

