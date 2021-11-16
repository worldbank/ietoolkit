** The titles consist of three rows across all
*  columns of the table. Each row is one local
local titlerow1 ""
local titlerow2 ""
local titlerow3 `""Variable""'



		** Set titlw SE if standard errors are used (default)
		*  or SD if standard deviation is used
								local variance_type "SE"
		if `STDEV_USED' == 1 	local variance_type "SD"

		*Prepare title for column showing onle N or N and cluster
		if "`vce_type'" != "cluster" {
			local N_title "N"
		}
		else {
			local N_title "N/[Clusters]"
		}

		** Tempvar corresponding that will store the final
		*  order for the group the observation belongs to
		tempvar  groupOrder
		gen 	`groupOrder' = .

		*Loop over the number of groups
		forvalues groupOrderNum = 1/`GRPVAR_NUM_GROUPS' {

			*Get the code and label corresponding to the group
			local groupLabel : word `groupOrderNum' of `grpLabels_final'
			local groupCode  : word `groupOrderNum' of `ORDER_OF_GROUP_CODES'

			*Prepare a row to store onerow values for each group
			if `ONEROW_USED' == 1 local onerow_`groupOrderNum' ""

			*Assign the group order to observations that belong to this group
			replace `groupOrder' = `groupOrderNum' if `grpvar' == `groupCode'

			*Create one more column for N if N is displayesd in column instead of row
			if `ONEROW_USED' == 0 {

				local titlerow1 `"`titlerow1' _tab "" 	_tab " (`groupOrderNum') " "'
				local titlerow2 `"`titlerow2' _tab ""  _tab "`groupLabel'"   	   "'
				local titlerow3 `"`titlerow3' _tab "`N_title'" _tab "Mean/`variance_type'" "'



			}
			else {

				local titlerow1 `"`titlerow1' _tab " (`groupOrderNum') " "'
				local titlerow2 `"`titlerow2' _tab "`groupLabel'" "'
				local titlerow3 `"`titlerow3' _tab "Mean/`variance_type'" "'

			}

		}



				if `TOTAL_USED' {

					*Add one more column group
					local totalColNumber = `GRPVAR_NUM_GROUPS' + 1

					*If onerow used, then add a local to store the total num obs
					if `ONEROW_USED' == 1 local onerow_tot ""

					local tot_label Total
					if `TOTALLABEL_USED' local tot_label `totallabel'


					*Create one more column for N if N is displayesd in column instead of row
					if `ONEROW_USED' == 0 {

						local titlerow1 `"`titlerow1' _tab ""	_tab " (`totalColNumber') "	"'
						local titlerow2 `"`titlerow2' _tab "" 	_tab "`tot_label'" 			"'
						local titlerow3 `"`titlerow3' _tab "`N_title'"	_tab "Mean/`variance_type'" "'

					}
					else {

						local titlerow1 `"`titlerow1' _tab " (`totalColNumber') " "'
						local titlerow2 `"`titlerow2' _tab "`tot_label'" 		  "'
						local titlerow3 `"`titlerow3' _tab "Mean/`variance_type'" "'


					}
				}


				if `TTEST_USED' | `NORMDIFF_USED' {

					if `CONTROL_USED' {

						iecontrolheader 	"`control'" "`ORDER_OF_GROUP_CODES'" "`GRPVAR_NUM_GROUPS'" ///
											`TTEST_USED' `PTTEST_USED' `NORMDIFF_USED' ///
											`" `titlerow1' "' `" `titlerow2' "' `" `titlerow3' "' `" `texrow3' "'
					}
					else {

						ienocontrolheader	 "`GRPVAR_NUM_GROUPS'" ///
											`TTEST_USED' `PTTEST_USED' `NORMDIFF_USED' ///
											`" `titlerow1' "' `" `titlerow2' "' `" `titlerow3' "' `" `texrow3' "'

					}

					local titlerow1		`"`r(titlerow1)'"'
					local titlerow2		`"`r(titlerow2)'"'
					local titlerow3		`"`r(titlerow3)'"'

				}


				************************************************
				*Add column for F-test of joint equality

					if `FEQTEST_USED' {

						local titlerow1 `"`titlerow1' _tab "F-test""'
						local titlerow2 `"`titlerow2' _tab "for joint""'
						local titlerow3 `"`titlerow3' _tab "orthogonality""'

					}



						****************************
						*Writing titles to textfile

							*Create a temporary textfile
							tempname 	textname
							tempfile	textfile

							*Write the title rows defined above
							cap file close 	`textname'
							file open  		`textname' using "`textfile'", text write replace
							file write  	`textname' ///
												`titlerow1' _n ///
												`titlerow2' _n ///
												`titlerow3' _n
							file close 		`textname'


							local tex_line_space	0pt

							foreach balancevar in `balancevars' {

								*Get the rowlabels prepared above one at the time
								gettoken row_label rowLabels_final : rowLabels_final

								*Start the tableRow string with the label defined
								local tableRowUp `""`row_label'""'
								local tableRowDo `" "'

								*Make sure special characters in variable labels are displayed correctly
								local texrow_label : subinstr local row_label 	 "%"  "\%" , all
								local texrow_label : subinstr local texrow_label "_"  "\_" , all
								local texrow_label : subinstr local texrow_label "["  "{[}" , all
								local texrow_label : subinstr local texrow_label "&"  "\&" , all
								local texrow_label : subinstr local texrow_label "\$"  "\\\\\\\$" , all

								local texRow	`""`texrow_label'""'

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
								if "`balmiss'" 		== "groupmean" 	local replaceoptions `" `replaceoptions' groupvar(`grpvar') groupcodes("`GRP_CODES'") "'
								if "`balmissreg'" 	== "groupmean" 	local replaceoptions `" `replaceoptions' groupvar(`grpvar') groupcodes("`GRP_CODES'") "'

								*Set the minimum number of observations to allow means to be set from
								if `MISSMINMEAN_USED' == 1			local replaceoptions `" `replaceoptions' minobsmean(`missminmean') "'
								if `MISSMINMEAN_USED' == 0			local replaceoptions `" `replaceoptions' minobsmean(10) "'

								*Excute the command. Code is found at the bottom of this ado file
								if (`BALMISS_USED' | `BALMISSREG_USED')  iereplacemiss `balancevar', `replaceoptions'


								*** Run the regressions

								forvalues groupNumber = 1/`GRPVAR_NUM_GROUPS' {

									reg 	`balancevar' if `groupOrder' == `groupNumber' `weight_option', `error_estm'

									*Number of observation for this balancevar for this group
									local 	N_`groupNumber' 	= e(N)
									local 	N_`groupNumber'  	: display %9.0f `N_`groupNumber''

									*If clusters used, number of clusters in this balance var for this group
									if "`vce_type'" == "cluster" {

										local 	N_clust_`groupNumber' 	= e(N_clust)
										local 	N_clust_`groupNumber'  	: display %9.0f `N_clust_`groupNumber''
										local 	N_clust_`groupNumber' 	= trim("`N_clust_`groupNumber''")
										local 	N_clustex_`groupNumber' = "{[}`N_clust_`groupNumber'']"
										local 	N_clust_`groupNumber' 	= "[`N_clust_`groupNumber'']"
									}

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

									*Remove leading zeros from excessive fomrat
									local 	N_`groupNumber' 		=trim("`N_`groupNumber''")
									local 	di_mean_`groupNumber' 	=trim("`di_mean_`groupNumber''")
									local 	di_var_`groupNumber' 	=trim("`di_var_`groupNumber''")

									*Test that N is the same for each group across all vars
									if `ONEROW_USED' == 0 {

										local 	tableRowUp  `"`tableRowUp' _tab "`N_`groupNumber''" 		_tab "`di_mean_`groupNumber''"  "'
										local 	tableRowDo  `"`tableRowDo' _tab "`N_clust_`groupNumber''" 	_tab "[`di_var_`groupNumber'']"  "'

										if `SHOW_NCLUSTER' == 0	{
											local texRow 	`"`texRow' " & `N_`groupNumber'' & \begin{tabular}[t]{@{}c@{}} `di_mean_`groupNumber'' \\ (`di_var_`groupNumber'') \end{tabular}"  "'
										}
										if `SHOW_NCLUSTER' == 1	{
											local texRow 	`"`texRow' " & \begin{tabular}[t]{@{}c@{}} `N_`groupNumber'' \\ `N_clustex_`groupNumber'' \end{tabular} & \begin{tabular}[t]{@{}c@{}} `di_mean_`groupNumber'' \\ (`di_var_`groupNumber'') \end{tabular}"  "'
										}
									}
									else {

										*Test if the number of observations is the same in each group accross all balance vars
										if "`onerow_`groupNumber''" == "" {
											*Store the obs num
											local onerow_`groupNumber' = `N_`groupNumber''
										}
										*If not, then check that the obs num is the same as before
										else if !(`onerow_`groupNumber'' == `N_`groupNumber'') {

											*option onerow not allowed if N is different
											noi display as error  "{phang}The number of observations for `balancevar' is different compared to other balance variables within the same group. You can therefore not use the option onerow. Run the command without the option onerow to see which group does not have the same number of observations with non-missing values across all balance variables.{p_end}"
											error 198
										}


										*If cluster is usedTest if the number of clusters is the same in each group accross all balance vars
										if "`vce_type'" == "cluster" {

											if "`oneclstrow_`groupNumber''" == "" {
												*Store the obs num
												local oneclstrow_`groupNumber' = `N_clust_`groupNumber''
											}
											*If not, then check that the obs num is the same as before
											else if !(`oneclstrow_`groupNumber'' == `N_clust_`groupNumber'') {

												*option onerow not allowed if N is different
												noi display as error  "{phang}The number of clusters for `balancevar' is differenet compared to other balance variables within the same group. You can therefore not use the option onerow. Run the command without the option onerow to see which group does not have the same number of clusters with non-missing values across all balance variables.{p_end}"
												error 198
											}
										}

										*Either this is the first balance var or num obs are identical, so write columns
										local 	tableRowUp  	`"`tableRowUp' _tab "`di_mean_`groupNumber''"  "'
										local 	tableRowDo  	`"`tableRowDo' _tab "[`di_var_`groupNumber'']"  "'

										local 	texRow 		`"`texRow' " &  \begin{tabular}[t]{@{}c@{}} `di_mean_`groupNumber'' \\ (`di_var_`groupNumber'') \end{tabular}"  "'
									}

								}

								if `TOTAL_USED' {

									reg 	`balancevar'  `weight_option', `error_estm'

									local 	N_tot	= e(N)
									local 	N_tot 	: display %9.0f `N_tot'

									*If clusters used, number of clusters in this balance var for this group
									if "`vce_type'" == "cluster" {

										local 	N_clust_tot 	= e(N_clust)
										local 	N_clust_tot  	: display %9.0f `N_clust_tot'
										local 	N_clust_tot  	= trim("`N_clust_tot'")
										local 	N_clustex_tot	= "{[}`N_clust_tot']"
										local 	N_clust_tot  	= "[`N_clust_tot']"
									}


									*Load values from matrices into scalars
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

									*Remove leading zeros from excessive fomrat
									local 	N_tot 		=trim("`N_tot'")
									local 	mean_tot 	=trim("`mean_tot'")
									local 	var_tot 	=trim("`var_tot'")



									*Test that N is the same for each group across all vars
									if `ONEROW_USED' == 0 {

										local 	tableRowUp  `"`tableRowUp' _tab "`N_tot'" 			_tab "`mean_tot'"  "'
										local 	tableRowDo  `"`tableRowDo' _tab "`N_clust_tot'"  	_tab "[`var_tot']"  "'

										if `SHOW_NCLUSTER' == 0	{
											local texRow 	`"`texRow' " & `N_tot' & \begin{tabular}[t]{@{}c@{}} `mean_tot' \\ (`var_tot') \end{tabular}"  "'
										}
										if `SHOW_NCLUSTER' == 1	{
											local texRow 	`"`texRow' " & \begin{tabular}[t]{@{}c@{}}	`N_tot' \\ `N_clustex_tot' \end{tabular} & \begin{tabular}[t]{@{}c@{}} `mean_tot' \\ (`var_tot') \end{tabular}"  "'
										}
									}
									else {

										*Test if the first balance var
										if "`onerow_tot'" == "" {
											*Store the obs num
											local onerow_tot = `N_tot'
										}
										*If not, then check that the obs num is the same as before
										else if !(`onerow_tot' == `N_tot') {

											*option onerow not allowed if N is different
											noi display as error  "{phang}The number of observations for all groups are not the same for `balancevar' compare to at least one other balance variables. Run the command without the option onerow to see which group does not have the same number of observations with non-missing values across all balance variables. This happened in the total column which can be an indication of a serious bug. Please email this erro message to kbjarkefur@worldbank.org{p_end}"
											error 198
										}

										*If cluster is usedTest if the number of clusters is the same in each group accross all balance vars
										if "`vce_type'" == "cluster" {

											if "`oneclstrow_tot'" == "" {
												*Store the obs num
												local oneclstrow_tot = `N_clust_tot'
											}
											*If not, then check that the obs num is the same as before
											else if !(`oneclstrow_tot' == `N_clust_tot') {

												*option onerow not allowed if N is different
												noi display as error  "{phang}The number of clusters fora ll groups for `balancevar' is differenet compared to other balance variables. You can therefore not use the option onerow. Run the command without the option onerow to see which balance variable does not have the same number of clusters with non-missing values as the other balance variables.{p_end}"
												error 198
											}
										}


										*Either this is the first balance var or num obs are identical, so write columns
										local 	tableRowUp  `"`tableRowUp' _tab "`mean_tot'"  "'
										local 	tableRowDo  `"`tableRowDo' _tab "[`var_tot']"  "'

										local 	texRow	 	`"`texRow' " & \begin{tabular}[t]{@{}c@{}}	`mean_tot' \\ (`var_tot') \end{tabular}"  "'
									}
								}

								*Test that N is the same for each group across all vars
								if `ONEROW_USED' == 0 {

									local 	tableRowUp  `"`tableRowUp' _tab "`N_`groupNumber''" 		_tab "`di_mean_`groupNumber''"  "'
									local 	tableRowDo  `"`tableRowDo' _tab "`N_clust_`groupNumber''" 	_tab "[`di_var_`groupNumber'']"  "'

									if `SHOW_NCLUSTER' == 0	{
										local texRow 	`"`texRow' " & `N_`groupNumber'' & \begin{tabular}[t]{@{}c@{}} `di_mean_`groupNumber'' \\ (`di_var_`groupNumber'') \end{tabular}"  "'
									}
									if `SHOW_NCLUSTER' == 1	{
										local texRow 	`"`texRow' " & \begin{tabular}[t]{@{}c@{}} `N_`groupNumber'' \\ `N_clustex_`groupNumber'' \end{tabular} & \begin{tabular}[t]{@{}c@{}} `di_mean_`groupNumber'' \\ (`di_var_`groupNumber'') \end{tabular}"  "'
									}
								}
								else {

									*Test if the number of observations is the same in each group accross all balance vars
									if "`onerow_`groupNumber''" == "" {
										*Store the obs num
										local onerow_`groupNumber' = `N_`groupNumber''
									}
									*If not, then check that the obs num is the same as before
									else if !(`onerow_`groupNumber'' == `N_`groupNumber'') {

										*option onerow not allowed if N is different
										noi display as error  "{phang}The number of observations for `balancevar' is different compared to other balance variables within the same group. You can therefore not use the option onerow. Run the command without the option onerow to see which group does not have the same number of observations with non-missing values across all balance variables.{p_end}"
										error 198
									}


									*If cluster is usedTest if the number of clusters is the same in each group accross all balance vars
									if "`vce_type'" == "cluster" {

										if "`oneclstrow_`groupNumber''" == "" {
											*Store the obs num
											local oneclstrow_`groupNumber' = `N_clust_`groupNumber''
										}
										*If not, then check that the obs num is the same as before
										else if !(`oneclstrow_`groupNumber'' == `N_clust_`groupNumber'') {

											*option onerow not allowed if N is different
											noi display as error  "{phang}The number of clusters for `balancevar' is differenet compared to other balance variables within the same group. You can therefore not use the option onerow. Run the command without the option onerow to see which group does not have the same number of clusters with non-missing values across all balance variables.{p_end}"
											error 198
										}
									}

									*Either this is the first balance var or num obs are identical, so write columns
									local 	tableRowUp  	`"`tableRowUp' _tab "`di_mean_`groupNumber''"  "'
									local 	tableRowDo  	`"`tableRowDo' _tab "[`di_var_`groupNumber'']"  "'

									local 	texRow 		`"`texRow' " &  \begin{tabular}[t]{@{}c@{}} `di_mean_`groupNumber'' \\ (`di_var_`groupNumber'') \end{tabular}"  "'
								}





												*Test that N is the same for each group across all vars
												if `ONEROW_USED' == 0 {

													local 	tableRowUp  `"`tableRowUp' _tab "`N_tot'" 			_tab "`mean_tot'"  "'
													local 	tableRowDo  `"`tableRowDo' _tab "`N_clust_tot'"  	_tab "[`var_tot']"  "'

													if `SHOW_NCLUSTER' == 0	{
														local texRow 	`"`texRow' " & `N_tot' & \begin{tabular}[t]{@{}c@{}} `mean_tot' \\ (`var_tot') \end{tabular}"  "'
													}
													if `SHOW_NCLUSTER' == 1	{
														local texRow 	`"`texRow' " & \begin{tabular}[t]{@{}c@{}}	`N_tot' \\ `N_clustex_tot' \end{tabular} & \begin{tabular}[t]{@{}c@{}} `mean_tot' \\ (`var_tot') \end{tabular}"  "'
													}
												}
												else {

													*Test if the first balance var
													if "`onerow_tot'" == "" {
														*Store the obs num
														local onerow_tot = `N_tot'
													}
													*If not, then check that the obs num is the same as before
													else if !(`onerow_tot' == `N_tot') {

														*option onerow not allowed if N is different
														noi display as error  "{phang}The number of observations for all groups are not the same for `balancevar' compare to at least one other balance variables. Run the command without the option onerow to see which group does not have the same number of observations with non-missing values across all balance variables. This happened in the total column which can be an indication of a serious bug. Please email this erro message to kbjarkefur@worldbank.org{p_end}"
														error 198
													}

													*If cluster is usedTest if the number of clusters is the same in each group accross all balance vars
													if "`vce_type'" == "cluster" {

														if "`oneclstrow_tot'" == "" {
															*Store the obs num
															local oneclstrow_tot = `N_clust_tot'
														}
														*If not, then check that the obs num is the same as before
														else if !(`oneclstrow_tot' == `N_clust_tot') {

															*option onerow not allowed if N is different
															noi display as error  "{phang}The number of clusters fora ll groups for `balancevar' is differenet compared to other balance variables. You can therefore not use the option onerow. Run the command without the option onerow to see which balance variable does not have the same number of clusters with non-missing values as the other balance variables.{p_end}"
															error 198
														}
													}


													*Either this is the first balance var or num obs are identical, so write columns
													local 	tableRowUp  `"`tableRowUp' _tab "`mean_tot'"  "'
													local 	tableRowDo  `"`tableRowDo' _tab "[`var_tot']"  "'

													local 	texRow	 	`"`texRow' " & \begin{tabular}[t]{@{}c@{}}	`mean_tot' \\ (`var_tot') \end{tabular}"  "'
												}
											}

											***Write N row if onerow used

											if `ONEROW_USED' == 1 {

												*Variable column i.e. row title
												local tableRowN `""N""'
												local texRowN 	`"N"'

												local tableRowClstr `""Clusters""'
												local texRowClstr 	`"Clusters"'

												*Loop over all groups
												forvalues groupOrderNum = 1/`GRPVAR_NUM_GROUPS' {

													*Prepare the row based on the numbers from above
													local tableRowN `" `tableRowN' _tab "`onerow_`groupOrderNum''" "'
													local texRowN 	`" `texRowN' & `onerow_`groupOrderNum'' "'

													local tableRowClstr `" `tableRowClstr' _tab "`oneclstrow_`groupOrderNum''" "'
													local texRowClstr 	`" `texRowClstr' & `oneclstrow_`groupOrderNum'' "'

												}

												if `TOTAL_USED' {

													*Prepare the row based on the numbers from above
													local tableRowN `" `tableRowN' _tab "`onerow_tot'" "'
													local texRowN 	`" `texRowN'  & `onerow_tot' "'

													local tableRowClstr `" `tableRowClstr' _tab "`oneclstrow_tot'" "'
													local texRowClstr 	`" `texRowClstr' & `oneclstrow_tot' "'
												}

												*Write the N prepared above
												file open  `textname' using "`textfile'", text write append
												file write `textname' `tableRowN' _n
												if "`vce_type'" == "cluster" file write `textname' `tableRowClstr' _n
												file close `textname'

												file open  `texname' using "`texfile'", text write append
												file write `texname' " `texRowN' \rule{0pt}{`tex_line_space'} \\" _n
												if "`vce_type'" == "cluster" file write `texname' " `texRowClstr' \\" _n
												file close `texname'
											}

											if `ONEROW_USED' == 0 {
												local ftestMulticol = 1 + (2*`NUM_COL_GRP_TOT')
											}
											else {
												local ftestMulticol = 1 + `NUM_COL_GRP_TOT'
											}


											if `PFTEST_USED' {
												local Fstat_row 	`" "F-test of joint significance (p-value)"  "'
												local Fstat_texrow 	`" "\multicolumn{`ftestMulticol'}{@{} l}{F-test of joint significance (p-value)}"  "'
											}
											else {
												local Fstat_row 	`" "F-test of joint significance (F-stat)"  "'
												local Fstat_texrow 	`" "\multicolumn{`ftestMulticol'}{@{} l}{F-test of joint significance (F-stat)}"  "'
											}

											local Fobs_row  		`" "F-test, number of observations"  "'
											local Fobs_texrow 		`" "\multicolumn{`ftestMulticol'}{@{} l}{F-test, number of observations}"  "'

											*Create empty cells for all the group columns
											forvalues groupIteration = 1/`GRPVAR_NUM_GROUPS' {

												local Fstat_row   	`" `Fstat_row' _tab "" "'
												local Fobs_row    	`" `Fobs_row'  _tab "" "'

												*Add one more column if onerow is not used
												if `ONEROW_USED' == 0 {
													local Fstat_row   	`" `Fstat_row' _tab "" "'
													local Fobs_row    	`" `Fobs_row'  _tab "" "'

												}
											}

											*Create empty cells for total columns if total is used
											if `TOTAL_USED' {
												local Fstat_row   	`" `Fstat_row' _tab "" "'
												local Fobs_row   	`" `Fobs_row'  _tab "" "'


												*Add one more column if onerow is not used
												if `ONEROW_USED' == 0 {
													local Fstat_row   	`" `Fstat_row' _tab "" "'
													local Fobs_row    	`" `Fobs_row'  _tab "" "'

												}
											}

											*** Write notes to file according to specificiation

											if `NOTECOMBINE_USED' == 1 {

												*Combine all notes used to one line

												*Delete the locals corresponding to options not used
												if `FTEST_USED'			== 0	local ftest_note		""
												if `VCE_USED'			== 0	local error_est_note	""
												if `WEIGHT_USED'		== 0	local weight_note		""
												if `FIX_EFFECT_USED'	== 0	local fixed_note		""
												if `COVARIATES_USED'	== 0	local covar_note		""
												if `BALMISS_USED'		== 0	local balmiss_note 		""
												if `COVMISS_USED'		== 0	local covmiss_note 		""
												if `STARSNOADD_USED'	== 1	local stars_note		""


													*Write to file
													file open  `textname' using "`textfile'", text write append

														file write `textname' "`tblnote' `ttest_note'`ftest_note'`error_est_note'`fixed_note'`covar_note'`weight_note'`balmiss_note'`covmiss_note'`stars_note'" _n

													file close `textname'


											}
											else if `NONOTE_USED' == 1 {

												*Nonote used. Only add manually entered note

												file open  `textname' using "`textfile'", text write append

													if `NOTE_USED' 			file write `textname' "`tblnote'" _n

												file close `textname'

											}
											else {

												file open  `textname' using "`textfile'", text write append

													if  `NOTE_USED' 		file write `textname' "`tblnote'" 			_n
																			file write `textname' "`ttest_note'" 		_n
													if 	`FTEST_USED'		file write `textname' "`ftest_note'" 		_n
													if  `VCE_USED'			file write `textname' "`error_est_note'" 	_n
													if  `FIX_EFFECT_USED' 	file write `textname' "`fixed_note'" 		_n
													if  `COVARIATES_USED' 	file write `textname' "`covar_note'" 		_n
													if  `BALMISS_USED'		file write `textname' "`balmiss_note'"		_n
													if  `COVMISS_USED'		file write `textname' "`covmiss_note'"		_n
													if !`STARSNOADD_USED'	file write `textname' "`stars_note'" 		_n
												file close `textname'

											}
