

	*Take the significance levels and count number of stars
	cap program drop 	countStars
		program define	countStars, rclass

		args pvalue star1 star2 star3 stardrop

		local stars 0

		*Option to suppress all stars
		if "`stardrop'" == "" {
			foreach star_p_level in `star1' `star2' `star3' {

				if `pvalue' < `star_p_level' local ++stars
			}
		}

		return local stars `stars'

	end


	**Convert the errors to the display stats picked
	* by the user. Standard errors is the default.
	cap program drop 	convertErrs
		program define	convertErrs, rclass

		args se_err N errortype

		*Test if custom star levels are used
		if "`errortype'" == "sd" {
			local err = `se_err' * sqrt(`N')
		}
		else {
			//For se keep se, for errhide keep se as matrix must have some value even if it will not be used
			local err = `se_err'
		}

		return local converted_error `err'

	end
