	
	ieboilstart, v(11.1)
	`r(version)'
	
	
	global box 		"C:\Users\wb462869\Box Sync"
	global ief 		"$box\Stata\Stata work\Commands\iefolder"
	global testdir	"$ief\ief_test"
	
	do "$ief\functions.do"

	cd "$ief\cdjunk"
	
	*use cd to test if folder can be created

	********************************
	
	local maindirname datawork
	
	global projectfolder "$testdir/`maindirname'"
	
	
	local surveyRounds baseline endline florence
	
	
	
	********************************
	
	cap noi deleteFolder "$testdir"
	
	
	
	mkdir "$testdir"
	mkdir "$projectfolder"
	
	
	********************************
	

	*Writing titles to textfile

	*Create a temporary textfile
	tempname 	newHandle	oldHandle
	tempfile	newTextFile
	
	*Write the title rows defined above	
	cap file close 	`newHandle'
	file open  		`newHandle' using "`newTextFile'", text write replace
	file write  	`newHandle' "*Intro to text" _n 			
	file close 		`newHandle'
	
	masterDofilePart0 `newTextFile' `newHandle'	
	
	writeDevisor `newTextFile' `newHandle' 0 End_Standardize
	
	masterDofilePart1 `newTextFile' `newHandle'	"$projectfolder"
	
	writeDevisor `newTextFile' `newHandle' 1 Globals 1 MastMon
	
	createFolderWriteGlobal "Master Data"  "projectfolder"  mastData `newTextFile' `newHandle'
	createFolderWriteGlobal "Monitor Data" "projectfolder"  moniData `newTextFile' `newHandle'
	
	local roundCount 1

	foreach rndName of local surveyRounds {
		
		local rndAbb 	`rndName'
		
		if "`rndAbb'" == "baseline" local rndAbb BL
		if "`rndAbb'" == "endline"  local rndAbb EL
		
		local ++roundCount
		
		writeDevisor `newTextFile' `newHandle' 1 Globals `roundCount' `rndName' `rndAbb' 
		
		newRndFolderAndGlobals `rndName' `rndAbb' projectfolder `newTextFile' `newHandle'
		
		
	}
	
	writeDevisor `newTextFile' `newHandle' 1 End_Globals
	
	cap file close 	`newHandle'
	file open  		`newHandle' using "`newTextFile'", text write append
	file write  	`newHandle' "count" _n 			
	file close 		`newHandle'
	
	copy "`newTextFile'"  "$maindir/testMasterDofile.do"

	doedit "$maindir\testMasterDofile.do" 
	
