
/*******************************************************************************
    PART 1:  Folder paths
*******************************************************************************/

    * Add the path to your local clone of the [ietoolkit] repo
    if "`c(username)'" == "WB462869" {
        global ietoolkit_clone   "C:\Users\wb462869\GitHub\ietoolkit"
    }
    
    if "`c(username)'" == "bbdaniels" {
        global ietoolkit_clone   "/Users/bbdaniels/GitHub/ietoolkit"
    }
    
      if "`c(username)'" == "avnis" {
        global ietoolkit_clone   "C:/Users/avnis/Documents/GitHub/ietoolkit"
    }

	* Create paths to the subfolders in the repo
    global  runfiles  "${ietoolkit_clone}/run"
    global  runoutput "${runfiles}/output"
	
	*ietoolkit require Stata version 12 or more recent
	if `c(stata_version)' < 12 {
		di as error 
	}
	
	
/*******************************************************************************
    PART 2: Switches
*******************************************************************************/

    local iegitaddmd = 1
    local iekdensity = 1
    local iesave     = 1

/*******************************************************************************
    PART 3: iegitaddmd
*******************************************************************************/
	
    *This run file depends on iefolder, make sure that command is tested before this run file
    if `iegitaddmd' == 1 {
        do "${runfiles}/iegitaddmd.do"
    }

/*******************************************************************************
    PART 4: iekdensity
*******************************************************************************/

    if `iekdensity' == 1 {
        do "${runfiles}/iekdensity.do"
    } 

/*******************************************************************************
    PART 5: iesave
*******************************************************************************/

    * This run file depends on ieboilstart, make sure that command is tested before this run file
    if `iesave' == 1 {
        do "${runfiles}/iesave.do"
    } 