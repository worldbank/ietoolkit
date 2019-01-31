*! version 6.2 31JAN2019 DIME Analytics dimeanalytics@worldbank.org

	capture program drop ieboilstart
	program ieboilstart , rclass

	qui {

		syntax ,  Versionnumber(string) [noclear maxvar(numlist) matsize(numlist) Quietly veryquietly Custom(string) setmem(string) nopermanently ]

		version 11.0

		/*********************************

			Check user specifed version
			and apply it is valid

		*********************************/

		local stata_versions "11 11.0 11.1 11.2 12 12.0 12.1 13 13.0 13.1 14 14.0 14.1 14.2 15 15.0 15.1"

		if `:list versionnumber in stata_versions' == 0 {

			di as error "{phang}Only recent major releases are allowed. The releases currently allowed are:{break}`stata_versions'{p_end}"
			di ""
			error 198
			exit
		}

		*Return the value
		return local version "version `versionnumber'"

		*Set the version specfied in the command
		version `versionnumber'



		/*********************************

			Check settings related to older
			versions and Stata IC

		*********************************/

		*Test that maxvar is not set in combination when using Stata IC
		if 	!(c(MP) == 1 | c(SE) == 1) & "`maxvar'" != "" {

			di as error "{phang}In Stata IC the maximum number of variables allowed is fixed at 2,047 and maxvar() is therefore not allowed.{p_end}"
			error 198
		}


		if 	"`setmem'" != ""	{

			if `versionnumber' >= 12  {

				di as error "{phang}Option setmem() is only allowed when setting the version number to 11. Setmem() is only applicable in Stata 11 or earlier, but those versions wont be able to run this file as the version number is set to 12 or higher.{p_end}"
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

				*Stata 15 MP has a higher maximum number of maxvar
				if c(stata_version) >= 15 & c(MP) == 1 {
					local max 120000
				}
				else {
					*For Stata 15 SE and MP and SE for all lower versions
					local max 32767
				}
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

					di as error "{phang}`maxlocal' must be between `min' and `max' (inclusive) if you are using Stata SE or Stata MP. You entered ``maxlocal''.{p_end}"
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

			Check other input

		*********************************/

		**Default is that these values are set as default values so that
		* these are the default values each time Stata starts.
		if "`nopermanently'" == "" {

			local permanently 		" , permanently"
			local permanently_col 	"{col 28}, permanently"

		}
		else {

			local permanently ""
		}

		/*********************************

			Set the settings

		*********************************/

		local setDispLocal "{col 5}{ul:Settings set by this command:}"

		*Set basic memory limits
		if "`clear'" == "" {

			*Setting
			clear all
			local setDispLocal "`setDispLocal'{break}{col 5}clear all"

			**Setting maxvar not allowed in Stata IC.
			if 	(c(MP) == 1 | c(SE) == 1) {

				*Setting
				set maxvar `maxvar' `permanently'
				local setDispLocal "`setDispLocal'{break}{col 5}set maxvar {col 22}`maxvar'`permanently_col'"
			}
		}

		*Setting
		set matsize `matsize' `permanently'
		local setDispLocal "`setDispLocal'{break}{col 5}set matsize {col 22}`matsize'`permanently_col'"


		****************
		*Memory	settings

		*For compatibility with Stata 11 the do file includes and if/else
		*condition testing version number. The memoroy settings introduced
		*in Stata 12 will be applied to Stata version more recent than
		*Stata 11, and set memory will be applied to Stata 11.
		if c(stata_version) >= 12 {

			*Setting
			set niceness 5  `permanently'
			local setDispLocal "`setDispLocal'{break}{col 5}set niceness{col 22}5`permanently_col'"

			*These settings cannot be modified with data in memory
			if "`clear'" == "" {

				*Settings
				set min_memory 0  `permanently'
				set max_memory .  `permanently'
				local setDispLocal "`setDispLocal'{break}{col 5}set min_memory {col 22}0`permanently_col'{break}{col 5}set max_memory {col 22}.`permanently_col'"

				*Set segment size to the largest value allowed by the operative system
				if c(bit) == 64 {
					*Setting
					set segmentsize	32m  `permanently'
					local setDispLocal "`setDispLocal'{break}{col 5}set segmentsize	{col 22}32m`permanently_col'"
				}
				else {
					*Setting
					set segmentsize	16m  `permanently'
					local setDispLocal "`setDispLocal'{break}{col 5}set segmentsize	{col 22}16m`permanently_col'"
				}
			}
		}
		else {

			*If this dofile is generated in Stata 11 then only the old
			*way of setting memory is included. This will be ignored by
			*more recent versios of Stata

			*Setting
			set memory `setmem'
			local setDispLocal "`setDispLocal'{break}{col 5}set memory {col 22}`setmem'"

		}

		*********************
		*Set default settings
		set more 		off `permanently'
		pause 			on
		set varabbrev 	off
		local setDispLocal "`setDispLocal'{break}{col 5}set more {col 22}off {col 28}, perm"
		local setDispLocal "`setDispLocal'{break}{col 5}pause {col 22}on"
		local setDispLocal "`setDispLocal'{break}{col 5}set varabbrev {col 22}off"

		/*********************************

			Add custom lines of code

		*********************************/

		if `"`custom'"' != "" {

			local setDispLocal `"`setDispLocal'{break} {break}{col 5}{ul:User specified settings:}"'

			*Create a local with the rowlabel input to be tokenized
			local custom_code_lines `custom'

			while `"`custom_code_lines'"' != "" {

				*Parsing name and label pair
				gettoken code_line custom_code_lines : custom_code_lines, parse("@")

				*Removing leadning or trailing spaces
				local code_line = trim(`"`code_line'"')

				*Set custom setting
				local setDispLocal `"`setDispLocal'{break}{col 5}`code_line'"'
				`code_line'

				*Parse char is not removed by gettoken
				local custom_code_lines = subinstr(`"`custom_code_lines'"' ,"@","",1)
			}
		}


		/*********************************

			Create return value and output message

		*********************************/

		if "`quietly'" == "" & "`veryquietly'" == "" {

			noi di ""
			noi di "{phang}{err:DISCLAIMER:} Due to how settings work in Stata, this command can only attempt to harmonize settings as much as possible across users, but no guarantee can be given that all commands will always behave identically unless the exact same version and type of Stata is used, with the same releases of user-contributed commands installed.{p_end}"
			noi di ""
			noi di `"`setDispLocal'"'
		}

		if  "`veryquietly'" == "" {

			noi di ""
			noi di "{phang}{err:IMPORTANT:} The most important setting of this command – the version – cannot be set inside the command due to technical reasons. The setting has been prepared by this command, and you only need to write \`r(version)' after this command (include the apostrophes).{p_end}"

		}

	}
	end
