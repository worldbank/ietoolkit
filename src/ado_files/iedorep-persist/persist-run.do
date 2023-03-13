
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
    
    tempname perstist_tempname
    tempfile perstist_tempfile
    
    global tempname `perstist_tempname'
    
    * Write run
    file open `perstist_tempname' using `perstist_tempfile', write 
    global check "false"
    do  "${pf}/persist-mockoutput.do"
    file close `perstist_tempname'
    
    copy `perstist_tempfile' "${pf}/persist-tempfile", replace
    
    file open `perstist_tempname' using `perstist_tempfile', read 
    global check "true"
    do  "${pf}/persist-mockoutput.do"
    file close `perstist_tempname'