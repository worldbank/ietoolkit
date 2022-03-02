//

global ietoolkit "/Users/bbdaniels/GitHub/ietoolkit"

do "${ietoolkit}/src/ado_files/iedorep.ado"

iedorep "${ietoolkit}/run/iedorep/iedorep-target-1.do" ///
  , debug qui ///
    alldata allsort allseed recursive
    
iedorep "${ietoolkit}/run/iedorep/iedorep-target-clear.do" ///
  , debug qui ///
    alldata allsort allseed recursive

//
