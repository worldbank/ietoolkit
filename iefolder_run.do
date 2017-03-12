
	*Set standardized settings
	ieboilstart, v(11.1)
	`r(version)'
	
	*Folder globals
	global box 			"C:\Users\wb462869\Box Sync"
	global ief 			"$box\Stata\Stata work\Commands\ietoolkit"
	global ief 			"C:\Users\Kristoffer\Documents\GitHub\ietoolkit"
	
	*Load the command
	do "$ief\functions.do"
	do "$ief\iefolder.do"
	*Set cd folder to catch and cd leakage
	cd "$ief\test\cdjunk"
	
	*Global to the project fodler in box
	global projectABC	"$ief\test\testOutput\Project ABC Uganda"	
	
	*Clean up the folder fomr last run
	do "$ief\deletefolder.do"
	cap deleteFolder "$projectABC\DataWork"
	
******************************************************************************
	
	*Creat a new project
	iefolder new project , projectfolder("$projectABC")
	
	*Create a new folder called baseline
	iefolder new round baseline  , projectfolder("$projectABC")
	
	*Create a new folder for endline with abbreviation EL
	iefolder new round endline 	, projectfolder("$projectABC") abb("EL")

	*Show example of test for imput
	*iefolder new round baseline , projectfolder("$projectABC") 
	
	*Show that it is scalabe
	*iefolder new round midline_studnets , projectfolder("$projectABC") 	abb("ML_stud")
	*iefolder new round midline_teachers , projectfolder("$projectABC") 
	*iefolder new round midline_schools , projectfolder("$projectABC") 
	
