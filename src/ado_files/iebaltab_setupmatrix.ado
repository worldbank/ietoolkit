*Sets up template for the result matrix
cap program drop 	setUpResultMatric
	program define	setUpResultMatric, rclass

  args order_of_group_codes  test_pair_codes cluster_used

  local emptyrow = ""
  local colnames = ""

  desc_stats = "n cluster mean sd se"
  test_stats = "diff beta t p "


  *Create columns for group statisitics

  foreach group_code of local order_of_group_codes {
    foreach stat of local desc_stats {
      local colnames = "`colnames' `stat'_`group_code'"
      local emptyrow = "`emptyrow',."
    }
  }

  *total_desc
  foreach stat of local desc_stats {
    local colnames = "`colnames' `stat'_t"
    local emptyrow = "`emptyrow',."
  }


  *test pair
  foreach test_pair in test_pairs {
    foreach stat of local test_stats {
      local colnames = "`colnames' `stat'_`test_pair'"
      local emptyrow = "`emptyrow',."
    }
  }

	*Define default row here. The results for each var will be one row that starts with all missing vlaues
	mat emptyRowMat = (`emptyrow')
	mat colnames emptyRowMat = `colnames'

	return matrix emptyRowMat emptyRowMat
	return local colnames `colnames'

end
