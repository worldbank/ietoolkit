//

clear

sysuse auto.dta , clear

local MYFAKELOCAL = `MYFAKELOCAL' + 1

#d cr

expand 2 , gen(check)

isid make check, sort

sort foreign

di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"

forv run = 1/5 {
  foreach type in A B "C" {
    if "`type'" == "A" set seed 8475
    gen var`type'`run' = rnormal()
  }
}

gen x = _n
gen y = rnormal()

set seed 123455

duplicates drop make , force

do "${clone}/run/iedorep/iedorep-target-3.do"


//
