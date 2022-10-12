
local github 	"C:\Users\luizaandrade\Documents\GitHub"
local ietoolkit	"`github'/ietoolkit"
local ado 		"`ietoolkit'/src/ado_files"
local out 		"`ietoolkit'/run/output/iebaltab"

ieboilstart, v(17.0)
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

do "`ado'/iebaltab.ado"

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


/*	
    texnotefile(filename)   Save table note in a separate LaTeX file on disk
    replace                 Replace file on disk if the file already exists
	*/
		
		
**# Column and row options -----------------------------------------------------

* Should throw error: file exists
	cap iebaltab `vars', grpvar(foreign) ///
		control(1) ///
		savetex("`out'/2g.tex")

	assert _rc == 602
	
* control	
	iebaltab `vars', grpvar(foreign) ///
		control(1) ///
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
	
* total                   Include descriptive stats on all observations included in the table
	iebaltab `vars', grpvar(tmt) ///
		total ///
		savetex("`out'/3g-total.tex") ///
		replace
		
	iebaltab `vars', grpvar(foreign) ///
		total ///
		savetex("`out'/2g-total.tex") ///
		replace

* onerow                  Write number of observations (and number of clusters if applicable) in one row at the bottom of the table
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
		ftest ///
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

/*	iebaltab `vars', grpvar(foreign) ///
		format("%9.2f") ///
		savetex("`out'/2g-fmt.tex") ///
		replace
*/		
	iebaltab `vars', grpvar(foreign) ///
		starsnoadd ///
		savetex("`out'/2g-nostars.tex") ///
		replace
		
	iebaltab `vars', grpvar(foreign) ///
		starlevels(.05 .01 .001) ///
		savetex("`out'/2g-stars.tex") ///
		replace
		
		
	iebaltab `vars', grpvar(foreign) ///
		stats(pair(diff se)) ///
		savetex("`out'/2g-diff-se.tex") ///
		replace
	
exit
    
**# Label/notes options     Description
    grpcodes                Use the values in the grpvar() variable as column titles. Default is to use value labels if any
    grplabels(codetitles)   Manually set the group column titles. See details on codetitles below
    totallabel(string)      Manually set the title of the total column
    rowvarlabels            Use the variable labels instead of variable name as row titles
    rowlabels(nametitles)   Manually set the row titles. See details on nametitles below
    tblnote(string)         Replace the default note at the bottom of the table
    tbladdnote(string)      Add note to the default note at the bottom of the table
    tblnonote               Suppresses any note at the bottom of the table

**# LaTeX options           Description
    texnotewidth(numlist)   Manually adjust width of note
    texcaption(string)      Specify LaTeX table caption
    texlabel(string)        Specify LaTeX label
    texdocument             Create a stand-alone LaTeX document
    texvspace(string)       Manually set size of the line space between two rows on LaTeX output
    texcolwidth(string)     Limit width of the first column on LaTeX output
