
	* Add the path to your local clone of the [ietoolkit] repo
	global 	ietoolkit   "..GitHub/ietoolkit" 
	global 	reports     "...\ieboilsave_practice"
	qui do 		        "${ietoolkit}/src/ado_files/ieboilsave.ado" 

	global stata_ver = "16"     // Stata version 
/*******************************************************************************
	No error
*******************************************************************************/

	* IDvars dtaversion                                   
	sysuse auto, clear
	ieboilsave, idvars(make) dtaversion(${stata_ver})

	* varreport
	sysuse auto, clear
	local stata_ver = 16
	cap erase "${reports}/report1.csv"
	ieboilsave, idvars(make) dtaversion(${stata_ver}) varreport("${reports}/report1.csv")

	* reportreplace
	sysuse auto, clear
	ieboilsave, idvars(make) dtaversion(${stata_ver}) varreport("${reports}/report1.csv") reportreplace
		
	
	* replace                                                                   // I dont know how to test it 
	sysuse auto, clear
	cap ieboilsave, idvars(make) dtaversion(${stata_ver}) varreport("${reports}/report1.csv")  replace
	assert _rc == 601
	
	
	* VNOMissing
	sysuse auto, clear
	cap ieboilsave, idvars(make) dtaversion(${stata_ver}) vnomissing(headroom trunk rep78)
	assert _rc == 416
	
	
	* VNOSTANDMissing                                                           // I dont know how to test this :C // I think it is not working 
	
	sysuse auto, clear
	replace trunk = .d in 12
	replace trunk = .n in 13
	replace trunk = .a in 14
	
	ieboilsave, idvars(make) dtaversion(${stata_ver}) vnostandmissing(headroom trunk foreign)
	
	
	
	* userinfo
	sysuse auto, clear
	ieboilsave, idvars(make) dtaversion(${stata_ver}) userinfo
	
/*******************************************************************************
    * Incorrect uses : error messages expected *
*******************************************************************************/	
	sysuse auto, clear
	
	*****************
	* idvars and dtaversion required                                  
	cap ieboilsave, dtaversion(${stata_ver})
	assert _rc == 198
	
	cap ieboilsave, idvars(make)
	assert _rc == 198
	
	* Dta version 
	cap ieboilsave, idvars(make) dtaversion(18)
	assert _rc == 198
	
	*****************
	* reportreplace combination without varreport()
	cap ieboilsave, idvars(make) dtaversion(${stata_ver}) reportreplace
	assert _rc == 198
	
	* wrong file extension
	cap ieboilsave, idvars(make) dtaversion(${stata_ver}) varreport("${reports}/report1") 
	assert _rc == 601
	
	* folder don´t exist
	cap ieboilsave, idvars(make) dtaversion(${stata_ver}) varreport("report_folder/report1.csv") 
	assert _rc == 601
	
	
	*****************
	* Missing values in the idvars
		sysuse auto, clear
		gen id = .
		
		forval i = 1/73 { 
			qui replace id = `i' in `i'
		}
	
	cap ieboilsave, idvars(id) dtaversion(${stata_ver}) 
	assert _rc== 459
	
	* Duplicates in the idvars
		sysuse auto, clear
		gen id = _n
		replace id = 2 in 4
	cap ieboilsave, idvars(id) dtaversion(${stata_ver})
		
	
********************************************************************************
	* returned values *
********************************************************************************		
	sysuse auto, clear
	ieboilsave, idvars(make) dtaversion(${stata_ver})
	
	foreach value in username computerid versions datasig N numvars {
		display "`value':  " r(`value')
	}
	
	
	
***************************** End of do-file ***********************************
