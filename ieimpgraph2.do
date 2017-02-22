cap	program drop	ieimpgraph
	program define 	ieimpgraph
	
	syntax varlist
	
	mat beta_ = e(b)

	local counter = 0
	local textfile = "Mrijan"
	local date = "$S_DATE"
qui{

foreach var of local varlist{
		local counter = `counter' + 1
		di `counter'
		
		scalar beta_`var' = _b[`var'] 
		noi display beta_`var'

		scalar coeff_se_`var' = _se[`var']
		noi display coeff_se_`var'

		scalar obs_`var' = r(N)
		display obs_`var'

	} 
global count: word count `varlist'  
tokenize "`varlist'"
noi di $count
noi sum `e(depvar)' if e(sample) == 1
scalar ctl_N		= r(N)
scalar ctl_mean	  	= r(mean)
scalar ctl_mean_sd 	= r(sd)	


}
end

