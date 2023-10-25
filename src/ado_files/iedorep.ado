*! version 7.2 04APR2023 DIME Analytics dimeanalytics@worldbank.org

cap program drop iedorep
program define   iedorep, rclass

qui {
  syntax anything [using/] , [verbose] [compact] [noClear] [debug]

  /*****************************************************************************
    Syntax parsing and setup
  *****************************************************************************/

  local dofile `anything'
    local ofname = substr(`"`dofile'"',strrpos(`"`dofile'"',"/")+1,.)

  local output `using'
    if `"`output'"' == `""' {
      local output = substr(`"`dofile'"',1,strrpos(`"`dofile'"',"/"))
    }

  di `"`dofile' || `output'"'

  if missing(`"`clear'"') {
    clear          // Data matches, zeroed out by default
    set seed 12345 // Use Stata default setting when starting routine
  }

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

  * Cannot choose verbose and compact
  if !missing(`"`verbose'"') local compact ""

  /*****************************************************************************
    Set up output structure
  *****************************************************************************/

  * Remove existing output if it exists
  mata : st_numscalar("r(dirExist)", direxists("`output'/iedorep"))
  if (`r(dirExist)' == 1) rm_output_dir, folder("`output'/iedorep")

  * Create the new output folder structure
  local dirout "`output'/iedorep"
  mkdir "`dirout'"

  * Create the subfolders in the output folder structure
  foreach odir in run1 run2 {
    local d`odir' "`dirout'/`odir'"   //Create a local to folder path
    mkdir "`d`odir''"                  //Create this folder
  }

  /*****************************************************************************
    Generate the run 1 and run 2 do-files
  *****************************************************************************/

  noi di as res ""
  noi di as res "{phang}Starting idorep. Creating the do-files for run 1 and run 2.{p_end}"
  noi iedorep_recurse, dofile("`dofile'") output("`dirout'") stub("m")
  local code_file_run1 "`r(code_file_run1)'"
  local code_file_run2 "`r(code_file_run2)'"
  noi di as res "{phang}Done creating the do-files for run 1 and run 2.{p_end}"

  /*****************************************************************************
    Execute the run 1 and run 2 file to write the data files
  *****************************************************************************/

  noi di as res "{phang}Executing the do-file for run 1.{p_end}"
  clear
  do "`code_file_run1'"
  noi di as res "{phang}Done executing the do-file for run 1.{p_end}"
  noi di as res "{phang}Executing the do-file for run 2.{p_end}"
  clear
  do "`code_file_run2'"
  noi di as res "{phang}Done executing the do-file for run 2.{p_end}"

  /*****************************************************************************
    Compare the data files and output the result
  *****************************************************************************/

  * Output locals
  local outputcolumns "10 37 64 91 110"
  tempname h_smcl
  tempfile f_smcl

  noi di as res "{phang}Generating the report for comparing the two runs.{p_end}"

  * Set up output smcl file
  file open `h_smcl' using `f_smcl', write
  noi write_and_print_output, h_smcl(`h_smcl') intro_output

  * Set up the titles for the first recursive call
  noi write_and_print_output, h_smcl(`h_smcl') l1(" ") ///
    l2(`"{phang}Checking file:{p_end}"')
  noi print_filetree_and_verbose_title, ///
    files(`" "`dofile'" "') h_smcl(`h_smcl') `verbose' `compact'
  output_writetitle , outputcolumns("`outputcolumns'")
  noi write_and_print_output, h_smcl(`h_smcl') ///
    l1("`r(topline)'") l2("`r(state_titles)'") ///
    l3("`r(col_titles)'") l4("`r(midline)'")

  * Start the recursive call
  noi recurse_comp_lines , dirout("`dirout'") stub("m") ///
    orgfile(`"`dofile'"') outputcolumns("`outputcolumns'") ///
    `verbose' `compact' h_smcl(`h_smcl')

  * Write line that close table
  output_writetitle , outputcolumns("`outputcolumns'")
  noi write_and_print_output, h_smcl(`h_smcl') ///
    l1(`"{phang}Done checking file:{p_end}"') ///
    l2(`"{pstd}{c BLC}{hline 1}> `dofile'{p_end}"') l3("{hline}")
  file close `h_smcl'

/*****************************************************************************
      Write smcl file to disk and clean up intermediate files unless debugging
*****************************************************************************/

  copy `f_smcl' "`dirout'/`ofname'rep.smcl" , replace
  noi di as res ""
  noi di as res `"{phang}SMCL-file with report written to: {view "`dirout'/`ofname'rep.smcl"}{p_end}"'

  if missing("`debug'") {
    rm_output_dir , folder("`dirout'/run1/")
    rm_output_dir , folder("`dirout'/run2/")
  }

}

end

/*****************************************************************************
******************************************************************************

 Sub-programs for: Writing run 1 and run 2 dofile

******************************************************************************
*****************************************************************************/

* Go over the do-file to create run 1 and run 2 do-files. Run 1 and 2 are identical with each other and the orginal file with two exceptions. Run 1 and run 2 writes after each line of code the states to a data file each.
cap program drop iedorep_recurse
program define   iedorep_recurse, rclass
qui {
  syntax, dofile(string) output(string) stub(string)

  /*****************************************************************************
    Create the files that this recursive call needs
  *****************************************************************************/

  * For each run there will be a code and a data file. The code file is what
  * is being run in each run, and the data file is where the states
  * will be written to
  foreach run in 1 2 {
    * Create code and data output file for each run
    tempname handle_c`run' handle_d`run'
    *Create locals for the file
    local file_c`run' "`output'/run`run'/`stub'.do"
    local file_d`run' "`output'/run`run'/`stub'.txt"
    * Create the files
    file open `handle_c`run'' using "`file_c`run''", write
    file open `handle_d`run'' using "`file_d`run''", write
  }

  /*****************************************************************************
    Loop over the do-file to create the write and check files
  *****************************************************************************/

  *Read orginal file and create fun file 1 and create write file and check file

  * Line write locals
  local lnum = 1
  local leof = 0
  local subf_n = 0

  * Line parse locals
  local block_stack  ""
  local loopblock    0
  local commentblock 0
  local last_line    ""
  local loop_stack ""

  * Open the orginal file
  tempname handle_o
  file open `handle_o' using "`dofile'", read

  * Loop until end of file
  while `leof' == 0 {
      * Read next line
      file read `handle_o' line
      local leof = `r(eof)'

      /* Lines with /// are concatenated to long single lines.
      If the previous line was a /// line then that content is
      in the last_line local which is here concatenated. */
      local line = `"`macval(last_line)' `macval(line)'"'

      * Analyze line in parser to see if this line needs and special handling
      org_line_parse, line(`"`macval(line)'"')
      local write_dataline = `r(write_dataline)'
      local firstw        = "`r(firstw)'"
      local secondw       = "`r(secondw)'"
      local thirdw        = "`r(thirdw)'"
      local line_wrap     = `r(line_wrap)'
      local block_end     = `r(block_end)'
      local block_add     = "`r(block_add)'"

      * If this row is closed curly bracket then
      * remove most recent word from stack
      if (`r(block_end)' == 1) {
        local block_pop : word 1 of `block_stack'
        local block_stack = subinstr("`block_stack'","`block_pop'","",1)

        if inlist("`block_pop'","foreach","forvalues","while") {
          local loop_stack = strreverse("`loop_stack'")
          local loop_pop : word 1 of `loop_stack'
          local loop_stack = strreverse( ///
            subinstr("`loop_stack'","`loop_pop'","",1))
        }
      }

      * Add if/else/noi/qui to block stack
      if (!missing("`r(block_add)'")) {
        local block_stack   "`r(block_add)' `block_stack' "
      }

      * Reset default locals for this line
      local write_recline = 0

      * Remove /// and pass this line to be included in next line as
      * multiline code is being written to one line in the write/check files
      if (`line_wrap' == 1) {
        local break_pos = strpos(`"`macval(line)'"',"///")
        local last_line = substr(`"`macval(line)'"',1,`break_pos'-1)
      }

      * Not part of a multiline line
      else {

        *Reset the last line local
        local last_line = ""
        get_command, word("`firstw'")
        local lcmd = "`r(command)'"

        * Line is do or run, so call recursive function
        if (inlist("`lcmd'","do","run")) {

          * Write line handline recursion in data file
          local write_recline = 1
          * Keep working on the stub
          local recursestub "`stub'_`++subf_n'"

          * Get the file path from the second word
          local file = `"`macval(secondw)'"'

          noi iedorep_recurse, dofile("`file'")     ///
                               output("`output'")   ///
                               stub("`recursestub'")
          local sub_f1 "`r(code_file_run1)'"
          local sub_f2 "`r(code_file_run2)'"

          * Substitute the original sub-dofile with the check/write ones
          local fwrite_line = subinstr(`"`line'"',`"`file'"',`""`sub_f1'""',1)
          local fcheck_line = subinstr(`"`line'"',`"`file'"',`""`sub_f2'""',1)

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
          if inlist("`lcmd'","local","global") {
            `line'
          }

          * Write foreach/forvalues to block stack and
          * it's macro name to loop stack
          if inlist("`lcmd'","foreach","forvalues") {
            local block_stack   "`lcmd' `block_stack' "
            local loop_stack = trim("`loop_stack' `secondw'")
          }

          * Write while to block stack and
          * also "while" to loop stack as it does not have a macro name
          if inlist("`lcmd'","while") {
            local block_stack   "`lcmd' `block_stack' "
            local loop_stack = trim("`loop_stack' `lcmd'")
          }
        }

        if (`write_recline' == 1) {
          file write `handle_c1' `"iedorep_dataline, lnum(`lnum') datatmp("`file_d1'") recursestub(`recursestub') orgsubfile(`file')"' _n
          file write `handle_c2' `"iedorep_dataline, lnum(`lnum') datatmp("`file_d2'") recursestub(`recursestub') orgsubfile(`file')"' _n
        }

        * Write the line copied from original file
        file write `handle_c1' `"`macval(fwrite_line)'"' _n
        file write `handle_c2' `"`macval(fcheck_line)'"' _n

        if (`write_dataline' == 1) {

          * prepare loop_string with macros
          local loop_str = ""
          foreach loop_macname of local loop_stack {
            if ("`loop_macname'"=="while") {
              local loop_str = "`macval(loop_str)' while"
            }
            else {
              local loop_str = ///
                "`macval(loop_str)' `loop_macname':\``loop_macname''"
            }
          }

          * Write lines to run file 1 and 2
          file write `handle_c1' `"iedorep_dataline, lnum(`lnum') datatmp("`file_d1'") looptracker("`macval(loop_str)'")"' _n
          file write `handle_c2' `"iedorep_dataline, lnum(`lnum') datatmp("`file_d2'") looptracker("`macval(loop_str)'")"' _n
        }
      }
      local ++lnum
  }

  /*****************************************************************************
    Close all tempfiles
  *****************************************************************************/

  foreach fh in `handle_o' `handle_c1' `handle_c2' `handle_da' `handle_db' {
      file close `fh'
  }

  /*****************************************************************************
    Return tempfiles so they can be used in when the test is run
  *****************************************************************************/
  return local code_file_run1 "`file_c1'"
  return local code_file_run2 "`file_c2'"
}
end

cap program drop org_line_parse
	program define org_line_parse , rclass

  syntax, line(string)

  *Define defaults to be returned
  local write_dataline 1
  local firstw        ""
  local secondw       ""
  local thirdw        ""
  local line_wrap     0
  local block_add     ""
  local block_end     0

  * Get the first words
  tokenize `" `macval(line)' "'

  ***********************************
  * Handle quietly and noisily
  ***********************************

  get_command , word(`"`1'"')
  local lcmd = "`r(command)'"

  if inlist("`lcmd'","quietly","noisily") {
    * Test if beginning of a noi/qui block
    if strpos(`"`macval(line)'"',"{") {
      local block_add "`lcmd'"
    }
    * Retokenize without the noi/qui syntax (including the ":")
    local nline = subinstr(`"`macval(line)'"',"`1'","",1)
    if (`"`2'"' == ":") ///
      local nline = subinstr(`"`macval(nline)'"',"`2'","",1)
    if (substr(`"`1'"',1,1)==":") ///
      local nline = subinstr(`"`macval(nline)'"',":","",1)
    tokenize `" `macval(nline)' "'
  }

  ***********************************
  * Handle if-else
  ***********************************

  if inlist("`lcmd'","if","else") {
    if strpos(`"`macval(line)'"',"{") {
      local block_add "`lcmd'"
    }
  }

  ***********************************
  * Parse the line
  ***********************************

  local firstw  `"`macval(1)'"'
  local secondw `"`macval(2)'"'
  local thirdw  `"`macval(3)'"'

  * Empty line - skip writing to data file
  if (itrim(trim(`"`macval(line)'"')) == "") {
    local write_dataline 0
  }

  * Closed curly bracket - End of block
  else if (substr(`"`firstw'"',1,1)=="}") {
    local write_dataline 0
    local block_end = 1
  }

  /* /// line wrap  */
  if (strpos(`"`macval(line)'"',"///")) local line_wrap 1

  * Return all info
  return local write_dataline `write_dataline'
  return local firstw         `"`macval(firstw)'"'
  return local secondw        `"`macval(secondw)'"'
  return local thirdw         `"`macval(thirdw)'"'
  return local line_wrap      `line_wrap'
  return local block_end      `block_end'
  return local block_add      "`block_add'"


end

* This program see if the string passed in word() is a match
* (full word or abbreviation) to a command that toggles some
* special beavior when writing the write and check files
cap program drop get_command
    program define get_command, rclass

    syntax, [word(string)]

    local wlen = strlen("`word'")

    local commands ""
    local commands "`commands' do ru:n"                    // File execution
    local commands "`commands' foreach forv:alues while"   // Iterations
    local commands "`commands' if else"                    // Logic
    local commands "`commands' loc:al gl:obal"             // Macros
    local commands "`commands' qui:etly n:oisily"          // Qui/noi
    local match = 0

    foreach command of local commands {
      if (`match'==0) {
        gettoken abbr rest : command, parse(":")
        local rest = subinstr("`rest'",":","",1)
        local labbr = strlen("`abbr'")

        *Test if minimum abbreviation is the same
        if (substr("`word'",1,`labbr')=="`abbr'") {
          *Test if remaining part of the word match the rest of the command
          if (substr("`word'",`labbr'+1,.)==substr("`rest'",1,`wlen'-`labbr')) {
             return local command "`abbr'`rest'"
             local match = 1
          }
        }
      }
    }

    * No match, return OTHER
    if (`match'==0) {
        return local command "OTHER"
    }

end

/*****************************************************************************
******************************************************************************

 Sub-programs for: Comparing results in data files line by line

******************************************************************************
*****************************************************************************/

cap program drop recurse_comp_lines
program define   recurse_comp_lines, rclass
qui {
  syntax, dirout(string) stub(string) orgfile(string) ///
  outputcolumns(string) h_smcl(string) [verbose] [compact]


  local df1 "`dirout'/run1/`stub'.txt"
  local df2 "`dirout'/run2/`stub'.txt"

  tempname handle_df1 handle_df2
  file open `handle_df1' using "`df1'", read
  file open `handle_df2' using "`df2'", read

  local prev_line1 ""
  local prev_line2 ""

  * Loop over all lines in the two data files
  local eof = 0
  while `eof' == 0 {

    * Read next line of data file 1
    file read `handle_df1' line1
    local eof1 = `r(eof)'
    * Read next line of data file 2
    file read `handle_df2' line2
    local eof2 = `r(eof)'

    *****************************
    * Test lines to see if the comparison is valid
    *****************************

    *Test if both lines are identitical
    local lines_identical = (`"`line1'"'==`"`line2'"')

    * Testing that not just one
    local eof = (`eof1' + `eof2')/2
    if (`eof' == .5) {
      noi di "Only one data file came to an end, that is an error"
      error 198
    }

    * Test if rows are recurse rows
    local is_recurse1 = ("`: word 1 of `line1''" == "recurse")
    local is_recurse2 = ("`: word 1 of `line2''" == "recurse")
    local recurse = (`is_recurse1' + `is_recurse2')/2
    if (`recurse' == .5) {
      noi di as error "Internal error: It should never be the case that only one row is a recurse row"
      error 198
    }
    else if (`recurse' == 1 & `lines_identical' == 0) {
      noi di as error "Internal error: Both rows are recurse but they are different"
      error 198
    }

    *****************************
    * Test lines to see if the comparison is valid
    *****************************

    * Skip rest if reached end of file
    if (`eof' != 1) {

      * If line is a recurse line, then recurese over that file
      if (`recurse' == 1 ) {

        * Getting stub name and orig ndofile name from recurse line
        local new_stub    : word 2 of `line1'
        local new_orgfile : word 3 of `line1'

        * Write end to previous table, write the file tree for the next
        * recursion, and write the beginning of that table
        output_writetitle , outputcolumns("`outputcolumns'")
        noi write_and_print_output, h_smcl(`h_smcl') ///
          l1("`r(botline)'") l2(" ") ///
          l3(`"{pstd} Stepping into sub-file:{p_end}"')
        noi print_filetree_and_verbose_title, ///
          files(`" `orgfile' "`new_orgfile'" "') h_smcl(`h_smcl') `verbose' `compact'
        output_writetitle , outputcolumns("`outputcolumns'")
        noi write_and_print_output, h_smcl(`h_smcl') ///
          l1("`r(topline)'") l2("`r(state_titles)'") ///
          l3("`r(col_titles)'") l4("`r(midline)'")

        * Make the recurisive call for next file
        noi recurse_comp_lines , dirout("`dirout'") stub("`new_stub'") ///
          orgfile(`"`orgfile' "`new_orgfile'" "') ///
          outputcolumns("`outputcolumns'") h_smcl(`h_smcl') `verbose' `compact'

        * Step back into this data file after the recursive call and:
        * Write file tree, and write the titles to the continuation for
        * this file
        noi write_and_print_output, h_smcl(`h_smcl') ///
          l1(`"{phang} Stepping back into file:{p_end}"')
        noi print_filetree_and_verbose_title, ///
          files(`" "`orgfile'" "') h_smcl(`h_smcl') `verbose' `compact'
        output_writetitle , outputcolumns("`outputcolumns'")
        noi write_and_print_output, h_smcl(`h_smcl') ///
            l1("`r(topline)'") l2("`r(state_titles)'") ///
            l3("`r(col_titles)'") l4("`r(midline)'")
      }
      * Line is data and not recurse : compare the lines
      else {

        * Compare if lines are different across runs, but also if lines has changed since last line
        compare_data_lines, ///
          l1("`line1'") pl1("`prev_line1'") ///
          l2("`line2'") pl2("`prev_line2'")

        * Only display line if there is a mismatch, or if option verbose
        * is used, also output if there is a change from previous line
        local write_outputline 0

          * Check each value individually for changes and mismatches
          foreach matchtype in rng srng dsig {
            * Test if any line is "Change"
            local any_change = ///
              strpos("`r(`matchtype'_c1)'`r(`matchtype'_c2)'","Change")
            if (`any_change' > 0 & !missing(`"`verbose'"')) ///
              local write_outputline 1
            * Test if any line is "Missmatch"
            local any_mismatch = ///
              max(strpos("`r(`matchtype'_m)'","NO"),strpos("`r(`matchtype'_m)'","|"))
            if (`any_mismatch' > 0) & missing(`"`compact'"') local write_outputline 1
            * Compact display
            if (`any_mismatch' > 0) & (`any_change' > 0) local write_outputline 1
          }

        * If line is supposed to be outputted, write line
        if (`write_outputline' == 1 ) {
          output_writerow ,                                                  ///
            outputcolumns("`outputcolumns'") lnum("`r(lnum)'")               ///
            rng1("`r(rng_c1)'")   rng2("`r(rng_c2)'")   rngm("`r(rng_m)'")   ///
            srng1("`r(srng_c1)'") srng2("`r(srng_c2)'") srngm("`r(srng_m)'") ///
            dsig1("`r(dsig_c1)'") dsig2("`r(dsig_c2)'") dsigm("`r(dsig_m)'") ///
            loopiteration("`r(loopt)'")
          noi write_and_print_output, h_smcl(`h_smcl') l1("`r(outputline)'")
        }

        * Load these lines into pre_line locals for next run
        local prev_line1 "`line1'"
        local prev_line2 "`line2'"
      }
    }
    * End of this data file
    else {
      * Close the table for his file
      output_writetitle , outputcolumns("`outputcolumns'")
      noi write_and_print_output, h_smcl(`h_smcl') ///
        l1("`r(botline)'") l2(" ")
    }
  }
}
end

cap program drop compare_data_lines
program define   compare_data_lines, rclass

    syntax, l1(string) l2(string) [pl1(string) pl2(string)]

    * Parse all lines and put then into locals to be compared
    foreach line in l1 l2 pl1 pl2 {
      local data "``line''"
      while !missing(`"`data'"') {
          * Parse next key:value pair of data
          gettoken keyvaluepair data : data, parse("&")
          local data = substr("`data'",2,.) // remove parse char
          * Get key and value from pair and return
          gettoken key value : keyvaluepair, parse(":")
          local `line'_`key' = substr("`value'",2,.) // remove parse char
      }
    }

    * Testing an returning line number
    if ("`l1_l'" != "`l2_l'") {
        noi di as error "Internal error: The line number should always be the same in data line from run 1 and run 2. But in this case line number in run 1 it is `l1_l', and in run 2 it is `l1_2'"
        error 198
    }
    return local lnum "`l1_l'"

    if ("`l1_loopt'" != "`l1_loopt'") {
        noi di as error "Internal error: The looptracker should always be the same in data line from run 1 and run 2. But in this case looptracker in run 1 it is `l1_loopt', and in run 2 it is `l2_loopt'"
        error 198
    }
    return local loopt "`l1_loopt'"

    * Comparing all states since previous line and between runs
    foreach state in rng srng dsig {
        * Comapre state in each run compared to previous line
        foreach run in 1 {
          local `state'_c`run' = " "
          if ("`l`run'_`state''" != "`pl`run'_`state''") {
            local `state'_c`run' = "Change"
          }
        }
        foreach run in 2 {
          local `state'_c`run' = " "
          if ("`l`run'_`state''" != "`pl`run'_`state''") {
            if "``state'_c1'" == "Change" local `state'_c`run' = "{c -}{c -}{c -}{c -}{c -}>"
            else local `state'_c`run' = "{err:Error!}"
          }
        }
        * Compare state between runs
        if ("`l1_`state''" == "`l2_`state''") & (("``state'_c1'" == "Change") | ("``state'_c2'" == "{c -}{c -}{c -}{c -}{c -}>")) return local `state'_m "   OK!"
        if ("`l1_`state''" == "`l2_`state''") & (("``state'_c1'" != "Change") & ("``state'_c2'" != "{c -}{c -}{c -}{c -}{c -}>")) return local `state'_m "      "
        if ("`l1_`state''" != "`l2_`state''") & (("``state'_c1'" == "Change") | ("``state'_c2'" == "{c -}{c -}{c -}{c -}{c -}>")) return local `state'_m "{err:NO}"
        if ("`l1_`state''" != "`l2_`state''") & (("``state'_c1'" != "Change") & ("``state'_c2'" != "{c -}{c -}{c -}{c -}{c -}>")) return local `state'_m "{err:|}"

        if ("`l1_`state''" != "`l2_`state''") & (("``state'_c1'" == "Change") | ("``state'_c2'" == "{c -}{c -}{c -}{c -}{c -}>"))  local `state'_c1 "{err:``state'_c1'}"
        if ("`l1_`state''" != "`l2_`state''") & (("``state'_c1'" == "Change") | ("``state'_c2'" == "{c -}{c -}{c -}{c -}{c -}>"))  local `state'_c2 "{err:``state'_c2'}"
        return local `state'_c1 "``state'_c1'"
        return local `state'_c2 "``state'_c2'"

    }
end

/*****************************************************************************
******************************************************************************

 Sub-programs for: Output results

******************************************************************************
*****************************************************************************/

* This sub-program prints output to file and screen.
* It can print up to 6 lines at the same time l1-l6
* It has a shorthand to print the intro output
cap program drop write_and_print_output
program define   write_and_print_output, rclass

  syntax , h_smcl(string) [intro_output ///
    l1(string) l2(string) l3(string) l4(string) l5(string) l6(string)]

  * Prepare setup lines
  if !missing("`intro_output'") {
    local l1 " "
    local l2 "{hline}"
    local l3 "`line'{phang}iedorep output created by user `c(username)' at `c(current_date)' `c(current_time)'{p_end}"
    local l4 "`line'{phang}Operating System `c(machine_type)' `c(os)' `c(osdtl)'{p_end}"
    local l5 "`line'{phang}Stata `c(edition_real)' - Version `c(stata_version)' running as version `c(version)'{p_end}"
    local l6 "{hline}"
  }

  * Output and write the lines
  forvalues line = 1/6 {
    if !missing(`"`l`line''"') {
      noi di as res `"`l`line''"'
      file write `h_smcl' `"`l`line''"' _n
    }
  }
end

cap program drop output_writerow
	program define output_writerow, rclass

  syntax , outputcolumns(numlist) lnum(string) ///
    [rng1(string)  rng2(string)  rngm(string) ///
    srng1(string) srng2(string) srngm(string) ///
    dsig1(string) dsig2(string) dsigm(string) ///
    loopiteration(string)]

  local c1 : word 1 of `outputcolumns'
  local c2 : word 2 of `outputcolumns'
  local c3 : word 3 of `outputcolumns'
  local c4 : word 4 of `outputcolumns'
  local c5 : word 5 of `outputcolumns'

  * Line number
  local out_line "{c |} `lnum' {col `c1'}"

  * Rng state
  local c1 = (`c1' + 9)
  local out_line "`out_line'{c |} `rng1'{col `c1'}"
  local c1 = (`c1' + 9)
  local out_line "`out_line'  `rng2'{col `c1'}"
  local out_line "`out_line'  `rngm'{col `c2'}"

  * Sort rng state
  local c2 = (`c2' + 9)
  local out_line "`out_line'{c |} `srng1'{col `c2'}"
  local c2 = (`c2' + 9)
  local out_line "`out_line'  `srng2'{col `c2'}"
  local out_line "`out_line'  `srngm'{col `c3'}"

  * Datasignature
  local c3 = (`c3' + 9)
  local out_line "`out_line'{c |} `dsig1'{col `c3'}"
  local c3 = (`c3' + 9)
  local out_line "`out_line'  `dsig2'{col `c3'}"
  local out_line "`out_line'  `dsigm'{col `c4'}"


  local out_line "`out_line'{c |} `loopiteration'"
  return local outputline `out_line'

end

cap program drop output_writetitle
	program define output_writetitle, rclass

  syntax , outputcolumns(string)

  local c1 : word 1 of `outputcolumns'
  local c2 : word 2 of `outputcolumns'
  local c3 : word 3 of `outputcolumns'
  local c4 : word 4 of `outputcolumns'
  local c5 : word 5 of `outputcolumns'

  local h1 = `c1'-2
  local h2 = `c2'-`c1'-1
  local h3 = `c3'-`c2'-1
  local h4 = `c4'-`c3'-1
  local h5 = `c5'-`c4'-1

  * Top-line
  local tt "{c TT}"
  local tl "{c TLC}{hline `h1'}`tt'{hline `h2'}`tt'{hline `h3'}`tt'{hline `h4'}"
  return local topline "`tl'`tt'{hline `h5'}"

  * State titel line
  local sl "{c |}{col `c1'}"
  local sl "`sl'{c |}{dup 6: }Seed RNG State{col `c2'}"
  local sl "`sl'{c |}{dup 6: }Sort Order RNG{col `c3'}"
  local sl "`sl'{c |}{dup 6: }Data Signature{col `c4'}"
  return local state_titles "`sl'{c |}"

  * Column title line
  local ct "{c |} Run 1  {c |} Run 2  {c |} Match  "
  local cl "{c |} Line # {col `c1'}"
  local cl "`cl'`ct'{col `c2'}`ct'{col `c3'}`ct'{col `c4'}{c |}"
  return local col_titles "`cl' Loop iteration:"

  * Middle-line
  local mt "{c +}"
  local ml "{c LT}{hline 8}`mt'"
  local ml "`ml'{hline 8}`mt'{hline 8}`mt'{hline 8}`mt'"
  local ml "`ml'{hline 8}`mt'{hline 8}`mt'{hline 8}`mt'"
  local ml "`ml'{hline 8}`mt'{hline 8}`mt'{hline 8}`mt'"
  return local midline "`ml'{hline `h5'}"

  * Bottom-line
  local bt "{c BT}"
  local bl "{c BLC}{hline 8}`bt'"
  local bl "`bl'{hline 8}`bt'{hline 8}`bt'{hline 8}`bt'"
  local bl "`bl'{hline 8}`bt'{hline 8}`bt'{hline 8}`bt'"
  local bl "`bl'{hline 8}`bt'{hline 8}`bt'{hline 8}`bt'"
  return local botline "`bl'{hline `h5'}"

end

* Print file tree
cap program drop print_filetree_and_verbose_title
program define   print_filetree_and_verbose_title, rclass
  syntax , files(string) h_smcl(string) [verbose] [compact]
  local file_count = 0
  foreach file of local files {
    noi write_and_print_output, h_smcl(`h_smcl') ///
      l1(`"{pstd}{c BLC}{hline `++file_count'}> `file'{p_end}"')
  }

  noi di ""
  if missing("`verbose'") & missing("`compact'") {
    noi di as res "{phang}Lines where Run 1 and Run 2 mismatch for any value:{p_end}"
  }

  if !missing("`verbose'") {
    noi di as res "{phang}Lines where Run 1 and Run 2 mismatch {ul:or} change for any value:{p_end}"
  }

  if !missing("`compact'") {
    noi di as res "{phang}Lines where Run 1 and Run 2 mismatch {ul:and} change for any value:{p_end}"
  }

end

/*****************************************************************************
******************************************************************************

 Utility sub-programs

******************************************************************************
*****************************************************************************/

* This program can delete all your folders on your computer if used incorrectly.
cap program drop rm_output_dir
	program define rm_output_dir

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
  		rm_output_dir , folder(`"`folderStd'/`dir'"')
  	}

  	* Remove files in this folder
  	foreach file of local files {
  		rm `"`folderStd'/`file'"'
  	}

  	* Remove this folder as it is now empty
  	rmdir `"`folderStd'"'
  }
end
