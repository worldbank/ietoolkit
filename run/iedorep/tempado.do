
  // Flag when entering loop
  local thisisloop = 0
  if strpos(`"`macval(line)'"',"{") ///
     & (  strpos(`"`macval(line)'"',"foreach") ///
        | strpos(`"`macval(line)'"',"forv")    ///
        | strpos(`"`macval(line)'"',"while"))  ///
  {        
    local loop = "loop `loop'"
    local thisisloop = 1
  }
  // Flag when entering logic
  if strpos(`"`macval(line)'"',"{") ///
     & strpos(`"`macval(line)'"',"if ") ///
     local loop == "logi `loop'"
     
     
  if strpos(`"`macval(line)'"',"}") ///
     & !strpos(`"`macval(line)'"',"{") ///
     & `logic' == 1 ///
     local logic == 0
  // Increment down when brace closed
  if   strpos(`"`macval(line)'"',"}") ///
    & !strpos(`"`macval(line)'"',"{") ///
    & `logic' == 0 ///
    local loop = `loop' - 1
