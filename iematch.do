
	clear 

	
	
	*command starts here
	
	cap program drop 	iematch
	    program define	iematch
		
		syntax  , GRPdummy(varname) MATCHcont(varname) [idvar(varname)]
		

		
		qui {
		
		if "`idvar'" == "" {
			
			gen _ID = _n
			
			local idvar _ID
		
		}		
		

		tempvar hi_diff lo_diff pref match newMatch
	

		gen `hi_diff' = .
		gen `lo_diff' = .
		gen _matchDiff = .
		gen `pref' = .
		gen byte `match' = 0
		gen byte `newMatch' = 0
		gen _matchID = .
		

		
		*order `idvar' , after(`pref')
		
		
		
		**match loop
		
		count if `grpdummy' == 1 & `match' == 0
		local left2Match = `r(N)'
		
		pause on
			
			
			
			while (`left2Match' > 0) {
			
				sort `match' `matchcont'
				
				replace `lo_diff' 	= .
				replace `hi_diff' 	= .
				replace `pref'		= . if `match' == 0
				replace `newMatch' 	= 0
				
				replace `lo_diff' = abs(`matchcont' - `matchcont'[_n-1]) if `match' == 0 & `grpdummy' != `grpdummy'[_n-1] 
				replace `hi_diff' = abs(`matchcont' - `matchcont'[_n+1]) if `match' == 0 & `grpdummy' != `grpdummy'[_n+1]
				
				replace `pref' = `idvar'[_n-1] if `match' == 0 & `lo_diff' <  `hi_diff'
				replace `pref' = `idvar'[_n+1] if `match' == 0 & `lo_diff' >= `hi_diff'
				
				replace `newMatch' = 1 if `match' == 0 & `pref' == `idvar'[_n-1] & `pref'[_n-1] == `idvar'
				replace `newMatch' = 1 if `match' == 0 & `pref' == `idvar'[_n+1] & `pref'[_n+1] == `idvar'
				
				replace `match' = 1 							if `newMatch' == 1
				replace _matchDiff = min(`lo_diff', `hi_diff') 	if `newMatch' == 1
				replace _matchID = `idvar' 						if `newMatch' == 1 & `grpdummy' == 1
				replace _matchID = `pref' 						if `newMatch' == 1 & `grpdummy' == 0
				
				*order _match* , last
				
			noi	count if `grpdummy' == 1 & `match' == 0
				local left2Match = `r(N)'
				
				*pause
				
			}
		}
	
	end
	
	

	set seed 1235324
	
	set obs 10000
	
	gen id = _n
	
	gen rand1 = uniform()
	
	gen tmt = (rand1 < .40)
	
	drop rand1
	tab tmt
	
	gen p_hat = uniform()
	
	iematch   , grp(tmt) match(p_hat) idvar(id)
