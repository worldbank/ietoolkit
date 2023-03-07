
    cap program drop write_line
    program define   write_line, rclass
        
        syntax, lnum(string) tmpname(string) data1(string) data2(string)
        
        file write `tmpname' "l`lnum'&d1:`data1'&d2:`data2'" _n
        
    end
    
    
    cap program drop find_and_read_line
    program define   find_and_read_line, rclass
        
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
        if `eof' != 0 {
            noi di as error "Line not found in tempfile"
        }
        
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
        
        timer off 50
        timer list
        local duration = `r(t50)'
        return local duration `duration'

    end
    