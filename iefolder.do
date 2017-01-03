	
	global box 		"C:\Users\wb462869\Box Sync"
	global ief 		"$box\Stata\Stata work\Commands\iefolder"
	global testdir	"$ief\ief_test"
	
	cd "$ief\cdjunk"
	
	ieboilstart, v(11.1)
	`r(version)'
	
	********************************
	
	local maindirname datawork
	
	local maindir "$testdir/`maindirname'"
	
	local mstdir "`maindir'/masterdata"
	local mondir "`maindir'/monitordata"
	
	local listoffolders maindir mstdir mondir
	
	local surveyRounds baseline endline
	
	foreach surveyRound of local surveyRounds {
		
		local rnddir 	"`maindir'/`surveyRound'"
		
		local dtadir 	"`rnddir'/Data"
		local rawdir 	"`dtadir'/Raw Data"
		local intdir 	"`dtadir'/Intermediate Data"
		local findir 	"`dtadir'/Final Data"
		local dodir		"`rnddir'/Dofiles"
		local outdir	"`rnddir'/Output"
		local survdir	"`rnddir'/Survey Documentation"
		
		 
		local listoffolders `listoffolders' rnddir dtadir rawdir intdir findir dodir outdir survdir
	}
	
	********************************
	
	do "$ief\deleteFolder.ado"
	
	noi deleteFolder "$testdir"
	
	
	mkdir "$testdir"
	
	foreach folder of local listoffolders {
		
		di "``folder''"
		
		mkdir "``folder''"
		
	}
	
