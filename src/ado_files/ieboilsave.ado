*! version 6.3 5NOV2019 DIME Analytics dimeanalytics@worldbank.org

	capture program drop ieboilsave
	program ieboilsave , rclass

		syntax ,  IDvars(varlist) [DIOUTput VNOMISSing LISTUser]

		qui {

		preserve

			local origversion "`c(version)'"

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

			Missing values

		*********************************/

			if "`missingok'" == "" {

				local varsStandMiss

				ds, has(type numeric)

				foreach variable in `r(varlist)' {

					cap assert `variable' != .

					if _rc {

						local varsStandMiss `varsStandMiss' `variable'
					}
				}

				if `:list sizeof varsStandMiss' > 0 {

					noi di as error "{phang}There are `:list sizeof varsStandMiss' numeric variable(s) that contains the standard missing value (.) which is bad practice. A list of the variable(s) are stored in the local {cmd:r(standmissvars)}. Extended missing variables should be used. See {help ieboilsave} for more details.{p_end}"

					return local standmissvars 	"`varsStandMiss'"

					error 416
					exit
				}
			}

		restore

		/*********************************

			Output success messages

		*********************************/

		// ID

		//Store the name of idvar in data set char and in notes


		local idOut "The uniquely and fully identifying ID variable is `idvarname'. "


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
