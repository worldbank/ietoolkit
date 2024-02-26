
/*******************************************************************************
    PART 1:  Make sure repkit is installed
*******************************************************************************/

    * The rootpaths in these run files are managed with
    * the command reproot in the package repkit.
    * Make sure that you have version v1.2 or more more recent
    * installed of repkit on your computer. To set up reproot on your comptuer
    * see this article https://worldbank.github.io/repkit/articles/reproot-files.html

    * Make sure that repkit is installed
    * If not, prompt user to install it from ssc
    cap which repkit
    if _rc == 111 {
        di as error "{pstd}You need to have {cmd:repkit} installed to run this reproducibility package. Click {stata ssc install repkit, replace} to do so.{p_end}"
    }

    * Display what version of repkit you have installed - >1.2 is required
    repkit
    reproot, project("ietoolkit") roots("clone") prefix("ietk_")

    global runfldr "${ietk_clone}/run"

    * Install the version of this package in
    * the plus-ado folder in the test folder
    cap mkdir    "${runfldr}/dev-env"
    repado using "${runfldr}/dev-env"

    * Make sure repkit is installed in /dev-env/
    cap which repkit
    if _rc == 111 {
        ssc install repkit, replace
    }

/*******************************************************************************
    PART 2: run all command
*******************************************************************************/

    *This run file depends on iefolder, make sure that command is tested before this run file

    * iegitaddmd
    do "${runfldr}/iegitaddmd/iegitaddmd.do"

    * iekdensity
    do "${runfldr}/iekdensity/iekdensity.do"

    * iesave
    do "${runfldr}/iesave/iesave1.do"
    do "${runfldr}/iesave/iesave2.do"

    * iebaltab
    do "${runfldr}/iebaltab/iebaltab1.do"
    do "${runfldr}/iebaltab/iebaltab2.do"

    * ieddtab
    do "${runfldr}/ieddtab/ieddtab.do"

    * ieboilstart
    * NOTE: this runfile changes settings such that Stata needs to be re-started
    * in order to comment this file out
    do "${runfldr}/ieboilstart/ieboilstart.do"
