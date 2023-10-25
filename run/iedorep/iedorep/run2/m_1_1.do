 //
iedorep_dataline, run(2) data(  4006999317) lnum(1) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 clear
iedorep_dataline, run(2) data(  5094894868) lnum(3) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 sysuse auto.dta , clear
iedorep_dataline, run(2) data(  3069667830) lnum(5) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
iedorep_dataline, run(2) data(  1418411512) lnum(7) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 #d cr
iedorep_dataline, run(2) data( 15370301534) lnum(9) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 expand 2 , gen(check)
iedorep_dataline, run(2) data( 28639375445) lnum(11) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 isid make check, sort
iedorep_dataline, run(2) data(  2342040797) lnum(13) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 sort foreign
iedorep_dataline, run(2) data( 12313349687) lnum(15) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
iedorep_dataline, run(2) data(  5130483054) lnum(17) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 gen x = _n
iedorep_dataline, run(2) data(  7572336719) lnum(19) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 gen y = rnormal()
iedorep_dataline, run(2) data(  1958862401) lnum(20) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 set seed 123455
iedorep_dataline, run(2) data(   101897102) lnum(22) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 duplicates drop make , force
iedorep_dataline, run(2) data(   571759782) lnum(24) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
 
 //
iedorep_dataline, run(2) data( 14413848203) lnum(27) datatmp("/Users/bbdaniels/GitHub/ietoolkit/run/iedorep//iedorep/run2/m_1_1.txt") looptracker("")
 
