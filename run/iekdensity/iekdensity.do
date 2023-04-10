
/*******************************************************************************
	Set up
*******************************************************************************/

	* Load the version in this clone into memory. If you need to use the version
	* currently installed in you instance of Stata, then simply re-start Stata.
	* Set up the ietoolkit_clone global root path in ietoolkit\run\run_master.do
	qui	do "src/ado_files/iekdensity.ado"

	* Load data
	sysuse	auto, clear

	* Generate treatment variables
	gen		random 		 	      = runiform()
	sort  random
	gen   treatment_binary  = random > 0.5
	tab	  treatment_binary

	* Generate factor variables
	forv    factorCap = 3/6 {
		gen treatment_factor`factorCap' = ceil(`factorCap' * _n/_N)
		tab treatment_factor`factorCap'
	}

/*******************************************************************************
	No error
*******************************************************************************/

	* Binary treatment
	* ----------------
	iekdensity price, by(treatment_binary )

	** Color options
	iekdensity price, by(treatment_binary ) color(eltblue edkblue)

	* Add label to treatment
	lab def 		  		 			    treatLab 0 "Control" 1 "Treatment"
	lab val 		     treatment_binary   treatLab

	iekdensity price, by(treatment_binary ) color(eltblue edkblue)

	** Statistic options
	iekdensity price, by(treatment_binary ) stat(p50)

	* Add statistic with detailed style
	iekdensity price, by(treatment_binary ) stat(mean) statstyle(lpattern(dash) lwidth(2))

	** Effect options
	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) effect

	* Specify control value
	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) effect control(0)
	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) effect control(1)

	* Add effect note with specified format
	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) effect effectformat(%9.0fc)

	** Regression options

	* Fixed effects
	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) ///
					  effect abs(foreign)

	* Clustered standard errors
	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) ///
					  effect reg(cl(foreign))

	** Kernel options
	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) ///
					  kdensity(biweight)

	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) ///
					  kdensity(epan2 bwidth(5))

	** Graphic options
	iekdensity price, by(treatment_binary ) stat(p50) color(eltblue edkblue) ///
					  effect effectformat(%9.0fc) 							 ///
					  graphregion(color(white)) ylab(, nogrid)				 ///
					  legend(cols(1))


	* Categorical treatment
	* ---------------------
	iekdensity price, by(treatment_factor3)
	iekdensity price, by(treatment_factor4)
	iekdensity price, by(treatment_factor5)
	iekdensity price, by(treatment_factor6)

	lab def 				  treatment_factor3Lab 1 "Treatment 1" 2 "Treatment 2" 3 "Treatment 3", replace
	lab val treatment_factor3 treatment_factor3Lab

	iekdensity price, by(treatment_factor3)

	iekdensity price, by(treatment_factor3) color(eltblue midblue edkblue)

	iekdensity price, by(treatment_factor3) color(eltblue midblue edkblue) stat(mean)

	iekdensity price, by(treatment_factor3) color(eltblue midblue edkblue) effect control(1)
	iekdensity price, by(treatment_factor3) color(eltblue midblue edkblue) effect control(2)


/*******************************************************************************
	Yes error
*******************************************************************************/

	* Group variable is not a factor variable
	cap iekdensity price, by(headroom)
	assert _rc == 109

	* Change only one color
	cap iekdensity price, by(treatment_binary)  color(eltblue)
	assert _rc == 198

	* Non-existing code as control
	cap iekdensity price, by(treatment_binary)  control(3)
	assert _rc == 197

	* Too many colors
	cap iekdensity price, by(treatment_binary)  color(eltblue midblue edkblue)
	assert _rc == 198

	* Not enough colors
	cap iekdensity price, by(treatment_factor3) color(eltblue midblue) stat(mean)
	assert _rc == 198

	* Multiple treatment arms but control group not specified
	cap iekdensity price, by(treatment_factor3) color(eltblue midblue edkblue) effect
	assert _rc == 198

***************************** End of do-file ***********************************
