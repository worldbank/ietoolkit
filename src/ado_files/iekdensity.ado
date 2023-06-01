*! version 7.2 04APR2023 DIME Analytics dimeanalytics@worldbank.org

	cap prog drop    iekdensity
		prog define  iekdensity

		syntax 		 varname(numeric) [if] [in] [aw fw iw] , 	/// Specify outcome variable (only fweights, aweights, and iweights are allowed in original [kdensity] command)
																///
			by(varname numeric)									/// Specify treatment variable
																///
		   [													///
		    color(string)										/// Specify string of colors
																///
		    stat(string)										/// Add lines with (one) statistic
		    statstyle(string)									/// Lines style. Default is dashed pattern.
																///
		    effect												/// Add note with treatment effect (beta, SD, and p-value)
		    control(numlist int max=1)							/// Specify value of control variable -- for comparisons
			effectformat(string)								/// Format of treatment treatment effect. Default is "%9.3f".
		    ABSorb(varname numeric)								/// Strata variable
		    REGressionoptions(string)							/// Allows any normal options for linear regressions
																///
		    KDENSITYoptions(string)								/// Allows kernel options (namely [kernel], [bwidth], [n], and all the [cline_options]) for univariate kernel density estimation
			*													/// * Allows any normal options for twoway graphs
		   ]

/*******************************************************************************
	Prepare settings
*******************************************************************************/

		qui {

			// Set minimum version for this command
			version 12

			// Preserve current dataset
			preserve

			// Remove observations excluded by if and in conditions
			marksample touse, novarlist
			keep if   `touse'

			**************************************************
			* Check if treatment variable is binary or factor
			**************************************************

			// Remove observations with a missing value in treatvar()
			drop if    missing(`by')

			// Create a local of all codes in treatvar()
			levelsof  		   `by'			, local(treatvar_levels)

			// Saving the name of the value label of the treatvar()
			local 	   treatvar_value_label : value label `by'

			// Counting how many levels there are in by()
			local 	   treatvar_num_groups  : word  count `treatvar_levels'

/*------------------------------------------------------------------------------
	Check that the treatment variable is a valid categorical variable
------------------------------------------------------------------------------*/
{
			cap confirm numeric variable `by'

			if _rc != 0 {

				noi di as error "{phang}The variable listed in by(`by') is not a numeric variable. See {help encode} for options on how to make a categorical string variable into a categorical numeric variable{p_end}"
						  error 108
			}

			else {

				** Testing that by is a categorical variable. Int() rounds to
				* integer, and if any values are non-integers then (int(`by') == `by') is
				* not true
				cap assert ( int(`by') == `by' )
				if _rc == 9 {
					noi di as error  "{phang}The variable in by(`by') is not a categorical variable. The variable may only include integers where each integer indicates which group each observation belongs to. See tabulation of `by' below:{p_end}"
					noi 	  tab  `by', nol
							  error 109
				}
			}
}

/*******************************************************************************
	Prepare optional options
*******************************************************************************/
/*------------------------------------------------------------------------------
	Color options
------------------------------------------------------------------------------*/
{
			// If no [color] is specified, keep standard Stata color palette.
			// Otherwise, set user-specified colors
			if	missing("`color'") {

				set scheme s2color

				local 	  treatvar_count = 0

				foreach   treatvar_num of local treatvar_levels {

					if 	 `treatvar_count' == 0 local color_`treatvar_num' "navy"
					if 	 `treatvar_count' == 1 local color_`treatvar_num' "maroon"
					if 	 `treatvar_count' == 2 local color_`treatvar_num' "forest_green"
					if 	 `treatvar_count' == 3 local color_`treatvar_num' "dkorange"
					if   `treatvar_count' == 4 local color_`treatvar_num' "teal"
					if	 `treatvar_count' == 5 local color_`treatvar_num' "cranberry"

					local treatvar_count = `treatvar_count' + 1
				}
			}

			if !missing("`color'") {

				// Check that the number of colors specified matches
				local color_num_groups : word count `color'

				// If it is smaller or larger, we throw an error
				if   `color_num_groups' > `treatvar_num_groups' {

					  noi di as error "{phang}The number of colors you specified in {bf:color()} is higher than the number of categories in the treatment variable {bf:by()}.{p_end}"
					  noi di as error "{phang}Please define one color for each category.{p_end}"
					  noi di 		  ""
								error 198
				}

				if   `color_num_groups' < `treatvar_num_groups' {

					  noi di as error "{phang}The number of colors you specified in {bf:color()}  is smaller than the number of categories in the treatment variable {bf:by()}.{p_end}"
					  noi di as error "{phang}Please define one color for each category.{p_end}"
					  noi di 		  ""
							    error 198
				}

				else {

					// Put colors in correct local for the graph
					local colorNum = 1

					foreach   treatvarNum of local treatvar_levels {

						local treatvar_`treatvarNum' 		 = word("`treatvar_levels'" , `colorNum')

						local color_`treatvar_`treatvarNum'' = word("`color'"		    , `colorNum')

						local colorNum = `colorNum' + 1
					}
				}
			}
}
/*------------------------------------------------------------------------------
	Control options
------------------------------------------------------------------------------*/
{
			// If control() is used, test that the value specified exists in the [by]
			local control_correct : list control in treatvar_levels

			if   `control_correct' == 0 {

				  noi di as error "{phang}The code listed in {bf:control(`control')} is not used in {bf:by(`by')}. See tabulation of {it:`by'} below:{p_end}"
				  noi tab  `by', nol
				  noi di 		  ""
							error 197
			}
}
/*------------------------------------------------------------------------------
	Treatment effect options
------------------------------------------------------------------------------*/
{
			// If [effectnote], [absorb], or [regressoptions] option is specified, check that [effect] was specified
			if "`effect'" == "" {

				foreach effectOption in effectnote absorb regressoptions {

					if "``effectOption''" != "" {

						noi di as error "{phang}{bf:`effectOption'()} requires the option {bf:effect} to be specified.{p_end}""
						noi di as error "{phang}If you want to use {bf:`effectOption'()}, you need to include the option {bf:effect} too.{p_end}"
						noi di 		    ""
								  error 198
					}
				}

				// If no [effect] is specified, do not attach any note with the effect
				local EFFECTnote ""
			}

			// If [effect] option is specified, add option to include note
			if "`effect'" != "" {

				// If format is specified, check that it is possible
				if "`effectformat'" != "" {

					// ------------------------------------------------
					// The procedure below is taken from 'iebaltab.ado'

					** Creating a numeric mock variable that we attempt to apply the format
					*  to. This allows us to piggy back on Stata's internal testing to be
					*  sure that the format specified is at least one of the valid numeric
					*  formats in Stata
						tempvar  formattest
						gen 	`formattest' = 1
					cap	format  `formattest' `effectformat'

					if _rc == 120 {

						noi di as error "{phang}The format specified in effectformat(`effectformat') is not a valid Stata format. See {help format} for a list of valid Stata formats. This command only accept the f, fc, g, gc and e format.{p_end}"
						noi di 		    ""
							      error 120
					}
					else if _rc != 0 {

						noi di as error "{phang}Something unexpected happened related to the option format(`format'). Make sure that the format you specified is a valid format. See {help format} for a list of valid Stata formats. If this problem remains, please report this error to mruzzante@worldbank.org.{p_end}"
						noi di 		    ""
							      error _rc
					}
					else {
						** We know here that the format is one of the numeric formats that Stata allows

						local formatAllowed 0
						local charLast  = substr("`effectformat'", -1, .)
						local char2Last = substr("`effectformat'", -2, .)

						if  "`charLast'" == "f" | "`charLast'" == "e" {
							local formatAllowed 1
						}
						else if "`charLast'" == "g"  {
							if "`char2Last'" == "tg" {
								*format tg not allowed. all other valid formats ending on g are allowed
								local formatAllowed 0
							}
							else {

								*Formats that end in g that is not tg can only be g which is allowed.
								local formatAllowed 1
							}
						}
						else if  "`charLast'" == "c" {
							if "`char2Last'" != "gc" & "`char2Last'" != "fc" {
								*format ends on c but is neither fc nor gc
								local formatAllowed 0
							}
							else {

								*Formats that end in c that are either fc or gc are allowed.
								local formatAllowed 1
							}
						}
						else {
							*format is neither f, fc, g, gc nor e
							local formatAllowed 0
						}
						if `formatAllowed' == 0 {
							di as error "{phang}The format specified in {bf:effectformat(`effectformat')} is not allowed. Only format f, fc, g, gc and e are allowed. See {help format} for details on Stata formats.{p_end}"
							noi di 		""
								  error 120
						}
						*If format passed all tests, store it in the local used for display formats
						local TEformat  "`effectformat'"
					}

					// ------------------------------------------------
				}

				if "`effectformat'" == "" {

					// Otherwise, we will use "%9.3f"
					local TEformat  "%9.3f"
				}

				// Standard case with binary treatment
				// -----------------------------------
				if `treatvar_num_groups' == 2 {

					if "`treatvar_levels'" == "0 1" & missing("`control'") {

						// Estimate treatment effect
						if "`absorb'" == "" {
							reg  `varlist' `by' [`weight'`exp'] , `regressionoptions'
						}

						// If there are strata, estimate treatment effect controlling for strata
						if "`absorb'" != "" {

							areg `varlist' `by' [`weight'`exp'] , `regressionoptions' abs(`absorb')
						}

						// Store estimated coefficient, standard error, p-value, and number of observations
						mat   results = r(table)
						local beta	  = string( _b[`by'] , "`TEformat'")
						local se	  = string(_se[`by'] , "`TEformat'")
						local pvalue  = results[4, 1]

						local obs	  = e(N)

						// Add level of statistical significance
						local stars     ""

						foreach signLevel in 0.1 0.05 0.01 {

							if `pvalue' < `signLevel' local stars "`stars'*"
						}

						local EFFECTnote " note(Treatment effect = `beta' (`se')`stars'. N = `obs'.) "
					}

					// If the values are not 0/1 and no [control] is specified, signal this to the user
					else if "`treatvar_levels'" != "0 1" & missing("`control'") {

							noi di as error "{phang}The treatment variable in {bf:by()} is not a 0/1 dummy variable. See tabulation of {it:`by'} below.{p_end}""
							noi di as error "{phang}If you want to compute the treatment effect, you need to indicate which value is referred to the control group using the option {bf:control()}.{p_end}"
							noi tab  `by', nolab
							noi di 		    ""
									  error 198
					}

					else if !missing("`control'") {

						// When the binary variable is not 0/1, recode variable to be 0/1, depending on the control specified
						tempvar  treatmentAux
						gen	    `treatmentAux' = 0 if `by' == `control' & !mi(`by')
						replace `treatmentAux' = 1 if `by' != `control' & !mi(`by')

						// New levels of new treatment variable
						levelsof `treatmentAux' , local(treatvarAux_levels)

						if "`absorb'" == "" {

							reg  `varlist' `treatmentAux' [`weight'`exp'] , `regressionoptions'
						}

						if "`absorb'" != "" {

							areg `varlist' `treatmentAux' [`weight'`exp'] , `regressionoptions' abs(`absorb')
						}

						mat   results = r(table)
						local beta	  = string( _b[`treatmentAux'] , "`TEformat'")
						local se	  = string(_se[`treatmentAux'] , "`TEformat'")
						local pvalue  = results[4, 1]

						local obs	  = e(N)

						local stars     ""

						foreach signLevel in 0.1 0.05 0.01 {

							if `pvalue' < `signLevel' local stars "`stars'*"
						}

						local EFFECTnote " note(Treatment effect = `beta' (`se')`stars'. N = `obs'.) "
					}
				}

				// Case with factor variables
				// --------------------------
				if `treatvar_num_groups'  > 2 {

					// In this case, the control value must be specified
					if  missing("`control'") {

						noi di as error "{phang}The treatment variable in {bf:treatvar()} is a factor variable. See tabulation of {it:`by'} below.{p_end}"
						noi di as error "{phang}If you want to compute the treatment effect, you need to indicate which value is referred to the control group using the option {bf:control()}.{p_end}"
						noi tab  `by', nolab
						noi di 		    ""
								  error 198
					}

					if !missing("`control'") {

						// Local with values of [control] and other than [control]
						levelsof `by' if `by' == `control', local(treatvar_control)
						levelsof `by' if `by' != `control', local(treatvar_comparison)

						// Generate new treatment factor variable
						tempvar  treatmentAux
						gen 	`treatmentAux' = 0 if `by' == `control'	// equal to 0 for the control group

						local    treatvarCount = 0
						foreach  treatvarNum of local treatvar_comparison {

							local    treatvarCount = `treatvarCount' + 1		// and going from 1 to the total number of treatment arms for the rest
							replace `treatmentAux' = `treatvarCount' if `by' == `treatvarNum'
						}

						// Transfer labels from original variable
						local    treatvarCount = 0
						local 	 treatvarLab_`treatvarCount' : label (`by') `treatvar_control'
						di	   "`treatvarLab_`treatvarCount''"
						lab def  treatvarLab `treatvarCount' "`treatvarLab_`treatvarCount''", replace

						foreach  treatvarNum of local treatvar_comparison {

							local treatvarCount = `treatvarCount' + 1

							local treatvarLab_`treatvarCount' : label (`by') `treatvarNum'

							lab   def treatvarLab `treatvarCount' "`treatvarLab_`treatvarCount''", add
						}

						lab val  `treatmentAux'   treatvarLab

						// Final levels of new treatment variable
						levelsof `treatmentAux' , local(treatvarAux_levels)

						// Run regression with control as base group
						if "`absorb'" == "" {

							reg  `varlist' ib0.`treatmentAux' [`weight'`exp'] , `regressionoptions'
						}

						if "`absorb'" != "" {

							areg `varlist' ib0.`treatmentAux' [`weight'`exp'] , `regressionoptions' abs(`absorb')
						}

						mat   results = r(table)

						// Store estimates for each treatment
						forv  estimateNum = 1/`treatvarCount' {

							local resultsMatCol = `estimateNum' + 1 //the first column of the matrix is left for the base group, i.e., the control

							local   beta`estimateNum' = string(results[1, `resultsMatCol'], "`TEformat'")
							local     se`estimateNum' = string(results[2, `resultsMatCol'], "`TEformat'")
							local pvalue`estimateNum' = 	   results[4, `resultsMatCol']

							local  stars`estimateNum'   ""

							foreach signLevel in 0.1 0.05 0.01 {

								if `pvalue`estimateNum'' < `signLevel' local stars`estimateNum' "`stars`estimateNum''*"
							}
						}

						local obs = e(N)

						// Stack each effect in a single note
						forv  estimateNum = 1/`treatvarCount' {

							if	`estimateNum' == 1 {
								local EFFECTnote 				   "  [`by' == `estimateNum'] `beta`estimateNum'' (`se`estimateNum'')`stars`estimateNum'';"
							}
							else {
								local EFFECTnote `" "`EFFECTnote'" "  [`by' == `estimateNum'] `beta`estimateNum'' (`se`estimateNum'')`stars`estimateNum'';" "'
							}
						}

						local EFFECTnote `" note("{bf:Treatment effects} =" `EFFECTnote' "  N = `obs'.") "'
					}
				}
			}
}
/*------------------------------------------------------------------------------
	Stat options
------------------------------------------------------------------------------*/
{
			*******************************************
			* Test that option was correctly specified
			*******************************************

			// If no [stat] is specified, option [statstyle] also shouldn't be
			if missing("`stat'") & !missing("`statstyle'") {

				noi di as error "{phang}{bf:statstyle()} requires the option {bf:stat()} to be specified.{p_end}"
				noi di as error "{phang}If you want to use {bf:statstyle()}, you need to include the option {bf:stat()} too.{p_end}"
				noi di 		    ""
						  error 198

			}
			// If no [stat] is specified, do not attach any vertical line in the plot
			else if  missing("`stat'") {

				local STATxline ""

			}
			// If [stat] option is specified, add option to graph vertical lines
			else if !missing("`stat'") {

				local statIfList 	 ""
				local statBoldString ""
				local statsList		 mean min max p1 p5 p10 p25 p50 p75 p90 p95 p99

				foreach possibleStat of local statsList 	{

					local statIfList	 `" `statIfList' "`stat'" != "`possibleStat'" & "'
					local statBoldString `"`statBoldString' {bf:`possibleStat'},"'

				}

				// Remove final comma
				local statBoldString = substr("`statBoldString'", 1, length("`statBoldString'") - 1)

				// Check that the stat is among possible statistics
				if `statIfList' "ok" == "ok" {

					noi di as error "{phang}The {bf:stat()} you selected cannot be shown in the graph.{p_end}"
					noi di as error "{phang}The available statistics are:`statBoldString'.{p_end}"
					noi di 		    ""
							  error 198
				}

				else {

					// Summarize variable and store locals with defined value
					// Distinguish normal case from case using controls which switched the order of the treatment groups
					if (`treatvar_num_groups' == 2 & !missing("`control'")) | (`treatvar_num_groups' > 2 & "`effect'" != "") {

						foreach    varNum of local treatvarAux_levels {

							sum   `varlist' if `treatmentAux' == `varNum' , d
							local `varlist'_`varNum' = `r(`stat')'
						}
					}

					else {

						foreach    varNum of local treatvar_levels {

							sum   `varlist' if `by' == `varNum' , d
							local `varlist'_`varNum' = `r(`stat')'
						}
					}
				}

				if missing("`statstyle'") {

					// In the absence of [statstyle], we only use the 'dash' patttern
					local 	  STATxline ""

					foreach   varNum of local treatvar_levels {

						local STATxline `" `STATxline' xline( ``varlist'_`varNum'' , lcolor(`color_`varNum''%80) lpattern(dash) ) "'
					}
				}

				else if !missing("`statstyle'") {

					// Check that [statstyle] is correctly specified
					set graphics off //we set graphics off as the option [nograph] is conflicting with [xline]
					cap kdensity `varlist' , xline( ``varlist'_0' , `statstyle' )

					if _rc != 0 {

						set graphics on

						// If it's not, replot the kernel density, which will automaticallty show the underlying error
						kdensity `varlist' , xline( ``varlist'_0' , `statstyle' )
					}
					else {

						// Store local with [xline] option to be graphed
						local 	  STATxline ""

						foreach   varNum of local treatvar_levels {

							local STATxline `" `STATxline' xline( ``varlist'_`varNum'' , lcolor(`color_`varNum''%80) `statstyle' ) "'
						}
					}

					set graphics on
				}
			}
}

/*******************************************************************************
	Prepare figure inputs
*******************************************************************************/
{
			// If the treatment variable has no defined label, we leave the value in the legend
			if  missing("`treatvar_value_label'") {

				//Multiple treatment case with effect option and control specified
				if `treatvar_num_groups' > 2 & "`effect'" != "" {

					foreach treatvarNum of local treatvarAux_levels {

						local label_`treatvarNum' "`treatvarNum'"
					}
				}

				//Other cases
				else {

					foreach treatvarNum of local treatvar_levels {

						local label_`treatvarNum' "`treatvarNum'"
					}
				}
			}

			// If the treatmnet variable has labels, we will display it in the legend
			if !missing("`treatvar_value_label'") {

				if `treatvar_num_groups' > 2 & "`effect'" != "" {

					foreach treatvarNum of local treatvarAux_levels {

						local label_`treatvarNum' : label (`treatmentAux') `treatvarNum'
					}
				}

				else {

					foreach treatvarNum of local treatvar_levels {

						local label_`treatvarNum' : label (`by')     `treatvarNum'
					}
				}
			}

			// Prepare [kdensity] code and legend argument
			local kdensityString  "tw"
			local 	legendString `"legend(order(0 "Treatment assignment:" "'

			if (`treatvar_num_groups' == 2 & !missing("`control'")) | (`treatvar_num_groups' > 2 & "`effect'" != "") {

				local   treatCount = 0
				foreach treatvarNum of local treatvarAux_levels {

					local treatCount	  = `treatCount' + 1

					local kdensityString `" `kdensityString' (kdensity `varlist' if `treatmentAux' == `treatvarNum' [`weight'`exp'] , `kdensityoptions' color(`color_`treatvarNum'') ) "'

					local   legendString `"   `legendString' `treatCount' "`label_`treatvarNum''" "'
				}
			}

			else {

				local   treatCount = 0
				foreach treatvarNum of local treatvar_levels {

					local treatCount	  = `treatCount' + 1

					local kdensityString `" `kdensityString' (kdensity `varlist' if `by' == `treatvarNum' [`weight'`exp'] , `kdensityoptions' color(`color_`treatvarNum'') ) "'

					local   legendString `"   `legendString' `treatCount' "`label_`treatvarNum''" "'
				}
			}

			// Add final parenthesis and number of rows (this can be changed by the user through graphoptions()
			if   `treatvar_num_groups' == 2 		 local rowString "row(1)"

			local legendString         `" `legendString') `rowString' )"'

			// Record outcome variable label to be shown as x-axis title
			local varLab 				: var label `varlist'
}
	}

/*******************************************************************************
	Plot the figure!
*******************************************************************************/

		`kdensityString' 		///
		 , 						///
		`STATxline' 			///
		`EFFECTnote' 			///
		`legendString'			///
		 ytitle(Density) 		///
		 xtitle(`varLab')		///
		`options'

		// Restore original dataset
		restore

	// End
	end

	// And now, you shall plot the distributions! ;)
