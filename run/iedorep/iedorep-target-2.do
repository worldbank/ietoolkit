//

clear

sysuse auto.dta , clear

local MYFAKELOCAL = `MYFAKELOCAL' + 1

#d cr

expand 2 , gen(check)

isid make check, sort

sort foreign

di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"

gen x = _n
gen y = rnormal()

set seed 123455

duplicates drop make , force

do "${ietoolkit}/run/iedorep/iedorep-target-3.do"


//
