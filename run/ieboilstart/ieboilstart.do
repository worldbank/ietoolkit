
  ************************
  * Set up root paths if not already set, and set up dev environment

  reproot, project("ietoolkit") roots("clone") prefix("ietk_")
  global runfldr "${ietk_clone}/run"
  global srcfldr "${ietk_clone}/src"

  * Set versson and seed
  ieboilstart , version(13.1)
  `r(version)'

  * Install the version of this package in
  * the plus-ado folder in the test folder
  cap mkdir    "${runfldr}/dev-env"
  repado using "${runfldr}/dev-env"

  cap net uninstall ietoolkit
  net install ietoolkit, from("${ietk_clone}/src") replace

  ************************
  * Run tests
 
  local out "${runfldr}/ieboilstart/"

  * Make sure deprecated but still supported option work
	ieboilstart , version(13.1) adopath("`out'", strict)
	`r(version)'
