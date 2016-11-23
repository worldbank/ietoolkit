	*! version 2.1 1Nov2016  Kristoffer Bjarkefur kbjarkefur@worldbank.org

	capture program drop ieboilstart2
	program ieboilstart2 , rclass
	
	noi di "Syntax works!"
	
	qui {
		
		*This is used to indicate in the do file how the command was specified
		local full_specification `0'
		
		syntax using ,  Versionnumber(string) [noclear maxvar(numlist) matsize(numlist) QUIetdo CUSTom(string) setmem(string) ]
		
		version 11.0
		
		/*********************************
		
			Check user specifed version 
			and apply it is valid
			
		*********************************/			
		
		local stata_versions "11.0 11.1 11.2 12.0 12.1 13.0 13.1 14.0 14.1"
		
		if `:list versionnumber in stata_versions' == 0 {

			di as error "{phang}Only recent major releases are allowed. One decimal must always be included. The releases currently allowed are:{break}`stata_versions'{p_end}"
			di ""
			error 198
			exit
		}		
		
		*Set the version specfied in the command
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
		
			Check settings related to older
			versions and Stata 11
			
		*********************************/		
		
		*Test that maxvar is not set in combination when using Stata IC
		if 	!(c(MP) == 1 | c(SE) == 1) & "`maxvar'" != "" {
		
			di as error "{phang}In Stata IC the maximum number of variables allowed is fixed at 2,047 and maxvar() is therefore not allowed.{p_end}"
			error 198
		}
		

		if 	"`setmem'" != ""	{
		
			if `versionnumber' >= 12  {
			
				di as error "{phang}Option setmem() is only allowed when setting the version number to 11. Setmem() is only applicable in Stata 11 or eralier, but those versions wont be able to run this file as the version number is set to 12 or higher.{p_end}"
				error 198
			}
			
			
			*Split the memory setting string into value and byte unit 
			local mem_strlen 	= strlen("`setmem'") -1
			local mem_number	= substr("`setmem'",  1 , `mem_strlen')
			local mem_bytetype	= substr("`setmem'", -1 , 1)
			
			
			*Test that the number part is a number and a integer
			cap confirm integer number `mem_number'
			if _rc {
			
				di as error "{phang}The value in setmem(`setmem') must be a number (followed by either b, k, m or g). See {help memory} for details.{p_end}"
				error _rc
			}
			
			*Test that the byte type is not anything else than b, k, m or g
			if !`=inlist(lower("`mem_bytetype'"), "b", "k", "m", "g")' {
	
				di as error "{phang}The last character in setmem(`setmem') must be either b, k, m or g. See {help memory} for details.{p_end}""
				error 7
	
			}
		}	
		else { 
			
			*Default value is 50M. This is probably too little, but 
			*it will safely work. And users can manually increase this
			local setmem "50M"
		
		}
		
		
		/*********************************
		
			Check input for maxvar and matsize 
			if specified, other wise set 
			maximum value allowed.
		
		*********************************/			
		
		*Setting maxvar requires a cleared memory. Therefore
		*maxvar() and noclear cannot be used at the same time.
		if "`maxvar'" != "" & "`clear'" != "" {
		
			di as error "{phang}It is not possible to set allowed maximum numbers of variables without clearing the data. noclear and maxvar() can therefore not be specified at the same time{p_end}"
			di ""
			error 198
			exit
		}		
		
		foreach maxlocal in maxvar matsize {
			
	
			*Set locals with the max and min values fox maxvar and matsize 
			if "`maxlocal'" == "maxvar" {
				local max 32767
				local min 2048
			}
			if "`maxlocal'" == "matsize" {
				local max 11000
				local min 10
			}	
		

			*Test if user set a value for this value
			if "``maxlocal''" != "" {
				
				*If user specified a value, test that it is between the min and the max
				if !(``maxlocal'' >= `min' & ``maxlocal'' <= `max') {

					di as error "{phang}`maxlocal' must be between `min' and `max' (inclusive) if you are using Stata SE and Stata MP. You entered ``maxlocal''.{p_end}"
					di ""
					*Throw appropriate error if below or above error
					if ``maxlocal'' < `min' error 910
					if ``maxlocal'' > `max' error 912
					exit
				}
			}
			
			else {
				*User did not specify value, use ieboilstart's defaults:
				
				if "`maxlocal'" == "maxvar" {
					*Set maxvar to max value allowed as this is often an issue when working with large survey data 
					local `maxlocal' `max'
				}
				if "`maxlocal'" == "matsize" {
					*Set to the default as the maximum is rarely requered.
					local `maxlocal' 400
				}						
			}
		}
		

		/*********************************
		
			Prepare a the dofile strings with 
			all code (settings and comments) 
			that is going in to the dofile
			
		*********************************/			
		
		*******************************
		*Messages in dofiles generated 
		*in Stata 11 and in Stata IC

		*Stata IC
		local dofile_string1 ""
		if 	!(c(MP) == 1 | c(SE) == 1) {
			local dofile_string1 `dofile_string1' **This dofile does not inlcude the setting maxvar as it ;
			local dofile_string1 `dofile_string1' * was generated in Stata IC or Small. If the dofile would ;
			local dofile_string1 `dofile_string1' * be generated in Stata MP or SE, then then maxvar is ;
			local dofile_string1 `dofile_string1' * included but for IC and Small it is ignored. ;
			local dofile_string1 `dofile_string1' * ;
		}
	
	
		*Stata 11
		local dofile_string2 ""
		if 	c(stata_version) < 12 {
			local dofile_string2 `dofile_string2' **This dofile does not inlcude modern memory settings as it ;
			local dofile_string2 `dofile_string2' * was generated in Stata 11. It only includes set memory that ; 
			local dofile_string2 `dofile_string2' * is ignored by Stata >=12. Dofiles generated in Stata >=12 ;
			local dofile_string2 `dofile_string2' * includes both. ;
			local dofile_string2 `dofile_string2' * ;
		}
		
		
		*******************
		*Maxvar and matsize
		
		local dofile_string3 ""
		
		*Set verison number 
		local dofile_string3 `dofile_string3' version `versionnumber' ;
		
		*Set basic memory limits
		if "`clear'" == "" {
			local dofile_string3 `dofile_string3' clear all ;
			
			**Setting maxvar not allowed in Stata IC. If Stata IC creates the file these lines
			* are excluded. The "if (c(MP) == 1 | c(SE) == 1) {" is still included in the dofile
			* so that a dofile generated by MP or SE still works on IC. In such a case you are 
			* likely to run in to the varaible count limit in Stata IC, but that error message
			* is more informative then when trying to set maxvar in Stata IC.
			if 	(c(MP) == 1 | c(SE) == 1) {
				local dofile_string3 `dofile_string3' if (c(MP) == 1 | c(SE) == 1) { ;
				local dofile_string3 `dofile_string3' set maxvar 	`maxvar' ;
				local dofile_string3 `dofile_string3' } ;
			}
		} 

		local dofile_string3 `dofile_string3'  set matsize 	`matsize' ;
		
		
		**************** 
		*Memory	settings 
		
		local dofile_string4 ""
		
		*New memory settings was introduced in Stata 12.
		if c(stata_version) >= 12 {
		
			*For compatibility with Stata 11 the do file includes and if/else 
			*condition testing version number. The memoroy settings introduced 
			*in Stata 12 will be applied to Stata version more recent than 
			*Stata 11, and set memory will be applied to Stata 11.
			local dofile_string4 `dofile_string4'  if c(stata_version) >= 12 { ;
			 
			*Set advanced memory limits
			local dofile_string4 `dofile_string4' set niceness	5 ;
					
			if "`clear'" == "" {
				*These settings cannot be modified with data in memory
				local dofile_string4 `dofile_string4' set min_memory	0 ;
				local dofile_string4 `dofile_string4' set max_memory	. ;
				
				*Set segment size to the largest value allowed by the operative system
				if c(bit) == 64 { 
					local dofile_string4 `dofile_string4' set segmentsize	32m ;
				}
				else {
					local dofile_string4 `dofile_string4' set segmentsize	16m ;
				}
			}
			local dofile_string4 `dofile_string4'  } ;
			
			*Inlcude an else statement that allows compatibility with Stata 11. This 
			*might cause errors when running the rest of the code for this project, 
			*but by using setmem() it might be possible to solve those errors.
			local dofile_string4 `dofile_string4'  else { ;
			local dofile_string4 `dofile_string4'  set memory `setmem' ;
			local dofile_string4 `dofile_string4'  } ;
		
		}
		else {
			
			*If this dofile is generated in Stata 11 then only the old 
			*way of setting memory is included. This will be ignored by 
			*more recent versios of Stata
			local dofile_string4 `dofile_string4'  set memory `setmem' ;
		
		}
		
		*********************
		*Set default settings			
		local dofile_string4 `dofile_string4' set more 			off ;
		local dofile_string4 `dofile_string4' pause 			on 	;
		local dofile_string4 `dofile_string4' set varabbrev 	off ;

		
		/*********************************
		
			Add custom lines of code
			
		*********************************/
		
		if "`custom'" != "" {
		
			local dofile_string5 ""	
		
			*Add a comment that list where 
			local dofile_string5 `dofile_string5' **The code below was added manually by the user to iboilstart. If ;
			local dofile_string5 `dofile_string5' * there are any issues please reconfigure ieboilstart. There is a ;
			local dofile_string5 `dofile_string5' * limit of less than 244 characters in the code in Stata 11, and ;
			local dofile_string5 `dofile_string5' * 512 in later versions.;
			
			*di "`dofile_string5'"
			*di `=strlen("`dofile_string5'")'
		
			*Create a local with the rowlabel input to be tokenized
			local custom_code_lines `custom'
			local dofile_string6 ""	
			
			while "`custom_code_lines'" != "" {
				
				*Parsing name and label pair
				gettoken code_line custom_code_lines : custom_code_lines, parse("@")
				
				*Removing leadning or trailing spaces
				local code_line = trim("`code_line'")
				
				local dofile_string6 `dofile_string6' `code_line';
				
				*Parse char is not removed by gettoken
				local custom_code_lines = subinstr("`custom_code_lines'" ,"@","",1)
			}
		}
		
		/*********************************
		
			Create the dofile
			
		*********************************/			
		
		*Create a local with the date
		local		date = subinstr(c(current_date)," ","",.)
		
		*Write the title rows defined above	
		capture file close settingsfile
		
		*Set up the file to be written
		file open  settingsfile using "`textfile'", text write replace
		
		*Suppress output from dofile if option qietdo is applied
		if "`quietdo'" != "" file write settingsfile "quietly {" _n
		
		*Write the standard message in the opening file.
		file write settingsfile ///
																					_n ///
			`" 	/*************************************************"' 				_n ///
			`" 	This file is was prepared by command ieboilstart "' 				_n ///
			`" 	on `date' by username: `c(username)'. "'							_n ///
																					_n ///
			`" 	Run this file to set the recommended settings for "' 				_n ///
			`" 	this project to your instance of Stata"' 							_n ///
			`" 	*************************************************/"' 				_n ///	
																					_n ///			
			`"	*This dofile was generated by specifying ieboilstart like this:"' 	_n ///
			`"	*ieboilstart `full_specification' "'								_n ///
																					_n ///																						
			"	*See help file for ieboilstart for details on these settings"		_n ///	
			_n 
		
		
		** Repeat through the possible 6 strings from above. The reason multiple strings 
		*  are created is that in older versions of Stata, the maximum string length 
		*  used in a string operation, like gettoken or subinstr(), is limited to 214.
		forvalues strNum = 1/6 {
			
			** Write each setting prepared above to the dofile.
			while ("`dofile_string`strNum''" != "") { 
				
				*noi di `=strlen("`dofile_string`strNum''")'
				*noi di "`dofile_string`strNum''"
				
				local tempstring `dofile_string`strNum''
				
				*Tokenize the first setting
				gettoken setting tempstring : tempstring, parse(";")
				
				*Write it to file
				file write settingsfile "	`setting'" _n
				
				*Remove the parse character
				local dofile_string`strNum' = subinstr("`tempstring'",";","",1)
			}
		}
		
		*Close quiet bracket if option quietdo is used.
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
		noi di "{phang}For a similar reason, ieboilstart only prepares a dofile with all recommended settings. This dofile {ul:MUST} be executed using the command {it:include} and not with {it:do}, otherwise not all settings will be set properly. See {help ieboilstart :help ieboilstart} for more details on how to correctly execute the dofile ieboilstart has prepared. If you do not run the dofile, ieboilstart does nothing to harmonize your settings.{p_end}"
		noi di ""
		noi di "{phang}dofile with all settings saved to: `textfile'{p_end}"	
	}
	end

	
	
	
	
	
