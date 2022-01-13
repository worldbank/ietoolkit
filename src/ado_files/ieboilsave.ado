*! version 6.4 11JAN2022 DIME Analytics dimeanalytics@worldbank.org

	capture program drop ieboilsave
	program ieboilsave , rclass

		syntax ,  IDVARname(varlist) [DIOUTput missingok tagnoname tagnohost]

		qui {

		preserve

			local origversion "`c(version)'"

			version 11.0

			//Checking that only one id variable is listed
			if `:list sizeof idvarname' > 1 {

				noi di as error "{phang}Multiple ID variables in idvarname(`idvarname') are not allowed. While it is not always incorrect, it is bad practice, see {help ieboilsave##IDnotes:Notes on ID variables} for more details.{p_end}"
				noi di ""
				error 103
				exit
			}


		/*********************************

			ID variables

		*********************************/

			capture isid `idvarname'

			if _rc {


				//Test missing
				capture assert !missing(`idvarname')
				if _rc {

					count if missing(`idvarname')

					noi di as error "{phang}The ID variable `idvarname' is missing in `r(N)' observation(s). The ID variable needs to be fully identifying, meaning that no values can be a missing values (., .a, .b ... .z) or the empty string{p_end}"
					noi di ""
				}

				//Test duplicates
				tempvar iedup

				duplicates tag `idvarname', gen(`iedup')

				count if `iedup' != 0

				if r(N) > 0 {

					sort `idvarname'

					noi di as error "{phang}To be uniquely identifying the ID variable should not have any duplicates. The ID variable `idvarname' has duplicate observations in the following values:{p_end}"
					noi list `idvarname' if `iedup' != 0
				}
				noi di ""
				error 148
				exit
			}



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
		char  _dta[ie_idvar] "`idvarname'"

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
