 

	capture program drop 	iedropone
			program define 	iedropone , 
	
	qui {
		
		*noi di "command OK!"
		
		syntax [if] ,  [multivar(varname) multical(string)]
	
		*noi di "syntax OK!"
	
		version 11.0
		
		
		di "`if'"
		
		count `if'
		
		if `r(N)' == 1 {
			
			drop `if'
			
			noi di "1 observation dropped"
			
		} 
		else {
		
			noi di "No observation dropped"	
			
		}
		
	}

	end
		
		
