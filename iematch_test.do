

	clear
	
	
	qui do "C:\Users\wb462869\Box Sync\Stata\Stata work\Commands\ietoolkit\iematch.do"
	
	
	set seed 125345324
	
	set obs 300000

	gen id = _n

	gen rand1 = uniform()

	gen tmt = (rand1 > .40)

	*replace tmt = . if (rand1 < .45)

	drop rand1
	tab tmt

	gen p_hat = uniform()

	*replace p_hat = p_hat + .03 if tmt == 1

	*replace p_hat = . if p_hat < .2

	*tostring id, replace
	
	iematch   , grp(tmt)  m1 match(p_hat) idvar(id)   //maxdiff(.01)  //matchidname(Kallefille)
