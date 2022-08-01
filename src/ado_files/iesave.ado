*! version 6.3 5NOV2019 DIME Analytics dimeanalytics@worldbank.org

capture program drop iesave
		program      iesave , rclass

	syntax using/,  IDvars(varlist) [replace userinfo report(string) debug SAVEVersion(string) version(string)]

	  *Save the three possible user settings before setting
	  * is standardized for this command
	  local version_char "c(stata_version):`c(stata_version)' c(version):`c(version)' c(userversion):`c(userversion)'"

	  version 12
	  
	  

/*******************************************************************************
	Test input
*******************************************************************************/
{
    
	if missing("`version'") & missing("`saveversion'") {
	    noi di as error "{phang}option {bf:version()} required{p_end}"
		error 198
	}
	else if missing("`version'") local version `saveversion'
	  ***************
	  * Dta version test

		*There are only three versions relevant here. Stata 11 can read Stata 12 format,
		*and Stata 15 and 16 saves in Stata 14 format anyways.
		local valid_dta_versions "12 13 14"
		if `:list saveversion in valid_dta_versions' == 0 {
	    di ""
	    di as error "{phang}In option {input:version(`version')} only the following values are allowed [`valid_dta_versions']. Stata 15 and 16 use the same .dta format as Stata 14. If you have Stata 14 or higher you can read more at {help saveold :help saveold}).{p_end}"
	    error 198
	  }

	  *Test that you can save in the data format you used.
		*Stata 12 can only save in Stata 12. Stata 13 can save in Stata 13 and 12
	  *Stata 14, 15 and 15 can save in Stata 14, 13 and 12. There is no new format
		*for Stata 15 and 16 (Stata 14 has a limit on number of variables that can
		*be held in memory, but that has nothing to do with the format used.)
		if (`c(stata_version)' < 13 & `version' > 12) { // "<13" to include versions like 12.1 etc.
	  	di as error "{phang}You are using Stata version `c(stata_version)' and you are therefore only able to save in the Stata 12 .dta-format. The version you indicated in {input:version(`version')}  is too recent for your version of Stata.{p_end}"
	  	error 198
	  }
		else if (`c(stata_version)' < 14 & `version' > 13) {
			di as error "{phang}You are using Stata version `c(stata_version)' and you are therefore only able to save in the Stata 12 and 13 .dta-format. The version you indicated in {input:version(`version')} is too recent for your version of Stata.{p_end}"
			error 198
		}

	  ***************
	  * var report tests

	  if ("`reportreplace'" != "") & ("`report'" == "") {
	  	di as error "{phang}Option {input:reportreplace} may only be used in combination with {input:report()}.{p_end}"
	  	error 198
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
}
/*******************************************************************************
	  ID variables
*******************************************************************************/
qui {
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
}
/*******************************************************************************
		Optimize storage on disk
*******************************************************************************/
qui {
	  *Optimize storage on disk
	  compress
}	
/*******************************************************************************
	Creating lists for data types
*******************************************************************************/
qui{	
	* String -------------------------------------------------------------------
	
	  ds, 	has(type string)
      local str_vars `r(varlist)'
	  
	* Numeric ------------------------------------------------------------------
	  
	  * All numeric
	  ds, 	has(type numeric)
      local num_vars `r(varlist)'
	  
	  * Date (anything with date display format)
	  ds, 	has(format %t*)
      local date_vars `r(varlist)'
	  
	  * All unlabeled
	  ds, 	not(vallabel)
	  local novallab_vars `r(varlist)'
	  
	  * Categorical variables (labeled numeric variables that are not dates)
	  local cat_vars : list num_vars - novallab_vars
	  local cat_vars : list cat_vars - date_vars
	  
	  * Continuous (all numeric variables that are not date or categorical)
	  local noncont_num_vars : list date_vars | cat_vars
      local cont_vars 		 : list num_vars - noncont_num_vars
}	

	if !missing("`debug'") {
		noi di "date_vars: `date_vars'"
		noi di "cat_vars: `cat_vars'"
		noi di "cont_vars: `cont_vars'"
		noi di "str_vars: `str_vars'"
	}

/*******************************************************************************
		Prepare output
*******************************************************************************/
{
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
	  qui describe
	  local N `r(N)'
	  local numVars `r(k)'
}
/*******************************************************************************
		Save to char
*******************************************************************************/
{
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
}
/*******************************************************************************
		Save report
*******************************************************************************/
	  
	  if !missing("`report'") {
	  	
		* Get options for variable report
	  	tokenize "`report'", parse(",")
									local report_path 	= strtrim("`1'") // file path
		if regex("`3'", "replace") 	local reportreplace	replace 		 // all other options
		if regex("`3'", "noalpha") 	local keepvarorder	keepvarorder 	 // all other options
		
		* Test input
		local report_std = subinstr(`"`report_path'"',"\","/",.)

	  	* Get file extension and folder from file path
	  	local report_fileext = substr(`"`report_std'"',strlen(`"`report_std'"')-strpos(strreverse(`"`report_std'"'),".")+1,.)
	  	local report_folder  = substr(`"`report_std'"',1,strlen(`"`report_std'"')-strpos(strreverse(`"`report_std'"'),"/"))

	  	*Test that the file extension is csv
	  	if !(`"`report_fileext'"' == ".csv") {
	  		noi di as error `"{phang}The report file [`report_path'] must include the file extension .csv.{p_end}"'
	  		error 601
	  	}

	  	*Test that the folder exist
	  	mata : st_numscalar("r(dirExist)", direxists("`report_folder'"))
	  	if (`r(dirExist)' == 0)  {
	  		noi di as error `"{phang}The folder in [`report'] does not exist.{p_end}"'
	  		error 601
	  	}

	  	*Test if reportreplace is used if the file already exist
	  	cap confirm file "`report_path'"
	  	if (_rc == 0 & "`reportreplace'" == "") {
	  		noi di as error `"{phang}The report file [`report_path'] already exists, use the option {input:reportreplace} if you want to overwrite this file.{p_end}"'
	  		error 601
	  	}
		
		* Write csv with variable report that can be version controlled
		* in git to track when variables change
		write_var_report, 			///
	  		file(`report_path') 	///
	  		datasig(`datasig') 		///
	  		idvars(`idvars') 		///
	  		n(`N')   	    		///
			user(`user_char')		///
			time(`timesave')		///
			str_vars(`str_vars')	///
			cont_vars(`cont_vars')	///
			date_vars(`date_vars')	///
			cat_vars(`cat_vars')	///
	  		`reportreplace' 		///
			`keepvarorder'			///
			`userinfo'				///
			`debug'
	  }	  
	  
/*******************************************************************************
		Save data
*******************************************************************************/
qui {
		*Stata 12.X just save as normal
		if `c(stata_version)' < 13 { // "< 13" to cover both 12.0 and 12.1
			save "`using'" , `replace'
		}
		*Stata 13, 12.1 just save as normal
		else if `c(stata_version)' < 14 { // "< 14" to cover both 13.0 and 13.1
			*if version() is 12 then use save old otherwise use regular old
			if `version' == 12 {
				saveold "`using'" , `replace'
			}
			else {
				save "`using'" , `replace'
			}
		}
		*For all Stata newver than 13.X use saveold for all versions as it
		*handles the cases when saving in the same version makes saveold redundant
		else {
			saveold "`using'" , `replace' v(`version')
		}
}
		noi di `"{phang}Data saved in .dta version `version' at {browse `"`using'"':`using'}{p_end}"'
		
/*******************************************************************************
		returned values
*******************************************************************************/
{
		*Return the outputs to return locals
		return local idvars       "`idvars'"
		return local username     "`user'"
		return local computerid   "`computer'"
		return local versions     "`version_char'"
		return local datasig      "`datasig'"
		return local N            "`N'"
		return local numvars      "`numVars'"
		return local iesave_str	  "`str_vars'"
		return local iesave_date  "`date_vars'"
		return local iesave_cat   "`cat_vars'"
		return local iesave_cont  "`cont_vars'"
}
end

/*******************************************************************************
********************************************************************************

	UTILITY COMMANDS

********************************************************************************
*******************************************************************************/

// Write variable report -------------------------------------------------------

cap program drop write_var_report
	program 	 write_var_report

	syntax , file(string) datasig(string) idvars(string) n(string) ///
		user(string) time(string) ///
		[date_vars(varlist) str_vars(varlist) cat_vars(varlist) cont_vars(varlist)] ///
		[replace keepvarorder userinfo debug]
		
	if !missing("`debug'") noi di "Entering write_var_report subcommand"
	
	  *Set up tempfile locals
	  tempname 	logname
	  tempfile	logfile
	  capture file close `logfile'

	  *Open the file and write headear
	  file open  `logname' 	using "`logfile'", text write replace
	  file write `logname' 	"Number of observations:,`n'" _n ///
							"ID variable(s):,`idvars'" _n ///
							"Data signature:,`datasig'" _n 
							
	if !missing("userinfo") {
	  file write `logname'  "Last saved by:,`user'" _n 
	}
	
	  file write `logname' 	"Last at:,`time'" _n _n
	  file close `logname'
	  
	  foreach vartype in str cont date cat {
	  	if !missing("``vartype'_vars'")  write_`vartype'_report  ``vartype'_vars', logname("`logname'") logfile("`logfile'") `debug'
	  }
	  
	  *Copy temp file to file location
	  qui copy "`logfile'"  "`file'", `replace'
	  noi di `"{phang}Meta data saved to {browse `"`file'"':`file'}{p_end}"'
	  
end

// Write string variable report ------------------------------------------------

cap program drop write_str_report
	program 	 write_str_report
	
	syntax varlist, logfile(string) logname(string) [debug]
	
	if !missing("`debug'") noi di "Entering write_str_report subcommand"
	
	* Open the file and write headear
	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' "Variable type: String" _n
	file write  	`logname' "Name,Label,Type,Complete observations,Number of levels" _n
	file close 		`logname'
	
	foreach var of local varlist {
		
		* Get labels
		local varlabel: variable label  `var'
		local vartype: 	type 			`var'

		* Number of levels and complete observations
		qui levelsof `var'
		local varlevels 	= r(r)
		local varcomplete	= r(N)	
		
		*Write variable row to file
		file open  `logname' using "`logfile'", text write append
		file write `logname' `"`var',`varlabel',`vartype',`varcomplete', `varlevels'"' _n
		file close `logname'
		
	}
	
	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' _n
	file close 		`logname'
	
end

// Write continuous variable report --------------------------------------------

cap program drop write_cont_report
	program 	 write_cont_report
	
	syntax varlist, logfile(string) logname(string) [debug]
	
	if !missing("`debug'") noi di "Entering write_cont_report subcommand"
	
	* Open the file and write headear
	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' "Variable type: Continuous" _n
	file write  	`logname' "Name,Label,Type,Complete observations,Mean,SD,p0,p25,p50,p75,p100" _n
	file close 		`logname'
	
	foreach var of local varlist {
		
		* Get labels
		local varlabel: variable label  `var'
		local vartype: 	type 			`var'

		* Number of levels and complete observations
		qui sum `var', det
		local varcomplete 	= r(N)
		local mean			= r(mean)
		local sd			= r(sd)
		local p0			= r(min)
		local p25			= r(p25)
		local p50			= r(p50)
		local p75			= r(p75)
		local p100			= r(max)

		*Write variable row to file
		file open  `logname' using "`logfile'", text write append
		file write `logname' `"`var',`varlabel',`vartype',`varcomplete',`mean',`sd',`p0',`p25',`p50',`p75',`p100'"' _n
		file close `logname'
		
	}
	
	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' _n
	file close 		`logname'
	
end

// Write date variable report --------------------------------------------------

cap program drop write_date_report
	program 	 write_date_report
	
	syntax varlist, logfile(string) logname(string) [debug]
	
	if !missing("`debug'") noi di "Entering write_date_report subcommand"
	
	* Open the file and write headear
	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' "Variable type: Date or date-time" _n
	file write  	`logname' "Name,Label,Format,Complete observations,Unique values,Mean,SD,Min,Median,Max" _n
	file close 		`logname'
	
	foreach var of local varlist {
		
		* Get labels
		local varlabel: 	variable label  `var'
		local varformat: 	format 			`var'

		* Number of levels and complete observations
		qui levelsof `var'
		local varlevels 	= r(r)
		local varcomplete	= r(N)	
		
		* Distribution
		qui sum `var', det
		local mean			= r(mean)
		local sd			= r(sd)
		local min			= r(min)
		local median		= r(p50)
		local max			= r(max)

		*Write variable row to file
		file open  `logname' using "`logfile'", text write append
		file write `logname' `"`var',`varlabel',`varformat',`varcomplete',`varlevels',`mean',`sd',`min',`median',`max'"' _n
		file close `logname'
		
	}
	
	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' _n
	file close 		`logname'
	
end

// Write categorical variable report -------------------------------------------

cap program drop write_cat_report
	program 	 write_cat_report
	
	syntax varlist, logfile(string) logname(string) [debug]
	
	if !missing("`debug'") noi di "Entering write_cat_report subcommand"
	
	* Open the file and write headear
	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' "Variable type: Categorical" _n
	file write  	`logname' "Name,Label,Value label,Complete observations,Number of levels,Number of unlabeled levels,Top count" _n
	file close 		`logname'
	
	foreach var of local varlist {
		
		* Get labels
		local varlabel: variable label  `var'
		local vallabel: value 	 label	`var'

		* Number of levels and complete observations
		qui levelsof `var'
		local varlevels 	= r(r)
		local varcomplete	= r(N)	
	
		* Count of unlabeled levels
		n_unlabeled `var', label(`vallabel') `debug'
		local nunlabeled = r(n_unlabeled)
		
		* Most frequent categories
		top_count `var', `debug'
		local topcount = r(top_count)
		
		*Write variable row to file
		file open  `logname' using "`logfile'", text write append
		file write `logname' `"`var',`varlabel',`vallabel',`varcomplete',`varlevels',`nunlabeled',`topcount'"' _n
		file close `logname'
	}
	
	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' _n
	file close 		`logname'
	
end

cap program drop top_count
	program		 top_count, rclass
	
	syntax varname, [debug]
	
	if !missing("`debug'") noi di "Entering top_count subcommand"
	
	preserve
		
		* Count number of observations per level
		gen count = 1
		collapse (sum) count if !missing(`varlist'), by(`varlist')
		
		* Sort levels by number of observations, in descending order
		gsort -count
				
		* Calculate number of levels to be displayed (minimum between 5 and the number of levels)
		qui count
		if (r(N) > 5) 	local max	5
		else			local max	= r(N)
			
		* Write the number of observations per level
		forvalues rank = 1/`max' {
		    local level = `varlist'[`rank']
			local count = count[`rank']
		    local top_count `"`top_count' `level':`count'"'
		}
		
	restore
	
	* Return top count to be reported
			local top_count = strtrim("`top_count'")
	return 	local top_count "`top_count'"
	
end

cap program drop n_unlabeled
	program		 n_unlabeled, rclass
	
	syntax varname, label(string) [debug]
	
	if !missing("`debug'") noi di "Entering n_unlabeled subcommand"
	
	qui {
	    preserve
		
			uselabel `label', clear
			levelsof value, local(labeled_values)
			
		restore
		
		levelsof `varlist', local(all_values)
		
		local unlabeled_values : list all_values - labeled_values
		
		if !missing("`unlabeled_values'") {
			 local n_unlabeled : word count "`unlabeled_values'"
		}
		else local n_unlabeled 0
	}
	
	* Return top count to be reported
	return 	local n_unlabeled `n_unlabeled'
	
end


********************************************************************************