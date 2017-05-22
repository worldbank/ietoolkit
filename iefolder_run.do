
	*Set standardized settings
	ieboilstart, v(11.1)
	`r(version)'
	
	*global to the exercise folder
	global ief 	"C:\Users\WB462869\Documents\GitHub\ietoolkit"

	
	*Load the command
	qui do 		"$ief\iefolder.do"
	
	*Global to the mock project folder you created
	global projectfolder	""	
	
	
	*(Ask me before using this two lines of code)
	*Clean up the folder fomr last run
	*do "$ief\deletefolder.do"
	*cap deleteFolder "$projectfolder\DataWork"
	
******************************************************************************


