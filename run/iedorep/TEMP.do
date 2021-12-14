tempname theSORT theRNG allRNGS whichRNG allDATA
local `theRNG' = "`c(rngstate)'" 
local `theSORT' = "`c(sortrngstate)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 1"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 1"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 2"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 2"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
clear
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 3"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 3"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 4"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 4"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
// set seed 12345
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 5"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 5"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 6"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 6"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 7"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 7"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 8"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 8"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 9"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 9"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 10"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 10"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 11"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 11"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 12"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 12"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 13"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 13"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 14"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 14"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 15"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 15"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 16"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 16"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 17"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 17"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Used: 18"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
di as err "Sort RNG Used: 18"  
local `theSORT' = "`c(sortrngstate)'" 
}
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 


clear // SECOND RUN STARTS HERE ------------------------------------------------

local `theRNG' = "`c(rngstate)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 1"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 0 of ``allDATA'''") di as err "Data Changed: 1"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 2"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 1 of ``allDATA'''") di as err "Data Changed: 2"  
clear
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 3"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 2 of ``allDATA'''") di as err "Data Changed: 3"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 4"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 3 of ``allDATA'''") di as err "Data Changed: 4"  
// set seed 12345
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 5"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 4 of ``allDATA'''") di as err "Data Changed: 5"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 6"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 5 of ``allDATA'''") di as err "Data Changed: 6"  
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 7"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 6 of ``allDATA'''") di as err "Data Changed: 7"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 8"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 7 of ``allDATA'''") di as err "Data Changed: 8"  
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 9"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 8 of ``allDATA'''") di as err "Data Changed: 9"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 10"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 9 of ``allDATA'''") di as err "Data Changed: 10"  
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 11"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 10 of ``allDATA'''") di as err "Data Changed: 11"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 12"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 11 of ``allDATA'''") di as err "Data Changed: 12"  
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 13"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 12 of ``allDATA'''") di as err "Data Changed: 13"  
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 14"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 13 of ``allDATA'''") di as err "Data Changed: 14"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 15"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 14 of ``allDATA'''") di as err "Data Changed: 15"  
duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 16"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 15 of ``allDATA'''") di as err "Data Changed: 16"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 17"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 16 of ``allDATA'''") di as err "Data Changed: 17"  
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 18"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 17 of ``allDATA'''") di as err "Data Changed: 18"  
