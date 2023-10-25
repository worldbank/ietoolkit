 //
iedorep_dataline, run(2) data(  2658658211) lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 clear
iedorep_dataline, run(2) data(  5798361624) lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 sysuse auto.dta , clear
iedorep_dataline, run(2) data( 10630641467) lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, run(2) data(  2512961121) lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 #d cr
iedorep_dataline, run(2) data(  4487065745) lnum(9) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 expand 2 , gen(check)
iedorep_dataline, run(2) data( 12338209488) lnum(11) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, run(2) data( 13252670345) lnum(13) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 sort foreign
iedorep_dataline, run(2) data(  1675929589) lnum(15) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
iedorep_dataline, run(2) data( 15505601872) lnum(17) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 forv run = 1/5 {
iedorep_dataline, run(2) data(  9244225418) lnum(19) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker(" run:`run'")
   foreach type in A B "C" {
iedorep_dataline, run(2) data(  8722835317) lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker(" run:`run' type:`type'")
     if "`type'" == "A" set seed 8475
iedorep_dataline, run(2) data(  2140264578) lnum(21) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker(" run:`run' type:`type'")
     gen var`type'`run' = rnormal()
iedorep_dataline, run(2) data(  3503931389) lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker(" run:`run' type:`type'")
   }
 }
 
 gen x = _n
iedorep_dataline, run(2) data( 10970962868) lnum(26) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, run(2) data(  5551859072) lnum(27) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 set seed 123455
iedorep_dataline, run(2) data(  8094900866) lnum(29) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 duplicates drop make , force
iedorep_dataline, run(2) data(  5533247706) lnum(31) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
iedorep_dataline, run(2) data(  1223800206) lnum(33) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") recursestub(m_1_1) orgsubfile(/Users/bbdaniels/GitHub/ietoolkit/run/iedorep/iedorep-target-3.do)
 do "/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.do"
iedorep_dataline, run(2) data(  1223800206) lnum(33) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
 
 //
iedorep_dataline, run(2) data( 12105630345) lnum(36) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1.txt") looptracker("")
 
