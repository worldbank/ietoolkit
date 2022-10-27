*! version 6.3 5NOV2019 DIME Analytics dimeanalytics@worldbank.org

capture program drop iesave
		program      iesave , rclass

	syntax using/,             ///
		/* Required options */ ///
        IDvars(varlist)        ///
		    dtaversion(string) ///
                               ///
		[                      ///
		/* options options */  ///
		    replace            ///
            userinfo           ///
            report             ///
            reportpath(string) ///
            noalpha            ///
		                       ///
		/* dev tools*/         ///
            debug              ///
		]

	  *Save the three possible user settings before setting
	  * is standardized for this command
	  local version_char "c(stata_version):`c(stata_version)' c(version):`c(version)' c(userversion):`c(userversion)'"

	  version 12


/*******************************************************************************
	Test input
*******************************************************************************/
qui {

	***************
	* Dta version test
    *There are only three versions relevant here. Stata 11 can read Stata 12 format,
    *and Stata 15 and later saves in Stata 14 format anyways.
    local valid_dtaversions "12 13 14"
    if `:list dtaversion in valid_dtaversions' == 0 {
        noi di ""
        noi di as error "{phang}In option {input:version(`dtaversion')} only the following values are allowed [`valid_dtaversions']. Stata 15 and later use the same .dta format as Stata 14. If you have Stata 14 or higher you can read more at {help saveold :help saveold}).{p_end}"
        error 198
    }

    *Test that you can save in the data format you used.
    *Stata 12 can only save in Stata 12. Stata 13 can save in Stata 13 and 12
    *Stata 14, 15 and 15 can save in Stata 14, 13 and 12. There is no new format
    *for Stata 15 and 16 (Stata 14 has a limit on number of variables that can
    *be held in memory, but that has nothing to do with the format used.)
    if (`c(stata_version)' < 13 & `dtaversion' > 12) { // "<13" to include versions like 12.1 etc.
	    noi di as error "{phang}You are using Stata version `c(stata_version)' and you are therefore only able to save in the Stata 12 .dta-format. The version you indicated in {input:dtaversions(`dtaversion')} is too recent for your version of Stata.{p_end}"
	    error 198
    }
    else if (`c(stata_version)' < 14 & `dtaversion' > 13) {
	    noi di as error "{phang}You are using Stata version `c(stata_version)' and you are therefore only able to save in the Stata 12 and 13 .dta-format. The version you indicated in {input:dtaversions(`dtaversion')} is too recent for your version of Stata.{p_end}"
        error 198
    }

    ***************
    * Report input tests

    * If reportpath used but not report,
    * then set the local report as if the option report was used.
    if missing("`report'") & !missing("`reportpath'") local report "report"

    ***************
    * save file path options

    * Standardize save file path
    local using = subinstr(`"`using'"',"\","/",.)

    *Get the save file extension
    local fileext = substr(`"`using'"',strlen(`"`using'"')-strpos(strreverse(`"`using'"'),".")+1,.)

    * If no save file extension was used, then add .dta to "`using'"
    if "`fileext'" == "" local using  "`using'.dta"
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

/*******************************************************************************
	  ID variables
*******************************************************************************/

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

/*******************************************************************************
		Optimize storage on disk
*******************************************************************************/

	*Optimize storage on disk
	compress

/*******************************************************************************
	Creating lists for data types
*******************************************************************************/
qui{

	* String -------------------------------------------------------------------

	if missing("`noalpha'") local alpha alpha

	ds,   has(type string) `alpha'
	local str_vars `r(varlist)'

	* Numeric ------------------------------------------------------------------

	* All numeric
	ds,   has(type numeric) `alpha'
	local num_vars `r(varlist)'

	* Date (anything with date display format)
	ds,   has(format %t*) `alpha'
	local date_vars `r(varlist)'

	* All unlabeled
	ds,   not(vallabel) `alpha'
	local novallab_vars `r(varlist)'

	* Categorical variables (labeled numeric variables that are not dates)
	local cat_vars : list num_vars - novallab_vars
	local cat_vars : list cat_vars - date_vars

	* Continuous (all numeric variables that are not date or categorical)
	local noncont_num_vars : list date_vars | cat_vars
	local cont_vars        : list num_vars - noncont_num_vars

	if !missing("`debug'") {
		noi di "date_vars: `date_vars'"
		noi di "cat_vars: `cat_vars'"
		noi di "cont_vars: `cont_vars'"
		noi di "str_vars: `str_vars'"
	}

/*******************************************************************************
		Prepare output
*******************************************************************************/

	*Prepare user info

	*Do not display user info in meta data saved to file and report
	if "`userinfo'" == "" {
		local see_option_str "see option userinfo in command iesave."
		*In char also list command name as info will
		*be read outside the context of this command.
		local user "Username withheld, `see_option_str'"
		local computer "Computer ID withheld, `see_option_str'"
		local reportuser "User info withheld, `see_option_str'"
	}
	else {
		*If user info is uncluded then no exlination is needed and all are the same
		local user "`c(username)'"
		local computer "`c(hostname)'"
		local reportuser "`user' - `computer'"
	}

	*Save time and date
	local timesave "`c(current_time)' `c(current_date)'"

	*Create data signature
	datasignature
	local datasig `r(datasignature)'

	*Get total number of obs and vars
	local N 	  = _N
	noi di "Number of obs: `N'"
	local numVars = c(k)

}
/*******************************************************************************
		Save to char
*******************************************************************************/

	*Store the ID vars in char
	char _dta[iesave_idvars]        "`idvars'"
	char _dta[iesave_N]             "`N'"
	char _dta[iesave_numvars]       "`numVars'"
	char _dta[iesave_username]      "`user'"
	char _dta[iesave_computerid]    "`computer'"
	char _dta[iesave_timesave]      "`timesave'"
	char _dta[iesave_version]       "`version_char'"
	char _dta[iesave_datasignature] "`datasig'"
	char _dta[iesave_success]       "iesave (https://dimewiki.worldbank.org/iesave) ran successfully"

/*******************************************************************************
		Save report
*******************************************************************************/

	if !missing("`report'") {

		* Use same location and file name if reportpath not explicitly provided
		if missing("`reportpath'") {
		  * using already cleaned so replace the file path
			local reportpath = subinstr("`using'",".dta",".md",.)
		}

	  * Test input
	  local report_std = subinstr(`"`reportpath'"',"\","/",.)

		* Get file extension and folder from file path
		local report_fileext = substr(`"`report_std'"',strlen(`"`report_std'"')-strpos(strreverse(`"`report_std'"'),".")+1,.)
		local report_folder  = substr(`"`report_std'"',1,strlen(`"`report_std'"')-strpos(strreverse(`"`report_std'"'),"/"))

		*Test that the file extension is csv
		if !inlist(`"`report_fileext'"', ".csv", ".md") {
			noi di as error `"{phang}The report file [`reportpath'] must include the file extensions .csv or .md.{p_end}"'
			error 601
		}

		*Test that the folder exist
		mata : st_numscalar("r(dirExist)", direxists("`report_folder'"))
		if (`r(dirExist)' == 0)  {
			noi di as error `"{phang}The folder in [`reportpath'] does not exist.{p_end}"'
			error 601
		}

		*Test if replace is used if the file already exist
		cap confirm file "`reportpath'"
		if (_rc == 0 & "`replace'" == "") {
			noi di as error `"{phang}The report file [`reportpath'] already exists, use the option {input:replace} if you want to overwrite this file.{p_end}"'
			error 601
		}

		* Write csv with variable report that can be version controlled
		* in git to track when variables change
		noi write_var_report,        ///
            file(`reportpath')       ///
            datasig(`datasig')       ///
            dtaversion(`dtaversion') ///
            idvars(`idvars')         ///
            n(`N')                   ///
            n_vars(`numVars')        ///
            user(`reportuser')       ///
            time(`timesave')         ///
            str_vars(`str_vars')     ///
            cont_vars(`cont_vars')   ///
            date_vars(`date_vars')   ///
            cat_vars(`cat_vars')     ///
            format(`report_fileext') ///
            `replace'          ///
            `keepvarorder'           ///
            `debug'

	}

/*******************************************************************************
		Save data
*******************************************************************************/

	*Stata 12.X just save as normal - "< 13" to cover both 12.0 and 12.1
	if `c(stata_version)' < 13 save "`using'" , `replace'

	*Stata 13, 12.1 just save as normal
	else if `c(stata_version)' < 14 { // "< 14" to cover both 13.0 and 13.1
		*if version() is 12 then use save old otherwise use regular old
		if `dtaversion' == 12 saveold "`using'" , `replace'
		else                   save    "`using'" , `replace'
	}
	*For all Stata newver than 13.X use saveold for all versions as it
	*handles the cases when saving in the same version makes saveold redundant
	else saveold "`using'" , `replace' v(`dtaversion')

	noi di `"{phang}Data saved in .dta version `dtaversion' at {browse `"`using'"':`using'}{p_end}"'

/*******************************************************************************
		returned values
*******************************************************************************/

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

} //quitely
end

/*******************************************************************************
********************************************************************************

	UTILITY COMMANDS

********************************************************************************
*******************************************************************************/

// Write variable report -------------------------------------------------------

cap program drop write_var_report
	program 	 write_var_report

	syntax , file(string) format(string) ///
		datasig(string) dtaversion(string) idvars(string) n(string) n_vars(string) ///
		time(string) user(string) ///
		[date_vars(varlist) str_vars(varlist) cat_vars(varlist) cont_vars(varlist)] ///
		[replace debug]
qui {
	if !missing("`debug'") noi di "Entering write_var_report subcommand"

	  *Set up tempfile locals
	  tempname 	logname
	  tempfile	logfile
	  capture file close `logfile'

	  write_header, ///
		   n(`n') n_vars(`n_vars') idvars(`idvars') ///
		   datasig(`datasig') dtaversion(`dtaversion') ///
		   user(`user') time(`time') ///
		   format(`format') ///
		   logname("`logname'") logfile("`logfile'") `debug'

	  foreach vartype in str cont date cat {
	  	if !missing("``vartype'_vars'") {
			if !missing("`debug'") noi di "vartype: `vartype'"

			write_`vartype'_report  ``vartype'_vars', ///
				format(`format') ///
				logname("`logname'") logfile("`logfile'") `debug'
		}
	  }

	  *Copy temp file to file location
	  copy "`logfile'"  "`file'", `replace'
	  noi di `"{phang}Meta data saved to {browse `"`file'"':`file'}{p_end}"'
}
end

cap program drop write_header
	program 	 write_header

	syntax, ///
		n(string) n_vars(string) idvars(string) datasig(string) time(string) user(string) ///
		logfile(string) logname(string) format(string) dtaversion(string) ///
		[debug ]

	if !missing("`debug'") noi di "Entering write_header subcommand"

	if ("`format'" == ".csv") {
		local sep ","
	}
	if ("`format'" == ".md")  {
		local item   "- "
		local bf 	 "**"
		local sep	 " "
	}

	*Get the version of ietoolkit installed
	cap ietoolkit
	if missing("`r(version)'") local ietkit_v "%% ietoolkit not installed through SSC %%"
	else                       local ietkit_v "version `r(version)'"

	*Open the file and write headear
	  file open  `logname' 	using "`logfile'", text write replace
	  file write `logname' 	"This report was created by the Stata command iesave (`ietkit_v'). Read more about this command and the purpose of this report on https://dimewiki.worldbank.org/iesave" _n _n ///
							"`item'`bf'Number of observations:`bf'`sep'`n'" _n ///
							"`item'`bf'Number of variables:`bf'`sep'`n_vars'" _n ///
							"`item'`bf'ID variable(s):`bf'`sep'`idvars'" _n ///
							"`item'`bf'.dta version used:`bf'`sep'`dtaversion'" _n ///
							"`item'`bf'Data signature:`bf'`sep'`datasig'" _n ///
							"`item'`bf'Last saved by:`bf'`sep'`user'" _n

	  file write `logname' 	"`item'`bf'Last saved at:`bf'`sep'`time'" _n _n
	  file close `logname'

end

cap program drop write_line
	program 	 write_line

	syntax anything, logfile(string) logname(string) format(string) [debug]

	if !missing("`debug'") noi di "Entering write_line subcommand"

	if 		("`format'" == ".csv") local sep ","
	else if ("`format'" == ".md")  local sep " | "
								   local line = subinstr(`anything', "~", "`sep'", .)
	if		("`format'" == ".md")  local line   | `line' |

	*Remove excessive spaces in the line before writing it to file
	local line = trim(itrim(`"`line'"'))

	file open  `logname' using "`logfile'", text write append
	file write `logname' 	  `"`line'"' _n
	file close `logname'

end

cap program drop write_title
	program 	 write_title

	syntax anything, logfile(string) logname(string) format(string) [debug]

	if !missing("`debug'") noi di "Entering write_title subcommand"

	if ("`format'" == ".md") local marker 	"## "
							 local line 	`marker'`anything'

							 file open  `logname' using "`logfile'", text write append
							 file write `logname' `"`line'"' _n
	if ("`format'" == ".md") file write `logname' _n
							 file close `logname'

end

cap program drop write_table_header
	program 	 write_table_header

	syntax anything, logfile(string) logname(string) format(string) [debug]

	if !missing("`debug'") noi di "Entering write_table_header subcommand"

	* Prepare options
	if ("`format'" == ".md") {
		local line  = subinstr(`anything', ",", " | ", .)
		local line    | `line' |
		local n_col = length(`"`line'"') - length(subinstr(`"`line'"', "|", "", .)) -1
	}
	else {
		local line  `anything'
	}

	* Write table header

			file open  `logname' using "`logfile'", text write append
			file write `logname' 	  `"`line'"' _n

	if ("`format'" == ".md") {

			file write `logname' 	  `"|"'

		forvalues col = 1/`n_col' {
			file write `logname' 	  `"---|"'
		}
			file write `logname' 	  _n
	}

			file close `logname'

end

// Write string variable report ------------------------------------------------

cap program drop write_str_report
	program 	 write_str_report

	syntax varlist, logfile(string) logname(string) format(string) [debug]

	if !missing("`debug'") noi di "Entering write_str_report subcommand"

	* Open the file and write headear
	write_title Variable type: String, ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	write_table_header "Name,Label,Type,Complete obs,Number of levels", ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	* Calculate column values
	foreach var of local varlist {

		* Get labels
		local varlabel: variable label  `var'
		local vartype: 	type 			`var'

		* Number of levels and complete observations
		qui levelsof `var'
		local varlevels 	= r(r)
		local varcomplete	= r(N)

		*Write variable row to file
		write_line `"`var'~"`varlabel'"~`vartype'~`varcomplete'~`varlevels'"', ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	}

	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' _n
	file close 		`logname'

end

// Write continuous variable report --------------------------------------------

cap program drop write_cont_report
	program 	 write_cont_report

	syntax varlist, logfile(string) logname(string) format(string) [debug]

	if !missing("`debug'") noi di "Entering write_cont_report subcommand"

	* Section title
	write_title Variable type: Continuous, ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	* Column header
	write_table_header "Name,Label,Type,Complete obs,Mean,Std Dev,p0,p25,p50,p75,p100", ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	* Calculate column values
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

		foreach stat in mean sd p0 p25 p50 p75 p100 {
			local `stat' : di %9.4g ``stat''
		}

		*Write variable row to file
		write_line `"`var'~"`varlabel'"~`vartype'~`varcomplete'~`mean'~`sd'~`p0'~`p25'~`p50'~`p75'~`p100'"', ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'
	}

	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' _n
	file close 		`logname'

end

// Write date variable report --------------------------------------------------

cap program drop write_date_report
	program 	 write_date_report

	syntax varlist, logfile(string) logname(string) format(string) [debug]

	if !missing("`debug'") noi di "Entering write_date_report subcommand"

	* Open the file and write headear
	write_title Variable type: Date or date-time, ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	write_table_header "Name,Label,Format,Complete obs,Unique values,Mean,Std Dev,Min,Median,Max", ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	* Calculate column values
	foreach var of local varlist {

		* Get labels
		local varlabel: 	variable label  `var'
		local varformat: 	format 			`var'

		* Number of levels and Complete obs
		qui levelsof `var'
		local varlevels 	= r(r)
		local varcomplete	= r(N)

		* Distribution
		qui sum `var', det
		local sd		= r(sd)
		local min		= r(min)
		local mean		= r(mean)
		local sd		= r(sd)
		local min		= r(min)
		local median	= r(p50)
		local max		= r(max)

		foreach stat in mean min median max {
			local `stat' : di `varformat' ``stat''
		}
			local sd 	 : di %9.4g `sd'

		*Write variable row to file
		write_line `"`var'~"`varlabel'"~`varformat'~`varcomplete'~`varlevels'~`mean'~`sd'~`min'~`median'~`max'"', ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'
	}

	file open  		`logname' using "`logfile'", text write append
	file write  	`logname' _n
	file close 		`logname'

end

// Write categorical variable report -------------------------------------------

cap program drop write_cat_report
	program 	 write_cat_report

	syntax varlist, logfile(string) logname(string) format(string) [debug]

	if !missing("`debug'") noi di "Entering write_cat_report subcommand"

	* Section title
	write_title Variable type: Categorical, ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	* Table header
	write_table_header "Name,Label,Value label,Complete obs,Number of levels,Number of unlabeled levels,Top count", ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'

	* Calculate column values
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
		write_line `"`var'~"`varlabel'"~`vallabel'~`varcomplete'~`varlevels'~`nunlabeled'~`topcount'"', ///
			logfile("`logfile'") logname("`logname'") format("`format'") `debug'
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
		decode `varlist', gen(label)

		* Sort levels by number of observations, in descending order
		gsort -count

		* Calculate number of levels to be displayed (minimum between 5 and the number of levels)
		qui count
		if (r(N) > 5) 	local max	5
		else			local max	= r(N)

		* Write the number of observations per level
		forvalues rank = 1/`max' {
		    local level = label[`rank']
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
