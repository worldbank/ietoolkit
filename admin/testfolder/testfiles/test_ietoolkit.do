qui {

    noi di ""
    noi di ""
    noi di "{pstd}Start testing command [ietoolkit]{p_end}"
    noi di ""

    /************************************
        Run cscript
    ************************************/

    *This clears all things in memory, this is recommended to 
    cscript

    /************************************
        Load test functions
    ************************************/

    *Must be done here as cscript clears all items in memory
    do  "testfunctions.do"


    /************************************
        Run Command - Try 1
    ************************************/

    ietoolkit

    noi test_returns, command("ietoolkit - Try 1") name("version")      type("scalar") value(`r(version)') number
    noi test_returns, command("ietoolkit - Try 1") name("versiondate")  type("local") value(`r(versiondate)')

    noi di ""
    noi di "{pstd}Finished testing command [ietoolkit] without any errors.{p_end}"
}
