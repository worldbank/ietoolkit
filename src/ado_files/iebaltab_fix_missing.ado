
			* This option can be used to get a uniform N across all variables even if
			* the variable is missing for some observations. When specifying this
			* option, a dummy is created indicating all HHs that have a missing value
			* for this variable. Missing values for the varaible is then set to zero,
			* and in the areg used for testing the differences in means, the dummy is
			* included as a control. Note that this will slightly distort the mean as well.

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
      			if (`BALMISS_USED' | `BALMISSREG_USED')


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
										noi display as error  "{phang}Not enough observations. There are less than `minobs' observations with a nonmissing value in `varlist'. Missing values can therefore not be set to the mean. Click {stata tab `varlist', missing} for detailed information.{p_end}"
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


						*Testing input in these for options. See function at the end of this command
						if `BALMISS_USED' == 1 		iereplacestringtest "balmiss" 		"`balmiss'"
						if `BALMISSREG_USED' == 1 	iereplacestringtest "balmissreg" 	"`balmissreg'"
						if `COVMISS_USED' == 1 		iereplacestringtest "covmiss" 		"`covmiss'"
						if `COVMISSREG_USED' == 1 	iereplacestringtest "covmissreg" 	"`covmissreg'"
