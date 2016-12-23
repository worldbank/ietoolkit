

	cap program drop 	iematch
	    program define	iematch
		
		noi di "Command OK!"
		
		syntax  [if] [in]  , 					///
			GRPdummy(varname) 					///
			MATCHvar(varname) 					///
			[									///
			IDvar(varname)						///
			m1									///
			maxdiff(numlist max = 1 min = 1) 	///
			seedok						 		///
			MATCHIDname(string)					///
			MATCHDIffname(string)				///
			MATCHREsultname(string)				///
			MATCHCOuntname(string)				///
			]

		*****

		noi di "Syntax OK!"

		pause on

		qui {

		********************************
		*
		*	Gen temp sort and merge var
		*
		********************************

		tempvar originalSort ifinvar

		gen `originalSort' = _n

		preserve

*Testing input
if 1 {

			local obsexcludstring ""
	
			*Deal with if and in and display info. 
			if "`if'`in'" != "" {
				
				gen `ifinvar' = 1 `if'`in'
				
				count if `ifinvar' != 1
				if `r(N)' > 0 {
					
					*This is not an error just outputting the number
					local obsexcludstring "`obsexcludstring'`r(N)' observation(s) were excluded in {inp:if}/{inp:in}: (`if'`in').{break}"
					
				}
				
				keep `if'`in'
			}
			
			
			
			********************************
			*
			*	Checking group dummy
			*
			********************************

			*Test that the group dummy is 1, 0 or missing
			cap assert inlist(`grpdummy', 1, 0, .) | `grpdummy' > .
			if _rc != 0 {

				di as error "{pstd}The variable in grpdummy(`grpdummy') is not a dummy variable. The variable is only allowed to have the values 1, 0 or missing. Observations with missing varaibles in the grpdummy are ignored by this command.{p_end}"
				error _rc
			}

			**Exclude obs with missing value in groupdummy

			*Count number of obs to be dropped and and output that number if more than zero
			count if missing(`grpdummy')
			if `r(N)' > 0 {
			
				*This is not an error just outputting the number
				local obsexcludstring  "`obsexcludstring'`r(N)' observation(s) were excluded due to missing value in  grpdummy(`grpdummy').{break}"
			}
			*Drop obs with missing
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
				local obsexcludstring  "`obsexcludstring'`r(N)' observation(s) were excluded due to missing value in matchvar(`matchvar').{break}"
				
			}
			*Drop obs with missing
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
					
					noi di as error "{pstd}There are more base observations than target observations. This is not allowed in a one-to-one match. See option {inp:m1} for an alternaitve matching where it is allowed to have more base observations than target ovbservations.{p_end}"
					error _rc
				}
			}			
			
			********************************
			*
			*	Checking duplicates in variable names in options
			*
			********************************

			*Create a local of all varnames used in any option
			local allnewvars `idvar' `matchidname' `matchdiffname' `matchresult'

			*Check if there are any duplicates in the local of all varnames in options
			local dupnewvars : list dups allnewvars

			*Throw error if there were any duplicates
			if "`dupnewvars'" != "" {

				di as error "{pstd}The same new variable name was used twice or more in the options generating a new variable. Go back and check syntax.{p_end}"
				error 198

			}


			********************************
			*
			*	Checking ID var
			*
			********************************


			*Checking set-up for the ID var used for _matchID
			if "`idvar'" == "" {

				*Copy this name
				local idvar _ID

				*Make sure that the default name _ID is not already used
				cap confirm variable `idvar'
				if _rc == 0 {

					di as error "{pstd}A variable with name `idvar' is already defined. Either drop this variable or specify a variable using idvar() that fully and uniquely identifies the data set.{p_end}"
					error 110

				}

				*Generate the ID var from row number
				gen `idvar' = _n
				
				*Store local indicating ID var generated has type numeric
				local IDtypeNumeric 1

			}
			else {

				*Make sure that user specified ID is uniquely and fully identifying the observations
				cap isid `idvar'
				if _rc != 0 {

					di as error "{pstd}Variable `idvar' specified in idvar() does not fully and uniquely identify the observations in the data set. Meaning that `idvar' is not allowed to have any duplicates or missing values. Make `idvar' uniquly and fully idnetifying or exclude the varaibleas using {inp:if} or {inp:in}.{p_end}"
					error 450

				}
				
				*Test if ID var is string or numeric
				cap confirm numeric variable `idvar'
				if _rc == 0 {
					
					*Store local indicating ID var type is numeric
					local IDtypeNumeric 1
				}
				else {
				
					*Store local indicating ID var type is numeric
					local IDtypeNumeric 0			
				}
			}

			********************************
			*
			*	Checking and generating the MatchID and the MatchDiff var
			*
			********************************


			*Test input from user or test if deafault value is valiable
			iematchMatchVarCheck _matchID `matchidname'
			local matchIDname "`r(validVarName)'"
			
			*Allow the ID var used to be string
			if `IDtypeNumeric' == 1 {
				gen  `matchIDname' = .
			}
			else {
				gen  `matchIDname' = ""
			}

			*If many-to-one match used
			if "`m1'" != "" {
				iematchMatchVarCheck _matchCount `matchcountname'
				local matchCountName "`r(validVarName)'"
				gen `matchCountName' = .
			}
			else {
				
				*Option match count name is not allowed if it is a one-to-one match
				if "`matchcountname'" != "" {
				
					di as error "{pstd}Option {inp:matchcountname()} is only allowed in combination with option {inp:m1}.{p_end}"
					error 198
				}
			}
			

			iematchMatchVarCheck _matchDiff `matchdiffname'
			local matchDiffName "`r(validVarName)'"
			gen `matchDiffName' = .

			iematchMatchVarCheck _matchResult `matchresultname'
			local matchResultName "`r(validVarName)'"
			gen `matchResultName' = .



			*Create a label for missing values that explains no match
			label define matchLabel 0 "Not Matched" 1 "Matched" .i "Obs excluded due to if/in" .g "Missing value in `grpdummy'" .m "Missing value in `matchvar'" .d "No match within maxdiff"

			*Apply the label
			label value `matchResultName' matchLabel

}

			********************************
			*
			*	Output exclude string
			*
			********************************				
			
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
			*	Creating tempvar used
			*
			********************************

			*Initiate the temporary variables used by this command
			tempvar prefID prefDiff matched

			gen `prefDiff' 		= .
			gen byte `matched' 	= 0

			*Allow the ID var used to be string
			if `IDtypeNumeric' == 1 {
				gen  `prefID' = .
			}
			else {
				gen  `prefID' = ""
			}			
			

			** Generate the inverse of the matchvar to sort descending (gsort is too slow),
			*  a random var to seperate two values with the same match var, and the inverse
			*  of the random var for when sorting descending.
			tempvar rand invsort invrand

			sort `matchvar'
			gen  `invsort' = -1 * `matchvar'

			gen    `rand' = uniform()
			gen `invrand' = -1 * `rand'

			***********
			*Tempvars for matching

			*Diffvars, they are always numeric
			tempvar					 diffup   diffdo   valUp_0   valDo_0   valUp_1   valDo_1   
			local 	 updownTempVars `diffup' `diffdo' `valUp_0' `valDo_0' `valUp_1' `valDo_1'

			foreach tempVar of local updownTempVars {

				gen `tempVar' = .
			}
			
			*ID vars, allowed to be both numeric and string
			tempvar					  	IDup   IDdo   IDup_0   IDdo_0   IDup_1   IDdo_1
			local 	 updownIDTempVars  `IDup' `IDdo' `IDup_0' `IDdo_0' `IDup_1' `IDdo_1'

			foreach tempVar of local updownIDTempVars {
				
				*Allow the ID var used to be string
				if `IDtypeNumeric' == 1 {
					gen  `tempVar' = .
				}
				else {
					gen  `tempVar' = ""
				}					
			}			

			***************************
			*
			*	One to one match
			*
			***************************

			if "`m1'" == "" {

				noi di ""
				noi di "{hline}{break}"
				noi di "{pstd}{ul:Matching one-to-one. Base observations left to match:}{p_end}"
				count if `grpdummy' == 1 & `matched' == 0
				local left2Match = `r(N)'
				noi di "{pstd}`left2Match' " _c
				
				*di "`idvar'"
				*di "`IDtypeNumeric'"
				*pause on
				*pause 
				
				
				while (`left2Match' > 0) {
					
					*noi di 0
					
					**For all observations still to be matched, assign the preferred
					* match among the other unmatched observations
					qui updatePrefDiffPreffID `prefID' `prefDiff' `matchvar' `invsort' `idvar' `grpdummy' `matched' `rand' `invrand' `updownTempVars' `updownIDTempVars'
					
					*noi di 1
					
					if "`maxdiff'" != "" {

						replace `matched' 			= 1		if `prefDiff' > `maxdiff' & `grpdummy' == 1
						replace `matchResultName' 	= .d 	if `prefDiff' > `maxdiff' & `grpdummy' == 1
						
						*Allow the ID var used to be string
						if `IDtypeNumeric' == 1 {
							replace `prefID'		= .		if `prefDiff' > `maxdiff'
						}
						else {
							replace `prefID'		= ""	if `prefDiff' > `maxdiff'
						}	
					}
					
					*noi di 2
					
					replace `matched' = 1 if `matched' == 0 & `prefID' == `idvar'[_n-1] & `prefID'[_n-1] == `idvar'
					replace `matched' = 1 if `matched' == 0 & `prefID' == `idvar'[_n+1] & `prefID'[_n+1] == `idvar'
					
					*noi di 3
					
					count if `grpdummy' == 1 & `matched' == 0
					local left2Match = `r(N)'
					noi di "`left2Match' " _c

				}
				noi di "{p_end}" _c

			}

			***************************
			*
			*	Many to one match
			*
			***************************
			else {


				updatePrefDiffPreffID `prefID' `prefDiff' `matchvar' `invsort' `idvar' `grpdummy' `matched' `rand' `invrand' `updownTempVars' `updownIDTempVars'

				if "`maxdiff'" != "" {

					replace `matched' 			= 1		if `prefDiff' > `maxdiff' & `grpdummy' == 1
					replace `matchResultName' 	= .d 	if `prefDiff' > `maxdiff' & `grpdummy' == 1
					
					*Allow the ID var used to be string
					if `IDtypeNumeric' == 1 {
						replace `prefID'		= .		if `prefDiff' > `maxdiff'
					}
					else {
						replace `prefID'		= ""	if `prefDiff' > `maxdiff'
					}	
			
				}

				replace `prefID'			=  `idvar' if `grpdummy' == 0
				bys 	`prefID' 			:   replace `matchCountName' = _N - 1
			

				**Replace prefID to missing for target obs that had no base 
				* obs matched to it. T
				if `IDtypeNumeric' == 1 { 
					*Id var is numeric
					replace `prefID'		= .		if `matchCountName' == 0
				}
				else {
					*id var is string
					replace `prefID'		= ""	if `matchCountName' == 0
				}					
				
				*Only target obs with base obs prefering it are matched
				replace	 `matched' 			= 1		if `matchCountName' != 0
			
				*Remove values for target obs that were not matched
				replace  `matchCountName'	= . 	if `matchCountName' == 0
			}


			*Return vars
			replace `matchDiffName' 	= `prefDiff'	if `matched' == 1
			replace `matchIDname' 		= `idvar' 		if `matched' == 1 & `grpdummy' == 0
			replace `matchIDname' 		= `prefID' 		if `matched' == 1 & `grpdummy' == 1

			*Target obs not used
			replace `matchResultName' = 0 if `matched' == 0 & `grpdummy' == 0

			*only keep output vars
			keep `matchIDname' `matchDiffName' `idvar' `originalSort' `matchResultName' `matchCountName'

			tempfile mergefile

			save `mergefile'

		restore

		tempvar mergevar ifinvar

		merge 1:1  `originalSort' using `mergefile', gen(`mergevar')

		replace `matchResultName' = .m if missing(`matchvar')
		replace `matchResultName' = .g if missing(`grpdummy')
		
		if "`if'`in'" != "" {
			
			gen `ifinvar' = 1 `if'`in'
			replace `matchResultName' = .i if `ifinvar' != 1
		}
		
		
		replace `matchResultName' = 1 if `matchResultName' == .
		
		*comress the variables generated
		compress  `matchIDname' `matchDiffName' `matchResultName' `matchCountName'

		noi outputTable `matchResultName' `grpdummy'
		
		sort `originalSort'		

	}

	end

*Testing input (functions)
 if 1 {
	*Cheack matchVar input
	cap program drop 	iematchMatchVarCheck
		program define 	iematchMatchVarCheck  , rclass

		args defaultName userName

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

			noi di as error "{phang}The new name specified in `optionName'(`userName') is not allowed to be _ID, `Oth1', `Oth2', or `Oth3'{p_end}"
			error 198
		}

		*Checking set-up for the ID var used for _matchID
		if "`userName'" == "" {

			*CSet the default name
			local validMatchVarname `defaultName'

			*Make sure that the default name _ID is not already used
			cap confirm variable `validMatchVarname'
			if _rc == 0 {

				noi di as error "A variable with name `validMatchVarname' is already defined. Either drop this variable or specify a new variable name using `optionName'()."
				error 110

			}

		}

		else {

			*CSet the default name
			local validMatchVarname `userName'

			*Make sure that the default name _ID is not already used
			cap confirm variable `validMatchVarname'
			if _rc == 0 {

				noi di as error "The variable name specified in `optionName'(`userName') is already defined in the data set. Either drop this variable or specify a another variable name using `optionName'()."
				error 110

			}

		}

		*Testing that the new name is valid by creating a variable that is dropped immedeatly afterwards
		cap gen `validMatchVarname' = .

		if _rc != 0 {

			noi di as error "The variable name specified in `optionName'(`userName') is not a valid variable name."
			error _rc

		}
		drop `validMatchVarname'

		return local validVarName 	"`validMatchVarname'"

	end
}




*Matching functions
if 1 {


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


	** This function goes through the observatioins from top to down and copying
	*  the match value of the closest observation of the other group above to
	*  (bestVal) and the ccoprresponding ID to (bestID) for obe group at the time.
	*  To go from bottuom to top sort with invsort and apply this command.
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

}

	** This function goes through the observatioins from top to down and copying
	*  the match value of the closest observation of the other group above to
	*  (bestVal) and the ccoprresponding ID to (bestID) for obe group at the time.
	*  To go from bottuom to top sort with invsort and apply this command.
	cap program drop 	outputTable
		program define 	outputTable	
		
		qui {
			args resultVar grpdum 

			local maxResultLen 16

			local allResults 1 0 .d .i .g .m

			levelsof `resultVar' , missing local(resultsUsed)  
			
			foreach result of local resultsUsed {
				
				if `result' == 1  local thisLen 7
				if `result' == 0  local thisLen 11
				if `result' == .d local thisLen 25
				if `result' == .i local thisLen 18
				if `result' == .g local thisLen 18
				if `result' == .m local thisLen 18

				local maxResultLen = max(`maxResultLen' , `thisLen')
			}
			
			local missingGrpDum 0
			count if missing(`grpdum')
			if `r(N)' > 0 local missingGrpDum 1
			
			local R1 "{col 4}{c |}"
			
			local col1width = `maxResultLen' + 3 //28
			local hli1 "{hline `col1width'}" 
			local cen1 "{center `col1width':"
			
			local col2border = `maxResultLen' + 8 //33
			local R2  "{col `col2border'}{c |}"
			local R2a "{col `col2border'}"

			local col3border = `maxResultLen' + 19 //44
			local R3 "{col `col3border'}{c |}"

			local col4border = `maxResultLen' + 32 //57
			local R4 "{col `col4border'}{c |}"		
			
			local grpdumCentre 23
			
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
			noi di "{col 5}`cen1'`resultVar'}`R2a' {centre `grpdumCentre':tmt }" 
			noi di "{col 4}{c LT}`hli1'{c +}{hline `grpdumCentre'}{c RT}"
			noi di "`R1'`cen1'value and result}`R2' 1 (base)   0 (target) `missTitle'{c |}"
			noi di "{col 4}{c LT}`hli1'{c +}{hline 10}{c +}{hline 12}`lastT'"
			
			foreach result of local allResults {
				
				if `:list result in resultsUsed' {
					
					qui count if `resultVar' == `result' & `grpdum' == 1
					local numBase = trim("`: display %16.0gc  `r(N)''")
					
					qui count if `resultVar' == `result' & `grpdum' == 0
					local numTarg = trim("`: display %16.0gc  `r(N)''")			
					
					if `missingGrpDum' {
					
						qui count if `resultVar' == `result' & missing(`grpdum')
						local numMiss = trim("`: display %16.0gc  `r(N)''")
						
						local missCol "{ralign 9 :`numMiss' }{c |}"
					
					}
					
					local numCols "`R2'{ralign 10 :`numBase' }`R3'{ralign 12 :`numTarg' }`R4'`missCol'"
					
					if `result' == 1  noi di "`R1' 1 Matched`numCols'"
					if `result' == 0  noi di "`R1' 0 Not matched`numCols'"
					if `result' == .d noi di "`R1'.d No match within maxdiff()`numCols'"
					if `result' == .i noi di "`R1'.i Excluded using if/in`numCols'"
					if `result' == .g noi di "`R1'.g Missing grpdummy()`numCols'"
					if `result' == .m noi di "`R1'.m Missing matchvar()`numCols'"
				}	
			}
			noi di "{col 4}{c LT}`hli1'{c +}{hline 10}{c +}{hline 12}`lastT'"
			
			qui count if `grpdum' == 1
			local numBase = trim("`: display %16.0gc  `r(N)''")
			
			qui count if `grpdum' == 0
			local numTarg = trim("`: display %16.0gc  `r(N)''")
			
			if `missingGrpDum' {
			
				qui count if missing(`grpdum')
				local numMiss = trim("`: display %16.0gc  `r(N)''")
				
				local missCol "{ralign 9 :`numMiss' }{c |}"
			
			}			
			
			noi di "`R1'`cen1'N per group}`R2'{ralign 10 :`numBase' }`R3'{ralign 12 :`numTarg' }`R4'`missCol'"
			noi di "{col 4}{c LT}`hli1'{c +}{hline 10}{c BT}{hline 12}`lastTdown'"
			
			qui count
			local numTot = trim("`: display %16.0gc  `r(N)''")
			
			
			noi di "`R1'`cen1'Total N}`R2'{centre `grpdumCentre':`numTot'}`R4'"
			noi di "{col 4}{c BLC}`hli1'{c BT}{hline `grpdumCentre'}{c BRC}"
		}
	end



