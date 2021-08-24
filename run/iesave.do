
	/*******************************************************************************
	  Set up
	*******************************************************************************/

	* Load the version in this clone into memory. If you need to use the version
	* currently installed in you instance of Stata, then simply re-start Stata.
	* Set up the ietoolkit_clone global root path in ietoolkit\run\run_master.do
	qui do "${ietoolkit_clone}/src/ado_files/iesave.ado"

	* Make sure the test folder is created
	local test_folder "${runoutput}/iesave"
	cap mkdir "`test_folder'"

	global stata_ver =  "16"     // Stata version


/*******************************************************************************
	Options: No error
*******************************************************************************/

	/*********************
	      IDvars
	*********************/

	* single id
	sysuse auto, clear
	iesave using "`test_folder'/id_1.dta", 	///
		idvars(make) 													///
		dtaversion(${stata_ver}) 							///
		replace

	* idvars list
	sysuse auto, clear
  gen id = make
	iesave using "`test_folder'/id_2.dta", 	///
		idvars(make id) 											///
		dtaversion(${stata_ver}) 							///
		replace

	* Missing values in the idvars
	sysuse auto, clear
	gen id = _n if _n != 74

	cap iesave using "`test_folder'/err_1.dta", 	///
		idvars(id) replace 														///
		dtaversion(${stata_ver})

	assert _rc == 459

	* Duplicates in the idvars
	sysuse auto, clear
	gen id = _n
	replace id = 3 in 4
	replace id = 8 in 11
	replace id = 8 in 21

	cap iesave using "`test_folder'/err_2.dta", 	///
		idvars(id) replace												///
		dtaversion(${stata_ver})

	assert _rc == 459

	/*********************
	      varreport
	*********************/

	sysuse auto, clear
	iesave using "`test_folder'/rep_1.dta",	///
		idvars(make) replace 									///
		dtaversion(${stata_ver}) 							///
		varreport("`test_folder'/rep_1.csv") 	///
		reportreplace

	/*********************
	      missing reportreplace
	*********************/
	sysuse auto, clear

	cap iesave using "`test_folder'/err_3.dta",	///
		idvars(make) dtaversion(${stata_ver})			///
		varreport("`test_folder'/rep_1.csv")			///
		replace
	assert _rc == 601


	/*********************
	      VNOMissing
	*********************/
	sysuse auto, clear
	cap iesave using "`test_folder'/nomiss_1.dta",	///
		idvars(make) 																	///
		dtaversion(${stata_ver}) 											///
		vnomissing(headroom trunk rep78)
	assert _rc == 416


	/*********************
	   VNOSTANDMissing
	*********************/
	sysuse auto, clear
	replace trunk = .d in 12
	replace trunk = .n in 13
	replace trunk = .a in 14
	replace trunk = . in 11

	cap iesave using "`test_folder'/nomiss_1.dta",	///
		idvars(make) dtaversion(${stata_ver}) 				///
		vnostandmissing(headroom trunk rep78)
	assert _rc == 416


	/*********************
	   userinfo
	*********************/

	sysuse auto, clear
	iesave using "`test_folder'/user_1.dta",	///
		idvars(make) replace										///
		dtaversion(${stata_ver}) 								///
		userinfo

/*******************************************************************************
    * Invalid syntaxes
*******************************************************************************/

	*****************
	* missing using
	sysuse auto, clear
	cap iesave
	assert _rc == 100

	*****************
	* idvars and dtaversion required options
	sysuse auto, clear
	cap iesave using "`test_folder'/err_4.dta"
	assert _rc == 198

	sysuse auto, clear
	cap iesave using "`test_folder'/err_5.dta", dtaversion(${stata_ver})
	assert _rc == 198

	sysuse auto, clear
	cap iesave using "`test_folder'/err_6.dta", idvars(make)
	assert _rc == 198


  *****************
	* incorrect .dta version value
	cap iesave using "`test_folder'/err_7.dta", idvars(make) dtaversion(18)
	assert _rc == 198

	*****************
	* reportreplace may only be used with varreport
	cap iesave using "`test_folder'/err_8.dta", ///
		idvars(make) dtaversion(${stata_ver}) 		///
		reportreplace
	assert _rc == 198

	*****************
	* missing report file extension AND bad path
	cap iesave using "`test_folder'/err_9.dta",	///
		idvars(make) dtaversion(${stata_ver}) 		///
		varreport("`test_folder'/report1")
	assert _rc == 601

	* folder don´t exist
	cap iesave using "`test_folder'/err_10.dta",	///
	 	idvars(make) dtaversion(${stata_ver}) 			///
		varreport("FOLDER-THAT-DSOES-NOT-EXIST/report1.csv")
	assert _rc == 601


********************************************************************************
	* Testing char values *
********************************************************************************

	/*****************************************
	Validate if char values are as expected
	*****************************************/

	sysuse auto, clear

	*1. Run iesave
	iesave using "`test_folder'/char_1.dta", ///
		idvars(make) dtaversion(${stata_ver}) replace userinfo

	return list

	*2. Store char values in locals
	foreach value in idvars N username computerid datasignature timesave {
		display 	 "`value' : " r(`value')
		local	 char_`value' : char _dta[iesave_`value']
	}

	*3. Open the dataset just saved
	use "`test_folder'/char_1.dta", clear
	datasignature
	local datasig `r(datasignature)'

	*4. Validate if char values are non-missing and as expected
	assert !missing("`char_idvars'")
	assert !missing("`char_N'")
	assert !missing("`char_username'")
	assert !missing("`char_computerid'")
	assert !missing("`char_datasignature'")

	assert "`char_idvars'" 				== "make"
	assert  `char_N'  						== _N
	assert "`char_username'" 			== "`c(username)'"
	assert "`char_computerid'"		== "`c(hostname)'"
	assert "`char_datasignature'"	== "`datasig'"

	*Make sure that time saved in char is less than time after sleeping for 3 sec
	sleep 3000
	assert Clock("`char_timesave'", "hmsDMY") < ///
				 Clock("`c(current_time)' `c(current_date)'", "hmsDMY")

	/**************************************************************
	Validate if char values are as expected after make data changes
	***************************************************************/

	sysuse auto, clear
	drop if trunk > 22
	drop displacement
	iesave using "`test_folder'/char_2.dta", ///
	idvars(make) dtaversion(${stata_ver}) replace userinfo

	di `" assert "`char_idvars'" 				== "`: char _dta[iesave_idvars]'" "'
	di `" assert "`char_username'" 			== "`: char _dta[iesave_username]'" "'
	di `" assert "`char_computerid'"		== "`: char _dta[iesave_computerid]'" "'
	di `" assert "`char_datasignature'"	!= "`: char _dta[iesave_datasignature]'" "'

	assert "`char_idvars'" 				== "`: char _dta[iesave_idvars]'"
	assert "`char_username'" 			== "`: char _dta[iesave_username]'"
	assert "`char_computerid'"		== "`: char _dta[iesave_computerid]'"
	assert "`char_datasignature'"	!= "`: char _dta[iesave_datasignature]'"

	**Test taht no err datasets were created

***************************** End of do-file ***********************************
