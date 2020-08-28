*! version 6.3 5NOV2019 DIME Analytics dimeanalytics@worldbank.org

	capture program drop ieboilsave
	program ieboilsave , rclass

		syntax ,  IDvars(varlist) [DIOUTput VNOMissing(varlist) VNOSTANDMissing(varlist numeric) LISTUser]

		qui {

			*Save the three possible user settings before setting
			* is standardized for this command
			local version_char "c(stata_version):`c(stata_version)' c(version):`c(version)' c(userversion):`c(userversion)'"

			version 11.0


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

				noi di ""
				error 148
				exit
		}

		*Store the ID vars in char
		char  _dta[ie_idvar] "`idvars'"


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
		if ("`missVarError'" != "")
			noi di as error "{phang}One or more variables listed in option vnomissing() has missing values whixh is not allowed. Those variable(s) are [`missVarError']{p_end}"
			error 416
			exit
		}

VNOSTANDMissing

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
		if ("`missVarError'" != "")
			noi di as error "{phang}One or more variables listed in option vnostandmissing() has standard missing values whixh is not allowed. Those variable(s) are [`missVarError']{p_end}"
			error 416
			exit
		}


		/*********************************

			Output success messages

		/*********************************
			Prepare output
		*********************************/

		*Save username to char is nameuser was used
		if "`userinfo'" == "" {
			local user "Username withheld, see option userinfo in command ieboildsave"
			local computer "Computer ID withheld, see option userinfo in command ieboildsave"
		}
		else {
			local user "`c(username)'"
			local computer "`c(hostname)'"
		}

		*Save time and date
		local timesave "`c(current_time)' `c(current_date)'"

		*Create data signature
		datasignature
		local datasig `r(datasignature)'

		/*********************************
			Save to char
		*********************************/

		*Store the ID vars in char
		char _dta[iesave_idvar]         "`idvars'"
		char _dta[iesave_username] 	    "`user'"
		char _dta[iesave_computerid]    "`computer'"
		char _dta[iesave_timesave]      "`timesave'"
		char _dta[iesave_version]       "`version_char'"
		char _dta[iesave_datasignature] "`datasig'"
		char _dta[iesave_success]      "iesave (wikilink) ran successfully"

		// Version
		char  _dta[ie_version] "`origversion'"

		local versOut "This data set was created in Stata version `origversion'"

		// Date
		char  _dta[ie_date] "`c(current_date)'"

		local dateOut " on `c(current_date)'."

		// Name

		local nameOut ""
		local hostOut ""

		if "`tagnoname'" == "" {

			char  _dta[ie_name] "`c(username)'"

			if "`tagnohost'" == "" {

				char  _dta[ie_host] "`c(hostname)'"
				local hostOut ", by user `c(username)' using computer `c(hostname)',"
			}
			else {

				local nameOut ", by user `c(username)',"

			}
		}
	// Missing vars

		if "`missingok'" == "" {

			local missOut "There are no regular missing values in this data set"
		}
		else {

			local missOut "This data set was not tested for missing values"
		}

		char _dta[ie_boilsave] "ieboilsave ran successfully. `idOut'`versOut'`nameOut'`hostOut'`dateOut' `missOut'"

		if "`dioutput'" != "" {

			local  outputSum :  char _dta[ie_boilsave]
			noi di ""
			noi di  "{phang}`outputSum'{p_end}"

		}

	}
	end
