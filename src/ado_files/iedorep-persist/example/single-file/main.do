clear
set obs 10
gen height = 3
gen width ///
  = runiform()

if (1) {
  replace width  = width / 2
}
