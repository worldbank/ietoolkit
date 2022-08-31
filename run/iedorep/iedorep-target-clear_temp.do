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
ieboilstart , version(13) noclear 
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
  `r(version)'
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
sysuse auto.dta , clear
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
//
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
ieboilstart , version(13) noclear 
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
  `r(version)'
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
sysuse auto.dta , clear
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
//
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
postclose posty
use `posty' , clear
collapse (firstnm) Data Err_1 Seed Err_2 Sort Err_3 Path , by(Line)
compress
