	
	* Set this local to a folder where folders can be creaetd for this experiment
	global test_folder ""
	
	* Create a folder clone and a folder dropbox (see use case 2 in help file for why both these folders are needed)
	mkdir "${test_folder}/clone"
	mkdir "${test_folder}/dropbox"
	
	* USe iefolder to create identical project folders 
	iefolder new project , projectfolder("${test_folder}/clone")
	iefolder new project , projectfolder("${test_folder}/dropbox")
	iefolder new round Baseline , projectfolder("${test_folder}/clone")
	iefolder new round Baseline , projectfolder("${test_folder}/dropbox")
	
	iefolder new unitofobs students, projectfolder("${test_folder}/clone")
	iefolder new unitofobs teachers, projectfolder("${test_folder}/clone")
	iefolder new unitofobs schools, projectfolder("${test_folder}/clone")
	
	* Remove some folders from the clone to simulate use case 2 (see helpfile for description of use cases)
	rmdir "${test_folder}/clone/DataWork/Baseline/DataSets/Deidentified"
	rmdir "${test_folder}/clone/DataWork/Baseline/DataSets/Final"
	rmdir "${test_folder}/clone/DataWork/Baseline/DataSets/Intermediate"
	rmdir "${test_folder}/clone/DataWork/Baseline/DataSets"
	rmdir "${test_folder}/clone/DataWork/Baseline/Questionnaire/Questionnaire Documentation"
	
	*Set global to ietoolkit clone
	global ietoolkit_clone ""
	qui do "${ietoolkit_clone}/src/ado_files/iegitaddmd.ado"
	
	*Use case 1 - see helpfile for description of use cases
	iegitaddmd , folder("${test_folder}/clone/DataWork") auto dryrun
	iegitaddmd , folder("${test_folder}/clone/DataWork") auto 
	
	*Use case 2 - see helpfile for description of use cases
	iegitaddmd , folder("${test_folder}/clone/DataWork") comparefolder("${test_folder}/dropbox/DataWork") auto dryrun
	iegitaddmd , folder("${test_folder}/clone/DataWork") comparefolder("${test_folder}/dropbox/DataWork") auto
	
	*Test prompt
	mkdir "${test_folder}/clone/DataWork/Baseline/DataSets/Final/Publishable"
	iegitaddmd , folder("${test_folder}/clone/DataWork") 