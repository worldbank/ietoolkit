* this global is set in the file ietoolkit\run\iedorep2-run\iedorep_run.do
local clone "${clone}"
local fldr  "`clone'/run/iedorep2-run/multi-file"

clear
set obs 10
do "`fldr'/B sub1.do"
do `fldr'/B-sub2.do
