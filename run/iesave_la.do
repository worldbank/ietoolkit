
	do "src/ado_files/ietoolkit.ado"
	do "src/ado_files/iesave.ado"

	sysuse auto, clear

// Errors ----------------------------------------------------------------------

	* File already exists
	cap iesave "run/output/iesave/auto.dta", id(make) version(17.0)
	assert _rc == 602

// Simple save -----------------------------------------------------------------

	* Save file
	iesave "run/output/iesave/auto.dta", id(make) version(17.0) replace
	
	* Check data chars
	use "run/output/iesave/auto.dta", clear
	char list _dta[]
	assert "`r(computerid)'" == "Computer ID withheld, see option userinfo in command iesave."
	assert "`r(username)'" == "Username withheld, see option userinfo in command iesave."

// Save + user info ------------------------------------------------------------

	* Save
	iesave "run/output/iesave/auto-userinfo.dta", id(make) version(17.0) userinfo replace
	
	* Check data chars
	use "run/output/iesave/auto-userinfo.dta", clear
	assert "`r(computerid)'" != "Computer ID withheld, see option userinfo in command iesave."
	assert "`r(username)'" 	 != "Username withheld, see option userinfo in command iesave."

// Report ----------------------------------------------------------------------

	* Simple report
	iesave "run/output/iesave/auto.dta", id(make) version(17.0) report replace
	iesave "run/output/iesave/auto.dta", id(make) version(17.0) report() replace
	
	* Report with user info
	iesave "run/output/iesave/auto-userinfo.dta", id(make) version(17.0) report userinfo replace
	
	* Report with user info and data order
	iesave "run/output/iesave/auto-noalpha.dta", id(make) version(17.0) report(noalpha) userinfo replace
	
	* Report with user info and path
	iesave "run/output/iesave/auto-path.dta", id(make) version(17.0) report(path("run/output/iesave/my-path.md")) userinfo replace
	
	* Report with csv path
	iesave "run/output/iesave/auto-path-csv.dta", id(make) version(17.0) report(path("run/output/iesave/my-path.csv")) userinfo replace
	
	* Report with csv without path
	iesave "run/output/iesave/auto-csv.dta", id(make) version(17.0) report(csv) replace

************************************************************************ The end.