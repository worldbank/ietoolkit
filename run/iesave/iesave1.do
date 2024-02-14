
	/*****************************************************************************
	  Set up
	*****************************************************************************/

  * Comment out to run without debug mode
  local debug debug

  local iesave_folder  "run/iesave"
  local out            "`iesave_folder'/outputs/iesave1"
  local reports_folder "`out'/reports"

	* Load the version in this clone into memory. If you need to use the version
	* currently installed in you instance of Stata, then simply re-start Stata.
	* Set up the ietoolkit_clone global root path in ietoolkit\run\run_master.do
	qui do "src/ado_files/iesave.ado"
  qui do "src/ado_files/ietoolkit.ado"

	*Load utility functions that create and resets folders across runs
	qui do "run/run_utils.do"

	/*****************************************************************************
		Run this run file once for each save file version
	*****************************************************************************/

    *Remove all previously generated output (if any)
    ie_recurse_rmdir, folder("`out'") okifnotexist

    *Re-create the reports folders
    ie_recurse_mkdir, folder("`reports_folder'")

    * Only include the version your Stata version can run
  	if 		`c(stata_version)'   < 13 local stata_versions 12
  	else if `c(stata_version)' < 14 local stata_versions 12 13
  	else                            local stata_versions 12 13 14

    * most basic case for quick testing - with and without path in ""
    sysuse auto, clear
    iesave `out'/basic, idvars(make) version(13.1)
    sysuse auto, clear
    iesave "`out'/basic.dta", idvars(make) version(13.1) replace


	foreach stata_ver of local stata_versions {

    local version_folder "`out'/v`stata_ver'"

		* Create the output folder (and all its parents is needed)
		ie_recurse_mkdir, folder("`version_folder'")

		*Lsit of all files this run file is expected to create
		local expected_files ""

	/*****************************************************************************
		Options: No error
	*****************************************************************************/

		/*********************
		      IDvars
		*********************/

		* single id
		sysuse auto, clear
		iesave "`version_folder'/id_1.dta", 	///
			idvars(make) version(`stata_ver') 						///
			                    ///
			replace

        * Test that command truly save in correct format
        dtaversion "`version_folder'/id_1.dta"
        if `stata_ver' == 12 assert `r(version)' == 115
        if `stata_ver' == 13 assert `r(version)' == 117
        if `stata_ver' == 14 assert `r(version)' == 118

		*Add this file to list of expected files
		local expected_files `"`expected_files' "id_1.dta""'

		* idvars list
		sysuse auto, clear
	    gen id = make
		iesave "`version_folder'/id_2.dta", 	///
			idvars(make id) 											///
			version(`stata_ver') 							///
			replace

		*Add this file to list of expected files
		local expected_files `"`expected_files' "id_2.dta""'

		* Missing values in the idvars
		sysuse auto, clear
		gen id = _n if _n != 74

		cap iesave "`version_folder'/err_id_1.dta", 	///
			idvars(id) replace 														///
			version(`stata_ver')
		assert _rc == 459

		* Duplicates in the idvars
		sysuse auto, clear
		gen id = _n
		replace id = 3 in 4
		replace id = 8 in 11
		replace id = 8 in 21

		cap iesave "`version_folder'/err_id_2.dta", 	///
			idvars(id) replace												///
			version(`stata_ver')
		assert _rc == 459

        /*********************
		      Mutliple IDvars with missing values
		*********************/

 		* Load auto
		sysuse auto, clear
        
        * Create ids that are only unique in combination
        gen village = foreign 
        sort village make
        by  village : gen village_hhid = _n
         
        * First test that it works without missing
		iesave "`version_folder'/id_3.dta", 	///
			idvars(village village_hhid) version(15) replace
 
 		*Add this file to list of expected files
		local expected_files `"`expected_files' "id_3.dta""'
        
        *  Create some missing vars
        replace village = . in 5
        replace village_hhid = . in 65
        
        * Run iesave and test for expected error
        cap iesave "`version_folder'/err_id_3.dta", ///
            idvars(village village_hhid) version(15) replace
        assert _rc == 459
        
		/*********************
		   absence of userinfo
		*********************/

		sysuse auto, clear
		iesave "`version_folder'/user_1.dta",	///
			idvars(make) replace										///
			version(`stata_ver')

		*Add these files to list of expected files
		local expected_files `"`expected_files' "user_1.dta""'

		*open the file again and test that placeholder text were used
		use "`version_folder'/user_1.dta", clear
		assert "Username withheld, see option userinfo in command iesave." == "`: char _dta[iesave_username]'"
		assert "Computer ID withheld, see option userinfo in command iesave." == "`: char _dta[iesave_computerid]'"

	/*******************************************************************************
	    * Invalid syntaxes
	*******************************************************************************/

		*****************
		* missing using
		sysuse auto, clear
		cap iesave
		assert _rc == 100

		*****************
		* idvars and version required options
		sysuse auto, clear
		cap iesave "`version_folder'/err_syntax_1.dta"
		assert _rc == 198

		sysuse auto, clear
		cap iesave "`version_folder'/err_syntax_2.dta", version(`stata_ver')
		assert _rc == 198

		sysuse auto, clear
		cap iesave "`version_folder'/err_syntax_3.dta", idvars(make)
		assert _rc == 198


	  *****************
		* incorrect .dta version value
		cap iesave "`version_folder'/err_syntax_4.dta", idvars(make) version(18)
		assert _rc == 198

		*****************
		* reportreplace may only be used with varreport
		cap iesave "`version_folder'/err_syntax_5.dta", ///
			idvars(make) version(`stata_ver') 		///
			reportreplace
		assert _rc == 198

	********************************************************************************
		* Testing char values *
	********************************************************************************

		/*****************************************
		Validate if char values are as expected
		*****************************************/

		sysuse auto, clear

		*1. Run iesave
		iesave "`version_folder'/char_1.dta", ///
			idvars(make) version(`stata_ver') replace userinfo

		*Add these files to list of expected files
		local expected_files `"`expected_files' "char_1.dta""'

		*2. Store char values in locals
		foreach value in idvars N username computerid datasignature timesave {
			//display 	 "`value' : " r(`value')
			local	 char_`value' : char _dta[iesave_`value']
		}

		*3. Open the dataset just saved
		use "`version_folder'/char_1.dta", clear
		qui datasignature
		local datasig `r(datasignature)'

		*4. Validate if char values are non-missing and as expected
		assert !missing("`char_idvars'")
		assert !missing("`char_N'")
		assert !missing("`char_username'")
		assert !missing("`char_computerid'")
		assert !missing("`char_datasignature'")

		assert "`char_idvars'"         == "make"
		assert  `char_N'               == _N
		assert "`char_username'"       == "`c(username)'"
		assert "`char_computerid'"     == "`c(hostname)'"
		assert "`char_datasignature'"  == "`datasig'"

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
		iesave "`version_folder'/char_2.dta", ///
			idvars(make) version(`stata_ver') replace userinfo

		*Add these files to list of expected files
		local expected_files `"`expected_files' "char_2.dta""'

		di `" assert "`char_idvars'" 		== "`: char _dta[iesave_idvars]'" "'
		di `" assert "`char_username'" 		== "`: char _dta[iesave_username]'" "'
		di `" assert "`char_computerid'"	== "`: char _dta[iesave_computerid]'" "'
		di `" assert "`char_datasignature'"	!= "`: char _dta[iesave_datasignature]'" "'

		assert "`char_idvars'" 				== "`: char _dta[iesave_idvars]'"
		assert "`char_username'" 			== "`: char _dta[iesave_username]'"
		assert "`char_computerid'"		    == "`: char _dta[iesave_computerid]'"
		assert "`char_datasignature'"	    != "`: char _dta[iesave_datasignature]'"

		/**************************************************************
		Test that only the exact data sets expected are created
		***************************************************************/

		*List files in output folder and remove the double qoutes
		local files_in_folder : dir `"`version_folder'"' files "*"	, respectcase

		*Get list of missing and extra files
		local missing_files : list expected_files - files_in_folder
		local extra_files : list files_in_folder - expected_files

		*Output error if there were extra or missing files
		if `"`missing_files'"' != "" {
			noi di as error `"{phang}The following files were expecetd to be created by this run0file but they were not created [`missing_files']{p_end}"'
			error 9
		}
		if `"`extra_files'"' != "" {
			noi di as error `"{phang}The following files were not expecetd to be created by this run-file but they were created [`extra_files']{p_end}"'
			error 9
		}


// Test meta data report -------------------------------------------------------

	set seed 1989

	sysuse auto, clear
	gen day 	= runiform(1, 30)
	gen month 	= runiform(1, 12)
	gen year 	= runiform(1990, 2020)
	gen date 	= mdy(month, day, year)
	format date %td

    lab var mpg "Milage , mpg"

    * Use defaults
    iesave "`reports_folder'/auto_defualt_v`stata_ver'.dta", ///
		idvars(make) ///
		version(`stata_ver') ///
        report

    * Use defaults but with csv and userinfo
    iesave "`reports_folder'/auto_csv_v`stata_ver'.dta", ///
		idvars(make) userinfo  ///
		version(`stata_ver') ///
        report(csv)

    *User location
    local userlocation "`reports_folder'/userlocation"
    ie_recurse_mkdir, folder("`userlocation'")

	iesave "`reports_folder'/auto_location_v`stata_ver'.dta", ///
		idvars(make) ///
		version(`stata_ver') ///
		userinfo ///
		report(path("`userlocation'/auto_location_v`stata_ver'.md")) `debug'

}

    // Test replace options for meta data report -------------------------------

    * Default location
	sysuse auto, clear
	iesave "`reports_folder'/report_replace.dta", ///
		idvars(make) ///
		version(13) ///
		report `debug'

	sysuse auto, clear
	iesave "`reports_folder'/report_replace.dta", ///
		idvars(make) ///
		version(13.1) ///
		replace ///
		report `debug'


    * User specified location
	sysuse auto, clear
	iesave "`reports_folder'/reportpath_replace.dta", ///
		idvars(make) ///
		version(13) ///
        report(path("`reports_folder'/reportpath_replace.csv")) ///
		`debug'

	sysuse auto, clear
	iesave "`reports_folder'/reportpath_replace.dta", ///
		idvars(make) ///
		version(13) ///
        report(path("`reports_folder'/reportpath_replace.csv") replace) ///
		replace  ///
		`debug'

***************************** End of do-file ***********************************
