*! version 6.3 5NOV2019 DIME Analytics dimeanalytics@worldbank.org

	capture program drop iesave
          program      iesave , rclass

	qui {

	  syntax using/,  IDvars(varlist) SAVEVersion(string) [replace userinfo]

	  *Save the three possible user settings before setting
	  * is standardized for this command
	  local version_char "c(stata_version):`c(stata_version)' c(version):`c(version)' c(userversion):`c(userversion)'"

	  version 12

	/*********************************
		Test input
	*********************************/

	  ***************
	  * Dta version test

		*There are only three versions relevant here. Stata 11 can read Stata 12 format,
		*and Stata 15 and 16 saves in Stata 14 format anyways.
	  local valid_dta_versions "12 13 14"
	  if `:list saveversion in valid_dta_versions' == 0 {
	    di ""
	    di as error "{phang}In option {input:saveversion(`saveversion')} only the following values are allowed [`valid_dta_versions']. Stata 15 and 16 use the same .dta format as Stata 14. If you have Stata 14 or higher you can read more at {help saveold :help saveold}).{p_end}"
	    error 198
	  }

	  *Test that you can save in the data format you used.
		*Stata 12 can only save in Stata 12. Stata 13 can save in Stata 13 and 12
	  *Stata 14, 15 and 15 can save in Stata 14, 13 and 12. There is no new format
		*for Stata 15 and 16 (Stata 14 has a limit on number of variables that can
		*be held in memory, but that has nothing to do with the format used.)
		if (`c(stata_version)' < 13 & `saveversion' > 12) { // "<13" to include versions like 12.1 etc.
	  	di as error "{phang}You are using Stata version `c(stata_version)' and you are therefore only able to save in the Stata 12 .dta-format. The version you indicated in {input:saveversion(`saveversion')}  is too recent for your version of Stata.{p_end}"
	  	error 198
	  }
		else if (`c(stata_version)' < 14 & `saveversion' > 13) {
			di as error "{phang}You are using Stata version `c(stata_version)' and you are therefore only able to save in the Stata 12 and 13 .dta-format. The version you indicated in {input:saveversion(`saveversion')} is too recent for your version of Stata.{p_end}"
			error 198
		}

	  ***************
	  * var report tests

	  if ("`reportreplace'" != "") & ("`varreport'" == "") {
	  	di as error "{phang}Option {input:reportreplace} may only be used in combination with {input:varreport()}.{p_end}"
	  	error 198
	  }

	  *Test varrepport input if it is used
	  if ("`varreport'" != "") {

	  	*standardize file path to only use forward slash
	  	local varreport_std = subinstr(`"`varreport'"',"\","/",.)

	  	* Get file extension and folder from file path
	  	local varreport_fileext = substr(`"`varreport_std'"',strlen(`"`varreport_std'"')-strpos(strreverse(`"`varreport_std'"'),".")+1,.)
	  	local varreport_folder  = substr(`"`varreport_std'"',1,strlen(`"`varreport_std'"')-strpos(strreverse(`"`varreport_std'"'),"/"))

	  	*Test that the file extension is csv
	  	if !(`"`varreport_fileext'"' == ".csv") {
	  		noi di as error `"{phang}The report file [`varreport'] must include the file extension .csv.{p_end}"'
	  		error 601
	  	}

	  	*Test that the folder exist
	  	mata : st_numscalar("r(dirExist)", direxists("`varreport_folder'"))
	  	if (`r(dirExist)' == 0)  {
	  		noi di as error `"{phang}The folder in [`varreport'] does not exist.{p_end}"'
	  		error 601
	  	}

	  	*Test if reportreplace is used if the file already exist
	  	cap confirm file "`varreport'"
	  	if (_rc == 0 & "`reportreplace'" == "") {
	  		noi di as error `"{phang}The report file [`varreport'] already exists, use the option {input:reportreplace} if you want to overwrite this file.{p_end}"'
	  		error 601
	  	}
	  }


	  ***************
	  * save file path options

	  * Standardize save file path
	  local using = subinstr(`"`using'"',"\","/",.)

	  *Get the save file extension
	  local fileext = substr(`"`using'"',strlen(`"`using'"')-strpos(strreverse(`"`using'"'),".")+1,.)

	  * If no save file extension was used, then add .dta to "`using'"
	  if "`fileext'" == "" {
	  	local using  "`using'.dta"
	  }
	  * Check if the save file extension is the correct
	  else if "`fileext'" != ".dta" {
	  	noi di as error `"{phang}The data file must include the extension [.dta]. The format [`fileext'] is not allowed.{p_end}"'
	  	error 198
	  }

	  *Confirm the file path is correct
	  cap confirm new file `using'
	  if (_rc == 603) {
	  	noi di as error `"{phang}The data file path used in [`using'] does not exist.{p_end}"'
	    error 601
	  }
	  *Test if replace is used if the file already exist
	  else if (_rc == 602) & missing("`replace'") {
	  	noi di as error `"{phang}The data file [`using'] already exists. Use the option [replace] if you want to overwrite the data.{p_end}"'
	  	error 602
	  }

	/*********************************
	  ID variables
	*********************************/

	  *Test that the ID var(s) is uniquely and fully identifying
		capture isid `idvars'
		if _rc {

		  *Test if there is missing values in the idvars
		  capture assert !missing(`idvars')
		  if _rc {
		  	count if missing(`idvars')
		  	noi di as error "{phang}The ID variable(s) `idvars' have missing values in `r(N)' observation(s). The ID variable(s) need to be fully identifying, meaning that missing values (., .a, .b ... .z) or the empty string are not allowed.{p_end}"
		  	noi list `idvars' if missing(`idvars')
		  	noi di ""
		  }

		  *Test if there are duplciates in the idvars
		  tempvar iedup
		  duplicates tag `idvars', gen(`iedup')
		  count if `iedup' != 0

		  *Test if any duplicates were found in the idvars
		  if `r(N)' > 0 {

		  	sort `idvars'
		  	noi di as error "{phang}To be uniquely identifying, the ID variable(s) should not have any duplicates. The ID variable(s) `idvars' has duplicate observations in the following values:{p_end}"
		  	noi list `idvars' if `iedup' != 0
		  }

		  *Add one space and run idvars to give built in error message
		  noi di ""
		  isid `idvars'
		}

	/*********************************
		Optimize storage on disk
	*********************************/

	  *Optimize storage on disk
	  compress
	
	/*********************************
	Creating lists for data types
	*********************************/
	
	  *Define list of locals with vars by category
	  
	  *String
	  
	  ds , has(type string)
    	  return list
          local iesave_str `r(varlist)'
	  
	  *Date
	  
	  ds , has(format %t* %-t*)
   	  return list
          local iesave_date `r(varlist)'
	  
	  *Categorical
	  
	  ds , has(type numeric)
	  return list 
          local iesave_num `r(varlist)'
	
       	  ds, not(vallabel)
	  return list 
	  local iesave_novallab `r(varlist)'
	
	  local iesave_cat : list iesave_num - iesave_novallab
	  local iesave_cat : list iesave_cat - iesave_date
	  
	  *Continuous 
	  
	  local iesave_num_oth : list iesave_date & iesave_cat
          local iesave_cont : list iesave_num - iesave_num_oth
	  
	
	/*********************************
		Prepare output
	*********************************/

	  *Save username to char is nameuser was used
	  if "`userinfo'" == "" {
	  	local user "Username withheld"
	  	local computer "Computer ID withheld"

	  	*In table use only option name
	  	local user_table "`user', see option {input:userinfo}"
	  	local computer_table "`computer', see option {input:userinfo}"

	  	*In char also list command name as info will
	  	*be read outside the context of this command.
	  	local user_char "`user', see option userinfo in command iesave"
	  	local computer_char "`computer', see option userinfo in command iesave"
	  }
	  else {

	  	*If user info is uncluded then no exlination is needed and all are the same
	  	local user "`c(username)'"
	  	local computer "`c(hostname)'"
	  	local user_table "`user'"
	  	local computer_table "`computer'"
	  	local user_char "`user'"
	  	local computer_char "`computer'"
	  }

	  *Save time and date
		local timesave "`c(current_time)' `c(current_date)'"

		*Create data signature
	  datasignature
	  local datasig `r(datasignature)'

	  *Get total number of obs and vars
	  describe
	  local N `r(N)'
	  local numVars `r(k)'

	/*********************************
		Save to char
	*********************************/

	  *Store the ID vars in char
	  char _dta[iesave_idvars]        "`idvars'"
	  char _dta[iesave_N]             "`N'"
	  char _dta[iesave_numvars]       "`numVars'"
	  char _dta[iesave_username]      "`user_char'"
	  char _dta[iesave_computerid]    "`computer_char'"
	  char _dta[iesave_timesave]      "`timesave'"
	  char _dta[iesave_version]       "`version_char'"
	  char _dta[iesave_datasignature] "`datasig'"
	  char _dta[iesave_success]       "iesave (https://dimewiki.worldbank.org/iesave) ran successfully"

	/*********************************
		Save data
	*********************************/

		*Stata 12.X just save as normal
		if `c(stata_version)' < 13 { // "< 13" to cover both 12.0 and 12.1
			save "`using'" , `replace'
		}
		*Stata 13, 12.1 just save as normal
		else if `c(stata_version)' < 14 { // "< 14" to cover both 13.0 and 13.1
			*if saveversion() is 12 then use save old otherwise use regular old
			if `saveversion' == 12 {
				saveold "`using'" , `replace'
			}
			else {
				save "`using'" , `replace'
			}
		}
		*For all Stata newver than 13.X use saveold for all versions as it
		*handles the cases when saving in the same version makes saveold redundant
		else {
			saveold "`using'" , `replace' v(`saveversion')
		}

		noi di `"{phang}Data saved in .dta version `saveversion' at {browse `"`using'"':`using'}{p_end}"'

	/*********************************
		returned values
	*********************************/

		*Return the outputs to return locals
		return local idvars       "`idvars'"
		return local username     "`user'"
		return local computerid   "`computer'"
		return local versions     "`version_char'"
		return local datasig      "`datasig'"
		return local N            "`N'"
		return local numvars      "`numVars'"
		return local iesave_str	  "`iesave_str'"
		return local iesave_date  "`iesave_date'"
		return local iesave_cat   "`iesave_cat'"
		return local iesave_cont  "`iesave_cont'"

}
end
