 //
iedorep_dataline, run(1) data( 10146536182) lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 clear
iedorep_dataline, run(1) data(  4750325456) lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 sysuse auto.dta , clear
iedorep_dataline, run(1) data( 12725781032) lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, run(1) data(  5651003849) lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 #d cr
iedorep_dataline, run(1) data(  5919445831) lnum(9) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 expand 2 , gen(check)
iedorep_dataline, run(1) data(  2087252409) lnum(11) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, run(1) data(  3798011682) lnum(13) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 sort foreign
iedorep_dataline, run(1) data(  3004382349) lnum(15) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
iedorep_dataline, run(1) data(  1958862401) lnum(17) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 gen x = _n
iedorep_dataline, run(1) data(   101897102) lnum(19) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, run(1) data( 14619452605) lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 set seed 123455
iedorep_dataline, run(1) data(  8264246446) lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 duplicates drop make , force
iedorep_dataline, run(1) data( 14413848203) lnum(24) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
 
 //
iedorep_dataline, run(1) data( 15097363822) lnum(27) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run1/m_1_1.txt") looptracker("")
 
