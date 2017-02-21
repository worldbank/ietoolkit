	
	/*
	
		USe carefully, this command delete a folder and all its content permanently
	
	*/
	cap program drop   deleteFolder
		program define deleteFolder
	
		args folder
		
		noi di "`folder'"
		
		local flist : dir `"`folder'"' files "*"
		local dlist : dir `"`folder'"' dirs "*" 
		local olist : dir `"`folder'"' other "*"
		
		
		foreach file of local flist {
			noi di "`folder'\\`file'"
			if "`c(os)'" == "Windows" erase "`folder'\\`file'"
			if "`c(os)'" != "Windows" rm 	"`folder'\\`file'"
		}
		foreach file of local olist {
			noi di "`folder'\\`file'"
			if "`c(os)'" == "Windows" erase "`folder'\\`file'"
			if "`c(os)'" != "Windows" rm 	"`folder'\\`file'"
		}	
		foreach dir of local dlist {
			
			deleteFolder "`folder'\\`dir'"	
		}	
		
		rmdir "`folder'"

	end 
