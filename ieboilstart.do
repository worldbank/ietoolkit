	*! version 2.1 1Nov2016  Kristoffer Bjarkefur kbjarkefur@worldbank.org

	capture program drop ieboilstart2
	program ieboilstart2 , rclass
		
	qui {
	
		syntax using ,  Versionnumber(string) [noclear maxvar(numlist) matsize(numlist) QUIetdo CUSTom(string) ]
		
		*Potentional updates
		*set trace on
		*set scrollbufsize #
		
		version 11.0
		version `versionnumber'
		
		/*********************************
		
			Check file name
			
		*********************************/		
		
		*Parse out the file name
		tokenize `"`using'"'
		local 		textfile "`2'"
		
		*Find index for where the file type suffix start
		local dot_index 	= strpos("`textfile'",".")
		
		*Extract the file index
		local file_suffix 	= substr("`textfile'", `dot_index', .)
		
		*If no file format suffix is specified, use the default .xlsx
		if "`file_suffix'" == "" {
		
			local textfile `"`textfile'.do"'
		}
		
		*If a file format suffix is specified make sure that it is one of the two allowed.
		else if "`file_suffix'" != ".do" {
		
			noi display as error "{phang}The file format specified in using is other than .do. Only the .do format is allowed. If no format is specified .do is assumed.{p_end}"
			error 198
		}
		
		/*********************************
		
			Check version
			
		*********************************/			
		
		
		if "`maxvar'" != "" & "`clear'" != "" {
		
			di as error "{phang}It is not possible to set allowed maximum numbers of variables without clearing the data. noclear and maxvar() can therefore not be specified at the same time{p_end}"
			di ""
			error 198
			exit
		}
				
		local stata_versions "11.0 11.1 11.2 12.0 12.1 13.0 13.1 14.0 14.1"
		
		if `:list versionnumber in stata_versions' == 0 {

			di as error "{phang}Only recent major releases are allowed. One decimal must always be included. The releases currently allowed are:{break}`stata_versions'{p_end}"
			di ""
			error 198
			exit
		}
		
		
		/*********************************
		
			Check input for maxvar and matsize 
			if specified, other wise set 
			maximum value allowed.
		
		*********************************/			
		
		local stata_types ic se mp
		foreach maxlocal in maxvar matsize {
			
			if "`maxlocal'" == "maxvar" {
				if c(MP) == 1 | c(SE) == 1 {
					local max 32767
					local min 2048
				}
				else {
					local max 2047
					local min 2047	
				}
			}
			
			if "`maxlocal'" == "matsize" {
				if c(MP) == 1 | c(SE) == 1 {
					local max 11000
					local min 10
				}
				else {
					local max 800
					local min 10	
				}				
			}
			
			if c(MP) == 1 | c(SE) == 1 {
				local vusing "Stata SE and Stata MP"
			}
			else {
				local vusing "Stata IC"
			}		
			
			
			*Test if user set maxvar
			if "``maxlocal''" != "" {
			
				if ``maxlocal'' >= `min' & ``maxlocal'' <= `max' {

					local `maxlocal' ``maxlocal''
				}
				else {
					
					di as error "{phang}`maxlocal' must be between `min' and `max' (inclusive) if you are using `vusing'. You entered ``maxlocal''.{p_end}"
					if ``maxlocal'' < `min' {
						di ""
						error 910
					}
					else {
						di ""
						error 912
					}
					exit
				}
			}
			else {
				
				*User did not specify value, use max value allowed
				local `maxlocal' `max'
			}
		}

		/*********************************
		
			Prepare a local with all settings
			
		*********************************/			
		
		local return_string ""
		
		*Set verison number 
		local return_string `return_string' version `versionnumber' ;
		
		*Set basic memory limits
		if "`clear'" == "" {
			local return_string `return_string' clear all ;
			local return_string `return_string' if !(c(MP) == 1 | c(SE) == 1) { ;
			local return_string `return_string' set maxvar 	`maxvar' ;
			local return_string `return_string' } ;
		} 

		local return_string `return_string'  set matsize 	`matsize' ;
		
		*Settings that were introduced in Stata 12
		local return_string `return_string'  if c(stata_version) < 12 { ;
		 
		*Set advanced memory limits
		local return_string `return_string' set niceness	5 ;
				
		if "`clear'" == "" {
			*These settings cannot be modified with data in memory
			local return_string `return_string' set min_memory	0 ;
			local return_string `return_string' set max_memory	. ;
			
			if c(bit) == 64 { 
				local return_string `return_string' set segmentsize	32m ;
			}
			else {
				local return_string `return_string' set segmentsize	16m ;
			}
		}
		
		local return_string `return_string'  } ;
		local return_string `return_string'  else { ;
		local return_string `return_string'  set memory 200m ;
		local return_string `return_string'  } ;
		
		*Set default options
		local return_string `return_string' set more 		off ;
		local return_string `return_string' pause 			on 	;
		local return_string `return_string' set varabbrev 	off ;
		
		/*********************************
		
			Add custom lines of code
			
		*********************************/
		
		if "`custom'" != "" {
		
			*Add a comment that list where 
			local return_string `return_string' ** The lines of code below was added manually when iboilstart ;
			local return_string `return_string' *  was used to create  this do-file. If there are any issues ;
			local return_string `return_string' *  with the code below, please reconfigure ieboilstart and ;
			local return_string `return_string' *  generate a new do-file. ;

		
			*Create a local with the rowlabel input to be tokenized
			local custom_code_lines `custom'

			while "`custom_code_lines'" != "" {
				
				*Parsing name and label pair
				gettoken code_line custom_code_lines : custom_code_lines, parse("@")
				
				*Removing leadning or trailing spaces
				local code_line = trim("`code_line'")
				
				local return_string `return_string' `code_line';
				
				*Parse char is not removed by gettoken
				local custom_code_lines = subinstr("`custom_code_lines'" ,"@","",1)
			}
		}
		
		/*********************************
		
			Create the do-file
			
		*********************************/			
		
		*Create a local with the date
		local		date = subinstr(c(current_date)," ","",.)
		
		*Write the title rows defined above	
		capture file close settingsfile
		
		*Set up the file to be written
		file open  settingsfile using "`textfile'", text write replace
		
		if "`quietdo'" != "" file write settingsfile "quietly {" _n
		
		*Write the standard message in the opening file.
		file write settingsfile ///
																				_n ///
			`" 	/*************************************************"' 			_n ///
			`" 	This file is was prepared by command ieboilstart "' 			_n ///
			`" 	on `date'."'													_n ///
																				_n ///
			`" 	Run this file to set the recommended settings for "' 			_n ///
			`" 	this project to your instance of Stata"' 						_n ///
			`" 	*************************************************/"' 			_n ///	
																				_n ///
																				_n ///																		
			"	*See help file for ieboilstart for details on these settings"	_n ///	
			_n 

		** Write each setting prepared above to the do-file.
		while ("`return_string'" != "") { 
		
			*Tokenize the first setting
			gettoken setting return_string : return_string, parse(";")
			
			*Write it to file
			file write settingsfile "	`setting'" _n
			
			*Remove the parse character
			local return_string = subinstr("`return_string'",";","",1)
		}
		
		if "`quietdo'" != "" file write settingsfile "}" _n
		
		*Close file	
		file close settingsfile
			
			
		/*********************************
		
			Create return value and output message
			
		*********************************/			
		
		return local ieboil_dofile "`textfile'"
	
		noi di ""
		noi di "{phang}{err:DISCLAIMER:} Due to how settings works in Stata, it is impossible to create the exact same coding environment for all users regardless of what version of Stata each user is using. Hence, this command only attempts to harmonize the settings as much as possible across users collaborating on the same code, but no guarantee can be given that all commands will always behave identical unless the exact same version of Stata is used.{p_end}"
		noi di ""
		noi di "{phang}For a similar reason, ieboilstart only prepares a do-file with all recommended settings. This do-file {ul:MUST} be executed using the command {it:include} and not with {it:do}, otherwise not all settings will be set properly. See {help ieboilstart :help ieboilstart} for more details on how to correctly execute the do-file ieboilstart has prepared. If you do not run the do-file, ieboilstart does nothing to harmonize your settings.{p_end}"
		noi di ""
		noi di "{phang}Do-file with all settings saved to: `textfile'{p_end}"	
	}
	end

	
	
	
	
	
