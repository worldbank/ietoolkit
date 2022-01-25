*! version 6.3 5NOV2019 DIME Analytics dimeanalytics@worldbank.org

	capture program drop iebaltab,
	program define iebaltab, rclass

		syntax varlist(numeric) [if] [in] [aw fw pw iw],                    ///
                                                                        ///
				/*Group variable*/                                              ///
				GRPVar(varname)                                                 ///
				[                                                               ///
				/*Columns and order of columns*/                                ///
				ORder(numlist int min=1) COntrol(numlist int max=1) TOTal       ///
                                                                        ///
				/*Column and row labels*/                                       ///
				GRPCodes GRPLabels(string) TOTALLabel(string) ROWVarlabels      ///
				ROWLabels(string) onerow                                        ///
				                                                                ///
				/*Statistics and data manipulation*/                            ///
				FIXedeffect(varname) COVariates(varlist ts fv) 						      ///
				vce(string)              ///
				WEIGHTold(string)                                               ///
				                                                                ///
				/*F-test and  FEQTest*/                                   ///
				FTest FMissok FEQTest	                                     ///
				                                                                ///
				/*Output display*/                                              ///
				pairoutput(string) ftestoutput(string)  ///
				feqtestoutput(string)  STDev              ///
				STARlevels(numlist descending min=3 max=3 >0 <1)			          ///
				STARSNOadd FORMat(string) TBLNote(string) TBLNONote	///
				                                                                ///
				/*Export and restore*/                                          ///
				SAVEXlsx(string) SAVECsv(string) SAVETex(string) TEXNotewidth(numlist min=1 max=1)  ///
				TEXCaption(string) TEXLabel(string) TEXDOCument	texvspace(string) ///
				texcolwidth(string) REPLACE BROWSE                         ///
				                                                                ///
				/*Deprecated options
				  - still included to throw helpful error if ever used */       ///
				 SAVEBRowse BALMISS(string) BALMISSReg(string)            ///
				COVMISS(string) COVMISSReg(string) MISSMINmean(string) COVARMISSOK  SAVE(string) NOTtest	///
				NORMDiff	PTtest	PFtest	PBoth NOTECombine ///
				///Deprecated options still to handle:
				]



		********HELPFILE TODO*********
		*1. Explain difference in se between group by itself and the standard errors used in the t-test

	preserve
qui {

	/***********************************************
	************************************************

		Version, weight and if/in sample

	*************************************************
	************************************************/

	*Set minimum version for this command
	version 12

	* Backwards compatibility for weight option
		if "`weightold'" != "" & "`exp'" == "" {
			tokenize `weightold', parse(=)
			local weight "`1'"
			local exp = "= `3'"
		}

		*Remove observations excluded by if and in
		marksample touse,  novarlist
		keep if `touse'

	/***********************************************
	************************************************

		Set initial constants

	*************************************************
	************************************************/

		*Create local for balance vars with more descriptive name
		local balancevars `varlist'

		tempname rmat fmat


	** Column Options

		*Is option control() used:
		if "`control'" 			== "" local CONTROL_USED = 0
		if "`control'" 			!= "" local CONTROL_USED = 1

		*Is option order() used:
		if "`order'" 			== "" local ORDER_USED = 0
		if "`order'" 			!= "" local ORDER_USED = 1

		*Is option grpcodes used:
		if "`grpcodes'"			== "" local NOGRPLABEL_USED = 0
		if "`grpcodes'" 		!= "" local NOGRPLABEL_USED = 1

		*Is option nolabel used:
		if "`grplabels'" 		== "" local GRPLABEL_USED = 0
		if "`grplabels'" 		!= "" local GRPLABEL_USED = 1

		*Is option total() used:
		if "`total'" 			== "" local TOTAL_USED = 0
		if "`total'" 			!= "" local TOTAL_USED = 1

		*Is option totallable() used:
		if "`totallabel'" 		== "" local TOTALLABEL_USED = 0
		if "`totallabel'" 		!= "" local TOTALLABEL_USED = 1


	** Row Options

		*Is option total() used:
		if "`rowvarlabels'" 	== "" local ROWVARLABEL_USED = 0
		if "`rowvarlabels'" 	!= "" local ROWVARLABEL_USED = 1

		*Is option totallable() used:
		if "`rowlabels'" 		== "" local ROWLABEL_USED = 0
		if "`rowlabels'" 		!= "" local ROWLABEL_USED = 1

		*Is option totallable() used:
		if "`onenrow'" 			!= "" local onerow = "onerow" //Old name still supported for backward compatibility
		if "`onerow'" 			== "" local ONEROW_USED = 0
		if "`onerow'" 			!= "" local ONEROW_USED = 1


	** Stats Options

		*Is option ftest used:
		if "`ftest'" 			== "" local FTEST_USED = 0
		if "`ftest'" 			!= "" local FTEST_USED = 1

		*Is option fmiss used:
		if "`fmissok'" 			== "" local F_MISS_OK = 0
		if "`fmissok'" 			!= "" local F_MISS_OK = 1

		*Is option fnoobs used:
		if "`fnoobs'" 			== "" local F_NO_OBS = 0
		if "`fnoobs'" 			!= "" local F_NO_OBS = 1

		*Is option fixedeffect() used:
		if "`fixedeffect'"		== "" local FIX_EFFECT_USED = 0
		if "`fixedeffect'" 		!= "" local FIX_EFFECT_USED = 1

		*Is option covariates() used:
		if "`covariates'"		== "" local COVARIATES_USED = 0
		if "`covariates'" 		!= "" local COVARIATES_USED = 1

		*Is option cluster() used:
		if "`vce'" 				== "" local VCE_USED = 0
		if "`vce'" 				!= "" local VCE_USED = 1

		*Is option missminmean() used:
		if "`missminmean'" 		== "" local MISSMINMEAN_USED = 0
		if "`missminmean'" 		!= "" local MISSMINMEAN_USED = 1

		*Is option starlevels() used:
		if "`starlevels'" 		== "" local STARLEVEL_USED = 0
		if "`starlevels'" 		!= "" local STARLEVEL_USED = 1

		*Is option starsnoadd used:
		if "`starsnoadd'" 		== "" local STARSNOADD_USED = 0
		if "`starsnoadd'" 		!= "" local STARSNOADD_USED = 1

		*Is option nottest used:
		if "`nottest'"			== "" local TTEST_USED = 1
		if "`nottest'"			!= "" local TTEST_USED = 0

		*Is option pftest() used:
		if "`stdev'" 			== "" local STDEV_USED = 0
		if "`stdev'" 			!= "" local STDEV_USED = 1

		*Is option weight() used:
		if "`weight'" 			== "" local WEIGHT_USED = 0
		if "`weight'" 			!= "" local WEIGHT_USED = 1

		*Is option feqtest() user:
		if "`feqtest'" 			== "" local FEQTEST_USED = 0
		if "`feqtest'" 			!= "" local FEQTEST_USED = 1


	** Output Options

		*Is option format() used:
		if "`format'" 			== "" local FORMAT_USED = 0
		if "`format'" 			!= "" local FORMAT_USED = 1

		*Is option savexlsx() used:
		if "`savexlsx'" 		== "" local SAVE_XSLX_USED = 0
		if "`savexlsx'" 		!= "" local SAVE_XSLX_USED = 1

		*Is option savecsv() used:
		if "`savecsv'" 			== "" local SAVE_CSV_USED = 0
		if "`savecsv'" 			!= "" local SAVE_CSV_USED = 1

		*Is option savetex() used:
		if "`savetex'" 			== "" local SAVE_TEX_USED = 0
		if "`savetex'" 			!= "" local SAVE_TEX_USED = 1

		*Is option browse() used:
		if "`browse'" 			== "" local BROWSE_USED = 0
		if "`browse'" 			!= "" local BROWSE_USED = 1

		local SAVE_USED = max(`SAVE_CSV_USED',`SAVE_CSV_USED',`SAVE_TEX_USED')

		*Is option texnotewidth() used:
		if "`texnotewidth'"		== "" local NOTEWIDTH_USED = 0
		if "`texnotewidth'"		!= "" local NOTEWIDTH_USED = 1

		*Is option texnotewidth() used:
		if "`texcaption'"		== "" local CAPTION_USED = 0
		if "`texcaption'"		!= "" local CAPTION_USED = 1

		*Is option texnotewidth() used:
		if "`texlabel'"			== "" local LABEL_USED = 0
		if "`texlabel'"			!= "" local LABEL_USED = 1

		*Is option texdocument() used:
		if "`texdocument'"		== "" local TEXDOC_USED = 0
		if "`texdocument'"		!= "" local TEXDOC_USED = 1

		*Is option texlinespace() used:
		if "`texvspace'"		== "" local TEXVSPACE_USED = 0
		if "`texvspace'"		!= "" local TEXVSPACE_USED = 1

		*Is option texcolwidth() used:
		if "`texcolwidth'"		== "" local TEXCOLWIDTH_USED = 0
		if "`texcolwidth'"		!= "" local TEXCOLWIDTH_USED = 1

		*Is option restore() used:
		if "`replace'" 			== "" local REPLACE_USED = 0
		if "`replace'" 			!= "" local REPLACE_USED = 1

		/***********************************************
			Deprecated options
		************************************************/

		local old_version_guide `"If you still need the old version of iebaltab, for example for reproduction of old code, see {browse  "https://github.com/worldbank/ietoolkit/blob/master/admin/run-old-versions.md" :this guide} for how to run old versions of any command in the ietoolkit package."'

	  if !missing("`savebrowse'`save'") {
			di as error `"{pstd}The options {input:savebrowse}, {input:save} and {input:browse} have been deprecated as of verion 7 of iebaltab. See if the options {input:savexlsx}, {input:savecsv} or {input:browse} have the functionality you need. `old_version_guide'{p_end}"'
			error 198
		}
		if !missing("`balmiss'`balmissreg'`covmiss'`covmissreg'`missminmean'`covarmissok'") {
			di as error `"{pstd}The options {input:balmiss}, {input:balmissreg}, {input:covmiss}, {input:covmissreg}, {input:missminmean} and {input:covarmissok} have been deprecated as of verion 7 of iebaltab. Instead, if needed and/or desired, you must modify missing values yourself before running the command. `old_version_guide'{p_end}"'
			error 198
		}
		if !missing("`nottest'`normdiff'`pttest'`pftest'`pboth'") {
			di as error `"{pstd}The options {input:nottest}, {input:normdiff}, {input:pttest}, {input:pftest} and {input:pboth} have been deprecated as of verion 7 of iebaltab. See if the options {input:pairoutput} or {input:ftestoutput} have the functionality you need. `old_version_guide'{p_end}"'
			error 198
		}
		if !missing("`notecombine'") {
			di as error `"{pstd}The option {input:notecombine} has been deprecated as of verion 7 of iebaltab. See if the options {input:tblnote} or {input:tblnonote} have the functionality you need. `old_version_guide'{p_end}"'
			error 198
		}

/*******************************************************************************
*******************************************************************************/

		* Testing the group variable

/*******************************************************************************
*******************************************************************************/

		cap confirm numeric variable `grpvar'

		* Tests if groupvar is numeric type
		if _rc == 0 {

			* Test that grpvar only consists if integers
			cap assert (int(`grpvar') == `grpvar')
			if _rc == 9 {
				noi display as error  "{phang}The variable in grpvar(`grpvar') is not a categorical variable. The variable may only include integers. See tabulation of `grpvar' below:{p_end}"
				noi tab `grpvar', nol
				error 109
			}
		}

		* Tests if groupvar is string type
		else {

			*Test for options not allowed if grpvar is a string variable
			if !missing("`control'`order'`grpcodes'`grplabels'") {
				local str_invalid_opt ""
				if !missing("`control'")   local str_invalid_opt "`str_invalid_opt' control()"
				if !missing("`order'")     local str_invalid_opt "`str_invalid_opt' order()"
				if !missing("`grplabels'") local str_invalid_opt "`str_invalid_opt' grplabels()"
				local str_invalid_options_used = itrim(trim("`str_invalid_opt' `grpcodes'"))
				di as error "{pstd}The option(s) [`str_invalid_options_used'] can only be used when variable {input:`grpvar'} is a numeric variable. Use {help encode} to generate a numeric version of variable {input:`grpvar'}.{p_end}"
				error 198
			}

			*Generate a encoded numeric tempvar variable from string grpvar
			tempvar grpvar_code
			encode `grpvar' , gen(`grpvar_code')

			*replace the grpvar local so that it uses the tempvar instead
			local grpvar `grpvar_code'
		}

		*Remove observations with a missing value in grpvar()
		drop if missing(`grpvar')

		*Create a local of all codes in group variable
		levelsof `grpvar', local(GRP_CODES)

		*Saving the name of the value label of the grpvar()
		local GRPVAR_VALUE_LABEL 	: value label `grpvar'

		*Static dummy for grpvar() has no label
		if "`GRPVAR_VALUE_LABEL'" == "" local GRPVAR_HAS_VALUE_LABEL = 0
		if "`GRPVAR_VALUE_LABEL'" != "" local GRPVAR_HAS_VALUE_LABEL = 1


/*******************************************************************************

		* Testing options related to order and lables of table columns and rows

*******************************************************************************/

	*****************************
	** Test column order inputs

		** Test if any value used in control is a code used in grpvar
		if `: list control in GRP_CODES' == 0 {
			noi display as error "{phang}The code listed in control(`control') is not used in grpvar(`grpvar'). See tabulation of `grpvar' below:"
			noi tab `grpvar', nol
			error 197
		}

		** Test if any value used in order is a code used in grpvar
		if `: list order in GRP_CODES' == 0 {
			noi display as error  "{phang}One or more codes listed in order(`order') are not used in grpvar(`grpvar'). See tabulation of `grpvar' below:"
			noi tab `grpvar', nol
			error 197
		}

		*****************************
		** Test and parse column label inputs
		if `GRPLABEL_USED' == 1 {
			test_parse_label_input, labelinput("`grplabels'") itemlist("`GRP_CODES'") ///
			column grpvar(`grpvar')
			local grpLabelCodes  "`r(items)'"
			local grpLabelLables "`r(labels)'"
		}

		*****************************
		** Test row label inputs
		if `ROWLABEL_USED' == 1 {
			test_parse_label_input, labelinput("`rowlabels'") itemlist("`balancevars'") ///
			row
			local rowLabelNames  "`r(items)'"
			local rowLabelLabels "`r(labels)'"
		}

		*****************************
		* Warning if totallabel is used without total. Only warning as there is
		* nothing preventing the comamnd to continue as normal
		if `TOTALLABEL_USED' & !`TOTAL_USED' {
			noi display as text "{phang}Warning: Option {input:totallabel(`totallabel')} is ignored as option {input:total} was not used."
		}

/*******************************************************************************

		* Testing Stats Options

*******************************************************************************/

		****************************************************************************
		** VCE input testing
		local CLUSTER_USED 0
		if `VCE_USED' == 1 {
			* Remove comman and tokenize based on spaces
			local vce_nocomma = subinstr("`vce'", "," , " ", 1)
			tokenize "`vce_nocomma'"
			local vce_type `1'

			* Tests related to VCE Type being cluster
			if "`vce_type'" == "cluster" {

				*Create a local for displaying number of clusters
				local CLUSTER_USED 1
				local cluster_var `2'

				* Test that the variable used as cluster is indeed a variable
				* and that it is numeric
				cap confirm numeric variable `cluster_var'
				if _rc {
					noi display as error "{phang}The cluster variable in vce(`vce') does not exist or is invalid for any other reason. See {help vce_option :help vce_option} for more information. "
					error _rc
				}
			}

			* Test that the vce_type is among any of the remaining options
			* that does not need any extra testing, if not among then, throw an error.
			else if inlist("`vce_type'","robust","bootstrap") == 0 {
				noi display as error "{phang}The vce type `vce_type' in vce(`vce') is not allowed. Only robust, cluster and bootstrap are allowed. See {help vce_option :help vce_option} for more information."
				error 198
			}
		}


		******************************
		* Handle STARS
		******************************

		* Test if nostar option used
		if `STARSNOADD_USED' == 1 {
			local starlevels ""
		}
		*If nostar not used and starlevels not specified, use defaults
		else if `STARLEVEL_USED' == 0 {
			*Set star levels to default values
			local starlevels ".1 .05 .01"
		}

		****************************************************************************
		** Test input for pair-wise test stats

		* Use default value if none is specified by user
		if missing("`pairoutput'") local pout_val "diff"
		else local pout_val "`pairoutput'"

		*Allowed apir test outputs
		local allowed_pairtest_outputs "diff beta nrmd t p none"
		if !`:list pout_val in allowed_pairtest_outputs' {
			noi display as error "{phang}Value in option pairtestoutput(`pout_val') is not valid. Allowed values are [`allowed_pairtest_outputs']. See {help iebaltab:helpfile} for more details.{p_end}"
			error 198
		}

		* Prepare the pair test labels
		if "`pout_val'" == "diff" local pout_lbl "Mean difference"
		if "`pout_val'" == "beta" local pout_lbl "Beta coefficient"
		if "`pout_val'" == "nrmd" local pout_lbl "Normalized difference"
		if "`pout_val'" == "t" local pout_lbl "T-statistics" //todo: include in matrix
		if "`pout_val'" == "p" local pout_lbl "P-value"
		if "`pout_val'" == "none" local pout_lbl "none"

		****************************************************************************
		** Test input for f over all balance variables

		* Use default value if none is specified by user
		if missing("`ftestoutput'") local fout_val "f"
		else local fout_val "`ftestoutput'"

		*Allowed apir test outputs
		local allowed_ftest_outputs "f p"
		if !`:list fout_val in allowed_ftest_outputs' {
			noi display as error "{phang}Value in option ftestoutput(`fout_val') is not valid. Allowed values are [`allowed_ftest_outputs']. See {help iebaltab:helpfile} for more details.{p_end}"
			error 198
		}

		* Prepare the pair test labels
		if "`fout_val'" == "f" local fout_lbl "F-stat"
		if "`fout_val'" == "p" local fout_lbl "P-value"

		****************************************************************************
		** Test input for fixed effects and output warning if missing values

		if `FIX_EFFECT_USED' == 1 {
			cap assert `fixedeffect' < .
			if _rc == 9 {
				noi di ""
				noi display as result "{phang}Warning: The variable in fixedeffect(`fixedeffect') is missing for some observations in the sample used. Before using the generated results, make sure that the number of observations in the table is as expected.{p_end}"
			}
		}

		****************************************************************************
		** Test input for fixed effects and output warning if missing values

		if `COVARIATES_USED' == 1 {
			local covar_balancevars ""
			foreach covar of local covariates {
				cap assert `covar' < .
				if _rc == 9 {
					noi di ""
					noi display as result "{phang}Warning: The variable [`covar'] in covariates(`covariates') is missing for some observations in the sample used. Before using the generated results, make sure that the number of observations in the table is as expected.{p_end}"
				}

				if `: list covar in balancevars' local covar_balancevars =trim("`covar_balancevars' `covar'")
			}
			if "`covar_balancevars'" != "" {
					noi display as error "{phang}The covariate variable(s) [`covar_balancevars'] is/are also among the  balance variable(s) [`balancevars'] which is not allowed.{p_end}"
					error 198
			}
		}

		****************************************************************************
		** Test input for fixed effects

		if `WEIGHT_USED' == 1 {
			* Parsing weight options
			local weight_type = "`weight'"
			* Parsing keeps the separating character
			local weight_var = subinstr("`exp'","=","",.)

			* Test is weight type specified is valie
			local weight_options "fweights pweights aweights iweights fweight pweight aweight iweight fw freq weight pw aw iw"
			if `:list weight_type in weight_options' == 0 {
				noi display as error  "{phang} The option `weight_type' specified in weight() is not a valid weight option. Weight options are: fweights, fw, freq, weight, pweights, pw, aweights, aw, iweights, and iw. {p_end}"
				error 198
			}

			* Test is weight variable specified if valid
			capture confirm variable `weight_var'
			if _rc {
				noi display as error  "{phang} The option `weight_var' specified in weight() is not a variable. {p_end}"
				error 198
			}
		}



	** Output Options

		** If the format option is specified, then test if there is a valid format specified
		if `FORMAT_USED' == 1 {

			** Creating a numeric mock variable that we attempt to apply the format
			*  to. This allows us to piggy back on Stata's internal testing to be
			*  sure that the format specified is at least one of the valid numeric
			*  formats in Stata
			tempvar      formattest
			gen         `formattest' = 1
			cap	format  `formattest' `format'

			if _rc == 120 {

				di as error "{phang}The format specified in format(`format') is not a valid Stata format. See {help format} for a list of valid Stata formats. This command only accept the f, fc, g, gc and e format.{p_end}"
				error 120
			}
			else if _rc != 0 {

				di as error "{phang}Something unexpected happened related to the option format(`format'). Make sure that the format you specified is a valid format. See {help format} for a list of valid Stata formats. If this problem remains, please report this error to kbjarkefur@worldbank.org.{p_end}"
				error _rc
			}
			else {
				** We know here that the format is one of the numeric formats that Stata allows

				local fomrmatAllowed 0
				local charLast  = substr("`format'", -1,.)
				local char2Last = substr("`format'", -2,.)

				if  "`charLast'" == "f" | "`charLast'" == "e" {
					local fomrmatAllowed 1
				}
				else if "`charLast'" == "g" {
					if "`char2Last'" == "tg" {
						*format tg not allowed. all other valid formats ending on g are allowed
						local fomrmatAllowed 0
					}
					else {

						*Formats that end in g that is not tg can only be g which is allowed.
						local fomrmatAllowed 1
					}
				}
				else if  "`charLast'" == "c" {
					if "`char2Last'" != "gc" & "`char2Last'" != "fc" {
						*format ends on c but is neither fc nor gc
						local fomrmatAllowed 0
					}
					else {

						*Formats that end in c that are either fc or gc are allowed.
						local fomrmatAllowed 1
					}
				}
				else {
					*format is neither f, fc, g, gc nor e
					local fomrmatAllowed 0
				}
				if `fomrmatAllowed' == 0 {
					di as error "{phang}The format specified in format(`format') is not allowed. Only format f, fc, g, gc and e are allowed. See {help format} for details on Stata formats.{p_end}"
					error 120
				}
				*If format passed all tests, store it in the local used for display formats
				local diformat = "`format'"
			}
		}
		else {
			*Default value if fomramt not specified
			local diformat = "%9.3f"
		}


		if `SAVE_USED' {
			if `SAVE_CSV_USED' {

				**Find the last . in the file path and assume that
				* the file extension is what follows. If a file path has a . then
				* the file extension must be explicitly specified by the user.

				*Copy the full file path to the file suffix local
				local file_suffix 	= "`save'"

				** Find index for where the file type suffix start
				local dot_index 	= strpos("`file_suffix'",".")

				*If no dot then no file extension
				if `dot_index' == 0  local file_suffix 	""

				**If there is one or many . in the file path than loop over
				* the file path until we have found the last one.
				while `dot_index' > 0 {

					*Extract the file index
					local file_suffix 	= substr("`file_suffix'", `dot_index' + 1, .)

					*Find index for where the file type suffix start
					local dot_index 	= strpos("`file_suffix'",".")
				}

				*If no file format suffix is specified, use the default .xlsx
				if "`file_suffix'" == "" {

					local save `"`save'.xlsx"'
				}

				*If a file format suffix is specified make sure that it is one of the two allowed.
				else if !("`file_suffix'" == "xls" | "`file_suffix'" == "xlsx") {

					noi display as error "{phang}The file format specified in save(`save') is other than .xls or .xlsx. Only those two formats are allowed. If no format is specified .xlsx is the default. If you have a . in your file path, for example in a folder name, then you must specify the file extension .xls or .xlsx.{p_end}"
					error 198
				}
			}
			if `SAVE_TEX_USED' {

				**Find the last . in the file path and assume that
				* the file extension is what follows. If a file path has a . then
				* the file extension must be explicitly specified by the user.

				*Copy the full file path to the file suffix local
				local tex_file_suffix 	= "`savetex'"

				** Find index for where the file type suffix start
				local tex_dot_index 	= strpos("`tex_file_suffix'",".")

				*If no dot then no file extension
				if `tex_dot_index' == 0  local tex_file_suffix 	""

				**If there is one or many . in the file path than loop over
				* the file path until we have found the last one.
				while `tex_dot_index' > 0 {

					*Extract the file index
					local tex_file_suffix 	= substr("`tex_file_suffix'", `tex_dot_index' + 1, .)

					*Find index for where the file type suffix start
					local tex_dot_index 	= strpos("`tex_file_suffix'",".")
				}

				*If no file format suffix is specified, use the default .tex
				if "`tex_file_suffix'" == "" {

					local savetex `"`savetex'.tex"'
				}

				*If a file format suffix is specified make sure that it is one of the two allowed.
				else if !("`tex_file_suffix'" == "tex" | "`tex_file_suffix'" == "txt") {

					noi display as error "{phang}The file format specified in savetex(`savetex') is other than .tex or .txt. Only those two formats are allowed. If no format is specified .tex is the default. If you have a . in your file path, for example in a folder name, then you must specify the file extension .tex or .txt.{p_end}"
					error 198
				}

				if `CAPTION_USED' {

					* Make sure special characters are displayed correctly
					local texcaption : subinstr local texcaption "%"  "\%" , all
					local texcaption : subinstr local texcaption "_"  "\_" , all
					local texcaption : subinstr local texcaption "&"  "\&" , all

				}
			}

		}


		* Check tex options
		if `SAVE_TEX_USED' {

			* Note width must be positive
			if `NOTEWIDTH_USED' {

				if `texnotewidth' <= 0 {

					noi display as error `"{phang}The value specified in texnotewidth(`texnotewidth') is non-positive. Only positive numbers are allowed. For more information, {net "from http://en.wikibooks.org/wiki/LaTeX/Lengths.smcl":check LaTeX lengths manual}.{p_end}"'
					error 198
				}
			}

			* Tex label must be a single word
			if `LABEL_USED' {

				local label_words : word count `texlabel'

				if `label_words' != 1 {

					noi display as error `"{phang}The value specified in texlabel(`texlabel') is not allowed. For more information, {browse "https://en.wikibooks.org/wiki/LaTeX/Labels_and_Cross-referencing":check LaTeX labels manual}.{p_end}"'
					error 198
				}

			}

			if (`LABEL_USED' | `CAPTION_USED') {

				if `TEXDOC_USED' == 0 {

					noi display as error "{phang}Options texlabel and texcaption may only be used in combination with option texdocument {p_end}"
					error 198
				}
			}

			if `TEXCOLWIDTH_USED' {

				* Test if width unit is correctly specified
				local 	texcolwidth_unit = substr("`texcolwidth'",-2,2)
				if 	!inlist("`texcolwidth_unit'","cm","mm","pt","in","ex","em") {
					noi display as error `"{phang}Option texcolwidth is incorrectly specified. Column width unit must be one of "cm", "mm", "pt", "in", "ex" or "em". For more information, {browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX lengths manual}.{p_end}"'
					error 198
				}

				* Test if width value is correctly specified
				local 	texcolwidth_value = subinstr("`texcolwidth'","`texcolwidth_unit'","",.)
				capture confirm number `texcolwidth_value'
				if _rc & inlist("`texcolwidth_unit'","cm","mm","pt","in","ex","em") {
					noi display as error "{phang}Option texcolwidth is incorrectly specified. Column width value must be numeric. See {help iebaltab:iebaltab help}. {p_end}"
					error 198
				}
			}

			if `TEXVSPACE_USED' {

				* Test if width unit is correctly specified
				local 	vspace_unit = substr("`texvspace'",-2,2)
				if 	!inlist("`vspace_unit'","cm","mm","pt","in","ex","em") {
					noi display as error `"{phang}Option texvspace is incorrectly specified. Vertical space unit must be one of "cm", "mm", "pt", "in", "ex" or "em". For more information, {browse "https://en.wikibooks.org/wiki/LaTeX/Lengths":check LaTeX lengths manual}.{p_end}"'
					error 198
				}

				* Test if width value is correctly specified
				local 	vspace_value = subinstr("`texvspace'","`vspace_unit'","",.)
				capture confirm number `vspace_value'
				if _rc & inlist("`vspace_unit'","cm","mm","pt","in","ex","em") {
					noi display as error "{phang}Option texvspace is incorrectly specified. Vertical space value must be numeric. See {help iebaltab:iebaltab help}. {p_end}"
					error 198
				}
			}
		}

		* Error for incorrectly using tex options
		else if `NOTEWIDTH_USED' | `LABEL_USED' | `CAPTION_USED' | `TEXDOC_USED' | `TEXVSPACE_USED' | `TEXCOLWIDTH_USED' {

			noi display as error "{phang}Options texnotewidth, texdocument, texlabel, texcaption, texvspace and texcolwidth may only be used in combination with option savetex(){p_end}"
			error 198

		}


/*******************************************************************************
*******************************************************************************/

		* Set up the result matrix that will store all the results

/*******************************************************************************
*******************************************************************************/

	************************************************
	*Group order

		* If option order is always used to set the orders of the group columns. If
		* option control is used when order is not used, then the code for the
		* control group will be used in order.
		if !`ORDER_USED' & `CONTROL_USED' local order `control'

		* Put all group codes not in local order in local order_code_rest. If
		* neither option order or control were used, then local order_code_rest is
		* identical to local GRP_CODES
		local order_code_rest : list GRP_CODES - order

		* The final order is compiled by combining local order with local
		* order_code_rest. If neither option order or control were used, then local
		* ORDER_OF_GROUP_CODES is identical to local order_code_rest and GRP_CODES
		local ORDER_OF_GROUP_CODES `order' `order_code_rest'

		* Loop from the second element in the list of group codes to the last and
		* create a list on the format 2.tmt=3.tmt=0 where tmt is the grpvar and the
		* first value is dropped as the regression that test for joint orthogonality
		* for across all groups for each balance var will drop the lowest value in grpvar.
		local FEQTEST_INPUT ""
		forvalues grp_code_count = 2/`: word count `GRP_CODES'' {
			local this_code : word `grp_code_count' of `GRP_CODES'
			local FEQTEST_INPUT "`FEQTEST_INPUT'`this_code'.`grpvar'="
		}
		local FEQTEST_INPUT "`FEQTEST_INPUT'0"

		************************************************
		*Generate list of test pairs

		local TEST_PAIR_CODES = ""

		if `CONTROL_USED' {
			*Loop over all non-control codes and create pairs with them and the control code
			local non_control_codes : list ORDER_OF_GROUP_CODES - control
			foreach code_2 of local non_control_codes {
				local TEST_PAIR_CODES = "`TEST_PAIR_CODES' `control'_`code_2'"
			}
		}
		else {
			* Nested loop where values used in the outer loop is removed from the
			* inner loop to not make any duplicated pais such as 1_2 and 2_1.
			local ORDER_OF_GROUP_CODES_2 = "`ORDER_OF_GROUP_CODES'"
			foreach code_1 of local ORDER_OF_GROUP_CODES {
				local ORDER_OF_GROUP_CODES_2 : list ORDER_OF_GROUP_CODES_2 - code_1
				foreach code_2 of local ORDER_OF_GROUP_CODES_2 {
					local TEST_PAIR_CODES = "`TEST_PAIR_CODES' `code_1'_`code_2'"
				}
			}
		}

		*Number of test pairs
		local COUNT_TEST_PAIRS : list sizeof TEST_PAIR_CODES

		noi di "`ORDER_OF_GROUP_CODES'"

		************************************************
		* Setup tempvar dummies for each test pair that is
		* 0 for first code and 1 for second code and
		* missing for all other observations.
		foreach ttest_pair of local TEST_PAIR_CODES {

			*Get each code from a testpair
			getCodesFromPair `ttest_pair'
			local code1 `r(code1)'
			local code2 `r(code2)'

			*Tempvar dummy for the codes in the test pair and missing for other obs
			tempvar  dummy_pair_`ttest_pair'
			gen     `dummy_pair_`ttest_pair'' = .
			replace `dummy_pair_`ttest_pair'' = 0 if `grpvar' == `code1'
			replace `dummy_pair_`ttest_pair'' = 1 if `grpvar' == `code2'
		}

		do "C:\Users\wb462869\GitHub\ietoolkit\src\ado_files\iebaltab_setupmatrix.ado"

		* Set up the matrix for all stats and estimates
		noi setUpResultMatrix, order_of_group_codes(`ORDER_OF_GROUP_CODES') test_pair_codes(`TEST_PAIR_CODES')
		mat emptyRow  = r(emptyRow)
		mat `rmat' = r(emptyRow)
		mat `fmat'  = r(emptyFRow)

		local desc_stats   `r(desc_stats)'
	  local pair_stats   `r(pair_stats)'
		local feq_stats    `r(feq_stats)'
		local ftest_stats  `r(ftest_stats)'

		noi mat list emptyRow
		noi mat list `fmat'

/*******************************************************************************
*******************************************************************************/

		* Set up locals with all column and row labels

/*******************************************************************************
*******************************************************************************/

	************************************************
	* Prepare column lables for groups


		*Local that will store the final labels. These labels will be stored in the in final order of groups in groupvar
		local COLUMN_LABELS ""

		*Loop over all groups in the final order
		foreach groupCode of local ORDER_OF_GROUP_CODES {

			************
			* Manually defined column label

			*Test if this code was listed in option GRPLabels()
			local grpLabelPos : list posof "`groupCode'" in grpLabelCodes

			*If index is not zero then manual label is defined, use it
			if `grpLabelPos' != 0 {
				*Getting the manually defined label and add it to local GROUP_LABELS
				local 	group_label : word `grpLabelPos' of `grpLabelLables'
				local	COLUMN_LABELS `" `COLUMN_LABELS' "`group_label'" "'
			}

			************
			* Use code as column label

			* If option grpcodes was used or grpvar has no value label, then the codes
			* must be used as column labels
			else if `NOGRPLABEL_USED' | !`GRPVAR_HAS_VALUE_LABEL' {
				*Not using value labels, simply using the group code as the label in the final table
				local	COLUMN_LABELS `" `COLUMN_LABELS' "`groupCode'" "'
			}

			************
			* Use value label in grpvar as column label

			* Grpvar has value labels and grpcodes was not used, then use value labels
			* as code labels
			else {
				*Get the value label corresponding to this code and use as label
				local gprVar_valueLabel : label `GRPVAR_VALUE_LABEL' `groupCode'
				local COLUMN_LABELS `" `COLUMN_LABELS' "`gprVar_valueLabel'" "'
			}
		}

		************************************************
		* Prepare row lables for each balance var

		local ROW_LABELS ""

		foreach balancevar of local balancevars {

			************
			* Manually defined row label

			** Test if this variable has a manually defined rowlabel in rowlabels()
			local rowLabPos : list posof "`balancevar'" in rowLabelNames
			*If index is not zero then manual label is defined, use it
			if `rowLabPos' != 0 {
				*Get the manually defined label for this balance variable
				local 	row_label : word `rowLabPos' of `rowLabelLabels'
				local ROW_LABELS `" `ROW_LABELS' "`row_label'" "'
			}

			************
			* Use var label in balance var as row label

			*Use variable label if option is specified
			else if `ROWVARLABEL_USED' {
				*Get the variable label used for this variable and trim it
				local var_label : variable label `balancevar'
				local var_label = trim("`var_label'")
				* If varaible label exists, use it, oterwise use the variable name
				if "`var_label'" != "" local ROW_LABELS `" `ROW_LABELS' "`var_label'" "'
				else local ROW_LABELS `" `ROW_LABELS' "`balancevar'" "'
			}

			************
			* Use variable name as row label

			* If no manually row labels are defined, and option rowvarlabels is
			* not used, then use balance var name
			else local ROW_LABELS `" `ROW_LABELS' "`balancevar'" "'

		}

		************************************************
		* Prepare column label for total column

		* Use custom total label or default : "Total"
		if `TOTALLABEL_USED' local tot_lbl `totallabel'
		else local tot_lbl "Total"

/*******************************************************************************
*******************************************************************************/

		* Generate all stats and estimates

/*******************************************************************************
*******************************************************************************/

	*****************************************************************************
	*** Setting default values or specified values for fixed effects and clusters

		**********************************
		*Preparing fixed effect option
		if !`FIX_EFFECT_USED' {
			* If a fixed effect var is not specified, so that areg may be uses. A
			* fixed effect with no variation does not have any effect on the estimates
			tempvar  fixedeffect
			gen 	`fixedeffect' = 1
		}

		**********************************
		*Preparing cluster option

		* The varname for cluster is prepared to be put in the areg options. If
		* option vce() was not used then this local will be left empty
		if `VCE_USED' local error_estm vce(`vce')

		**********************************
		*Preparing weight option

		* The varname for weight is prepared to be put in the reg options. If no
		* weight was used then this option will be left empty
		if `WEIGHT_USED' local weight_option "[`weight_type' = `weight_var']"


	** Create locals that control the warning table

			*Mean test warnings
			local warn_means_num    	0
			local warn_ftest_num    	0

			*Joint test warnings
			local warn_joint_novar_num	0
			local warn_joint_lovar_num	0
			local warn_joint_robus_num	0


	*****************************************************************************
	*** Loop over each balance var and create the stats

		foreach balancevar in `balancevars' {

			* Make a copy of the empty row template to populate this row with
			mat row = emptyRow
			mat rownames row = `balancevar'

			*Local that keeps track of which column to fill
			local colindex 0

			******************************************************
			*** Get descriptive stats for each group

			foreach group_code of local ORDER_OF_GROUP_CODES {

				noi di "Desc stats. Var [`balancevar'], group code [`group_code']"
				reg 	`balancevar' if `grpvar' == `group_code' `weight_option', `error_estm'

				*Number of observation for this balancevar for this group
				mat row[1,`++colindex'] = e(N)
				*If clusters used, number of clusters in this balance var for this group, otherwise .c
				local ++colindex
				if "`vce_type'" == "cluster" mat row[1,`colindex'] = e(N_clust)
				else mat row[1,`colindex'] = .c
				*Mean of balance var for this group
				mat row[1,`++colindex'] = _b[_cons]
				*Standard error of balance var for this group
				mat row[1,`++colindex'] = _se[_cons]
				*Standard deviation of balance var for this group
				local sd = _se[_cons] * sqrt(e(N))
				mat row[1,`++colindex'] = `sd'

			}

			******************************************************
			*** Get descriptive stats for total

			noi di "Desc stats. Var [`balancevar'], total"
			if !missing("`total'") {
				* Estimate descriptive stats for total
				reg 	`balancevar'  `weight_option', `error_estm'
				*Number of observation for this balancevar for this group
				mat row[1,`++colindex'] = e(N)
				*If clusters used, number of clusters in this balance var for this group, otherwise .c
				local ++colindex
				if "`vce_type'" == "cluster" mat row[1,`colindex'] = e(N_clust)
				else mat row[1,`colindex'] = .c
				*Mean of balance var for this group
				mat row[1,`++colindex'] = _b[_cons]
				*Standard error of balance var for this group
				mat row[1,`++colindex'] = _se[_cons]
				*Standard deviation of balance var for this group
				local sd = _se[_cons] * sqrt(e(N))
				mat row[1,`++colindex'] = `sd'
			}
			else {
				*If total not specified, then put .m in all total columns
				foreach tot_stat of local desc_stats {
					mat row[1,`++colindex'] = .m
				}
			}

			******************************************************
			*** Get test estimates for each test pair

			foreach ttest_pair of local TEST_PAIR_CODES {

				*If none is used then no pair test stats are calculated
				if "`pout_val'" == "none" {
					foreach tot_stat of local pair_stats {
						mat row[1,`++colindex'] = .m
					}
				}

				*Calculate pair wise stats
				else {

					*Get each code from a testpair
	        getCodesFromPair `ttest_pair'
					local code1 `r(code1)'
					local code2 `r(code2)'

					local colnum_mean_code1 = colnumb(row,"mean_`code1'")
					local colnum_mean_code2 = colnumb(row,"mean_`code2'")
					mat row[1,`++colindex'] = el(row,1,`colnum_mean_code1') - el(row,1,`colnum_mean_code2')

					* The command mean is used to test that there is variation in the
					* balance var across these two groups. The regression that includes
					* fixed effects and covariaties might run without error even if there is
					* no variance across the two groups. The local varloc will determine if
					* an error or a warning will be thrown or if the test results will be
					* replaced with an "N/A".
					if "`error_estm'" != "vce(robust)" 	local mean_error_estm `error_estm' //Robust not allowed in mean, but the mean here
					noi di "Test var. Var [`balancevar'], test pair [`ttest_pair']"
					mean `balancevar', over(`dummy_pair_`ttest_pair'') 	 `mean_error_estm'
					mat var = e(V)
					local varloc = max(var[1,1],var[2,2])

					*Calculate standard deviation for sample of interest
					sum `balancevar' if !missing(`dummy_pair_`ttest_pair'')
					tempname scal_sd
					scalar `scal_sd' = r(sd)

					*Testing result and if valid, write to file with or without stars
					if `varloc' == 0 {

						local warn_means_num  	= `warn_means_num' + 1

						local warn_means_name`warn_means_num'	"t-test"
						local warn_means_group`warn_means_num' 	"(`code1')-(`code2')"
						local warn_means_bvar`warn_means_num'	"`balancevar'"

						* Adding missing value for each stat that is missing due to not running regression
						foreach stat in baln balcl beta t p {
							mat row[1,`++colindex'] = .v
						}
					}

					else {

						* Perform the balance test for this test pair for this balance var
						noi di "Balance regression. Var [`balancevar'], test pair [`ttest_pair']"
						reg `balancevar' `dummy_pair_`ttest_pair'' `covariates' i.`fixedeffect' `weight_option', `error_estm'

						*Number of observation for in these two groups
						mat row[1,`++colindex'] = e(N)
						*If clusters used, number of clusters in this these two groups, otehrwise .c
						local ++colindex
						if "`vce_type'" == "cluster" mat row[1,`colindex'] = e(N_clust)
						else mat row[1,`colindex'] = .c

						*The diff between the groups after controling for fixed effects and covariates
						mat row[1,`++colindex'] = e(b)[1,1]
						*The t-stat the the beta is different from 0
						mat row[1,`++colindex'] = _b[`dummy_pair_`ttest_pair'']/_se[`dummy_pair_`ttest_pair'']

						*Perform the t-test and store p-value in pttest
						*Test is used instead of ttest as we test coefficients from reg
						test `dummy_pair_`ttest_pair''
						mat row[1,`++colindex'] = r(p)

					}

					*Testing result and if valid, write to file with or without stars
					if `scal_sd' == 0 {

						local warn_means_num  	= `warn_means_num' + 1

						local warn_means_name`warn_means_num'	"Norm diff"
						local warn_means_group`warn_means_num' 	"(`first_group')-(`second_group')"
						local warn_means_bvar`warn_means_num'	"`balancevar'"

						* Adding missing value for no normdiff due to no standdev in balancevar for this pair
						mat row[1,`++colindex'] = .n

					}
					else {
						*Calculate and store the normalized difference
						mat row[1,`++colindex'] = el(row,1,colnumb(row,"diff_`ttest_pair'")) / `scal_sd'
					}
				}
			}

			******************************************************
			*** Test for joint orthogonality across all groups for this balance var

			if !missing("`feqtest'") {

			    * Run regression
					noi di "FEQ regression. Var [`balancevar']"
					reg `balancevar' i.`grpvar' `covariates' i.`fixedeffect' `weight_option', `error_estm'
					local nfeqtest 	= e(N)
					*If clusters used, number of clusters in this reg, otehrwise .c
					if "`vce_type'" == "cluster" local clfeqtest = e(N_clust)
					else local clfeqtest = .c

					*Perfeorm the F test
					test `FEQTEST_INPUT'
					local ffeqtest 	= r(F)
					local pfeqtest 	= r(p)


					*Check if the test is valid. If not, print N/A and error message.
					*Is yes, print test
					if "`ffeqtest'" == "." {
						local warn_ftest_num  	= `warn_ftest_num' + 1
						local warn_ftest_bvar`warn_ftest_num'		"`balancevar'"
						* Adding missing values for invalid feq test
						foreach feq_stat of local feq_stats {
							mat row[1,`++colindex'] = .f
						}
					}
					* Few test possible save results to matrix
					else {
						* Adding p value and F value to matrix
						mat row[1,`++colindex'] = `nfeqtest'
						mat row[1,`++colindex'] = `clfeqtest'
						mat row[1,`++colindex'] = `ffeqtest'
						mat row[1,`++colindex'] = `pfeqtest'
					}
				}

				* Feq test not used -  save missing .m
				else {
					foreach feq_stat of local feq_stats {
						mat row[1,`++colindex'] = .m
					}
				}

			******************************************************
			*** All estimates calculated for this row

			*Appending row for this balance var to result matrix
			mat `rmat' = [`rmat'\row]
		}

	/***********************************************
	***********************************************/

		*Running the regression for the F-tests

	/************************************************
	************************************************/

	*Local used to count number of f-test that trigered warnings
	local warn_joint_novar_num	0
	local warn_joint_lovar_num	0
	local warn_joint_robus_num	0
	local fmiss_error           0

	local Fcolindex             0

	*Run the F-test on each pair
	foreach ttest_pair of local TEST_PAIR_CODES {

		**********
		* Run the regression for f-test
		noi di "F regression. Var [`balancevars'], test pair [`ttest_pair']"
		reg `dummy_pair_`ttest_pair'' `balancevars' `covariates' i.`fixedeffect' `weight_option',  `error_estm'
		scalar reg_f = e(F)

		* Adding F score and number of observations to the matrix
		mat `fmat'[1,`++Fcolindex'] = e(N)
		*If clusters used, number of clusters in this reg, otehrwise .c
		local ++Fcolindex
		if "`vce_type'" == "cluster" mat `fmat'[1,`Fcolindex'] = e(N_clust)
		else mat `fmat'[1,`Fcolindex'] = .c

		*Test all balance variables for joint significance
		cap testparm `balancevars'
		scalar test_F = r(F)
		scalar test_p = r(p)

		**********
		* Write to table

		* No variance in either groups mean in any of the balance vars. F-test not possible to calculate
		if _rc == 111 {

			local warn_joint_novar_num	= `warn_joint_novar_num' + 1
			local warn_joint_novar`warn_joint_novar_num' "(`first_group')-(`second_group')"
		}

		* Collinearity between one balance variable and the dependent treatment dummy
		else if "`test_F'" == "." {

			local warn_joint_lovar_num	= `warn_joint_lovar_num' + 1
			local warn_joint_lovar`warn_joint_lovar_num' "(`first_group')-(`second_group')"
		}

		* F-test is incorreclty specified, error in this code
		else if _rc != 0 {

			noi di as error "F-test not valid. Please report this error to dimeanalytics@worldbank.org"
			error _rc
		}

		* F-tests possible to calculate
		else {

			* Robust singularity, see help file. Similar to overfitted model. Result possible but probably not reliable
			if "`reg_F'" == "." {

				local warn_joint_robus_num	= `warn_joint_robus_num' + 1
				local warn_joint_robus`warn_joint_robus_num' "(`first_group')-(`second_group')"
			}
			mat `fmat'[1,`++Fcolindex'] = test_F
			mat `fmat'[1,`++Fcolindex'] = test_p
		}
	}

	/*******************************************************************************
	*******************************************************************************/

			*Compile and display warnings from regressions and tests

	/*******************************************************************************
	*******************************************************************************/

	* Count if there were any warsnings generated above
	local anywarning	= max(`warn_means_num',`warn_ftest_num',`warn_joint_novar_num', `warn_joint_lovar_num' ,`warn_joint_robus_num')
	local anywarning_F	= max(`warn_joint_novar_num', `warn_joint_lovar_num' ,`warn_joint_robus_num')

	* Display warnings related to the pairwise test regressions
	if `anywarning' > 0 {

		noi di as text ""
		noi di as error "{hline}"
		noi di as error "{pstd}Stata issued one or more warnings in relation to the tests in this balance table. Read the warning(s) below carefully before using the values generated for this table.{p_end}"
		noi di as text ""

		if `warn_means_num' > 0 {

			noi di as text "{pmore}{bf:Difference-in-Means Tests:} The variance in both groups listed below is zero for the variable indicated and a difference-in-means test between the two groups is therefore not valid. Tests are reported as N/A in the table.{p_end}"
			noi di as text ""

			noi di as text "{col 9}{c TLC}{hline 11}{c TT}{hline 12}{c TT}{hline 37}{c TRC}"
			noi di as text "{col 9}{c |}{col 13}Test{col 21}{c |}{col 25}Group{col 34}{c |}{col 39}Balance Variable{col 72}{c |}"
			noi di as text "{col 9}{c LT}{hline 11}{c +}{hline 12}{c +}{hline 37}{c RT}"

			forvalues warn_num = 1/`warn_means_num' {
				noi di as text "{col 9}{c |}{col 11}`warn_means_name`warn_num''{col 21}{c |}{col 23}`warn_means_group`warn_num''{col 34}{c |}{col 37}`warn_means_bvar`warn_num''{col 72}{c |}"
			}
			noi di as text "{col 9}{c BLC}{hline 11}{c BT}{hline 12}{c BT}{hline 37}{c BRC}"
			noi di as text ""
		}

		if `warn_ftest_num' > 0 {

			noi di as text "{pmore}{bf:F-Test for Joint Orthogonality:} The variance all groups is zero for the variable indicated and a test of joint orthogonality for all groups is therefore not valid. Tests are reported as N/A in the table.{p_end}"
			noi di as text ""

			noi di as text "{col 9}{c TLC}{hline 25}{c TRC}"
			noi di as text "{col 9}{c |}{col 13} Balance Variable{col 35}{c |}"
			noi di as text "{col 9}{c LT}{hline 25}{c RT}"

			forvalues warn_num = 1/`warn_ftest_num' {
				noi di as text "{col 9}{c |}{col 12}`warn_ftest_bvar`warn_num''{col 35}{c |}"
			}
			noi di as text "{col 9}{c BLC}{hline 25}{c BRC}"
			noi di as text ""
		}

		* Display warnings related to the F test regression
		if `anywarning_F' > 0 {
			noi di as text "{pmore}{bf:Joint Significance Tests:} F-tests are not possible to perform or unreliable. See below for details:{p_end}"
			noi di as text ""

			if `warn_joint_novar_num' > 0 {

				noi di as text "{pmore}In the following tests, F-tests were not valid as all variables were omitted in the joint significance test due to collinearity. Tests are reported as N/A in the table.{p_end}"
				noi di as text ""

				noi di as text "{col 9}{c TLC}{hline 12}{c TRC}"
				noi di as text "{col 9}{c |}{col 13}Test{col 22}{c |}"
				noi di as text "{col 9}{c LT}{hline 12}{c RT}"

				forvalues warn_num = 1/`warn_joint_novar_num' {
					noi di as text "{col 9}{c |}{col 12}`warn_joint_novar`warn_num''{col 22}{c |}"
				}
				noi di as text "{col 9}{c BLC}{hline 12}{c BRC}"
				noi di as text ""
			}
			if `warn_joint_lovar_num' > 0 {

				noi di as text "{pmore}In the following tests, F-tests are not valid as the variation in, and the covariation between, the balance variables is too close to zero in the joint test. This could be due to many reasons, but is usually due to a balance variable with high correlation with group dummy. Tests are reported as N/A in the table.{p_end}"
				noi di as text ""

				noi di as text "{col 9}{c TLC}{hline 12}{c TRC}"
				noi di as text "{col 9}{c |}{col 13}Test{col 22}{c |}"
				noi di as text "{col 9}{c LT}{hline 12}{c RT}"

				forvalues warn_num = 1/`warn_joint_lovar_num' {
					noi di as text "{col 9}{c |}{col 12}`warn_joint_lovar`warn_num''{col 22}{c |}"
				}
				noi di as text "{col 9}{c BLC}{hline 12}{c BRC}"
				noi di as text ""
			}
			if `warn_joint_robus_num' > 0 {

				noi di as text "{pmore}In the following tests, F-tests are possible to calculate, but Stata issued a warning. Read more about this warning {help j_robustsingular:here}. Tests are reported with F-values and significance stars (if applicable), but these results might be unreliable.{p_end}"
				noi di as text ""

				noi di as text "{col 9}{c TLC}{hline 12}{c TRC}"
				noi di as text "{col 9}{c |}{col 13}Test{col 22}{c |}"
				noi di as text "{col 9}{c LT}{hline 12}{c RT}"

				forvalues warn_num = 1/`warn_joint_robus_num' {
					noi di as text "{col 9}{c |}{col 12}`warn_joint_robus`warn_num''{col 22}{c |}"
				}
				noi di as text "{col 9}{c BLC}{hline 12}{c BRC}"
				noi di as text ""
			}
		}

		noi di as error "{pstd}Stata issued one or more warnings in relation to the tests in this balance table. Read the warning(s) above carefully before using the values generated for this table.{p_end}"
		noi di as error "{hline}"
		noi di as text ""

	}

/*******************************************************************************

			*Prepare note string

*******************************************************************************/

	*Test if options tblnonote or tblnote are used - if not generate default note
	if missing("`tblnonote'") {
		if missing("`tblnote'") {
			generate_note, pout_lbl("`pout_lbl'") fix("`fixedeffect'") fix_used("`FIX_EFFECT_USED'") covars("`covariates'") `ftest' `feqtest' starlevels("`starlevels'") `stdev' vce("`vce'") vce_type("`vce_type'") clustervar("`cluster_var'") weight_used("`WEIGHT_USED'") weight_type("`weight_type'") weight_var("`weight_var'")

			 local note_to_use "`r(table_note)'"
		}
		* Use user specified note
		else local note_to_use `"`tblnote'"'
	}
	*Use no note
	else else local note_to_use ""

/*******************************************************************************

			* Return values to the user

*******************************************************************************/

	*Restore from orginial preserve at top of command
	restore

	*Remove the first row that was just a place holder
	matrix `rmat' = `rmat'[2...,1...]

	mat returnRMat = `rmat'
	mat returnFMat = `fmat'

	return matrix iebaltabrmat returnRMat
	return matrix iebaltabfmat returnFMat


/*******************************************************************************
********************************************************************************
		Export tables from results in the matrix
********************************************************************************
*******************************************************************************/

		******************************************
		*Set locals used regardless of export method

		** SE if standard errors are used (default) or SD if standard deviation is used
		if `STDEV_USED' == 1 	local vtype "sd"
		else local vtype "se"

		*Create the title for the column with number of observations/clusters
		if "`vce_type'" == "cluster" local ntitle "N/Clusters"
		else local ntitle "N"

		* Test that option onerow (if used) is ok - meaning the N is the same across rows
		if (!missing("`onerow'")) {
			isonerowok, rmat(`rmat') fmat(`fmat') stat("n") `ftest' `feqtest'
			if "`vce_type'" == "cluster" {
				isonerowok, rmat(`rmat') fmat(`fmat') stat("cl") `ftest' `feqtest'
			}
		}

		******************************************
		* Create tab delimited file and generate exports based on it

		* Test if any option that requires the tab delimited file is used
		if `SAVE_CSV_USED' | `SAVE_XSLX_USED' | `BROWSE_USED' {

			preserve

				* Since commas can be used in labels it is tricky to write a comma seperated
				* file (like csv) directly. Therefore, this function writes a tab delimited file
				* as tabs are never valid labels. Then this tab delimited file is insheeted and
				* this command use Stata's built in commands to export to csv and xlsx as those
				* commands has built in support for handling commas in labels and other corner cases
				noi export_tab , rmat(`rmat') fmat(`fmat') ///
					order_grp_codes(`ORDER_OF_GROUP_CODES') pairs(`TEST_PAIR_CODES') ///
					row_lbls(`"`ROW_LABELS'"') col_lbls(`"`COLUMN_LABELS'"')  ///
					pout_lbl(`pout_lbl') pout_val(`pout_val') fout_lbl(`fout_lbl') fout_val(`fout_val') ///
					tot_lbl("`tot_lbl'") `total' `onerow' `feqtest' `ftest'  ///
					ntitle("`ntitle'") note(`"`note_to_use'"') vtype("`vtype'") cl_used("`CLUSTER_USED'") ///
					diformat("`diformat'") starlevels("`starlevels'")

					*Save the tab delimited file
					tempfile tab_file
					save `tab_file'

					* Use Stata's built in commands for exporting to CSV
					if `SAVE_CSV_USED' export delimited using "`savecsv'", novarnames quote `replace'

					* Use Stata's built in commands for exporting to Excel format
					if `SAVE_XSLX_USED' export excel using "`savexlsx'", `replace'

			* Bring back the original data
			restore
			* Overwrite in working memory the original data so results can be browsed
			if `BROWSE_USED' use `tab_file', clear

		}

		******************************************
		* Create tex file based on result matrices

		// *Export to tex format
		// if `SAVE_TEX_USED' {
		// 	// Run subommand that exports table to tex
		// }
}
end


/*******************************************************************************
********************************************************************************

	Main export functions: tab delimited file from result matrices

********************************************************************************
*******************************************************************************/

* Read the result matrices and output the results in a tab delimited file
cap program drop 	export_tab
	program define	export_tab, rclass

	syntax , rmat(name) fmat(name) 					///
	ntitle(string) vtype(string) cl_used(string)		///
	col_lbls(string) order_grp_codes(numlist) ///
	pairs(string) diformat(string) ///
	row_lbls(string) tot_lbl(string) ///
	pout_lbl(string) pout_val(string) ///
	fout_lbl(string) fout_val(string) ///
	[note(string) onerow total feqtest ftest ///
	starlevels(string)]

	* If total is used, add t to locals used when looping over desc stats
	if !missing("`total'") local order_grp_codes "`order_grp_codes' t"
	if !missing("`total'") local col_lbls `"`col_lbls' "`tot_lbl'""'

	* Count groups and number of balance vars
	local grp_count : list sizeof order_grp_codes
	local row_count : list sizeof row_lbls

	* Get a local with one item for each desc stats column
	local desc_cols "`order_grp_codes'"
	if !missing("`feqtest'") local desc_cols "`desc_cols' feq"
	if missing("`onerow'") local desc_cols "`desc_cols' `desc_cols'"

	* If pair tests set to none, then set pairs to "" to not iterate that loop
	if "`pout_val'" == "none" local pairs ""

	*Create a temporary textfile
	tempname 	tab_name
	tempfile	tab_file

	******************************************************************************
	* Generate title rows
	******************************************************************************

	** The titles consist of three rows across all
	*  columns of the table. Each row is one local
	local titlerow1 ""
	local titlerow2 ""
	local titlerow3 `""Variable""'

	********* Descriptive group stats titles *************************************
	*Loop over each group to be used in descriptive stats section

	forvalues grp_colnum = 1/`grp_count' {

		*Get the code and label corresponding to the group
		local grp_lbl : word `grp_colnum' of `col_lbls'

		*Titles for each group depending on the option one row used or not
		if missing("`onerow'") {

			local titlerow1 `"`titlerow1' _tab "" "'
			local titlerow2 `"`titlerow2' _tab "" "'
			local titlerow3 `"`titlerow3' _tab "`ntitle'" "'
		}

		*Add titles for summary row stats
		local titlerow1 `"`titlerow1' _tab " (`grp_colnum') " "'
		local titlerow2 `"`titlerow2' _tab "`grp_lbl'"        "'
		local titlerow3 `"`titlerow3' _tab "Mean/`vtype'"     "'
	}


	********* joint orthogonality of each balance variable ***********************

	if !missing("`feqtest'") {

		if missing("`onerow'") {
			local titlerow1 `"`titlerow1' _tab "" "'
			local titlerow2 `"`titlerow2' _tab "" "'
			local titlerow3 `"`titlerow3' _tab "`ntitle'" "'
		}

		*Add titles for summary row stats
		local titlerow1 `"`titlerow1' _tab "Test for balance accross all variables" "'
		local titlerow2 `"`titlerow2' _tab "All groups" "'
		local titlerow3 `"`titlerow3' _tab "F-stat/P-value" "'
	}

	********* Test pairs titles **************************************************

	foreach pair of local pairs {

		*Get the group order from the two groups in each pair
		getCodesFromPair `pair'
		local order1 : list posof "`r(code1)'" in order_grp_codes
		local order2 : list posof "`r(code2)'" in order_grp_codes

		*Write test pair titles
		local titlerow1 `"`titlerow1' _tab "(`order1')-(`order2')""'
		local titlerow2 `"`titlerow2' _tab "Pairwise t-test""'
		local titlerow3 `"`titlerow3' _tab "`pout_lbl'""'

	}

	********* Write the title lines **********************************************

	*Write the title rows defined above
	cap file close 	`tab_name'
	file open  		`tab_name' using "`tab_file'", text write replace
	file write  	`tab_name' `titlerow1' _n `titlerow2' _n `titlerow3' _n
	file close 		`tab_name'

	******************************************************************************
	* Write data rows
	******************************************************************************

	forvalues row_num = 1/`row_count' {

		*Get the code and label corresponding to the group
		local row_lbl : word `row_num' of `row_lbls'

		********* Initiate row locals and write row label **************************

		*locals for each row
		local row_up   `""`row_lbl'""'
		local row_down `""' // Not used in onerow

		********* Write group descriptive stats ************************************

		foreach grp_code of local order_grp_codes {

			* Add column with N for this group unless option onerow is used
			if missing("`onerow'") {
				*Get N for this group
				local n_value = el(`rmat',`row_num',colnumb(`rmat',"n_`grp_code'"))
				*Get number of clusters if clusters were used
				local cl_n ""
				if `cl_used' == 1 local cl_n = el(`rmat',`row_num',colnumb(`rmat',"cl_`grp_code'"))
				* Write to row locals
				local row_up   `"`row_up'   _tab "`n_value'" "'
				local row_down `"`row_down' _tab "`cl_n'" "'
			}

			* Mean and variance for this group - get value from mat and apply format
			local mean_value = el(`rmat',`row_num',colnumb(`rmat',"mean_`grp_code'"))
			local var_value = el(`rmat',`row_num',colnumb(`rmat',"`vtype'_`grp_code'"))
			local mean_value : display `diformat' `mean_value'
			local var_value  : display `diformat' `var_value'
			local row_up   `"`row_up'   _tab "`mean_value'" "'
			local row_down `"`row_down' _tab "`var_value'" "'
		}

		********* Write Feq test stats (if applicable) *****************************

		if !missing("`feqtest'") {
			* Add column with N for the F test for all vars unless option onerow is used
			if missing("`onerow'") {
				* Get the N for this test
				local n_value = el(`rmat',`row_num',colnumb(`rmat',"feqn"))
				*Get number of clusters if clusters were used
				local cl_n ""
				if `cl_used' == 1 local cl_n = el(`rmat',`row_num',colnumb(`rmat',"feqcl"))
				* Write to row locals
				local row_up   `"`row_up'   _tab "`n_value'" "'
				local row_down `"`row_down' _tab "`cl_n'" "'
			}

			* F and p values for this test - get value from mat and apply format
			local f_value = el(`rmat',`row_num',colnumb(`rmat',"feqf"))
			local p_value = el(`rmat',`row_num',colnumb(`rmat',"feqp"))

			count_stars, p(`p_value') starlevels(`starlevels')
			local f_value : display `diformat' `f_value'
			local p_value  : display `diformat' `p_value'
			local row_up   `"`row_up'   _tab "`f_value'`r(stars)'" "'
			local row_down `"`row_down' _tab "`p_value'" "'
		}

		********* Write pair test stats ********************************************

		foreach pair of local pairs {
			* Pairwise test statistics for this pair - get value from mat and apply format
			local test_value = el(`rmat',`row_num',colnumb(`rmat',"`pout_val'_`pair'"))
			local test_value 	: display `diformat' `test_value'

			local p_value = el(`rmat',`row_num',colnumb(`rmat',"p_`pair'"))
			count_stars, p(`p_value') starlevels(`starlevels')

			local row_up   `"`row_up'   _tab "`test_value'`r(stars)'" "'
			local row_down `"`row_down' _tab "" "'
		}

		********* Write row locals *************************************************

		*Write the stats rows to tab file
		cap file close 	`tab_name'
		file open  		`tab_name' using "`tab_file'", text write append
		file write  	`tab_name' `row_up' _n `row_down' _n
		file close 		`tab_name'
	}

	******************************************************************************
	* Write f-test for pair test across all variables
	******************************************************************************

	if !missing("`ftest'") {

		* First column with row labels
		local frow_up   `""F-test of joint significance (`fout_lbl')""'
		local frow_down `""F-test, number of observations""' // Not used in onerow
		local frow_cl   `""F-test, number of clusters""'     // Only used with cluster and without onerow

		* Skip all group columns and skip total column if applicable
		foreach grp_code of local desc_cols {
			local frow_up 	`"`frow_up' _tab "" "'
			local frow_down `"`frow_down' _tab "" "'
			local frow_cl   `"`frow_cl' _tab "" "'
		}

		*Write fstats
		foreach pair of local pairs {
			* Pairwise test statistics for this pair - get value from mat and apply format
			local ftest_value = el(`fmat',1,colnumb(`fmat',"f`fout_val'_`pair'"))
			local ftest_value 	: display `diformat' `ftest_value'
			local ftest_n     = el(`fmat',1,colnumb(`fmat',"fn_`pair'"))
			local ftest_cl    = el(`fmat',1,colnumb(`fmat',"fcl_`pair'"))

			local p_value = el(`fmat',1,colnumb(`fmat',"fp_`pair'"))
			count_stars, p(`p_value') starlevels(`starlevels')

			local frow_up   `"`frow_up'   _tab "`ftest_value'`r(stars)'" "'
			local frow_down `"`frow_down' _tab "`ftest_n'" "'
			local frow_cl   `"`frow_cl'   _tab "`ftest_cl'" "'
		}

		*Write the fstats rows
		cap file close 	`tab_name'
		file open  		`tab_name' using "`tab_file'", text write append
													                  file write  `tab_name' `frow_up' _n
		if missing("`onerow'")                  file write  `tab_name' `frow_down' _n
		if missing("`onerow'") & `cl_used' == 1 file write  `tab_name' `frow_cl' _n
		file close 		`tab_name'
	}

	******************************************************************************
	* Write onerow N (if applicable)
	******************************************************************************

	if !missing("`onerow'") {

		*Initiate the row local for the N row if onerow is not missing
		local n_row  `""Number of observations""'
		local cl_row `""Number of clusters""'

		*Get the N for each group
		foreach grp_code of local order_grp_codes {
			* Get the N from the first row (they must be the same for onerow to work)
			local n_value  = el(`rmat',1,colnumb(`rmat',"n_`grp_code'"))
			local cl_value = el(`rmat',1,colnumb(`rmat',"cl_`grp_code'"))
			local n_row   `"`n_row'  _tab "`n_value'" "'
			local cl_row  `"`cl_row' _tab "`cl_value'" "'
		}

		*If feqtest was used, add the N from the first row
		if !missing("`feqtest'") {
			local n_value = el(`rmat',1,colnumb(`rmat',"feqn"))
			local cl_value = el(`rmat',1,colnumb(`rmat',"feqcl"))
			local n_row   `"`n_row' _tab "`n_value'" "'
			local cl_row  `"`cl_row' _tab "`cl_value'" "'
		}

		*Get the N/cl from each pair
		foreach pair of local pairs {
			local n_value  = el(`rmat',1,colnumb(`rmat',"n_`pair'"))
			local cl_value = el(`rmat',1,colnumb(`rmat',"cl_`pair'"))
			local n_row   `"`n_row' _tab "`n_value'" "'
			local cl_row  `"`cl_row' _tab "`cl_value'" "'
		}

		*Write the N row to file
		cap file close 	`tab_name'
		file open  		`tab_name' using "`tab_file'", text write append
		                  file write `tab_name' `n_row' _n
		if `cl_used' == 1 file write `tab_name' `cl_row' _n
		file close 		`tab_name'
	}

	******************************************************************************
	* Write table note
	******************************************************************************
	if !missing("`note'") {
		*Write the table note if one is defined
		cap file close 	`tab_name'
		file open  		`tab_name' using "`tab_file'", text write append
		file write  	`tab_name' "`note'" _n
		file close 		`tab_name'
	}

	******************************************************************************
	* Import tabfile to memory
	******************************************************************************

	* Import tab file to memory to be exported as csv, xlsx or be browsed.
	* Tabs are used as they are never used in labels, making manual writing easier
	insheet using "`tab_file'", tab clear

end

/*******************************************************************************
********************************************************************************

	Main export functions: tex file from result matrices

********************************************************************************
*******************************************************************************/

cap program drop 	export_tex
	program define	export_tex

	syntax using , rmat(name) fmat(name) [note(string)]

	noi mat list `rmat'
	noi mat list `fmat'

end

/*******************************************************************************
********************************************************************************

	Utility functions

********************************************************************************
*******************************************************************************/

/*******************************************************************************
  test_parse_label_input: pars and test item/label lists
	* Test that lists are on format "item1 label1 @ item2 label2"
	* Test that each item listed is used in itemlist (groupcode or balance var)
	* Test hat no label is missing for items included
*******************************************************************************/
cap program drop 	test_parse_label_input
	program define	test_parse_label_input, rclass

	syntax, labelinput(string) itemlist(string) [row column grpvar(string)]

	if !missing("`row'") {
		local optionname "rowlabels"
		local listoutput "the name of any of the balance variables used"
		local itemname "balance variable"
	}
	else if !missing("`column'") {
		local optionname "grplabels"
		local listoutput "a value used in grpvar(`grpvar')"
		local itemname "group code"
	}
	else noi di as error "{phang}test_parse_label_inpu: either [row] or [column] must be used.

	local labelinput_tokenize "`labelinput'"

	* Loop over each item/label pair
	while "`labelinput_tokenize'" != "" {

		*Parsing item/label pairs and then split to item and label
		gettoken item_label labelinput_tokenize : labelinput_tokenize, parse("@")
		gettoken item label : item_label
		local label = trim("`label'") //Removing leadning or trailing spaces

		*Test that item is part of item list
		if `: list item in itemlist' == 0 {
			noi display as error `"{phang}Item [`item'] in `optionname'("`labelinput'") is not `listoutput'.{p_end}"'
			error 198
		}

		*Testing that no label is missing
		if "`label'" == "" {
			noi display as error `"{phang}For item [`item'] listed in `optionname'("`labelinput'") there is no label specified. Not all `itemname's need to be listed, but those listed must have a label. Omitted `itemname's get the deafult label. See {help iebaltab:help file} for more details.{p_end}"'
			error 198
		}

		*Storing the code in local to be used later
		local items "`items' `item'"
		local labels `"`labels' "`label'""'

		*Parse char is not removed by gettoken
		local labelinput_tokenize = subinstr("`labelinput_tokenize'" ,"@","",1)
	}

	return local items  "`items'"
	return local labels `"`labels'"'

end


/*******************************************************************************
  getCodesFromPair:  to get codes from a test pair and test them
	* From a test pair like 4_9 it tests that both codes are numbers and that they
	* are not the same, then returns code left of "_" as code1 and code right of "_"
	* as code2.
*******************************************************************************/
cap program drop 	getCodesFromPair
	program define	getCodesFromPair, rclass

	args pair

	* Parse the two codes from the test pair
	local undscr_pos  = strpos("`pair'","_")
	local code1 = substr("`pair'",1,`undscr_pos'-1)
	local code2 = substr("`pair'",  `undscr_pos'+1,.)

	*Test that the codes are just numbers and that they are not identical
	cap confirm number `code1'`code2'
	if _rc {
		noi display as error "{phang}Both codes [`code1'] & [`code2'] in pair [`pair'] must be numbers.{p_end}"
		error 7
	}
	if `code1' == `code2' {
		noi display as error "{phang}The codes in [`pair'] may not be identical.{p_end}"
		error 7
	}

    * Return second first so they are listed in correct order
	* when using return list
	return local code2 `code2'
	return local code1 `code1'

end

/*******************************************************************************
  isonerowok: test if values in matrices are valid for option onerow
	* In order to onerow to work, the values in colums with number of observations
	* must be the same for all rows. The same applies to the number of clusters if
	* clusters are used. This functions tests that.
*******************************************************************************/
cap program drop 	isonerowok
	program define	isonerowok

	syntax , rmat(name) fmat(name) stat(string) [ftest feqtest]

	*stat may only be "n" or "cl"
	if "`stat'" == "n"  local unit "observations"
	if "`stat'" == "cl" local unit "clusters"

	local not_ok_grps ""

	* Get all column names that starts on n_, i.e. all cols with N
	local all_cnames : colnames `rmat'
	local groups_and_pairs ""
	foreach cols_name of local all_cnames {
		if substr("`cols_name'",1,2) == "`stat'_" {
			local group_or_pair = substr("`cols_name'",3,.)
			local groups_and_pairs "`groups_and_pairs' `group_or_pair'"
		}
	}

	*Get number of rows in rmat
	local matrows  : rowsof `rmat'

	*loop over all columns that start with n
	foreach g_or_p of local groups_and_pairs {
		*Store the value of the first row of rmat
		local nval = el(`rmat',1,colnumb(`rmat',"`stat'_`g_or_p'"))

		* If matrix has more than 1 row, then loop over those rows and
		* test that n_ is the same
		forvalues row = 2/`matrows' {
			if `nval' != el(`rmat',`row',colnumb(`rmat',"`stat'_`g_or_p'")) {
				local not_ok_grps : list not_ok_grps | g_or_p
			}
	  }

		* If ftest was used, and g_or_p is a pair like i_j then
		* test if the value for the pair is the same
		if !missing("`ftest'") & strpos("`g_or_p'","_") > 0 {
			if `nval' != el(`fmat',1,colnumb(`fmat',"f`stat'_`g_or_p'")) {
				local not_ok_grps : list not_ok_grps | g_or_p
			}
		}
	}

	* Test all rows for feqtest
	if !missing("`feqtest'") {
		*Store the value of the first few row of rmat
		local nval = el(`rmat',1,colnumb(`rmat',"feq`stat'"))
		* If matrix has more than 1 row, then loop over those rows and
		* test that n_ is the same
		forvalues row = 2/`matrows' {
			if `nval' != el(`rmat',`row',colnumb(`rmat',"feq`stat'")) {
				local not_ok_grps : list not_ok_grps | feqtest
			}
	  }
	}

	* Display error if any
	if ("`not_ok_grps'" != "") {
		local not_ok_grps : list sort not_ok_grps
		noi di as error "{pstd}Option {input:onerow} may only be used if the number of `unit' with non-missing values are the same in all groups across all balance variables. This is not true for group(s): [`not_ok_grps']. Run the command again without this options to see in which column the number of `unit' is not the same for all rows.{p_end}"
		error 499
	}
end

/*******************************************************************************
  count_stars: count number of stars given p-value and star levels
	* Returns a string with the number of stars given a p-value and the list of
	* starlevels. If starlevels is empty (if option starsnoadd is used) then it
	* will always return the empty string "".
*******************************************************************************/
cap program drop 	count_stars
	program define	count_stars, rclass

	syntax, p(numlist) [starlevels(string)]

	local stars ""
	if !missing("`starlevels'") {
		tokenize "`starlevels'"
		if `p' < `1' local stars "*"
		if `p' < `2' local stars "**"
		if `p' < `3' local stars "***"
	}

	return local stars "`stars'"
end

/*******************************************************************************
  generate_note: generate a note documenting options used
	* Returns a note meant to be used in tables to document what options are used.
	* For example, what variable to use as fixed effect etc. This note is not
	* meant to be a final note for a published table, but more as a way to automate
	* documenting what options generated what results during explorative analys
*******************************************************************************/
cap program drop 	generate_note
	program define	generate_note, rclass

	syntax, pout_lbl(string) [fix(string) fix_used(string) covars(string) ftest feqtest ///
	starlevels(string)  stdev vce(string) ///
	vce_type(string) clustervar(string) weight_used(string) weight_type(string) weight_var(string) ]

	local table_note ""

	* Test sentence
	local test_sentence = ""
	if !missing("`ftest'`feqtest'") & "`pout_lbl'" != "none" {
		local test_sentence = "pairwise and f-test regressions"
	}
	else if !missing("`ftest'`feqtest'") local test_sentence = "f-test regressions"
	else if "`pout_val'" != "none"       local test_sentence = "pairwise regressions"


	if !missing("`covars'") local table_note "`table_note' Covariates used in `test_sentence': [`covars']."
	if `fix_used' == 1      local table_note "`table_note' Fixed effect used in `test_sentence': [`fix']."

	if !missing("`starlevels'") {
		tokenize "`starlevels'"
		local signint1 = 100 - (`1' * 100)
		local signint2 = 100 - (`2' * 100)
		local signint3 = 100 - (`3' * 100)
		local table_note "`table_note' Significance: ***=`signint3'%, **=`signint2'%, *=`signint1'%."
	}

	if !missing("`vce'") {
		*Display variation in Standard errors (default) or in Standard Deviations
		if missing("`stdev'") local vname "Standard errors"
		else                  local vname "Standard deviations"
		if "`vce_type'" == "robust"		 local table_note "`table_note' `vname' are robust. "
		if "`vce_type'" == "cluster"   local table_note "`table_note' `vname' are clustered at variable [`clustervar']. "
		if "`vce_type'" == "bootstrap" local table_note "`table_note' `vname' are estimeated using bootstrap. "

	}

	if `weight_used' == 1 {

		local f_weights "fweights fw freq weight"
		local a_weights "aweights aw"
		local p_weights "pweights pw"
		local i_weights "iweights iw"

		if `:list weight_type in f_weights' local weight_type = "frequency"
		else if `:list weight_type in a_weights' local weight_type = "analytical"
		else if `:list weight_type in p_weights' local weight_type = "probability"
		else if `:list weight_type in i_weights' local weight_type = "importance"

		local table_note "`table_note' Observations are weighted using variable `weight_var' as `weight_type' weights."
  }

	return local table_note `table_note'
end
