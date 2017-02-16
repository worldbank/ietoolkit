	ieboilstart, v(11.1)
	`r(version)'
	
	
	global box 			"C:\Users\wb462869\Box Sync"
	*global box			"C:\Users\Kristoffer\Box Sync"
	
	global ief 			"$box\Stata\Stata work\Commands\ietoolkit"
	global testProject	"$ief\test\testOutput\ProjectTest"
	
	do "$ief\functions.do"
	do "$ief\iefolder.do"
	
	cd "$ief\test\cdjunk"
	
	*use cd to test if folder can be created

	********************************
	

	local surveyRounds baseline endline kristoffer kewinowens
	
	
	
	********************************
	
	cap noi deleteFolder "$testProject"
	
	mkdir "$testProject"

	iefolder new project , projectfolder("$testProject")
	
	
	*iefolder new round baseline , projectfolder("$testProject") abb("BL")
