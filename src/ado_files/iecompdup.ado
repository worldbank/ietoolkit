*! version 5.3 14NOV2017 Kristoffer Bjarkefur kbjarkefur@worldbank.org
	
	capture program drop iecompdup 
	program iecompdup , rclass
	
	qui {
		
		syntax varname ,  id(string) [DIDIfference KEEPDIFFerence KEEPOTHer(varlist) more2ok]
		
		version 11.0
		
		preserve
			
			/****************************
		
				Turn ID var to string so that the rest of the command works similarly
			
			****************************/			
			
			* Test if ID variable is numeric or string
			cap confirm numeric variable `varlist' 
			if !_rc {
				 
				* If numeric, test if all values in ID variable is integer
				cap assert mod(`varlist',1) == 0
				
				* This command does not allow numeric ID varaibels that are not integers
				if _rc {
					di as error "{phang}The ID variable is only allowed to be either string or only consist of integers. Integer in this context is not the same as the variable type int. Integer in this context means numeric values without decimals. Please consider using integers as your ID or convert your ID variable to a string.{p_end}"
					
				} 
				else {
					
					** Find the longest (for integers that is the same as largest) 
					*  number and get its legth.l
					sum `varlist'
					local length 	= strlen("`r(max)'")
					
					** Use that length when explicitly setting the format in 
					*  order to prevent information lost
					tostring `varlist', replace format(%`length'.0f)
				}
			} 
			
			* Testing that the ID variable is a string before constinueing the command
			cap confirm string variable `varlist' 
			if _rc {
				di as error "{phang}This error message is not due to incorrect specification from you. This message follows a failed check that the command is working properly. If you get this error, please send an email to kbjarkefur@worldbank.org including the follwoing message 'ID var was not succesfully turned in to a string without information loss in iecompdup.' and include whatever other data you do not mind sharing.{p_end}"
			}
			
			* Only keep duplicates with the ID specified
			keep if  `varlist' == "`id'"
		
			/****************************
		
				Test if input is correct
			
			****************************/
		
			
			if "`keepdifference'" == "" & "`keepother'" != "" {
			
				noi di as error "{phang}Not allowed to specify keepother() without specifying keepdifference{p_end}"
				noi di ""
				error 197
				exit
			}
			
			* Test the number of observations left and make sure that there are only two of them
			count
			if `r(N)' == 0 {
			
				noi di as error "{phang}ID incorrectly specified. No observations with (`varlist' == `id'){p_end}"
				noi di ""
				error 2000
				exit
			}
			else if `r(N)' == 1 {
			
				noi di as error "{phang}ID incorrectly specified. No duplicates with that ID. Only one observation where (`varlist' == `id'){p_end}"
				noi di ""
				error 2001
				exit
			}
			else if `r(N)' > 2 & "`more2ok'" == "" {
			
				noi di as error "{phang}The current version of ie_compdup is not able to compare more than 2 duplicates at the time. (How to output the results for groups larger than 2 is non-obvious and suggestions on how to do that are appreciated.) Either drop one of the duplicates before re-running the command or specify option more2ok and the comparison will be done between the first and the second row.{p_end}"
				noi di ""
				error 198
				exit
			}			
			else {
			
			
			/****************************
		
				Compare all variables
			
			****************************/				
			
			
				* If more than 2 observations, keep the first and second row only
				keep if _n <= 2
				
				*Initiate the locals
				local match
				local difference
				
				* Go over all variables and see if they are non missing for at least one of the variables
				foreach var of varlist _all {
				
					cap assert missing(`var')
					
					** If not missing for at lease one of the observations, test 
					*  if they are identical across the duplicates or not, and 
					*  store variable name in appropriate local
					if _rc {
						
						* Are the variables identical
						if `var'[1] == `var'[2] {
							local match `match' `var'
						}
						else {
							local difference `difference' `var'
						}
					} 
					* If missing for all duplicates, then drop that variable
					else {
						drop `var'
					}
				}
				
				* Remove the ID var from the match list, it is match by definition and therefore add no information
				local match : list match - varlist
				
			/****************************
		
				Output the result
			
			****************************/
			
			
				noi di ""
				** Display all variables that differ. This comes first in case 
				*  the number of variables are a lot, cause then it would push
				*  any other output to far up
				if "`didifference'" != "" {
				
					noi di "{phang}The following variables have different values across the duplicates:{p_end}"
					noi di "{pstd}`difference'{p_end}"
					noi di ""
				}
				
				*Display number output
				local numNonMissing = `:list sizeof match' + `:list sizeof difference'
				
				noi di "{phang}The duplicate observations with ID = `id' have non-missing values in `numNonMissing' variables. Out of those variables:{p_end}"
				noi di ""
				noi di "{phang2}`:list sizeof match' variable(s) are identical across the duplicates{p_end}"
				noi di "{phang2}`:list sizeof difference' variable(s) have different values across the duplicates{p_end}"
				
				
				
				return local matchvars 	`"`match'"'
				return local diffvars 	`"`difference'"'

				return scalar nummatch	= `:list sizeof match'
				return scalar numdiff 	= `:list sizeof difference'
				return scalar numnomiss	= `numNonMissing' 
		}	
		
		restore
		
		* If keep difference is applied only keep those variables here.
		if "`keepdifference'" != "" & "`difference'" != "" {
			
			order `varlist' `difference' `keepother'
			keep `varlist' `difference' `keepother'
			
			* Drop differently depending on numeric or string
			cap confirm numeric variable `varlist' 
			if !_rc {
				keep if  `varlist' == `id'
			}
			else {
				keep if  `varlist' == "`id'"
			}
		}
	}
	end
