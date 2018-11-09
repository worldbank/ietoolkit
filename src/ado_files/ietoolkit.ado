*! version 6.1 09112018 DIME Analytics dimeanalytics@worldbank.org

capture program drop ietoolkit
program ietoolkit, rclass

	* UPDATE THESE LOCALS FOR EACH NEW VERSION PUBLISHED
	local version "6.1"
	local versionDate "11NOV2018"


	syntax [anything]

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

	* Prepare returned locals
	return local 	versiondate "`versionDate'"
	return scalar 	version		= `version'

	* Display output
	noi di ""
	noi di _col(4) "This version of ietoolkit installed is version " _col(54)"`version'"
	noi di _col(4) "This version of ietoolkit was released on " _col(54)"`versionDate'"

end
