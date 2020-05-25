
	global GitHub	"C:\Users\wb501238\Documents\GitHub\ietoolkit"
	
	sysuse auto, clear
	
	do "${GitHub}/src/ado_files/iemetasave.ado"
	
	local linesize `c(linesize)'
	
	iemetasave using "${GitHub}/run/output/iemetasave/auto.txt", replace
	
	assert `c(linesize)' == `linesize'
	
	cap iemetasave using "${GitHub}/run/output/iemetasave/auto.txt", replace linesize(20)
	assert _rc == 198
	
	cap iemetasave using "${GitHub}/run/output/iemetasave/auto.txt", replace linesize(300)
	assert _rc == 198
