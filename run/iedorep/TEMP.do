tempname allSORT theRNG allRNGS whichRNG allDATA
local `theRNG' = "`c(rngstate)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 1"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 1 of ``allSORT'''") di as err "Data Sorted: 1"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 2"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 1 of ``allSORT'''") di as err "Data Sorted: 2"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
clear
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 3"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 2 of ``allSORT'''") di as err "Data Sorted: 3"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 4"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 3 of ``allSORT'''") di as err "Data Sorted: 4"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
// set seed 12345
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 5"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 4 of ``allSORT'''") di as err "Data Sorted: 5"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 6"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 5 of ``allSORT'''") di as err "Data Sorted: 6"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 7"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 6 of ``allSORT'''") di as err "Data Sorted: 7"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 8"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 7 of ``allSORT'''") di as err "Data Sorted: 8"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 9"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 8 of ``allSORT'''") di as err "Data Sorted: 9"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 10"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 9 of ``allSORT'''") di as err "Data Sorted: 10"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 11"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 10 of ``allSORT'''") di as err "Data Sorted: 11"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 12"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 11 of ``allSORT'''") di as err "Data Sorted: 12"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 13"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 12 of ``allSORT'''") di as err "Data Sorted: 13"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 14"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 13 of ``allSORT'''") di as err "Data Sorted: 14"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 15"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 14 of ``allSORT'''") di as err "Data Sorted: 15"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 16"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 15 of ``allSORT'''") di as err "Data Sorted: 16"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 17"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 16 of ``allSORT'''") di as err "Data Sorted: 17"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
di as err "RNG Advanced: 18"  
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 17 of ``allSORT'''") di as err "Data Sorted: 18"  
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
if ("`r(datasignature)'" != "`: word 1 of ``allDATA'''") di as err "Data Changed: 1"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 2"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 2 of ``allDATA'''") di as err "Data Changed: 2"  
clear
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 3"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 3 of ``allDATA'''") di as err "Data Changed: 3"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 4"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 4 of ``allDATA'''") di as err "Data Changed: 4"  
// set seed 12345
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 5"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 5 of ``allDATA'''") di as err "Data Changed: 5"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 6"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 6 of ``allDATA'''") di as err "Data Changed: 6"  
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 7"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 7 of ``allDATA'''") di as err "Data Changed: 7"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 8"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 8 of ``allDATA'''") di as err "Data Changed: 8"  
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 9"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 9 of ``allDATA'''") di as err "Data Changed: 9"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 10"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 10 of ``allDATA'''") di as err "Data Changed: 10"  
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 11"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 11 of ``allDATA'''") di as err "Data Changed: 11"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 12"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 12 of ``allDATA'''") di as err "Data Changed: 12"  
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 13"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 13 of ``allDATA'''") di as err "Data Changed: 13"  
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 14"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 14 of ``allDATA'''") di as err "Data Changed: 14"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 15"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 15 of ``allDATA'''") di as err "Data Changed: 15"  
duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 16"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 16 of ``allDATA'''") di as err "Data Changed: 16"  

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 17"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 17 of ``allDATA'''") di as err "Data Changed: 17"  
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 18"  
}
}
datasignature
if ("`r(datasignature)'" != "`: word 18 of ``allDATA'''") di as err "Data Changed: 18"  
