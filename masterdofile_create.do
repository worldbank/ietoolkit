	
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
	
	masterDofilePart0 `newtextfile' `newfile'	
	masterDofilePart1 `newtextfile' `newfile'	"`maindir'"
	
	copy "`newtextfile'"  "$maindir/testMasterDofileGen3.do" , replace
	
	doedit "$maindir\testMasterDofileGen3.do" 
