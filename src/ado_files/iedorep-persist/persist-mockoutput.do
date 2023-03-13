
write_or_check_line, lnum(1) tmpname("${tempname}") check("${check}")
sysuse auto.dta, clear

write_or_check_line, lnum(2) tmpname("${tempname}") check("${check}")
global do "nothing"

write_or_check_line, lnum(3) tmpname("${tempname}") check("${check}")
expand 2 , gen(check)

write_or_check_line, lnum(4) tmpname("${tempname}") check("${check}")
sort foreign

write_or_check_line, lnum(5) tmpname("${tempname}") check("${check}")
gen y = rnormal()

write_or_check_line, lnum(6) tmpname("${tempname}") check("${check}")


