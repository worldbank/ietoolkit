*! version 5.4 15DEC2017  DIME Analytics lcardosodeandrad@worldbank.org
		
capture program drop ietoolkit, rclass
program ietoolkit, rclass
	
	* UPDATE THESE LOCALS FOR EACH NEW VERSION PUBLISHED
	local version "5.4"
	local versionDate "15DEC2017"
	
	
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
	return local diffvars 	`"`difference'"'
	return scalar nummatch	= `:list sizeof match'
	
	* Display output
	noi di ""
	noi di _col(4) "This version of ietoolkit installed is version " _col(54)"`version'"
	noi di _col(4) "This version of ietoolkit was released on " _col(54)"`versionDate'"
	
end
