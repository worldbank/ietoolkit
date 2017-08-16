
cap program drop   iegitaddtxt
	program define iegitaddtxt
	
	qui {
	
		args folder
		
		*List files, directories and other files
		local flist : dir `"`folder'"' files "*"
		local dlist : dir `"`folder'"' dirs "*" 
		local olist : dir `"`folder'"' other "*"
	
		*Test if all of those lists are empty.
		if `"`flist'`dlist'`olist'"' == "" {
			
			** If all those lists are empty then we are in an 
			*  empty folder and should write gitKeep.txt
			writeGitKeep `"`folder'"'
			
		}
		
		*Use the command on any subfolder to this command
		foreach dir of local dlist {
			
			*Recursive call on subfolder
			addGitKeep `"`folder'\\`dir'"'	
		}	
		
	}
	
end 
	
cap program drop   writeGitKeep
	program define writeGitKeep
	
		args folder
		
		*Create file
		tempname 	newHandle
		cap file close 	`newHandle'	
			file open  	`newHandle' using "`folder'\gitKeep.txt", text write replace
		
		*Add some text to the file
		file write  `newHandle' ///
			_col(4)"*******************************************************************************" _n ///
			_col(4)"*******************************************************************************" _n _n ///
			_col(8) "This file is just a placeholder file so the GitHub syncs empty folders" _n _n ///
			_col(8) "This file is meant to be deleted once this folder has real content" _n _n ///
			_col(4)"*******************************************************************************" _n ///
			_col(4)"*******************************************************************************" _n ///
			_n 
		
		*Closing the file
		file close 		`newHandle'
	
end 

