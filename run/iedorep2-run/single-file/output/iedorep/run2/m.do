 //
iedorep_dataline, lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 clear
iedorep_dataline, lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 sysuse auto.dta
iedorep_dataline, lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 #d cr
iedorep_dataline, lnum(9) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 // TEST COMMENT
iedorep_dataline, lnum(11) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 global do "nothing"
iedorep_dataline, lnum(13) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 forv run = 1/5 {
iedorep_dataline, lnum(15) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker(" run:`run'")
   gen varx`run' = rnormal()
iedorep_dataline, lnum(16) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker(" run:`run'")
   if `run' == 3 set seed 847
iedorep_dataline, lnum(17) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker(" run:`run'")
 }
 
 expand 2 , gen(check)
iedorep_dataline, lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 sort foreign
iedorep_dataline, lnum(24) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"
iedorep_dataline, lnum(26) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 gen x = _n
iedorep_dataline, lnum(28) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, lnum(29) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 
 
 duplicates drop make , force
iedorep_dataline, lnum(33) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 
iedorep_dataline, lnum(36) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") recursestub(m_1) orgsubfile(/Users/bbdaniels/GitHub/ietoolkit/run/iedorep/iedorep-target-2.do)
 do "/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.do"
iedorep_dataline, lnum(36) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
 
 //
iedorep_dataline, lnum(39) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m.txt") looptracker("")
 
