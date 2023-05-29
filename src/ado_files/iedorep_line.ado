
* Command intended to exclusively be run from the run files
* that the command iedorep is generating

cap program drop iedorep_line
program define   iedorep_line

  syntax , lnum(string) datatmp(string) [recursestub(string) orgsubfile(string)]

  * Open data_store file
  file open data_store using "`datatmp'", write append

  * If not a recurse row then write data
  if missing("`recursestub'") {

    * This is so long it makes testing hard - add later
    //local srng "`c(rngstate)'"
    *Get the states to be checked
    local srng "`c(sortrngstate)'"
    datasignature
    local dsig "`r(datasignature)'"

    *Build data line
    local line "l:`lnum'&srng:`srng'&dsig:`dsig'"
  }
  else {
    *Build recurse instructions line
    local line `"recurse `recursestub' "`orgsubfile'" "'
  }

  *Write line and close file
  file write data_store `"`line'"' _n
  file close data_store
end
