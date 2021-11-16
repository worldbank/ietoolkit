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



*******
* Throw missing values in f-test warning
if `fmiss_error' == 1 {

  *Remove the first comman before the first variable
  local fmiss_error_list = subinstr("`fmiss_error_list'" ,",","",1)

  noi di as error "{phang}F-test is possible but perhaps not advisable. Some observations have missing values in some of the balance variables and therfore dropped from the f-stat regression. This happened in the f-tests for the following group(s): [`fmiss_error_list']. Solve this by manually restricting the balance table using if or in, or disable the f-test, or by using option {help iebaltab:balmiss()}. Suppress this error message by using option {help iebaltab:fmissok}"
  error 416
}
