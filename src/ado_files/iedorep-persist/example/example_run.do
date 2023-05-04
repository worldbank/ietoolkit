
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
    global pf       "${ado_fldr}/iedorep-persist"
    global ex       "${pf}/example"
    global ex1      "${ex}/single-file"
    global ex2      "${ex}/multi-file"
    
    //qui do          "${pf}/persist-cmd.do"
    qui do          "${ex}/iedorep.ado"
    qui do          "${ex}/iedorep_line.ado"
    
    file close _all 
    
    * Example A - single file
    iedorep , dofile("${ex1}/main.do") output("${ex1}/output")
    
    * Example B - multiple file
    iedorep , dofile("${ex2}/main.do") output("${ex2}/output")