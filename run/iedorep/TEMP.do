tempname theSORT theRNG allRNGS whichRNG allDATA theDATA
tempfile posty
postfile posty Line str15(Data Err_1 Seed Err_2 Sort Err_3) using `posty' , replace
local `theRNG' = "`c(rngstate)'" 
local `theSORT' = "`c(sortrngstate)'" 
datasignature
local `theDATA' = "`r(datasignature)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
post posty (1) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (1) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 1_x
save `1_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (1) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 1
save `1' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (2) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (2) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 2_x
save `2_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (2) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 2
save `2' , emptyok
}
clear
if ("`c(rngstate)'" != "``theRNG''") {
post posty (3) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (3) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 3_x
save `3_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (3) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 3
save `3' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (4) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (4) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 4_x
save `4_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (4) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 4
save `4' , emptyok
}
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
post posty (5) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (5) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 5_x
save `5_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (5) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 5
save `5' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (6) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (6) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 6_x
save `6_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (6) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 6
save `6' , emptyok
}
#d cr
if ("`c(rngstate)'" != "``theRNG''") {
post posty (7) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (7) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 7_x
save `7_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (7) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 7
save `7' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (8) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (8) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 8_x
save `8_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (8) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 8
save `8' , emptyok
}
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
post posty (9) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (9) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 9_x
save `9_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (9) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 9
save `9' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (10) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (10) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 10_x
save `10_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (10) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 10
save `10' , emptyok
}
isid make check, sort
if ("`c(rngstate)'" != "``theRNG''") {
post posty (11) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (11) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 11_x
save `11_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (11) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 11
save `11' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (12) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (12) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 12_x
save `12_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (12) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 12
save `12' , emptyok
}
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
post posty (13) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (13) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 13_x
save `13_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (13) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 13
save `13' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (14) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (14) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 14_x
save `14_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (14) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 14
save `14' , emptyok
}
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
post posty (15) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (15) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 15_x
save `15_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (15) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 15
save `15' , emptyok
}
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
post posty (16) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (16) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 16_x
save `16_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (16) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 16
save `16' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (17) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (17) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 17_x
save `17_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (17) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 17
save `17' , emptyok
}
set seed 123455
if ("`c(rngstate)'" != "``theRNG''") {
post posty (18) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (18) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 18_x
save `18_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (18) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 18
save `18' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (19) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (19) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 19_x
save `19_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (19) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 19
save `19' , emptyok
}
duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
post posty (20) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (20) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 20_x
save `20_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (20) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 20
save `20' , emptyok
}

if ("`c(rngstate)'" != "``theRNG''") {
post posty (21) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (21) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 21_x
save `21_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (21) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 21
save `21' , emptyok
}
//
if ("`c(rngstate)'" != "``theRNG''") {
post posty (22) ("") ("") ("Used") ("") ("") ("")   
local `theRNG' = "`c(rngstate)'" 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
}
if ("`c(sortrngstate)'" != "``theSORT''") {
post posty (22) ("") ("") ("") ("") ("Sorted") ("") 
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
tempfile 22_x
save `22_x' , emptyok
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
post posty (22) ("Changed") ("") ("") ("") ("") ("") 
local `theDATA' = "`r(datasignature)'" 
tempfile 22
save `22' , emptyok
}

di -.3842286719069723
clear // SECOND RUN STARTS HERE ------------------------------------------------

local `theRNG' = "`c(rngstate)'" 
local `theSORT' = "`c(sortrngstate)'" 
datasignature
local `theDATA' = "`r(datasignature)'" 
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (1) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `1_x'
if _rc != 0 {
post posty (1) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `1'
if _rc != 0 {
post posty (1) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (2) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `2_x'
if _rc != 0 {
post posty (2) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `2'
if _rc != 0 {
post posty (2) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
clear
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (3) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `3_x'
if _rc != 0 {
post posty (3) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `3'
if _rc != 0 {
post posty (3) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (4) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `4_x'
if _rc != 0 {
post posty (4) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `4'
if _rc != 0 {
post posty (4) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
sysuse auto.dta
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (5) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `5_x'
if _rc != 0 {
post posty (5) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `5'
if _rc != 0 {
post posty (5) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (6) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `6_x'
if _rc != 0 {
post posty (6) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `6'
if _rc != 0 {
post posty (6) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
#d cr
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (7) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `7_x'
if _rc != 0 {
post posty (7) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `7'
if _rc != 0 {
post posty (7) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (8) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `8_x'
if _rc != 0 {
post posty (8) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `8'
if _rc != 0 {
post posty (8) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
expand 2 , gen(check)
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (9) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `9_x'
if _rc != 0 {
post posty (9) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `9'
if _rc != 0 {
post posty (9) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (10) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `10_x'
if _rc != 0 {
post posty (10) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `10'
if _rc != 0 {
post posty (10) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
isid make check, sort
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (11) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `11_x'
if _rc != 0 {
post posty (11) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `11'
if _rc != 0 {
post posty (11) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (12) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `12_x'
if _rc != 0 {
post posty (12) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `12'
if _rc != 0 {
post posty (12) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
sort foreign
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (13) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `13_x'
if _rc != 0 {
post posty (13) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `13'
if _rc != 0 {
post posty (13) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (14) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `14_x'
if _rc != 0 {
post posty (14) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `14'
if _rc != 0 {
post posty (14) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
gen x = _n
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (15) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `15_x'
if _rc != 0 {
post posty (15) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `15'
if _rc != 0 {
post posty (15) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
gen y = rnormal()
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (16) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `16_x'
if _rc != 0 {
post posty (16) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `16'
if _rc != 0 {
post posty (16) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (17) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `17_x'
if _rc != 0 {
post posty (17) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `17'
if _rc != 0 {
post posty (17) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
set seed 123455
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (18) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `18_x'
if _rc != 0 {
post posty (18) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `18'
if _rc != 0 {
post posty (18) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (19) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `19_x'
if _rc != 0 {
post posty (19) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `19'
if _rc != 0 {
post posty (19) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
duplicates drop make , force
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (20) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `20_x'
if _rc != 0 {
post posty (20) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `20'
if _rc != 0 {
post posty (20) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}

if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (21) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `21_x'
if _rc != 0 {
post posty (21) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `21'
if _rc != 0 {
post posty (21) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
//
if ("`c(rngstate)'" != "``theRNG''") {
local `whichRNG' = ``whichRNG'' + 1
local `theRNG' = "`c(rngstate)'" 
if ("`c(rngstate)'" != "`: word ``whichRNG'' of ``allRNGS'''") {
post posty (22) ("") ("") ("") ("ERROR! ") ("") ("")  
}
}
if ("`c(sortrngstate)'" != "``theSORT''") {
local `theSORT' = "`c(sortrngstate)'" 
preserve
xpose, clear
cap cf _all using `22_x'
if _rc != 0 {
post posty (22) ("") ("") ("") ("") ("") ("ERROR! ") 
}
restore
}
datasignature
if ("`r(datasignature)'" != "``theDATA''") {
local `theDATA' = "`r(datasignature)'" 
cap cf _all using `22'
if _rc != 0 {
post posty (22) ("") ("ERROR! ") ("") ("") ("") ("")  
}
}
postclose posty
use `posty' , clear
collapse (firstnm) Data Err_1 Seed Err_2 Sort Err_3 , by(Line)
compress