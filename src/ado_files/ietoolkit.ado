*! version 7.3 01FEB2024 DIME Analytics dimeanalytics@worldbank.org

capture program drop ietoolkit
program ietoolkit, rclass

	* UPDATE THESE LOCALS FOR EACH NEW VERSION PUBLISHED
	local version "7.3"
	local versionDate "01FEB2024"

	syntax [anything]

	version 12

	/**********************
		Error messages
	**********************/

	* Make sure that no arguments were passed
	if "`anything'" != "" {
		noi di as error "This command does not take any arguments, write only {it:ietoolkit}"
		error 198
	}

	/**********************
		Output
	**********************/

	* Stata versions commands in this package allows when applicable
	return local  stata_target_versions "12 12.0 12.1 13 13.0 13.1 14 14.0 14.1 14.2 15 15.0 15.1 16.0 16.1 17.0 18.0"
	return local  dta_target_versions   "12 13 14"

	* Prepare returned locals
	return local  versiondate     "`versionDate'"
	return scalar version		      = `version'

	* Display output
	noi di ""
	noi di _col(4) "This version of ietoolkit installed is version " _col(54)"`version'"
	noi di _col(4) "This version of ietoolkit was released on " _col(54)"`versionDate'"

end
