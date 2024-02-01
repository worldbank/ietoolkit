*! version 7.3 01FEB2024 DIME Analytics dimeanalytics@worldbank.org

	capture program drop 	iedropone
			program define 	iedropone ,

	qui {

		syntax [if] ,  [Numobs(numlist int min=1 max=1 >0) mvar(varname) mval(string) zerook]


		version 12

		/***********************************

			Set constants

		***********************************/

		*Set a constant for the multi option being used
												local MULTI_USED 0
		if ("`mvar'" != "" & "`mval'" != "") 	local MULTI_USED 1

		*Set a constant for the zerook option being used
												local ZEROOK_USED 0
		if ("`zerook'" != "") 					local ZEROOK_USED 1

		*Set a constant for if an IF-condition used
												local IF_USED 0
		if (`"`if'"' != "") 					local IF_USED 1

		/***********************************

			Test input

		***********************************/

		*Test that mvar() and mval() was used in combination
		if ("`mvar'" != "" & "`mval'" == "") {

			di as error "{pstd}The option mval() is required when using the option mvar()"
			error 197
		}
		if ("`mvar'" == "" & "`mval'" != "") {

			di as error "{pstd}The option mvar() is required when using the option mval()"
			error 197
		}

		*Test that either an if condition was specified or of the multi values option was used
		if `IF_USED' == 0 & `MULTI_USED' == 0 {

			di as error "{pstd}An {it:if} condition is required when mvar() and mval() is not used."
			error 197
		}


		/***********************************

			Set locals

		***********************************/

		*If number of obs to drop is not set, then use the default which is 1
		if "`numobs'" == "" {

			local numobs = 1
		}

		*Test if the var in mvar() is string or not
		if `MULTI_USED' == 1 {

			cap confirm string variable `mvar'

			if _rc == 0	local MULTI_STRING 1
			if _rc != 0	local MULTI_STRING 0
		}

		/***********************************

			Test the number of obs matching

		***********************************/

		*Subfunction options
		local subfunc_opts "nobs(`numobs') zero(`ZEROOK_USED')"

		if `MULTI_USED' == 0 {

			** Use the functon iedropone_test_match to
			*  test if the number of observations to drop
			*  is correct
			iedropone_test_match `if' , `subfunc_opts'
			local num_obs_dropped `r(numtodrop)'

		}
		else {

			**Create a counter that will noitify
			* the user how many observations were
			* dropped
			local num_obs_dropped = 0

			*Loop over all values in mval()
			foreach mvalue of local mval {

				*Run the sub-function that test number of observation to be dropped is OK

				*Is mvar() is numeric
				if `MULTI_STRING' == 0 {


					** Use the functon iedropone_test_match to
					*  test if the number of observations to drop
					*  is correct
					if `IF_USED' == 1 	iedropone_test_match `if' & `mvar' == `mvalue'   , `subfunc_opts'
					if `IF_USED' == 0	iedropone_test_match  if 	`mvar' == `mvalue'   , `subfunc_opts'
				}
				*Is mvar() is numeric
				else {

					** Use the functon iedropone_test_match to
					*  test if the number of observations to drop
					*  is correct
					if `IF_USED' == 1 	iedropone_test_match `if' & `mvar' == "`mvalue'" , `subfunc_opts'
					if `IF_USED' == 0	iedropone_test_match  if 	`mvar' == "`mvalue'" , `subfunc_opts'

				}

				*Add to the counter how many observations will be dropped
				local num_obs_dropped = `num_obs_dropped' + `r(numtodrop)'
			}
		}

		/***********************************

			Drop observation(s)

		***********************************/


		*Test if multivars are used
		if `MULTI_USED' == 0 {

			*The observations to be dropped
			drop `if'

		}
		else {

			*Loop over all values in mval and drop observations
			foreach mvalue of local mval {

				if `MULTI_STRING' == 0 {
					if `IF_USED' == 1 	drop `if' & `mvar' == `mvalue'
					if `IF_USED' == 0	drop  if 	`mvar' == `mvalue'
				}
				else {
					if `IF_USED' == 1 	drop `if' & `mvar' == "`mvalue'"
					if `IF_USED' == 0	drop  if 	`mvar' == "`mvalue'"
				}
			}
		}

		*Output to user how many observations were dropped
		if `num_obs_dropped' == 1 noi di "`num_obs_dropped' observation was dropped"
		if `num_obs_dropped' != 1 noi di "`num_obs_dropped' observations were dropped"

	}

	end

	**Sub function that checks that the number of observations
	* to drop is correct and it returns the number of observations
	* that will be dropped.

	capture program drop 	iedropone_test_match
			program define 	iedropone_test_match , rclass


		syntax [if] , nobs(int) zero(int)


		**Count how many obs fits the drop condition (this
		* function is called once for each value in mval)
		count `if'
		local count_match `r(N)'

		*Test if no match and zerook not used
		if `count_match' == 0 & `zero' == 0 {

			*Return error message
			noi di as error `"{pstd}No observation matches the drop condition " `if'". Consider using option zerook to surpress this error. No observations dropped."'
			error 2000
		}
		*Test if no match but zerook used
		else if `count_match' == 0 & `zero' == 1 {

			*No observation dropped but that is allowed byt zero_used. Return 0.
			return scalar numtodrop	= `count_match'

		}
		*Test if the number of match is less than it is supposed to be
		else if `count_match' < `nobs' {

			*Return error message
			noi di as error  `"{pstd}There are less than exactly `nobs' observations that match the drop condition " `if'". No observations dropped."'
			error 910

		}
		*Test if the number of match is more than it is supposed to be
		else if `count_match' > `nobs' {

			*Return error message
			if `nobs' == 1  noi di as error  `"{pstd}There are more than exactly `nobs' observation that match the drop condition " `if'". No observations dropped."'
			if `nobs' >  1  noi di as error  `"{pstd}There are more than exactly `nobs' observations that match the drop condition " `if'". No observations dropped."'
			error 912

		}
		*Test if the number of match exactly what it is suppsed to be
		else if `count_match' == `nobs' {

			*Return the number of obs that will be dropped
			return scalar numtodrop	= `count_match'

		}
		*The options above should be mutually exclusive, so this should never happen.
		else {

			*Return error message
			noi di as error "{pstd}The command is never supposed to reach this point, please notify the author of the command at kbjarkefur@worldbank.org"
			error 197
		}

	end
