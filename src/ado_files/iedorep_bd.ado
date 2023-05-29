*! version 1.1 XXXX DIME Analytics dimeanalytics@worldbank.org

cap  program drop  iedorep
  program define   iedorep, rclass

  syntax anything , ///
  [Recursive] ///
    [recurring(string asis)] [recurringlines(string asis)] /// Background
  [Output(string asis)] ///
  [Verbose] [alldata] [allsort] [allseed] [allpath] /// Verbose reporting of non-errors
  [debug] [qui] // Programming options to view exact temp do-file

/*****************************************************************************
Options
*****************************************************************************/






/*****************************************************************************
Big loop through target do-file contents
*****************************************************************************/
while r(eof)==0 {

  /*****************************************************************************
  Setup and state checks
  *****************************************************************************/



  // Reproduce file contents
    // Catch any [clear all] or [ieboilstart] commands


    // Catch comments
    if strpos(`"`macval(line)'"',"/*") local comment = 1
    if strpos(`"`macval(line)'"',"*/") local comment = 0

    // Monitor loop state to evaluate within loops

      // Evaluate if the thigns after the logic is a special key word
      if strpos(`"`macval(line)'"',"if ")     local logic = 1
      if strpos(`"`macval(line)'"',"else ")   local logic = 1

      // Evaluate where in a loop to run
      if strpos(`"`macval(line)'"',"forv")    local  loop = 1
      if strpos(`"`macval(line)'"',"foreach") local  loop = 1
      if strpos(`"`macval(line)'"',"while")   local  loop = 1

      // Never do iedorep_line after closing bracket
      if strpos(`"`macval(line)'"',"}")
      // Implement a stack to keep track of the closed brackets



  /*****************************************************************************
  Implement logic checks in file copy
  *****************************************************************************/
  local depth : word count `loopstate'



    // Catch any [do] or [run] commands for recursion
    if  strpos(`"`macval(line)'"',"do ") {
    else if  strpos(`"`macval(line)'"',"ru ") {
    if  strpos(`"`macval(line)'"',"run ") {


    // Flag changes to RNG state
    file write edited `"// RNG Check --------------------------- // "' _n
    file write edited ///
    `" if ("\`c(rngstate)'" != "\`\`theRNG''") {"' _n ///
      `"  post posty (`linenum_real') `allseed1'   "' _n ///
      `"  local \`theRNG' = "\`c(rngstate)'" "' _n ///
      `"  local \`allRNGS' = "\`\`allRNGS'' \`c(rngstate)'" "' _n ///
    `" }"'_n

    // Error changes to RNG state
    file write checkr `"// RNG Check -------------------------- // "' _n
    file write checkr ///
    `" if ("\`c(rngstate)'" != "\`\`theRNG''") {"' _n ///
      `"  local \`whichRNG' = \`\`whichRNG'' + 1"' _n ///
      `"  local \`theRNG' = "\`c(rngstate)'" "' _n ///
      `"  if ("\`c(rngstate)'" != "\`: word \`\`whichRNG'' of \`\`allRNGS'''") {"' _n ///
        `"   post posty (`linenum_real') `allseed2'  "' _n ///
      `"  }"'_n ///
    `" }"'_n

    // Flag changes to Sort RNG state
    file write edited `"// Sort Check -------------------------- // "' _n
    file write edited ///
    `" if ("\`c(sortrngstate)'" != "\`\`theSORT''") {"' _n ///
      `"  post posty (`linenum_real') `allsort1' "' _n ///
      `"  local \`whichSORT' = \`\`whichSORT'' + 1"' _n ///
      `"  local \`theSORT' = "\`c(sortrngstate)'" "' _n ///
      `"  tempfile sort_\`\`whichSORT''"' _n ///
      `"  save \`sort_\`\`whichSORT''' , emptyok"' _n ///
      `"  local theLOCALS "\`theLOCALS' sort_\`\`whichSORT''" "' _n ///
    `" }"'_n

    // Flag Errors to Sort RNG state
    file write checkr `"// Sort Check ------------------------- // "' _n
    file write checkr ///
    `" if ("\`c(sortrngstate)'" != "\`\`theSORT''") {"' _n ///
      `"  local \`whichSORT' = \`\`whichSORT'' + 1"' _n ///
      `"  local \`theSORT' = "\`c(sortrngstate)'" "' _n ///
      `"  cap cf _all using \`sort_\`\`whichSORT'''"' _n ///
      `"  if _rc != 0 {"'_n ///
          `"   post posty (`linenum_real') `allsort2' "' _n ///
      `"  }"'_n ///
    `" }"'_n

    // Flag changes to DATA state
    file write edited `"// Data Check -------------------------- // "' _n
    file write edited ///
    " datasignature" _n ///
    `" if ("\`r(datasignature)'" != "\`\`theDATA''") {"' _n ///
      `"  post posty (`linenum_real') `alldata1' "' _n ///
      `"  local \`theDATA' = "\`r(datasignature)'" "' _n ///
      `"  local \`allDATA' = "\`\`allDATA'' \`theDATA'" "' _n ///
    `" }"'_n
    file write edited `" "' _n _n

    // Error changes to DATA state
    file write checkr `"// Data Check -------------------------- // "' _n
    file write checkr ///
    " datasignature" _n ///
    `" if ("\`r(datasignature)'" != "\`\`theDATA''") {"' _n ///
    `"  local \`whichDATA' = \`\`whichDATA'' + 1"' _n ///
      `"  local \`theDATA' = "\`r(datasignature)'" "' _n ///
      `"  if ("\`theDATA'" != "\`: word \`\`whichDATA'' of \`\`allDATA'''") {"' _n ///
          `"   post posty (`linenum_real') `alldata2' "' _n ///
      `"  }"'_n ///
    `" }"'_n _n

    // Advance line number
    local linenum_real = `linenum'
  }

  // Error if delimiter                                                         TODO: Improve checking/erroring here
  if strpos(`"`macval(line)'"',"#d") {
    di as err "      Note: The delimiter may have been changed in this file (#d)."
    di as err " "
  }






/*****************************************************************************
Cleanup and then run the combined temp dofile
*****************************************************************************/



/*****************************************************************************
Output flags and errors to Stata window
*****************************************************************************/
qui {
  gen n = _n
  gen x = .
  forv i = 1/`c(N)' {
    if Line[`i'] == 1 local x = 0
    if Line[`i'] != Line[`i'-1] local ++x
    replace x = `x' in `i'
  }
  order Path, last
  collapse (firstnm) Line Depth Data Err_1 Seed Err_2 Sort Err_3 Path , by(x)
    bys Line: gen Loop = _n

  replace Data = Err_1 + Data
  replace Seed = Err_2 + Seed
  replace Sort = Err_3 + Sort
  gen Subfile = "Yes" if Path != ""
}

  li Line Depth Loop Data Seed Sort Subfile `pathopt' ///                       TODO: Re-write display?
    if !(Data == "" & Seed == "" & Sort == "" & Subfile == "") ///
, noobs divider

/*****************************************************************************
Output flags and errors to External file
*****************************************************************************/

  if (`"`output'"' != `""') & (`"`recurring'"' == "") {
    file open report using `output' , w t replace
    file write report ///
      `"| \`iedorep\` Reproducibility Report         |      |"' _n ///
      `"|--------------|-----------|"' _n ///
      `"| Last Checked by      | User "`c(username)'"  at `c(current_date)' (`c(current_time)') |"' _n ///
      `"| Operating System   | `c(machine_type)' `c(os)' `c(osdtl)' |"' _n ///
      `"| Stata `c(edition_real)'  | Version `c(stata_version)' running as Version `c(version)' |"' _n _n
    file close report
  }

  if `"`output'"' != `""' {
    file open report using `output' , w t append
    egen output = concat(Line Depth Loop Data Seed Sort Subfile Path) , p(" | ")
      qui replace output = "| " + output + " |"

      local file = subinstr(`anything',`"""',"",.)

    file write report ///
      `"Report for: `file'"' _n _n ///
      `"| Line | Depth | Loop | Data | Seed | Sort | Subfile | Path |"' _n ///
      `"|------|-------|------|------|------|------|---------|------|"' _n

    forv i = 1/`c(N)' {
      local o = output[`i']
      if !(Data[`i'] == "" & Seed[`i'] == "" & Sort[`i'] == "" & Subfile[`i'] == "") ///
        file write report `"`o'"' _n
    }

    file write report _n
    file close report
  }

/*****************************************************************************
Pseudo-recursion
*****************************************************************************/

  if "`recursive'" != "" {
    qui keep if !(Err_1 == "" & Err_2 == "" & Err_3 == "") & (Path != "")
    if `c(N)' == 0 {
      di as err " "
      di as err "No errors detected in sub do-files; recursion completed."
      di as err " "
    }
    else {
      di as err " "
      di as err "Errors detected in the following sub do-files; starting recursion."
      li Line Path , noobs divider
      qui duplicates drop Path, force
      sort Line
      forvalues i = 1/`c(N)' {
        if `"`output'"' != "" local outputopt output(`output')
        local file = Path[`i']
        local line = Line[`i']
        iedorep `file' ///
          , recurring(`recurring' `anything') recurringlines(`recurringlines' `line')  ///
            `debug' `qui' `recursive' `outputopt' ///
            `verbose' `alldata' `allsort' `allseed' `allpath'
        if `r(errors)' ==  0 {
          di as err "!!------ WARNING ------!!"
          di as err "An error was expected in this sub do-file but none was found."
          di as err "  This can occur when sub do-files are not independent."
          di as err "  Check that this sub do-file does not depend on the calling file."
          di as err "  This includes both the data state and global macros;"
          di as err "    the data is reset on each run, but macros are not."
          di as err " "
          error 459
        }
      }
    }
  }

/*****************************************************************************
Return
*****************************************************************************/

  qui count if !(Err_1 == "" & Err_2 == "" & Err_3 == "")
  return scalar errors = `r(N)'

/*****************************************************************************
END
*****************************************************************************/

end

//
