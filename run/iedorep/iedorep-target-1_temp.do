  cap drop _all            
  cap frames reset         
  cap collect clear        
  cap label drop _all      
  cap matrix drop _all     
  cap scalar drop _all     
  cap constraint drop _all 
  cap cluster drop _all    
  cap file close _all      
  cap postutil clear       
  cap _return drop _all    
  cap discard              
  cap timer clear          
  cap putdocx clear        
  cap putpdf clear         
  cap mata: mata clear     
  cap python clear         
  cap java clear  
tempname theSORT theRNG allRNGS whichRNG theDATA
tempfile posty allDATA
postfile posty Line str15(Data Err_1 Seed Err_2 Sort Err_3) str2000(Path) using `posty' , replace
local `theRNG' = "`c(rngstate)'" 
local `theSORT' = "`c(sortrngstate)'" 
datasignature
local `theDATA' = "`r(datasignature)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
post posty (1)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (1)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 1_x
save `1_x' , emptyok
local theLOCALS "`theLOCALS' 1_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (1)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 1
local theLOCALS "`theLOCALS' 1" 
save `1' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (2)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (2)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 2_x
save `2_x' , emptyok
local theLOCALS "`theLOCALS' 2_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (2)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 2
local theLOCALS "`theLOCALS' 2" 
save `2' , emptyok
}
clear
if ("`c(rngstate)'" != "``theRNG''") {
post posty (3)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (3)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 3_x
save `3_x' , emptyok
local theLOCALS "`theLOCALS' 3_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (3)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 3
local theLOCALS "`theLOCALS' 3" 
save `3' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (4)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (4)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 4_x
save `4_x' , emptyok
local theLOCALS "`theLOCALS' 4_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (4)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 4
local theLOCALS "`theLOCALS' 4" 
save `4' , emptyok
}
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
post posty (5)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (5)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 5_x
save `5_x' , emptyok
local theLOCALS "`theLOCALS' 5_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (5)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 5
local theLOCALS "`theLOCALS' 5" 
save `5' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (6)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (6)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 6_x
save `6_x' , emptyok
local theLOCALS "`theLOCALS' 6_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (6)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 6
local theLOCALS "`theLOCALS' 6" 
save `6' , emptyok
}
local MYFAKELOCAL = `MYFAKELOCAL' + 1
if ("`c(rngstate)'" != "``theRNG''") {
post posty (7)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (7)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 7_x
save `7_x' , emptyok
local theLOCALS "`theLOCALS' 7_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (7)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 7
local theLOCALS "`theLOCALS' 7" 
save `7' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (8)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (8)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 8_x
save `8_x' , emptyok
local theLOCALS "`theLOCALS' 8_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (8)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 8
local theLOCALS "`theLOCALS' 8" 
save `8' , emptyok
}
#d cr
if ("`c(rngstate)'" != "``theRNG''") {
post posty (9)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (9)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 9_x
save `9_x' , emptyok
local theLOCALS "`theLOCALS' 9_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (9)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 9
local theLOCALS "`theLOCALS' 9" 
save `9' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (10)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (10)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 10_x
save `10_x' , emptyok
local theLOCALS "`theLOCALS' 10_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (10)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 10
local theLOCALS "`theLOCALS' 10" 
save `10' , emptyok
}
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
post posty (11)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (11)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 11_x
save `11_x' , emptyok
local theLOCALS "`theLOCALS' 11_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (11)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 11
local theLOCALS "`theLOCALS' 11" 
save `11' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (12)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (12)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 12_x
save `12_x' , emptyok
local theLOCALS "`theLOCALS' 12_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (12)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 12
local theLOCALS "`theLOCALS' 12" 
save `12' , emptyok
}
isid make check, sort
if ("`c(rngstate)'" != "``theRNG''") {
post posty (13)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (13)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 13_x
save `13_x' , emptyok
local theLOCALS "`theLOCALS' 13_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (13)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 13
local theLOCALS "`theLOCALS' 13" 
save `13' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (14)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (14)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 14_x
save `14_x' , emptyok
local theLOCALS "`theLOCALS' 14_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (14)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 14
local theLOCALS "`theLOCALS' 14" 
save `14' , emptyok
}
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
post posty (15)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (15)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 15_x
save `15_x' , emptyok
local theLOCALS "`theLOCALS' 15_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (15)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 15
local theLOCALS "`theLOCALS' 15" 
save `15' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (16)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (16)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 16_x
save `16_x' , emptyok
local theLOCALS "`theLOCALS' 16_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (16)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 16
local theLOCALS "`theLOCALS' 16" 
save `16' , emptyok
}
di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"
if ("`c(rngstate)'" != "``theRNG''") {
post posty (17)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (17)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 17_x
save `17_x' , emptyok
local theLOCALS "`theLOCALS' 17_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (17)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 17
local theLOCALS "`theLOCALS' 17" 
save `17' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (18)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (18)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 18_x
save `18_x' , emptyok
local theLOCALS "`theLOCALS' 18_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (18)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 18
local theLOCALS "`theLOCALS' 18" 
save `18' , emptyok
}
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
post posty (19)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (19)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 19_x
save `19_x' , emptyok
local theLOCALS "`theLOCALS' 19_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (19)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 19
local theLOCALS "`theLOCALS' 19" 
save `19' , emptyok
}
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
post posty (20)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (20)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 20_x
save `20_x' , emptyok
local theLOCALS "`theLOCALS' 20_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (20)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 20
local theLOCALS "`theLOCALS' 20" 
save `20' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (21)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (21)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 21_x
save `21_x' , emptyok
local theLOCALS "`theLOCALS' 21_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (21)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 21
local theLOCALS "`theLOCALS' 21" 
save `21' , emptyok
}
set seed 123455
if ("`c(rngstate)'" != "``theRNG''") {
post posty (22)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (22)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 22_x
save `22_x' , emptyok
local theLOCALS "`theLOCALS' 22_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (22)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 22
local theLOCALS "`theLOCALS' 22" 
save `22' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (23)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (23)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 23_x
save `23_x' , emptyok
local theLOCALS "`theLOCALS' 23_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (23)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 23
local theLOCALS "`theLOCALS' 23" 
save `23' , emptyok
}
duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
post posty (24)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (24)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 24_x
save `24_x' , emptyok
local theLOCALS "`theLOCALS' 24_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (24)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 24
local theLOCALS "`theLOCALS' 24" 
save `24' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (25)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (25)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 25_x
save `25_x' , emptyok
local theLOCALS "`theLOCALS' 25_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (25)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 25
local theLOCALS "`theLOCALS' 25" 
save `25' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (26)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (26)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 26_x
save `26_x' , emptyok
local theLOCALS "`theLOCALS' 26_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (26)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 26
local theLOCALS "`theLOCALS' 26" 
save `26' , emptyok
}
do "${ietoolkit}/run/iedorep/iedorep-target-2.do"
 post posty (27)  ("") ("") ("") ("") ("") ("") (`""/Users/bbdaniels/GitHub/ietoolkit/run/iedorep/iedorep-target-2.do""') 
if ("`c(rngstate)'" != "``theRNG''") {
post posty (27)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (27)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 27_x
save `27_x' , emptyok
local theLOCALS "`theLOCALS' 27_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (27)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 27
local theLOCALS "`theLOCALS' 27" 
save `27' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (28)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (28)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 28_x
save `28_x' , emptyok
local theLOCALS "`theLOCALS' 28_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (28)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 28
local theLOCALS "`theLOCALS' 28" 
save `28' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (29)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (29)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 29_x
save `29_x' , emptyok
local theLOCALS "`theLOCALS' 29_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (29)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 29
local theLOCALS "`theLOCALS' 29" 
save `29' , emptyok
}
//
if ("`c(rngstate)'" != "``theRNG''") {
post posty (30)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (30)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
tempfile 30_x
save `30_x' , emptyok
local theLOCALS "`theLOCALS' 30_x" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (30)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 30
local theLOCALS "`theLOCALS' 30" 
save `30' , emptyok
}

// CLEANUP LOCALS BETWEEN FILES -------------------------------------------
local theLOCALS posty theSORT theRNG allRNGS whichRNG allDATA theDATA theLOCALS `posty' `theSORT' `theRNG' `allRNGS' `whichRNG' `allDATA' `theDATA' `theLOCALS'
mata : st_local("all_locals", invtokens(st_dir("local", "macro", "*")'))
local toDROP : list all_locals - theLOCALS
cap macro drop `toDROP' 
foreach macro in `toDROP' {
  mata : st_local("`macro'","") 
}
// ADVANCE RNG AND CLEAR DATA -------------------------------------------
qui di `=rnormal()'
  cap drop _all            
  cap frames reset         
  cap collect clear        
  cap label drop _all      
  cap matrix drop _all     
  cap scalar drop _all     
  cap constraint drop _all 
  cap cluster drop _all    
  cap file close _all      
  cap _return drop _all    
  cap mata: mata clear     
  cap timer clear          
  cap putdocx clear        
  cap putpdf clear         
  cap python clear         
  cap java clear  
// SECOND RUN STARTS HERE ------------------------------------------------

local `theRNG' = "`c(rngstate)'" 
local `theSORT' = "`c(sortrngstate)'" 
datasignature
local `theDATA' = "`r(datasignature)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (1)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `1_x'
if _rc != 0 {
post posty (1)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `1'
if _rc != 0 {
post posty (1)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (2)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `2_x'
if _rc != 0 {
post posty (2)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `2'
if _rc != 0 {
post posty (2)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
clear
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (3)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `3_x'
if _rc != 0 {
post posty (3)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `3'
if _rc != 0 {
post posty (3)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (4)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `4_x'
if _rc != 0 {
post posty (4)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `4'
if _rc != 0 {
post posty (4)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (5)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `5_x'
if _rc != 0 {
post posty (5)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `5'
if _rc != 0 {
post posty (5)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (6)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `6_x'
if _rc != 0 {
post posty (6)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `6'
if _rc != 0 {
post posty (6)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
local MYFAKELOCAL = `MYFAKELOCAL' + 1
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (7)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `7_x'
if _rc != 0 {
post posty (7)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `7'
if _rc != 0 {
post posty (7)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (8)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `8_x'
if _rc != 0 {
post posty (8)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `8'
if _rc != 0 {
post posty (8)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
#d cr
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (9)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `9_x'
if _rc != 0 {
post posty (9)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `9'
if _rc != 0 {
post posty (9)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (10)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `10_x'
if _rc != 0 {
post posty (10)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `10'
if _rc != 0 {
post posty (10)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (11)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `11_x'
if _rc != 0 {
post posty (11)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `11'
if _rc != 0 {
post posty (11)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (12)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `12_x'
if _rc != 0 {
post posty (12)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `12'
if _rc != 0 {
post posty (12)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
isid make check, sort
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (13)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `13_x'
if _rc != 0 {
post posty (13)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `13'
if _rc != 0 {
post posty (13)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (14)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `14_x'
if _rc != 0 {
post posty (14)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `14'
if _rc != 0 {
post posty (14)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (15)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `15_x'
if _rc != 0 {
post posty (15)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `15'
if _rc != 0 {
post posty (15)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (16)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `16_x'
if _rc != 0 {
post posty (16)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `16'
if _rc != 0 {
post posty (16)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (17)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `17_x'
if _rc != 0 {
post posty (17)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `17'
if _rc != 0 {
post posty (17)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (18)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `18_x'
if _rc != 0 {
post posty (18)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `18'
if _rc != 0 {
post posty (18)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (19)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `19_x'
if _rc != 0 {
post posty (19)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `19'
if _rc != 0 {
post posty (19)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (20)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `20_x'
if _rc != 0 {
post posty (20)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `20'
if _rc != 0 {
post posty (20)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (21)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `21_x'
if _rc != 0 {
post posty (21)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `21'
if _rc != 0 {
post posty (21)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
set seed 123455
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (22)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `22_x'
if _rc != 0 {
post posty (22)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `22'
if _rc != 0 {
post posty (22)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (23)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `23_x'
if _rc != 0 {
post posty (23)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `23'
if _rc != 0 {
post posty (23)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (24)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `24_x'
if _rc != 0 {
post posty (24)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `24'
if _rc != 0 {
post posty (24)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (25)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `25_x'
if _rc != 0 {
post posty (25)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `25'
if _rc != 0 {
post posty (25)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (26)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `26_x'
if _rc != 0 {
post posty (26)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `26'
if _rc != 0 {
post posty (26)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
do "${ietoolkit}/run/iedorep/iedorep-target-2.do"
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (27)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `27_x'
if _rc != 0 {
post posty (27)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `27'
if _rc != 0 {
post posty (27)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (28)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `28_x'
if _rc != 0 {
post posty (28)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `28'
if _rc != 0 {
post posty (28)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (29)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `29_x'
if _rc != 0 {
post posty (29)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `29'
if _rc != 0 {
post posty (29)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (30)  ("") ("") ("") ("ERROR! ") ("") ("") ("")   
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
cap cf _all using `30_x'
if _rc != 0 {
post posty (30)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `30'
if _rc != 0 {
post posty (30)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
postclose posty
use `posty' , clear
collapse (firstnm) Data Err_1 Seed Err_2 Sort Err_3 Path , by(Line)
compress
