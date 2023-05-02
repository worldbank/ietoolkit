cap program drop iedorep
program define   iedorep, rclass

  syntax , dofile(string) output(string)

  /*****************************************************************************
    Test input
  *****************************************************************************/

  *Test that output location exist
  mata : st_numscalar("r(dirExist)", direxists("`output'"))
  if (`r(dirExist)' == 0) {
    noi di as error `"{phang}The folder used in [output(`output')] does not exist.{p_end}"'
    error 693
    exit
  }

  /*****************************************************************************
    Set up output structure
  *****************************************************************************/

  * Remove existing output if it exists
  mata : st_numscalar("r(dirExist)", direxists("`output'/iedorep-output"))
  if (`r(dirExist)' == 1) r_rmdir, folder("`output'/iedorep-output")

  * Create the new output folder structure
  local dirout "`output'/iedorep-output"
  mkdir "`dirout'"

  * Create the subfolders in the output folder structure
  foreach odir in write check data {
    local d`odir' "`dirout'/`odir'"   //Create a local to folder path
    mkdir "`d`odir''"                  //Create this folder
  }

  /*****************************************************************************
    Generate write and
  *****************************************************************************/

  iedorep_recurse, dofile("`dofile'") output("`dirout'") stub("m")
  local filewrite "`r(filewrite)'"
  local filecheck "`r(filecheck)'"

  /*****************************************************************************
    Set up output structure
  *****************************************************************************/

  do "`filewrite'"
  do "`filecheck'"

end

cap program drop iedorep_recurse
program define   iedorep_recurse, rclass

  syntax, dofile(string) output(string) stub(string)

  /*****************************************************************************
    Create output files needed
  *****************************************************************************/

  * Create file locals
  local file_w "`output'/write/`stub'.do"
  local file_c "`output'/check/`stub'.do"
  local file_d "`output'/data/`stub'.txt"

  * Create the output files
  tempname handle_o handle_w handle_c handle_d
  file open `handle_w' using "`file_w'", write replace
  file open `handle_c' using "`file_c'", write replace
  file open `handle_d' using "`file_d'", write replace


  /*****************************************************************************
    Loop over the do-file to create the write and check files
  *****************************************************************************/

  *Read orginal file and
  *create write file and check file

  local lnum = 1
  local leof = 0
  local subf_n = 0

  file open `handle_o' using "`dofile'", read

  while `leof' == 0 {
      * Read next line

      file read `handle_o' line
      local leof = `r(eof)'

      * Locals used to analyze line
      local fw : word 1 of `line'

      noi di "lnum(`lnum') - fw(`fw')"

      if (inlist("`fw'","do","run","ru")) {

        * Get the file path from the
        local file : word 2 of `macval(line)'

        iedorep_recurse, dofile("`file'") ///
                         output("`output'") ///
                         stub("m_`++subf_n'")
        local sub_fw "`r(filewrite)'"
        local sub_fc "`r(filecheck)'"

        * Substitute the original sub-dofile with the check/write ones
        local fwrite_line = subinstr(`"`macval(line)'"',`"`macval(file)'"',`""`sub_fw'""',1)
        local fcheck_line = subinstr(`"`macval(line)'"',`"`macval(file)'"',`""`sub_fc'""',1)

        *Correct potential ""path"" to "path"
        local fcheck_line = subinstr(`"`fcheck_line'"',`""""',`"""',.)
        local fwrite_line = subinstr(`"`fwrite_line'"',`""""',`"""',.)

      }
      else if (inlist("`fw'","local")) {

        * Execute line with local to be able to
        * assemble file paths in recursive calls
        `line'

        * Write local line as normal
        local fwrite_line `"`macval(line)'"'
        local fcheck_line `"`macval(line)'"'

      }
      else {
        * No special row, just write the lines as is
        local fwrite_line `"`macval(line)'"'
        local fcheck_line `"`macval(line)'"'
      }

      file write `handle_w' `"`macval(fwrite_line)'"' _n
      file write `handle_w' `"iedorep_line, lnum(`lnum') datatmp("`file_d'") mode(write)"' _n

      file write `handle_c' `"`macval(fcheck_line)'"' _n
      file write `handle_c' `"iedorep_line, lnum(`lnum') datatmp("`file_d'") mode(check)"' _n

      local lnum = `lnum' + 1
  }

  /*****************************************************************************
    Close all tempfiles
  *****************************************************************************/

  foreach filehandle in `handle_o' `handle_w' `handle_c' `handle_d' {
      file close `filehandle'
  }

  /*****************************************************************************
    Return tempfiles so they can be used in when the test is run
  *****************************************************************************/
  return local filewrite "`file_w'"
  return local filecheck "`file_c'"

end


* This file can delete all your folders on your computer if used incorrectly.

cap program drop r_rmdir
	program define r_rmdir

	syntax , folder(string)

  *Test that folder exist
  mata : st_numscalar("r(dirExist)", direxists("`folder'"))
  if (`r(dirExist)' != 0) {

  	* File paths can have both forward and/or back slash.
    * We'll standardize them so they're easier to handle
  	local folderStd			= subinstr(`"`folder'"',"\","/",.)

  	* List directories, files and other files
    local dlist : dir `"`folderStd'"' dirs  "*" , respectcase
    local flist : dir `"`folderStd'"' files "*"	, respectcase
  	local olist : dir `"`folderStd'"' other "*"	, respectcase
    local files `"`flist' `olist'"'

  	* Recursively call this command on all subfolders
  	foreach dir of local dlist {
  		r_rmdir , folder(`"`folderStd'/`dir'"')
  	}

  	* Remove files in this folder
  	foreach file of local files {
  		rm `"`folderStd'/`file'"'
  	}

  	* Remove this folder as it is now empty
  	rmdir `"`folderStd'"'
  }
end
