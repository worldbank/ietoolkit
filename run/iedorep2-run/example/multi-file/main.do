local clone "C:\Users\wb462869\github\ietoolkit"
local fldr  "`clone'\src\ado_files\iedorep-persist\example\multi-file"

clear
set obs 10
do "`fldr'/B sub1.do"
do `fldr'/B-sub2.do
