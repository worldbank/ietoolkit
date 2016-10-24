	*! version 2.0 24Oct2016  Kristoffer Bjarkefur kbjarkefur@worldbank.org

	capture program drop iebaltab
	program iebaltab
	
	
		syntax varlist(numeric) [if] [in], 									///
																			///
				/*Group variable*/											///
				GRPVar(varname) 											///
																			///
				[															///
				/*Columns and order of columns*/							///
				ORder(numlist int min=1) 									///
				COntrol(numlist int max=1) 									///
				TOTal 														///
																			///
				/*Column and row labels*/									///
				GRPCodes													///
				GRPLabels(string)											///
				TOTALLabel(string)											///
				ROWVarlabels												///
				ROWLabels(string)											///
																			///
				/*Statistics and data manipulation*/						///
				FIXedeffect(varname)										///
				COVariates(varlist)											///
				COVAMISSOK													///
				vce(string) 												///
				BALMISS(string) 											///
				BALMISSReg(string)											///
				COVMISS(string) 											///
				COVMISSReg(string)											///	
				MISSMINmean(numlist min=1 max=1 >0)							///
																			///
				/*F-test*/													///
				FTest 														///
				FMissok														///
				FNOOBS														///
																			///
				/*Output display*/											///
				PTtest														///
				PFtest														///
				PBoth														///
				STDev														///
				STARlevels(numlist descending min=3 max=3 >0 <1)			///
				STARSNOadd													///
				FORMat(string) 												///
				TBLNote(string)												///
				NOTECombine													///
				TBLNONote													///
																			///
				/*Export and restore*/										///
				SAVE(string)  												///
				BROWSE														///
				SAVEBRowse													///
				REPLACE														///
				]

				
		***************TODO***************
		* 3. When errors with click Stata code, find a way to apply all conditions for sample to output
		* 4. stdev as well as se
		* 5. Include option for latex

		
		********POTENTIAL UPDATES*********
		*2. Implement option for bootstrap
		
		********HELPFILE TODO*********
		*1. Explain difference in se between group by itself and the standard errors used in the t-test
		
	preserve		
qui {

	version 11
	
	*Remove observations excluded by if and in
	if ("`if'`in'"!="") {
		keep `if' `in'
	}
	
	*Remove observations with a missing value in grpvar()
	drop if `grpvar' >= .
	

	/***********************************************
	************************************************
	
		Set initial constants
		
	*************************************************
	************************************************/
		
		*di "START"
		
		*Create local for balance vars with more descriptive name
		local balancevars `varlist'

		
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
		
		*Is option covarmissok used:
		if "`covarmissok'"		== "" local COVARMISSOK_USED = 0 
		if "`covarmissok'" 		!= "" local COVARMISSOK_USED = 1 		
	
		*Is option cluster() used:
		if "`vce'" 				== "" local VCE_USED = 0 
		if "`vce'" 				!= "" local VCE_USED = 1 
	
		*Is option balmiss() used:
		if "`balmiss'" 			== "" local BALMISS_USED = 0 
		if "`balmiss'" 			!= "" local BALMISS_USED = 1 
		
		*Is option missreg() used:
		if "`balmissreg'" 		== "" local BALMISSREG_USED = 0 
		if "`balmissreg'" 		!= "" local BALMISSREG_USED = 1 		
		
		*Is option covmiss() used:		
		if "`covmiss'" 			== "" local COVMISS_USED = 0 
		if "`covmiss'" 			!= "" local COVMISS_USED = 1 
		
		*Is option covmissreg() used:
		if "`covmissreg'" 		== "" local COVMISSREG_USED = 0 
		if "`covmissreg'" 		!= "" local COVMISSREG_USED = 1 			
		
		*Is option missminmean() used:
		if "`missminmean'" 		== "" local MISSMINMEAN_USED = 0 
		if "`missminmean'" 		!= "" local MISSMINMEAN_USED = 1 			
		
		
		*Is option starlevels() used:
		if "`starlevels'" 		== "" local STARLEVEL_USED = 0 
		if "`starlevels'" 		!= "" local STARLEVEL_USED = 1 
		
		*Is option starsnoadd used:
		if "`starsnoadd'" 		== "" local STARSNOADD_USED = 0 
		if "`starsnoadd'" 		!= "" local STARSNOADD_USED = 1 
		
		*Is option pttest() used:
		if "`pttest'" 			== "" local PTTEST_USED = 0 
		if "`pttest'" 			!= "" local PTTEST_USED = 1 		
		
		*Is option pftest() used:
		if "`pftest'" 			== "" local PFTEST_USED = 0 
		if "`pftest'" 			!= "" local PFTEST_USED = 1 		
		
		*Is option pboth() used:
		if "`pboth'" 			== "" local PBOTH_USED 	= 0 
		if "`pboth'" 			!= "" local PBOTH_USED 	= 1 
		if `PBOTH_USED' == 1 		  local PTTEST_USED = 1
		if `PBOTH_USED' == 1 		  local PFTEST_USED = 1

		*Is option pftest() used:
		if "`stdev'" 			== "" local STDEV_USED = 0 
		if "`stdev'" 			!= "" local STDEV_USED = 1 
		
	** Output Options	
		
		*Is option format() used:
		if "`format'" 			== "" local FORMAT_USED = 0 
		if "`format'" 			!= "" local FORMAT_USED = 1 		
	
		*Is option save() used:
		if "`save'" 			== "" local SAVE_USED = 0 
		if "`save'" 			!= "" local SAVE_USED = 1 
		
		*Is option browse() used:
		if "`browse'" 			== "" local BROWSE_USED = 0 
		if "`browse'" 			!= "" local BROWSE_USED = 1		

		*Is option restore() used:
		if "`savebrowse'" 		== "" local SAVE_BROWSE_USED = 0 
		if "`savebrowse'" 		!= "" local SAVE_BROWSE_USED = 1 

		*Is option restore() used:
		if "`replace'" 			== "" local REPLACE_USED = 0 
		if "`replace'" 			!= "" local REPLACE_USED = 1 		

		*Is option tablenote() used:
		if "`tblnote'" 			== "" local NOTE_USED = 0 
		if "`tblnote'" 			!= "" local NOTE_USED = 1 	
		
		*Is option notecombine() used:
		if "`notecombine'" 	== "" local NOTECOMBINE_USED = 0 
		if "`notecombine'" 	!= "" local NOTECOMBINE_USED = 1 	
		
		*Is option notablenote() used:
		if "`tblnonote'" 		== "" local NONOTE_USED = 0 
		if "`tblnonote'" 		!= "" local NONOTE_USED = 1 			
		
	/***********************************************
	************************************************
	
		Prepare a list of group variables
	
	*************************************************
	************************************************/	
		
		*Create a local of all codes in group variable
		levelsof `grpvar', local(GRP_CODE_LEVELS)
		
		*Saving the name of the value label of the grpvar()
		local GRPVAR_VALUE_LABEL 	: value label `grpvar'
		
		*Counting how many levels there are in groupvar
		local GRPVAR_NUM_GROUPS : word count `GRP_CODE_LEVELS'
		
		*Static dummy for grpvar() has no label
		if "`GRPVAR_VALUE_LABEL'" == "" local GRPVAR_HAS_VALUE_LABEL = 0
		if "`GRPVAR_VALUE_LABEL'" != "" local GRPVAR_HAS_VALUE_LABEL = 1
			

	/***********************************************
	************************************************/
	
		*Testing that options to dmtab is correctly specified and make initial operations based on these commands
	
	/*************************************************
	************************************************/	
	
	** Group Options
	
		cap confirm numeric variable `grpvar' 
		if _rc != 0 {
			noi display as error "{phang}The variable listed in grpvar(`grpvar') is not a numeric variable. See {help encode} for options on how to make a categorical string variable into a categorical numeric variable{p_end}"
			error 108
		} 
		else {
			cap assert ( int(`grpvar') == `grpvar' )
			if _rc == 9 {
				noi display as error  "{phang}The variable in grpvar(`grpvar') is not a categorical variable. The variable may only include integers where each integer indicates which group each observation belongs to. See tabulation of `grpvar' below:{p_end}"
				noi tab `grpvar', nol
				error 109
			}
		}
			
	
	** Column Options
		
		** If control() or order() is used, then the levels specified in those
		*  options need to exist in the groupvar
		
		local control_correct : list control in GRP_CODE_LEVELS
		if `control_correct' == 0 {
			noi display as error "{phang}The code listed in control(`control') is not used in grpvar(`grpvar'). See tabulation of `grpvar' below:"
			noi tab `grpvar', nol
			error 197
		}
		
		local order_correct : list order in GRP_CODE_LEVELS
		if `order_correct' == 0 {
			noi display as error  "{phang}One or more codes listed in order(`order') are not used in grpvar(`grpvar'). See tabulation of `grpvar' below:"
			noi tab `grpvar', nol
			error 197
		}
		
		if `GRPLABEL_USED' == 1 {
			
			local col_labels_to_tokenize `grplabels'
			
			while "`col_labels_to_tokenize'" != "" {
				
				*Parsing code and label pair
				gettoken codeAndLabel col_labels_to_tokenize : col_labels_to_tokenize, parse("@")
			
				*Splitting code and label
				gettoken code label : codeAndLabel
		
		
				*** Codes
				
				*Checking that code exist in grpvar and store it
				local code_correct : list code in GRP_CODE_LEVELS
				if `code_correct' == 0 {
					noi display as error  "{phang}Code [`code'] listed in grplabels(`grplabels') is not used in grpvar(`grpvar'). See tabulation of `grpvar' below:"
					noi tab `grpvar', nol
					error 198
				}			
				
				*Storing the code in local to be used later
				local grpLabelCodes `"`grpLabelCodes' "`code'" "'
				
				
				*** Labels
				
				*Removing leadning or trailing spaces
				local label = trim("`label'")
				
				*Testing that no label is missing
				if "`label'" == "" {
					noi display as error "{phang}For code [`code'] listed in grplabels(`grplabels') you have not specified any label. Labels are requried for all codes listed in grplabels(). See tabulation of `grpvar' below:"
					noi tab `grpvar', nol
					error 198					
				}
				
				*Storing the label in local to be used later
				local grpLabelLables `"`grpLabelLables' "`label'" "'
		
		
				*Parse char is not removed by gettoken
				local col_labels_to_tokenize = subinstr("`col_labels_to_tokenize'" ,"@","",1)
			}
		}
		
		if `ROWLABEL_USED' {
		
			*** Test the validity for the rowlabel input
			
			*Create a local with the rowlabel input to be tokenized
			local row_labels_to_tokenize `rowlabels'
		
			while "`row_labels_to_tokenize'" != "" {
				
				*Parsing name and label pair
				gettoken nameAndLabel row_labels_to_tokenize : row_labels_to_tokenize, parse("@")
			
				*Splitting name and label
				gettoken name label : nameAndLabel
				
				*** Variable names
				
				*Checking that the variables used in rowlabels() are included in the table
				local name_correct : list name in balancevars
				if `name_correct' == 0 {
					noi display as error "{phang}Variable [`name'] listed in rowlabels(`rowlabels') is not found among the variables included in the balance table."
					error 111
				}		
				
				*Storing the code in local to be used later
				local rowLabelNames `"`rowLabelNames' "`name'" "'
				
				
				*** Variable labels
				
				*Removing leading or trailing spaces
				local label = trim("`label'")
				
				*Testing that no label is missing
				if "`label'" == "" {
					noi display as error "{phang}For variable [`name'] listed in rowlabels(`rowlabels') you have not specified any label. Labels are requried for all variables listed in rowlabels(). The variable name itself will be used for any variables omitted from rowlabels(). See also option {help dmtab:rowvarlabels}"
					noi tab `grpvar', nol
					error 198					
				}
				
				*Storing the label in local to be used later
				local rowLabelLabels `"`rowLabelLabels' "`label'" "'
				
				*Parse char is not removed by gettoken
				local row_labels_to_tokenize = subinstr("`row_labels_to_tokenize'" ,"@","",1)
			}
		}
	
		if `TOTALLABEL_USED' & !`TOTAL_USED' {
			
			*Error for totallabel() incorrectly applied
			noi display as error "{phang}Option totallabel() may only be used together with the option total"
			error 197
		}	
		
	** Stats Options	
		
		if `VCE_USED' == 1 {
			
			local vce_nocomma = subinstr("`vce'", "," , " ", 1)
			
			tokenize "`vce_nocomma'"
			local vce_type `1'
			
			if "`vce_type'" == "robust" {
				
				*Robust is allowed and not other tests needed
			}
			else if "`vce_type'" == "cluster" {
				
				local cluster_var `2'
				
				cap confirm variable `cluster_var'
				
				if _rc {
				
					*Error for vce(cluster) incorrectly applied
					noi display as error "{phang}The cluster variable in vce(`vce') does not exist or is invalid for any other reason. See {help vce_option :help vce_option} for more information. "
					error _rc

				}
			}
			else if  "`vce_type'" == "bootstrap" {
				
				*bootstrap is allowed and not other tests needed. Error checking is more comlex, add tests here in the future.
			}
			else {
			
				*Error for vce() incorrectly applied
				noi display as error "{phang}The vce type `vce_type' in vce(`vce') is not allowed. Only robust, cluster and bootstrap is allowed. See {help vce_option :help vce_option} for more information."
				error 198
			
			}
		}
		
		if `STARSNOADD_USED' == 0 {
		
			*Allow user defined p-values for stars or set the default values
			if `STARLEVEL_USED' == 1 {
			
				*Tokenize the string with the p-values entered by the user. The value entered are tested in syntax
				tokenize "`starlevels'"
				
				*Set user defined levels for 1, 2 and 3 stars
				local p1star `1'
				local p2star `2'
				local p3star `3'
			}
			else {
				*Set default levels for 1, 2 and 3 stars
				local p1star .1
				local p2star .05
				local p3star .01
			}
			
			** Create locals with the values expressed
			*  as percentages for the note to the table
			local p1star_percent = `p1star' * 100
			local p2star_percent = `p2star' * 100
			local p3star_percent = `p3star' * 100
		}
		else {
			
			*Options starsomitt is used. No stars will be displayed. By setting 
			*these locals to nothing the loop adding stars will not be iterated
			local p1star 
			local p2star
			local p3star 
		}

		*Error for starlevels incorrectly used together with starsnoadd
		if `STARSNOADD_USED' & `STARLEVEL_USED' {
			*Error for starlevels and starsnoadd incorrectly used together
			noi display as error "{phang}Option starlevels() may not be used in combination with option starsnoadd"
			error 197
		}			
		
		
		
		*Error for misszero incorrectly used together with missregzero
		if `BALMISS_USED' & `BALMISSREG_USED' {
			*Error for misszero and missregzero incorrectly used together
			noi display as error "{phang}Option misszero may not be used in combination with option missregzero"
			error 197
		}	
		
		if `COVMISS_USED' & `COVMISSREG_USED' {
			*Error for misszero and missregzero incorrectly used together
			noi display as error "{phang}Option covmisszero may not be used in combination with option covmissregzero"
			error 197
		}			
		
		*Testing input in these for options. See function at the end of this command
		if `BALMISS_USED' == 1 		iereplacestringtest "balmiss" 		"`balmiss'"
		if `BALMISSREG_USED' == 1 	iereplacestringtest "balmissreg" 	"`balmissreg'"
		if `COVMISS_USED' == 1 		iereplacestringtest "covmiss" 		"`covmiss'"
		if `COVMISSREG_USED' == 1 	iereplacestringtest "covmissreg" 	"`covmissreg'"
		
			
		if `FIX_EFFECT_USED' == 1 {
			
			cap assert `fixedeffect' < .
			if _rc == 9 {
			
				noi display as error  "{phang}The variable in fixedeffect(`fixedeffect') is missing for some observations. This would cause observations to be dropped in the estimation regressions. See tabulation of `fixedeffect' below:{p_end}"
				noi tab `fixedeffect', m
				error 109
			}
		
		}
		
		* test covariate variables
		if `COVARIATES_USED' == 1  {
			
			foreach covar of local covariates {
				
				*Create option string
				local replaceoptions 
				
				*Sopecify differently based on all missing or only regualr missing
				if `COVMISS_USED' 					local replaceoptions `" `replaceoptions' replacetype("`covmiss'") "'
				if `COVMISSREG_USED' 				local replaceoptions `" `replaceoptions' replacetype("`covmissreg'") regonly "'
				
				*Add group variable if the replace type is group mean
				if "`covmiss'" 		== "groupmean" 	local replaceoptions `" `replaceoptions' groupvar(`grpvar') groupcodes("`GRP_CODE_LEVELS'") "'
				if "`covmissreg'" 	== "groupmean" 	local replaceoptions `" `replaceoptions' groupvar(`grpvar') groupcodes("`GRP_CODE_LEVELS'") "'
				
				*Set the minimum number of observations to allow means to be set from
				if `MISSMINMEAN_USED' == 1			local replaceoptions `" `replaceoptions' minobsmean(`missminmean') "'
				if `MISSMINMEAN_USED' == 0			local replaceoptions `" `replaceoptions' minobsmean(10) "'
				
				*Excute the command. Code is found at the bottom of this ado file
				if (`COVMISS_USED' | `COVMISSREG_USED')  iereplacemiss `covancevar', `replaceoptions'		
				
				if `COVARMISSOK_USED' != 1 {
				
					cap assert `covar' < .
					if _rc == 9 {
				
						noi display as error  "{phang}The variable `covar' specified in covariates() has missing values for one or several observations. This would cause observations to be dropped in the estimation regressions. To allow for observations to be dropped see option covarmissok and to make the command treat missing values as zero see option covmisszero and covmissregzero. Click {stata tab `covar' `if' `in', m} to see the missing values.{p_end}"
						error 109
					}
				}
			}
		}
		 	
			
			
		
		
	** Output Options
		
		** If the format option is specified, then test if there is a valid format specified
		if `FORMAT_USED' == 1 {
			
			** Creating a numeric mock variable that we attempt to apply the format
			*  to. This allows us to piggy back on Stata's internal testing to be
			*  sure that the format specified is at least one of the valid numeric
			*  formats in Stata
				tempvar  formattest
				gen 	`formattest' = 1
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

		
		*Error for tblnonote incorrectly used together with notecombine
		if `NOTECOMBINE_USED' & `NONOTE_USED' {
			
			*Error for tblnonote incorrectly used together with notecombine
			noi display as error "{phang}Option tblnonote may not be used in combination with option notecombine"
			error 197
		}
	
		if `SAVE_USED' {
		
			*Find index for where the file type suffix start
			local dot_index 	= strpos("`save'",".")
			
			*Extract the file index
			local file_suffix 	= substr("`save'", `dot_index', .)
			
			*If no file format suffix is specified, use the default .xlsx
			if "`file_suffix'" == "" {
			
				local save `"`save'.xlsx"'
			}
			
			*If a file format suffix is specified make sure that it is one of the two allowed.
			else if !("`file_suffix'" == ".xls" | "`file_suffix'" == ".xlsx") {
			
				noi display as error "{phang}The file format specified in save(`save') is other than .xls or .xlsx. Only those two formats are allowed. If no format is specified .xlsx is the default.{p_end}"
				error 198
			}
		}
		else if `SAVE_BROWSE_USED' {
		
			noi display as error "{phang}Option savepreserve may only be used in combination with option save(){p_end}"
			error 198
		}
		
		*Exactly only one of save and browse may be used
		if (`SAVE_USED' + `BROWSE_USED' != 1) {
			
			*Error for incorrectly using both save() and browse
			noi display as error "{phang}Either option save() or option browse must be used and they are not allowed to be used together. Note that option browse drops all data in memory and it is not possible to restore it afterwards. Use preserve/restore, tempfiles or save data to disk before using the otion browse."
			error 197
		
		}
	/***********************************************
	************************************************/
	
		*Manage order in levels of grpvar()
	
	/*************************************************
	************************************************/	
		
		
		*Changed to value used in control() if control() is 
		*specified but order() is not, 
		if !`ORDER_USED' & `CONTROL_USED' local order `control'
		
		*Unless changed above, either as specified in order().
		*if order() is not specified then the all levels in
		*numeric order is stored in order_code_rest to be.
		local order_code_rest : list GRP_CODE_LEVELS - order
	
	
		*The final order is compiled. order_code_rest 
		*is ordered numerically. If order has no yet
		*been defined (if niether order() or control() 
		* was used) then order will be exactly like 
		* order_code_rest
		local ORDER_OF_GROUPS `order' `order_code_rest'
		

	/***********************************************
	************************************************/

		*Manage lables to be used for the groups in groupvar

	/*************************************************
	************************************************/	
		
		*Local that will store the final labels. These labels will be stored in the in final order of groups in groupvar
		local grpLabels_final "" 
		
		*Loop over all groups in the final order
		foreach groupCode of local ORDER_OF_GROUPS {
			
			*Test if this code has a manually defined group label
			local grpLabelPos : list posof "`groupCode'" in grpLabelCodes
			
			*If index is not zero then manual label is defined, use it
			if `grpLabelPos' != 0 {

				*Getting the manually defiend label corresponding to this code
				local 	group_label : word `grpLabelPos' of `grpLabelLables'
				
				*Storing the label to be used for this group code.
				local	grpLabels_final `" `grpLabels_final' "`group_label'" "'
			}
			
			** No manually defined label, test if group var has value labels or if user
			* has specified that value labels should not be used
			else if `NOGRPLABEL_USED' | !`GRPVAR_HAS_VALUE_LABEL' {
				
				*Not using value labels, simply using the group code as the label in the final table
				local	grpLabels_final `" `grpLabels_final' "`groupCode'" "'
				
			}
			
			*No defined group label but value labels exist and may be used
			else {	
				
				*Get the value label corresponding to this code
				local gprVar_valueLabel : label `GRPVAR_VALUE_LABEL' `groupCode'
				
				*Storing the value label used for grpvar corresponding to the group code.
				local grpLabels_final `" `grpLabels_final' "`gprVar_valueLabel'" "'
	
			}
		}
	
	
	
	
	/***********************************************
	************************************************/

		*Manage lables to be used as rowtitels

	/*************************************************
	************************************************/
	
		local rowLabelsFinal ""
		
		foreach balancevar of local balancevars {
		
			** Test if this variable has a manually defined rowlable. If 
			*  rowlabels() was not specified, then this local will be empty
			*  and generate index 0 for all variables
			local rowLabPos : list posof "`balancevar'" in rowLabelNames
			
			if `rowLabPos' != 0 {
				
				*Getting the manually defined label corresponding to this code
				local 	row_label : word `rowLabPos' of `rowLabelLabels'
				
				*Store the label in local to be used later
				local rowLabels_final `" `rowLabels_final' "`row_label'" "'
			
			}
			*Use variable label if option is specified
			else if `ROWVARLABEL_USED' {
			
				*Get the variable label used for this variable
				local var_label : variable label `balancevar'
				
				*Remove leading or trailing spaces
				local var_label = trim("`var_label'")
				
				*Make sure varlabel is not empty
				if "`var_label'" != "" {
					
					*Store the label in local to be used later
					local rowLabels_final `" `rowLabels_final' "`var_label'" "'
				}
				*If var lable empty, use var name instead
				else {
				
					*Store the label in local to be used later
					local rowLabels_final `" `rowLabels_final' "`balancevar'" "'
				}
			}
			*Otherwise use the variable name
			else {
				
				*Store the label in local to be used later
				local rowLabels_final `" `rowLabels_final' "`balancevar'" "'
			}
		}
	
	/***********************************************
	************************************************/
	
		*Creating title rows
	
	/*************************************************
	************************************************/
		
		
		** The titles consist of three rows across all 
		*  columns of the table. Each row is one local
		local titlerow1 ""
		local titlerow2 ""
		local titlerow3 `""Variable""'
		
		
								local variance_type "SE"
		if `STDEV_USED' == 1 	local variance_type "SD"
	
	*********************************************
	*Generating titles for each value of groupvar
		
		** Tempvar corresponding that will store the final 
		*  order for the group the observation belongs to
		tempvar  groupOrder
		gen 	`groupOrder' = .
		
		*Loop over the number of groups
		forvalues groupOrderNum = 1/`GRPVAR_NUM_GROUPS' {
			
			*Get the code and label corresponding to the group
			local groupLabel : word `groupOrderNum' of `grpLabels_final'
			local groupCode  : word `groupOrderNum' of `ORDER_OF_GROUPS'
	
			*Assign the group order to observations that belong to this group
			replace `groupOrder' = `groupOrderNum' if `grpvar' == `groupCode'
	 
			local titlerow1  `"`titlerow1' _tab "" 	_tab "(`groupOrderNum')" 	_tab ""   				"'
			local titlerow2  `"`titlerow2' _tab ""  _tab "`groupLabel'"   		_tab ""   				"'
			local titlerow3  `"`titlerow3' _tab "N" _tab "Mean"  				_tab "`variance_type'" 	"'
			
		}
		
	***********************************************************
	*Generating titles for sample total if total() is specified	
	
		if `TOTAL_USED' {
			
			local totalColNumber = `GRPVAR_NUM_GROUPS' + 1
			
			local tot_label Total
			if `TOTALLABEL_USED' local tot_label `totallabel'
			
			local titlerow1  `"`titlerow1' _tab ""	_tab "(`totalColNumber')"	_tab "" 				"'
			local titlerow2  `"`titlerow2' _tab "" 	_tab "`tot_label'" 			_tab "" 				"'
			local titlerow3  `"`titlerow3' _tab "N"	_tab "Mean"  				_tab "`variance_type'" 	"'
		}
	
		
	************************************************
	*Generating titles for each test of diff in mean
		
		local ttest_pairs ""
		
		if `CONTROL_USED' {
		
			*Get the order of the control group
			local ctrlGrpPos : list posof "`control'" in ORDER_OF_GROUPS
		
			*The t-tests will only be between control and each of the other groups
			forvalues second_ttest_group = 1/`GRPVAR_NUM_GROUPS' {	
				
				*Include all groups apart from the control group itself
				if `second_ttest_group' != `ctrlGrpPos' {
				
					*Adding title rows for the t-test. 
					local titlerow1 `"`titlerow1' _tab "t-test""'
					local titlerow2 `"`titlerow2' _tab "(`ctrlGrpPos') - (`second_ttest_group')""'
					
					if `PTTEST_USED' == 1 {
						local titlerow3 `"`titlerow3' _tab "p-value""'
					}
					else {
						local titlerow3 `"`titlerow3' _tab "Difference""'
					}
					
					*Storing a local of all the test pairs
					local ttest_pairs "`ttest_pairs' `ctrlGrpPos'_`second_ttest_group'"
				}
			}		
		}
		else {
			
			*The t-tests will be all cominations of groups
			forvalues first_ttest_group = 1/`GRPVAR_NUM_GROUPS' {
				
				** To guarantee that all combination of groups are included 
				*  but no duplicates are possible, start next loop one integer
				*  higher than the first group
				local nextPossGroup = `first_ttest_group' + 1
				
				forvalues second_ttest_group = `nextPossGroup'/`GRPVAR_NUM_GROUPS' {
					
					*Adding title rows for the t-test.
					local titlerow1  `"`titlerow1' _tab "t-test""'
					local titlerow2  `"`titlerow2' _tab "(`first_ttest_group')-(`second_ttest_group')""'
				
					if `PTTEST_USED' == 1 {
						local titlerow3 `"`titlerow3' _tab "p-value""'
					}
					else {
						local titlerow3 `"`titlerow3' _tab "Difference""'
					}
					
					*Storing a local of all the test pairs
					local ttest_pairs "`ttest_pairs' `first_ttest_group'_`second_ttest_group'"

				}
			}
		}
		

	
	
	****************************
	*Writing titles to textfile
		
		*Create a temporary textfile
		tempname 	textfile_name
		local 		textfile `textfile_name'		
			
		*Write the title rows defined above	
		capture file close `textfile'
		file open  `textfile' using `textfile'.txt, text write replace
		file write `textfile' ///
						`titlerow1' _n ///
						`titlerow2' _n ///
						`titlerow3' _n 
						
		file close `textfile'
	
		
	/***********************************************
	***********************************************/
	
		*Running the regrssion for the t-test 
		*for each variable in varlist
	
	/************************************************
	************************************************/		
	
	*** Setting default values or specified values for fixed effects and clusters
		
	**********************************
	*Preparing fixed effect option
	
		if !`FIX_EFFECT_USED' {
			
			** If a fixed effect var is not specified,
			*  then a constant fixed effect is here generated.
			*  A constent fixed effect leaves the areg 
			*  unaffected
			tempvar  fixedeffect
			gen 	`fixedeffect' = 1
		}

	**********************************
	*Preparing cluster option
	
		if `VCE_USED' {
			
			** The varname for cluster is
			*  prepared to be put in the areg
			*  options
			local error_estm vce(`vce')
		
		}
	
	
	** Create locals that control the warning table
					
			*Mean test warnings
			local warn_means_num    0
			local warn_means_strlen 0
			
			
			*Joint test warnings
			local warn_joint_novar_num	0
			local warn_joint_lovar_num	0
			local warn_joint_robus_num	0	
	
	
	*** Create columns with means and sd for this row
		
		foreach balancevar in `balancevars' {
		
			*Get the rowlabels prepared above one at the time
			gettoken row_label rowLabels_final : rowLabels_final
			
			*Start the tableRow string with the label defined
			local tableRow `""`row_label'""' 
			
			
			
			*** Replacing missing value
			
			** This option can be used to get a uniform N across all 
			*  variables even if the variable is missing for some 
			*  observations. When specifying this option, a dummy is 
			*  created indicating all HHs that have a missing value 
			*  for this variable. Missing values for the varaible is
			*  then set to zero, and in the areg used for testing the 
			*  differences in means, the dummy is included as a control.
			*  Note that this will slightly distort the mean as well.
			
			*Create option string
			local replaceoptions 
			
			*Sopecify differently based on all missing or only regualr missing
			if `BALMISS_USED' 					local replaceoptions `" `replaceoptions' replacetype("`balmiss'") "'
			if `BALMISSREG_USED' 				local replaceoptions `" `replaceoptions' replacetype("`balmissreg'") regonly "'
			
			*Add group variable if the replace type is group mean
			if "`balmiss'" 		== "groupmean" 	local replaceoptions `" `replaceoptions' groupvar(`grpvar') groupcodes("`GRP_CODE_LEVELS'") "'
			if "`balmissreg'" 	== "groupmean" 	local replaceoptions `" `replaceoptions' groupvar(`grpvar') groupcodes("`GRP_CODE_LEVELS'") "'
			
			*Set the minimum number of observations to allow means to be set from
			if `MISSMINMEAN_USED' == 1			local replaceoptions `" `replaceoptions' minobsmean(`missminmean') "'
			if `MISSMINMEAN_USED' == 0			local replaceoptions `" `replaceoptions' minobsmean(10) "'
			
			*Excute the command. Code is found at the bottom of this ado file
			if (`BALMISS_USED' | `BALMISSREG_USED')  iereplacemiss `balancevar', `replaceoptions'

			
			*** Run the regressions
		
			forvalues groupNumber = 1/`GRPVAR_NUM_GROUPS' {
			
				reg 	`balancevar' if `groupOrder' == `groupNumber' , `error_estm'
				
				local 	N_`groupNumber' 	= e(N)
				local 	N_`groupNumber'  	: display %9.0f `N_`groupNumber''
				
				*Load values from matrices into scalars
				local 	mean_`groupNumber' 	= _b[_cons]
				local	se_`groupNumber'   	= _se[_cons]
				
				local	di_mean_`groupNumber' 	: display `diformat' `mean_`groupNumber''
				
				*Display variation in Standard errors (default) or in Standard Deviations
				if `STDEV_USED' == 0 {
					*Format Standard Errors
					local 	di_var_`groupNumber' 	: display `diformat' `se_`groupNumber''
				}
				else {
					*Calculate Standard Deviation
					local 	sd_`groupNumber'		= `se_`groupNumber'' * sqrt(`N_`groupNumber'')
					*Format Standard Deviation
					local 	di_var_`groupNumber' 	: display `diformat' `sd_`groupNumber''
				}
				
				* Add three columns for each balance var (one balance var per loop)
				local 	tableRow  `"`tableRow' _tab "`N_`groupNumber''" _tab "`di_mean_`groupNumber''" _tab "`di_var_`groupNumber''" "'
			}
			
			if `TOTAL_USED' {
				
				reg 	`balancevar'  , `error_estm'
				
				local 	N_tot	= e(N)
				local 	N_tot 	: display %9.0f `N_tot'
				
				//Load values from matrices into scalars
				local 	mean_tot 	= _b[_cons]
				local	se_tot   	= _se[_cons]
				
				local mean_tot 	: display `diformat' `mean_tot'
				
				*Display variation in Standard errors (default) or in Standard Deviations
				if `STDEV_USED' == 0 {
					*Format Standard Errors
					local 	var_tot 	: display `diformat' `se_tot'
				}
				else {
					*Calculate Standard Deviation
					local 	sd_tot		= `se_tot' * sqrt(`N_tot')
					*Format Standard Deviation
					local 	var_tot 	: display `diformat' `sd_tot'
				}				
				
				* Add three columns for total
				local 	tableRow  `"`tableRow' _tab "`N_tot'" _tab "`mean_tot'" _tab "`var_tot'" "'
			}
	
	*** Create the columns with t-tests for this row

			*di "`ttest_pairs'" 
			foreach ttest_pair of local ttest_pairs {
				
				*Create a local for each group in the test 
				*pair from the test_pair local created above
				local undscr_pos   = strpos("`ttest_pair'","_")
				local first_group  = substr("`ttest_pair'",1,`undscr_pos'-1)
				local second_group = substr("`ttest_pair'",  `undscr_pos'+1,.)
				
				*Create the local with the difference to be displayed in the table
				local diff_`ttest_pair' =  `mean_`first_group'' - `mean_`second_group'' //means from section above

				*Create a temporary varaible used as the dummy to indicate 
				*which observation is in the first and in the second group 
				*in the test pair. Since all other observations are mission, 
				*this variable also exculde all observations in neither of 
				*the groups from the test regression
				tempvar tempvar_thisGroupInPair
				gen 	`tempvar_thisGroupInPair' = .	//default is missing, and obs not in this pair will remain missing
				replace `tempvar_thisGroupInPair' = 0 if `groupOrder' == `first_group'
				replace `tempvar_thisGroupInPair' = 1 if `groupOrder' == `second_group'
				
				*The command mean is used to test that there is variation 
				*in the balance var across these two groups. The regression 
				*that includes fixed effects and covariaties might run without 
				*error evern if there is no variance across the two groups. The 
				*local varloc will determine if an error or a warning will be 
				*thrown or if the test results will be replaced with an "N/A".
				mean `balancevar', over(`tempvar_thisGroupInPair') `error_estm'
				mat var = e(V)
				local varloc = max(var[1,1],var[2,2])				
				
				*This is the regression where we test differences.
				reg `balancevar' `tempvar_thisGroupInPair' `covariates' i.`fixedeffect' , `error_estm'
				
				
				*Testing result and if valid, write to file with or without stars
				if `varloc' == 0 {
					
					local warn_means_num  	= `warn_means_num' + 1
					local warn_means_strlen = max(`warn_means_strlen', strlen("`balancevar'"))
					
					local warn_means_test`warn_means_num' "(`first_group')-(`second_group')"
					local warn_means_bvar`warn_means_num' "`balancevar'"
					
					local tableRow `" `tableRow' _tab "N/A" "'
				}
				else {
					
					*Perform the t-test and store p-value in pttest
					test `tempvar_thisGroupInPair'
					local pttest = r(p)
					
					
					*If p-test option is used
					if `PTTEST_USED' == 1 {
						
						local ttest_output = `pttest'
					}
					*Otherwise display differences
					else {
					
						local ttest_output = `diff_`ttest_pair''
					}
				
					*Format the output
					local ttest_output : display `diformat' `ttest_output'
				
					*Add stars
					foreach ttest_p_level in `p1star' `p2star' `p3star' {
					
							if `pttest' < `ttest_p_level' local ttest_output "`ttest_output'*"
					}
					
					*Print row
					local tableRow `" `tableRow' _tab "`ttest_output'" "'
				}
			}
			
			*Write the row for this balance var to file.
			file open  `textfile' using `textfile'.txt, text write append
			file write `textfile' ///
				`tableRow' _n			
			file close `textfile'
			
		}
		
	/***********************************************
	***********************************************/
	
		*Running the regrssion for the F-tests
	
	/************************************************
	************************************************/
	
	if `FTEST_USED' == 1 {
		
		if `PFTEST_USED' == 1 {
			local Fstat_row `" "F-test of joint significance (p-value)"  "'
		}
		else {
			local Fstat_row `" "F-test of joint significance (F-stat)"  "'
		
		}
		local Fobs_row  `" "F-test, number of observations"  "'

		*Create empty cells for all the group columns
		forvalues groupIteration = 1/`GRPVAR_NUM_GROUPS' {

			local Fstat_row   `" `Fstat_row' _tab "" _tab "" _tab "" "'
			local Fobs_row    `" `Fobs_row'  _tab "" _tab "" _tab "" "'
		}
		
		*Create empty cells for total columns if total is used
		if `TOTAL_USED' {
			local Fstat_row   `" `Fstat_row' _tab "" _tab "" _tab "" "'
			local Fobs_row    `" `Fobs_row'  _tab "" _tab "" _tab "" "'
		}
		
		*Local used to count number of f-test that trigered warnings
		local warn_joint_novar_num	0
		local warn_joint_lovar_num	0
		local warn_joint_robus_num	0			
		local fmiss_error 			0
		
		*Run the F-test on each pair
		foreach ttest_pair of local ttest_pairs {
				
			*Create a local for each group in the test 
			*pair from the test_pair local created above			
			local undscr_pos   = strpos("`ttest_pair'","_")
			local first_group  = substr("`ttest_pair'",1,`undscr_pos'-1)
			local second_group = substr("`ttest_pair'",  `undscr_pos'+1,.)
		
			*Create the local with the difference to be displayed in the table
			tempvar tempvar_thisGroupInPair miss
			gen 	`tempvar_thisGroupInPair' = .
			replace `tempvar_thisGroupInPair' = 0 if `groupOrder' == `first_group'
			replace `tempvar_thisGroupInPair' = 1 if `groupOrder' == `second_group'		
			
			***** Testing if any obs have missing values in any og the varaibles used in the f_test
			
			*Loop over all balvars and seperate them with a comma
			local balvars_comma_seperated
			foreach balancevar of local balancevars {
				local balvars_comma_seperated `balvars_comma_seperated' , `balancevar'
			}
			*Remove the first comman before the first variable
			local balvars_comma_seperated = subinstr("`balvars_comma_seperated'" ,",","",1) 
			*Generate a variable equal to 1 if any balance var is missing
			gen `miss' = missing(`balvars_comma_seperated') if !missing(`tempvar_thisGroupInPair')
			
			*Count number obs in this test pair with non-missing values for all balance variables.
			count if `miss' == 0 
			
			if `r(N)' == 0 {
				noi di as error "{phang}F-test not possible. All observations are dropped from the f-test regression as no observation in the f-test between (`first_group')-(`second_group') has non-missing values in all balance variables. Disable the f-test option."
				error 2000
			}
			else if `r(N)' == 1 {
				noi di as error "{phang}F-test not possible. All but one observation are dropped from the f-test regression as only that one observation in the f-test between (`first_group')-(`second_group') has non-missing values in all balance variables. Disable the f-test option."
				error 2001
			}
			
			*Count number obs in this test pair with missing value in at least one balance variable.
			count if `miss' == 1
			
			
			if `r(N)' != 0 & `F_MISS_OK' == 0 {
				local fmiss_error 		1	//Used to throw error below 
				local fmiss_error_list 	`fmiss_error_list', (`first_group')-(`second_group')
			}
			
			********** 
			* Run the regression for f-test
			reg `tempvar_thisGroupInPair' `balancevars' `covariates' i.`fixedeffect' ,  `error_estm'
			
			*This F is calculated using fixed effects as well
			local reg_F 	"`e(F)'"
			local reg_F_N 	"`e(N)'"
			
			*Test all balance variables for joint significance
			cap testparm `balancevars'
			local test_F 	"`r(F)'"
			local test_F_p 	"`r(p)'"
			
			********** 
			* Write to table 	
			
			* No variance in either groups mean in any of the balance vars. F-test not possible to calculate
			if _rc == 111 {
				
				local warn_joint_novar_num	= `warn_joint_novar_num' + 1
				local warn_joint_novar`warn_joint_novar_num' "(`first_group')-(`second_group')"
				
				local Fstat_row   `" `Fstat_row' _tab "N/A"  "'
				local Fobs_row    `" `Fobs_row'  _tab "N/A"  "'
			}
			
			* Coliniarity between one balance variable and the dependent treatment dummy
			else if "`test_F'" == "." {
				
				local warn_joint_lovar_num	= `warn_joint_lovar_num' + 1
				local warn_joint_lovar`warn_joint_lovar_num' "(`first_group')-(`second_group')"
				
				local Fstat_row   `" `Fstat_row' _tab "N/A"  "'
				local Fobs_row    `" `Fobs_row'  _tab "N/A"  "'
			}
			
			* F-test is incorreclty specified, error in this code
			else if _rc != 0 {
				noi di as error "F-test not valid. Please report this error to kbjarkefur@worldbank.org"
				error _rc
			}
			
			* F-tests possible to calculate
			else {
				
				* Robust singularity, see help file. Similar to overfitted model. Result possible but probably not reliable
				if "`reg_F'" == "." {
				
					local warn_joint_robus_num	= `warn_joint_robus_num' + 1
					local warn_joint_robus`warn_joint_robus_num' "(`first_group')-(`second_group')"
				}				
				
				*If p-test option is used
				if `PFTEST_USED' == 1 {
					
					local ftest_output = `test_F_p'
				}
				*Otherwise display differences
				else {
				
					local ftest_output = `test_F'
				}				
				
				
				*Store f-value
				local ftest_output 	: display `diformat' `ftest_output'
				local reg_F_N 		: display  %9.0f  	 `reg_F_N'
				
				*Adding stars
				foreach ftest_p_level in `p1star' `p2star' `p3star' {
				
						if `test_F_p' < `ftest_p_level' local ftest_output `ftest_output'*
				}
				
				*Store the f-stat value with stars to the f-stat row
				local Fstat_row   `" `Fstat_row' _tab "`ftest_output'"  "'
				local Fobs_row    `" `Fobs_row'  _tab "`reg_F_N'"  		"'
			}
		}
		
		*******
		* Throw missing values in f-test warning
		if `fmiss_error' == 1 {
		
			*Remove the first comman before the first variable
			local fmiss_error_list = subinstr("`fmiss_error_list'" ,",","",1) 
			
			noi di as error "{phang}F-test is possible but perhaps not advisable. Some observations have missing values in some of the balance variables and therfore dropped from the f-stat regression. This happened in the f-tests for the following group(s): [`fmiss_error_list']. Solve this by manually restricting the balance table using if or in, or disable the f-test, or by using option {help dmtab:misszero}. Suppress this error message by using option {help dmtab:fmissok}"
			error 416
		}
		
		
		
		*******
		* Write the f-test row to file
		
		file open  `textfile' using `textfile'.txt, text write append
								file write `textfile' `Fstat_row' _n
			if !`F_NO_OBS' 		file write `textfile' `Fobs_row'  _n
		file close `textfile'
		
	}
	
	
	/***********************************************
	************************************************/
	
		*Compile and display warnings (as opposed to errors in relation to t and f tests.)
	
	/*************************************************
	************************************************/

	local anywarning	= max(`warn_means_num' ,`warn_joint_novar_num', `warn_joint_lovar_num' ,`warn_joint_robus_num')
	local anywarning_F	= max(`warn_joint_novar_num', `warn_joint_lovar_num' ,`warn_joint_robus_num')
	
	if `anywarning' > 0 {
		
		noi di as text ""
		noi di as error "{hline}"
		noi di as error "{pstd}Stata issued one or more warnings in relation to the tests in this balance table. Read the warning(s) below carefully before using the values generated for this table.{p_end}" 
		noi di as text ""
		
		if `warn_means_num' > 0 {
			
			noi di as text "{pmore}{bf:Difference-in-Means Tests:} The variance in both groups listed below is zero for the varaible indicated and a difference-in-means test between the two groups is therefore not valid. Tests are reported as N/A in the table.{p_end}" 
			noi di as text ""
			
			noi di as text "{col 9}{c TLC}{hline 11}{c TT}{hline 36}{c TRC}"
			noi di as text "{col 9}{c |}{col 13}Test{col 21}{c |}{col 24}Balance Variable{col 58}{c |}"
			noi di as text "{col 9}{c LT}{hline 11}{c +}{hline 36}{c RT}"
			
			forvalues warn_num = 1/`warn_means_num' {
				noi di as text "{col 9}{c |}{col 12}`warn_means_test`warn_num''{col 21}{c |}{col 24}`warn_means_bvar`warn_num''{col 58}{c |}"
			}
			noi di as text "{col 9}{c BLC}{hline 11}{c BT}{hline 36}{c BRC}"
			noi di as text ""
		}
		
		if `anywarning_F' > 0 {
			noi di as text "{pmore}{bf:Joint Significance Tests:} F-tests are not possible to perform or unreliable. See below for details:{p_end}" 
			noi di as text ""
			
			if `warn_joint_novar_num' > 0 {
				
				noi di as text "{pmore}In the following tests, F-tests were not valid as all variables were omitted in the joint significance test due to colliniarity. Tests are reported as N/A in the table.{p_end}" 
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
	
	/***********************************************
	************************************************/
	
		*Add notes to the bottom of the table
		
	/*************************************************
	************************************************/
	
	* Prepare the covariate note.
	if `COVARIATES_USED' == 1 {
		local covars_comma = ""
		
		*Loop over all covariates and add a comma
		foreach covar of local covariates {
			if "`covars_comma'" == "" {
				local covars_comma "and `covar'"
				local one_covar 1
			}
			else {
				local covars_comma "`covar', `covars_comma'" 
				local one_covar 0
			}
		}
		
		* If only one covariate, remove and from local and make note singular, and if multiple covariates, make note plural.
		if `one_covar' == 1 {
			local covars_comma = subinstr("`covars_comma'" , "and ", "", .)
			local covar_note	"The covariate variable `covars_comma' is included in all estimation regressions. "
		}
		else {
			local covar_note	"The covariate variables `covars_comma' are included in all estimation regressions. "
		}
	}
	
	*** Prepare the notes used below
	local fixed_note	"Fixed effects using variable `fixedeffect' are included in all estimation regressions. "
	local stars_note	"***, **, and * indicate significance at the `p3star_percent', `p2star_percent', and `p1star_percent' percent critical level. "
	
	if `PTTEST_USED' == 1 {	
		local ttest_note "The value displayed for t-tests are p-values. " 
	}
	else {
		local ttest_note "The value displayed for t-tests are the differences in the means across the groups. " 
	}
	
	if `PFTEST_USED' == 1 {	
		local ftest_note "The value displayed for F-tests are p-values. " 
	}
	else {
		local ftest_note "The value displayed for F-tests are the F-statistics. "
	}	
	
	if `VCE_USED' == 1 {
			
		*Display variation in Standard errors (default) or in Standard Deviations
		if `STDEV_USED' == 0 {
			*Standard Errors string
			local 	variance_type_name 	"Standard errors"
		}
		else {
			*Standard Deviation string
			local 	variance_type_name 	"Standard deviations"
		}		
		
		if "`vce_type'" == "robust"		local error_est_note	"`variance_type_name' are robust. "
		if "`vce_type'" == "cluster"  	local error_est_note	"`variance_type_name' are clustered at variable `cluster_var'. "
		if "`vce_type'" == "bootstrap"  local error_est_note	"`variance_type_name' are estimeated using bootstrap. "
	}	

	
	if `BALMISS_USED' == 1 | `BALMISSREG_USED' == 1 {
		
		if `BALMISS_USED' 		== 1 	local balmiss_note "All missing values in balance variables are treated as zero."
		if `BALMISSREG_USED'  	== 1 	local balmiss_note "Regular missing values in balance variables are treated as zero,  {help missing:extended missing values} are still treated as missing."
		
		local BALMISS_USED = 1
	}
	
	
	
	if `COVMISS_USED' == 1 | `COVMISSREG_USED' == 1 {
		
		if `COVMISS_USED'		== 1	local covmiss_note "All missing values in covariate varaibles are treated as zero."
		if `COVMISSREG_USED'  	== 1	local covmiss_note "Regular missing values in covariate varaibles are treated as zero, {help missing:extended missing values} are still treated as missing."
		
		local COVMISS_USED = 1
	}
	
	
	
	*** Write notes to file according to specificiation
	
	if `NOTECOMBINE_USED' == 1 {

		*Combine all notes used to one line
		
		*Delete the locals corresponding to options not used
		if `FTEST_USED'			== 0	local ftest_note		""
		if `VCE_USED'			== 0	local error_est_note	""
		if `FIX_EFFECT_USED'	== 0	local fixed_note		""
		if `COVARIATES_USED'	== 0	local covar_note		""
		if `BALMISS_USED'		== 0	local balmiss_note 		""
		if `COVMISS_USED'		== 0	local covmiss_note 		""
		if `STARSNOADD_USED'	== 1	local stars_note		""
		

		
		*Write to file
		file open  `textfile' using `textfile'.txt, text write append
		
			file write `textfile' "`tblnote' `ttest_note'`ftest_note'`error_est_note'`fixed_note'`covar_note'`balmiss_note'`covmiss_note'`stars_note'" _n
			
		file close `textfile'
		
	}
	else if `NONOTE_USED' == 1 {
		
		*Nonote used. Only add manually entered note
		
		file open  `textfile' using `textfile'.txt, text write append
		
			if `NOTE_USED' 			file write `textfile' "`tblnote'" _n
			
		file close `textfile'
		
	}
	else {
	
		file open  `textfile' using `textfile'.txt, text write append
		
			if  `NOTE_USED' 		file write `textfile' "`tblnote'" 			_n
									file write `textfile' "`ttest_note'" 		_n
			if 	`FTEST_USED'		file write `textfile' "`ftest_note'" 		_n
			if  `VCE_USED'			file write `textfile' "`error_est_note'" 	_n	
			if  `FIX_EFFECT_USED' 	file write `textfile' "`fixed_note'" 		_n
			if  `COVARIATES_USED' 	file write `textfile' "`covar_note'" 		_n
			if  `BALMISS_USED'		file write `textfile' "`balmiss_note'"		_n	
			if  `COVMISS_USED'		file write `textfile' "`covmiss_note'"		_n			
			if !`STARSNOADD_USED'	file write `textfile' "`stars_note'" 		_n
		file close `textfile'
		
	}
			
			
	/***********************************************
	************************************************/
	
		*Export and restore data unless other specified
	
	/*************************************************
	************************************************/
		
	restore
	
	
	
	
	if !( `BROWSE_USED' | `SAVE_BROWSE_USED' ) preserve
	

		import delimited using `textfile'.txt, clear delimiters("\t")
		
		if `SAVE_USED' {
		
			export excel using `"`save'"', `replace'
			
			noi di as result `"{phang}Balance table saved to: {browse "`save'":`save'} "'
		}
	
	if !( `BROWSE_USED' | `SAVE_BROWSE_USED' ) restore
	

}	

end

*This function is used to test the input in the options 
*that replace missing values. Only three strings are allowed 
*as arguemnts
cap program drop iereplacestringtest
program define iereplacestringtest

	args optionname replacetypestring
	
	if !("`replacetypestring'" == "zero" | "`replacetypestring'" == "mean" |  "`replacetypestring'" == "groupmean") {
	
		noi display as error  "{phang}The string entered in option `optionname'(`replacetypestring') is not a valid replace type string. Only zero, mean and groupmean is allowed. See {help iebaltab:help iebaltab} for more details.{p_end}"
		error 198
	}

end 

*This function replaces zeros in balance variables 
*or covariates according to the users specifications.
cap program drop iereplacemiss
program define iereplacemiss
	
	syntax varname, replacetype(string) [minobsmean(numlist) regonly groupvar(varname) groupcodes(string)]
		
		*Which missing values to change. Standard or extended.
		if "`regonly'" == "" {
			local misstype "`varlist' >= ." 
		}
		else {
			local misstype "`varlist' == ." 
		}
		
		
		*Set the minimum number of observations 
		*a mean is allowed to be based on.
		if "`minobsmean'" == "" {
			local minobs 10 	//10 is the default
		}
		else {
			*setting it to a user defiend value
			local minobs `minobsmean' 
		}
		
		
		*Change the missing values accord 
		*to the users specifications
		if "`replacetype'" == "zero" {
			
			*Missing is set to zero
			replace `varlist' = 0 if `misstype'
			
		}
		else if "`replacetype'" == "mean" {
			
			*Generate the mean for all observations in the table
			sum		`varlist' 
			
			*Test that there are enough observations to base the mean on
			if `r(N)' < `minobs' {
				noi display as error  "{phang}Not enough observations. There are less than `minobs' observations with a non missing value in `varlist'. Missing values can therefore not be set to the mean. Click {stata tab `varlist', missing} for detailed information.{p_end}"
				error 2001
			}
			
			*Missing values are set to the mean
			replace `varlist' = `r(mean)' if `misstype'
			
		}
		else if  "`replacetype'" == "groupmean" {
			
			*Loop over each group code
			foreach code of local groupcodes {
				
				*Generate the mean for all observations in the group
				sum		`varlist' if `groupvar' == `code'
				
				*Test that there are enough observations to base the mean on
				if `r(N)' == 0 {
				
					noi display as error  "{phang}No observations. All values are missing in variable `varlist' for group `code' in variable `groupvar' and missing values can therefore not be set to the group mean. Click {stata tab `varlist' if `groupvar' == `code', missing} for detailed information.{p_end}"
					error 2000
				}
				if `r(N)' < `minobs' {
				
					noi display as error  "{phang}Not enough observations. There are less than `minobs' observations in group `code' in variable `groupvar' with a non missing value in `varlist'. Missing values can therefore not be set to the group mean. Click {stata tab `varlist' if `groupvar' == `code', missing} for detailed information.{p_end}"
					error 2001
				
				}
				
				*Missing values are set to the mean of the group
				replace `varlist' = `r(mean)' if `misstype' & `groupvar' == `code'
			}
		
		}

end

qui {
noi di ""
noi di "This is a cat that says meow"
			noi di"     /\___/\"
	noi di"    (  o o  )  meow!"
				noi di"    /   *   \"
	  noi di"    \__\_/__/" 
		   noi di"      /   \"
	noi di"     / ___ \"
	   noi di"     \/_|_\/"
		}

		
