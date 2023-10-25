 //
iedorep_dataline, lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 clear
iedorep_dataline, lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 sysuse auto.dta , clear
iedorep_dataline, lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 #d cr
iedorep_dataline, lnum(9) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 expand 2 , gen(check)
iedorep_dataline, lnum(11) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, lnum(13) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 sort foreign
iedorep_dataline, lnum(15) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
iedorep_dataline, lnum(17) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 gen x = _n
iedorep_dataline, lnum(19) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 set seed 123455
iedorep_dataline, lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 duplicates drop make , force
iedorep_dataline, lnum(24) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 
 //
iedorep_dataline, lnum(27) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
