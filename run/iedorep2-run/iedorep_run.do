
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
    iedorep , dofile("${clone}/run/iedorep/iedorep-target-1.do") output("${sf}/output")  compact
-
    * Example A - single file
    iedorep , dofile("${sf}/main.do") output("${sf}/output")

    * Example B - multiple file
    iedorep , dofile("${mf}/main.do") output("${mf}/output")

    * Example C - multiple file
    iedorep , dofile("${mf}/main.do") output("${mf}/output_verbose") verbose

    * Example D - multiple file
    iedorep , dofile("${lf}/main.do") output("${lf}/output") verbose
