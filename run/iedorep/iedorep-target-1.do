//

clear

sysuse auto.dta

local MYFAKELOCAL = `MYFAKELOCAL' + 1

#d cr

// TEST COMMENT

global do "nothing"

expand 2 , gen(check)

isid make check, sort

sort foreign

di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"

gen x = _n
gen y = rnormal()

forv run = 1/5 {
  gen varx`run' = rnormal()
  if `run' == 3 set seed 847
}

duplicates drop make , force


do "${ietoolkit}/run/iedorep/iedorep-target-2.do"


//
