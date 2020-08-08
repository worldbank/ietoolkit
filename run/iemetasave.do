//
// 	global GitHub	"C:\Users\wb462869\GitHub\ietoolkit"
//
// 	sysuse auto, clear
//
// 	do "${GitHub}/src/ado_files/iemetasave.ado"
//
// 	local linesize `c(linesize)'
//
// 	iemetasave using "${GitHub}/run/output/iemetasave/auto.txt", replace 
//
// 	assert `c(linesize)' == `linesize'
//
// 	cap iemetasave using "${GitHub}/run/output/iemetasave/auto.txt", replace linesize(20) short
// 	assert _rc == 198
//
// 	cap iemetasave using "${GitHub}/run/output/iemetasave/auto.txt", replace linesize(300) short
// 	assert _rc == 198

	
	*********************
	

	global GitHub	"C:\Users\wb462869\GitHub\ietoolkit"

	sysuse auto, clear
	
	replace length = .a if _n == 5
	
	
	label var price "Price, dollars"

	qui do "${GitHub}/src/ado_files/iemetasave.ado"

	local linesize `c(linesize)'

	iemetasave using "${GitHub}/run/output/iemetasave/auto2.csv", replace short

	