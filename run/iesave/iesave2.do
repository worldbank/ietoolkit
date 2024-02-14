
	do "src/ado_files/ietoolkit.ado"
	do "src/ado_files/iesave.ado"

  qui do "run/run_utils.do"

  local out "run/iesave/outputs/iesave2"

  *Delete all content in the output folder
  ie_recurse_rmdir, folder("`out'") okifnotexist
  ie_recurse_mkdir, folder("`out'")

	sysuse auto, clear

  * Creaeting a file to be able to trigger the first error
  save "`out'/auto.dta"

// Errors ----------------------------------------------------------------------

	* File already exists
	cap iesave "`out'/auto.dta", id(make) version(13.1)
	assert _rc == 602

// Simple save ------------------------------------------------------

	* Save file
	iesave "`out'/auto.dta", id(make) version(13.1) replace

	* Check data chars
	use "`out'/auto.dta", clear
	char list _dta[]
	assert "`r(computerid)'" == "Computer ID withheld, see option userinfo in command iesave."
	assert "`r(username)'" == "Username withheld, see option userinfo in command iesave."

// Save + user info ------------------------------------------------------------

	* Save
	iesave "`out'/auto-userinfo.dta", id(make) version(13.1) userinfo replace

	* Check data chars
	use "`out'/auto-userinfo.dta", clear
	assert "`r(computerid)'" != "Computer ID withheld, see option userinfo in command iesave."
	assert "`r(username)'" 	 != "Username withheld, see option userinfo in command iesave."

// Report ----------------------------------------------------------------------

	* Simple report
	iesave "`out'/auto.dta", id(make) version(13.1) report replace
	iesave "`out'/auto.dta", id(make) version(13.1) report() replace

	* Report with user info
	iesave "`out'/auto-userinfo.dta", id(make) version(13.1) report userinfo replace

	* Report with user info and data order
	iesave "`out'/auto-noalpha.dta", id(make) version(13.1) report(noalpha) userinfo replace

	* Report with user info and path
	iesave "`out'/auto-path.dta", id(make) version(13.1) report(path("`out'/my-path.md")) userinfo replace

	* Report with csv path
	iesave "`out'/auto-path-csv.dta", id(make) version(13.1) report(path("`out'/my-path.csv")) userinfo replace

	* Report with csv without path
	iesave "`out'/auto-csv.dta", id(make) version(13.1) report(csv) replace

// Two ID vars -----------------------------------------------------------------

	iesave "`out'/auto-2id.dta", id(make foreign) version(13.1) report replace

	replace foreign = . in 1

	cap	iesave "`out'/auto-2id.dta", id(make foreign) version(13.1) report replace
	assert _rc == 459


************************************************************************ The end.
