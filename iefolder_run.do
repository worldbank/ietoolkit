	ieboilstart, v(11.1)
	`r(version)'
	
	
	global box 			"C:\Users\wb462869\Box Sync"
	*global box			"C:\Users\Kristoffer\Box Sync"
	
	global ief 			"$box\Stata\Stata work\Commands\ietoolkit"
	global testProject	"$ief\test\testOutput\Project ABC Uganda"
	
	do "$ief\functions.do"
	do "$ief\iefolder.do"
	do "$ief\deletefolder.do"
	
	cd "$ief\test\cdjunk"
	
	*use cd to test if folder can be created

	********************************
	

	*local surveyRounds baseline endline kristoffer kewinowens
	
	
	
	********************************
	
	cap noi deleteFolder "$testProject\DataWork"
	
	*di `"   iefolder new project 		, projectfolder("$testProject")"'
	iefolder new project 		, projectfolder("$testProject")
	
	*di `"   iefolder new round baseline , projectfolder("$testProject") abb("BL")"'
	iefolder new round  , projectfolder("$testProject") abb("BL")
	
	*di `"   iefolder new round endline 	, projectfolder("$testProject") abb("EL")"'
	iefolder new round endline 	, projectfolder("$testProject") abb("BL")
	
	di `"   iefolder new round name 	, projectfolder("$testProject") abb("MR")"'
	iefolder new round  	, projectfolder("$testProject") abb("MR")
	
	*doedit "$projectfolder\testMasterDofile.do" 
	*doedit "$projectfolder\testMasterDofile2.do" 
