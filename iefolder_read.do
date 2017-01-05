	
	ieboilstart, v(11.1)
	`r(version)'
	
	
	global box 		"C:\Users\wb462869\Box Sync"
	global ief 		"$box\Stata\Stata work\Commands\iefolder"
	global testdir	"$ief\ief_test"
	
	do "$ief\functions.do"

	cd "$ief\cdjunk"
	
	local maindirname datawork
	
	local maindir "$testdir/`maindirname'"
	
	local oldfilename "`maindir'/testMasterDofile.do"
   
	tempfile	newtextfile
	tempname oldfile newfile
	
	file open  		`newfile' using "`newtextfile'", text write replace
	file close 		`newfile'	
	
	
	
	local linenum = 0
	file open `oldfile' using `"`oldfilename'"', read
	file read `oldfile' line
	
	
	while r(eof)==0 {
		
		*Do not interpret macros
		local line : subinstr local line "\$"  "\\$"
		local line : subinstr local line "\`"  "\\`"
		
		parseReadLine `"`line'"'
		
		if `r(ief_line)' {
			di  `"`line'"'
			
			return list 
			
			di ""
			di ""
			di "********************************"
		}
		
		
		
		if `r(ief_line)' == 0 {
			
			file open  		`newfile' using "`newtextfile'", text write append
			file write		`newfile' `"`line' new 1"' _n
			file close 		`newfile'	
		
		}
		else if `r(ief_end)' == 1 {
		
			file open  		`newfile' using "`newtextfile'", text write append
			file write		`newfile' `"`line' new 2"' _n
			file close 		`newfile'	
		
		}
		else {
			
			file open  		`newfile' using "`newtextfile'", text write append
			file write		`newfile' `"`line' new 3"' _n
			file close 		`newfile'	
		
		}
		
		
		
		file read `oldfile' line
		
		
	}
	file close `oldfile'
	
	
	copy "`newtextfile'"  "$maindir/testMasterDofile2.do" , replace
	
	doedit "$maindir\testMasterDofile2.do" 
