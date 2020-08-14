
	
	sysuse auto, clear
	
	isid make, sort
	
	set 	seed 893915 														// Obtained through bit.ly/stata-random at  2020-05-19 14:57:54 UTC
	gen 	random1	= uniform()
	gen 	random2	= runiform(-.5, .5)
	
	gen 	tmt = 0
	replace tmt = tmt + 1 	if random1 > .33
	replace tmt = tmt + 1 	if random1 > .5
	
	gen	  cluster = 1
	local sum = -.5
	
	forvalues val  = 1/10 {
		local sum = `sum' + .1
		replace cluster = cluster + 1 if random2 > `sum'
	}

	
	iebaltab trunk mpg [pw = random1], grpvar(tmt)
	
	iebaltab trunk mpg, grpvar(tmt) vce(cluster cluster) feqtest

	iebaltab trunk mpg, grpvar(tmt) vce(cluster cluster) normdiff
	
//	iebaltab price, grpvar(tmt) browse
	iebaltab trunk mpg, grpvar(tmt)
	
