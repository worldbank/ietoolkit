*! version 6.3 5NOV2019 DIME Analytics dimeanalytics@worldbank.org

	capture program drop ieboilsave
				program      ieboilsave , rclass

		qui {

		syntax ,  IDvars(varlist) dtaversion(string) [varreport(string) reportreplace replace VNOMissing(varlist) VNOSTANDMissing(varlist numeric) userinfo]

			*Save the three possible user settings before setting
			* is standardized for this command
			local version_char "c(stata_version):`c(stata_version)' c(version):`c(version)' c(userversion):`c(userversion)'"

			version 11.0

/*********************************
	Test input
*********************************/

			***************
			* Dta version test

			local valid_dta_versions "11 12 13 14 15 16"
			if `:list dtaversion in valid_dta_versions' == 0 {
				di ""
				di as error "{phang}In option {input:dtaversion(`dtaversion')} only the following values are allowed [`valid_dta_versions'].{p_end}"
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
					noi di as error `"{phang}The report file [`varreport'] already exist, use the option {input:reportreplace} if you want to overwrite the file.{p_end}"'
					error 601
				}
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
            noi di ""
        }

				*Test if there are duplciates in the idvars
				tempvar iedup
				duplicates tag `idvars', gen(`iedup')
				count if `iedup' != 0

				*Test if any duplicates were found
				if r(N) > 0 {

				    sort `idvars'
						noi di as error "{phang}To be uniquely identifying, the ID variable(s) should not have any duplicates. The ID variable(s) `idvars' has duplicate observations in the following values:{p_end}"
						noi list `idvars' if `iedup' != 0
				}

				*Add one space and run idvars to give built in error message
				noi di ""
				isid `idvars'
		}

		/*********************************
			Missing values of any type
		*********************************/

		local missVarError ""

		*Loop over all vars that may not have missing values
		* and list them in local if they do
		foreach noMissVar of local vnomissing {
			cap assert !missing(`noMissVar')
			if _rc local missVarError `missVarError' `noMissVar'
		}

			*If any variable incorrectly includes missing vars, display error
			if ("`missVarError'" != "") {
				noi di as error "{phang}One or more variables listed in option vnomissing() has missing values which is not allowed. Those variable(s) are [`missVarError']{p_end}"
				error 416
				exit
			}

		/*********************************
			Missing standard missing
			.a,.b is allowed but not .
		*********************************/

		local missVarError ""

		*Loop over all vars that may not have missing values
		* and list them in local if they do
		foreach noMissVar of local vnostandmissing {
			cap assert `noMissVar' != .
			if _rc local missVarError `missVarError' `noMissVar'
		}

		*If any variable incorrectly includes missing vars, display error
		if ("`missVarError'" != "") {
			noi di as error "{phang}One or more variables listed in option vnostandmissing() has standard missing values which is not allowed. Those variable(s) are [`missVarError']{p_end}"
			error 416
			exit
			}

/*********************************
	Optimize storage on disk
*********************************/

			*Optimize storage on disk
			compress

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
	Write variable report
*********************************/

			*Write csv with variable report that can be version controlled
			* in git to track when variables change
			if ("`varreport'" != "") write_var_report , ///
					file(`varreport') ///
					datasig(`datasig') ///
					idvars(`idvars') 	///
					n(`N') 				    ///
					`reportreplace' `keepvarorder'

		/*********************************
			Display in table
		*********************************/
			noi di ""

			* List the locals with values in the table
			local output_locals "idvars user_table computer_table timesave version_char datasig"

			*Find the length of longest value
			local maxlen 0
		foreach output_local of local output_locals {
			local maxlen = max(`maxlen',strlen("``output_local''"))
		}

		*Lenght of horizontal lines in header, footer and dividers
		local name_line 18
		local output_line = `maxlen' + 2

		*Column position of first and last cell wall
		local first_col 4
		local last_col = `first_col' + `maxlen' + 22

		*Shorthand for most row beginnings and row ends
		local rowbeg "{col `first_col'}{c |}"
		local rowend "{col `last_col'}{c |}"

		*Shorthand for divider
		local divider "{col `first_col'}{c LT}{hline `name_line'}{c +}{hline `output_line'}{col `last_col'}{c RT}"

		*Display header
		noi di as text "{col `first_col'}{c TLC}{hline `name_line'}{c TT}{hline `output_line'}{c TRC}"
		noi di as text "`rowbeg' {bf:Name}             {c |} {bf:Value} `rowend'"
		noi di as text "`divider'"

			*Display all table rows
			noi di as text "`rowbeg' ID Var(s)        {c |} `idvars' `rowend'"
			noi di as text "`divider'"
			noi di as text "`rowbeg' Number of obs    {c |} `N' `rowend'"
			noi di as text "`divider'"
			noi di as text "`rowbeg' Number of vars   {c |} `numVars' `rowend'"
			noi di as text "`divider'"
			noi di as text "`rowbeg' Username         {c |} `user_table' `rowend'"
			noi di as text "`divider'"
			noi di as text "`rowbeg' Computer ID      {c |} `computer_table' `rowend'"
			noi di as text "`divider'"
			noi di as text "`rowbeg' Time and Date    {c |} `timesave' `rowend'"
			noi di as text "`divider'"
			noi di as text "`rowbeg' Version Settings {c |} `version_char' `rowend'"
		noi di as text "`divider'"
		noi di as text "`rowbeg' Data Signature   {c |} `datasig' `rowend'"

		*Display footer
		noi di as text "{col `first_col'}{c BLC}{hline `name_line'}{c BT}{hline `output_line'}{c BRC}"

/*********************************
	Save to char
*********************************/

			*Store the ID vars in char
			char _dta[iesave_idvar]         "`idvars'"
			char _dta[iesave_N]             "`N'"
			char _dta[iesave_numVars]       "`numVars'"
			char _dta[iesave_username] 	    "`user_char'"
			char _dta[iesave_computerid]    "`computer_char'"
			char _dta[iesave_timesave]      "`timesave'"
			char _dta[iesave_version]       "`version_char'"
			char _dta[iesave_datasignature] "`datasig'"
			char _dta[iesave_success]       "iesave (https://dimewiki.worldbank.org/iesave) ran successfully"


/*********************************
	returned values
*********************************/

		*Return the putputs to retirn locals
		return local idvars     "`idvars'"
		return local username   "`user'"
		return local computerid "`computer'"
		return local versions   "`version_char'"
		return local datasig    "`datasig'"
		return local N          "`N'"
		return local numvars    "`numVars'"

}
end


		capture program drop write_var_report
		program write_var_report

			syntax , file(string) datasig(string) idvars(string) n(string) [reportreplace keepvarorder]

		qui {

			*Convert reportreplace to replace in this context
			if ("`reportreplace'" == "") local replace ""
			else local replace "replace"

			*Set up tempfile locals
			tempname 	logname
			tempfile	logfile
			capture file close `texname'

			*get order or vars for report.
			*alpha is default as it keeps the order more stable
			if ("`keepvarorder'" == "") ds, alpha
			else ds
			local all_vars `r(varlist)'

			*Open the file and write headear
			file open  		`logname' using "`logfile'", text write replace
			file write  	`logname' "Name, Var label, Type, Val label, # unique non-miss values, # missing, Mean, Std dev" _n
			file close 		`logname'

			*Loop over all variables and write one row per variable
			foreach var of local all_vars {

				* Variable name
				local varrow `""`var'""'

				*Variable label
				local varlabel:  variable label  `var'
				local varrow `"`varrow',"`varlabel'""'

				*Variable type
				local vartype: type `var'
				local varrow `"`varrow',"`vartype'""'

				*Value label
				local vallabel:  value label `var'
				local varrow `"`varrow',"`vallabel'""'

				*Count number of unique values
				noi tab `var'
				local varrow `"`varrow',"`r(r)'""'

				*Count missing
				count if missing(`var')
				local varrow `"`varrow',"`r(N)'""'

				* Basic sum stats
				sum `var'
				local varrow `"`varrow',"`r(mean)'","`r(sd)'""'

				*Temp test output
				noi di `"{pstd}`varrow'{p_end}"'

				*Write variable row to file
				file open  `logname' using "`logfile'", text write append
				file write `logname' `"`varrow'"' _n
				file close `logname'
			}


			*Write the end of the report
			file open  `logname' using "`logfile'", text write append
			file write `logname' _n ///
					"***, ***, ***, ***, ***, ***, ***" _n ///
					"Number of observations:, `n'" _n ///
					"ID variable(s):, `idvars'" _n ///
					"Data signature:, `datasig'"
			file close `logname'

			*Copy temp file to file location
			copy "`logfile'"  "`file'", `replace'

		}

end
