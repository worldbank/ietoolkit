cap program drop iedorep
program define   iedorep, rclass

  syntax , mainfolder(string)

  local tempfilenames "fwrite fcheck fdata"

  tempname forg `tempfilenames'

  preserve

    * tempfiles for this file
    local fwrite "`mainfolder'/orig/temp/ST01.do"
    local fcheck "`mainfolder'/orig/temp/ST02.do"
    local fdata "`mainfolder'/orig/temp/ST03"

    * Create the three files
    foreach filehandle of local tempfilenames  {
        file open `filehandle' using ``filehandle'', write replace
        file write `filehandle' ""
    }

    *Read orginal file and
    *create write file and check file

    local lnum = 1
    local leof = 0

    file open `forg' using "`mainfolder'/orig/main.do", read


    while `leof' == 0 {
        * Read next line

        file read `forg' line
        local leof = `r(eof)'

        file write fwrite `"`line'"' _n
        file write fwrite `"iedorep_line, lnum(`lnum') datatmp("`fdata'") mode(write)"' _n

        file write fcheck `"`line'"' _n
        file write fcheck `"iedorep_line, lnum(`lnum') datatmp("`fdata'") mode(check)"' _n

        local `r(eof)' = 0
        local lnum = `lnum' + 1
    }



    * Close files
    file close `forg'
    foreach filehandle of local tempfilenames  {
        file close `filehandle'
    }

  restore

  do "`fwrite'"

  do "`fcheck'"

end
