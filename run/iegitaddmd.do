
	/*******************************************************************************
		Set up
	*******************************************************************************/

	* Load the version in this clone into memory. If you need to use the version
	* currently installed in you instance of Stata, then simply re-start Stata.
	* Set up the ietoolkit_clone global root path in ietoolkit\run\run_master.do
	qui do "${ietoolkit_clone}/src/ado_files/iegitaddmd.ado"

	*Load utility function that helps clean up folders inbetween test runs
	qui do "${ietoolkit_clone}/run/ie_recurse_rmdir.do"

	* Make sure the test folder is created
	local test_folder "${runoutput}/iegitaddmd"
	ie_recurse_mkdir, folder("`test_folder'")

	* Create a folder clone and a folder dropbox (see use case 2 in help file for why both these folders are needed)
	local highlevel_folders clone dropbox gitfilter1 gitfilter2
	foreach folder of local highlevel_folders {
		ie_recurse_rmdir, folder("`test_folder'/`folder'") okifnotexist
		mkdir "`test_folder'/`folder'"
	}

	* Use iefolder to create identical project folders
	iefolder new project , projectfolder("`test_folder'/clone")
	iefolder new project , projectfolder("`test_folder'/dropbox")
	iefolder new round Baseline , projectfolder("`test_folder'/clone")
	iefolder new round Baseline , projectfolder("`test_folder'/dropbox")

	iefolder new unitofobs students, projectfolder("`test_folder'/clone")
	iefolder new unitofobs teachers, projectfolder("`test_folder'/clone")
	iefolder new unitofobs schools, projectfolder("`test_folder'/clone")

	* Remove some folders from the clone to simulate use case 2 (see helpfile for description of use cases)
	rmdir "`test_folder'/clone/DataWork/Baseline/DataSets/Deidentified"
	rmdir "`test_folder'/clone/DataWork/Baseline/DataSets/Final"
	rmdir "`test_folder'/clone/DataWork/Baseline/DataSets/Intermediate"
	rmdir "`test_folder'/clone/DataWork/Baseline/DataSets"
	rmdir "`test_folder'/clone/DataWork/Baseline/Questionnaire/Questionnaire Documentation"

	* Create the git folder
	local gitfolders gitfilter1 gitfilter2
	foreach gitfolder of local gitfolders {
		mkdir "`test_folder'/`gitfolder'/.git"
		mkdir "`test_folder'/`gitfolder'/includeme"
		mkdir "`test_folder'/`gitfolder'/skipmein2"
		mkdir "`test_folder'/`gitfolder'/skipalsomein2"
		mkdir "`test_folder'/`gitfolder'/sub"
		mkdir "`test_folder'/`gitfolder'/sub/.git"
		mkdir "`test_folder'/`gitfolder'/sub/includealsome"

		mkdir "`test_folder'/`gitfolder'/ado"
		mkdir "`test_folder'/`gitfolder'/asdfasd"
		mkdir "`test_folder'/`gitfolder'/asdfasd/ado"
	}




	*Use case 1 - see helpfile for description of use cases
	iegitaddmd , folder("`test_folder'/clone/DataWork") auto dryrun
	iegitaddmd , folder("`test_folder'/clone/DataWork") auto

	*Use case 2 - see helpfile for description of use cases
	iegitaddmd , folder("`test_folder'/clone/DataWork") comparefolder("`test_folder'/dropbox/DataWork") auto dryrun
	iegitaddmd , folder("`test_folder'/clone/DataWork") comparefolder("`test_folder'/dropbox/DataWork") auto

	*Test prompt
	mkdir "`test_folder'/clone/DataWork/Baseline/DataSets/Final/Publishable"
	*iegitaddmd , folder("`test_folder'/clone/DataWork")

	*Test skip git folders
	iegitaddmd , folder("`test_folder'/gitfilter1") auto

	*Test skip custom
	iegitaddmd , folder("`test_folder'/gitfilter2") auto dry skipfolders(skipmein2 skipalsomein2 folderthatnotexist ado)
	iegitaddmd , folder("`test_folder'/gitfilter2") auto skipfolders(skipmein2 skipalsomein2 folderthatnotexist ado)

	* Test that folders are not used
	cap iegitaddmd , folder("`test_folder'/gitfilter2") auto skipfolders(skipmein2 skipalsomein2 folderthatnotexist asdfasd/ado)
	assert _rc == 198
