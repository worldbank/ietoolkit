*! version 0.1 9NOV2021 DIME Analytics dimeanalytics@worldbank.org

cap  program drop  iedorep
  program define   iedorep, rclass
  
  syntax anything , [debug]
  
// Prep
  file close _all
  tempfile newfile1
  tempfile newfile2
  local comment = 0
  local loop = 0
  local linenum = 1
  
// Open the file to be checked
  file open original using `"`anything'"' , read
  file read original line // Need initial read
    local linenum_real = 1
  
// Open the files to be written
  qui file open edited using `newfile1' , write replace 
  qui file open checkr using `newfile2' , write replace 
  
// Initialize locals in new file
  file write edited "tempname theSORT theRNG allRNGS whichRNG allDATA theDATA" _n
  file write edited `"local \`theRNG' = "\`c(rngstate)'" "' _n
  file write edited `"local \`theSORT' = "\`c(sortrngstate)'" "' _n
  file write checkr `"local \`theRNG' = "\`c(rngstate)'" "' _n
  file write edited "datasignature" _n `"local \`theDATA' = "\`r(datasignature)'" "' _n
  file write checkr "datasignature" _n `"local \`theDATA' = "\`r(datasignature)'" "' _n
  
// Big loop through file
while r(eof)==0 {
  
  // Increment line
  local linenum = `linenum' + 1
  
  // Reproduce file contents
  file write edited `"`macval(line)'"' _n
  file write checkr `"`macval(line)'"' _n  
  
  // Catch comments
  if strpos(`"`macval(line)'"',"/*") local comment = 1
  if strpos(`"`macval(line)'"',"*/") local comment = 0
  
  // Catch loops (but not globals)
    if    strpos(`"`macval(line)'"',"{") ///
       & !strpos(`"`macval(line)'"',"}") ///
          local loop = `loop' + 1
  
    if    strpos(`"`macval(line)'"',"}") ///
       & !strpos(`"`macval(line)'"',"{") ///
          local loop = `loop' - 1

  if (`comment' == 0) & (`loop' == 0) {
    // Add checkers if line end
    if !strpos(`"`macval(line)'"',"///") {
      local checknum = `checknum' + 1
      
      // Flag changes to RNG state
      file write edited ///
      `"if ("\`c(rngstate)'" != "\`\`theRNG''") {"' _n ///
        `"di as err "RNG Used: `linenum_real'"  "' _n ///
        `"local \`theRNG' = "\`c(rngstate)'" "' _n ///
        `"local \`allRNGS' = "\`\`allRNGS'' \`c(rngstate)'" "' _n ///
      `"}"'_n
      
      // Error changes to RNG state
      file write checkr ///
      `"if ("\`c(rngstate)'" != "\`\`theRNG''") {"' _n ///
        `"local \`whichRNG' = \`\`whichRNG'' + 1"' _n ///
        `"local \`theRNG' = "\`c(rngstate)'" "' _n ///
        `"if ("\`c(rngstate)'" != "\`: word \`\`whichRNG'' of \`\`allRNGS'''") {"' _n ///
          `"di as err "RNG ERROR: `linenum_real'"  "' _n ///
        `"}"'_n ///
      `"}"'_n
      
      // Flag changes to Sort RNG state
      file write edited ///
      `"if ("\`c(sortrngstate)'" != "\`\`theSORT''") {"' _n ///
        `"di as err "Sort RNG Used: `linenum_real'"  "' _n ///
        `"local \`theSORT' = "\`c(sortrngstate)'" "' _n ///
      `"}"'_n      
    
      
      // Flag changes to DATA state
      file write edited ///
      "datasignature" _n ///
      `"if ("\`r(datasignature)'" != "\`\`theDATA''") {"' _n ///
        `"di as err "Data Changed: `linenum_real'"  "' _n ///
        `"local \`theDATA' = "\`r(datasignature)'" "' _n ///
        `"tempfile `linenum_real'"' _n ///
        `"save \``linenum_real''"' _n ///
      `"}"'_n
      
      // Error changes to DATA state
      file write checkr ///
      "datasignature" _n ///
      `"if ("\`r(datasignature)'" != "\`\`theDATA''") {"' _n ///
        `"local \`theDATA' = "\`r(datasignature)'" "' _n ///
        `"cap cf _all using \``linenum_real''"' _n ///
        `"if _rc != 0 {"'_n ///
            `"di as err "Data ERROR: `linenum_real'"  "' _n ///
        `"}"'_n ///
      `"}"'_n

      // Advance line number
      local linenum_real = `linenum'
    }
    
    // Error if delimiter
    if strpos(`"`macval(line)'"',"#d") {
      di as err "Delimiter changed!"
    }
    
  } // Comments and loops logic
  
  // Advance through file
  file read original line

}

// Append the checking dofile to the edited dofile

file close checkr
file open checkr using `"`newfile2'"' , read
  file read checkr line // Need initial read
  file write edited _n _n `"clear // SECOND RUN STARTS HERE "' ///
    "------------------------------------------------" _n _n
  while r(eof)==0 {
    file write edited `"`macval(line)'"' _n
    file read checkr line
  }
  
// Clean up and run

  file close _all
  
  clear
  qui do `newfile1'
  
  if "`debug'" != "" /// COPY FILE FOR DEBUGGING
    copy `newfile1' "${ietoolkit}/run/iedorep/TEMP.do" , replace 
  
end
