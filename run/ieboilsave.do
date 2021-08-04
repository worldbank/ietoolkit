
	* Add the path to your local clone of the [ietoolkit] repo
	global 	ietoolkit   "C:\Users\Inspiron\Desktop\GitHub/ietoolkit" 
	global 	reports     "C:\Users\Inspiron\Desktop\DIME\practice\iebolsave_practice"
    qui do 		            "${ietoolkit}/src/ado_files/ieboilsave.ado" 

	global stata_ver =  "16"     // Stata version 
	
	
/*******************************************************************************
	Options: No error
*******************************************************************************/
    
	/*********************
	      IDvars       
	*********************/
	sysuse auto, clear
	* single id 
	ieboilsave, idvars(make) dtaversion(${stata_ver})
	
	* idvars list 
    gen id = make 
	ieboilsave, idvars(make id) dtaversion(${stata_ver})
	
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
		replace id = 3 in 4
		replace id = 8 in 11
		replace id = 8 in 21
	
		
	cap 
	ieboilsave, idvars(id) dtaversion(${stata_ver})
	assert _rc== 459	
	
	
	
	/*********************
	      varreport    
	*********************/	
	
	sysuse auto, clear
	cap erase "${reports}/report1.csv"
	ieboilsave, idvars(make) dtaversion(${stata_ver}) /// 
	varreport("${reports}\report1.csv")                                         
	
	/*********************
	      reportreplace    
	*********************/		
	sysuse auto, clear
	ieboilsave, idvars(make) dtaversion(${stata_ver}) /// 
	varreport("${reports}/report1.csv") reportreplace
	
	
	/*********************
	      replace    
	*********************/		                                                // I dont know how this works 
	sysuse auto, clear

	cap 
	ieboilsave, idvars(make) dtaversion(${stata_ver}) ///
	varreport("${reports}/report1.csv")  replace  
	reportreplace
	assert _rc == 601
	
	/*********************
	      VNOMissing
	*********************/			
	sysuse auto, clear
	cap 
	ieboilsave, idvars(make) dtaversion(${stata_ver}) ///
	vnomissing(headroom trunk rep78)
	assert _rc == 416  //  


	/*********************
	   VNOSTANDMissing                                                          // Not working  
	*********************/		
	sysuse auto, clear
	replace trunk = .d in 12
	replace trunk = .n in 13
	replace trunk = .a in 14
	replace trunk = . in 11
	
	ieboilsave, idvars(make) dtaversion(${stata_ver}) ///
	vnostandmissing(headroom trunk foreign)  // Error: Just validate . 
		
	/*********************
	   userinfo                                                          
	*********************/			
	
	sysuse auto, clear
	ieboilsave, idvars(make) dtaversion(${stata_ver}) userinfo
	
/*******************************************************************************
    * Incorrect uses 
*******************************************************************************/	
	sysuse auto, clear
	
	*****************
	* idvars and dtaversion required options
	cap ieboilsave
	assert _rc == 198
	
	cap ieboilsave, dtaversion(${stata_ver})
	assert _rc == 198
	
	cap ieboilsave, idvars(make)
	assert _rc == 198
	
	* Dta version validation
	cap ieboilsave, idvars(make) dtaversion(18)
	assert _rc == 198
	
	* reportreplace combination without varreport
	cap ieboilsave, idvars(make) dtaversion(${stata_ver}) ///
	reportreplace
	assert _rc == 198
	
	* wrong file extension
	cap ieboilsave, idvars(make) dtaversion(${stata_ver}) ///
	varreport("${reports}/report1") 
	assert _rc == 601
	
	* folder don´t exist
	cap ieboilsave, idvars(make) dtaversion(${stata_ver}) ///
	varreport("report_folder/report1.csv") 
	assert _rc == 601
	
	
		
	
********************************************************************************
	* returned values *
********************************************************************************		
	sysuse auto, clear
	ieboilsave, idvars(make) dtaversion(${stata_ver}) userinfo
	
	foreach value in username computerid versions datasig N numvars {
		display "`value':  " r(`value')
	}
	

	
********************************************************************************
	* Testing char values *
********************************************************************************		

	/*****************************************
	Validate if char values are as expected                                                    
	*****************************************/
	sysuse auto, clear
	ieboilsave, idvars(make) dtaversion(${stata_ver}) userinfo
		
	*1. Store char values
		foreach value in idvar N username timesave{
			global `value'1       : char _dta[iesave_`value']
		}		
		
	*2. Save dataset
		save "${reports}\data1.dta", replace
	
	*3. Open the dataset just saved
		use "${reports}\data1.dta", clear
		
	*4. Store char values
		foreach value in idvar N username timesave{
			global `value'2       : char _dta[iesave_`value']
		}
	
	*5. Validate if char values are as expected
		foreach value in idvar N username timesave{
			assert "$`value'1" == "$`value'2"
		}
		char list 
	clear
	
	/***********************
	 validate last time save                                                     
	************************/	
	use "${reports}\data1.dta", clear
	ieboilsave, idvars(make) dtaversion(${stata_ver}) userinfo
	
	*1. Save dataset 
	save "${reports}\data1.dta", replace
	
	*2. Open the dataset just saved
		use "${reports}\data1.dta", clear	
	    global timesave3 : char  _dta[iesave_timesave]
	
    *3. Validate last time save 
		assert "$timesave3" != "$timesave1"
		

	/**************************************************************
	Validate if char values are as expected after make data changes                                                    
	***************************************************************/	
	drop if trunk > 22
	drop displacement
	ieboilsave, idvars(make) dtaversion(${stata_ver}) userinfo
	
	*1. Save dataset
		save 	"${reports}\data1.dta" , replace
		clear 
	
	*2. Open the dataset just saved
		use "${reports}\data1.dta"
	
		foreach value in idvar N username timesave{
			global `value'4       : char _dta[iesave_`value']
		}		
		
		
	*3. Validate if char values are as expected
		foreach value in id username{
			assert "$`value'1" == "$`value'4"
		} 	

		foreach value in N timesave{
			assert "$`value'2" != "$`value'4"
			di "$`value'2 != " "$`value'4"
		} 		

		
***************************** End of do-file ***********************************
