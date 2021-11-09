*! version 0.1 9NOV2021 DIME Analytics dimeanalytics@worldbank.org

cap  program drop  iedorep
  program define   iedorep, rclass
  
  syntax anything
  
// Prep
  file close _all
  tempname newfile
  global allRNGS = ""
  
// Open the file to be checked
  file open original using `"`anything'"' , read
  file read original line
  
// Open the files to be written
  file open edited using "/users/bbdaniels/desktop/newfile.do" , write replace // replace when done
  file open checkr using "/users/bbdaniels/desktop/checker.do" , write replace // replace when done

// Big loop
while r(eof)==0 {
  
  
  file write edited `"`macval(line)'"' _n
  file write checkr `"`macval(line)'"' _n
  
    // Add checkers if line end
    if !strpos(`"`macval(line)'"',"///") {
      local linenum = `linenum' + 1
      
      file write edited `"global allRNGS = "\${allRNGS} \`c(rngstate)'" // `linenum'"' _n
      
      file write checkr `"if "\`c(rngstate)'" == "\`: word `linenum' of \${allRNGS}'" di as err "OK"  "' _n
    }
    
    // Error if delimiter
    if strpos(`"`macval(line)'"',"#delimit") {
      di as err "Delimiter changed!"
    }
  
  file read original line

}

  file close _all

  do "/users/bbdaniels/desktop/newfile.do"
  qui do "/users/bbdaniels/desktop/checker.do"
  
  
end

// DEMO
iedorep /Users/bbdaniels/Downloads/TanzaniaIE_Reproducibility/Code/Revenue.do
