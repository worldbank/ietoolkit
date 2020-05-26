
	
	sysuse sp500, clear
	
	gen 	month 		= month(date)
	gen 	year  		= year(date)
	gen 	dayofweek 	= dow(date)
	
	sort 	date
	
	set 	seed 893915 														// Obtained through bit.ly/stata-random at  2020-05-19 14:57:54 UTC
	gen 	random1	= uniform()
	gen 	random2	= runiform(-.5, .5)
	
	gen 	tmt = 0
	replace tmt = tmt + 1 	if random1 > .33
	replace tmt = tmt + 1 	if random1 > .66
	
	egen 	stratum = group(month year)
	gen 	cluster	= dayofweek
	
	gen 	weight  = 1 + random2
	
	