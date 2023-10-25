 //
iedorep_dataline, run(2) data(  9591999838) lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 clear
iedorep_dataline, run(2) data(  5440770502) lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 sysuse auto.dta
iedorep_dataline, run(2) data(  3576809061) lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, run(2) data( 27547459803) lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 #d cr
iedorep_dataline, run(2) data(  1973079265) lnum(9) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 // TEST COMMENT
iedorep_dataline, run(2) data(  8034225260) lnum(11) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 global do "nothing"
iedorep_dataline, run(2) data(  4407027247) lnum(13) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 forv run = 1/5 {
iedorep_dataline, run(2) data( 10192273297) lnum(15) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker(" run:`run'")
   gen varx`run' = rnormal()
iedorep_dataline, run(2) data( 18719764165) lnum(16) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker(" run:`run'")
   if `run' == 3 set seed 847
iedorep_dataline, run(2) data(  4235664310) lnum(17) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker(" run:`run'")
 }
 
 expand 2 , gen(check)
iedorep_dataline, run(2) data(  5279335424) lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, run(2) data( 14506459260) lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 sort foreign
iedorep_dataline, run(2) data( 13672061890) lnum(24) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"
iedorep_dataline, run(2) data(  4591981228) lnum(26) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 gen x = _n
iedorep_dataline, run(2) data(    20742090) lnum(28) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, run(2) data(  7135886860) lnum(29) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 
 
 duplicates drop make , force
iedorep_dataline, run(2) data(  4819369478) lnum(33) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 
iedorep_dataline, run(2) data( 21440583841) lnum(36) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") recursestub(m_1) orgsubfile(/Users/bbdaniels/GitHub/ietoolkit/run/iedorep/iedorep-target-2.do)
 do "/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.do"
iedorep_dataline, run(2) data( 21440583841) lnum(36) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
 
 //
iedorep_dataline, run(2) data( 25183089009) lnum(39) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m.txt") looptracker("")
 
