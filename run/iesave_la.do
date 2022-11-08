
do "src/ado_files/ietoolkit.ado"
do "src/ado_files/iesave.ado"

sysuse auto, clear

cap iesave "run/output/iesave/auto.dta", id(make)
assert _rc == 101

iesave using "run/output/iesave/auto.dta", id(make) dtaversion(17.0) replace
cap confirm file "run/output/iesave/auto.dta"
assert !_rc

cap iesave using "run/output/iesave/auto.dta", id(make) dtaversion(17.0)
assert _rc == 602

iesave using "run/output/iesave/auto.dta", id(make) dtaversion(17.0) replace
use "run/output/iesave/auto.dta", clear
char list _dta[]
assert "`r(computerid)'" == "Computer ID withheld, see option userinfo in command iesave."
assert "`r(username)'" == "Username withheld, see option userinfo in command iesave."

iesave using "run/output/iesave/auto-userinfo.dta", id(make) dtaversion(17.0) userinfo replace
use "run/output/iesave/auto-userinfo.dta", clear
assert "`r(computerid)'" != "Computer ID withheld, see option userinfo in command iesave."
assert "`r(username)'" != "Username withheld, see option userinfo in command iesave."

iesave using "run/output/iesave/auto.dta", id(make) dtaversion(17.0) report replace
iesave using "run/output/iesave/auto-userinfo.dta", id(make) dtaversion(17.0) report userinfo replace
iesave using "run/output/iesave/auto-noalpha.dta", id(make) dtaversion(17.0) report noalpha userinfo replace
iesave using "run/output/iesave/auto-path.dta", id(make) dtaversion(17.0) reportpath("run/output/iesave/my-path.md", replace) userinfo replace
iesave using "run/output/iesave/auto-path-csv.dta", id(make) dtaversion(17.0) reportpath("run/output/iesave/my-path.csv", replace) userinfo replace
iesave using "run/output/iesave/auto-paths.dta", id(make) dtaversion(17.0) reportpath("run/output/iesave/my-paths.csv", replace) userinfo replace


iesave using "run/output/iesave/auto-csv.dta", id(make) dtaversion(17.0) csv report replace
