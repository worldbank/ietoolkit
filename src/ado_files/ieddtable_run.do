	

	/******************************************
		Create some dummy datat 
		No need to edit anything, but you may 
	********************************************/
	
	clear all
	
	sysuse census
	
	set seed 1234567
	
	*Convert vars to precentage of total population
	local censusvars poplt5 pop5_17 pop18p pop65p popurban death marriage divorce
	foreach cvar of local censusvars {
	
		replace `cvar' = 100 * `cvar' / pop
	}
	
	*Drop state IDs and genrate random time and treat belonging
	drop state state2 region
	gen tmt = (runiform()<.5)
	gen t	= (runiform()<.5)
	
	replace death = death * 1000
	
	replace death = death ^ 2 if tmt == 1
	
	/******************************************
		Add your file path here and 
		try the command
	********************************************/	
	
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

	*Manually set significance level
	ieddtable `outvars' , t(t) tmt(tmt) covar(pop5_17 pop18p pop65p) starl(.05 .01 .001) diformat(%9.5f)	
	
	replace marriage = . if _n == 36
	
	*Options for row labels instead of just using varname
	ieddtable `outvars' , t(t) tmt(tmt) covar(pop5_17 pop18p pop65p) rowlabtext("death Death Rate @@ divorce Divorce Rate") rowlabtype("varlab") onerow

	
	ieddtable `outvars' , t(t) tmt(tmt) covar(pop5_17) rowlabtext("death LOOOOOOOOOOOOOOOOOOOOOOOOOOOOONG label  @@ divorce Divorce Rate") rowlabtype("varlab") errortype(errhide)
