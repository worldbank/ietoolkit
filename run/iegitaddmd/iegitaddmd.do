
	**********************************************
    * Set root macro to clone folder wide path macros

    ***
    * Macro to run folder
    local iegam  "run/iegitaddmd"
    local output "`iegam'/outputs"

    local cl     "`output'/clone"
    local db     "`output'/dropbox"

    local cl_dw  "`cl'/DataWork"
    local db_dw  "`db'/DataWork"

    local customfolder   "`output'/customfolder"
    local customfile     "iegitaddmd_custom_file.md"

    **********************************************
    * Load commands

    *Load version of iegitaddmd in clone
    qui do "src/ado_files/iegitaddmd.ado"

    *Load utility command
	  qui do "run/run_utils.do"
    ie_recurse_rmdir, folder("`output'") okifnotexist

    **********************************************
    * Set up folders to test on

	  * Simple create folders
	  ie_recurse_mkdir, folder("`output'")
    ie_recurse_mkdir, folder("`customfolder'")
    ie_recurse_mkdir, folder("`cl'")
    ie_recurse_mkdir, folder("`db'")

	* Use iefolder to create identical project folders
	iefolder new project           , projectfolder("`cl'")
	iefolder new project           , projectfolder("`db'")
	iefolder new round Baseline    , projectfolder("`cl'")
	iefolder new round Baseline    , projectfolder("`db'")

	iefolder new unitofobs students, projectfolder("`cl'")
	iefolder new unitofobs teachers, projectfolder("`cl'")
	iefolder new unitofobs schools , projectfolder("`cl'")

	* Remove some folders from the clone to simulate use case 2 (see helpfile for description of use cases)
	rmdir "`cl_dw'/Baseline/DataSets/Deidentified"
	rmdir "`cl_dw'/Baseline/DataSets/Final"
	rmdir "`cl_dw'/Baseline/DataSets/Intermediate"
	rmdir "`cl_dw'/Baseline/DataSets"
	rmdir "`cl_dw'/Baseline/Questionnaire/Questionnaire Documentation"

	* Create the git folder
	local gitfolders gitfilter1 gitfilter2
	foreach gitfolder of local gitfolders {
    mkdir "`output'/`gitfolder'"
    mkdir "`output'/`gitfolder'/.git"
		mkdir "`output'/`gitfolder'/includeme"
		mkdir "`output'/`gitfolder'/skipmein2"
		mkdir "`output'/`gitfolder'/skipalsomein2"
		mkdir "`output'/`gitfolder'/sub"
		mkdir "`output'/`gitfolder'/sub/.git"
		mkdir "`output'/`gitfolder'/sub/includealsome"
		mkdir "`output'/`gitfolder'/ado"
		mkdir "`output'/`gitfolder'/asdfasd"
		mkdir "`output'/`gitfolder'/asdfasd/ado"
	}

  **********************************************
  * Test the command

	*Use case 1 - see helpfile for description of use cases
	iegitaddmd , folder("`cl_dw'") auto dryrun
	iegitaddmd , folder("`cl_dw'") auto

	*Use case 2 - see helpfile for description of use cases
	iegitaddmd , folder("`cl_dw'") comparefolder("`db_dw'") auto dryrun
	iegitaddmd , folder("`cl_dw'") comparefolder("`db_dw'") auto

	*Test prompt
	mkdir "`cl_dw'/Baseline/DataSets/Final/Publishable"
	*iegitaddmd , folder("`cl_dw'")

	*Test skip git folders
	iegitaddmd , folder("`output'/gitfilter1") auto

  * Test that the regular file was copied correctly
  checksum "`output'/gitfilter1/ado/README.md"
  assert `r(checksum)' == 4290144044

	*Test skip custom
	iegitaddmd , folder("`output'/gitfilter2") auto dry skipfolders(skipmein2 skipalsomein2 folderthatnotexist ado)
	iegitaddmd , folder("`output'/gitfilter2") auto skipfolders(skipmein2 skipalsomein2 folderthatnotexist ado)

	* Test that folders are not used
	cap iegitaddmd , folder("`output'/gitfilter2") auto skipfolders(skipmein2 skipalsomein2 folderthatnotexist asdfasd/ado)
	assert _rc == 198

  * Test customfile
  iegitaddmd, folder("`customfolder'") customfile("`iegam'/`customfile'") auto

  * Test that the custom file was actaully used
  checksum "`customfolder'/`customfile'"
  assert `r(checksum)' == 1932786186
