	
	cap program drop vce_prep
		program		 vce_prep, rclass 
		
		syntax , vce(string)
		
	* Only applies if option was used
	if "`vce'" != "" {
		
	* Parse string input to see what kind of variance estimator was selected
		local vce_nocomma = subinstr("`vce'", "," , " ", 1)

		tokenize "`vce_nocomma'"
		local vce_type `1'

		local cluster 0
		
	/***************************************************************************
	 Three variance estimators are allowed: 'robust', 'cluster' and 'bootstrap'
	 (i)   if 'robust' was selected, no extra test is needed
	 (ii)  if 'bootstrap' was selected, no extra test is needed
	 (iii) if 'cluster' was selected, we need to test the cluster variable 
	 (iv)  if some other estimator was selected, throw an error
	***************************************************************************/
	
	* (i) 'robust' -----------------------------------------------------------
			if "`vce_type'" == "robust" {
				* Robust is allowed and not other tests needed
			}
			
	* (ii) 'bootstrap' -------------------------------------------------------
			else if  "`vce_type'" == "bootstrap" {
				* Bootstrap is allowed and not other tests needed. Error checking is more complex, add tests here in the future.
			}
			
	* (iii) 'cluster' -------------------------------------------------------

			else if "`vce_type'" == "cluster" {

			* Parse the name of the cluster variable
				local cluster_var `2'

			* Confirm that it exists and throw and error if is does not
				cap confirm variable `cluster_var'

				if _rc {
					noi display as error "{phang}The cluster variable in vce(`vce') does not exist or is invalid for some other reason. See {help vce_option :help vce_option} for more information."
					error _rc
				}

				* Add a local named cluster to be passed to commands
				local cluster 1
			}
	* (iv) other estimator -----------------------------------------------------		
			else {

				*Error for vce() incorrectly applied
				noi display as error "{phang}The vce type `vce_type' in vce(`vce') is not allowed. Only robust, cluster or bootstrap are allowed. See {help vce_option :help vce_option} for more information."
				error 198

			}

	/***************************************************************************
	 Return outputs
	(i)   a local indicating whether clustered variance was selected
	(ii)  the prepared regression variance estimator option
	(iii) the prepared mean variance estimator option
	(iv)  the list of outputs so they can be easily turned into locals
	***************************************************************************/
	
			return local cluster 	`cluster' 					// (i)
			return local error_estm vce(`vce')					// (ii)
			
			* Prepare (iv)
			local outputs cluster error_estm 
			
			* (iii) only applies if errors are not 'robust'
			if "`vce_type'" != "robust" {
				return local error_estm_mean 	vce(`vce')		// (iii)
				local	outputs "`outputs'	error_estm_mean"	// (iv)
			}
			
			return local outputs `outputs'						// (iv)
		}
	
	end program
	