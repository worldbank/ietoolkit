//

clear

// set seed 12345

sysuse auto.dta

expand 2 , gen(check)

sort foreign 

gen x = _n

//
