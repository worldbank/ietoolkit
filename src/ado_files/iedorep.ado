*! version 0.2 14DEC2021 DIME Analytics dimeanalytics@worldbank.org

cap  program drop  iedorep
  program define   iedorep, rclass
  
  syntax anything , ///
  [alldata] ///
  [debug(string asis)] [qui] // Programming option to view exact temp do-file
  
/*****************************************************************************
Options
*****************************************************************************/

  // Optionally request all data changes to be flagged
  if "`alldata'" != "" {
    local alldata1 = `" ("Changed") ("") ("") ("") ("") ("") "'
    local alldata2 = `" ("") ("ERROR! ") ("") ("") ("") ("") "'
  }
  else {
    local alldata1 = `" ("") ("") ("") ("") ("") ("") "'
    local alldata2 = `" ("Changed") ("ERROR! ") ("") ("") ("") ("") "'
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
  
// Open the file to be checked
  file open original using `anything' , read
  file read original line // Need initial read
    local linenum_real = 1
  
// Open the files to be written
  qui file open edited using `newfile1' , write replace 
  qui file open checkr using `newfile2' , write replace 
  
// Initialize locals in new file
  file write edited "local theLOCALS posty theSORT theRNG allRNGS whichRNG allDATA theDATA theLOCALS" _n
  file write edited "tempname theSORT theRNG allRNGS whichRNG allDATA theDATA" _n
  file write edited "tempfile posty" _n "postfile posty Line " ///
    "str15(Data Err_1 Seed Err_2 Sort Err_3) using \`posty' , replace" _n
    
  file write edited `"local \`theRNG' = "\`c(rngstate)'" "' _n
  file write checkr `"local \`theRNG' = "\`c(rngstate)'" "' _n
  
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
  
  // Reproduce file contents
  file write edited `"`macval(line)'"' _n
  file write checkr `"`macval(line)'"' _n  
  
  // Catch comments
  if strpos(`"`macval(line)'"',"/*") local comment = 1
  if strpos(`"`macval(line)'"',"*/") local comment = 0
  
  // Monitor loop state and do not evaluate within loops
  
    // Set flag whenever looping word or logic word
    if strpos(`"`macval(line)'"',"if ")     local logic = 1
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
      local loopstate = substr("`loopstate'",5,.)
      
  /*****************************************************************************
  Implement logic checks in file copy
  *****************************************************************************/  
  if (`comment' == 0) & !strpos("`loopstate'","loop") {
    // Add checkers if line end
    if !strpos(`"`macval(line)'"',"///") {
      local logic = 0 // If we are here with logic flagged, it was a subset
      
      // Flag changes to RNG state
      file write edited ///
      `"if ("\`c(rngstate)'" != "\`\`theRNG''") {"' _n ///
        `"post posty (`linenum_real') ("") ("") ("Used") ("") ("") ("")   "' _n ///
        `"local \`theRNG' = "\`c(rngstate)'" "' _n ///
        `"local \`allRNGS' = "\`\`allRNGS'' \`c(rngstate)'" "' _n ///
      `"}"'_n
      
      // Error changes to RNG state
      file write checkr ///
      `"if ("\`c(rngstate)'" != "\`\`theRNG''") {"' _n ///
        `"local \`whichRNG' = \`\`whichRNG'' + 1"' _n ///
        `"local \`theRNG' = "\`c(rngstate)'" "' _n ///
        `"if ("\`c(rngstate)'" != "\`: word \`\`whichRNG'' of \`\`allRNGS'''") {"' _n ///
          `"post posty (`linenum_real') ("") ("") ("") ("ERROR! ") ("") ("")  "' _n ///
        `"}"'_n ///
      `"}"'_n
      
      // Flag changes to Sort RNG state
      file write edited ///
      `"if ("\`c(sortrngstate)'" != "\`\`theSORT''") {"' _n ///
        `"post posty (`linenum_real') ("") ("") ("") ("") ("Sorted") ("") "' _n ///
        `"local \`theSORT' = "\`c(sortrngstate)'" "' _n ///
        `"preserve"' _n ///
        `"xpose, clear"' _n ///
        `"tempfile `linenum_real'_x"' _n ///
        `"save \``linenum_real'_x' , emptyok"' _n ///
        `"local theLOCALS "\`theLOCALS' `linenum_real'_x" "' _n ///
        `"restore"' _n ///
      `"}"'_n      
      
      // Flag Errors to Sort RNG state
      file write checkr ///
      `"if ("\`c(sortrngstate)'" != "\`\`theSORT''") {"' _n ///
        `"local \`theSORT' = "\`c(sortrngstate)'" "' _n ///
        `"preserve"' _n ///
        `"xpose, clear"' _n ///
        `"cap cf _all using \``linenum_real'_x'"' _n ///
        `"if _rc != 0 {"'_n ///
            `"post posty (`linenum_real') ("") ("") ("") ("") ("") ("ERROR! ") "' _n ///
        `"}"'_n ///
        `"restore"' _n ///
      `"}"'_n  
      
      // Flag changes to DATA state
      file write edited ///
      "datasignature" _n ///
      `"if ("\`r(datasignature)'" != "\`\`theDATA''") {"' _n ///
        `"post posty (`linenum_real') `alldata1' "' _n ///
        `"local \`theDATA' = "\`r(datasignature)'" "' _n ///
        `"tempfile `linenum_real'"' _n ///
        `"local theLOCALS "\`theLOCALS' `linenum_real'" "' _n ///
        `"save \``linenum_real'' , emptyok"' _n ///
      `"}"'_n
      
      // Error changes to DATA state
      file write checkr ///
      "datasignature" _n ///
      `"if ("\`r(datasignature)'" != "\`\`theDATA''") {"' _n ///
        `"local \`theDATA' = "\`r(datasignature)'" "' _n ///
        `"cap cf _all using \``linenum_real''"' _n ///
        `"if _rc != 0 {"'_n ///
            `"post posty (`linenum_real') `alldata2' "' _n ///
        `"}"'_n ///
      `"}"'_n

      // Advance line number
      local linenum_real = `linenum'
    }
    
    // Error if delimiter
    if strpos(`"`macval(line)'"',"#d") {
      di as err "Note: The delimiter may have been changed in this file (#d)."
      di as err " "
    }
    
  } // Comments and loops logic
  
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
    `"mata : st_local("all_locals", invtokens(st_dir("local", "macro", "*")'))"' _n ///
    "local toDROP : list all_locals - theLOCALS" _n ///
    "macro drop \`toDROP' " _n  ///
    "foreach macro in \`toDROP' {" _n ///
    `"  mata : st_local("\`macro'","") "' _n ///
     "}" _n ///
  "// ADVANCE RNG AND CLEAR DATA -------------------------------------------" _n ///
    "qui di \`=rnormal()'" _n ///
    "clear" _n /// 
  "// SECOND RUN STARTS HERE ------------------------------------------------" _n _n
    
  while r(eof)==0 {
    file write edited `"`macval(line)'"' _n
    file read checkr line
  }
  file write edited `"postclose posty"' _n
  file write edited `"use \`posty' , clear"' _n
  file write edited `"collapse (firstnm) Data Err_1 Seed Err_2 Sort Err_3 , by(Line)"' _n
  file write edited `"compress"' _n

/*****************************************************************************
Cleanup and then run the combined temp dofile
*****************************************************************************/  

  file close _all
  
  clear
  if `"`debug'"' != "" {
    copy `newfile1' `debug' , replace 
    `qui' do `newfile1'
  }
  else qui do `newfile1'
  
/*****************************************************************************
Output flags and errors
*****************************************************************************/

  qui replace Data = Err_1 + Data 
  qui replace Seed = Err_2 + Seed 
  qui replace Sort = Err_3 + Sort 
  drop if Data == "" & Seed == "" & Sort == ""
  li Line Data Seed Sort , noobs divider 
  
/*****************************************************************************
Pseudo-recursion
*****************************************************************************/

  
/*****************************************************************************
END
*****************************************************************************/
  
end

//
