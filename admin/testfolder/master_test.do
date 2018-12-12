

    *But then we need to load the test functioins
    if c(username) == "kbrkb" global testfolder "C:\Users\kbrkb\Documents\GitHub\ietoolkit\admin\testfolder"

    cd "$testfolder"

    /************************************
        Define individual folder paths
    ************************************/

    ieboilstart , version(11)
    `r(version)'

    /************************************
        Define all commands
    ************************************/

    local ietoolkit_commands ietoolkit //iebaltab ieddtab ieduplicates iecompdup ieboilstart iefolder iegitaddmd iematch iegraph iedropone ieboilsave

    /************************************
        Run all test files
    ************************************/

    foreach command of local ietoolkit_commands {
        do "$testfolder/testfiles/test_`command'.do"
    }
