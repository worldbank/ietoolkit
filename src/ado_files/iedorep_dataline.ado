
* Command intended to exclusively be run from the run files
* that the command iedorep is generating

cap program drop iedorep_dataline
program define   iedorep_dataline

  syntax , run(string)    ///
    lnum(string) datatmp(string)           [ ///
    recursestub(string) orgsubfile(string)   ///
    looptracker(string) ]

  * Open data_store file
  file open data_store using "`datatmp'", write append

  * If not a recurse row then write data
  if missing("`recursestub'") {

    * This is so long it makes testing hard - add later
    local rng "`c(rngstate)'"
    *Get the states to be checked
    local srng "`c(sortrngstate)'"
    datasignature
    local dsig "`r(datasignature)'"

    * Trim data
    local loopt = trim("`looptracker'")

    * Handle data line
    local output = substr(`"`datatmp'"',1,strrpos(`"`datatmp'"',"/"))
    local data = "`lnum'_`looptracker'"
    local data = subinstr("`data'"," ","_",.)
    local data = subinstr("`data'",":","-",.)
    if `run' == 1 {
      cap mkdir "`output'/dta/"
      save "`output'/dta/`data'.dta" , replace emptyok
      local srngcheck = _rc
    }
    if `run' == 2 {
      local output = subinstr(`"`output'"',"run2","run1",.)
      cap cf _all using "`output'/dta/`data'.dta"
      local srngcheck = _rc
    }

    *Build data line
    local line "l:`lnum'&rng:`rng'&srngstate:`srng'&dsig:`dsig'&loopt:`loopt'&srngcheck:`srngcheck'"
  }

  * Recurse line
  else {
    *Build recurse instructions line
    local line `"recurse `recursestub' "`orgsubfile'" "'
  }

  *Write line and close file
  file write data_store `"`line'"' _n
  file close data_store
end
