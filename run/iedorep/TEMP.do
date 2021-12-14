tempname allSORT allRNGS allDATA
//
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 1 of ``allRNGS'''") di as err "RNG Changed: 1"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 1 of ``allSORT'''") di as err "Data Sorted: 1"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 1 of ``allRNGS'''") di as err "RNG Changed: 2"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 1 of ``allSORT'''") di as err "Data Sorted: 2"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
clear
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 2 of ``allRNGS'''") di as err "RNG Changed: 3"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 2 of ``allSORT'''") di as err "Data Sorted: 3"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 3 of ``allRNGS'''") di as err "RNG Changed: 4"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 3 of ``allSORT'''") di as err "Data Sorted: 4"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
// set seed 12345
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 4 of ``allRNGS'''") di as err "RNG Changed: 5"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 4 of ``allSORT'''") di as err "Data Sorted: 5"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 5 of ``allRNGS'''") di as err "RNG Changed: 6"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 5 of ``allSORT'''") di as err "Data Sorted: 6"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
sysuse auto.dta
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 6 of ``allRNGS'''") di as err "RNG Changed: 7"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 6 of ``allSORT'''") di as err "Data Sorted: 7"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 7 of ``allRNGS'''") di as err "RNG Changed: 8"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 7 of ``allSORT'''") di as err "Data Sorted: 8"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
expand 2 , gen(check)
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 8 of ``allRNGS'''") di as err "RNG Changed: 9"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 8 of ``allSORT'''") di as err "Data Sorted: 9"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 9 of ``allRNGS'''") di as err "RNG Changed: 10"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 9 of ``allSORT'''") di as err "Data Sorted: 10"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
sort foreign 
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 10 of ``allRNGS'''") di as err "RNG Changed: 11"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 10 of ``allSORT'''") di as err "Data Sorted: 11"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 11 of ``allRNGS'''") di as err "RNG Changed: 12"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 11 of ``allSORT'''") di as err "Data Sorted: 12"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
gen x = _n
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 12 of ``allRNGS'''") di as err "RNG Changed: 13"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 12 of ``allSORT'''") di as err "Data Sorted: 13"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 13 of ``allRNGS'''") di as err "RNG Changed: 14"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 13 of ``allSORT'''") di as err "Data Sorted: 14"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
duplicates drop make , force
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 14 of ``allRNGS'''") di as err "RNG Changed: 15"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 14 of ``allSORT'''") di as err "Data Sorted: 15"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 

local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 15 of ``allRNGS'''") di as err "RNG Changed: 16"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 15 of ``allSORT'''") di as err "Data Sorted: 16"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 
//
local `allRNGS' = "``allRNGS'' `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 16 of ``allRNGS'''") di as err "RNG Changed: 17"  
local `allSORT' = "``allSORT'' `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 16 of ``allSORT'''") di as err "Data Sorted: 17"  
datasignature
local `allDATA' = "``allDATA'' `r(datasignature)'" 


clear // SECOND RUN STARTS HERE ------------------------------------------------

//
datasignature
if ("`r(datasignature)'" != "`: word 1 of ``allDATA'''") di as err "Data Changed: 1"  

datasignature
if ("`r(datasignature)'" != "`: word 2 of ``allDATA'''") di as err "Data Changed: 2"  
clear
datasignature
if ("`r(datasignature)'" != "`: word 3 of ``allDATA'''") di as err "Data Changed: 3"  

datasignature
if ("`r(datasignature)'" != "`: word 4 of ``allDATA'''") di as err "Data Changed: 4"  
// set seed 12345
datasignature
if ("`r(datasignature)'" != "`: word 5 of ``allDATA'''") di as err "Data Changed: 5"  

datasignature
if ("`r(datasignature)'" != "`: word 6 of ``allDATA'''") di as err "Data Changed: 6"  
sysuse auto.dta
datasignature
if ("`r(datasignature)'" != "`: word 7 of ``allDATA'''") di as err "Data Changed: 7"  

datasignature
if ("`r(datasignature)'" != "`: word 8 of ``allDATA'''") di as err "Data Changed: 8"  
expand 2 , gen(check)
datasignature
if ("`r(datasignature)'" != "`: word 9 of ``allDATA'''") di as err "Data Changed: 9"  

datasignature
if ("`r(datasignature)'" != "`: word 10 of ``allDATA'''") di as err "Data Changed: 10"  
sort foreign 
datasignature
if ("`r(datasignature)'" != "`: word 11 of ``allDATA'''") di as err "Data Changed: 11"  

datasignature
if ("`r(datasignature)'" != "`: word 12 of ``allDATA'''") di as err "Data Changed: 12"  
gen x = _n
datasignature
if ("`r(datasignature)'" != "`: word 13 of ``allDATA'''") di as err "Data Changed: 13"  

datasignature
if ("`r(datasignature)'" != "`: word 14 of ``allDATA'''") di as err "Data Changed: 14"  
duplicates drop make , force
datasignature
if ("`r(datasignature)'" != "`: word 15 of ``allDATA'''") di as err "Data Changed: 15"  

datasignature
if ("`r(datasignature)'" != "`: word 16 of ``allDATA'''") di as err "Data Changed: 16"  
//
datasignature
if ("`r(datasignature)'" != "`: word 17 of ``allDATA'''") di as err "Data Changed: 17"  
