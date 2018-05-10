	
	/* Create some dummy datat */
	
	clear all
	
	sysuse census
	
	*Convert vars to precentage of total population
	local censusvars poplt5 pop5_17 pop18p pop65p popurban death marriage divorce
	foreach cvar of local censusvars {
	
		replace `cvar' = 100 * `cvar' / pop
	}
	
	*Drop state IDs and genrate random time and treat belonging
	drop state state2 region
	gen tmt = (runiform()<.5)
	gen t	= (runiform()<.5)
	
/* 
	*Include this to see how the command test for non dummy values in dummies
	replace t = 2 if _n == 1
*/
	
/* 
	*Include this to see how the command test that there are too few groups
			replace tmt = 0
	bys t : replace tmt = 1 if _n == 1
*/
	
	
	*Add your own file path to be able to run the command
	if "`c(username)'" == "kbrkb" global ietoolkitfolder "C:\Users\kbrkb\Documents\GitHub\ietoolkit"
	
	qui do "$ietoolkitfolder\src\ado_files\ieddtable.ado"
	
	local outvars death marriage divorce
	
	*Simple possible specification
	ieddtable `outvars' , t(t) tmt(tmt)
	
	*Including covariates
	ieddtable `outvars' , t(t) tmt(tmt) covar(pop5_17 pop18p pop65p) 
	
	*Manually set significance level
	ieddtable `outvars' , t(t) tmt(tmt) covar(pop5_17 pop18p pop65p) starl(.05 .01 .001)
	
	*Options for row labels instead of just using varname
	ieddtable `outvars' , t(t) tmt(tmt) covar(pop5_17 pop18p pop65p) rowlabtext("death Death Rate @@ divorce Divorce Rate") rowlabtype("varlab")

	
