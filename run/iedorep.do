//

global ietoolkit "/Users/bbdaniels/GitHub/ietoolkit"

do "${ietoolkit}/src/ado_files/iedorep.ado"

iedorep "${ietoolkit}/run/iedorep/iedorep-target-1.do" ///
  , debug("${ietoolkit}/run/iedorep/TEMP.do") qui

//
