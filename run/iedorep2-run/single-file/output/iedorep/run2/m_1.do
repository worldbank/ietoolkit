 //
iedorep_dataline, lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 clear
iedorep_dataline, lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 sysuse auto.dta , clear
iedorep_dataline, lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 #d cr
iedorep_dataline, lnum(9) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 expand 2 , gen(check)
iedorep_dataline, lnum(11) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, lnum(13) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 sort foreign
iedorep_dataline, lnum(15) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
iedorep_dataline, lnum(17) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 forv run = 1/5 {
iedorep_dataline, lnum(19) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker(" run:`run'")
   foreach type in A B "C" {
iedorep_dataline, lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker(" run:`run' type:`type'")
     if "`type'" == "A" set seed 8475
iedorep_dataline, lnum(21) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker(" run:`run' type:`type'")
     gen var`type'`run' = rnormal()
iedorep_dataline, lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker(" run:`run' type:`type'")
   }
 }
 
 gen x = _n
iedorep_dataline, lnum(26) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, lnum(27) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 set seed 123455
iedorep_dataline, lnum(29) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 duplicates drop make , force
iedorep_dataline, lnum(31) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
iedorep_dataline, lnum(33) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") recursestub(m_1_1) orgsubfile(/Users/bbdaniels/GitHub/ietoolkit/run/iedorep/iedorep-target-3.do)
 do "/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1_1.do"
iedorep_dataline, lnum(33) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
 
 //
iedorep_dataline, lnum(36) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep2-run/single-file/output/iedorep/run2/m_1.txt") looptracker("")
 
