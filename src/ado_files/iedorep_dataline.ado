
* Command intended to exclusively be run from the run files
* that the command iedorep is generating

cap program drop iedorep_dataline
program define   iedorep_dataline

  syntax , lnum(string) datatmp(string)    [ ///
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

    *Build data line
    local line "l:`lnum'&rng:`rng'&srng:`srng'&dsig:`dsig'&loopt:`loopt'"
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