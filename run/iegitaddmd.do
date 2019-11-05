	
	* Set this local to a folder where folders can be creaetd for this experiment
	global test_folder ""
	
	* Create a folder clone and a folder dropbox (see use case 2 in help file for why both these folders are needed)
	mkdir "${top_folder}/clone"
	mkdir "${top_folder}/dropbox"
	
	* USe iefolder to create identical project folders 
	iefolder new project , projectfolder("${top_folder}/clone")
	iefolder new project , projectfolder("${top_folder}/dropbox")
	iefolder new round Baseline , projectfolder("${top_folder}/clone")
	iefolder new round Baseline , projectfolder("${top_folder}/dropbox")
	
	* Remove some folders from the clone to simulate use case 2 (see helpfile for description of use cases)
	rmdir "${top_folder}/clone/DataWork/Baseline/DataSets/Deidentified"
	rmdir "${top_folder}/clone/DataWork/Baseline/DataSets/Final"
	rmdir "${top_folder}/clone/DataWork/Baseline/DataSets/Intermediate"
	rmdir "${top_folder}/clone/DataWork/Baseline/DataSets"
	rmdir "${top_folder}/clone/DataWork/Baseline/Questionnaire/Questionnaire Documentation"
	
	*Set global to ietoolkit clone
	global ietoolkit_clone ""
	qui do "${ietoolkit_clone}/src/ado_files/iegitaddmd.ado"
	
	*Use case 1 - see helpfile for description of use cases
	iegitaddmd , folder("${top_folder}/clone/DataWork") auto dryrun
	iegitaddmd , folder("${top_folder}/clone/DataWork") auto 
	
	*Use case 2 - see helpfile for description of use cases
	iegitaddmd , folder("${top_folder}/clone/DataWork") comparefolder("${top_folder}/dropbox/DataWork") auto dryrun
	iegitaddmd , folder("${top_folder}/clone/DataWork") comparefolder("${top_folder}/dropbox/DataWork") auto
	
	*Test prompt
	mkdir "${top_folder}/clone/DataWork/Baseline/DataSets/Final/Publishable"
	iegitaddmd , folder("${top_folder}/clone/DataWork") 