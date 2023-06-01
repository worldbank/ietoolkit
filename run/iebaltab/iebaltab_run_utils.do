/***********************************************
  Test utils for iebaltab
************************************************/

* Test if matrices has any regular missing values
cap program drop   ie_test_mat_nomiss
    program define ie_test_mat_nomiss

	syntax, mat1(name) [mat2(name) mat3(name) mat4(name)]

  * Combine a list of all mats and loop over them
  local mats "`mat1' `mat2' `mat3' `mat4'"
  foreach mat of local mats {
  	*Loop over columns and rows
  	forvalues c = 1/`=colsof(`mat')' {
  	    forvalues r = 1/`=rowsof(`mat')' {
        *Test if value is missing
        if el(`mat',`r',`c') == . {
  			   mat list `mat'
  			   noi di as error "{pstd}Matrix may only non-missing values or extended missing values. See position row `r' and col `c'.{p_end}"
  			   error 504
  			}
  		}
    }
	}
end
