
	* Set versson and seed
	ieboilstart , version(13.1)
	`r(version)'

	* Add the path to your local clone of the [ietoolkit] repo
  global iekit_fldr ""

	if c(username) == "wb462869" {
		global 	iekit_fldr "C:\Users/wb462869/GitHub/ietoolkit"
	}

	* Sub-folder globals
	global run_fldr "${iekit_fldr}/run"
	global out_fldr "${iekit_fldr}/run/output/iebaltab"


  * Load the command from file and utils
	qui	do "${iekit_fldr}/src/ado_files/iebaltab.ado"
	qui	do "${run_fldr}/run_utils/iebaltab_run_utils.do"


************* Regular
	*  L
	sysuse auto

	set seed 34543673

	gen tmt = (runiform()<.5)
	recode tmt (0 = 6) (1 = 2)
	replace tmt = 10231 if (runiform()<.2)
	replace tmt = 4 	if (runiform()<.2)
	tab		tmt

	* String treatment variable
	tostring tmt, gen(tmt_str)

	* Tmt labels
	lab define tmtlbl 4 "control/unobserved" 2 "Oi in %" 6 "taco & salsa"
	lab val tmt tmtlbl

	*Cluster variable
	gen test_cluster_var = tmt
	qui sum test_cluster_var, d
	gen tmt_cl = (test_cluster_var <= r(p50))



qui {

	/***************************************************************************
	  Table 1 - csv, excel, tex and texnote
	***************************************************************************/
	preserve

		local tnum 1
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			ftest feqtest control(1)      ///
			cov(mpg) fixed(foreign)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 2 - tex table fragement only
	***************************************************************************/
	preserve

		local tnum 2
		local texfile "iebt-tex`tnum'"

		noi iebaltab weight price ,              ///
      groupvar(tmt_cl) replace           ///
			ftest feqtest control(1)         ///
			savetex("${out_fldr}/`texfile'") ///
			cov(mpg) fixed(foreign)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
  restore

	/***************************************************************************
	  Table 3 - tex table fragement only with options
	***************************************************************************/
	preserve

		local tnum 3
		local texfile "iebt-tex`tnum'"

		iebaltab weight price ,              ///
      groupvar(tmt_cl) replace           ///
			ftest feqtest control(1)         ///
			savetex("${out_fldr}/`texfile'") ///
			cov(mpg) fixed(foreign)          ///
			texcolwidth(4cm)  ///
			addnote("Options used: texcolwidth(3cm) short first column ")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 4 - tex stand alone doc
	***************************************************************************/
	preserve

		local tnum 4
		local texfile "iebt-texdoc`tnum'"

		noi iebaltab weight price ,                 ///
            groupvar(tmt_cl) replace              ///
			ftest feqtest control(1)            ///
			savetex("${out_fldr}/`texfile'")    ///
			cov(mpg) fixed(foreign) texdocument 

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 5 - tex stand alone doc with options
	***************************************************************************/
	preserve

		local tnum 5
		local texfile "iebt-texdoc`tnum'"

		noi iebaltab weight price ,                               ///
      groupvar(tmt_cl) replace                            ///
			ftest feqtest control(1)                          ///
			savetex("${out_fldr}/`texfile'")                  ///
			cov(mpg) fixed(foreign) texdocument               ///
			texnotewidth(1.5) texcolwidth(2cm) ///
			texcaption("Table 5") texlabel("T5")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore


	/***************************************************************************
	  Table 6 - csv, excel, tex and texnote - rowlabels, weird tmt levels, total
	***************************************************************************/
	preserve

		local tnum 6
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave'           ///
      groupvar(tmt) replace                     ///
			ftest feqtest total rowvarlabels        ///
			cov(mpg) fixed(foreign)                 ///
			addnote("Many groups, rowvarlabels")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 7 - csv, excel, tex and texnote -  order
	***************************************************************************/
	preserve

		local tnum 7
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave'             ///
      groupvar(tmt) replace                       ///
			total order(4 10231) control(6) groupcodes  ///
			cov(mpg) fixed(foreign)                   ///
			addnote("column order should be 4 10231 6 2, and 6 is control so pair test only with this group")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 8 - csv, excel, tex and texnote - manual labels (and order)
	***************************************************************************/
	preserve

		local tnum 8
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

        label var weight "Weight (USD$)"
        // Percent sign in value label

		noi iebaltab weight price headroom , `allsave'                           ///
      groupvar(tmt) replace                                                  ///
			total control(6)  rowvarlabels                                         ///
			grouplabels(`"6 Quotes, and comma "," @ 4 Pizza & Pineapple (USD$) "') ///
			totallabel("Total single ' quote") cov(mpg) fixed(foreign)           ///
      rowlabels(`"price St*r and sub _script @ headroom Headroom "Height" quote "') ///
			addnote("Row column manual ($) lables.")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 9 - missing covariate and fixed effect value warnings
	***************************************************************************/

	preserve

		* Replace one value in three different obs for balance var, covariate
		* and fixed effect
        sort tmt_cl make
		by tmt_cl : replace weight  = . if _n == 1 & tmt_cl == 1
		by tmt_cl : replace mpg     = . if _n == 2 & tmt_cl == 1
		by tmt_cl : replace foreign = . if _n == 3 & tmt_cl == 1

		local tnum 9
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			ftest feqtest                 ///
			cov(mpg) fixed(foreign)       ///
			addnote("Warning for missing value in fixedeffect(foreign) and in covariates(mpg)")

		* Expected outcome: Warning for missing value in
		* fixedeffect(foreign) and in covariates(mpg), but no warning for weight

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 10 - cluster
	***************************************************************************/

	preserve

		local tnum 10
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			vce(cluster test_cluster_var) ///
			ftest feqtest total           ///
			cov(mpg) fixed(foreign)       ///
			addnote("added cluster")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 11 - onerow - basic stats
	***************************************************************************/

	preserve

		local tnum 11
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			onerow                        ///
			cov(mpg) fixed(foreign)       ///
			addnote("added onerow")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore


	/***************************************************************************
	  Table 12 - onerow - all stats that change cols and cluster var
	***************************************************************************/

	preserve

		local tnum 12
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave'        ///
      groupvar(tmt_cl) replace               ///
			onerow vce(cluster test_cluster_var) ///
			ftest feqtest total                  ///
			cov(mpg) fixed(foreign)              ///
			addnote("added onerow and cluster") browse

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore


	/***************************************************************************
	  Table 13 - test pair and f stats preferences
	***************************************************************************/
	preserve

		local tnum 13
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			ftest control(1)              ///
			stats(f(p) pair(nrmd))        ///
			cov(mpg) fixed(foreign)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 14 - test showing no pair tests
	***************************************************************************/
	preserve

		local tnum 14
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			ftest feqtest control(1)      ///
			stats(pair(none))             ///
			cov(mpg) fixed(foreign)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 15 - more test pair stats preferences
	***************************************************************************/
	preserve

		local tnum 15
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			ftest control(1)              ///
			stats(pair(se))               ///
			cov(mpg) fixed(foreign)


		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

    /***************************************************************************
	  Table 16 - test normalized difference
	***************************************************************************/
	preserve

		local tnum 16
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			stats(pair(nrmd))             ///
			cov(mpg) fixed(foreign)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 17 - test normalized adjusted difference
	***************************************************************************/
	preserve

		local tnum 17
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			stats(pair(nrmb))             ///
			cov(mpg) fixed(foreign)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore


    /***************************************************************************
	  Table 18 - test normalized difference
	***************************************************************************/
	preserve

		local tnum 18
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			stats(pair(diff))


		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 19 - test normalized adjusted difference
	***************************************************************************/
	preserve

		local tnum 19
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			stats(pair(beta))

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore


        /***************************************************************************
	  Table 20 - test desc stats and vce bootstrap
	***************************************************************************/
	preserve

		local tnum 20
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			stats(desc(var) pair(t)) vce(robust)


		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 21 - test desc stats and vce robus
	***************************************************************************/
	preserve

		local tnum 21
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

		noi iebaltab weight price , `allsave' ///
      groupvar(tmt_cl) replace        ///
			stats(desc(sd) pair(p)) vce(bootstrap)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)

	restore


	/***************************************************************************
	  Table 22 - test adding stars and star user inputs
	***************************************************************************/
	preserve

		local tnum 22
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
		local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") texnotefile("${out_fldr}/`txnfile'") "'

        set seed 542783

        local balvars  mpg headroom trunk weight length turn price
        foreach balvar of local balvars {
            replace `balvar' = `balvar' * (1 - (.2 * runiform())) if tmt_cl == 1
        }

		noi iebaltab `balvars' , `allsave' ///
      groupvar(tmt_cl) replace onerow  ///
			stats(pair(p)) starlevels(.4 .2 .001)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)

	restore


    /***************************************************************************
	  Table 23 - use all deprecated still allowed names
	***************************************************************************/
	preserve

		local tnum 23
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'")"'

        set seed 542783

        local balvars  mpg trunk weight turn price
        foreach balvar of local balvars {
            replace `balvar' = `balvar' * (1 - (.2 * runiform())) if tmt_cl == 1
        }

		noi iebaltab `balvars' , `allsave' ///
          grpvar(tmt_cl) grpcodes replace  ///
          starsnoadd stats(pair(p))        ///
          tblnonote grplabels("0 Control @ 1 Treatment")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore
    
     /***************************************************************************
	  Table 24 - testing nonote beahvior
	***************************************************************************/

    preserve

		local tnum 24a
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
        local txnfile "iebt-tex`tnum'-note"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") texnotefile("${out_fldr}/`txnfile'")  savetex("${out_fldr}/`texfile'") "'

		noi iebaltab weight , `allsave' replace groupvar(tmt_cl) ///
          nonote addnote(`"added a "tricky" note"')

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore
    
	preserve

		local tnum 24b
		local csvfile "iebt-csv`tnum'"
		local exlfile "iebt-xlsx`tnum'"
		local texfile "iebt-tex`tnum'"
        local allsave `"savecsv("${out_fldr}/`csvfile'") savexlsx("${out_fldr}/`exlfile'") savetex("${out_fldr}/`texfile'") "'

		noi iebaltab weight , `allsave' replace groupvar(tmt_cl) nonote

		* Test no regaular missing values in matrices
		mat mat1 = r(iebtab_rmat)
		mat mat2 = r(iebtab_fmat)
		noi ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore
}
