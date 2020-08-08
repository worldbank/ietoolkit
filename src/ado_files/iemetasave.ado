

	capture program drop iemetasave
	program iemetasave

		syntax using/, [replace labdrop(string) short linesize(integer 75)]

	qui {

		compress

		tempname 	logname
		tempfile	logfile

		capture file close `texname'

		file open  		`logname' using "`logfile'", text write replace
		file write  	`logname' "Name, Var label, Type, Val label, # unique non-miss values, # missing, Mean, Std dev" _n
		file close 		`logname'


		ds, alpha
		local all_vars `r(varlist)'

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

		noi datasignature
		local datasig `r(datasignature)'

		noi count
		local N `r(N)'

		file open  `logname' using "`logfile'", text write append
		file write `logname' _n ///
				"***, ***, ***, ***, ***, ***, ***" _n ///
				"Data signature:, `datasig'" _n ///
				"Number of observations:, `N'"
		file close `logname'


		copy "`logfile'"  "`using'", `replace'


	}

	noi di as result `"{phang}Meta data file saved to: {browse "`using'":`using'} "'

	end
