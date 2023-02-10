*! version 1.1 XXXX DIME Analytics dimeanalytics@worldbank.org

cap  program drop  iedorep
  program define   iedorep, rclass

  syntax anything , ///
  [Recursive] [recurring] ///
  [Output(string asis)] ///
  [Verbose] [alldata] [allsort] [allseed] [allpath] /// Verbose reporting of non-errors
  [debug] [qui] // Programming options to view exact temp do-file

/*****************************************************************************
Options
*****************************************************************************/

  // Optionally enable all verbosity options
  if "`verbose'" != "" {
    local alldata "alldata"
    local allsort "allsort"
    local allseed "allseed"
    local pathopt "Path"
  }

  // Optionally request all data changes to be flagged
  if "`alldata'" != "" {
    local alldata1 = `" ("Changed") ("") ("") ("") ("") ("") ("") (.) "'
    local alldata2 = `" ("") ("ERROR! ") ("") ("") ("") ("") ("") (.) "'
  }
  else {
    local alldata1 = `" ("") ("") ("") ("") ("") ("") ("") (.) "'
    local alldata2 = `" ("Changed") ("ERROR! ") ("") ("") ("") ("") ("") (.) "'
  }

  // Optionally request all sorts to be flagged
  if "`allsort'" != "" {
    local allsort1 = `" ("") ("") ("") ("") ("Sorted") ("") ("") (.) "'
    local allsort2 = `" ("") ("") ("") ("") ("") ("ERROR! ") ("") (.) "'
  }
  else {
    local allsort1 = `" ("") ("") ("") ("") ("") ("") ("") (.) "'
    local allsort2 = `" ("") ("") ("") ("") ("Sorted") ("ERROR! ") ("") (.) "'
  }

  // Optionally request all seeds to be flagged
  if "`allseed'" != "" {
    local allseed1 = `" ("") ("") ("Used") ("") ("") ("") ("") (.) "'
    local allseed2 = `" ("") ("") ("") ("ERROR! ") ("") ("") ("") (.) "'
  }
  else {
    local allseed1 = `" ("") ("") ("") ("") ("") ("") ("") (.) "'
    local allseed2 = `" ("") ("") ("Used") ("ERROR! ") ("") ("") ("") (.) "'
  }

/*****************************************************************************
One-time prep
*****************************************************************************/
preserve
  file close _all
  postutil clear
  tempfile newfile1
  tempfile newfile2
  local comment = 0
  local loopstate = ""
  local loop = 0
  local logic = 0
  local linenum = 1
  local clear

// Open the file to be checked
  di as err " "
  di as err `"Processing: `anything'"'
  file open original using `anything' , read
  file read original line // Need initial read
    local linenum_real = 1

// Open the files to be written
  qui file open edited using `newfile1' , write replace
  qui file open checkr using `newfile2' , write replace

// Initialize locals in new file
  file write edited ///
    "  cap drop _all            " _n  /// (see [D] drop)
    "  cap frames reset         " _n  /// (see [D] frames reset)
    "  cap collect clear        " _n  /// (see [TABLES] collect clear)
    "  cap label drop _all      " _n  /// (see [D] label)
    "  cap matrix drop _all     " _n  /// (see [P] matrix utility)
    "  cap scalar drop _all     " _n  /// (see [P] scalar)
    "  cap constraint drop _all " _n  /// (see [R] constraint)
    "  cap cluster drop _all    " _n  /// (see [MV] cluster utility)
    "  cap file close _all      " _n  /// (see [P] file)
    "  cap postutil clear       " _n  /// (see [P] postfile)
    "  cap _return drop _all    " _n  /// (see [P] _return)
    "  cap discard              " _n  /// (see [P] discard)
    "  cap timer clear          " _n  /// (see [P] timer)
    "  cap putdocx clear        " _n  /// (see [RPT] putdocx begin)
    "  cap putpdf clear         " _n  /// (see [RPT] putpdf begin)
    "  cap mata: mata clear     " _n  /// (see [M-3] mata clear)
    "  cap python clear         " _n  /// (see [P] PyStata integration)
    "  cap java clear  " _n
  file write edited "tempname theSORT whichSORT theRNG allRNGS whichRNG theDATA whichDATA allDATA" _n
  file write edited "tempfile posty" _n "postfile posty Line " ///
    "str15(Data Err_1 Seed Err_2 Sort Err_3) str2000(Path) int(Depth) using \`posty' , replace" _n

  file write edited `"local \`theRNG' = "\`c(rngstate)'" "' _n
  file write checkr `"local \`theRNG' = "\`c(rngstate)'" "' _n
  file write edited  "local \`whichSORT' = 0  " _n
  file write edited  "local \`whichDATA' = 0  " _n

  file write edited `"local \`theSORT' = "\`c(sortrngstate)'" "' _n
  file write checkr `"local \`theSORT' = "\`c(sortrngstate)'" "' _n

  file write edited "datasignature" _n `"local \`theDATA' = "\`r(datasignature)'" "' _n
  file write checkr "datasignature" _n `"local \`theDATA' = "\`r(datasignature)'" "' _n

/*****************************************************************************
Big loop through target do-file contents
*****************************************************************************/
while r(eof)==0 {

  /*****************************************************************************
  Setup and state checks
  *****************************************************************************/

  // Increment line
  local linenum = `linenum' + 1
  file write edited `"// Line `linenum_real' ---------------------------- // "' _n
  file write checkr `"// Line `linenum_real' ---------------------------- // "' _n


  // Reproduce file contents
    // Catch any [clear all] or [ieboilstart] commands
    if strpos(`"`macval(line)'"',"clear ") ///
     & (   strpos(`"`macval(line)'"',"all") ///
         | strpos(`"`macval(line)'"',"*") ) {
      di as err "This file contained [clear all] or [clear *]. That has been replaced. Check functionality."
      file write edited ///
        "  cap drop _all            " _n  /// (see [D] drop)
        "  cap frames reset         " _n  /// (see [D] frames reset)
        "  cap collect clear        " _n  /// (see [TABLES] collect clear)
        "  cap label drop _all      " _n  /// (see [D] label)
        "  cap matrix drop _all     " _n  /// (see [P] matrix utility)
        "  cap scalar drop _all     " _n  /// (see [P] scalar)
        "  cap constraint drop _all " _n  /// (see [R] constraint)
        "  cap cluster drop _all    " _n  /// (see [MV] cluster utility)
        "  cap file close _all      " _n  /// (see [P] file)
        "  cap _return drop _all    " _n  /// (see [P] _return)
        "  cap mata: mata clear     " _n  /// (see [M-3] mata clear)
        "  cap timer clear          " _n  /// (see [P] timer)
        "  cap putdocx clear        " _n  /// (see [RPT] putdocx begin)
        "  cap putpdf clear         " _n  /// (see [RPT] putpdf begin)
        "  cap python clear         " _n  /// (see [P] PyStata integration)
        "  cap java clear           " _n  ///
        "  cap estimates clear  " _n
      file write checkr ///
        "  cap drop _all            " _n  /// (see [D] drop)
        "  cap frames reset         " _n  /// (see [D] frames reset)
        "  cap collect clear        " _n  /// (see [TABLES] collect clear)
        "  cap label drop _all      " _n  /// (see [D] label)
        "  cap matrix drop _all     " _n  /// (see [P] matrix utility)
        "  cap scalar drop _all     " _n  /// (see [P] scalar)
        "  cap constraint drop _all " _n  /// (see [R] constraint)
        "  cap cluster drop _all    " _n  /// (see [MV] cluster utility)
        "  cap file close _all      " _n  /// (see [P] file)
        "  cap _return drop _all    " _n  /// (see [P] _return)
        "  cap mata: mata clear     " _n  /// (see [M-3] mata clear)
        "  cap timer clear          " _n  /// (see [P] timer)
        "  cap putdocx clear        " _n  /// (see [RPT] putdocx begin)
        "  cap putpdf clear         " _n  /// (see [RPT] putpdf begin)
        "  cap python clear         " _n  /// (see [P] PyStata integration)
        "  cap java clear           " _n  ///
        "  cap estimates clear  " _n
    }
    else if strpos(`"`macval(line)'"',"ieboilstart")  {
      di as err "This file contained [ieboilstart]. That has been modified. Check functionality."
      file write edited ///
        "  cap drop _all            " _n  /// (see [D] drop)
        "  cap frames reset         " _n  /// (see [D] frames reset)
        "  cap collect clear        " _n  /// (see [TABLES] collect clear)
        "  cap label drop _all      " _n  /// (see [D] label)
        "  cap matrix drop _all     " _n  /// (see [P] matrix utility)
        "  cap scalar drop _all     " _n  /// (see [P] scalar)
        "  cap constraint drop _all " _n  /// (see [R] constraint)
        "  cap cluster drop _all    " _n  /// (see [MV] cluster utility)
        "  cap file close _all      " _n  /// (see [P] file)
        "  cap _return drop _all    " _n  /// (see [P] _return)
        "  cap mata: mata clear     " _n  /// (see [M-3] mata clear)
        "  cap timer clear          " _n  /// (see [P] timer)
        "  cap putdocx clear        " _n  /// (see [RPT] putdocx begin)
        "  cap putpdf clear         " _n  /// (see [RPT] putpdf begin)
        "  cap python clear         " _n  /// (see [P] PyStata integration)
        "  cap java clear           " _n  ///
        "  cap estimates clear  " _n
      file write checkr ///
        "  cap drop _all            " _n  /// (see [D] drop)
        "  cap frames reset         " _n  /// (see [D] frames reset)
        "  cap collect clear        " _n  /// (see [TABLES] collect clear)
        "  cap label drop _all      " _n  /// (see [D] label)
        "  cap matrix drop _all     " _n  /// (see [P] matrix utility)
        "  cap scalar drop _all     " _n  /// (see [P] scalar)
        "  cap constraint drop _all " _n  /// (see [R] constraint)
        "  cap cluster drop _all    " _n  /// (see [MV] cluster utility)
        "  cap file close _all      " _n  /// (see [P] file)
        "  cap _return drop _all    " _n  /// (see [P] _return)
        "  cap mata: mata clear     " _n  /// (see [M-3] mata clear)
        "  cap timer clear          " _n  /// (see [P] timer)
        "  cap putdocx clear        " _n  /// (see [RPT] putdocx begin)
        "  cap putpdf clear         " _n  /// (see [RPT] putpdf begin)
        "  cap python clear         " _n  /// (see [P] PyStata integration)
        "  cap java clear           " _n  ///
        "  cap estimates clear  " _n
      file write edited `"`macval(line)' noclear "' _n
      file write checkr `"`macval(line)' noclear "' _n
    }
    else {
      file write edited `"`macval(line)'"' _n
      file write checkr `"`macval(line)'"' _n
    }

    // Catch comments
    if strpos(`"`macval(line)'"',"/*") local comment = 1
    if strpos(`"`macval(line)'"',"*/") local comment = 0

    // Monitor loop state and do not evaluate within loops

      // Set flag whenever looping word or logic word
      if strpos(`"`macval(line)'"',"if ")     local logic = 1
      if strpos(`"`macval(line)'"',"else ")   local logic = 1
      if strpos(`"`macval(line)'"',"forv")    local  loop = 1
      if strpos(`"`macval(line)'"',"foreach") local  loop = 1
      if strpos(`"`macval(line)'"',"while")   local  loop = 1

      // Track state when logic entered (unless ALSO loop)
      if `logic' == 1 & `loop' == 0 & strpos(`"`macval(line)'"',"{") ///
        local loopstate "logi `loopstate'"
      if `logic' == 1 & strpos(`"`macval(line)'"',"{") ///
        local logic = 0

      // Track state when loop entered
      if `loop' == 1 & strpos(`"`macval(line)'"',"{") {
        local loopstate "loop `loopstate'"
        local loop = 0
      }

      // Track state whenever logic or loop exited
      if strpos(`"`macval(line)'"',"}") ///
        local loopstate = substr("`loopstate'",6,.)

  /*****************************************************************************
  Implement logic checks in file copy
  *****************************************************************************/
  local depth : word count `loopstate'
  file write edited `" "' _n
  file write edited `"// Line `linenum_real' Checks ------------------------ // "' _n
  file write edited `"post posty (`linenum_real')  ("") ("") ("") ("") ("") ("") ("") (`depth') "' _n
  file write checkr `"post posty (`linenum_real')  ("") ("") ("") ("") ("") ("") ("") (.z) "' _n
  // Add checkers if line end
  if !strpos(`"`macval(line)'"',"///") {
    local logic = 0 // If we are here with logic flagged, it was a subset

    // Catch any [do] or [run] commands
    if  strpos(`"`macval(line)'"',"do ") {
      local theRECURSION = substr(`"`macval(line)'"',strpos(`"`macval(line)'"',"do ")+3,.)
      file write edited `" post posty (`linenum_real')  ("") ("") ("") ("") ("") ("") (`"`theRECURSION'"') (.) "' _n
    }
    else if  strpos(`"`macval(line)'"',"ru ") {
      local theRECURSION = substr(`"`macval(line)'"',strpos(`"`macval(line)'"',"ru ")+3,.)
      file write edited `" post posty (`linenum_real')  ("") ("") ("") ("") ("") ("") (`"`theRECURSION'"') (.) "' _n
    }
    if  strpos(`"`macval(line)'"',"run ") {
      local theRECURSION = substr(`"`macval(line)'"',strpos(`"`macval(line)'"',"run ")+4,.)
      file write edited `" post posty (`linenum_real')  ("") ("") ("") ("") ("") ("") (`"`theRECURSION'"') (.) "' _n
    }

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

  // Error if delimiter
  if strpos(`"`macval(line)'"',"#d") {
    di as err "      Note: The delimiter may have been changed in this file (#d)."
    di as err " "
  }


// Advance through file
file read original line

}

/*****************************************************************************
Append the checking dofile to the edited dofile
Betwen dofiles, use [di] to advance seed and use [clear] for data
Then remove all macros other than the ones we are using
*****************************************************************************/
file close checkr
file open checkr using `"`newfile2'"' , read
  file read checkr line // Need initial read
  file write edited _n ///
  "// CLEANUP LOCALS BETWEEN FILES -------------------------------------------" _n ///
    "local theLOCALS posty theSORT whichSORT theRNG allRNGS whichRNG allDATA whichDATA theDATA theLOCALS " ///
      "\`posty' \`theSORT' \`whichSORT' \`theRNG' \`allRNGS' \`whichRNG' \`allDATA' \`whichDATA' \`theDATA' \`theLOCALS'" _n ///
    `"mata : st_local("all_locals", invtokens(st_dir("local", "macro", "*")'))"' _n ///
    "local toDROP : list all_locals - theLOCALS" _n ///
    "cap macro drop \`toDROP' " _n  ///
    "foreach macro in \`toDROP' {" _n ///
    `"  mata : st_local("\`macro'","") "' _n ///
     "}" _n ///
  "// ADVANCE RNG AND CLEAR DATA -------------------------------------------" _n ///
    "qui di \`=rnormal()'" _n ///
    "  cap drop _all            " _n  /// (see [D] drop)
    "  cap frames reset         " _n  /// (see [D] frames reset)
    "  cap collect clear        " _n  /// (see [TABLES] collect clear)
    "  cap label drop _all      " _n  /// (see [D] label)
    "  cap matrix drop _all     " _n  /// (see [P] matrix utility)
    "  cap scalar drop _all     " _n  /// (see [P] scalar)
    "  cap constraint drop _all " _n  /// (see [R] constraint)
    "  cap cluster drop _all    " _n  /// (see [MV] cluster utility)
    "  cap file close _all      " _n  /// (see [P] file)
    "  cap _return drop _all    " _n  /// (see [P] _return)
    "  cap mata: mata clear     " _n  /// (see [M-3] mata clear)
/// "  cap discard              " _n  /// (see [P] discard)                     TODO: Figure out why [discard] kills postfile
    "  cap timer clear          " _n  /// (see [P] timer)
    "  cap putdocx clear        " _n  /// (see [RPT] putdocx begin)
    "  cap putpdf clear         " _n  /// (see [RPT] putpdf begin)
    "  cap python clear         " _n  /// (see [P] PyStata integration)
    "  cap java clear  " _n ///
    "local \`whichSORT' = 0  " _n ///
    "local \`whichDATA' = 0  " _n ///
  "// SECOND RUN STARTS HERE ------------------------------------------------" _n _n

  while r(eof)==0 {
    file write edited `"`macval(line)'"' _n
    file read checkr line
  }
  file write edited `"postclose posty"' _n
  file write edited `"use \`posty' , clear"' _n
  file write edited `"compress"' _n
  file write edited `"order Path, last"' _n

/*****************************************************************************
Cleanup and then run the combined temp dofile
*****************************************************************************/

  file close _all
  di as err `"Entering `anything' run...."'
  clear
  if `"`debug'"' != "" {
    local debugpath = subinstr(`"`anything'"',".do","_temp.do",.)
    copy `newfile1' `debugpath' , replace
    `qui' do `newfile1'
  }
  else qui do `newfile1'
  di as err `"Done with `anything'!"'

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

  li Line Depth Loop Data Seed Sort Subfile `pathopt' ///
    if !(Data == "" & Seed == "" & Sort == "" & Subfile == "") ///
, noobs divider

/*****************************************************************************
Output flags and errors to External file
*****************************************************************************/

  if (`"`output'"' != `""') & ("`recurring'" == "") {
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
        iedorep `file' ///
          , recurring  `debug' `qui' `recursive' `outputopt' ///
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
