
	global GitHub	"C:\Users\wb501238\Documents\GitHub\ietoolkit"
	
	sysuse auto, clear
	
	do "${GitHub}/src/ado_files/iemetasave.ado"
	
	
	iemetasave using "${GitHub}/run/output/iemetasave/auto.txt", replace
