*! version DEVELOP 5SEP2019 Matteo Ruzzante mruzzante@worldbank.org
	
	cap prog drop    iekdensity
		prog define  iekdensity
		
		syntax 		 varname(numeric) [if] [in] [aw fw iw] , 	/// Specify outcome variable (only fweights, aweights, and iweights are allowed in original kdensity command)
																///
			TREATvar(varname numeric)							/// Specify treatment variable (must  be binary) -- next step: allow for factor variable
																///
		   [													///
		    treatcolor(string)									/// Choose color for treatment
		    controlcolor(string)								/// Choose color for control -- can be combined in a single option, like 'color(value1 color1 @ value2 color2)'
																///
		    stat(string)										/// Add lines with (one) statistic
		    statstyle(string)									/// Lines style. Default is dashed pattern.
																///
		    effect												/// Add note with treatment effect (beta, SD, and p-value)
		    effectformat(string)								/// Format of treatment treatment effect. Default is "%9.3f".
		    ABSorb(varname numeric)								/// Strata variable
		    REGressionoptions(string)							/// Allows any normal options for linear regressions
																///
		    KDENSITYoptions(string)								/// Allows kernel options (namely [kernel], [bwidth], [n], and all the [cline_options]) for univariate kernel density estimation
		    GRaphoptions(string)								/// Allows any normal options for twoway graphs
		   ]
		   
/*******************************************************************************
	Prepare settings
*******************************************************************************/
		
		qui {
		
			// Set minimum version for this command
			version 11
			
			// Preserve current dataset
			preserve
							
			// Remove observations excluded by if and in conditions
			marksample touse, novarlist
			keep if   `touse'
			
/*******************************************************************************
	Prepare optional options
*******************************************************************************/			
			
/*------------------------------------------------------------------------------
	Color options
------------------------------------------------------------------------------*/

			// If no [color] is specified, keep standard Stata color palette.
			// Otherwise, set user-specified colors
			
			* For treatment group
			if  missing("`treatcolor'") {
				local color_1 maroon
			}
			else {
				local color_1 `treatcolor'
			}
			
			* For control group
			if  missing("`controlcolor'") {
				local color_0 navy
			}
			else {
				local color_0 `controlcolor'
			}
				
/*------------------------------------------------------------------------------
	Stat options
------------------------------------------------------------------------------*/
				
				
			*******************************************
			* Test that option was correctly specified
			*******************************************
			
			// If no [stat] is specified, option [statstyle] also shouldn't be
			if missing("`stat'") & !missing("`statstyle'") {
				
				noi di as error "{bf:statstyle()} requires the option {bf:stat()} to be specified."
				noi di as error "If you want to use {bf:statstyle()}, you need to include the option {bf:stat()} too."
						  exit 
				
			}
			// If no [stat] is specified, do not attach any vertical line in the plot
			else if missing("`stat'") {
				
				local STATxline ""
				
			}
			// If [stat] option is specified, add option to graph vertical lines
			else if !missing("`stat'") {
			
				local statsList 	 mean min max p1 p5 p10 p25 p50 p75 p90 p95 p99
				
				foreach possibleStat of local statsList {
				
					local statIfList     `"`statIfList' "`stat'", "'
					local statBoldString `"`statBoldString' {bf:`possibleStat'},"'
					
				}
				
				// Check that the stat is among possible statistics
				if !inlist("`stat'", `statIfList') {
					
					noi di as error "The {bf:stat} you selected cannot be shown in the graph."
					noi di as error "The available statistics are:`statBoldString'."
							  exit	
				}			
				else {
					
					// Summarize variable and store locals with defined value
					sum	  `varlist' if `treatvar' == 0 , d
					local `varlist'_0 = `r(`stat')'
					
					sum	  `varlist' if `treatvar' == 1 , d
					local `varlist'_1 = `r(`stat')'
				}
				
				if missing("`statstyle'") {
				
					// In the absence of [statstyle], we only use the 'dash' patttern
					local STATxline `" xline( ``varlist'_0' , lcolor(`color_0'%80) lpattern(dash) ) xline(``varlist'_1' , lcolor(`color_1'%80) lpattern(dash) ) "'
					
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
						local STATxline `" xline( ``varlist'_0' , lcolor(`color_0'%80) `statstyle' ) xline(``varlist'_1' , lcolor(`color_1'%80) `statstyle' ) "'
					}
					
					set graphics on
				}
				
			}
				
/*------------------------------------------------------------------------------
	Treatment effect options
------------------------------------------------------------------------------*/

				// If [effectnote], [absorb], or [regressoptions] option is specified, check that [effect] was specified
				if "`effect'" == "" {
					
					foreach effectOption in effectnote absorb regressoptions {
					
						if "``effectOption''" != "" {
								
							noi di as error "{bf:`effectOption'()} requires the option {bf:effect} to be specified."
							noi di as error "If you want to use {bf:`effectOption'()}, you need to include the option {bf:effect} too."
									  exit 
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

							di as error "{phang}The format specified in effectformat(`effectformat') is not a valid Stata format. See {help format} for a list of valid Stata formats. This command only accept the f, fc, g, gc and e format.{p_end}"
							error 120
						}
						else if _rc != 0 {

							di as error "{phang}Something unexpected happened related to the option format(`format'). Make sure that the format you specified is a valid format. See {help format} for a list of valid Stata formats. If this problem remains, please report this error to mruzzante@worldbank.org.{p_end}"
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
								di as error "{phang}The format specified in effectformat(`effectformat') is not allowed. Only format f, fc, g, gc and e are allowed. See {help format} for details on Stata formats.{p_end}"
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
					
					// Estimate treatment effect
					if "`absorb'" == "" {
						reg  `varlist' `treatvar' [`weight'`exp'] , `regressionoptions'
					}
					
					// If there are strata, estimate treatment effect controlling for strata
					if "`absorb'" != "" {
					
						areg `varlist' `treatvar' [`weight'`exp'] , `regressionoptions' abs(`absorb') 
					}
					
					// Store estimated coefficient, standard error, p-value, and number of observations
					mat   results = r(table)
					local beta	  = string( _b[`treatvar'] , "`TEformat'")
					local se	  = string(_se[`treatvar'] , "`TEformat'")
					local pvalue  = results[4, 1]
					
					local obs	  = e(N)
					
					* Add level of statistical significance
					local stars     ""
					
					foreach signLevel in 0.1 0.05 0.01 {

						if `pvalue' < `signLevel' local stars "`stars'*"
					}
					
					local EFFECTnote " note(Treatment effect = `beta' (`se')`stars'. N = `obs'.) "
				}
			}
			
			// Record outcome variable label to be shown as x-axis title
			local varLab : var label `varlist'
		
/*******************************************************************************
	Plot the figure!
*******************************************************************************/

		tw  (kdensity `varlist' if `treatvar' == 0 [`weight'`exp'] , `kdensityoptions' color(`color_0') ) ///
			(kdensity `varlist' if `treatvar' == 1 [`weight'`exp'] , `kdensityoptions' color(`color_1') ) ///
			, 																							  ///			 
			`STATxline' 																				  ///
			`EFFECTnote' 																				  ///
			ytitle	(Density) 																			  ///
			xtitle	(`varLab') 																			  ///
			legend	(order(0 "Treatment assignment:" 1 "Control" 2 "Treatment") 						  ///
					 row(1) 																			  ///
					) 																					  ///	   
			`graphoptions'

		// Restore original dataset
		restore
	
	// End
	end

	// And now, you shall plot the distributions! ;)
	