//
global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 1 of ${allRNGS}'") di as err "RNG Changed: 1"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 1 of ${allSORT}'") di as err "Data Sorted: 1"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 

global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 1 of ${allRNGS}'") di as err "RNG Changed: 2"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 1 of ${allSORT}'") di as err "Data Sorted: 2"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 
clear
global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 2 of ${allRNGS}'") di as err "RNG Changed: 3"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 2 of ${allSORT}'") di as err "Data Sorted: 3"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 

global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 3 of ${allRNGS}'") di as err "RNG Changed: 4"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 3 of ${allSORT}'") di as err "Data Sorted: 4"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 
// set seed 12345
global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 4 of ${allRNGS}'") di as err "RNG Changed: 5"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 4 of ${allSORT}'") di as err "Data Sorted: 5"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 

global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 5 of ${allRNGS}'") di as err "RNG Changed: 6"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 5 of ${allSORT}'") di as err "Data Sorted: 6"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 
sysuse auto.dta
global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 6 of ${allRNGS}'") di as err "RNG Changed: 7"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 6 of ${allSORT}'") di as err "Data Sorted: 7"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 

global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 7 of ${allRNGS}'") di as err "RNG Changed: 8"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 7 of ${allSORT}'") di as err "Data Sorted: 8"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 
expand 2 , gen(check)
global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 8 of ${allRNGS}'") di as err "RNG Changed: 9"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 8 of ${allSORT}'") di as err "Data Sorted: 9"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 

global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 9 of ${allRNGS}'") di as err "RNG Changed: 10"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 9 of ${allSORT}'") di as err "Data Sorted: 10"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 
sort foreign 
global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 10 of ${allRNGS}'") di as err "RNG Changed: 11"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 10 of ${allSORT}'") di as err "Data Sorted: 11"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 

global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 11 of ${allRNGS}'") di as err "RNG Changed: 12"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 11 of ${allSORT}'") di as err "Data Sorted: 12"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 
gen x = _n
global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 12 of ${allRNGS}'") di as err "RNG Changed: 13"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 12 of ${allSORT}'") di as err "Data Sorted: 13"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 

global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 13 of ${allRNGS}'") di as err "RNG Changed: 14"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 13 of ${allSORT}'") di as err "Data Sorted: 14"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 
//
global allRNGS = "${allRNGS} `c(rngstate)'" 
if ("`c(rngstate)'" != "`: word 14 of ${allRNGS}'") di as err "RNG Changed: 15"  
global allSORT = "${allSORT} `c(sortrngstate)'" 
if ("`c(sortrngstate)'" != "`: word 14 of ${allSORT}'") di as err "Data Sorted: 15"  
datasignature
global allDATA = "${allDATA} `r(datasignature)'" 


clear // SECOND RUN STARTS HERE ------------------------------------------------

//
datasignature
if ("`r(datasignature)'" != "`: word 1 of ${allDATA}'") di as err "Data Changed: 1"  

datasignature
if ("`r(datasignature)'" != "`: word 2 of ${allDATA}'") di as err "Data Changed: 2"  
clear
datasignature
if ("`r(datasignature)'" != "`: word 3 of ${allDATA}'") di as err "Data Changed: 3"  

datasignature
if ("`r(datasignature)'" != "`: word 4 of ${allDATA}'") di as err "Data Changed: 4"  
// set seed 12345
datasignature
if ("`r(datasignature)'" != "`: word 5 of ${allDATA}'") di as err "Data Changed: 5"  

datasignature
if ("`r(datasignature)'" != "`: word 6 of ${allDATA}'") di as err "Data Changed: 6"  
sysuse auto.dta
datasignature
if ("`r(datasignature)'" != "`: word 7 of ${allDATA}'") di as err "Data Changed: 7"  

datasignature
if ("`r(datasignature)'" != "`: word 8 of ${allDATA}'") di as err "Data Changed: 8"  
expand 2 , gen(check)
datasignature
if ("`r(datasignature)'" != "`: word 9 of ${allDATA}'") di as err "Data Changed: 9"  

datasignature
if ("`r(datasignature)'" != "`: word 10 of ${allDATA}'") di as err "Data Changed: 10"  
sort foreign 
datasignature
if ("`r(datasignature)'" != "`: word 11 of ${allDATA}'") di as err "Data Changed: 11"  

datasignature
if ("`r(datasignature)'" != "`: word 12 of ${allDATA}'") di as err "Data Changed: 12"  
gen x = _n
datasignature
if ("`r(datasignature)'" != "`: word 13 of ${allDATA}'") di as err "Data Changed: 13"  

datasignature
if ("`r(datasignature)'" != "`: word 14 of ${allDATA}'") di as err "Data Changed: 14"  
//
datasignature
if ("`r(datasignature)'" != "`: word 15 of ${allDATA}'") di as err "Data Changed: 15"  
