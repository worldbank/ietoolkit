
cap program drop   iegitaddtxt
	program define iegitaddtxt
	
	qui {
	
		syntax nothing, folder(string)
		
		*Test that folder exist
		mata : st_numscalar("r(dirExist)", direxists("`folder'"))
		
		if `r(dirExist)' == 0 {
		
			noi di as error `"{phang}The "`folder'" folder does not exist. You must enter the full path. For example, on most Windows computers it starts with {it:C:} and on most Mac computers with {it:/user/}. Important: Specify the whole file path to the repository folder, not just {it:C:} or {it:/user/} as that would creaet the .txt file in every empty folder on your computer.{p_end}"' 
			error 693
			exit
		}
		
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
		
		*Use the command on each subfolder to this folder (if any)
		foreach dir of local dlist {
			
			*Recursive call on each subfolder
			addGitKeep `"`folder'\\`dir'"'	
		}	
	}
	
end 
	
*Write a short txt file iegitaddtxt have found an empty folder	
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

