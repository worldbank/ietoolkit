//

clear

/// set seed 12345

sysuse auto.dta

#d cr

expand 2 , gen(check)

isid make check, sort

sort foreign

gen x = _n
gen y = rnormal()

// duplicates drop make , force

//
