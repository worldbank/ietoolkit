

	clear all
	
	
	cap program drop 	updateDiffID
		program define 	updateMatchID
		
		args updo grpvl diff idvar grpvar matched
		
		replace dum`grpvl'_diff`updo' 	= .
		replace dum`grpvl'_ID`updo' 	= .
		
		replace dum`grpvl'_diff`updo'  	= `diff' 	if `grpvar' != `grpvl' & `matched' == 0
		replace dum`grpvl'_ID`updo'  	= `idvar' 	if `grpvar' != `grpvl' & `matched' == 0
		
		replace dum`grpvl'_diff`updo'  	= dum`grpvl'_diff`updo'[_n-1] 	if dum`grpvl'_diff`updo' == . & `matched' == 0
		replace dum`grpvl'_ID`updo'  	= dum`grpvl'_ID`updo'[_n-1] 	if dum`grpvl'_ID`updo'	 == . & `matched' == 0
		
	end

	cap program drop 	updateAllDiffID
		program define 	updateAllDiffID
		
		args diffvar invdiff idvar grpvar matched rand invrand
		
		*****************
		*Update possible matches with higher rank value
		sort `matched' `diffvar' `rand'
		
		updateDiffID up 0 `diffvar' `idvar' `grpvar' `matched' 
		updateDiffID up 1 `diffvar' `idvar' `grpvar' `matched' 
		
		
		*****************
		*Update possible matches with lower rank value
		sort `matched' `invdiff' `invrand'
		
		updateDiffID do 0 `diffvar' `idvar' `grpvar' `matched' 
		updateDiffID do 1 `diffvar' `idvar' `grpvar' `matched' 
		
		
		*****************
		*Create one varaible common for both groups with diff upwards
		replace diffup = abs(`diffvar' - dum1_diffup) if `grpvar' == 1
		replace diffup = abs(`diffvar' - dum0_diffup) if `grpvar' == 0 
		
		*Create one varaible common for both groups with diff downwards
		replace diffdo = abs(`diffvar' - dum1_diffdo) if `grpvar' == 1 
		replace diffdo = abs(`diffvar' - dum0_diffdo) if `grpvar' == 0 
		
		*Create one varaible common for both groups with ID upwards
		replace IDup = dum1_IDup if `grpvar' == 1
		replace IDup = dum0_IDup if `grpvar' == 0 
		
		*Create one varaible common for both groups with ID downwards
		replace IDdo = dum1_IDdo if `grpvar' == 1 
		replace IDdo = dum0_IDdo if `grpvar' == 0 
		
		replace pref = IDdo if `matched' == 0 & diffdo <= diffup
		replace pref = IDup if `matched' == 0 & diffdo >  diffup	
		
	end




	set obs 4000
	
	gen id = _n
	
	gen rand1 = uniform()
	
	gen tmt = (rand1 < .5850)
	
	*replace tmt = . if (rand1 < .05)
	
	drop rand1
	tab tmt
	
	gen p_hat = uniform() * 1000
	*gen p_hat = 10
	
	sort p_hat
	*replace p_hat = . if p_hat < .01
	
	
	gen pref 	= .
	gen matched = 0
	gen diffup 	= .
	gen diffdo 	= .
	gen IDup 	= .
	gen IDdo 	= .
		
	
	gen dum0_diffup = .
	gen dum0_diffdo = .

	gen dum0_IDup = .
	gen dum0_IDdo = .	
	
	gen dum1_diffup = .
	gen dum1_diffdo = .
	
	gen dum1_IDup = .
	gen dum1_IDdo = .	
	
	pause on

	
	sort p_hat
	
	gen invsort = -1 * p_hat
	gen    rand = uniform()
	gen invrand = -1 * rand
	
	preserve
		
		clear 
		
		tempfile match_append
		save	`match_append' , emptyok
	
	restore
	
	
	qui {
	
		noi count if tmt == 1 & matched == 0
		local left2match = `r(N)'
		
		while (`left2match' > 0) {
			
			**For all observations still to be matched, assign the preferred 
			* match among the other unmatched observations
			updateAllDiffID p_hat invsort id tmt matched rand invrand
		
			
			replace matched = 1 if matched == 0 & pref == id[_n-1] & pref[_n-1] == id
			replace matched = 1 if matched == 0 & pref == id[_n+1] & pref[_n+1] == id
			
			noi count if tmt == 1 & matched == 0
			local left2match = `r(N)'

			
			
			
			*Remove matched observations so that the sorting in follwoing iteration are faster
			preserve
			
				keep if matched == 1 
				
				keep id tmt p_hat pref matched diffup diffdo IDup IDdo
				
				append using `match_append'
				
				save		 `match_append' , replace
		
			restore
			

			keep if matched == 0
			
		
		}
	
	}
	
	keep id tmt p_hat pref matched diffup diffdo IDup IDdo
	
	append using `match_append'
