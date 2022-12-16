//

clear all

sysuse auto.dta

ieboilstart , version(13)
  `r(version)'
clear *
sysuse auto.dta , clear

//
