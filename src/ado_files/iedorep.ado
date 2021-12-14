*! version 0.1 9NOV2021 DIME Analytics dimeanalytics@worldbank.org

cap  program drop  iedorep
  program define   iedorep, rclass
  
  syntax anything
  
// Prep
  file close _all
  tempfile newfile1
  tempfile newfile2
  global allRNGS = ""
  global allDATA = ""
  global allSORT = ""
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
  
  // Catch loops
  if strpos(`"`macval(line)'"',"{") local loop = `loop' + 1
  if strpos(`"`macval(line)'"',"}") local loop = `loop' - 1

  if (`comment' == 0) & (`loop' == 0) {
    // Add checkers if line end
    if !strpos(`"`macval(line)'"',"///") {
      local checknum = `checknum' + 1
      
      // Flag changes to RNG state
      file write edited `"global allRNGS = "\${allRNGS} \`c(rngstate)'" "' _n
      file write edited ///
        `"if ("\`c(rngstate)'" != "\`: word `=max(1,`=`checknum'-1')' of \${allRNGS}'")"' 
        file write edited `" di as err "RNG Changed: `linenum_real'"  "' _n
      
      // Flag changes to Sort RNG state
      file write edited `"global allSORT = "\${allSORT} \`c(sortrngstate)'" "' _n
      file write edited ///
        `"if ("\`c(sortrngstate)'" != "\`: word `=max(1,`=`checknum'-1')' of \${allSORT}'")"'
        file write edited `" di as err "Data Sorted: `linenum_real'"  "' _n
    
      // Flag changes to data
      file write edited "datasignature" _n
      file write edited `"global allDATA = "\${allDATA} \`r(datasignature)'" "' _n
      file write checkr "datasignature" _n
      file write checkr `"if ("\`r(datasignature)'" != "\`: word `checknum' of \${allDATA}'")"'
        file write checkr `" di as err "Data Changed: `linenum_real'"  "' _n

      // Advance line number
      local linenum_real = `linenum'
    }
    
    // Error if delimiter
    if strpos(`"`macval(line)'"',"#delimit") {
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
  copy `newfile1' "${ietoolkit}/run/iedorep/TEMP.do" , replace // FOR DEBUGGING
  
end
