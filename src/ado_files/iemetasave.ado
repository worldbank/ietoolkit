	
	
	capture program drop iemetasave
	program iemetasave

		syntax using/, [replace labdrop(string) short]
	
	qui {
		preserve
			
			if "`labdrop'" != "" lab drop `labdrop'
			
			if "`short'" != "" {
				qui {
					log using "`using'", text `replace'
					noisily describe
					log close
				}
			}
			else {
				qui {
					log using "`using'", text `replace'
					noisily codebook
					log close
				}
			}
		
		restore
	}	
	
	noi di as result `"{phang}Meta data file saved to: {browse "`using'":`using'} "'
	
	end
