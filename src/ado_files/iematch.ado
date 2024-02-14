*! version 7.3 01FEB2024 DIME Analytics dimeanalytics@worldbank.org

	cap program drop 	iematch
	    program define	iematch

		syntax  [if] [in]  , 					///
			GRPdummy(varname) 					///
			MATCHvar(varname) 					///
			[									///
			IDvar(varname)						///
			m1									///
			maxdiff(numlist >0 max = 1 min = 1) ///
			maxmatch(numlist >0 integer max = 1 min = 1) ///
			seedok						 		///
			MATCHIDname(string)					///
			MATCHDIffname(string)				///
			MATCHREsultname(string)				///
			MATCHCOuntname(string)				///
			replace								///
			]

		*****

	qui {

		* Set version
		version 12

		********************************
		*
		*	Gen temp sort and merge var
		*
		********************************

		tempvar originalSort ifinvar

		**Generate a variable that is used
		* to restore original sort.
		gen `originalSort' = _n
		label variable `originalSort' "originalSort"

		preserve

			* String used to store why and how
			*  many observations are excluded.
			local obsexcludstring ""

			*Dummy local that is 1 if replace is used
			if "`replace'" == "" local REPLACE_USED 0
			if "`replace'" != "" local REPLACE_USED 1

			*Deal with if and in and display info.
			if "`if'`in'" != "" {

				* Gen dummy that is 1 when if/in is true. Then
				* count when this dummy is not 1. Ther is no way
				* to negate `if'`in'
				marksample touse
				count if `touse' != 1
				if `r(N)' > 0 {

					*This is not an error just outputting the number
					local obsexcludstring "`obsexcludstring'`r(N)' observation(s) were excluded in {inp:if}/{inp:in}: (`if'`in').{break}"

				}

				*Drop variables excluded by `if'`in'
				keep if `touse'
			}

		********************************
		*
		*	Checking ID var (and create if needed)
		*
		********************************

			*Checking set-up for the ID var used for _matchID
			if "`idvar'" == "" {

				*Copy this name
				local idvar _ID

				*Make sure that the default name _ID is not already used
				cap confirm variable `idvar'
				if _rc == 0 {

					*Test if option replace is used
					if `REPLACE_USED' == 1 {
						*Replace option is used, drop the variable with the name specified
						drop `idvar'
					}
					else {
						*Replace is not used, throw an error.
						di as error "{pstd}A variable with name `idvar' is already defined. Either drop this variable manually, use the replace option or specify a variable using idvar() that fully and uniquely identifies the data set.{p_end}"
						error 110
					}
				}

				*Generate the ID var from row number
				gen `idvar' = _n
			}

			*Make sure that idvar is uniquely and fully identifying
			cap isid `idvar'
			if _rc != 0 {

				di as error "{pstd}Variable `idvar' specified in idvar() does not fully and uniquely identify the observations in the data set. `idvar' either has duplicates or missing values which is not allowed. Make `idvar' uniquly and fully idnetifying or exclude the varaibleas using {inp:if} or {inp:in}.{p_end}"
				error 450
			}

			*local indicating assume ID is string
			local IDtypeNumeric 0

			*Change local to 1 if ID actally string
			cap confirm numeric variable `idvar'
			if _rc == 0 local IDtypeNumeric 1


		********************************
		*
		*	Checking duplicates in variable names in options
		*
		********************************

			*Create a local of all varnames used in any option
			local allnewvars `idvar' `matchidname' `matchdiffname' `matchresultname' `matchcountname'

			*Check if there are any duplicates in the local of all varnames in options
			local dupnewvars : list dups allnewvars
			local dupnewvars : list uniq dupnewvars

			*Throw error if there were any duplicates
			if "`dupnewvars'" != "" {

				noi di as error "{pstd}The variable name(s) [`dupnewvars'] was used twice or more in the options that manually name the outcome varaibles. Go back and make sure that no name is used more than once.{p_end}"
				error 198
			}

		********************************
		*
		*	Test the names used for output vars
		*
		********************************

			iematchMatchVarCheck 	_matchResult 	`REPLACE_USED' "`matchresultname'"
			local matchResultName 	"`r(validVarName)'"

			iematchMatchVarCheck 	_matchID 		`REPLACE_USED' "`matchidname'"
			local matchIDname 		"`r(validVarName)'"

			iematchMatchVarCheck 	_matchDiff 		`REPLACE_USED' "`matchdiffname'"
			local matchDiffName 	"`r(validVarName)'"

			if "`m1'" != "" {
			   iematchMatchVarCheck _matchCount 	`REPLACE_USED' "`matchcountname'"
			   local matchCountName "`r(validVarName)'"
			}

			*List of output vars used to delete vars that should be replaced by new output vars, used after restore
			local outputNames `matchResultName' `matchIDname' `matchDiffName' `matchCountName'

			*Option matchcountname() is not allowed if it is not a many-one match
			if "`matchcountname'" != "" & "`m1'" == "" {
				di as error "{pstd}Option {inp:matchcountname()} is only allowed in combination with option {inp:m1}.{p_end}"
				error 198
			}

		********************************
		*
		*	Create and label output vars
		*
		********************************

			* MATCH RESULT VAR
			label define 	 matchLabel 0 "Not Matched" 1 "Matched" .i "Obs excluded due to if/in" 			///
										.g "Missing value in `grpdummy'" .m "Missing value in `matchvar'" 	///
										.d "No match within maxdiff" .t "No more eligible target obs", replace

			gen 			`matchResultName' = .
			label variable	`matchResultName' "Matched obs = 1, not mathched = 0, all other different missing values"
			label value 	`matchResultName' matchLabel

			* MATCH ID VAR
			if `IDtypeNumeric' == 1 {
				gen `:type `idvar'' `matchIDname' = .	 //Main ID var is numeric - type is important for long IDs
				format `matchIDname' `:format `idvar'' //Make sure that long IDs are not converted to scientific format
			}
			else {
				gen `matchIDname' = "" //Main ID var is string
			}

			if "`m1'" != "" label variable	`matchIDname' "The ID of the target var in each matched group"	//If many to one
			if "`m1'" == "" label variable	`matchIDname' "The ID of the target var in each matched pair"	//If one to one

			* MATCH DIFF VAR
			gen 	`matchDiffName' = .
			if "`m1'" != "" label variable	`matchDiffName' "The difference in matchvar() between base obs and the target obs it matched with" 	//If many to one
			if "`m1'" == "" label variable	`matchDiffName' "The difference in matchvar() between base and target obs in each pair" 			//If one to one

			*Match count, only many-one
			if "`m1'" != "" {
				gen 			`matchCountName' = .
				label variable	`matchCountName' "The number of base obs this target obs matched with"
			}

		********************************
		*
		*	Keep only relevant vars
		*
		********************************

			*Keep only input vars and output vars
			keep  `grpdummy' `idvar' `matchvar'	`originalSort' `matchResultName' `matchIDname' `matchDiffName' `matchCountName'

		********************************
		*
		*	Checking group dummy
		*
		********************************

			*Test that the group dummy is 1, 0 or missing
			cap assert inlist(`grpdummy', 1, 0, .) | `grpdummy' > .
			if _rc != 0 {

				di as error "{pstd}The variable in grpdummy(`grpdummy') is not a dummy variable. The variable is only allowed to have the values 1, 0 or missing. Observations with missing variables in the grpdummy are ignored by this command.{p_end}"
				error _rc
			}

			**********
			**Exclude obs with missing value in groupdummy

			*Count number of obs to be dropped and and output that number if more than zero
			count if missing(`grpdummy')
			if `r(N)' > 0 {

				*Prepare the local to be outputted with info on observations excluded
				local obsexcludstring  "`obsexcludstring'`r(N)' observation(s) were excluded due to missing value in  grpdummy(`grpdummy').{break}"
			}

			*Drop obs with missing value in groupvar
			drop if missing(`grpdummy')


		********************************
		*
		*	Checking match continous var
		*
		********************************

			*Test that the continous is numeric
			cap confirm numeric variable `matchvar'
			if _rc != 0 {

				noi di as error "{pstd}The variable to match on specified in matchvar(`matchvar') is not a numeric variable.{p_end}"
				error 109
			}

			**All variables with value 1 or 0 in the group dummy and
			* not excluded by if/in must have a value in matchvar
			count if missing(`matchvar')
			if `r(N)' > 0 {

				*Prepare the local to be outputted with info on observations excluded
				local obsexcludstring  "`obsexcludstring'`r(N)' observation(s) were excluded due to missing value in matchvar(`matchvar').{break}"
			}

			*Drop obs with missing values in match var
			drop if missing(`matchvar')


		********************************
		*
		*	Checking match var and group dummy are unique
		*
		********************************

			if "`seedok'" == "" {

				**test that there are no duplicates in match
				* var within each type of observation
				cap isid `matchvar' `grpdummy'

				if _rc != 0 {

					*Output the error message
					noi di as error "{pstd}There are base observations or target observations {...}"
					noi di as error "with duplicate values in matchvar(`matchvar'). To guarantee {...}"
					noi di as error "a replicable match you must {help seed:set a seed}. To supress {...}"
					noi di as error "this error message after you have set a the seed, or if a {...}"
					noi di as error "replicable match is not important to you, use option {inp:seedok}{p_end}"
					error 198

				}
			}


		********************************
		*
		*	Checking that there are more target
		*	obs than base obs in a 1-to-1 match
		*
		********************************

			if "`m1'" == "" {

				*Count number of base vars
				count if `grpdummy' == 1
				local numBaseObs `r(N)'

				*Count number of target vars
				count if `grpdummy' == 0
				local numTrgtObs `r(N)'

				*Test that there are more target
				cap assert `numTrgtObs' >= `numBaseObs'

				if _rc != 0 {

					noi di as error "{pstd}There are more base observations than target observations. This is not allowed in a one-to-one match. See option {inp:m1} for an alternative matching where it is allowed to have more base observations than target ovbservations.{p_end}"
					error _rc
				}
			}

		********************************
		*
		*	Checking that matchCount is only used with
		*	many-to-one matching
		*
		********************************

		if "`m1'" == "" & "`maxmatch'" != "" {

			noi di as error "{pstd}The option {inp:maxmatch()} can only be used when option {inp:m1} is used, as restricting to a maximum number of matches is only applicable in a many-to-one match.{p_end}"
			error 198
		}

		********************************
		*
		*	Output exclude string
		*
		********************************

			*The exclude string is created above but only displayed
			*after all testing of input is done.

			if "`obsexcludstring'" != "" {

				noi di ""
				noi di "{hline}"
				noi di ""
				noi di "{pstd}{ul:Observations are excluded from the matching for the following reasons:}{break}"
				noi di "`obsexcludstring'{p_end}"

			}

	********************************
	*	Start matching
	********************************


		********************************
		*
		*	Creating tempvar used in matching
		*
		********************************

		*Initiate the temporary variables used by this command
		tempvar prefID prefDiff matched matchcount maxmatchprefid

		gen `prefDiff' 		= .
		gen byte `matched' 	= 0

		*Allow the ID var used to be string
		if `IDtypeNumeric' == 1 {
			gen  `:type `idvar'' `prefID' = .
			gen  `maxmatchprefid'       	= .
		}
		else {
			gen  `prefID' 			= ""
			gen  `maxmatchprefid' 	= ""
		}

		*Gen a variable that indicates for target vars if the max match is reached
		gen `matchcount' 	= .

		*Label tempvars - only needed for troubleshooting
		label variable `prefDiff' "prefDiff"
		label variable `matched' "matched"
		label variable `prefID' "prefID"
		label variable `maxmatchprefid' "maxmatchprefid"
		label variable `matchcount' "matchcount"


		** Generate the inverse of the matchvar to sort descending (gsort is too slow),
		*  a random var to seperate two values with the same match var, and the inverse
		*  of the random var for when sorting descending.
		tempvar rand invsort invrand

		sort `matchvar'
		gen  `invsort' = -1 * `matchvar'

		gen    `rand' = uniform()
		gen `invrand' = -1 * `rand'

		*Label tempvars - only needed for troubleshooting
		label variable `rand' "rand"
		label variable `invsort' "invsort"
		label variable `invrand' "invrand"

		***********
		*Tempvars for matching

		*Diffvars, they are always numeric
		tempvar					 diffup   diffdo   valUp_0   valDo_0   valUp_1   valDo_1
		local 	 updownTempVars `diffup' `diffdo' `valUp_0' `valDo_0' `valUp_1' `valDo_1'

		foreach tempVar of local updownTempVars {

			gen `tempVar' = .
		}

		*Label tempvars - only needed for troubleshooting
		label variable `diffup' "diffup"
		label variable `diffdo' "diffdo"
		label variable `valUp_0' "valUp_0"
		label variable `valDo_0' "valDo_0"
		label variable `valUp_1' "valUp_1"
		label variable `valDo_1' "valDo_1"

		*ID vars, allowed to be both numeric and string
		tempvar					  	IDup   IDdo   IDup_0   IDdo_0   IDup_1   IDdo_1
		local 	 updownIDTempVars  `IDup' `IDdo' `IDup_0' `IDdo_0' `IDup_1' `IDdo_1'

		foreach tempVar of local updownIDTempVars {

			*Allow the ID var used to be string
			if `IDtypeNumeric' == 1 {
				gen `:type `idvar'' `tempVar' = .
			}
			else {
				gen  `tempVar' = ""
			}
		}

		*Label tempvars - only needed for troubleshooting
		label variable `IDup' "IDup"
		label variable `IDdo' "IDdo"
		label variable `IDup_0' "IDup_0"
		label variable `IDdo_0' "IDdo_0"
		label variable `IDup_1' "IDup_1"
		label variable `IDdo_1' "IDdo_1"


		***************************
		*
		*	One to one match
		*
		***************************

		if "`m1'" == "" {

			*Start outputting the countdown
			noi di ""
			noi di "{hline}{break}"
			noi di "{pstd}{ul:Matching one-to-one. Base observations left to match:}{p_end}"

			*Create local to display "obs left to match" and to use in while loop
			count if `grpdummy' == 1 & `matched' == 0
			local left2Match = `r(N)'
			noi di "{pstd}`left2Match' " _c

			*Match until no more observations to match.
			while (`left2Match' > 0) {

				**For all observations still to be matched, assign the preferred
				* match among the other unmatched observations
				qui updatePrefDiffPreffID `prefID' `prefDiff' `matchvar' `invsort' `idvar' `grpdummy' `matched' `rand' `invrand' `updownTempVars' `updownIDTempVars'

				*Restrict matches to within maxdiff() if that option is used.
				if "`maxdiff'" != "" {

					*Omit base observation from matching if diff is to big
					replace `matched' 			= 1		if `prefDiff' > `maxdiff' & `grpdummy' == 1

					*Indicate in result var that this obs did not have valid match within maxdiff()
					replace `matchResultName' 	= .d 	if `prefDiff' > `maxdiff' & `grpdummy' == 1

					*Removed preferred match
					if `IDtypeNumeric' == 1 {
						*IDvar is numeric
						replace `prefID'		= .		if `prefDiff' > `maxdiff'
					}
					else {
						*IDvar is string
						replace `prefID'		= ""	if `prefDiff' > `maxdiff'
					}
				}

				*If two observations mutually prefer each other, then indicate both of them as matched.
				replace `matched' = 1 if `matched' == 0 & `prefID' == `idvar'[_n-1] & `prefID'[_n-1] == `idvar'
				replace `matched' = 1 if `matched' == 0 & `prefID' == `idvar'[_n+1] & `prefID'[_n+1] == `idvar'

				*Update local to display "obs left to match" and to use in while loop
				count if `grpdummy' == 1 & `matched' == 0
				local left2Match = `r(N)'
				noi di "`left2Match' " _c

			}

			*End formatting for the "base obs left to match"
			noi di "{p_end}" _c
		}
		***************************
		*
		*	Many to one match with no restriction on # matches
		*
		***************************
		else if "`maxmatch'" == ""  {

			*Start outputting the countdown
			noi di ""
			noi di "{hline}{break}"
			noi di "{pstd}{ul:Matching many-to-one.}{p_end}"

			**For all observations to be matched, assign the preferred
			* match among the other unmatched observations
			updatePrefDiffPreffID `prefID' `prefDiff' `matchvar' `invsort' `idvar' `grpdummy' `matched' `rand' `invrand' `updownTempVars' `updownIDTempVars'

			*Restrict matches to within maxdiff() if that option is used.
			if "`maxdiff'" != "" {

				*Indicate in result var that this obs did not have valid match within maxdiff()
				replace `matchResultName' 	= .d 	if `prefDiff' > `maxdiff' & `grpdummy' == 1

				*Removed preferred match
				if `IDtypeNumeric' == 1 {
					*IDvar is numeric
					replace `prefID'		= .		if `prefDiff' > `maxdiff'
				}
				else {
					*IDvar is string
					replace `prefID'		= ""	if `prefDiff' > `maxdiff'
				}
			}

			*Assign it's own ID as pref ID for all target vars
			replace `prefID'			=  `idvar' if `grpdummy' == 0

			* Replace the _matchCount var with number of base observations in each
			* match group. Each group is all base observation plus the target
			* observation, therefore (_N - 1)
			bys 	`prefID' 			:   replace `matchCountName' = _N - 1 if !missing(`prefID')

			**Replace prefID to missing for target obs that had no base
			* obs matched to it. T
			if `IDtypeNumeric' == 1 {
				*IDvar is numeric
				replace `prefID'		= .		if `matchCountName' == 0
			}
			else {
				*IDvar is string
				replace `prefID'		= ""	if `matchCountName' == 0
			}

			*Only target obs with base obs prefering it are matched
			replace	 `matched' 			= 1		if `matchCountName' != 0

			*Remove values for target obs that were not matched
			replace  `matchCountName'	= . 	if `matchCountName' == 0

		}
		***************************
		*
		*	Many to one match with restriction on # matches
		*
		***************************
		else {

			noi di "max count"
			*pause

			*Start outputting the countdown
			noi di ""
			noi di "{hline}{break}"
			noi di "{pstd}{ul:Matching many-to-one. Base observations left to match:}{p_end}"

			*Create local to display "obs left to match" and to use in while loop
			count if `grpdummy' == 1 & `matched' == 0
			local left2Match = `r(N)'
			noi di "{pstd}`left2Match' " _c

			*Match until no more observations to match.
			while (`left2Match' > 0) {

				**For all observations to be matched, assign the preferred
				* match among the other unmatched observations
				updatePrefDiffPreffID `prefID' `prefDiff' `matchvar' `invsort' `idvar' `grpdummy' `matched' `rand' `invrand' `updownTempVars' `updownIDTempVars'

				*Restrict matches to within maxdiff() if that option is used.
				if "`maxdiff'" != "" {

					*Omit base observation from matching if diff is to big
					replace `matched' 			= 1		if `prefDiff' > `maxdiff' & `grpdummy' == 1

					*Indicate in result var that this obs did not have valid match within maxdiff()
					replace `matchResultName' 	= .d 	if `prefDiff' > `maxdiff' & `grpdummy' == 1

					*Removed preferred match
					if `IDtypeNumeric' == 1 {
						*IDvar is numeric
						replace `prefID'		= .		if `prefDiff' > `maxdiff'
					}
					else {
						*IDvar is string
						replace `prefID'		= ""	if `prefDiff' > `maxdiff'
					}
				}

				*If a base observation is mutually preferred by a target observation
				replace `matched' = 1 if `grpdummy' == 1 & `matched' == 0 & `prefID' == `idvar'[_n-1] & `prefID'[_n-1] == `idvar'
				replace `matched' = 1 if `grpdummy' == 1 & `matched' == 0 & `prefID' == `idvar'[_n+1] & `prefID'[_n+1] == `idvar'

				*Set maxmatchprefid to the matched id for matched base obs, and its own id for target obs
				replace `maxmatchprefid' = `prefID' if `grpdummy' == 1 & `matched' == 1
				replace `maxmatchprefid' = `idvar'  if `grpdummy' == 0

				*By the maxmatchprefid, count how many base observations (all obs
				* minus target) that are matched to this target obs
				bys 	`maxmatchprefid' : replace `matchcount' = _N - 1 if  `matchResultName' 	!= .d

				*Set the target obs as matched if the max match count is reached (matching one at the time so no risk of overstepping)
				replace `matched' 	= 1  if `grpdummy' == 0 & `matchcount' == (`maxmatch') & `matchResultName' != .d

				*Update local to display "obs left to match" and to use in while loop
				count if `grpdummy' == 1 & `matched' == 0
				local left2Match = `r(N)'
				noi di "`left2Match' " _c

				*Test that there are still target obs left to match against
				count if `grpdummy' == 0 & `matched' == 0
				if `r(N)' == 0 {

					*set left to match to -1 to exit while loop and to output message after loop
					local left2Match = -1

					*Set all unmatched base obs to .t (no more eligible target obs)
					replace `matchResultName' 	= .t 	if `grpdummy' == 1 & `matched' == 0
				}

			}

			*End the outputted count down on how many observations left to match
			noi di "{p_end}" _c

			*If ran out of target out put that
			if `left2Match' == -1 {

				noi di ""
				noi di ""
				noi di "{pstd}No more target obs to match{p_end}"
			}

			*Set all target obs with at least 1 matched base obs as matched
			replace `matched' 	= 1 if `grpdummy' == 0 & `matchcount' >= 1 & `matchResultName' != .d

			*Remove match diff for target obs (does not make sense with mutliple obs)
			replace `prefDiff' 	= . if `grpdummy' == 0

			*Set the match count output var to the number of matched base obs
			replace `matchCountName' = `matchcount' if  `matched' 	== 1 & `matchResultName' != .d

		}

		*Update all return vars
		replace `matchDiffName' 	= `prefDiff'	if `matched' == 1
		replace `matchIDname' 		= `idvar' 		if `matched' == 1 & `grpdummy' == 0
		replace `matchIDname' 		= `prefID' 		if `matched' == 1 & `grpdummy' == 1

		*Remove the best match value in obs that did not have a match within maxdiff()
		replace `matchDiffName'  = . 				if `matchResultName' == .d

		*Matched observations are give value 1 in result var
		replace `matchResultName' = 1 				if `matched' == 1 & `matchResultName' != .d

		*Target obs not used
		replace `matchResultName' = 0 if `matched' == 0 & `grpdummy' == 0

		*only keep output vars
		keep `matchIDname' `matchDiffName' `originalSort' `matchResultName' `matchCountName'

		*Merge the results back to the original data set
		tempfile mergefile
		save 	`mergefile'

	restore

	***************************
	*
	*	Merge match results to
	*	original data and assign
	*	remaining missing values
	*	to the result var
	*
	***************************

	**Drop any vars with same name as the output vars. The command has already
	* tested that replace was used if variable already exists. If variable does
	* not exist nothing is done
	foreach outputVar of local outputNames {

		*Drop vars with same name as output vars.
		cap drop `outputVar'
	}

	*Merge the results with the original data
	tempvar mergevar
	merge 1:1  `originalSort' using `mergefile', gen(`mergevar')

	*remaining missing values are listed in ascending order of importance.
	*Meaning that if a variable is both .m and .i then it will be .i as it
	*is assigned afterwards below.

	*Missing matching var
	replace `matchResultName' = .m if missing(`matchvar')

	*Missing dummy var
	replace `matchResultName' = .g if missing(`grpdummy')

	*Excluded in if/in
	if "`if'`in'" != "" {

		tempvar  ifinvar
		gen 	`ifinvar' = 1 `if'`in'
		replace `matchResultName' = .i if `ifinvar' != 1
	}

	*compress the variables generated
	compress  `matchIDname' `matchDiffName' `matchResultName' `matchCountName'

	*Output result table
	noi outputTable `matchResultName' `grpdummy'

	*Restore the original sort
	sort `originalSort'

}

end

	*Check manually entered names for the return vars.
	cap program drop 	iematchMatchVarCheck
		program define 	iematchMatchVarCheck  , rclass

		args defaultName replace_used userName

		if "`defaultName'" == "_matchID" 		local optionName matchidname
		if "`defaultName'" == "_matchDiff" 		local optionName matchdiffname
		if "`defaultName'" == "_matchResult" 	local optionName matchresult
		if "`defaultName'" == "_matchCount" 	local optionName matchcount

		*All the default names
		local dfltNms _noMatchReason _matchDiff _matchResult _matchCount

		*The other two default names
		local othDfltNms : list dfltNms - defaultName

		*Creating two locals with the deafult name in each local
		local Oth1 : word 1 of `othDfltNms'
		local Oth2 : word 2 of `othDfltNms'
		local Oth3 : word 3 of `othDfltNms'

		*Testing that the option name is not the same as the other variable's default name.
		if ("`userName'" == "`Oth1'" | "`userName'" == "`Oth2'" | "`userName'" == "`Oth3'" | "`userName'" == "_ID")  {

			noi di as error "{pstd}The new name specified in `optionName'(`userName') is not allowed to be _ID, `Oth1', `Oth2', or `Oth3'{p_end}"
			error 198
		}

		*Test if name is set manually
		if "`userName'" != "" {
			*Use the manually set name
			local validMatchVarname `userName'
		}
		else {
			*No manually set name, use deafult name
			local validMatchVarname `defaultName'
		}

		*Make sure that the manually entered name is not already used
		cap confirm variable `validMatchVarname'
		if _rc == 0 {

			if `replace_used' == 1 {
				//Replace is used, drop the old var
				drop `validMatchVarname'
			}
			else {

				*Replace is not used. Prepare an error message and throw error

				if "`userName'" != "" {
					*Error message for user specified name s
					local nameErrorString "The variable name specified in `optionName'(`userName')"
				}
				else {
					*Error message for user specified name s
					local nameErrorString "A variable with name `validMatchVarname'"
				}

				*Throw error
				noi di as error "{pstd}`nameErrorString' is already defined in the data set. Either drop this variable, use the replace option or specify a another variable name using `optionName'()."
				error 110

			}
		}

		*Testing that the new name is valid by creating a variable that is dropped immediately afterwards
		cap gen `validMatchVarname' = .

		if _rc != 0 {

			noi di as error "{pstd}The variable name specified in `optionName'(`userName') is not a valid variable name."
			error _rc
		}
		drop `validMatchVarname'

		return local validVarName 	"`validMatchVarname'"

	end



	** This function is called to assign the preferred match for all unmatched
	*  observations to any other unmatched observation. Returns a variable pref that is the
	cap program drop 	updatePrefDiffPreffID
		program define 	updatePrefDiffPreffID

		args prefID prefDiff matchvar invsort idvar grpvar matched rand invrand diffup diffdo valUp_0 valDo_0 valUp_1 valDo_1 IDup IDdo IDup_0 IDdo_0 IDup_1 IDdo_1

		*****************
		*Update possible matches with higher rank value
		sort `matched' `matchvar' `rand'

		updateBestValID 0 `matchvar' `idvar' `grpvar' `matched' `valUp_0' `IDup_0'
		updateBestValID 1 `matchvar' `idvar' `grpvar' `matched' `valUp_1' `IDup_1'

		*****************
		*Update possible matches with lower rank value
		sort `matched' `invsort' `invrand'

		updateBestValID 0 `matchvar' `idvar' `grpvar' `matched' `valDo_0' `IDdo_0'
		updateBestValID 1 `matchvar' `idvar' `grpvar' `matched' `valDo_1' `IDdo_1'

		*****************
		*Create one varaible common for both groups with diff upwards
		replace `diffup' 	= abs(`matchvar' - `valUp_1') if `grpvar' == 1
		replace `diffup' 	= abs(`matchvar' - `valUp_0') if `grpvar' == 0

		*Create one varaible common for both groups with diff downwards
		replace `diffdo' 	= abs(`matchvar' - `valDo_1') if `grpvar' == 1
		replace `diffdo' 	= abs(`matchvar' - `valDo_0') if `grpvar' == 0

		*Create one varaible common for both groups with ID upwards
		replace `IDup' 		= `IDup_1' 	if `grpvar' == 1
		replace `IDup' 		= `IDup_0' 	if `grpvar' == 0

		*Create one varaible common for both groups with ID downwards
		replace `IDdo' 		= `IDdo_1' 	if `grpvar' == 1
		replace `IDdo' 		= `IDdo_0' 	if `grpvar' == 0

		replace `prefID' 	= `IDdo' 	if `matched' == 0 & `diffdo' <= `diffup'
		replace `prefID' 	= `IDup' 	if `matched' == 0 & `diffdo' >  `diffup'

		replace `prefDiff' 	= `diffdo' 	if `matched' == 0 & `diffdo' <= `diffup'
		replace `prefDiff' 	= `diffup' 	if `matched' == 0 & `diffdo' >  `diffup'

	end


	** This function goes through the observatioins from top down and copies
	*  the match value of the closest observation of the other group above to
	*  (bestVal) and the corresponding ID to (bestID) for one group at the time.
	*  To go from bottom to top sort with invsort and apply this command.
	cap program drop 	updateBestValID
		program define 	updateBestValID

		args grpvl matchval idvar grpvar matched bestVal bestID

		*Test if ID var is string or numeric
		local IDNumeric 0
		cap confirm numeric variable `idvar'
		if _rc == 0 local IDNumeric 1


		*Reset all values
		replace `bestVal' 	= .
		if `IDNumeric' == 1 replace `bestID' 	= .
		if `IDNumeric' == 0 replace `bestID' 	= ""

		*Set the match value and ID of observations that are in the other group
		replace `bestVal'   = `matchval' 		if `grpvar' != `grpvl' & `matched' == 0
		replace `bestID'  	= `idvar' 			if `grpvar' != `grpvl' & `matched' == 0

		*Fill in that value from the observation in the other group until getting to another observation of the other group
							replace `bestVal'   = `bestVal'[_n-1]	if `bestVal' == .  & `matched' == 0
		if `IDNumeric' == 1 replace `bestID'  	= `bestID'[_n-1] 	if `bestID'	 == .  & `matched' == 0
		if `IDNumeric' == 0 replace `bestID'  	= `bestID'[_n-1] 	if `bestID'	 == "" & `matched' == 0

	end



	** This function creates the output table.
	cap program drop 	outputTable
		program define 	outputTable

		qui {
			args resultVar grpdum

			*List the texts used in the first column in the
			local text_1 " 1 Matched"
			local text_0 " 0 Not matched"
			local text_d ".d No match within maxdiff()"
			local text_i ".i Excluded using if/in"
			local text_g ".g Missing grpdummy()"
			local text_m ".m Missing matchvar()"
			local text_t ".t No more target obs"

			*The minimum width of the
			local firstColWidth = max(strlen(" `resultVar'") , strlen(" value and result"))

			levelsof `resultVar' , missing local(resultsUsed)

			foreach result of local resultsUsed {

				*Remove the . from the local to match the string
				local result = subinstr("`result'",".","",1)

				* Test if the text in the first column is longer
				* for this row than previous row
				local firstColWidth = max(`firstColWidth' , strlen("`text_`result''"))
			}

			* Create a local that indicates if there is column
			* for obs with missing value in tmt dummy
			local missingGrpDum 0
			count if missing(`grpdum')
			if `r(N)' > 0 local missingGrpDum 1


			*Set all locals that determines column width

			local C1 "{col 4}{c |}"

			di "`firstColWidth'"

			local col1width = `firstColWidth'  + 1
			local hli1 "{hline `col1width'}"
			local cen1 "{center `col1width':"

			local col2border = `firstColWidth' + 6
			local C2  "{col `col2border'}{c |}"
			local C2a "{col `col2border'}"

			local col3border = `firstColWidth' + 17
			local C3 "{col `col3border'}{c |}"

			local col4border = `firstColWidth' + 30
			local C4 "{col `col4border'}{c |}"

			local grpdumCentre 23 //Overspills automatically

			local lastT  	"{c RT}"
			local lastTdown	"{c RT}"
			local lastC  	"{c BRC}"

			if `missingGrpDum' {

				local lastT 		"{c +}{hline 9}{c RT}"
				local lastTdown 	"{c BT}{hline 9}{c RT}"
				local lastC 		"{c BT}{hline 9}{c BRC}"
				local missTitle 	"  missing "
				local grpdumCentre 	33

			}

			noi di ""
			noi di ""
			noi di "{hline}"
			noi di ""
			noi di "{pstd}{ul:Output of Matching Result:}{p_end}"
			noi di ""
			noi di "{col 5}`cen1'`resultVar'}`C2a' {centre `grpdumCentre':`grpdum' }"
			noi di "{col 4}{c LT}`hli1'{c +}{hline `grpdumCentre'}{c RT}"
			noi di "`C1'`cen1'value and result}`C2' 1 (base)   0 (target) `missTitle'{c |}"
			noi di "{col 4}{c LT}`hli1'{c +}{hline 10}{c +}{hline 12}`lastT'"

			*This is the roworder for the output table
			local resultTableOrder 1 0 .d .t .i .g .m

			foreach result of local resultTableOrder {

				*Test if this result was used
				if `:list result in resultsUsed' {

					*Count base observations in this result type
					qui count if `resultVar' == `result' & `grpdum' == 1
					local numBase = trim("`: display %16.0gc  `r(N)''")

					*Count target observations in this result type
					qui count if `resultVar' == `result' & `grpdum' == 0
					local numTarg = trim("`: display %16.0gc  `r(N)''")

					*Count observations that are neither base or target in this result type
					if `missingGrpDum' {

						qui count if `resultVar' == `result' & missing(`grpdum')
						local numMiss = trim("`: display %16.0gc  `r(N)''")

						local missCol "{ralign 9 :`numMiss' }{c |}"

					}

					*Prepare the local that displays the columns with numbers
					local numCols "`C2'{ralign 10 :`numBase' }`C3'{ralign 12 :`numTarg' }`C4'`missCol'"

					*Remove the . from the local to match the string
					local result = subinstr("`result'",".","",1)

					*Output the table row
					noi di "`C1'`text_`result''`numCols'"

				}
			}

			*Output line before N per group row
			noi di "{col 4}{c LT}`hli1'{c +}{hline 10}{c +}{hline 12}`lastT'"

			*Caculate N per group row for base observations
			qui count if `grpdum' == 1
			local numBase = trim("`: display %16.0gc  `r(N)''")

			*Caculate N per group row for target observations
			qui count if `grpdum' == 0
			local numTarg = trim("`: display %16.0gc  `r(N)''")


			*Caculate N per group row for observations neither base or target
			if `missingGrpDum' {

				qui count if missing(`grpdum')
				local numMiss = trim("`: display %16.0gc  `r(N)''")

				local missCol "{ralign 9 :`numMiss' }{c |}"

			}

			*Output N per group row
			noi di "`C1'`cen1'N per group}`C2'{ralign 10 :`numBase' }`C3'{ralign 12 :`numTarg' }`C4'`missCol'"

			*Output line before total N row
			noi di "{col 4}{c LT}`hli1'{c +}{hline 10}{c BT}{hline 12}`lastTdown'"

			*Count total N
			qui count
			local numTot = trim("`: display %16.0gc  `r(N)''")

			*Output total N row
			noi di "`C1'`cen1'Total N}`C2'{centre `grpdumCentre':`numTot'}`C4'"

			*Output bottom line
			noi di "{col 4}{c BLC}`hli1'{c BT}{hline `grpdumCentre'}{c BRC}"
		}
	end
