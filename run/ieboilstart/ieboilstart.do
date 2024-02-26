
  ************************
  * Set up root paths if not already set, and set up dev environment

  reproot, project("ietoolkit") roots("clone") prefix("ietk_")
  global runfldr "${ietk_clone}/run"
  global srcfldr "${ietk_clone}/src"

  * Install the version of this package in
  * the plus-ado folder in the test folder
  cap mkdir    "${runfldr}/dev-env"
  repado using "${runfldr}/dev-env"

  cap net uninstall ietoolkit
  net install ietoolkit, from("${ietk_clone}/src") replace

  * Set version to target version of ietoolkit
  ieboilstart , version(13.1)
  `r(version)'

  * Load utils commands
  qui do "${runfldr}/run_utils.do"

  ************************
  * Run tests

  local out "${runfldr}/ieboilstart/ado-test"
  ie_recurse_rmdir, folder("`out'") okifnotexist
  ie_recurse_mkdir, folder("`out'")

  * Make sure deprecated but still supported option work
	ieboilstart , version(13.1) adopath("`out'", strict)
	`r(version)'

  // make sure repkit is installed in this folder such that other files can use repado to reset this change
  ssc install repkit, replace
