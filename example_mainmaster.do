* ***************************************************************** *
* ***************************************************************** *
*																	*
*		your_project_name											*
*   	MASTER DO_FILE												*
*																	*
* ***************************************************************** *
* ***************************************************************** *

	/*
	 ** PURPOSE:  	Write intro to project here
					
	** OUTLINE:		PART 0: Configure settings for memory etc.
					PART 1: Set globals for dynamic file paths
					PART 2: Set globals for constants and varlist
							used across the project. Intall custom
							commands needed.
					PART 3: Call the task specific master do-files 
							that call all do-files needed for that 
							tas. Do not include Part 0-2 in a task
							specific master do-file


	** REQUIRES:	List all data sets using the globals that you 
					define below to indicate what data you will need
					
					Example:
					$BL_dtRaw/baseline_survey_v1.csv
					$BL_dataraw/baseline_survey_v2.csv
					$monitor_data/monitor2016_data.xlsx
																			
	** CREATES:	  	List all data sets using the globals that you 
					define below to indicate what data set are 
					created by the do-files this master do-file calls
					
					Example:
					$BL_data/final/baseline_clean.dta
					$BL_data/final/baseline_constructs.dta
					Multiple tables and grahps in $BL_output
							
	** IDS VAR:		list_ID_var_here		//Uniquely identifies households (update for your proejct)
					  
	** NOTES: 	  
				  
	** WRITEN BY:  names_of_contributors                  															

	** Last time modified: 

	*/	
	
*******************************************************************************************************************************************
*										PART 0:  Install packages and standardizer settings
*										
*										Install packages needed to run all do-files this file will call. 
*										Use ieboilstart to harmonize settings
*										
*******************************************************************************************************************************************
	
	*Packages that this project requires:
	ssc install ietoolkit 
	
	
	*Standardize settings accross users
	ieboilstart, version(12.1)		//Set the version number to the oldes version used by anyone in the project team
	`r(version)'					//This line is needed to actually set the version from the command above
	
*******************************************************************************************************************************************
*										PART 1:  PREPARING FOLDER PATH GLOBALS
*										
*										Set the global box to point to the project folder
*										on each collaborators computer. Set other locals 
*										that point to other folders of interest.
*******************************************************************************************************************************************

	*  User 
	* -----------
		
	*User Number:
	* You				1   //Replace "You with your name"
	* Next User			2	//Assign a user number to each additional collaborator of this code
	
	*Set this value to the user currently using this file
	global user  1

	* Root folder globals
	* ---------------------
		
	if $user == 1 {
		global projectfolder "C:\Users\wb448687\Desktop\Box Sync"
	}		
			
	if $user == 2 {
		global projectfolder ""  //Enter the file path to the projectfolder of next user here
	}
	
	
	* Project folder globals
	* ---------------------
	
	
	
		
*******************************************************************************************************************************************
*										PART 2: - SET GLOBALS FOR ALL CONSTANTS USED ACROSS THE PROJECT
*
*										Set globals with numbers, variable lists or anything else that is standardized
*										across a project. Any conversion rates used to standardize to meter and kilograms,
*										currency exchange rates etc. Gather all of that here in this section.
*******************************************************************************************************************************************	   
		
	* Best practice is to fill this section with as many constants as possible
		
	**Example 1: Standardizing to meters
	global foot			= 0.3048
	global mile			= 1609.34
	global km			= 1000
	
	**Example 2: Universial regression controls
	local 	hh_controls 	hhh_age hhh_edu
	local 	geo_controls 	highland districtGDP
	global 	reg_controls 	`hh_controls' `geo_controls'
		
	
*******************************************************************************************************************************************
*										PART 3: - Run task specific master do-files (the do-files here is just an example)
*
*										This section should run all dofiles needed from raw 
*										data to analysis to outputs. This section should be 
*										written in a way that anyone new to the project should
*										still be able to follow what is going on in the data folder.
*******************************************************************************************************************************************	  	
	
	*Set the corresponding value 
	local baseline 			1
	local endline 			1
	
	*********************************************************************
	*		Run master do-files for individual survey rounds
	*********************************************************************

	* Run baseline master dofile
	* ---------------------
	if `baseline' 			do "$baseline_do\master_baseline.do"

	
	* Run baseline master dofile
	* ---------------------
	if `endline' 			do "$endline_do\master_endline.do"




/**********************************************************************************************************************************
*END OF THE DOFILE 																											  	 *
**********************************************************************************************************************************/
