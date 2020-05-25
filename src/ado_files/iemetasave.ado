	
	
	capture program drop iemetasave
	program iemetasave

		syntax using/, [replace labdrop(string) short linesize(integer 75)]
		
	qui {
		preserve

			local old_linesize `c(linesize)'
						
			if missing("`linesize'") {
				local linesize 75
			}
			set linesize `linesize'
			
			if "`labdrop'" != "" lab drop `labdrop'
			
						log using "`using'", text `replace'		

			if "`short'" != "" {

			qui {
					noisily describe
				}
			}
			else {
				qui {
					noisily codebook
				}
			}
		
			log close

			set linesize `old_linesize'
			
		restore
	}	
	
	noi di as result `"{phang}Meta data file saved to: {browse "`using'":`using'} "'
	
	end
