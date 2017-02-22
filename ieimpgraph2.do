cap	program drop	ieimpgraph
	program define 	ieimpgraph
	
	syntax varlist
	
	mat beta_ = e(b)

	local counter = 0
	local textfile = "Mrijan"
	local date = "$S_DATE"

foreach var of local varlist{
		local `counter' = `counter' + 1
		di `counter'
		scalar beta_`var' = _b[`var'] 
		noi display beta_`var'

		scalar coeff_se_`var' = _se[`var']
		display coeff_se_`var'

		scalar obs_`var' = r(N)
		display obs_`var'

		display `counter'
	} 

end

