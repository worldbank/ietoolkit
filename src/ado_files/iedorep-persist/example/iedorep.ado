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

  * Line write locals
  local lnum = 1
  local leof = 0
  local subf_n = 0

  * Line parse locals
  local block_stack  ""
  local loopblock    0
  local commentblock 0
  local last_line    ""

  file open `handle_o' using "`dofile'", read

  while `leof' == 0 {
      * Read next line

      file read `handle_o' line
      local leof = `r(eof)'

      /* If last line was "///" append to line to write as one line */
      local line = `"`macval(last_line)' `macval(line)'"'

      * Parse line
      org_line_parse, line(`"`macval(line)'"') ///
                      block_stack(`block_stack')  ///
                      loopblock(string)    ///
                      commentblock(string)
      noi di ""
      noi di "*****************************"
      noi di `"`macval(line)'"'
      noi return list
      local write_adoline = `r(write_adoline)'
      local firstw        = "`r(firstw)'"
      local secondw       = "`r(secondw)'"
      local thirdw        = "`r(thirdw)'"
      local line_wrap     = `r(line_wrap)'
      local block_stack   = "`r(block_stack)'"

      * Add this line to last line and read next line
      * This is to break up lines split onto multiple lines to one line
      if (`line_wrap' == 1) {
        local break_pos = strpos(`"`macval(line)'"',"///")
        local last_line = substr(`"`macval(line)'"',1,`break_pos'-1)
      }
      else {
        *Reset the last line local if needed
        local last_line = ""

        if (inlist("`firstw'","do","run","ru")) {

          * Get the file path from the second word
          local file = `"`macval(secondw)'"'

          iedorep_recurse, dofile("`file'") ///
                           output("`output'") ///
                           stub("m_`++subf_n'")
          local sub_fw "`r(filewrite)'"
          local sub_fc "`r(filecheck)'"

          * Substitute the original sub-dofile with the check/write ones
          local fwrite_line = subinstr(`"`line'"',`"`file'"',`""`sub_fw'""',1)
          local fcheck_line = subinstr(`"`line'"',`"`file'"',`""`sub_fc'""',1)

          *Correct potential ""path"" to "path"
          local fcheck_line = subinstr(`"`fcheck_line'"',`""""',`"""',.)
          local fwrite_line = subinstr(`"`fwrite_line'"',`""""',`"""',.)
        }

        * No special thing with row needing alteration, write row as is
        else {

          * Copy the lines as is
          local fwrite_line `"`macval(line)'"'
          local fcheck_line `"`macval(line)'"'

          * Load the local in memory - important to
          * build file paths in recursive calls
          if (inlist("`firstw'","local")) {
            `line'
          }
        }

        * Write the line copied from original file
        file write `handle_w' `"`macval(fwrite_line)'"' _n
        file write `handle_c' `"`macval(fcheck_line)'"' _n

        if (`write_adoline' == 1) {
          file write `handle_w' `"iedorep_line, lnum(`lnum') datatmp("`file_d'") mode(write)"' _n
          file write `handle_c' `"iedorep_line, lnum(`lnum') datatmp("`file_d'") mode(check)"' _n
        }
      }

      local ++lnum
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

cap program drop org_line_parse
	program define org_line_parse , rclass

  syntax, line(string) ///
          [block_stack(string) loopblock(string) commentblock(string)]

  *Define defaults to be returned
  local write_adoline 1
  local firstw        ""
  local secondw       ""
  local thirdw        ""
  local line_wrap     0
  local block_stack  `block_stack'

  * Get the first words
  tokenize `macval(line)'

  * Handle quietly and noisily
  if (substr(`"`1'"',1,3)=="qui") | (substr(`"`1'"',1,1)=="n") {
    * Test if beginning of a noi/qui block
    if strpos(`"`macval(line)'"',"{") {
      local block_stack trim("`=subinstr("`1'",":","",1)' `block_stack'")
    }
    * Retokenize without the noi/qui syntax (including the ":")
    local nline = subinstr(`"`macval(line)'"',"`1'","",1)
    if (`"`2'"' == ":") ///
      local nline = subinstr(`"`macval(nline)'"',"`2'","",1)
    if (substr(`"`1'"',1,1)==":") ///
      local nline = subinstr(`"`macval(nline)'"',":","",1)
    tokenize `macval(nline)'
  }

  // TODO: do the same to remove the if-

  *
  local firstw  `"`macval(1)'"'
  local secondw `"`macval(2)'"'
  local thirdw  `"`macval(3)'"'

  * Closed curly bracket - End of block
  if (substr(`"`firstw'"',1,1)=="}") {
    local write_adoline 0
    local block_end : word 1 of `block_stack'
    local block_stack = subinstr("`block_stack'","`block_end'","",1)
  }

  /* /// line wrap  */
  if (strpos(`"`macval(line)'"',"///")) local line_wrap 1

  * Return all info
  return local write_adoline `write_adoline'
  return local firstw        `"`macval(firstw)'"'
  return local secondw       `"`macval(secondw)'"'
  return local thirdw        `"`macval(thirdw)'"'
  return local line_wrap     `line_wrap'
  return local block_stack   "`block_stack'"

end

* This program can delete all your folders on your computer if used incorrectly.
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
