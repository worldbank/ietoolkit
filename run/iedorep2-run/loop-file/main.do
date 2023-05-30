clear
set obs 10
local setseed = 1

forvalues i = 1/5 {
  gen rand`i' = runiform()
}

if `setseed' == 1 {
  set seed 123452
}

foreach crop in banana corn wheat {
  if ("a"=="a") gen c`crop' = 1
  forvalues plot = 1/3 {
    gen c`crop'_p`plot' = runiform()
  }
}

local x = 0
while (`x'<3) {
  gen new_var`x' = 1
  local ++x
}
