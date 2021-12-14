tempname theSORT theRNG allRNGS whichRNG allDATA theDATA
tempfile posty
postfile posty Line str15(Data Seed Flag_1 Flag_2 Flag_3) using `posty' , replace
local `theRNG' = "`c(rngstate)'" 
local `theSORT' = "`c(sortrngstate)'" 
datasignature
local `theDATA' = "`r(datasignature)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
post posty (1) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (1) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (1) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 1
save `1'
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (2) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (2) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (2) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 2
save `2'
}
clear
if ("`c(rngstate)'" != "``theRNG''") {
post posty (3) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (3) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (3) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 3
save `3'
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (4) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (4) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (4) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 4
save `4'
}
/// set seed 12345

if ("`c(rngstate)'" != "``theRNG''") {
post posty (5) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (5) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (5) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 5
save `5'
}
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
post posty (7) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (7) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (7) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 7
save `7'
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (8) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (8) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (8) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 8
save `8'
}
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
post posty (9) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (9) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (9) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 9
save `9'
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (10) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (10) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (10) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 10
save `10'
}
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
post posty (11) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (11) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (11) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 11
save `11'
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (12) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (12) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (12) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 12
save `12'
}
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
post posty (13) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (13) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (13) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 13
save `13'
}
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
post posty (14) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (14) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (14) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 14
save `14'
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (15) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (15) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (15) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 15
save `15'
}
// duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
post posty (16) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (16) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (16) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 16
save `16'
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (17) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (17) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (17) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 17
save `17'
}
//
if ("`c(rngstate)'" != "``theRNG''") {
post posty (18) ("") ("") ("Seed Used") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (18) ("") ("") ("") ("") ("Sortseed Used") 
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (18) ("") ("") ("") ("Data Changed") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 18
save `18'
}


clear // SECOND RUN STARTS HERE ------------------------------------------------

local `theRNG' = "`c(rngstate)'" 
datasignature
local `theDATA' = "`r(datasignature)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (1) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `1'
if _rc != 0 {
post posty (1) ("ERROR") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (2) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `2'
if _rc != 0 {
post posty (2) ("ERROR") ("") ("") ("") ("")  
}
}
clear
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (3) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `3'
if _rc != 0 {
post posty (3) ("ERROR") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (4) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `4'
if _rc != 0 {
post posty (4) ("ERROR") ("") ("") ("") ("")  
}
}
/// set seed 12345

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (5) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `5'
if _rc != 0 {
post posty (5) ("ERROR") ("") ("") ("") ("")  
}
}
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (7) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `7'
if _rc != 0 {
post posty (7) ("ERROR") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (8) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `8'
if _rc != 0 {
post posty (8) ("ERROR") ("") ("") ("") ("")  
}
}
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (9) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `9'
if _rc != 0 {
post posty (9) ("ERROR") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (10) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `10'
if _rc != 0 {
post posty (10) ("ERROR") ("") ("") ("") ("")  
}
}
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (11) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `11'
if _rc != 0 {
post posty (11) ("ERROR") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (12) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `12'
if _rc != 0 {
post posty (12) ("ERROR") ("") ("") ("") ("")  
}
}
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (13) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `13'
if _rc != 0 {
post posty (13) ("ERROR") ("") ("") ("") ("")  
}
}
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (14) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `14'
if _rc != 0 {
post posty (14) ("ERROR") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (15) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `15'
if _rc != 0 {
post posty (15) ("ERROR") ("") ("") ("") ("")  
}
}
// duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (16) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `16'
if _rc != 0 {
post posty (16) ("ERROR") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (17) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `17'
if _rc != 0 {
post posty (17) ("ERROR") ("") ("") ("") ("")  
}
}
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (18) ("") ("ERROR") ("") ("") ("")  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `18'
if _rc != 0 {
post posty (18) ("ERROR") ("") ("") ("") ("")  
}
}
postclose posty
use `posty' , clear
collapse (firstnm) D* S* F* , by(Line)
