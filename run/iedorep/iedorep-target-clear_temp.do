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
tempname theSORT theRNG allRNGS whichRNG allDATA theDATA
tempfile posty
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
preserve
xpose, clear
tempfile 1_x
save `1_x' , emptyok
local theLOCALS "`theLOCALS' 1_x" 
restore
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
preserve
xpose, clear
tempfile 2_x
save `2_x' , emptyok
local theLOCALS "`theLOCALS' 2_x" 
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (2)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 2
local theLOCALS "`theLOCALS' 2" 
save `2' , emptyok
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
preserve
xpose, clear
tempfile 3_x
save `3_x' , emptyok
local theLOCALS "`theLOCALS' 3_x" 
restore
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
preserve
xpose, clear
tempfile 4_x
save `4_x' , emptyok
local theLOCALS "`theLOCALS' 4_x" 
restore
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
preserve
xpose, clear
tempfile 5_x
save `5_x' , emptyok
local theLOCALS "`theLOCALS' 5_x" 
restore
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
preserve
xpose, clear
tempfile 6_x
save `6_x' , emptyok
local theLOCALS "`theLOCALS' 6_x" 
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (6)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 6
local theLOCALS "`theLOCALS' 6" 
save `6' , emptyok
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
preserve
xpose, clear
tempfile 7_x
save `7_x' , emptyok
local theLOCALS "`theLOCALS' 7_x" 
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (7)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 7
local theLOCALS "`theLOCALS' 7" 
save `7' , emptyok
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
preserve
xpose, clear
tempfile 8_x
save `8_x' , emptyok
local theLOCALS "`theLOCALS' 8_x" 
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (8)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 8
local theLOCALS "`theLOCALS' 8" 
save `8' , emptyok
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
preserve
xpose, clear
tempfile 9_x
save `9_x' , emptyok
local theLOCALS "`theLOCALS' 9_x" 
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (9)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 9
local theLOCALS "`theLOCALS' 9" 
save `9' , emptyok
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
preserve
xpose, clear
tempfile 10_x
save `10_x' , emptyok
local theLOCALS "`theLOCALS' 10_x" 
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (10)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 10
local theLOCALS "`theLOCALS' 10" 
save `10' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (11)  ("") ("") ("Used") ("") ("") ("") ("")    
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (11)  ("") ("") ("") ("") ("Sorted") ("") ("")  
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 11_x
save `11_x' , emptyok
local theLOCALS "`theLOCALS' 11_x" 
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (11)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 11
local theLOCALS "`theLOCALS' 11" 
save `11' , emptyok
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
preserve
xpose, clear
tempfile 12_x
save `12_x' , emptyok
local theLOCALS "`theLOCALS' 12_x" 
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (12)  ("Changed") ("") ("") ("") ("") ("") ("")  
local `theDATA' = "`r(datasignature)'" 
tempfile 12
local theLOCALS "`theLOCALS' 12" 
save `12' , emptyok
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
preserve
xpose, clear
cap cf _all using `1_x'
if _rc != 0 {
post posty (1)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
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
preserve
xpose, clear
cap cf _all using `2_x'
if _rc != 0 {
post posty (2)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `2'
if _rc != 0 {
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
preserve
xpose, clear
cap cf _all using `3_x'
if _rc != 0 {
post posty (3)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
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
preserve
xpose, clear
cap cf _all using `4_x'
if _rc != 0 {
post posty (4)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
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
preserve
xpose, clear
cap cf _all using `5_x'
if _rc != 0 {
post posty (5)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
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
preserve
xpose, clear
cap cf _all using `6_x'
if _rc != 0 {
post posty (6)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `6'
if _rc != 0 {
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
preserve
xpose, clear
cap cf _all using `7_x'
if _rc != 0 {
post posty (7)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `7'
if _rc != 0 {
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
preserve
xpose, clear
cap cf _all using `8_x'
if _rc != 0 {
post posty (8)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `8'
if _rc != 0 {
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
preserve
xpose, clear
cap cf _all using `9_x'
if _rc != 0 {
post posty (9)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `9'
if _rc != 0 {
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
preserve
xpose, clear
cap cf _all using `10_x'
if _rc != 0 {
post posty (10)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `10'
if _rc != 0 {
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
preserve
xpose, clear
cap cf _all using `11_x'
if _rc != 0 {
post posty (11)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `11'
if _rc != 0 {
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
preserve
xpose, clear
cap cf _all using `12_x'
if _rc != 0 {
post posty (12)  ("") ("") ("") ("") ("") ("ERROR! ") ("")  
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `12'
if _rc != 0 {
post posty (12)  ("") ("ERROR! ") ("") ("") ("") ("") ("")  
}
}
postclose posty
use `posty' , clear
collapse (firstnm) Data Err_1 Seed Err_2 Sort Err_3 Path , by(Line)
compress
