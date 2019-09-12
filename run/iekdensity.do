
/*******************************************************************************
	Set up
*******************************************************************************/

	* Add the path to your local clone of the [ietoolkit] repo
	global 	ietoolkit "C:/Users/WB527265/Documents/GitHub/ietoolkit"  
	qui		do 		  "${ietoolkit}/src/ado_files/iekdensity.ado"

	* Load data
	sysuse	auto, clear
	
	* Generate treatment variables
	gen		random 		 	  = runiform()
	sort  	random
	gen     treatment_binary  = random > 0.5
	tab	    treatment_binary
	
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
	iekdensity price, treatvar(treatment_binary ) 
	
	** Color options
	iekdensity price, treatvar(treatment_binary ) color(eltblue edkblue)
	
	* Add label to treatment
	lab def 		  		 					  treatLab 0 "Control" 1 "Treatment"
	lab val 				   treatment_binary   treatLab
	
	iekdensity price, treatvar(treatment_binary ) color(eltblue edkblue) 
	
	** Statistic options
	iekdensity price, treatvar(treatment_binary ) stat(p50)
	
	
	* Add statistic with detailed style
	iekdensity price, treatvar(treatment_binary ) stat(mean) statstyle(lpattern(dashed) lwidth(2))
	
	** Effect options
	iekdensity price, treatvar(treatment_binary ) stat(p50) color(eltblue edkblue) effect
	
	* Specify control value
	iekdensity price, treatvar(treatment_binary) stat(p50) color(eltblue edkblue) effect control(0)
	iekdensity price, treatvar(treatment_binary) stat(p50) color(eltblue edkblue) effect control(1)
	
	* Add effect note with specified format
	iekdensity price, treatvar(treatment_binary ) stat(p50) color(eltblue edkblue) effect effectformat(%9.0fc)
		
	** Regression options
	
	** Kernel options
	
	** Graphic options
	iekdensity price, treatvar(treatment_binary ) stat(p50) color(eltblue edkblue) effect effectformat(%9.0fc) gr(graphregion(color(white)))
	
	
	* Categorical treatment
	* ---------------------
	iekdensity price, treatvar(treatment_factor3)
	iekdensity price, treatvar(treatment_factor4) 
	iekdensity price, treatvar(treatment_factor5)
	iekdensity price, treatvar(treatment_factor6)
	
	iekdensity price, treatvar(treatment_factor3) color(eltblue midblue edkblue)
	
	iekdensity price, treatvar(treatment_factor3) stat(mean)
	
	iekdensity price, treatvar(treatment_factor3) color(eltblue midblue edkblue) effect
	
/*******************************************************************************
	Yes error
*******************************************************************************/
	
	* Change only one color
	iekdensity price, treatvar(treatment_binary)  color(eltblue)
	
	* Non-existing code as control
	iekdensity price, treatvar(treatment_binary)  control(3)
	
	* Too many colors
	iekdensity price, treatvar(treatment_binary)  color(eltblue midblue edkblue)
	
	* Not enough colors
	iekdensity price, treatvar(treatment_factor3) color(eltblue midblue) stat(mean) 
	
	