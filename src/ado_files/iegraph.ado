*! version 6.2 31JAN2019 DIME Analytics dimeanalytics@worldbank.org

cap	program drop	iegraph
	program define 	iegraph, rclass

	syntax varlist, 							///
 	   [noconfbars 								///
 		confbarsnone(varlist) 					///
 		confintval(numlist min=1 max=1 >0 <1) 	///
 		BARLabel								///
 		MLABColor(string)						///
 		MLABPosition(numlist)					///
 		MLABSize(string)						///
 		BAROPTions(string)						///
 		barlabelformat(string)					///
 		GREYscale								///
		GRAYscale								///
 		yzero									///
 		BASICTItle(string) 						///
 		VARLabels								///
 		ignoredummytest 						///
 		norestore								///
 		save(string) *]

 	if "`restore'" == "" preserve

	qui {

	version 11

/*******************************************************************************

						Identify options used

********************************************************************************/

	*Checking to see if the noconfbars option has been used and assigning 1 and 0 based
	*on that to the CONFINT_BAR variable.
	if "`confbars'" != ""  			local CONFINT_BAR 	= 0
	if "`confbars'" == ""  			local CONFINT_BAR 	= 1

	*Checking to see if the barlabel option has been used and assigning 1 and 0 based
	*on that to the LABEL_BAR variable.
	if "`barlabel'" != "" 			local LABEL_BAR 	= 1
	if "`barlabel'" == "" 			local LABEL_BAR 	= 0

	*Checking to see if the mlabposition option has been used and assigning 1 and 0 based
	*on that to the LABEL_POS variable.
	if "`mlabposition'" != "" 		local LABEL_POS 	= 1
	if "`mlabposition'" == "" 		local LABEL_POS 	= 0

	*Checking to see if the mlabcolor option has been used and assigning 1 and 0 based
	*on that to the LABEL_COL variable.
	if "`mlabcolor'" != "" 			local LABEL_COL 	= 1
	if "`mlabcolor'" == "" 			local LABEL_COL 	= 0

	*Checking to see if the mlabcolor option has been used and assigning 1 and 0 based
	*on that to the LABEL_COL variable.
	if "`mlabsize'" != "" 			local LABEL_SIZE	= 1
	if "`mlabsize'" == "" 			local LABEL_SIZE 	= 0

	*Checking to see if the barlabelformat option has been used and assigning 1 and 0 based
	*on that to the LABEL_FORMAT variable.
	if "`barlabelformat'" != "" 	local LABEL_FORMAT 	= 1
	if "`barlabelformat'" == ""		local LABEL_FORMAT 	= 0

/*******************************************************************************

							Prepare inputs

********************************************************************************/

	*Only keep the observations in the regressions
	keep if e(sample) == 1

	*Copy beta matrix to a regular matrix
	mat BETA = e(b)

	*Translate GREYscale to GRAYscale
	if "`greyscale'" != "" local grayscale "grayscale"

	*Unabbreviate and varlists
	unab varlist : `varlist'

	*Testing to see if the variables used in the regressions are actual dummy variables as treatment vars need to be dummy variables.
	foreach var of local varlist {

		*Get the column number from this var
		local colnumber = colnumb(BETA,"`var'")

		*Test if this var was omitted from the regression
		if "`r(label`colnumber')'" == "(omitted)" {

			*Test if that dummy is not found in the estimation matrix
			noi di as error "{phang}Dummy variable `var' was not included in the regression, or was omitted from it.{p_end}"
			error 480
		}
	}

	foreach var of local varlist {
		*Assigning variable coefficient/standard errors/no of obs. to scalars with the name Coeff_(`variable name')
		*coeff_se_(`variable name'), obs_(`variable name').

		*Access and store the beta value (
		scalar coeff_`var' 		= _b[`var']

		*Access and store standard errors for the dummy
		scalar coeff_se_`var' 	= _se[`var']

		*Store the number of observations for this dummy
		count if `var' == 1 //Count one tmt group at the time
		scalar obs_`var' = r(N)

	}

	*Test if the list of dummies are valid
	if "`ignoredummytest'" == "" testDums `varlist'


	*Testing to see if the variables used in confbarsnone are
	*actually in the list of
	*variables used for the regression/graph.
	local varTest : list confbarsnone in varlist

	if `varTest' == 0 {
		*Error displayed if variables defined in confbarsnone aren't in the list of variables for the graph.
		noi display as error "{phang} Variables defined in confbarsnone(`confbarsnone') cannot be found in the graph variable list. {p_end}"
		noi display ""
		error 111
	}

	* Can only be used if the bar label is displayed
	if `LABEL_BAR' == 0 {
		if `LABEL_FORMAT' | `LABEL_POS' | `LABEL_COL' | `LABEL_SIZE' {
			noi display as error "{phang} Options barlabelformat(), mlabsize(), mlabposition() and mlabcolor() can only be specified when option barlabel is used. {p_end}"
			error 198
		}
	}
	else {

		**************************************
		* Check that specified format is valid
		**************************************

		if `LABEL_FORMAT' {
			if substr("`barlabelformat'",1,1) != "%" | !inlist(substr("`barlabelformat'",-1,1), "e", "f") | !regex("`barlabelformat'", "\.") {
				noi display as error "{phang} Option barlabelformat() was incorrectly specified. Only fixed and exponencial formats are currently allowed. See {help format} for more information on how to specify a variable format.{p_end}"
				error 198
			}
		}

		***************************************************************************
		* Check that label options are valid. If not, print warning and turn switch
		* off so default will be used
		***************************************************************************
		if `LABEL_POS' {
			noi 	clockname `mlabposition'
			local 	LABEL_POS = r(LABEL_POS)
		}
		if `LABEL_SIZE' {
			noi 	sizename `mlabsize'
			local 	LABEL_SIZE = r(LABEL_SIZE)
		}
		if `LABEL_COL' {
			if !inlist("`mlabcolor'", "background", "bg", "foreground", "fg") {
				noi 	colorname `mlabcolor'
				local 	LABEL_COL = r(LABEL_COL)
			}
		}
	}

	*Checking to see if the save option is used what is the extension related to it.
	if "`save'" != "" {

		**Find the last . in the path name and assume that
		* the file extension is what follows. However, with names
		* that have multiple dots in it, the user has to explicitly
		* specify the file name.

		**First, will extract the file names from the combination of file
		* path and files names. We will use both backslash and forward slash
		* to account for differences in Windows/Unix file paths
		local backslash = strpos(reverse("`save'"), "\")
		local forwardslash = strpos(reverse("`save'"), "/")

		** Replacing the value of forward/back slash with the other value if one of the
		*  values is equal to zero.
        if `forwardslash' == 0  local forwardslash = `backslash'
        if `backslash' == 0     local backslash = `forwardslash'

		**Extracting the file name from the full file path by  reversing and breaking the path
		* at the first occurence of slash.
		local file_name = substr(reverse("`save'"), 1, (min(`forwardslash', `backslash')-1))
		local file_name = reverse("`file_name'")

		**If no slashes it means that there is no file path and just a file name, so the name of the file will be
		* the local save.
		if (`forwardslash' == 0 & `backslash' == 0) local file_name = "`save''"

		*Assign the full file path to the local file_suffix
		local file_suffix = "`file_name'"

        *Find index for where the file type suffix start
        local dot_index     = strpos("`file_name'",".")

		local file_suffix = substr("`file_name'", `dot_index' + 1, .)

		*If no dot in the name, then no file extension
		if `dot_index' == 0 {
			local save `"`save'.gph"'
			local file_suffix "gph"
			local save_export = 0
		}

		**If there is one or many . in the file path than loop over
		* the file path until we have found the last one.

		**Find index for where the file type suffix starts. We are re-checking
		* to see if there are any more dots than the first one. If there are,
		* then there needs to be an error message saying remove the dots.
		local dot_index 	= strpos("`file_suffix'",".")

		*Extract the file index

		if (`dot_index' > 0) {
			di as error "{pstd}File names cannot have more than one dot. Please only use the dot to separate the filename and file format.{p_end}"
			error 198
		}

        *List of formats to which the file can be exported
        local nonGPH_formats png tiff gph ps eps pdf wmf emf

        *If no file format suffix is specified, use the default .gph
        if "`file_suffix'" == "gph" {
			local save_export = 0
		}

        *If a file format suffix is specified make sure that it is one of the eight formats allowed.
        else if `:list file_suffix in nonGPH_formats' != 0  {
            local save_export = 1

			if ("`file_suffix'" == "wmf" | "`file_suffix'" == "emf") & "`c(os)'" != "Windows" {
				di as error "{pstd}The file formats .wmf and .emf are only allowed when using Stata on a Windows computer.{p_end}"
                error 198
			}
		}
		*If a different extension was used then display an error.
        else {

            di as error "{pstd}You are not using a allowed file format in save(`save'). Only the following formats are allowed: gph `nonGPH_formats'. {p_end}"
            error 198
        }
    }
	else {

		*Save option is not used, therefore save export will not be used
		local save_export = 0

	}

	* Set default barlabel options
	if `LABEL_BAR' {
		if !`LABEL_POS'		local mlabposition 	12
		if !`LABEL_COL'	 	local mlabcolor		black
		if !`LABEL_SIZE' 	local mlabsize		medium
	}


/*******************************************************************************

						Get values from regression

*******************************************************************************/

	local count: word count `varlist' // Counting the number of total vars used as treatment.
	local graphCount = `count' + 1 // Number of vars needed for the graph is total treatment vars plus one(control).

	//Make all vars tempvars (maybe do later)
	//Make sure that missing is properly handled

	tempvar anyTMT control
	egen `anyTMT' = rowmax(`varlist')
	gen `control' = (`anyTMT' == 0) 	if !missing(`anyTMT')

	sum `e(depvar)' if `control' == 1
	scalar ctl_N		= r(N)
	scalar ctl_mean	  	= r(mean)
	scalar ctl_mean_sd 	= r(sd)


	/**
	 Calculate t-statistics
	**/

	*If not set in options, use default of 95%
	if "`confintval'" == "" {
		local confintval = .95
	}

	**Since we calculating each tail separately we need to convert
	* the two tail % to one tail %
	local conintval_1tail = ( `confintval' + (1-`confintval' ) / 2)

	*degrees of freedom in regression
	local df = `e(df_r)'

	*Calculate t-stats to be used
	local tstats = invt(`df' , `conintval_1tail'  )


	foreach var of local varlist {

		*Calculating confidnece interval
		scalar  conf_int_min_`var'   =	(coeff_`var'-(`tstats'*coeff_se_`var') + ctl_mean)
		scalar  conf_int_max_`var'   =	(coeff_`var'+(`tstats'*coeff_se_`var') + ctl_mean)
		**Assigning stars to the treatment vars.

		*Perform the test to get p-values
		test `var'
		local star_`var' " "

		scalar  pvalue =r(p)
		if pvalue < 0.10 {
			local star_`var' "*"
		}
		if pvalue < 0.05 {
			local star_`var' "**"
		}
		if pvalue < 0.01 {
			local star_`var' "***"
		}

		scalar tmt_mean_`var' = ctl_mean + coeff_`var'
	}


/*******************************************************************************

			Set up temp file where results are written

*******************************************************************************/


	tempfile		 newTextFile
	tempname 		 newHandle
	cap file close 	`newHandle'
	file open  		`newHandle' using "`newTextFile'", text write append

	*Write headers and control value
	file write `newHandle' ///
		"position" 	_tab "xLabeled"	_tab "mean" _tab "coeff" _tab "conf_int_min" _tab "conf_int_max" _tab "obs" _tab "star" _n 	///
		%9.3f (1) _tab "Control"  _tab %9.3f (ctl_mean)      _tab  	_tab   _tab _tab %9.3f (ctl_N) 	 _tab  _n

	tempvar newCounter
	gen `newCounter' = 2  //First tmt group starts at 2 (1 is control)

	foreach var in `varlist' {

		if "`varlabels'" == "" {

			*Default is to use the varname in legend
			local var_legend "`var'"

		}
		else {

			*Option to use the variable label in the legend instead
			local var_legend : variable label `var'

		}

		*Writing the necessary tables for the graph to list to file.
	    if `: list var in confbarsnone' {
			file write `newHandle' 	%9.3f (`newCounter') _tab `"`var_legend'"'  ///
			_tab %9.3f (tmt_mean_`var') _tab  %9.3f (coeff_`var')  _tab _tab ///
			_tab %9.3f (obs_`var') _tab "`star_`var''"  _n

			replace `newCounter' = `newCounter' + 1
		}
		else {
			file write `newHandle' %9.3f (`newCounter') _tab `"`var_legend'"' ///
			_tab %9.3f (tmt_mean_`var') _tab  %9.3f (coeff_`var')  			///
			_tab %9.3f (conf_int_min_`var') _tab %9.3f (conf_int_max_`var')	///
			_tab %9.3f (obs_`var')   _tab "`star_`var''"  _n

			replace `newCounter' = `newCounter' + 1
		}
	}

	file close `newHandle'

/*******************************************************************************

						Create the graph

*******************************************************************************/


	*Read file with results
	insheet using `newTextFile', clear

	*Defining various options to go on the graph option.

	local tmtGroupBars 	""
	local xAxisLabels 	`"xlabel( "'
	local legendLabels	""
	local legendNumbers	""

	forval tmtGroupCount = 1/`graphCount' {

		************
		*Create the bar for this group

		if "`grayscale'" == "" {
			colorPicker `tmtGroupCount' `graphCount'
		}
		else {
			grayPicker `tmtGroupCount' `graphCount'
		}

		local tmtGroupBars `"`tmtGroupBars' (bar mean position if position == `tmtGroupCount', `baroptions' color("`r(color)'") lcolor(black) ) "'

		************
		*Create labels etc. for this group

		local obs 			= obs[`tmtGroupCount']
		local stars 		= star[`tmtGroupCount']
		local legendLabel 	= xlabeled[`tmtGroupCount']

		local xAxisLabels 	`"`xAxisLabels' `tmtGroupCount' "(N = `obs') `stars'" "'
		local legendLabels 	`"`legendLabels' lab(`tmtGroupCount' "`legendLabel'") "'
		local legendNumbers	`"`legendNumbers' `tmtGroupCount'"'
	}

	*Close or complete some strings
	local xAxisLabels `"`xAxisLabels' ,noticks labsize(medsmall)) "'
	local legendOption `"legend(order(`legendNumbers') `legendLabels')"'


	*Create the confidence interval bars

	if `CONFINT_BAR' == 0 {

		local confIntGraph = ""
	}
		else if `CONFINT_BAR' == 1 {
		local confIntGraph = `"(rcap conf_int_max conf_int_min position, lc(gs)) (scatter mean position,  msym(none)  mlabsize(`mlabsize') mlabposition(`mlabposition') mlabcolor(`mlabcolor'))"'
	}

	*Create the bar label
	if `LABEL_BAR' == 0 {
		local barLabel = ""
	}
	else if `LABEL_BAR' == 1 {

		gen label = mean

		if `LABEL_FORMAT' == 1 {
			format label `barlabelformat'
		}
		else if `LABEL_FORMAT' == 0 {
			format label %9.1f
		}

		local barLabel = `"(scatter mean position,  msym(none)  mlab(label) mlabposition(`mlabposition') mlabcolor(`mlabcolor'))"'
	}

	local titleOption `" , xtitle("") ytitle("`e(depvar)'") "'

	if "`save'" != "" {
		local saveOption saving("`save'", replace)
	}

	*******************************************************************************
	*** Generating the graph axis labels for the [yzero] option used..
	*******************************************************************************

	*Calculations needed if yzero used
	if  ("`yzero'" != "" ) {

		**Testing if [yzero] is applicable
		********************************

		** [yzero] is only applicable if all values used in the graph
		* are all negative or all positive. If there is a mix, then
		* the [yzero] option will be ignored

		*Finding the min value for all values used in the graph
		gen row_minvalue = min(mean, conf_int_min, conf_int_max)
		sum row_minvalue
		local min_value `r(min)'

		*Finding the min value for all values used in the graph
		gen row_maxvalue = max(mean , conf_int_max, conf_int_min)
		sum row_maxvalue
		local max_value `r(max)'

		*Locals used for logic below
		local signcheck = ((`max_value' * `min_value') >= 0) 	// dummy local for both signs the same (positive or negative)
		local negative	=  (`max_value' <= 0)				// dummy for max value still negative (including 0)

		**If [yzero] is used and min and max does not have
		* the same sign, then [yzero] is not applicable.

		if (`signcheck' == 0 ) {

		**** [yzero] is NOT applicable and will be ignored
		*************************************************

			noi di "{pstd}{error:WARNING:} Option yzero will be ignored as the graph has values both on the the positve and negative part of the y-axis. This only affects formatting of the graph. See helpfile for more details.{p_end}"
		}
		else {

		**** [yzero] is applicable and will be used
		*****************************************

			*Get max value if only postive values
			if (`negative' == 0) {

				sum row_maxvalue
				local absMax = `max_value'
			}

			*Get absolute min (will convert back below) if only negative values
			else {

				sum row_minvalue
				local absMax = abs(`min_value')
			}

			*Rounded up to the nearest power of ten
			local logAbsMax = ceil(log10(`absMax'))
			local absMax = 10 ^ (`logAbsMax')

			*Generating quarter value for y-axis markers.
			local quarter = (`absMax') / 4

			**Construct the option to be applied to
			* the graph using the values calculated
			if (`negative' == 0)  {

				local yzero_option ylabel(0(`quarter')`absMax')
			}
			else {

				local absMax = `absMax' * (-1) // Convert back to negative
				local yzero_option ylabel(`absMax'(`quarter')0)
			}
		}
	}

	*******************************************************************************
	***Graph generation based on if the option [save] has an export or a save feature.
	*******************************************************************************

	*Store all the options in one local
	local commandline 		`" `tmtGroupBars' `confIntGraph' `barLabel' `titleOption'  `legendOption' `xAxisLabels' title("`basictitle'") `yzero_option' `options'  "'

	*Error message used in both save-option cases below.
	local graphErrorMessage `" Something went wrong while trying to generate the graph. Click {stata di r(cmd) :display graph options } to see what graph options iegraph used. This can help in locating the source of the error in the command. "'

	if `save_export' == 0 {

		*Generate a return local with the code that will be used to generate the graph
		return local cmd `"graph twoway `commandline' `saveOption'"'

		*Generate the graph
		cap graph twoway `commandline' `saveOption'

		*If error, provide error message and then run the code again allowing the program to crash
		if _rc {

			di as error "{pstd}`graphErrorMessage'{p_end}"
            graph twoway `commandline' `saveOption'
		}
	}
	else if `save_export' == 1 {

		*Generate a return local with the code that will be used to generate the graph
		return local cmd `"graph twoway `commandline'"'

		*Generate the graph
		cap graph twoway `commandline'

		*If error, provide error message and then run the code again allowing the program to crash
		if _rc {

			di as error "{pstd}`graphErrorMessage'{p_end}"
            graph twoway `commandline'
		}

		*Export graph to preferred option
		graph export "`save'", replace

	}

	if "`restore'" == "" restore
}

end
	*******************************************
	*******************************************
		******* To pick colors based  *******
		******* on the number of vars *******
	*******************************************
	*******************************************
	cap	program drop	colorPicker
		program define 	colorPicker , rclass

		args groupCount totalNumGroups

		if `totalNumGroups' == 2 {

			if `groupCount' == 1 return local color "215 25 28"
			if `groupCount' == 2 return local color "43 123 182"
		}
		else if `totalNumGroups' == 3 {

			if `groupCount' == 1 return local color "215 25 28"
			if `groupCount' == 2 return local color "255 255 191"
			if `groupCount' == 3 return local color "43 123 182"
		}
		else if `totalNumGroups' == 4 {

			if `groupCount' == 1 return local color "215 25 28"
			if `groupCount' == 2 return local color "255 255 191"
			if `groupCount' == 3 return local color "171 217 233"
			if `groupCount' == 4 return local color "43 123 182"
		}
		else {

			*For five or more colors we repeat the same pattern

			local colorNum = mod(`groupCount', 5)
			if `colorNum' == 1 return local color "215 25 28"
			if `colorNum' == 2 return local color "253 174 93"
			if `colorNum' == 3 return local color "255 255 191"
			if `colorNum' == 4 return local color "171 217 233"
			if `colorNum' == 0 return local color "43 123 182"

		}

	end

	*******************************************
	*******************************************
		******* Grayscale Option *******
		******* Colour Picker    *******
	*******************************************
	*******************************************

	cap	program drop	grayPicker
		program define 	grayPicker , rclass

		args groupCount totalNumGroups

		if `groupCount' == 1 {

			return local color "black"
		}

		else if `groupCount' == 2 & `totalNumGroups' <= 3 {

			return local color "gs14"
		}
		else {

			local grayscale =  round( (`groupCount'-1) * (100 / (`totalNumGroups'-1) ))

			return local color "`grayscale' `grayscale' `grayscale' `grayscale'"
		}

	end

	*******************************************
	*******************************************
		******* Test if valid  *******
		******* dummies 	   *******
	*******************************************
	*******************************************

	cap program drop 	testDums
		program define	testDums

		unab dumlist : `0'

		foreach dumvar of varlist `dumlist' {

			*Test: all values dummies (missing would have been excluded in regression and we keep if e(sample)
			cap assert inlist(`dumvar',0,1)
			if _rc {
				noi display as error "{phang} The variable `dumvar' is not a dummy. Treatment variable needs to be a dummy (0 or 1) variable. {p_end}"
				noi display ""
				error 149
			}
		}

		/*What we are testing for below:
			- We count the number of dummies that each obervation has the value 1 for.
			- The count numbers must either fit the case of diff-in-diff or the case of regression with one dummy for each treatment arms

			Regular regression with one dummy for each treatment arm
			- Some observations don't have 1 for any dummy - omitted control observations
			- No observation has the value 1 in more than one observation - can't be in more than one treatment group
			- No treatment group can have no observation with value 1 for that dummy

			Diff-in-Diff
			- Some observations don't have 1 for any dummy - omitted controls observations in time = 0
			- Some observation must have value 1 for only the treatment dummy - treatment observations in time = 0
			- Some observation must have value 1 for only the time dummy - control observations in time = 1
			- Some observation must have value 1 for in all three of time, treatment and interaction dummy - treatment observations in time = 1

		*/

		*Count how many dummies is 1 for each observation
		tempvar  dum_count
		egen 	`dum_count' = rowtotal(`dumlist')

		*Exactly one dummy is 1, meaning this observation is in one of the treatment arms
		count if `dum_count' == 1
		local dum_count_1 `r(N)'

		*No dummies is 1, meaning this observation is control
		count if `dum_count' == 0
		local dum_count_0 `r(N)'

		*Exactly 3 dummies are three. Only allowed in the exact case of diff-and-diff regressions
		count if `dum_count' == 3
		local dum_count_3 `r(N)'

		*Exactly 2 or more than three is never correct.
		count if `dum_count' == 2 | `dum_count' > 3
		local dum_count_2orgt3 `r(N)'

		*Test that there are at least some treatment observations
		if `dum_count_0' == 0 		noi di as error "{phang} There are no control observations. One category must be omitted and it should be the omitted category in the regression. The omitted category will be considerd the control group. See helpfile for more info. Disable this test by using option ignoredummytest.{p_end}"
		if `dum_count_0' == 0 		error 480

		*Test that there are at least some control observations (this error should be caught by dummies omitted in the regression)
		if `dum_count_1' == 0 		noi di as error "{phang} There are no treatment observations. None of the dummies have observations for which the dummy has the value 1. See helpfile for more info. Disable this test by using option ignoredummytest.{p_end}"
		if `dum_count_1' == 0 		error 480

		*Test if there are any observations that have two or more than three dummies that is 1
		if `dum_count_2orgt3' > 0 	noi di as error "{phang} There is overlap in the treatment dummies. The dummies must be mutually exclusive meaning that no observation has the value 1 in more than one treatment dummy. The exception is when you use a diff-and-diff, but this dummies is not a valid diff and diff. See helpfile for more info. Disable this test by using option ignoredummytest.{p_end}"
		if `dum_count_2orgt3' > 0 	error 480

		*After passing the previous two steps, test if there are cases that are only allowed in diff
		if `dum_count_3' > 0 {

			*Diff-and-diff must have exactly 3 dummies
			if `:list sizeof dumlist' != 3 	noi di as error "{phang} There is overlap in the treatment dummies. The dummies must be mutually exclusive meaning that no observation has the value 1 in more than one treatment dummy. The exception is when you use a diff-and-diff, but this dummies is not a valid diff and diff. See helpfile for more info. Disable this test by using option ignoredummytest.{p_end}"
			if `:list sizeof dumlist' != 3 	error 480

			* Test if valid diff-diff
			testDumsDD `dum_count' `dumlist'
		}

	end

	cap program drop 	testDumsDD
		program define	testDumsDD

		local dum_count `1'

		**Test that for only two of three dummies there are observations
		* that has only that dummy. I.e. the two that is not the
		* interaction. If the interaction is 1, all three shluld be 1.

		*Count how many dummies the condition is above applies to
		local counter 0

		*Loop over all dummies
		forvalues i = 2/4 {

			*Test the number
			count if ``i'' == 1 & `dum_count' == 1
			if `r(N)' > 0 local ++counter

		}
		*Count that exactly two dummies fullfilled the condition
		if `counter' != 2	noi di as error "{phang} There is overlap in the treatment dummies. The dummies must be mutually exclusive meaning that no observation has the value 1 in more than one treatment dummy. The exception is when you use a diff-and-diff, but this dummies is not a valid diff and diff. See helpfile for more info. Disable this test by using option ignoredummytest.{p_end}""
		if `counter' != 2	error 480

	end

	* Test inputs for label
	cap prog drop sizename
 		prog def sizename, rclass

		args name

		capture findfile gsize-`name'.style

		if ( _rc == 601 ) {

			noi di "{phang} WARNING: Option mlabsize() was incorrectly specified. Only {help textsizestyle} values are accepted. Default size used.{p_end}"
			return local 	LABEL_SIZE 	0
		}

	end

	cap prog drop colorname
		prog def colorname, rclass

		args name

		capture findfile color-`name'.style

		if ( _rc == 601 ) {

			noi di "{phang} WARNING: Option mlabcolor() was incorrectly specified. Only named colors in {help colorstyle} are accepted. Default color used.{p_end}"
			return local 	LABEL_COL 	0
		}

	end


	cap prog drop clockname
		prog def clockname, rclass

		args name

		capture findfile clockdir-`name'.style

		if ( _rc == 601 ) {

			noi di "{phang} WARNING: Option mlabposition() was incorrectly specified. Only {help clockposstyle} values are accepted. Default position used.{p_end}"
			return local 	LABEL_POS 	0
		}

	end
