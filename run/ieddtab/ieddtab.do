
/*******************************************************************************
	Set up
*******************************************************************************/

	* Set versson and seed
	ieboilstart , version(13.1)
	`r(version)'
	set seed 313833


	* Add the path to your local clone of the [ietoolkit] repo
	qui	do "src/ado_files/ieddtab.ado"

	* Load data blood pressure patient data
	sysuse	bplong, clear

	*Rename and recode time var
	rename when time
	recode time (1=0) (2=1)

	* Sort patient and time and randomize number on baseline value
	bys patient : gen rand = runiform() if time == 0

	*Sort rand and assign half of baseline to tmt == 1.
	*Baseline is half of all obs, so half bseline = .25
	sort rand
	gen tmt = (_n / _N > .25) if !missing(rand)

	*Sort on patient and time and copy baselin value to endline obs
	sort patient time
	by patient : replace tmt = tmt[_n-1] if time == 1

	*Label vars. USe suffix -test to see what is dynamc and what is hard coded
	label define treatment 0 "Control-test" 1 "Treatment-test"
	label define time 0 "Baseline-test" 1 "Endline-test"
	label value time time
	label value tmt treatment


	*Tidy up required vars
	local orderkeep patient tmt time bp
	keep `orderkeep'
	order `orderkeep'


	**************************************

	*Utility function to test result matrix
	program define test_matrix
		syntax ,  rmatrix(string) row(string) col(string) expected_val(string)
		local value = `rmatrix'["`row'","`col'"]
		di "{pstd}Row: `row', Col: `col', Expected value: `expected_val', Actual value `value'{p_end}"
		assert `value' == `expected_val'
	end

	**************************************

	*regular run, test all values
	ieddtab bp, time(time) treat(tmt)

	mat result1 = r(ieddtabResults)
	mat list result1

	*Test second difference
	test_matrix , rmatrix(result1) row("bp") col("2D") 			expected_val(-1.649999999999993)
	test_matrix , rmatrix(result1) row("bp") col("2D_err") 		expected_val(3.332609384661584)
	test_matrix , rmatrix(result1) row("bp") col("2D_stars") 	expected_val(0)
	test_matrix , rmatrix(result1) row("bp") col("2D_N") 		expected_val(240)

	*Test control first difference
	test_matrix , rmatrix(result1) row("bp") col("1DC") 		expected_val(-4.266666666666667)
	test_matrix , rmatrix(result1) row("bp") col("1DC_err") 	expected_val(2.39864211429447)
	test_matrix , rmatrix(result1) row("bp") col("1DC_stars") 	expected_val(1)
	test_matrix , rmatrix(result1) row("bp") col("1DC_N") 		expected_val(120)

	*Test treatment first difference
	test_matrix , rmatrix(result1) row("bp") col("1DT") 		expected_val(-5.916666666666667)
	test_matrix , rmatrix(result1) row("bp") col("1DT_err") 	expected_val(2.313612179745651)
	test_matrix , rmatrix(result1) row("bp") col("1DT_stars") 	expected_val(2)
	test_matrix , rmatrix(result1) row("bp") col("1DT_N") 		expected_val(120)

	*Test control baseline summary stats
	test_matrix , rmatrix(result1) row("bp") col("C0_mean") 	expected_val(156.0666666666667)
	test_matrix , rmatrix(result1) row("bp") col("C0_err") 		expected_val(1.594458388227513)
	test_matrix , rmatrix(result1) row("bp") col("C0_N") 		expected_val(60)

	*Test treatment baseline summary stats
	test_matrix , rmatrix(result1) row("bp") col("T0_mean") 	expected_val(156.8333333333333)
	test_matrix , rmatrix(result1) row("bp") col("T0_err") 		expected_val(1.346719526847542)
	test_matrix , rmatrix(result1) row("bp") col("T0_N") 		expected_val(60)

	*Test control endline summary stats
	test_matrix , rmatrix(result1) row("bp") col("C1_mean") 	expected_val(151.8)
	test_matrix , rmatrix(result1) row("bp") col("C1_err") 		expected_val(1.791978359433497)
	test_matrix , rmatrix(result1) row("bp") col("C1_N") 		expected_val(60)

	*Test treatment endline summary stats
	test_matrix , rmatrix(result1) row("bp") col("T1_mean") 	expected_val(150.9166666666667)
	test_matrix , rmatrix(result1) row("bp") col("T1_err") 		expected_val(1.881262298105969)
	test_matrix , rmatrix(result1) row("bp") col("T1_N") 		expected_val(60)
