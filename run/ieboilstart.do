

    global rieboil "${runoutput}/ieboilstart"
    
     * Load the command from file and utils
	qui	do "${ietoolkit_clone}/src/ado_files/ieboilstart.ado"
    qui do "${ietoolkit_clone}/src/ado_files/ietoolkit.ado"
	   
    
    * Testing old "default" syntax
    cap ieboilstart , version(13.1) adopath("${rieboil}/ado1")
    assert _rc == 198
    
    * Load the command from file and utils
	qui	do "${ietoolkit_clone}/src/ado_files/ieboilstart.ado"
    qui do "${ietoolkit_clone}/src/ado_files/ietoolkit.ado"  
       
	* Set PERSONAL path
	ieboilstart , version(13.1) adopath("${rieboil}/ado1", nostrict)
	`r(version)'
    
    *Test mock command in this ado path
    ado1
    
    * NOTE THAT THIS LINE WILL CAUSE AN ERROR IF THIS RUN FILE IS RAN TWICE
    * WITHOUT RESTARTING STATA INBETWEEN
    iefieldkit
    

    * Reload commands
	qui	do "${ietoolkit_clone}/src/ado_files/ieboilstart.ado"
    qui do "${ietoolkit_clone}/src/ado_files/ietoolkit.ado"
    
    * Set PLUS path
	ieboilstart , version(13.1) adopath("${rieboil}/ado2", strict)
	`r(version)'
    
    *Test mock command in this ado path
    ado2
    
    * Test that otherwise instaleld commands are not accessible after "strict"
    cap iefieldkit
    assert _rc == 199