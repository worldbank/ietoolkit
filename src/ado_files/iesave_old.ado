
syntax using/,  IDvars(varlist) SAVEVersion(string) [varreport(string) reportreplace replace userinfo]


	/*********************************
		Write variable report
	*********************************/

	  *Write csv with variable report that can be version controlled
	  * in git to track when variables change
	  if ("`varreport'" != "") write_var_report , ///
	  		file(`varreport') ///
	  		datasig(`datasig') ///
	  		idvars(`idvars') 	///
	  		n(`N')   	    ///
	  		`reportreplace' `keepvarorder'

	/*********************************
	  Display in table
	*********************************/
	  noi di ""

	  * List the locals with values in the table
	  local output_locals "idvars user_table computer_table timesave version_char datasig"

	  *Find the length of longest value
	  local maxlen 0
		foreach output_local of local output_locals {
	    local maxlen = max(`maxlen',strlen("``output_local''"))
		}

		*Lenght of horizontal lines in header, footer and dividers
		local name_line 18
		local output_line = `maxlen' + 2

		*Column position of first and last cell wall
		local first_col 4
		local last_col = `first_col' + `maxlen' + 22

		*Shorthand for most row beginnings and row ends
		local rowbeg "{col `first_col'}{c |}"
		local rowend "{col `last_col'}{c |}"

		*Shorthand for divider
		local divider "{col `first_col'}{c LT}{hline `name_line'}{c +}{hline `output_line'}{col `last_col'}{c RT}"

		*Display header
		noi di as text "{col `first_col'}{c TLC}{hline `name_line'}{c TT}{hline `output_line'}{c TRC}"
		noi di as text "`rowbeg' {bf:Name}             {c |} {bf:Value} `rowend'"
		noi di as text "`divider'"

	  *Display all table rows
	  noi di as text "`rowbeg' ID Var(s)        {c |} `idvars' `rowend'"
	  noi di as text "`divider'"
	  noi di as text "`rowbeg' Number of obs    {c |} `N' `rowend'"
	  noi di as text "`divider'"
	  noi di as text "`rowbeg' Number of vars   {c |} `numVars' `rowend'"
	  noi di as text "`divider'"
	  noi di as text "`rowbeg' Username         {c |} `user_table' `rowend'"
	  noi di as text "`divider'"
	  noi di as text "`rowbeg' Computer ID      {c |} `computer_table' `rowend'"
	  noi di as text "`divider'"
	  noi di as text "`rowbeg' Time and Date    {c |} `timesave' `rowend'"
	  noi di as text "`divider'"
	  noi di as text "`rowbeg' Version Settings {c |} `version_char' `rowend'"
		noi di as text "`divider'"
		noi di as text "`rowbeg' Data Signature   {c |} `datasig' `rowend'"

		*Display footer
		noi di as text "{col `first_col'}{c BLC}{hline `name_line'}{c BT}{hline `output_line'}{c BRC}"


	/*********************************
		returned values
	*********************************/

		*Return the putputs to retirn locals
		return local idvars     "`idvars'"
		return local username   "`user'"
		return local computerid "`computer'"
		return local versions   "`version_char'"
		return local datasig    "`datasig'"
		return local N          "`N'"
		return local numvars    "`numVars'"

}
end


	capture program drop write_var_report
	program write_var_report

	qui {

		syntax , file(string) datasig(string) idvars(string) n(string) [reportreplace keepvarorder]

	  *Convert reportreplace to replace in this context
	  if ("`reportreplace'" == "") local replace ""
	  else local replace "replace"

	  *Set up tempfile locals
	  tempname 	logname
	  tempfile	logfile
	  capture file close `texname'

	  *get order or vars for report.
	  *alpha is default as it keeps the order more stable
	  if ("`keepvarorder'" == "") ds, alpha
	  else ds
	  local all_vars `r(varlist)'

	  *Open the file and write headear
	  file open  		`logname' using "`logfile'", text write replace
	  file write  	`logname' "Name, Var label, Type, Val label, # unique non-miss values, # missing, Mean, Std dev" _n
	  file close 		`logname'

	  *Loop over all variables and write one row per variable
	  foreach var of local all_vars {

	  	* Variable name
	  	local varrow `""`var'""'

	  	*Variable label
	  	local varlabel:  variable label  `var'
	  	local varrow `"`varrow',"`varlabel'""'

	  	*Variable type
	  	local vartype: type `var'
	  	local varrow `"`varrow',"`vartype'""'

	  	*Value label
	  	local vallabel:  value label `var'
	  	local varrow `"`varrow',"`vallabel'""'

	  	*Count number of unique values
	  	noi tab `var'
	  	local varrow `"`varrow',"`r(r)'""'

	  	*Count missing
	  	count if missing(`var')
	  	local varrow `"`varrow',"`r(N)'""'

	  	* Basic sum stats
	  	sum `var'
	  	local varrow `"`varrow',"`r(mean)'","`r(sd)'""'

	  	*Temp test output
	  	noi di `"{pstd}`varrow'{p_end}"'

	  	*Write variable row to file
	  	file open  `logname' using "`logfile'", text write append
	  	file write `logname' `"`varrow'"' _n
	  	file close `logname'
	  }


	  *Write the end of the report
	  file open  `logname' using "`logfile'", text write append
	  file write `logname' _n ///
	  		"***, ***, ***, ***, ***, ***, ***" _n ///
	  		"Number of observations:, `n'" _n ///
	  		"ID variable(s):, `idvars'" _n ///
	  		"Data signature:, `datasig'"
	  file close `logname'

	  *Copy temp file to file location
	  copy "`logfile'"  "`file'", `replace'

	}

end
