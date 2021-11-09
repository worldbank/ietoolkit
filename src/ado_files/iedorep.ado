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
  
// Open the file to be checked
  file open original using `"`anything'"' , read
  file read original line
  
// Open the files to be written
  qui file open edited using `newfile1' , write replace 
  qui file open checkr using `newfile2' , write replace 

// Big loop
while r(eof)==0 {
  
  
  file write edited `"`macval(line)'"' _n
  file write checkr `"`macval(line)'"' _n
  
  local linenum_real = `linenum_real' + 1
  
    // Add checkers if line end
    if !strpos(`"`macval(line)'"',"///") {
      local linenum = `linenum' + 1
      
      file write edited `"global allRNGS = "\${allRNGS} \`c(rngstate)'" // `linenum'"' _n
      file write edited `"if ("\`c(rngstate)'" != "\`: word `=max(1,`=`linenum'-1')' of \${allRNGS}'") di as err "RNG Changed: `linenum_real'"  "' _n
    
      file write edited "datasignature" _n
      file write edited `"global allDATA = "\${allDATA} \`r(datasignature)'" // `linenum'"' _n
      file write checkr "datasignature" _n
      file write checkr `"if ("\`r(datasignature)'" != "\`: word `linenum' of \${allDATA}'") di as err "Data Changed: `linenum_real'"  "' _n

    }
    
    // Error if delimiter
    if strpos(`"`macval(line)'"',"#delimit") {
      di as err "Delimiter changed!"
    }
  
  file read original line

}

  file close _all
  
  clear
  qui do `newfile1'
  clear
  qui do `newfile2'
  
  
end

// DEMO
iedorep /Users/bbdaniels/Downloads/TanzaniaIE_Reproducibility/Code/Revenue.do
