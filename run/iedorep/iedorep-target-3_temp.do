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
local theLOCALS "`theLOCALS' 1" 
local 1 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 2" 
local 2 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 3" 
local 3 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 4" 
local 4 = "`r(datasignature)'" 
}
sysuse auto.dta , clear
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
local theLOCALS "`theLOCALS' 5" 
local 5 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 6" 
local 6 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 7" 
local 7 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 8" 
local 8 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 9" 
local 9 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 10" 
local 10 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 11" 
local 11 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 12" 
local 12 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 13" 
local 13 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 14" 
local 14 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 15" 
local 15 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 16" 
local 16 = "`r(datasignature)'" 
}
di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
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
local theLOCALS "`theLOCALS' 17" 
local 17 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 18" 
local 18 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 19" 
local 19 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 20" 
local 20 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 21" 
local 21 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 22" 
local 22 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 23" 
local 23 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 24" 
local 24 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 25" 
local 25 = "`r(datasignature)'" 
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
local theLOCALS "`theLOCALS' 26" 
local 26 = "`r(datasignature)'" 
}
//
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
local theLOCALS "`theLOCALS' 27" 
local 27 = "`r(datasignature)'" 
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
if ("`r(datasignature)'" != "`1'") {
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
if ("`r(datasignature)'" != "`2'") {
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
if ("`r(datasignature)'" != "`3'") {
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
if ("`r(datasignature)'" != "`4'") {
post posty (4)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
sysuse auto.dta , clear
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
if ("`r(datasignature)'" != "`5'") {
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
if ("`r(datasignature)'" != "`6'") {
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
if ("`r(datasignature)'" != "`7'") {
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
if ("`r(datasignature)'" != "`8'") {
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
if ("`r(datasignature)'" != "`9'") {
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
if ("`r(datasignature)'" != "`10'") {
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
if ("`r(datasignature)'" != "`11'") {
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
if ("`r(datasignature)'" != "`12'") {
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
if ("`r(datasignature)'" != "`13'") {
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
if ("`r(datasignature)'" != "`14'") {
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
if ("`r(datasignature)'" != "`15'") {
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
if ("`r(datasignature)'" != "`16'") {
post posty (16)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
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
if ("`r(datasignature)'" != "`17'") {
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
if ("`r(datasignature)'" != "`18'") {
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
if ("`r(datasignature)'" != "`19'") {
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
if ("`r(datasignature)'" != "`20'") {
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
if ("`r(datasignature)'" != "`21'") {
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
if ("`r(datasignature)'" != "`22'") {
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
if ("`r(datasignature)'" != "`23'") {
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
if ("`r(datasignature)'" != "`24'") {
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
if ("`r(datasignature)'" != "`25'") {
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
if ("`r(datasignature)'" != "`26'") {
post posty (26)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
//
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
if ("`r(datasignature)'" != "`27'") {
post posty (27)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
postclose posty
use `posty' , clear
collapse (firstnm) Data Err_1 Seed Err_2 Sort Err_3 Path , by(Line)
compress
