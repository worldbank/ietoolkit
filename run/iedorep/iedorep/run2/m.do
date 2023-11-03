 //
iedorep_dataline, run(2) lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 clear
iedorep_dataline, run(2) lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 sysuse auto.dta
iedorep_dataline, run(2) lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 isid make, sort
iedorep_dataline, run(2) lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 sort foreign
iedorep_dataline, run(2) lnum(8) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, run(2) lnum(10) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 su price
iedorep_dataline, run(2) lnum(12) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 di as err "Should be 6165... `r(mean)'"
iedorep_dataline, run(2) lnum(14) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 #d cr
iedorep_dataline, run(2) lnum(16) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 // TEST COMMENT
iedorep_dataline, run(2) lnum(18) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 global do "nothing"
iedorep_dataline, run(2) lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 forv run = 1/5 {
iedorep_dataline, run(2) lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker(" run:`run'")
   gen varx`run' = rnormal()
iedorep_dataline, run(2) lnum(23) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker(" run:`run'")
   if `run' == 3 set seed 847
iedorep_dataline, run(2) lnum(24) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker(" run:`run'")
 }
 
 expand 2 , gen(check)
iedorep_dataline, run(2) lnum(27) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, run(2) lnum(29) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 sort foreign
iedorep_dataline, run(2) lnum(31) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"
iedorep_dataline, run(2) lnum(33) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 gen x = _n
iedorep_dataline, run(2) lnum(35) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, run(2) lnum(36) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 
 
 duplicates drop make , force
iedorep_dataline, run(2) lnum(40) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 
iedorep_dataline, run(2) lnum(43) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") recursestub(m_1) orgsubfile(/Users/bbdaniels/GitHub/ietoolkit/run/iedorep/iedorep-target-2.do)
 do "/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.do"
iedorep_dataline, run(2) lnum(43) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 
 //
iedorep_dataline, run(2) lnum(46) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
