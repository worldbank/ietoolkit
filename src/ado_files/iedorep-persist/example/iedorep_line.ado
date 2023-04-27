cap program drop iedorep_line
program define   iedorep_line, rclass

  syntax , lnum(string) datatmp(string) mode(string)

  *Check mode is write or check
  if !inlist("`mode'","write","check") {
    noi di as error "iedorep_line mode must be write or check"
  }

  * This is so long it makes testing hard - add later
  //local srng "`c(rngstate)'"

  *Get the states to be checked
  local srng "`c(sortrngstate)'"
  datasignature
  local dsig "`r(datasignature)'"

  * Write the data base file
  if ("`mode'"=="write") {
    * Open data_store file
    file open data_store using "`datatmp'", write append
    *Build data line
    local line "l`lnum'&repsrng:`srng'&repdtsig:`dsig'"
    *Write line to data store file row
    file write data_store "`line'" _n
  }


  if ("`mode'" == "check") {
    file open data_store using "`datatmp'", read
    * Get values for this line
    parse_line , target_lnum(`lnum') data_store(data_store)
    * Check sort rng for this line
    if ("`r(repsrng)'" != "`srng'") {
      noi di as error  "Sortrngstate is not the same in line number `lnum'. 1st:`r(repsrng)', 2nd:`srng'"
    }
    else {
      noi di "Match: srng `lnum'. 1st:`r(repsrng)', 2nd:`srng'"
    }

    * Check data signature for this line
    if ("`r(repdtsig)'" != "`dsig'") {
      noi di as error "Datasignature is not the same in line number `lnum'. 1st:`r(repdtsig)', 2nd:`dsig'"
    }
    else {
      noi di "Match: dsig `lnum'. 1st:`r(repdtsig)', 2nd:`dsig'"
    }
  }


  file close data_store

end

cap program drop parse_line
program define   parse_line, rclass

    syntax, target_lnum(string) data_store(string)

    * initiate while locals
    local eof = 0
    local this_lnum = 0

    * iterate until end of file (should never happen)
    * or target line found
    while `eof'== 0 & "`this_lnum'" != "`target_lnum'" {
        * Read next line
        file read data_store line
        local eof = `r(eof)'
        * Split line into line number and line data
        gettoken this_lnum data : line, parse("&")
        local data = substr("`data'",2,.) // remove parse char
        * Update this_lnum to this line number
        local this_lnum = substr("`this_lnum'",2,.)
    }

    * Output message is line was not found - this is an error
    if `eof' != 0 noi di as error "Line not found in tempfile - should never happen"
    * Parse data for line found
    else {
        * Loop over all data key value pairs
        while !missing("`data'") {
            * Parse next key:value pair of data
            gettoken keyvaluepair data : data, parse("&")
            local data = substr("`data'",2,.) // remove parse char
            * Get key and value from pair and return
            gettoken key value : keyvaluepair, parse(":")
            local value = substr("`value'",2,.) // remove parse char
            * Return the value in a r() local named after key
            return local `key' `value'
        }
    }
end
