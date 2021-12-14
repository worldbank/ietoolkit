//

clear

sysuse auto.dta

#d cr

expand 2 , gen(check)

isid make check, sort

sort foreign

gen x = _n
gen y = rnormal()

set seed 123455

duplicates drop make , force

//
