version 12.0

cd "C:\Users\wb503680\Box Sync\DIME WOrk\GitFolder\ietoolkit\test"

do "C:\Users\wb503680\Box Sync\DIME WOrk\GitFolder\ietoolkit\ieimpgraph2.do"


sysuse auto, replace
gen weight2 = 1 if weight >= 3019.5
replace weight2 = 0 if weight2 == .

reg price foreign weight2 
ieimpgraph foreign weight2
tab rep78, gen(newvar1_)

drop newvar1_1

regress price newvar1_*
ieimpgraph newvar1_*
