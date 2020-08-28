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
			noi di as error "{phang}One or more variables listed in option vnomissing() has missing values whixh is not allowed. Those variable(s) are [`missVarError']{p_end}"
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
			Write variable report
		*********************************/


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

		/*********************************
			Display in table
		*********************************/
		noi di ""

		* List the locals with values in the table
		local output_locals "idvars user computer timesave version_char datasig"

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
		noi di as text "`rowbeg' Username         {c |} `user' `rowend'"
		noi di as text "`divider'"
		noi di as text "`rowbeg' Computer ID      {c |} `computer' `rowend'"
		noi di as text "`divider'"
		noi di as text "`rowbeg' Time and Date    {c |} `timesave' `rowend'"
		noi di as text "`divider'"
		noi di as text "`rowbeg' Version Settings {c |} `version_char' `rowend'"
		noi di as text "`divider'"
		noi di as text "`rowbeg' Data Signature   {c |} `datasig' `rowend'"

		*Display footer
		noi di as text "{col `first_col'}{c BLC}{hline `name_line'}{c BT}{hline `output_line'}{c BRC}"

	}
	end
