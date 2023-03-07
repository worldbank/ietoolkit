* gen dummmy-tempfiles

    // persistant prototype

    * Kristoffer's root path
    if "`c(username)'" == "wb462869" {
        global clone "C:\Users\wb462869\github\ietoolkit"
    }
    * Fill in your root path here
    if "`c(username)'" == "" {
        global clone ""
    }
    * Set global to ado_fldr
    global ado_fldr "${clone}/src/ado_files"
    global pf "${ado_fldr}/iedorep-persist"
    
    qui do "${pf}/persist-cmd.do"

    local maxlines "10 100 1000 10000 100000"

    foreach maxline of local maxlines {
        
        timer clear
        timer on 1
        
        tempfile dofile`maxline'
        tempname tmpname
        
        file open  `tmpname' using `dofile`maxline'', write replace

        forvalues line = 1/`maxline' {
            write_line               ///
             ,  lnum("`line'")       ///
                tmpname("`tmpname'") ///
                data1("d1-`line'")   ///
                data2("d2-`line'")
        }
        
        file close `tmpname'
        
        timer off 1
        timer list
        
        copy `dofile`maxline'' "${pf}/dummy-temp_`maxline'", replace
    }
    
    
    noi di "Searching data"
    
    tempname   tmpname
    file open `tmpname' using `dofile100000', read 
    find_and_read_line, target_lnum(99999) tmpname(`tmpname')
    return list
    
    
    
    