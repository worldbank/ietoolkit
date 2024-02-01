*! version 7.3 01FEB2024 DIME Analytics dimeanalytics@worldbank.org

	capture program drop   iebaltab,
	        program define iebaltab, rclass

		syntax varlist(numeric) [if] [in] [aw fw pw iw],                    ///
                                                                        ///
        [                                                               ///
        /*Required options - GRPVar deprecated name still allowed */    ///
				GROUPvar(varname) GRPVar(varname)                              ///
				                                                                ///
				/*Column and row options*/                                      ///
				COntrol(numlist int max=1) ORder(numlist int min=1)             ///
				TOTal onerow                                                    ///
                                                                        ///
				/*Estimation options*/                                          ///
				vce(string) FIXedeffect(varname) COVariates(varlist ts fv) 	    ///
				FTest FEQTest WEIGHTold(string)                                 ///
                                                                                ///
				/*Stat display options*/                                        ///
				stats(string)                                                   ///
				STARlevels(numlist descending min=3 max=3 >0 <1)			          ///
				NOSTARs FORMat(string)                                          ///
				                                                                ///
				/*Label/notes options*/                                         ///
				GROUPCodes GROUPLabels(string) TOTALLabel(string)               ///
        ROWVarlabels ROWLabels(string)                                  ///
        addnote(string) nonote                                          ///
			                                                                  ///
				/*Export and restore*/                                          ///
				BRowse SAVEXlsx(string) SAVECsv(string) SAVETex(string)         ///
				texnotefile(string) REPLACE                                     ///
				                                                                ///
				/*LaTeX options*/     				                                  ///
				TEXNotewidth(numlist min=1 max=1)                               ///
				TEXCaption(string) TEXLabel(string) TEXDOCument	                ///
				texcolwidth(string)                                             ///
				                                                                ///
        /*Deprecated names: still allowed for backward compatibility*/  ///
        GRPCodes GRPLabels(string) STARSNOadd TBLNONote                 ///
                                                                        ///
				/* Deprecated options - still included to throw                 ///
				helpful error if ever used */                                   ///
				SAVEBRowse SAVE(string) BALMISS(string) BALMISSReg(string)      ///
				COVMISS(string) COVMISSReg(string) MISSMINmean(string)          ///
				COVARMISSOK FMissok NOTtest	fnoobs NORMDiff STDev PTtest        ///
				PFtest PBoth NOTECombine texvspace(string) TBLNote(string)      ///
				]

  local full_user_input = "iebaltab " + trim(itrim(`"`0'"'))
  local full_user_input : subinstr local full_user_input "\" "/" , all

  *Add space between code and output
  noi di ""

  preserve
qui {

	*Set minimum version for this command
	version 12

	/***********************************************
	************************************************

		Version, weight and if/in sample

	*************************************************
	************************************************/

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

		Some initial locals and option handling

	*************************************************
	************************************************/

		*Create local for balance vars with more descriptive name
		local balancevars `varlist'

		*Create place holders for the two result matrices
		tempname rmat fmat

		*Local to indicate if manual effects are included
		if missing("`fixedeffect'") local FIX_EFFECT_USED = 0
		else                        local FIX_EFFECT_USED = 1

    /***********************************************
			Deprecated names
		************************************************/

    * GRPVar is now called groupVar
    if missing("`groupvar'") & !missing("`grpvar'") ///
      local groupvar "`grpvar'"
    if missing("`groupvar'") {
      di as error `"{pstd}The option {input:groupvar()} is required.{p_end}"'
      error 198
    }

    * grpcodes is now called groupcodes
    if missing("`groupcodes'") & !missing("`grpcodes'") ///
      local groupcodes "groupcodes"
    * grplabels is now called grouplabels
    if missing("`grouplabels'") & !missing("`grplabels'") ///
      local grouplabels "`grplabels'"

    * tblnonote is now called nonote
    if "`note'" != "nonote" & !missing("`tblnonote'") ///
        local note "nonote"
    if "`note'" != "nonote" local note "note"

    * starsnoadd is now called nostars
    if "`stars'" != "nostars" & !missing("`starsnoadd'") ///
        local stars "nostars"
    if "`stars'" != "nostars" local stars "stars"


		/***********************************************
			Deprecated options
		************************************************/

		local old_version_guide `"If you still need the old version of iebaltab, for example for reproduction of old code, see {browse  "https://github.com/worldbank/ietoolkit/blob/master/admin/run-old-versions.md" :this guide} for how to run old versions of any command in the ietoolkit package."'

		if !missing("`savebrowse'`save'") {
			di as error `"{pstd}The options {input:savebrowse}, {input:save} and {input:browse} have been deprecated as of version 7 of iebaltab. See if the options {input:savexlsx}, {input:savecsv} or {input:browse} have the functionality you need. `old_version_guide'{p_end}"'
			error 198
		}
		if !missing("`balmiss'`balmissreg'`covmiss'`covmissreg'`missminmean'`covarmissok'`fmissok'") {
			di as error `"{pstd}The options {input:balmiss}, {input:balmissreg}, {input:covmiss}, {input:missminmean}, {input:covarmissok} and {input:fmissok} have been deprecated as of version 7 of iebaltab. Instead, if needed and/or desired, you must modify missing values yourself before running the command. `old_version_guide'{p_end}"'
			error 198
		}
		if !missing("`nottest'`normdiff'`pttest'`pftest'`pboth'`stdev'") {
			di as error `"{pstd}The options {input:nottest}, {input:normdiff}, {input:pttest}, {input:pftest}, {input:pboth} and {input:stdev} have been deprecated as of version 7 of iebaltab. See if the option {input:stats()} has the functionality you need. `old_version_guide'{p_end}"'
			error 198
		}
		if !missing("`fnoobs'") {
			di as error `"{pstd}The option {input:fnoobs} has been deprecated as of version 7 of iebaltab. See the {help iebaltab} help file for more information. `old_version_guide'{p_end}"'
			error 198
		}
    if !missing("`texvspace'") {
      di as error `"{pstd}The option {input:texvspace} has been deprecated as of version 7 of iebaltab. See the {help iebaltab} help file for more information. `old_version_guide'{p_end}"'
      error 198
    }
    if !missing("`notecombine'`tblnote'") {
      di as error `"{pstd}The options {input:tblnote} and {input:notecombine} have been deprecated as of version 7 of iebaltab. See the {help iebaltab} for the options {opt addnote()} and {opt nonote} that has replaced this option. `old_version_guide'{p_end}"'
      error 198
    }

/*******************************************************************************

		* Testing the group variable

*******************************************************************************/

		* Test that the groupvar is not one of the balancevars
		if `: list groupvar in balancevars' {
			noi display as error  "{phang}The variable [`groupvar'] may not be in both groupvar(`groupvar') and the varlist used as balance variables [`balancevars'].{p_end}"
			error 198
		}

    * Tests if groupvar is numeric type
		cap confirm numeric variable `groupvar'
		if _rc == 0 {

			* Test that groupvar only consists if integers
			cap assert (int(`groupvar') == `groupvar')
			if _rc == 9 {
				noi display as error  "{phang}The variable in groupvar(`groupvar') is not a categorical variable. The variable may only include integers. See tabulation of `groupvar' below:{p_end}"
				noi tab `groupvar', nol
				error 109
			}
		}

		* Tests if groupvar is string type
		else {

			*Test for options not allowed if groupvar is a string variable
			if !missing("`control'`order'`groupcodes'`grouplabels'") {
				local str_invalid_opt ""
				if !missing("`control'")   local str_invalid_opt "`str_invalid_opt' control()"
				if !missing("`order'")     local str_invalid_opt "`str_invalid_opt' order()"
				if !missing(`"`grouplabels'"') local str_invalid_opt "`str_invalid_opt' grouplabels()"
				local str_invalid_options_used = itrim(trim("`str_invalid_opt' `groupcodes'"))
				di as error "{pstd}The option(s) [`str_invalid_options_used'] can only be used when variable {input:groupvar(`groupvar')} is a numeric variable. Use {help encode} to generate a numeric version of the variable {input:`groupvar'}.{p_end}"
				error 198
			}

			*Generate a encoded numeric tempvar variable from string groupvar
			tempvar groupvar_code
			encode `groupvar' , gen(`groupvar_code')

			*replace the groupvar local so that it uses the tempvar instead
			local groupvar `groupvar_code'
		}

		*Remove observations with a missing value in groupvar()
		drop if missing(`groupvar')

		*Create a local of all codes in group variable
		levelsof `groupvar', local(GRP_CODES)

		*Saving the name of the value label of the groupvar()
		local GRPVAR_VALUE_LABEL 	: value label `groupvar'

		*Static dummy for groupvar() has no label
		if "`GRPVAR_VALUE_LABEL'" == "" local GRPVAR_HAS_VALUE_LABEL = 0
		if "`GRPVAR_VALUE_LABEL'" != "" local GRPVAR_HAS_VALUE_LABEL = 1


/*******************************************************************************

		* Testing options related to order and lables of table columns and rows

*******************************************************************************/

	*****************************
	** Test column order inputs

		** Test if any value used in control is a code used in groupvar
		if `: list control in GRP_CODES' == 0 {
			noi display as error "{phang}The code listed in control(`control') is not used in groupvar(`groupvar'). See tabulation of `groupvar' below:{p_end}"
			noi tab `groupvar', nol
			error 197
		}

		** Test if any value used in order is a code used in groupvar
		if `: list order in GRP_CODES' == 0 {
			noi display as error  "{phang}One or more codes listed in order(`order') are not used in groupvar(`groupvar'). See tabulation of `groupvar' below:{p_end}"
			noi tab `groupvar', nol
			error 197
		}

    *****************************
    ** Test and parse column label inputs
    if !missing(`"`grouplabels'"') {
      noi test_parse_label_input, labelinput(`"`grouplabels'"') ///
      itemlist("`GRP_CODES'") column groupvar(`groupvar')
      local grpLabelCodes  "`r(items)'"
      local grpLabelLables `"`r(labels)'"'
    }

    *****************************
    ** Test and parse row label inputs
    if  !missing("`rowlabels'") {
      noi test_parse_label_input, labelinput(`"`rowlabels'"') ///
      itemlist("`balancevars'") row
      local rowLabelNames  "`r(items)'"
      local rowLabelLabels `"`r(labels)'"'
    }

		*****************************
		* Warning if totallabel is used without total. Only warning as there is
		* nothing preventing the comamnd to continue as normal
		if !missing("`totallabel'") & missing("`total'") {
			noi display as text "{phang}Warning: Option {input:totallabel(`totallabel')} is ignored as option {input:total} was not used.{p_end}"
		}

/*******************************************************************************

		* Testing Stats Options

*******************************************************************************/

		****************************************************************************
		** Test input for user specified stats

		parse_and_clean_stats, stats("`stats'")
		local stats_string "`r(stats_string)'"

		* If ftest not used, issue warning if preference for ftest was specified
		if missing("`ftest'") {
			get_stat_label_stats_string, stats_string("`stats_string'") testname("f")
			if `r(deafult_used)' == 0 noi di as text "{phang}{input:Warning:} A stats perference was specified in [stats(`stats')] for F test across all variables, but no such test will be done as the option [ftest] for that test was not specified.{p_end}"
		}

		* If feqtest not used, issue warning if preference for feqtest was specified
		if missing("`feqtest'") {
			get_stat_label_stats_string, stats_string("`stats_string'") testname("feq")
			if `r(deafult_used)' == 0 noi di as text "{phang}{input:Warning:} A stats perference was specified in [stats(`stats')] for F test across all groups, but no such test will be done as the option [feqtest] for that test was not specified.{p_end}"
		}

		* If feqtest not used, issue warning if preference for feqtest was specified
		get_stat_label_stats_string, stats_string("`stats_string'") testname("pair")
		if "`r(stat)'" == "none" & !missing("`ftest'") {
			noi di as text "{phang}{input:Warning:} The option [ftest] cannot be combined with [pair(none)] in [stats(`stats')] as there would be nowhere to display the F-test results. The option [ftest] is therefore ignored.{p_end}"
			local ftest ""
		}

		****************************************************************************
		** VCE input testing
		local CLUSTER_USED 0
		if !missing("`vce'") {
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
					noi display as error "{phang}The cluster variable in vce(`vce') does not exist or is invalid for any other reason. See {help vce_option :help vce_option} for more information.{p_end}"
					error _rc
				}
			}
			else if "`vce_type'" == "bootstrap" {
				get_stat_label_stats_string, stats_string("`stats_string'") testname("desc")
			    local dout_val "`r(stat)'"
				get_stat_label_stats_string, stats_string("`stats_string'") testname("pair")
				local pout_val "`r(stat)'"
				if ("`dout_val'" == "var") | ("`pout_val'" == "nrmb") | ("`pout_val'" == "nrmd") {
					noi display as error "{phang}The vce type {input:bootstrap} may not be combines with {input:desc(var)}, {input:pair(nrmb)} or {input:pair(nrmd)} in {input:stats(`stats')}.{p_end}"
					error 198
				}
			}
			else if "`vce_type'" == "robust" {
				*no test needed here, always allowed
			}
			* Test that the vce_type is among any of the remaining options
			* that does not need any extra testing, if not among then, throw an error.
			else {
				noi display as error "{phang}The vce type `vce_type' in vce(`vce') is not allowed. Only robust, cluster and bootstrap are allowed. See {help vce_option :help vce_option} for more information.{p_end}"
				error 198
			}
		}


		****************************************************************************
		** Star level input handling

		* Surpress stars if nostars is used
		if "`stars'" == "nostars" local starlevels ""
		*If nostar not used and starlevels not specified, use defaults
		else if missing("`starlevels'") local starlevels ".1 .05 .01"

		****************************************************************************
		** Test input for fixed effects and output warning if missing values

		if !missing("`fixedeffect'") {
			cap assert `fixedeffect' < .
			if _rc == 9 {
				noi display as text "{phang}{input:Warning:} At least one observation in the sample has at least one missing value in a variable used in {input:fixedeffect(`fixedeffect')}. Before using the generated results, make sure that the number of observations in the table is as expected.{p_end}"
			}
		}

		****************************************************************************
		** Test input for fixed effects and output warning if missing values

		if !missing("`covariates'") {
			local covar_balancevars ""
			foreach covar of local covariates {
				cap assert `covar' < .
				if _rc == 9 {
					noi display as text "{phang}{input:Warning:} At least one observation in the sample has at least one missing value in the variable [`covar'] used in {input:covariates(`covariates')}. Before using the generated results, make sure that the number of observations in the table is as expected.{p_end}"
				}

				* Prepare a local of all covariates that is also a balance var (not allowed)
				if `: list covar in balancevars' local covar_balancevars =trim("`covar_balancevars' `covar'")
			}

			* Thorw error if any covariates were found among the balance vars
			if "`covar_balancevars'" != "" {
					noi display as error "{phang}The covariate variable(s) [`covar_balancevars'] is/are also among the  balance variable(s) [`balancevars'] which is not allowed.{p_end}"
					error 198
			}
		}

		****************************************************************************
		** Test input for weights

		if !missing("`weight'") {
			* Parsing weight options
			local weight_type = "`weight'"
			* Parsing keeps the separating character
			local weight_var = subinstr("`exp'","=","",.)

			* Test is weight type specified is valie
			local valid_weight_options "fweights pweights aweights iweights fweight pweight aweight iweight fw freq weight pw aw iw"
			if `:list weight_type in valid_weight_options' == 0 {
				noi display as error  "{phang} The option `weight_type' specified in {input:weight(`weight_type')} is not a valid weight option. Valid weight options are: [`valid_weight_options'].{p_end}"
				error 198
			}

			* Test is weight variable specified is valid
			capture confirm variable `weight_var'
			if _rc {
				noi display as error  "{phang} The variable `weight_var' specified in option {input:weight(`weight_var')} is not a variable.{p_end}"
				error 198
			}
		}

		/*******************************************************************************

				* Testing Output options

		*******************************************************************************/

		****************************************************************************
		** Test input for format

		** If the format option is specified, then test if there is a valid format specified
		if !missing("`format'") {
			test_parse_format, format("`format'")
			local diformat = "`r(diformat)'"
		}
		*Use default value if format not specified
		else local diformat = "%9.3f"

		****************************************************************************
		** Test file paths for save options

		if !missing("`savecsv'") {
			test_parse_file_input, filepath(`savecsv') allowedformats(".csv") defaultformat(".csv") option("savecsv")
			local savecsv "`r(filepath)'"
		}
		if !missing("`savexlsx'") {
			test_parse_file_input, filepath(`savexlsx') allowedformats(".xlsx .xls") defaultformat(".xlsx") option("savexlsx")
			local savexlsx "`r(filepath)'"
		}
		if !missing("`savetex'") {
			test_parse_file_input, filepath(`savetex') allowedformats(".tex") defaultformat(".tex") option("savetex")
			local savetex "`r(filepath)'"
		}
		if !missing("`texnotefile'") {

      * texnotefile cannot be used if nonote is also used
      if "`note'" == "nonote" & missing(`"`addnote'"') {
        noi display as error `"{phang}The option {inp:texnotefile()} cannot be used if the option {inp:nonote} is used without the option {opt addnote()}.{p_end}"'
        error 198
      }

			test_parse_file_input, filepath(`texnotefile') allowedformats(".tex") defaultformat(".tex") option("texnotefile")
			local texnotefile "`r(filepath)'"
		}

		/*******************************************************************************

				* Testing tex foramtting Options

		*******************************************************************************/

		* Check tex options
		if !missing("`savetex'") {
			* Note width must be positive
			if !missing("`texnotewidth'") {
				if `texnotewidth' <= 0 {
					noi display as error `"{phang}The value specified in texnotewidth(`texnotewidth') is non-positive. Only positive numbers are allowed. For more information, {net "from http://en.wikibooks.org/wiki/LaTeX/Lengths.smcl":check LaTeX lengths manual}.{p_end}"'
					error 198
				}
			}

			* Escape tex characters in caption string
			if !missing("`texcaption'") {
				* Make sure special characters are displayed correctly
				local texcaption : subinstr local texcaption "%"  "\%" , all
				local texcaption : subinstr local texcaption "_"  "\_" , all
				local texcaption : subinstr local texcaption "&"  "\&" , all
			}

			* Tex label must be a single word
			if !missing("`texlabel'") {
				local label_words : word count `texlabel'
				if `label_words' != 1 {
					noi display as error `"{phang}The value specified in texlabel(`texlabel') is not allowed. For more information, {browse "https://en.wikibooks.org/wiki/LaTeX/Labels_and_Cross-referencing":check LaTeX labels manual}.{p_end}"'
					error 198
				}
			}

			* texcaption and texlabel may not be used if texdocument is not used
			if (!missing("`texcaption'`texlabel'") & missing("`texdocument'")) {
				noi display as error "{phang}Options texlabel and texcaption may only be used in combination with option texdocument {p_end}"
					error 198
			}

			if !missing("`texcolwidth'") {

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
		}

		* Error for incorrectly using tex options
		else if !missing("`texnotewidth'`texlabel'`texcaption'`texdocument'`texcolwidth'") {
			noi display as error "{phang}Options texnotewidth(), texdocument, texlabel(), texcaption() and texcolwidth() may only be used in combination with option savetex(){p_end}"
			error 198
		}


/*******************************************************************************
*******************************************************************************/

		* Set up the result matrix that will store all the results

/*******************************************************************************
*******************************************************************************/

	  	************************************************
	  	*Group order

		*List all codes in order_code_rest
		local order_code_rest `GRP_CODES'

    	* First - use manually specified groups from order()
		if !missing("`order'") {
			local ORDER_OF_GROUP_CODES `order'
			local order_code_rest : list GRP_CODES - order
		}

		* Second - if control used and was not specified in order already
		if !missing("`control'") & !`: list control in order' {
			local ORDER_OF_GROUP_CODES `ORDER_OF_GROUP_CODES' `control'
			local order_code_rest : list order_code_rest - control
		}

		* Last - apply all other codes in alphanumeric order
		local ORDER_OF_GROUP_CODES `ORDER_OF_GROUP_CODES' `order_code_rest'

		************************************************
		*Feq-test equation

		* Loop from the second element in the list of group codes to the last and
		* create a list on the format 2.tmt=3.tmt=0 where tmt is the groupvar and the
		* first value is dropped as the regression that test for joint orthogonality
		* for across all groups for each balance var will drop the lowest value in groupvar.
		local FEQTEST_INPUT ""
		forvalues grp_code_count = 2/`: word count `GRP_CODES'' {
			local this_code : word `grp_code_count' of `GRP_CODES'
			local FEQTEST_INPUT "`FEQTEST_INPUT'`this_code'.`groupvar'="
		}
		local FEQTEST_INPUT "`FEQTEST_INPUT'0"

		************************************************
		*Generate list of test pairs

		local TEST_PAIR_CODES = ""

		if !missing("`control'") {
			*Loop over all non-control codes and create pairs with them and the control code
			local non_control_codes : list ORDER_OF_GROUP_CODES - control
			foreach code_2 of local non_control_codes {
				local TEST_PAIR_CODES = "`TEST_PAIR_CODES' `code_2'_`control'"
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
			replace `dummy_pair_`ttest_pair'' = 1 if `groupvar' == `code1'
			replace `dummy_pair_`ttest_pair'' = 0 if `groupvar' == `code2'
		}

		* Set up the matrix for all stats and estimates
		noi setUpResultMatrix, order_of_group_codes(`ORDER_OF_GROUP_CODES') test_pair_codes(`TEST_PAIR_CODES')
		mat emptyRow  = r(emptyRow)
		mat `rmat' = r(emptyRow)
		mat `fmat'  = r(emptyFRow)

		local desc_stats   `r(desc_stats)'
    local pair_stats   `r(pair_stats)'
		local feq_stats    `r(feq_stats)'
		local ftest_stats  `r(ftest_stats)'

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
				local group_label : word `grpLabelPos' of `grpLabelLables'
				local	COLUMN_LABELS `"`COLUMN_LABELS' `"`group_label'"'"'
			}

			************
			* Use code as column label

			* If option groupcodes was used or groupvar has no value label,
      * then the codes must be used as column labels
			else if !missing("`groupcodes'") | !`GRPVAR_HAS_VALUE_LABEL' {
				*Not using value labels, simply using the group code as the label in the final table
				local	COLUMN_LABELS `"`COLUMN_LABELS' `"`groupCode'"'"'
			}

			************
			* Use value label in groupvar as column label

			* Grpvar has value labels and groupcodes was not used,
      * then use value labels as code labels
			else {
				*Get the value label corresponding to this code and use as label
				local gprVar_valueLabel : label `GRPVAR_VALUE_LABEL' `groupCode'
				local COLUMN_LABELS `"`COLUMN_LABELS' `"`gprVar_valueLabel'"'"'
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
				local ROW_LABELS `"`ROW_LABELS' `"`row_label'"'"'
			}

			************
			* Use var label in balance var as row label

			*Use variable label if option is specified
			else if !missing("`rowvarlabels'") {
				*Get the variable label used for this variable and trim it
				local var_label : variable label `balancevar'
				local var_label = trim("`var_label'")
				* If varaible label exists, use it, oterwise use the variable name
				if "`var_label'" != "" local ROW_LABELS `"`ROW_LABELS' `"`var_label'"'"'
				else local ROW_LABELS `" `ROW_LABELS' `"`balancevar'"' "'
			}

			************
			* Use variable name as row label
			* If no manually row labels are defined, and option rowvarlabels is
			* not used, then use balance var name
			else local ROW_LABELS `" `ROW_LABELS' `"`balancevar'"' "'
		}

		************************************************
		* Prepare column label for total column

		* Use custom total label or default : "Total"
		if !missing("`totallabel'" ) local tot_lbl `totallabel'
		else local tot_lbl "Total"

/*******************************************************************************
*******************************************************************************/

		* Generate all stats and estimates

/*******************************************************************************
*******************************************************************************/

	*****************************************************************************
	*** Setting default values or specified values for fixed effects and clusters

		**********************************
		* If a fixed effect var is not specified, so that areg may be uses. A
		* fixed effect with no variation does not have any effect on the estimates
		if missing("`fixedeffect'") {
			tempvar  fixedeffect
			gen 	`fixedeffect' = 1
		}

		**********************************
		*Preparing cluster option

		* The varname for cluster is prepared to be put in the areg options. If
		* option vce() was not used then this local will be left empty
		if !missing("`vce'") local error_estm vce(`vce')

		**********************************
		*Preparing weight option

		* The varname for weight is prepared to be put in the reg options. If no
		* weight was used then this option will be left empty
		if !missing("`weight'") local weight_option "[`weight_type' = `weight_var']"

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

				//noi di "Desc stats. Var [`balancevar'], group code [`group_code']"
				reg `balancevar' if `groupvar' == `group_code' `weight_option', `error_estm'

				*Number of observation for this balancevar for this group
				mat row[1,`++colindex'] = e(N)
				*If clusters used, number of clusters in this balance var for this group, otherwise .c
				local ++colindex
				if "`vce_type'" == "cluster" mat row[1,`colindex'] = e(N_clust)
				else mat row[1,`colindex'] = .c
				*Mean of balance var for this group
				mat row[1,`++colindex'] = _b[_cons]
				*Variance of balance var for this group
				local ++colindex
				if "`vce_type'" == "bootstrap" mat row[1,`colindex'] = .b
				else 						   mat row[1,`colindex'] = e(rss)/e(df_r)
				*Standard error of balance var for this group
				mat row[1,`++colindex'] = _se[_cons]
				*Standard deviation of balance var for this group
				local sd = _se[_cons] * sqrt(e(N))
				mat row[1,`++colindex'] = `sd'

			}

			******************************************************
			*** Get descriptive stats for total

			//noi di "Desc stats. Var [`balancevar'], total"
			if !missing("`total'") {
				* Estimate descriptive stats for total
				reg `balancevar' `weight_option', `error_estm'
				*Number of observation for this balancevar for this group
				mat row[1,`++colindex'] = e(N)
				*If clusters used, number of clusters in this balance var for this group, otherwise .c
				local ++colindex
				if "`vce_type'" == "cluster" mat row[1,`colindex'] = e(N_clust)
				else mat row[1,`colindex'] = .c
				*Mean of balance var for this group
				mat row[1,`++colindex'] = _b[_cons]
				*Variance of balance var for this group
				mat row[1,`++colindex'] = e(rss)/e(df_r)
				*Standard error of balance var for this group
				mat row[1,`++colindex'] = _se[_cons]
				*Standard deviation of balance var for this group
				local sd = _se[_cons] * sqrt(e(N))
				mat row[1,`++colindex'] = `sd'
			}
			else {
				*If total not specified, then put .t in all total columns
				foreach tot_stat of local desc_stats {
					mat row[1,`++colindex'] = .t
				}
			}

			******************************************************
			*** Get test estimates for each test pair

			foreach ttest_pair of local TEST_PAIR_CODES {

				*If none is used then no pair test stats are calculated
				get_stat_label_stats_string, stats_string("`stats_string'") testname("pair")
				if "`r(stat_label)'" == "none" {
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

					* Perform the balance test for this test pair for this balance var
					//noi di "Balance regression. Var [`balancevar'], test pair [`ttest_pair']"
					reg `balancevar' `dummy_pair_`ttest_pair'' `covariates' i.`fixedeffect' `weight_option', `error_estm'

					*If any of the tests
					if (e(r2) == .) {
						* R2 is undefined
						noi display as text "{phang}Warning: The R2 was not possible to calculate in the regression for the pair-wise test of variable [`balancevar'] for observations with values [`code1'] and [`code2'] in the groupvar [`groupvar'].{p_end}."
						foreach stat of local pair_stats {
								mat row[1,`++colindex'] = .n
						}
					}
					else if (e(r2) == 1) {
						* R2 = 100
						noi display as text "{phang}Warning: All variance was explained by one or several variables in the regression for the pair-wise test of variable [`balancevar'] for observations with values [`code1'] and [`code2'] in the groupvar [`groupvar'].{p_end}."
						foreach stat of local pair_stats {
								mat row[1,`++colindex'] = .v
						}
					}
					else {

						* Calculate the difference in means
						local colnum_mean_code1 = colnumb(row,"mean_`code1'")
						local colnum_mean_code2 = colnumb(row,"mean_`code2'")
						mat row[1,`++colindex'] = el(row,1,`colnum_mean_code1') - el(row,1,`colnum_mean_code2')

						*Number of observation for in these two groups
						mat row[1,`++colindex'] = e(N)

						*If clusters used, number of clusters in this these two groups, otehrwise .c
						local ++colindex
						if "`vce_type'" == "cluster" mat row[1,`colindex'] = e(N_clust)
						else mat row[1,`colindex'] = .c

						*The diff between the groups after controling for fixed effects and covariates
						mat row[1,`++colindex'] = _b[`dummy_pair_`ttest_pair'']

						*Get the standard error for this pair dummy and calculate st dev
						local se_this_pair = _se[`dummy_pair_`ttest_pair'']
						local sd_this_pair = `se_this_pair' * sqrt(e(N))

						*The t-stat the the beta is different from 0
						mat row[1,`++colindex'] = _b[`dummy_pair_`ttest_pair'']/`se_this_pair'

						*Perform the t-test and store p-value in pttest
						*Test is used instead of ttest as we test coefficients from reg
						test `dummy_pair_`ttest_pair''
						mat row[1,`++colindex'] = r(p)

						*Store standard error and standard deviation
						mat row[1,`++colindex'] = `se_this_pair'
						mat row[1,`++colindex'] = `sd_this_pair'

						*Calculate and store the normalized difference and normlized beta
						if "`vce_type'" == "bootstrap" {
							* These statsare missing if using bootstrap
							mat row[1,`++colindex'] = .b
							mat row[1,`++colindex'] = .b
						}
						else {
							local nrmdenom = sqrt( .5 * (     ///
							    el(row,1,colnumb(row,"var_`code1'")) + ///
							    el(row,1,colnumb(row,"var_`code2'")) ))
							mat row[1,`++colindex'] = el(row,1,colnumb(row,"diff_`ttest_pair'")) / `nrmdenom'
							mat row[1,`++colindex'] = el(row,1,colnumb(row,"beta_`ttest_pair'")) / `nrmdenom'
						}
					}
				}
			}

			******************************************************
			*** Test for joint orthogonality across all groups for this balance var

			if !missing("`feqtest'") {

		    	* Run regression
				//noi di "FEQ regression. Var [`balancevar']"
				reg `balancevar' i.`groupvar' `covariates' i.`fixedeffect' `weight_option', `error_estm'

				*If any of the tests
				if (e(r2) == .) {
					* R2 undefined
					noi display as text "{phang}Warning: The R2 value could not be calculated in the regression for the feq-test over all values in the group variable [`groupvar'] for balance variable [`balancevar'].{p_end}"
					foreach stat of local feq_stats {
							mat row[1,`++colindex'] = .n
					}
				}
				else if  (e(r2) == 1) {
					* R2 = 1
					noi display as text "{phang}Warning: All variance was explained by one or several variables in the regression for the feq-test over all values in the group variable [`groupvar'] for balance variable [`balancevar'].{p_end}"
					foreach stat of local feq_stats {
							mat row[1,`++colindex'] = .v
					}
				}
				else {
					mat row[1,`++colindex'] = e(N)
					*If clusters used, number of clusters in this reg, otehrwise .c
					local ++colindex
					if "`vce_type'" == "cluster" mat row[1,`colindex'] = e(N_clust)
					else mat row[1,`colindex'] = .c

					*Perfeorm the F test
					test `FEQTEST_INPUT'
					mat row[1,`++colindex'] = r(F)
					mat row[1,`++colindex'] = r(p)

				}
			}
			* Feq test not used -  save missing .f
			else {
				foreach feq_stat of local feq_stats {
					mat row[1,`++colindex'] = .f
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

	* Initiate F matrix index
	local Fcolindex 0

	if !missing("`ftest'") {

		*Run the F-test on each pair
		foreach ftest_pair of local TEST_PAIR_CODES {

			*Get each code from a testpair
			getCodesFromPair `ftest_pair'
			local code1 `r(code1)'
			local code2 `r(code2)'

			**********
			* Run the regression for f-test
			//noi di "F regression. Var [`balancevars'], test pair [`ftest_pair']"
			reg `dummy_pair_`ftest_pair'' `balancevars' `covariates' i.`fixedeffect' `weight_option', `error_estm'

			* Find ommitted balance vars if any
		 	local all_columns     : colnames r(table)
			local omitted_balvars : list balancevars - all_columns
			* If not possible to calculate F-test due to variance issues,
			if !missing("`omitted_balvars'") {
				noi display as text "{phang}Warning: One or more balance variables were omitted due to no variance in the F-test across all balance variables for group variable values `code1' and `code2'.{p_end}."
				foreach f_stat of local ftest_stats {
					mat `fmat'[1,`++Fcolindex'] = .o
				}
			}
			else if (e(r2) == 1) {
				* R2 = 1
				noi display as text "{phang}Warning: All variance in the F-test across all balance variables for group variable values `code1' and `code2' is explained by one or more independent variables.{p_end}."
				foreach f_stat of local ftest_stats {
					mat `fmat'[1,`++Fcolindex'] = .v
				}
			}
			else {
				* Adding F score and number of observations to the matrix
				mat `fmat'[1,`++Fcolindex'] = e(N)
				*If clusters used, number of clusters in this reg, otehrwise .c
				local ++Fcolindex
				if "`vce_type'" == "cluster" mat `fmat'[1,`Fcolindex'] = e(N_clust)
				else mat `fmat'[1,`Fcolindex'] = .c

				*Test all balance variables for joint significance
				testparm `balancevars'

				*F-test possible store stats in matrix
				mat `fmat'[1,`++Fcolindex'] = r(F)
				mat `fmat'[1,`++Fcolindex'] = r(p)
			}
		}
	}
	else {
		* F test not used, mark all f-test values as .f
		foreach ftest_pair of local TEST_PAIR_CODES {
			foreach f_stat of local ftest_stats {
				mat `fmat'[1,`++Fcolindex'] = .f
			}
		}
	}


/*******************************************************************************

			*Prepare note string

*******************************************************************************/

	*Test if options nonote or notereplace are used
  * - if not generate default note
	if "`note'" != "nonote" {

	  generate_note, full_user_input(`"`full_user_input'"')   ///
      stats_string("`stats_string'") fix("`fixedeffect'")  ///
			fix_used("`FIX_EFFECT_USED'") covars("`covariates'") `ftest' `feqtest' ///
			starlevels("`starlevels'") vce("`vce'") vce_type("`vce_type'") ///
			clustervar("`cluster_var'")             ///
			weight_type("`weight_type'") weight_var("`weight_var'")
		local note_to_use `"`r(table_note)' "'
	}
	*Use no note
	else local note_to_use ""

  * Add note from noteappend command to default note if applicable
  if !missing(`"`addnote'"') local note_to_use `"`note_to_use'`addnote'"'


/*******************************************************************************

			* Return values to the user

*******************************************************************************/

	*Restore from orginial preserve at top of command
	restore

	*Remove the first row that was just a place holder
	matrix `rmat' = `rmat'[2...,1...]

	mat returnRMat = `rmat'
	mat returnFMat = `fmat'

	return matrix iebtab_rmat returnRMat
	return matrix iebtab_fmat returnFMat


/*******************************************************************************
********************************************************************************
		Export tables from results in the matrix
********************************************************************************
*******************************************************************************/

		******************************************
		*Set locals used regardless of export method

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

		* If pair tests set to none, then set pairs to "" to not iterate that loop
		get_stat_label_stats_string, stats_string("`stats_string'") testname("pair")
		if "`r(stat_label)'" == "none" local TEST_PAIR_CODES ""

		******************************************
		* Create tab delimited file and generate exports based on it

		* Test if any option that requires the tab delimited file is used
		if !missing("`savecsv'`savexlsx'`browse'") {

			preserve

				* Since commas can be used in labels it is tricky to write a comma seperated
				* file (like csv) directly. Therefore, this function writes a tab delimited file
				* as tabs are never valid labels. Then this tab delimited file is insheeted and
				* this command use Stata's built in commands to export to csv and xlsx as those
				* commands has built in support for handling commas in labels and other corner cases
				noi export_tab , rmat(`rmat') fmat(`fmat') ///
					order_grp_codes(`ORDER_OF_GROUP_CODES') pairs(`TEST_PAIR_CODES') ///
					row_lbls(`"`ROW_LABELS'"') col_lbls(`"`COLUMN_LABELS'"')  ///
					stats_string("`stats_string'") ///
					tot_lbl(`"`tot_lbl'"') `total' `onerow' `feqtest' `ftest'  ///
					ntitle("`ntitle'") note(`"`note_to_use'"') cl_used("`CLUSTER_USED'") ///
					diformat("`diformat'") starlevels("`starlevels'")

					*Save the tab delimited file
					tempfile tab_file
					save `tab_file'

					* Use Stata's built in commands for exporting to CSV
					if !missing("`savecsv'") {
						export delimited using "`savecsv'", novarnames quote `replace'
						noi di as result `"{phang}Balance table saved in csv format to: {browse "`savecsv'":`savecsv'}{p_end}"'
					}

					* Use Stata's built in commands for exporting to Excel format
					if !missing("`savexlsx'") {
						export excel using "`savexlsx'", `replace'
						noi di as result `"{phang}Balance table saved in Excel format to: {browse "`savexlsx'":`savexlsx'}{p_end}"'
					}

			* Bring back the original data
			restore
			* Overwrite in working memory the original data so results can be browsed
			if !missing("`browse'") {
				use `tab_file', clear
				* Reduce max lenght of col 1 to 32 so varnames will show but note will be shrunk
				format v1 %35s
			}
		}

		******************************************
		* Create tex file based on result matrices

		*Export to tex format
		if !missing("`savetex'") {
			noi export_tex ,  texfile("`savetex'") ///
				rmat(`rmat') fmat(`fmat') pairs(`TEST_PAIR_CODES') `texdocument' ///
				texcaption("`texcaption'") starlevels("`starlevels'") ///
				texlabel("`texlabel'") texcolwidth("`texcolwidth'") ///
        texnotewidth("`texnotewidth'") texnotefile("`texnotefile'")  ///
				stats_string("`stats_string'") userinput(`"`full_user_input'"') ///
				`total' `onerow' `feqtest' `ftest' note(`"`note_to_use'"')  ///
				ntitle("`ntitle'") diformat("`diformat'") ///
				col_lbls(`"`COLUMN_LABELS'"') tot_lbl("`tot_lbl'") ///
				row_lbls(`"`ROW_LABELS'"') cl_used("`CLUSTER_USED'") ///
				order_grp_codes(`ORDER_OF_GROUP_CODES') `replace'
		}
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

qui {
	syntax , rmat(name) fmat(name) 					///
		ntitle(string) cl_used(string)		///
		col_lbls(string) order_grp_codes(numlist) ///
		diformat(string) ///
		row_lbls(string) tot_lbl(string) ///
		[pairs(string) stats_string(string) ///
		note(string) onerow total feqtest ftest ///
		starlevels(string)]

	* If total is used, add t to locals used when looping over desc stats
	if !missing("`total'") local order_grp_codes "t `order_grp_codes'"
	if !missing("`total'") local col_lbls `"`"`tot_lbl'"' `col_lbls'"'

	* Count groups and number of balance vars
	local grp_count : list sizeof order_grp_codes
	local row_count : list sizeof row_lbls

	* Get a local with one item for each desc stats column
	local desc_cols "`order_grp_codes'"
	if !missing("`feqtest'") local desc_cols "`desc_cols' feq"
	if missing("`onerow'") local desc_cols "`desc_cols' `desc_cols'"

  * Get stats and label for descreptive stats, pairs and f-test
  get_stat_label_stats_string, stats_string("`stats_string'") testname("desc")
  local dout_val "`r(stat)'"
  local dout_lbl "`r(stat_label)'"
	get_stat_label_stats_string, stats_string("`stats_string'") testname("pair")
	local pout_val "`r(stat)'"
	local pout_lbl "`r(stat_label)'"
	get_stat_label_stats_string, stats_string("`stats_string'") testname("f")
	local fout_val "`r(stat)'"
	local fout_lbl "`r(stat_label)'"

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
		local titlerow2 `"`titlerow2' _tab `"`grp_lbl'"'        "'
		local titlerow3 `"`titlerow3' _tab "Mean/(`dout_lbl')"  "'
	}


	********* joint orthogonality of each balance variable ***********************

	if !missing("`feqtest'") {

		if missing("`onerow'") {
			local titlerow1 `"`titlerow1' _tab "" "'
			local titlerow2 `"`titlerow2' _tab "" "'
			local titlerow3 `"`titlerow3' _tab "`ntitle'" "'
		}

		*Add titles for summary row stats
		local titlerow1 `"`titlerow1' _tab "F-test for balance" "'
		local titlerow2 `"`titlerow2' _tab "across all groups" "'
		local titlerow3 `"`titlerow3' _tab "F-stat/P-value" "'
	}

	********* Test pairs titles **************************************************

	foreach pair of local pairs {

		*Get the group order from the two groups in each pair
		getCodesFromPair `pair'
		local order1 : list posof "`r(code1)'" in order_grp_codes
		local order2 : list posof "`r(code2)'" in order_grp_codes

		*Write test pair titles
		if missing("`onerow'") {
			local titlerow1 `"`titlerow1' _tab "" "'
			local titlerow2 `"`titlerow2' _tab "" "'
			local titlerow3 `"`titlerow3' _tab "`ntitle'" "'
		}
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
		local row_up   `"`"`row_lbl'"'"'
		local row_down `""'

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
			local var_value = el(`rmat',`row_num',colnumb(`rmat',"`dout_val'_`grp_code'"))
			local mean_value = trim("`: display `diformat' `mean_value''")
			local var_value  = trim("`: display `diformat' `var_value''")
			local row_up   `"`row_up'   _tab "`mean_value'" "'
			local row_down `"`row_down' _tab "(`var_value')" "'
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
			local f_value = trim("`: display `diformat' `f_value''")
			local p_value = trim("`: display `diformat' `p_value''")
			local row_up   `"`row_up'   _tab "`f_value'`r(stars)'" "'
			local row_down `"`row_down' _tab "`p_value'" "'
		}

		********* Write pair test stats ********************************************

		foreach pair of local pairs {

			* Add column with N for this group unless option onerow is used
			if missing("`onerow'") {
				*Get N for this group
				local n_value = el(`rmat',`row_num',colnumb(`rmat',"n_`pair'"))
				*Get number of clusters if clusters were used
				local cl_n ""
				if `cl_used' == 1 local cl_n = el(`rmat',`row_num',colnumb(`rmat',"cl_`pair'"))
				* Write to row locals
				local row_up   `"`row_up'   _tab "`n_value'" "'
				local row_down `"`row_down' _tab "`cl_n'" "'
			}

			* Pairwise test statistics for this pair - get value from mat and apply format
			local test_value = el(`rmat',`row_num',colnumb(`rmat',"`pout_val'_`pair'"))
			local test_value = trim("`: display `diformat' `test_value''")

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

		*Skip a column if onerow not used
		if missing("`onerow'") local ftabs "_tab _tab"
		else                   local ftabs "_tab"

		*Write fstats
		foreach pair of local pairs {
			* Pairwise test statistics for this pair - get value from mat and apply format
			local ftest_value = el(`fmat',1,colnumb(`fmat',"f`fout_val'_`pair'"))
			local ftest_value = trim("`: display `diformat' `ftest_value''")
			local ftest_n     = el(`fmat',1,colnumb(`fmat',"fn_`pair'"))
			local ftest_cl    = el(`fmat',1,colnumb(`fmat',"fcl_`pair'"))

			local p_value = el(`fmat',1,colnumb(`fmat',"fp_`pair'"))
			count_stars, p(`p_value') starlevels(`starlevels')

			local frow_up   `"`frow_up'   `ftabs' "`ftest_value'`r(stars)'" "'
			local frow_down `"`frow_down' `ftabs' "`ftest_n'" "'
			local frow_cl   `"`frow_cl'   `ftabs' "`ftest_cl'" "'
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

	if !missing(`"`note'"') {
		*Write the table note if one is defined
		cap file close 	`tab_name'
		file open  		`tab_name' using "`tab_file'", text write append
		file write  	`tab_name' `"`note'"' _n
		file close 		`tab_name'
	}

	******************************************************************************
	* Import tabfile to memory
	******************************************************************************

	* Import tab file to memory to be exported as csv, xlsx or be browsed.
	* Tabs are used as they are never used in labels, making manual writing easier
	import delimited `tab_file', delimiters("\t") clear

}
end

/*******************************************************************************
********************************************************************************

	Main export functions: tex file from result matrices

********************************************************************************
*******************************************************************************/

cap program drop 	export_tex
	program define	export_tex
qui {
	syntax , rmat(name) fmat(name) texfile(string) [note(string) pairs(string) ///
	ntitle(string) cl_used(string) ///
	stats_string(string) starlevels(string) ///
	texdocument texcaption(string) texnotewidth(string) ///
	texlabel(string) texcolwidth(string)  onerow total feqtest ftest ///
	order_grp_codes(numlist) diformat(string) ///
	row_lbls(string) col_lbls(string) tot_lbl(string) ///
	replace texnotefile(string) userinput(string)]

	* If total is used, add t to locals used when looping over desc stats
	if !missing("`total'") local order_grp_codes "t `order_grp_codes'"
	if !missing("`total'") local col_lbls `""`tot_lbl'" `col_lbls'"'

	* Count groups and number of balance vars
	local grp_count  : list sizeof order_grp_codes
	local pair_count : list sizeof pairs
	local row_count  : list sizeof row_lbls


	* Get stats and label for descriptive, pairs and f-test
	get_stat_label_stats_string, stats_string("`stats_string'") testname("desc")
	local dout_val "`r(stat)'"
	local dout_lbl "`r(stat_label)'"
	get_stat_label_stats_string, stats_string("`stats_string'") testname("pair")
	local pout_val "`r(stat)'"
	local pout_lbl "`r(stat_label)'"
	get_stat_label_stats_string, stats_string("`stats_string'") testname("f")
	local fout_val "`r(stat)'"
	local fout_lbl "`r(stat_label)'"

	*Create a temporary texfile
	tempname 	texhandle texnotehandle
	tempfile	textmpfile texnotetmpfile

	******************************************************************************
	* Set up tex file type - stand alone tex doc or not
	******************************************************************************

	* Write this comment at the top of each tex file
	file open  `texhandle' using "`textmpfile'", text write replace
	file write `texhandle' ///
		"%%% Table created in Stata by command iebaltab" _n ///
		"%%% (https://github.com/worldbank/ietoolkit)" _n ///
		"%%% (https://dimewiki.worldbank.org/iebaltab)" _n ///
		"%%% The command was specified exactly like this: " _n ///
		`"%%% `userinput'"'_n _n
	file close `texhandle'

	* If tex doc is used, prepare header so that the tex file can be compiled on
	* its own. Default is that the table should be imported into another tex file
	if !missing("`texdocument'") {

		file open  `texhandle' using "`textmpfile'", text write replace
		file write `texhandle' ///
			"\documentclass{article}" _n _n ///
			"% ----- Preamble " _n ///
			"\usepackage[utf8]{inputenc}" _n ///
			"\usepackage{adjustbox}" _n ///
			"% ----- End of preamble " _n _n ///
			" \begin{document}" _n _n ///
			"\begin{table}[!htbp]" _n ///
			"\centering" _n

		* Write tex caption and tex label if specified
		if !missing("`texcaption'") file write `texhandle' `"\caption{`texcaption'}"' _n
		if !missing("`texlabel'")   file write `texhandle' `"\label{`texlabel'}"' _n

		file write `texhandle'	"\begin{adjustbox}{max width=\textwidth}" _n
		file close `texhandle'
	}

	******************************************************************************
	* Prepare tabular environment header
	******************************************************************************

	* Set custom row height if applicable
  local row_space "[1ex]"

	*Count number of columns in table
	if missing("`texcolwidth'")	local colstring	"l"
	else		                    local colstring	"p{`texcolwidth'}"

	*Add 1 col for stat, and 1 more for N if onerow not used
	if missing("`onerow'") local numcols 2
	else                   local numcols 1
	if missing("`onerow'") local titlecols "cc"
	else                   local titlecols "c"
	if missing("`onerow'") local frowcols "& & "
	else                   local frowcols "& "


	*Add columns for each group desc stats (and for total if used)
	forvalues repeat = 1/`grp_count' {
		local	colstring	"`colstring'`titlecols'"
  }

	*Add columns of F-test for equality of means if used
	if !missing("`feqtest'") local	colstring	"`colstring'`titlecols'"

	*Add columns for all test pairs to be displayed
	foreach pair of local pairs {
		local	colstring	"`colstring'`titlecols'"
	}

	*Write tabular environment header
	file open  `texhandle' using "`textmpfile'", text write append
	file write `texhandle' ///
		"\begin{tabular}{@{\extracolsep{5pt}}`colstring'}" _n ///
		"\\[-1.8ex]\hline \hline \\[-1.8ex]" _n
	file close `texhandle'

	******************************************************************************
	* Create table title rows
	******************************************************************************

	** The titles consist of three rows across all
	*  columns of the table. Each row is one local
	local texrow1 ""
	local texrow2 ""
	local texrow3 `"Variable"'

  *****************************
	*Titles for descriptive stats
	forvalues grp_num = 1/`grp_count' {

		*Get the code and label corresponding to the group
		local grp_lbl : word `grp_num' of `col_lbls'

    * Make sure special characters are displayed correctly
    local grp_lbl : subinstr local grp_lbl "%" "\%" , all
    local grp_lbl : subinstr local grp_lbl "_" "\_" , all
    local grp_lbl : subinstr local grp_lbl "&" "\&" , all
    local grp_lbl : subinstr local grp_lbl "\$" "\\\$" , all

		*Create one more column for N if N is displayesd in column instead of row
		local texrow1 	`"`texrow1' & \multicolumn{`numcols'}{c}{(`grp_num')} "'
		local texrow2 	`"`texrow2' & \multicolumn{`numcols'}{c}{`grp_lbl'} "'

		if missing("`onerow'") local texrow3 `"`texrow3' & `ntitle' & Mean/(`dout_lbl')"'
        else                   local texrow3 `"`texrow3' & Mean/(`dout_lbl')"'
	}

	*****************************
	*Titles for feq test
	if !missing("`feqtest'") {
		local texrow1 `"`texrow1' & \multicolumn{`numcols'}{c}{F-test for balance}"'
		local texrow2 `"`texrow2' & \multicolumn{`numcols'}{c}{across all groups}"'
		if !missing("`onerow'") local texrow3 `"`texrow3' & F-stat/P-value"'
		else                    local texrow3 `"`texrow3' & `ntitle' & F-stat/P-value"'
	}

	*****************************
	*Titles for pairwise tests

	* Only add pair titles if there are pairs to be displayed
	if `pair_count' > 0 {

		*Add columns for all test pairs to be displayed and stats titles
		foreach pair of local pairs {
			*Get the group order from the two groups in each pair
			getCodesFromPair `pair'
			local order1 : list posof "`r(code1)'" in order_grp_codes
			local order2 : list posof "`r(code2)'" in order_grp_codes
			local texrow1 `"`texrow1' & \multicolumn{`numcols'}{c}{(`order1')-(`order2')}"'

			if !missing("`onerow'") local texrow3 `"`texrow3' & `pout_lbl'"'
			else                    local texrow3 `"`texrow3' & `ntitle' & `pout_lbl'"'
		}

		*Write  2nd row for test stats
		local pair_cols = `pair_count' * `numcols'
		local texrow2 `"`texrow2' & \multicolumn{`pair_cols'}{c}{Pairwise t-test} "'


	}

	*****************************
	*Write title rows

  * Escape potential $ in group labels one more time.
  local texrow2 : subinstr local texrow2 "\$" "\\\$" , all

	*Write the title rows defined above
	file open  `texhandle' using "`textmpfile'", text write append
	file write `texhandle' `"`texrow1' \\"' _n `"`texrow2' \\"' _n ///
	                     `"`texrow3' \\ \hline \\[-1.8ex] "' _n
	file close `texhandle'

	******************************************************************************
	* Create balance variable row
	******************************************************************************

	forvalues row_num = 1/`row_count' {

		*Get the code and label corresponding to the group
		local row_lbl : word `row_num' of `row_lbls'

		* Make sure special characters are displayed correctly
		local row_lbl : subinstr local row_lbl "%" "\%" , all
		local row_lbl : subinstr local row_lbl "_" "\_" , all
		local row_lbl : subinstr local row_lbl "&" "\&" , all
		local row_lbl : subinstr local row_lbl "\$" "\\\$" , all

		********* Initiate row locals and write row label **************************

		*locals for each row
		local row_up   `"`row_lbl'"'
		local row_down `""'

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
				local row_up   `"`row_up'   & `n_value' "'
				local row_down `"`row_down' & `cl_n' "'
			}

			* Mean and variance for this group - get value from mat and apply format
			local mean_value = el(`rmat',`row_num',colnumb(`rmat',"mean_`grp_code'"))
			local var_value = el(`rmat',`row_num',colnumb(`rmat',"`dout_val'_`grp_code'"))
			local mean_value = trim("`: display `diformat' `mean_value''")
			local var_value  = trim("`: display `diformat' `var_value''")
			local row_up   `"`row_up'   & `mean_value' "'
			local row_down `"`row_down' & (`var_value') "'
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
				local row_up   `"`row_up'   & `n_value' "'
				local row_down `"`row_down' & `cl_n' "'
			}

			* F and p values for this test - get value from mat and apply format
			local f_value = el(`rmat',`row_num',colnumb(`rmat',"feqf"))
			local p_value = el(`rmat',`row_num',colnumb(`rmat',"feqp"))

			count_stars, p(`p_value') starlevels(`starlevels')
			local f_value = trim("`: display `diformat' `f_value''")
			local p_value = trim("`: display `diformat' `p_value''")
			local row_up   `"`row_up'   & `f_value'`r(stars)' "'
			local row_down `"`row_down' & `p_value' "'
		}

		********* Write pair test stats ********************************************
		foreach pair of local pairs {

			* Add column with N for this group unless option onerow is used
			if missing("`onerow'") {
				*Get N for this group
				local n_value = el(`rmat',`row_num',colnumb(`rmat',"n_`pair'"))
				*Get number of clusters if clusters were used
				local cl_n ""
				if `cl_used' == 1 local cl_n = el(`rmat',`row_num',colnumb(`rmat',"cl_`pair'"))
				* Write to row locals
				local row_up   `"`row_up'   & `n_value' "'
				local row_down `"`row_down' & `cl_n' "'
			}


			* Pairwise test statistics for this pair - get value from mat and apply format
			local test_value = el(`rmat',`row_num',colnumb(`rmat',"`pout_val'_`pair'"))
			local test_value 	= trim("`: display `diformat' `test_value''")

			local p_value = el(`rmat',`row_num',colnumb(`rmat',"p_`pair'"))
			count_stars, p(`p_value') starlevels(`starlevels')

			local row_up   `"`row_up'   & `test_value'`r(stars)' "'
			local row_down `"`row_down' & "'
		}

    * Escape potential $ in row labels one more time.
    local row_up : subinstr local row_up "\$" "\\\$" , all

		*Write the title rows defined above
		file open  `texhandle' using "`textmpfile'", text write append
		file write `texhandle' `"`row_up'  \\"' _n ///
		                       `"`row_down' \\ `row_space'"' _n
		file close `texhandle'

	}


	******************************************************************************
	* Write F-stat row
	******************************************************************************

	if !missing("`ftest'") {

		*Write a line before ftest
		file open  `texhandle' using "`textmpfile'", text write append
		file write `texhandle' "\hline \\[-1.8ex]" _n
		file close `texhandle'

		* First column with row labels
		local frow_up   `"F-test of joint significance (`fout_lbl')"'
		local frow_down `"F-test, number of observations"' // Not used in onerow
		local frow_cl   `"F-test, number of clusters"'    // Only used with cluster and without onerow

		* Skip all group/total/feqtest columns
		local f_col_skips = `grp_count'
		if !missing("`feqtest'") local f_col_skips = `f_col_skips' + 1
		forvalues grp_num = 1/`f_col_skips' {
			local frow_up 	`"`frow_up' `frowcols' "'
			local frow_down `"`frow_down' `frowcols' "'
			local frow_cl   `"`frow_cl' `frowcols' "'
		}

		*Write fstats
		foreach pair of local pairs {
			* Pairwise test statistics for this pair - get value from mat and apply format
			local ftest_value = el(`fmat',1,colnumb(`fmat',"f`fout_val'_`pair'"))
			local ftest_value = trim("`: display `diformat' `ftest_value''")
			local ftest_n     = el(`fmat',1,colnumb(`fmat',"fn_`pair'"))
			local ftest_cl    = el(`fmat',1,colnumb(`fmat',"fcl_`pair'"))

			local p_value = el(`fmat',1,colnumb(`fmat',"fp_`pair'"))
			count_stars, p(`p_value') starlevels(`starlevels')

			local frow_up   `"`frow_up'   `frowcols' `ftest_value'`r(stars)' "'
			local frow_down `"`frow_down' `frowcols' `ftest_n' "'
			local frow_cl   `"`frow_cl'   `frowcols' `ftest_cl' "'
		}

		*Write the fstats rows
		cap file close `texhandle'
		file open  		 `texhandle' using "`textmpfile'", text write append
    file write  `texhandle' "`frow_up' \\" _n
		if missing("`onerow'") file write  `texhandle' "`frow_down' \\" _n
		if missing("`onerow'") & `cl_used' == 1 file write `texhandle' "`frow_cl' \\" _n
		file close 		`texhandle'
	}

	******************************************************************************
	* Write onerow N (if applicable)
	******************************************************************************

	if !missing("`onerow'") {

    *Write a line before onerow observations
		file open  `texhandle' using "`textmpfile'", text write append
		file write `texhandle' "\hline \\[-1.8ex]" _n
		file close `texhandle'

		*Initiate the row local for the N row if onerow is not missing
		local n_row  "Number of observations"
		local cl_row "Number of clusters"

		*Get the N for each group
		foreach grp_code of local order_grp_codes {
			* Get the N from the first row (they must be the same for onerow to work)
			local n_value  = el(`rmat',1,colnumb(`rmat',"n_`grp_code'"))
			local cl_value = el(`rmat',1,colnumb(`rmat',"cl_`grp_code'"))
			local n_row   "`n_row'  & `n_value' "
			local cl_row  "`cl_row' & `cl_value' "
		}

		*If feqtest was used, add the N from the first row
		if !missing("`feqtest'") {
			local n_value = el(`rmat',1,colnumb(`rmat',"feqn"))
			local cl_value = el(`rmat',1,colnumb(`rmat',"feqcl"))
			local n_row   "`n_row' & `n_value'"
			local cl_row  "`cl_row' & `cl_value'"
		}

		*Get the N/cl from each pair
		foreach pair of local pairs {
			local n_value  = el(`rmat',1,colnumb(`rmat',"n_`pair'"))
			local cl_value = el(`rmat',1,colnumb(`rmat',"cl_`pair'"))
			local n_row   "`n_row' & `n_value' "
			local cl_row  "`cl_row' & `cl_value' "
		}

		*Write the N row to file
		cap file close `texhandle'
		file open      `texhandle' using "`textmpfile'", text write append
    file write     `texhandle' "`n_row' \\" _n
		if `cl_used' == 1 file write `texhandle' "`cl_row' \\" _n
		file close 		 `texhandle'
	}

	******************************************************************************
	* Write last line in table
	******************************************************************************

	*Write the table note if one is defined
	cap file close 	`texhandle'
	file open  		`texhandle' using "`textmpfile'", text write append
	file write `texhandle' "\hline \hline \\[-1.8ex]" _n
	file close 		`texhandle'

	******************************************************************************
	* Write table note
	******************************************************************************

	*Write note if not missing (for example tblnonote was used)
	if !missing(`"`note'"') {

		* Make sure special characters are displayed correctly
		local note : subinstr local note "%" "\%" , all
		local note : subinstr local note "_" "\_" , all
		local note : subinstr local note "&" "\&" , all
		local note : subinstr local note "\$" "\\\$" , all


		*If tex file option is not used, write in main file
		if missing("`texnotefile'") {
			*Count number of columns
			local totalColNo = 1 + `numcols'*`grp_count' + `pair_count'
			if !missing("`feqtest'") local totalColNo = `totalColNo' + `numcols'

			*Write the table note if one is defined
			cap file close 	`texhandle'
			file open  		`texhandle' using "`textmpfile'", text write append
			file write `texhandle' ///
			"%%% This is the note. If it does not have the correct margins, use texnotewidth() option or change the number before '\textwidth' in line below to fit it to table size." _n ///
			`"\multicolumn{`totalColNo'}{@{} p{`texnotewidth'\textwidth}}{`note'}"' _n
			file close 		`texhandle'
		}

		* If applicable write a text note file that can be inported in tex's threparttable package
		else {
			file open  `texnotehandle' using "`texnotetmpfile'", text write replace
			file write `texnotehandle' `"`note'"' _n
			file close `texnotehandle'

			* Write temporay tex file to disk
			copy "`texnotetmpfile'" "`texnotefile'" , `replace'
		}
	}

	******************************************************************************
	* Write end of file and copy to disk
	******************************************************************************

	* Close tex environments
	file open  `texhandle' using "`textmpfile'", text write append
	file write `texhandle' _n "\end{tabular}" _n
	if !missing("`texdocument'") file write `texhandle' "\end{adjustbox}" _n "\end{table}" _n "\end{document}" _n
	file close `texhandle'

	* Write temporay tex file to disk and prepare success string
  copy "`textmpfile'" "`texfile'" , `replace'

	* Report file writes to users
	local success_string `"Balance table saved in LaTeX format to: {browse "`texfile'":`texfile'}"'
	if !missing("`texnotefile'") local success_string  ///
	  `"`success_string' and note file saved in LaTeX format to: {browse "`texnotefile'":`texnotefile'}"'
	noi di as result `"{phang}`success_string'{p_end}"'

}
end

/*******************************************************************************
********************************************************************************

	Utility functions

********************************************************************************
*******************************************************************************/

/*******************************************************************************
  setUpResultMatrix: set up a matrices where result will be stored
	* This command sets up two template matrices: emptyRow and emptyFRow.
	* Both of them are of size 1 row and C columns, where C depends on the number
	* of test pairs that are used. emptyRow will be used as a template once per
	* balance variable outside this command, where each row is appended to a
	* matrix of size B rows and C columns, where B is the number of balance vars.
*******************************************************************************/

*Sets up template for the result matrix
cap program drop 	setUpResultMatrix
	program define	setUpResultMatrix, rclass

  syntax , order_of_group_codes(string) test_pair_codes(string)

	*Locals for balance var row
  local emptyRow = ""
  local colnames = ""

  *Locals for F test row
  local emptyFRow = ""
  local Fcolnames = ""

  *Locals with stats names for each category
  local desc_stats   = "n cl mean var se sd"
  local pair_stats   = "diff n cl beta t p se sd nrmd nrmb"
  local feq_stats    = "feqn feqcl feqf feqp"
  local ftest_stats  = "fn fcl ff fp"

  *Create columns for group desc statisitics
  foreach group_code of local order_of_group_codes {
    foreach stat of local desc_stats {
      local colnames = "`colnames' `stat'_`group_code'"
      local emptyRow = "`emptyRow',."
    }
  }

  *Create columns for total obs desc statisitics
  foreach stat of local desc_stats {
    local colnames = "`colnames' `stat'_t"
    local emptyRow = "`emptyRow',."
  }

  *balance var pair stats
  foreach test_pair of local test_pair_codes {
    foreach stat of local pair_stats {
      local colnames = "`colnames' `stat'_`test_pair'"
      local emptyRow = "`emptyRow',."
    }
  }

	*all balance var stats
  foreach stat of local feq_stats {
    local colnames = "`colnames' `stat'"
    local emptyRow = "`emptyRow',."
  }

	*ftest pairs stats
  foreach test_pair of local test_pair_codes {
    foreach stat of local ftest_stats {
      local Fcolnames = "`Fcolnames' `stat'_`test_pair'"
      local emptyFRow = "`emptyFRow',."
    }
  }

  *Remove first comma in ",.,.,.,.," empty row
	local emptyRow  = subinstr("`emptyRow'" ,",","",1)
	local emptyFRow = subinstr("`emptyFRow'",",","",1)

	*Create a one 1xN matrix that represents one balance var row
	mat emptyRow = (`emptyRow')
	mat colnames emptyRow = `colnames'
	return matrix emptyRow emptyRow

	*Create a one 1xN matrix that represents one F-test row
	mat emptyFRow = (`emptyFRow')
	mat colnames emptyFRow = `Fcolnames'
	mat rownames emptyFRow = "fstats"
	return matrix emptyFRow emptyFRow

	*Return all stats locals to be used in the command
  return local desc_stats   `desc_stats'
  return local pair_stats   `pair_stats'
	return local feq_stats    `feq_stats'
	return local ftest_stats  `ftest_stats'

end

/*******************************************************************************
  get_stat_label_from_stats_string: parse and test user stats preference
	* Test that items in stats() are on the format: stats(pair(t) f(p))
	* Test that testsnames specified are allowed stats: allowed_test_names
	* Test that testsnames specified are allowed stats: allowed_`testname'_stats
*******************************************************************************/

cap program drop parse_and_clean_stats
	program define parse_and_clean_stats, rclass

	syntax, [stats(string)]

	*Define locals used in command
	local cleaned_stats ""
	local used_test_names ""

	*********************
	* Allowed inputs

	*List allowed test names
	local allowed_test_names "desc pair f feq"

	*List allowed test names
	local allowed_desc_stats "se var sd"
	local allowed_pair_stats "diff beta t p nrmd nrmb se sd none"
	local allowed_f_stats    "f p"
	local allowed_feq_stats  "f p"

	*********************
	* Prepare inputs

	*Clean up exessive spaced in input
	local stats =trim(itrim("`stats'"))

	*********************
	* Parse inputs

	*Create local of stats to parst over in while loop
	local stats_to_parse `stats'

	*Parst over stats one at the time until all are parsed
	while "`stats_to_parse'" != "" {

		* Parse next item
		gettoken testname stats_to_parse : stats_to_parse, parse("(")

		***************
		* Test name

		*Parse next test tname
		local testname = trim("`testname'")

		* test if multiple testnames used or any testname missing () - such as stats(pair f(p))
		if `: word count `testname'' != 1 {
			noi di as error "{phang}The [stats(`stats')] is not formatted properly. Make sure that each test name is followed by a single stat inside a (). For example: [stats(pair(t) f(p))].{p_end}"
			error 198
		}

		*Test that the testname is an allowed test name
		if !`: list testname in allowed_test_names' {
			noi di as error "{phang}The test name [`testname'] in [stats(`stats')] is not an allowed test name. Allowed names are [`allowed_test_names'].{p_end}"
			error 198
		}

		*Test that the testname is only used once
		if `: list testname in used_test_names' {
			noi di as error "{phang}The test name [`testname'] in [stats(`stats')] is used more than one time which is not allowed.{p_end}"
			error 198
		}
		*Save list of already used stats names
		local used_test_names "`used_test_names' `testname'"

		***************
		*  Stat name

		* Parse the stats name for this test
		gettoken statname stats_to_parse : stats_to_parse, parse(")")
		local statname = trim(subinstr("`statname'","(","",1))

		*Make sure that only one stat was listed
		if `: word count `statname'' != 1 {
			noi di as error "{phang}The [`testname'(`statname')] in [stats(`stats')] is not formatted properly. Make sure that each test name is followed by a single stat inside a ().{p_end}"
			error 198
		}

		* Make sure that the statname used was a valid statname
		if !`: list statname in allowed_`testname'_stats' {
			noi di as error "{phang}The name [`statname'] in [`testname'(`statname')] in [stats(`stats')] is not an allowed statistics name. Allowed names are [`allowed_`testname'_stats'].{p_end}"
			error 198
		}

		*noi di "Parsed output [`testname'(`statname')]"
		local cleaned_stats "`cleaned_stats' `testname':`statname'"

		* Remove last ) for this stat, so string can be parsed again
		local stats_to_parse = trim(subinstr("`stats_to_parse'",")","",1))

	}

	local cleaned_stats = trim("`cleaned_stats'")
	return local stats_string `cleaned_stats'

end

/*******************************************************************************
  get_stat_label_stats_string: return stat and its label for the test
  * stats_string is expected to have been cleaned in parse_and_clean_stats
	* Returns user specified or default stat from stats_string: r(stat)
	* Returns label for the stat used: r(stat_label)
*******************************************************************************/

cap program drop   get_stat_label_stats_string
	program define get_stat_label_stats_string, rclass

	syntax, [stats_string(string)] testname(string)

	* Initialize local if deafult stat was used
	local default_used 0

	*Test deafult stats
	local desc_default "se"
	local pair_default "diff"
	local f_default    "f"
	local feq_default  "f"

	* Pair test stat labels
	local desc_se_label  "SE"
	local desc_var_label "Var"
	local desc_sd_label  "SD"

	* Pair test stat labels
	local pair_diff_label "Mean difference"
	local pair_beta_label "Beta coefficient"
	local pair_nrmd_label "Normalized difference"
	local pair_nrmb_label "Normalized beta coefficient"
	local pair_t_label    "t-statistics"
	local pair_p_label    "P-value"
	local pair_se_label   "Standard error"
	local pair_sd_label   "Standard deviation"
	local pair_none_label "none"

	* F-test stat labels
	local f_f_label "F-stat"
	local f_p_label "P-value"

	* Feq-test stat labels
	local feq_f_label "F-stat"
	local feq_p_label "P-value"

	* Get position of this stat - returns 0 if not used
	local stats_pos = strpos("`stats_string'","`testname':")

	* Stat not specified by user, return default
	if `stats_pos' == 0 {
		local return_stat "``testname'_default'"
		local default_used 1
	}

	*Stat specified by user. Parse and use it.
	else {
		*Cut off string after the test name and the stat to use is the first word
		local str_cutoff = `stats_pos' + strlen("`testname':")
		local rest_of_string = substr("`stats_string'",`str_cutoff',.)
		local return_stat : word 1 of `rest_of_string'
	}

	return local deafult_used `default_used'
	return local stat_label "``testname'_`return_stat'_label'"
	return local stat       "`return_stat'"

end

/*******************************************************************************
  test_parse_file_input: pars and test item/label lists
	* Test that lists are on format "item1 label1 @ item2 label2"
	* Test that each item listed is used in itemlist (groupcode or balance var)
	* Test hat no label is missing for items included
*******************************************************************************/
cap program drop 	test_parse_file_input
	program define	test_parse_file_input, rclass

	syntax, filepath(string) allowedformats(string) defaultformat(string) option(string)

	**Find the last . in the file path and find extension after it

	** Find index for where the file type suffix start
	local dot_index 	 = strpos(strreverse("`filepath'"),".")
	local file_extension = substr("`filepath'",-`dot_index',.)

	** If no dot then no file extension, use default
	if `dot_index' == 0 {
		local return_file "`filepath'`defaultformat'"
	}
  * File path good as is
	else if `: list file_extension in allowedformats' {
		local return_file "`filepath'"
	}
	* Format used is not allowed, throw error
	else {
		noi display as error "{phang}The file extension [`file_extension'] used in {input:`option'(`filepath')} is not within the allowed format(s): [`allowedformats'].{p_end}"
		error 198
	}

	return local filepath "`return_file'"

end

/*******************************************************************************
  test_parse_label_input: pars and test item/label lists
	* Test that lists are on format "item1 label1 @ item2 label2"
	* Test that each item listed is used in itemlist (groupcode or balance var)
	* Test hat no label is missing for items included
*******************************************************************************/

cap program drop 	test_parse_label_input
	program define	test_parse_label_input, rclass

	syntax, labelinput(string) itemlist(string) [row column groupvar(string)]

	if !missing("`row'") {
		local optionname "rowlabels"
		local listoutput "the name of any of the balance variables used"
		local itemname "balance variable"
	}
	else if !missing("`column'") {
		local optionname "grouplabels"
		local listoutput "a value used in groupvar(`groupvar')"
		local itemname "group code"
	}
	else noi di as error "{phang}test_parse_label_inpu: either [row] or [column] must be used.

	local labelinput_tokenize `"`labelinput'"'

	* Loop over each item/label pair
	while `"`labelinput_tokenize'"' != "" {

		*Parsing item/label pairs and then split to item and label
		gettoken item_label labelinput_tokenize : labelinput_tokenize, parse("@")
		gettoken item label : item_label
		local label = trim(`"`label'"') //Removing leadning or trailing spaces

		*Test that item is part of item list
		if `: list item in itemlist' == 0 {
			noi display as error `"{phang}Item [`item'] in `optionname'("`labelinput'") is not `listoutput'.{p_end}"'
			error 198
		}

		*Testing that no label is missing
		if `"`label'"' == "" {
			noi display as error `"{phang}For item [`item'] listed in `optionname'("`labelinput'") there is no label specified. Not all `itemname's need to be listed, but those listed must have a label. Omitted `itemname's get the deafult label. See {help iebaltab:help file} for more details.{p_end}"'
			error 198
		}

		*Storing the code in local to be used later
		local items "`items' `item'"
		local labels `"`labels' `"`label'"'"'

		*Parse char is not removed by gettoken
		local labelinput_tokenize = subinstr(`"`labelinput_tokenize'"' ,"@","",1)
	}

	return local items  "`items'"
	return local labels `"`labels'"'

end

/*******************************************************************************
  test_parse_format: pars and test format input
	* Test that format specificed is a valid Stata format
*******************************************************************************/
cap program drop 	test_parse_format
	program define	test_parse_format, rclass

	syntax, format(string)

	** Creating a numeric mock variable that we attempt to apply the format
	*  to. This allows us to piggy back on Stata's internal testing to be
	*  sure that the format specified is at least one of the valid numeric
	*  formats in Stata
	tempvar      formattest
	gen         `formattest' = 1
	cap	format  `formattest' `format'

	if _rc == 120 {
		noi di as error "{phang}The format specified in format(`format') is not a valid Stata format. See {help format} for a list of valid Stata formats. This command only accept the f, fc, g, gc and e format.{p_end}"
		error 120
	}
	else if _rc != 0 {
		noi di as error "{phang}Something unexpected happened related to the option format(`format'). Make sure that the format you specified is a valid format. See {help format} for a list of valid Stata formats. If this problem remains, please report this error to dimeanalytics@worldbank.org.{p_end}"
		error _rc
	}

	************************
	** We know now format is a valid Stata numeric format,
	*  now test if it is one allowed in iebaltab

	local fomrmatAllowed 0
	local charLast  = substr("`format'", -1,.)
	local char2Last = substr("`format'", -2,.)

	*All formats ending on f and e are allowed
	if  "`charLast'" == "f" | "`charLast'" == "e" local fomrmatAllowed 1

	* Formats ending on g is allowed as long as it is not tg
	else if "`charLast'" == "g" {
		if "`char2Last'" == "tg" local fomrmatAllowed 0
		else                     local fomrmatAllowed 1
	}

	* Formats ending on c is allowed as long as it is not gc or fc
	else if  "`charLast'" == "c" {
		if "`char2Last'" != "gc" & "`char2Last'" != "fc" local fomrmatAllowed 0
		else                                             local fomrmatAllowed 1
	}

	*format is neither f, fc, g, gc nor e - no remaining format is allowed
	else local fomrmatAllowed 0

	* Throw error if an not allowed format is used
	if `fomrmatAllowed' == 0 {
		di as error "{phang}The format specified in {input:format(`format')} is not allowed. Only format f, fc, g, gc and e are allowed. See {help format} for details on Stata formats.{p_end}"
		error 120
	}

	*If format passed all tests, store it in the local used for display formats
	return local diformat "`format'"

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
	if (missing("`code1'") | missing("`code2'")) {
		noi display as error "{phang}One or both codes in [`pair'] is missing.{p_end}"
		error 7
	}
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
	* starlevels. If starlevels is empty (i.e. option nostars is used)
	* then it will always return the empty string "".
*******************************************************************************/
cap program drop 	count_stars
	program define	count_stars, rclass

	syntax, p(numlist missingokay) [starlevels(string)]

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

	syntax, full_user_input(string) [stats_string(string) fix(string) fix_used(string) covars(string) ftest feqtest ///
	starlevels(string) vce(string) ///
	vce_type(string) clustervar(string) ///
	weight_type(string) weight_var(string) ]

	local table_note "If the table includes missing values (.n, .o, .v etc.) see the Missing values section in the help file for the Stata command iebaltab for definitions of these values. "

	* Get stats and label for pairs and f-test
	get_stat_label_stats_string, stats_string("`stats_string'") testname("pair")
	local pout_lbl "`r(stat_label)'"

	* Test sentence
	local test_sentence = ""
	if !missing("`ftest'`feqtest'") & "`pout_lbl'" != "none" {
		local test_sentence = "pairwise and f-test regressions"
	}
	else if !missing("`ftest'`feqtest'") local test_sentence = "f-test regressions"
	else if "`pout_val'" != "none"       local test_sentence = "pairwise regressions"


	if !missing("`covars'") local table_note "`table_note' Covariate(s) used in `test_sentence': [`covars']."
	if `fix_used' == 1      local table_note "`table_note' Fixed effect used in `test_sentence': [`fix']."

	if !missing("`starlevels'") {
		tokenize "`starlevels'"
		local table_note "`table_note' Significance: ***=`3', **=`2', *=`1'."
	}

	if !missing("`vce'") {
		*Display variation in Standard errors (default) or in Standard Deviations
		if "`vce_type'" == "robust"		 local table_note "`table_note' Errors are robust. "
		if "`vce_type'" == "cluster"   local table_note "`table_note' Errors are clustered at variable: [`clustervar']. "
		if "`vce_type'" == "bootstrap" local table_note "`table_note' Errors are estimeated using bootstrap. "
	}

	if !missing("`weight_var'`weight_type'") {

		local f_weights "fweights fw freq weight"
		local a_weights "aweights aw"
		local p_weights "pweights pw"
		local i_weights "iweights iw"

		if      `:list weight_type in f_weights' local weight_type = "frequency"
		else if `:list weight_type in a_weights' local weight_type = "analytical"
		else if `:list weight_type in p_weights' local weight_type = "probability"
		else if `:list weight_type in i_weights' local weight_type = "importance"

		local table_note "`table_note' Observations are weighted using variable `weight_var' as `weight_type' weights."
  }

	* Add the full user input when running the command
  	local table_note `"`table_note' Full user input as written by user: [`full_user_input']"'

	return local table_note = trim(itrim(`"`table_note'"'))

end
