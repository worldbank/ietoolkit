    cap program drop write_or_check_line
    program define   write_or_check_line, rclass

      syntax, lnum(string) tmpname(string) check(string)

      if "`check'" == "false" {
        write_line, lnum("`lnum'") tmpname("`tmpname'")
      }
      else if "`check'" == "true" {
        parse_line, target_lnum("`lnum'") tmpname("`tmpname'")

        * checks states
        // if ("`r(reprng)'" != "`c(rngstate)'") {
        //   noi di "Rngstate is the same in line number `lnum'. 1st:`r(reprng)', 2nd:`c(rngstate)'"
        // }
        if ("`r(repsrng)'" != "`c(sortrngstate)'") {
          noi di "Sortrngstate is not the same in line number `lnum'. 1st:`r(repsrng)', 2nd:`c(sortrngstate)'"
        }
        local repdtsig "`r(repdtsig)'"
        datasignature
        if ("`repdtsig'" != "`r(datasignature)'") {
          noi di "Datasignature is not the same in line number `lnum'. 1st:`repdtsig', 2nd:`r(datasignature)'"
        }
      }
    end


    cap program drop write_line
    program define   write_line, rclass
        syntax, lnum(string) tmpname(string)

        local line "l`lnum'"
        // local line "`line'&reprng:`c(rngstate)'"
        local line "`line'&repsrng:`c(sortrngstate)'"
        datasignature
        local line "`line'&repdtsig:`r(datasignature)'"
        file write `tmpname' "`line'" _n

    end


    cap program drop parse_line
    program define   parse_line, rclass

        syntax, target_lnum(string) tmpname(string)
        timer on 50
        * initiate while locals
        local eof = 0
        local this_lnum = 0

        * iterate until end of file or target line found
        while `eof'== 0 & "`this_lnum'" != "`target_lnum'" {
            * Read next line
            file read `tmpname' line
            local eof = `r(eof)'
            * Split line into line number and line data
            gettoken this_lnum data : line, parse("&")
            local data = substr("`data'",2,.) // remove parse char
            * Update this_lnum to this line number
            local this_lnum = substr("`this_lnum'",2,.)
        }

        * Output message is line was not found - this is an error
        if `eof' != 0 noi di as error "Line not found in tempfile"
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

        // timer off 50
        // timer list
        // local duration = `r(t50)'
        // return local duration `duration'

    end
