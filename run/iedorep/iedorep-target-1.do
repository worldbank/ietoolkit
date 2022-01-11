//

clear

sysuse auto.dta

local MYFAKELOCAL = `MYFAKELOCAL' + 1

#d cr

expand 2 , gen(check)

isid make check, sort

sort foreign

di as err "`MYFAKELOCAL'"

gen x = _n
gen y = rnormal()

set seed 123455

duplicates drop make , force

//
