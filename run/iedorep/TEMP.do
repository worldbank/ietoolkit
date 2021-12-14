tempname theSORT theRNG allRNGS whichRNG allDATA theDATA
local `theRNG' = "`c(rngstate)'" 
local `theSORT' = "`c(sortrngstate)'" 
datasignature
local `theDATA' = "`r(datasignature)'" 
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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 1"  
local `theDATA' = "`r(datasignature)'" 
tempfile 1
save `1'
}

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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 2"  
local `theDATA' = "`r(datasignature)'" 
tempfile 2
save `2'
}
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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 3"  
local `theDATA' = "`r(datasignature)'" 
tempfile 3
save `3'
}

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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 4"  
local `theDATA' = "`r(datasignature)'" 
tempfile 4
save `4'
}
/// set seed 12345

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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 5"  
local `theDATA' = "`r(datasignature)'" 
tempfile 5
save `5'
}
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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 7"  
local `theDATA' = "`r(datasignature)'" 
tempfile 7
save `7'
}

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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 8"  
local `theDATA' = "`r(datasignature)'" 
tempfile 8
save `8'
}
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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 9"  
local `theDATA' = "`r(datasignature)'" 
tempfile 9
save `9'
}

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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 10"  
local `theDATA' = "`r(datasignature)'" 
tempfile 10
save `10'
}
/// sort foreign

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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 11"  
local `theDATA' = "`r(datasignature)'" 
tempfile 11
save `11'
}
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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 13"  
local `theDATA' = "`r(datasignature)'" 
tempfile 13
save `13'
}
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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 14"  
local `theDATA' = "`r(datasignature)'" 
tempfile 14
save `14'
}

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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 15"  
local `theDATA' = "`r(datasignature)'" 
tempfile 15
save `15'
}
// duplicates drop make , force
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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 16"  
local `theDATA' = "`r(datasignature)'" 
tempfile 16
save `16'
}

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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 17"  
local `theDATA' = "`r(datasignature)'" 
tempfile 17
save `17'
}
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
if ("`r(datasignature)'" != "``theDATA''") {
di as err "Data Changed: 18"  
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
di as err "RNG ERROR: 1"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `1'
if _rc != 0 {
di as err "Data ERROR: 1"  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 2"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `2'
if _rc != 0 {
di as err "Data ERROR: 2"  
}
}
clear
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 3"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `3'
if _rc != 0 {
di as err "Data ERROR: 3"  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 4"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `4'
if _rc != 0 {
di as err "Data ERROR: 4"  
}
}
/// set seed 12345

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 5"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `5'
if _rc != 0 {
di as err "Data ERROR: 5"  
}
}
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 7"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `7'
if _rc != 0 {
di as err "Data ERROR: 7"  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 8"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `8'
if _rc != 0 {
di as err "Data ERROR: 8"  
}
}
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 9"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `9'
if _rc != 0 {
di as err "Data ERROR: 9"  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 10"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `10'
if _rc != 0 {
di as err "Data ERROR: 10"  
}
}
/// sort foreign

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 11"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `11'
if _rc != 0 {
di as err "Data ERROR: 11"  
}
}
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 13"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `13'
if _rc != 0 {
di as err "Data ERROR: 13"  
}
}
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 14"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `14'
if _rc != 0 {
di as err "Data ERROR: 14"  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 15"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `15'
if _rc != 0 {
di as err "Data ERROR: 15"  
}
}
// duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 16"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `16'
if _rc != 0 {
di as err "Data ERROR: 16"  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 17"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `17'
if _rc != 0 {
di as err "Data ERROR: 17"  
}
}
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
di as err "RNG ERROR: 18"  
}
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `18'
if _rc != 0 {
di as err "Data ERROR: 18"  
}
}
