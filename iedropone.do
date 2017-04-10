 

	capture program drop 	iedropone
			program define 	iedropone , 
	
	qui {
		
		*noi di "command OK!"
		
		syntax [if] ,  [Numobs(numlist int min=1 max=1 >0) mvar(varname) mval(string) zerook]
	
		*noi di "syntax OK!"
		
		*noi di "`if'"
		
		version 11.0
		

		/***********************************
		
			Set constants
		
		***********************************/		
		
		*Set a constant for the multi option being used
												local MULTI_USED 0
		if ("`mvar'" != "" & "`mval'" != "") 	local MULTI_USED 1
		
		
		*Set a constant for the zerook option being used
												local ZEROOK_USED 0
		if ("`zerook'" != "") 					local ZEROOK_USED 1
		
		*Set a constant for if an IF-condition used
												local IF_USED 0
		if ("`if'" != "") 						local IF_USED 1		
		
		
		/***********************************
		
			Test input
		
		***********************************/
		
		*Test that mvar() and mval() was used in combination
		if ("`mvar'" != "" & "`mval'" == "") {
			
			di as error "{pstd}The options mval() is required when using the option mvar()"
			error 197
		}
		if ("`mvar'" == "" & "`mval'" != "") {
		
			di as error "{pstd}The options mvar() is required when using the option mval()"
			error 197
		}
		
		*Test that either an if condition was specified or of the multi values option was used 
		if `IF_USED' == 0 & `MULTI_USED' == 0 {
			
			di as error "{pstd}An {it:if} condition is required unless mvar() and mval() is used."
			error 197
		}
		

		/***********************************
		
			Set locals
		
		***********************************/		
		
		*If number of drops is not set, tehn use the default which is 1
		if "`numobs'" == "" {
	
			local numobs = 1
		}
		
		
		/***********************************
		
			Test the number of obs matching
		
		***********************************/		
		
		*noi di "Test the number of obs matching"
		
		if `MULTI_USED' == 0 { 
		
			noi di "iedropone_test_match `if' , numobs(`numobs') zero_used(`ZEROOK_USED')"
			
			iedropone_test_match `if' , numobs(`numobs') zero_used(`ZEROOK_USED') multi_used(`MULTI_USED')
			local num_obs_dropped `r(numtodrop)'

		}
		else {
			
			local num_obs_dropped = 0
			
			foreach mvalue in `mval' {
				
				if `IF_USED' == 1	noi di "iedropone_test_match `if' & `mvar' == `mvalue' , numobs(`numobs') zero_used(`ZEROOK_USED')"
				if `IF_USED' == 0	noi di "iedropone_test_match  if 	`mvar' == `mvalue' , numobs(`numobs') zero_used(`ZEROOK_USED')"
				
				if `IF_USED' == 1 	iedropone_test_match `if' & `mvar' == `mvalue' , numobs(`numobs') zero_used(`ZEROOK_USED') multi_used(`MULTI_USED')
				if `IF_USED' == 0	iedropone_test_match  if 	`mvar' == `mvalue' , numobs(`numobs') zero_used(`ZEROOK_USED') multi_used(`MULTI_USED')
								
				local num_obs_dropped = `num_obs_dropped' + `r(numtodrop)'
			}
		}
		
		/***********************************
		
			Drop observation(s)
		
		***********************************/	
		
		*noi di "Drop observation(s)"
		
		if `MULTI_USED' == 0 { 
		
			drop `if'
		}
		else {
			foreach mvalue in `mval' {
			
				if `IF_USED' == 1 	drop `if' & `mvar' == `mvalue'
				if `IF_USED' == 0	drop  if 	`mvar' == `mvalue' 
			}
		}
		
		if `num_obs_dropped' == 1 {
			
			noi di "`num_obs_dropped' observation was dropped"
		}
		else {
			noi di "`num_obs_dropped' observations were dropped"
		}
	}

	end
	
	
	
	capture program drop 	iedropone_test_match
			program define 	iedropone_test_match , rclass
		
		
		syntax [if] , numobs(int) zero_used(int) multi_used(int)
		
		
		
		*Count how many obs fits this 
		count `if'
		
		local count_match `r(N)' 
		
		if `count_match' == 0 & `zero_used' == 0 {
				
			noi di as error `"{pstd}No observation matches the drop condition " `if'". Consider using option zerook to surpress this error. No observations dropped."'
			error 2000
		}
		else if `count_match' == 0 & `zero_used' == 1 {
			
			*No observation dropped but that is allowed byt zero_used
			return scalar numtodrop	= `count_match'
			
		}
		
		else if `count_match' < `numobs' {
			
			noi di as error  `"{pstd}There are less than exactly `numobs' observations that match the drop condition " `if'". No observations dropped."'
			error 910
				
		} 
		else if `count_match' > `numobs' {
			
			if `numobs' == 1  noi di as error  `"{pstd}There are more than exactly `numobs' observation that match the drop condition " `if'". No observations dropped."'
			if `numobs' >  1  noi di as error  `"{pstd}There are more than exactly `numobs' observations that match the drop condition " `if'". No observations dropped."'
			error 912
			
		}
		else if `count_match' == `numobs' {
			
			return scalar numtodrop	= `count_match'
			
		}
		else {
		
			noi di as error "{pstd}The command is never supposed to reach this point, please notify the author iof the command on kbjarkefur@worldbank.org"
			error 197
		}
	
	
	end 
	
	
		
		
