
	* Set versson and seed
	ieboilstart , version(13.1)
	`r(version)'

	* Add the path to your local clone of the [ietoolkit] repo
  global iekit_fldr ""

	if c(username) == "WB462869" {
		global 	iekit_fldr "C:\Users/wb462869/GitHub/ietoolkit"
	}

	* Sub-folder globals
	global run_fldr "${iekit_fldr}/run"
	global out_fldr "${iekit_fldr}/run/output/iebaltab"


  * Load the command from file and utils
	qui	do "${iekit_fldr}/src/ado_files/iebaltab.ado"
	qui	do "${run_fldr}/run_utils/iebaltab_run_utils.do"


************* Regular
	sysuse auto

	set seed 34543673

	gen tmt = (runiform()<.5)

	recode tmt (0 = 6) (1 = 2)

	replace tmt = 10231 if (runiform()<.2)
	replace tmt = 4 	if (runiform()<.2)
	tab		tmt


	gen this_cluster = tmt
	sum this_cluster, d
	gen tmt_cl = (this_cluster <= r(p50))

	tostring tmt, gen(tmt_str)

	lab define tmtlbl 4 "control/unobserved" 2 "Oi in %" 6 "taco & slsa"

	lab val tmt tmtlbl

	//replace weight = 10

	//bysort tmt_cl : keep if _n <= 20
	//bysort tmt_cl : replace weight = 5 if _n < _N /2

	/***************************************************************************
	  Table 1 - csv, excel, tex and texnote
	***************************************************************************/
	preserve
		iebaltab weight price , grpvar(tmt_cl) replace ///
			ftest feqtest control(1)   ///
			savecsv("${out_fldr}/iebt-csv1")          ///
			savexlsx("${out_fldr}/iebt-xlsx1")        ///
			savetex("${out_fldr}/iebt-tex1")          ///
			texnotefile("${out_fldr}/iebt-tex1-note") ///
			cov(mpg) fixed(foreign)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebaltabrmat)
		mat mat2 = r(iebaltabfmat)
		ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 2 - tex table fragement only
	***************************************************************************/
	preserve
		iebaltab weight price , grpvar(tmt_cl) replace ///
			ftest feqtest control(1)   ///
			savetex("${out_fldr}/iebt-tex2")  ///
			cov(mpg) fixed(foreign)

		* Test no regaular missing values in matrices
		mat mat1 = r(iebaltabrmat)
		mat mat2 = r(iebaltabfmat)
		ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
  restore

	/***************************************************************************
	  Table 3 - tex table fragement only with options
	***************************************************************************/
	preserve
		iebaltab weight price , grpvar(tmt_cl) replace ///
			ftest feqtest control(1)   ///
			savetex("${out_fldr}/iebt-tex3")  ///
			cov(mpg) fixed(foreign) ///
			texvspace(1cm) texcolwidth(4cm) ///
			tbladdnote("Options used: texvspace(1cm) - tall rows, texcolwidth(3cm) short first column ")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebaltabrmat)
		mat mat2 = r(iebaltabfmat)
		ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 4 - tex stand alone doc
	***************************************************************************/
	preserve
		iebaltab weight price , grpvar(tmt_cl) replace ///
			ftest feqtest control(1)   ///
			savetex("${out_fldr}/iebt-texdoc4")  ///
			cov(mpg) fixed(foreign) texdocument

		* Test no regaular missing values in matrices
		mat mat1 = r(iebaltabrmat)
		mat mat2 = r(iebaltabfmat)
		ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 5 - tex stand alone doc with options
	***************************************************************************/
	preserve
		iebaltab weight price , grpvar(tmt_cl) replace ///
			ftest feqtest control(1)   ///
			savetex("${out_fldr}/iebt-texdoc5")  ///
			cov(mpg) fixed(foreign) texdocument ///
			texnotewidth(1.5) texvspace(1cm) texcolwidth(2cm)  ///
			texcaption("Table 5") texlabel("T5")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebaltabrmat)
		mat mat2 = r(iebaltabfmat)
		ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore


	/***************************************************************************
	  Table 6 - csv, excel, tex and texnote - rowlabels, weird tmt levels, total
	***************************************************************************/
	preserve
		iebaltab weight price , grpvar(tmt) replace ///
			ftest feqtest total rowvarlabels   ///
			savecsv("${out_fldr}/iebt-csv6")          ///
			savexlsx("${out_fldr}/iebt-xlsx6")        ///
			savetex("${out_fldr}/iebt-tex6")          ///
			texnotefile("${out_fldr}/iebt-tex6-note") ///
			cov(mpg) fixed(foreign) ///
			tbladdnote("Many groups, rowvarlabels")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebaltabrmat)
		mat mat2 = r(iebaltabfmat)
		ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 7 - csv, excel, tex and texnote -  order
	***************************************************************************/
	preserve
		iebaltab weight price , grpvar(tmt) replace ///
			total order(4 10231) control(6) grpcodes                       ///
			savecsv("${out_fldr}/iebt-csv7")          ///
			savexlsx("${out_fldr}/iebt-xlsx7")        ///
			savetex("${out_fldr}/iebt-tex7")          ///
			texnotefile("${out_fldr}/iebt-tex7-note") ///
			cov(mpg) fixed(foreign) ///
			tbladdnote("column order should be 4 10231 6 2, and 6 is control so pair test only with this group")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebaltabrmat)
		mat mat2 = r(iebaltabfmat)
		ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore

	/***************************************************************************
	  Table 8 - csv, excel, tex and texnote - manual labels (and order)
	***************************************************************************/
	preserve
		iebaltab weight price , grpvar(tmt) replace ///
			total control(6)  rowvarlabels                  ///
			grplabels("4 Pizza and Pineapple (m) @ 6 Control (m)")                 ///
			totallabel("Total manual label (m)") rowlabels("price Priset (m)")     ///
			savecsv("${out_fldr}/iebt-csv8")          ///
			savexlsx("${out_fldr}/iebt-xlsx8")        ///
			savetex("${out_fldr}/iebt-tex8")          ///
			texnotefile("${out_fldr}/iebt-tex8-note") ///
			cov(mpg) fixed(foreign) ///
			tbladdnote("Row and column manual lables.")

		* Test no regaular missing values in matrices
		mat mat1 = r(iebaltabrmat)
		mat mat2 = r(iebaltabfmat)
		ie_test_mat_nomiss, mat1(mat1) mat2(mat2)
	restore
