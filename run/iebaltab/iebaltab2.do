
ieboilstart , version(13.1)
`r(version)'

sysuse auto, clear

set seed 232197	// obtained from bit.ly/stata-random on 2022-10-11 22:16:30 UTC

gen random = runiform()

gen tmt = (random > .33)
replace tmt = 2 if (random > .66)

split make, gen(strata)
encode strata1, gen(stratum)
drop strata*

local vars price mpg trunk headroom weight length turn displacement gear_ratio

qui do "src/ado_files/iebaltab.ado"
qui do "run/run_utils.do"

local out "run/iebaltab/outputs/iebaltab2"
ie_recurse_mkdir, folder("`out'")

**# Export options ---------------------------------------------------------------

preserve
	iebaltab `vars', grpvar(foreign) browse
restore

iebaltab `vars', grpvar(foreign) ///
	savexlsx("`out'/2g.xlsx") ///
	savecsv("`out'/2g-control.csv") ///
	savetex("`out'/2g.tex") ///
	replace

iebaltab `vars', grpvar(tmt) ///
		savetex("`out'/3g.tex") ///
		replace

**# Column and row options -----------------------------------------------------

* Should throw error: file exists
	cap iebaltab `vars', grpvar(foreign) ///
		control(1) ///
		savetex("`out'/2g.tex")

	assert _rc == 602

* control
	iebaltab `vars', grpvar(foreign) ///
		control(0) ///
		savetex("`out'/2g-control.tex") ///
		replace

* Three groups
	iebaltab `vars', grpvar(tmt) ///
		savetex("`out'/3g.tex") ///
		replace

	iebaltab `vars', grpvar(tmt) ///
		control(0) ///
		savetex("`out'/3g-control.tex") ///
		replace

*  order(groupcodelist)
	iebaltab `vars', grpvar(tmt) ///
		order(2) ///
		savetex("`out'/3g-order.tex") ///
		replace

	iebaltab `vars', grpvar(tmt) ///
		control(0) order(2 1) ///
		savetex("`out'/3g-control-order.tex") ///
		replace

* total
	iebaltab `vars', grpvar(tmt) ///
		total ///
		savetex("`out'/3g-total.tex") ///
		replace

	iebaltab `vars', grpvar(foreign) ///
		total ///
		savetex("`out'/2g-total.tex") ///
		replace

* onerow
	iebaltab `vars', grpvar(foreign) ///
		onerow ///
		savetex("`out'/2g-onerow.tex") ///
		replace

**# Estimation options ---------------------------------------------------------
	iebaltab `vars', grpvar(foreign) ///
		fixedeffect(stratum) ///
		savetex("`out'/2g-fe.tex") ///
		replace

	iebaltab `vars', grpvar(tmt) ///
		covariates(foreign) ///
		stats(pair(p)) ///
		savetex("`out'/3g-cov.tex") ///
		replace

	iebaltab `vars', grpvar(foreign) ///
		fixedeffect(stratum) ///
		ftest ///
		savetex("`out'/2g-ftest.tex") ///
		replace

	iebaltab `vars', grpvar(foreign) ///
		fixedeffect(stratum) ///
		feqtest ///
		savetex("`out'/2g-feqtest.tex") ///
		replace

	iebaltab `vars', grpvar(foreign) ///
		stats(pair(p)) ///
		savetex("`out'/2g-pair.tex") ///
		replace

	iebaltab `vars', grpvar(foreign) ///
		vce(cluster stratum) ///
		stats(pair(p)) ///
		savetex("`out'/2g-cluster.tex") ///
		replace

**# Stat display options -------------------------------------------------------

	iebaltab `vars', grpvar(foreign) ///
		format("%9.2f") ///
		savetex("`out'/2g-fmt.tex") ///
		replace

	iebaltab `vars', grpvar(foreign) ///
		starsnoadd ///
		savetex("`out'/2g-nostars.tex") ///
		replace

	iebaltab `vars', grpvar(foreign) ///
		starlevels(.05 .01 .001) ///
		savetex("`out'/2g-stars.tex") ///
		replace


/*	This should work at some point, but is not yet implemented
	iebaltab `vars', grpvar(foreign) ///
		stats(pair(diff se)) ///
		savetex("`out'/2g-diff-se.tex") ///
		replace
*/
exit
