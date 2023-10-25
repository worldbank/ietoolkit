
    * Kristoffer's root path
    if "`c(username)'" == "wb462869" {
        global clone "C:\Users\wb462869\github\ietoolkit"
    }
    * Fill in your root path here
    if "`c(username)'" == "bbdaniels" {
        global clone "/Users/bbdaniels/GitHub/ietoolkit"
    }

    * Set global to ado_fldr
    global ado_fldr "${clone}/src/ado_files"
    global run_fldr "${clone}/run/iedorep2-run"
    global sf       "${run_fldr}/single-file"
    global mf       "${run_fldr}/multi-file"
    global lf       "${run_fldr}/loop-file"

    qui do          "${ado_fldr}/iedorep.ado"
    qui do          "${ado_fldr}/iedorep_dataline.ado"

    file close _all

    * Example 0 - Ben's files
    iedorep "${clone}/run/iedorep/iedorep-target-1.do" using "${clone}/run/iedorep/"
    iedorep "${clone}/run/iedorep/iedorep-target-1.do" using "${clone}/run/iedorep/" , s(srng)
    iedorep "${clone}/run/iedorep/iedorep-target-1.do" using "${clone}/run/iedorep/" , compact  s(rng srng dsig)
    iedorep "${clone}/run/iedorep/iedorep-target-1.do"  ,  verbose debug

    * Example A - single file
    iedorep "${sf}/main.do" using "${sf}/output" , verbose

    * Example B - multiple file
    iedorep "${mf}/main.do" using "${mf}/output"

    * Example C - multiple file
    iedorep "${mf}/main.do" using "${mf}/output_verbose"

    * Example D - multiple file
    iedorep "${lf}/main.do" using "${lf}/output" , verbose
