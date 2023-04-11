
/*******************************************************************************
    PART 1:  Folder paths
*******************************************************************************/

    ** NOTE: Nothing to do here!!
    
    ** This file is meant to run withing the ietoolkit.strp project
    ** Go to the root folder of the ietoolkit clone and open ietoolkit.strp 
    ** and then run this file
    
    * This main.do is only meant to be used when you want to run the run-files
    * for all commands

/*******************************************************************************
    PART 2: run all command
*******************************************************************************/
	
    *This run file depends on iefolder, make sure that command is tested before this run file
    
    * iegitaddmd
    do "run/iegitaddmd/iegitaddmd.do"
    
    * iekdensity
    do "run/iekdensity/iekdensity.do"
   
    * iesave
    do "run/iesave/iesave1.do"
    do "run/iesave/iesave2.do"

    * iebaltab
    do "run/iebaltab/iebaltab1.do"
    do "run/iebaltab/iebaltab2.do"

    * ieddtab
    do "run/ieddtab/ieddtab.do"
  
    * ieboilstart
    * NOTE: this runfile changes settings such that Stata needs to be re-started
    * in order to comment this file out
    do "run/ieboilstart/ieboilstart.do"