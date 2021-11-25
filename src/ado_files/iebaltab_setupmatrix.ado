*Sets up template for the result matrix
cap program drop 	setUpResultMatrix
	program define	setUpResultMatrix, rclass

qui {
  syntax , order_of_group_codes(string) test_pair_codes(string)

	noi di "`order_of_group_codes'"

	*Locals for balance var row
  local emptyRow = ""
  local colnames = ""

  *Locals for F test row
	local emptyFRow = ""
	local Fcolnames = ""

  *Stats
  local desc_stats   = "n cl mean se sd"
  local pair_stats   = "diff bn bcl beta p nrmd"
	local allbal_stats = "feqp feqf"
	local ftest_stats  = "fn ff fp"

  *Create columns for group statisitics
  foreach group_code of local order_of_group_codes {
    foreach stat of local desc_stats {
      local colnames = "`colnames' `stat'_`group_code'"
      local emptyRow = "`emptyRow',."
    }
  }

  *total_desc
  foreach stat of local desc_stats {
    local colnames = "`colnames' `stat'_t"
    local emptyRow = "`emptyRow',."
  }


  *balance test pairs
  foreach test_pair of local test_pair_codes {
    foreach stat of local pair_stats {
      local colnames = "`colnames' `stat'_`test_pair'"
      local emptyRow = "`emptyRow',."
    }
  }

	*all balance var test
  foreach stat of local allbal_stats {
    local colnames = "`colnames' `stat'"
    local emptyRow = "`emptyRow',."
  }


	*ftest pairs
  foreach test_pair of local test_pair_codes {
    foreach stat of local ftest_stats {
      local Fcolnames = "`Fcolnames' `stat'_`test_pair'"
      local emptyFRow = "`emptyFRow',."
    }
  }

  *Remove first comma in ",.,.,.,.," empty row
	local emptyRow  = subinstr("`emptyRow'" ,",","",1)
	local emptyFRow = subinstr("`emptyFRow'",",","",1)

	*Create a one 1xN matrix that represents one balance var row
	mat emptyRow = (`emptyRow')
	mat colnames emptyRow = `colnames'
	return matrix emptyRow emptyRow

	*Create a one 1xN matrix that represents one F-test row
	mat emptyFRow = (`emptyFRow')
	mat colnames emptyFRow = `Fcolnames'
	return matrix emptyFRow emptyFRow

}
end
