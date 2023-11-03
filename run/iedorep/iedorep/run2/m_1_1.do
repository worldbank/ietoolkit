 //
iedorep_dataline, run(2) lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 clear
iedorep_dataline, run(2) lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 sysuse auto.dta , clear
iedorep_dataline, run(2) lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, run(2) lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 #d cr
iedorep_dataline, run(2) lnum(9) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 expand 2 , gen(check)
iedorep_dataline, run(2) lnum(11) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, run(2) lnum(13) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 sort foreign
iedorep_dataline, run(2) lnum(15) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
iedorep_dataline, run(2) lnum(17) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 gen x = _n
iedorep_dataline, run(2) lnum(19) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, run(2) lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 set seed 123455
iedorep_dataline, run(2) lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 duplicates drop make , force
iedorep_dataline, run(2) lnum(24) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 
 //
iedorep_dataline, run(2) lnum(27) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
