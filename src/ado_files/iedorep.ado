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
  local comment = 0
  local loop = 0
  local linenum = 1
  
// Open the file to be checked
  file open original using `"`anything'"' , read
  file read original line // Need initial read
  
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
      
      file write edited `"global allRNGS = "\${allRNGS} \`c(rngstate)'" "' _n
      file write edited `"if ("\`c(rngstate)'" != "\`: word `=max(1,`=`checknum'-1')' of \${allRNGS}'") di as err "RNG Changed: `linenum_real'"  "' _n
    
      file write edited "datasignature" _n
      file write edited `"global allDATA = "\${allDATA} \`r(datasignature)'" "' _n
      file write checkr "datasignature" _n
      file write checkr `"if ("\`r(datasignature)'" != "\`: word `checknum' of \${allDATA}'") di as err "Data Changed: `linenum_real'"  "' _n

      local linenum_real = `linenum'
    }
    
    // Error if delimiter
    if strpos(`"`macval(line)'"',"#delimit") {
      di as err "Delimiter changed!"
    }
    
  } // Comments
  
  // Advance through file
  file read original line

}

  file close _all
  
  clear
  qui do `newfile1'
  clear
  qui do `newfile2'
  
end
