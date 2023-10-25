 //
iedorep_dataline, run(1) data(  9591999838) lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 clear
iedorep_dataline, run(1) data(  5440770502) lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 sysuse auto.dta
iedorep_dataline, run(1) data(  3576809061) lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 isid make, sort
iedorep_dataline, run(1) data( 27547459803) lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 sort foreign
iedorep_dataline, run(1) data(  6125968334) lnum(8) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, run(1) data( 16102238204) lnum(10) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 #d cr
iedorep_dataline, run(1) data( 10960116638) lnum(12) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 // TEST COMMENT
iedorep_dataline, run(1) data( 10114265226) lnum(14) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 global do "nothing"
iedorep_dataline, run(1) data( 18719764165) lnum(16) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 forv run = 1/5 {
iedorep_dataline, run(1) data(  6339538298) lnum(18) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker(" run:`run'")
   gen varx`run' = rnormal()
iedorep_dataline, run(1) data(  4172334254) lnum(19) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker(" run:`run'")
   if `run' == 3 set seed 847
iedorep_dataline, run(1) data(  5279335424) lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker(" run:`run'")
 }
 
 expand 2 , gen(check)
iedorep_dataline, run(1) data( 10992252691) lnum(23) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, run(1) data(  5174628125) lnum(25) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 sort foreign
iedorep_dataline, run(1) data( 10245762726) lnum(27) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"
iedorep_dataline, run(1) data(  7135886860) lnum(29) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 gen x = _n
iedorep_dataline, run(1) data(  9106916780) lnum(31) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, run(1) data( 11047774324) lnum(32) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 
 
 duplicates drop make , force
iedorep_dataline, run(1) data(  2658658211) lnum(36) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 
iedorep_dataline, run(1) data( 25183089009) lnum(39) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") recursestub(m_1) orgsubfile(/Users/bbdaniels/GitHub/ietoolkit/run/iedorep/iedorep-target-2.do)
 do "/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1.do"
iedorep_dataline, run(1) data( 25183089009) lnum(39) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
 
 //
iedorep_dataline, run(1) data(   734580041) lnum(42) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m.txt") looptracker("")
 
