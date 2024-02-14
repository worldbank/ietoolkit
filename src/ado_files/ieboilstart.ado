*! version 7.3 01FEB2024 DIME Analytics dimeanalytics@worldbank.org

  capture program drop ieboilstart
  program ieboilstart , rclass

  qui {

    syntax ,                      ///
      /* Required options */      ///
      Versionnumber(string)       ///
      [                           ///
      /* ADO path options */      ///
      ADOpath(string)             ///
      /* Workflow options */      ///
      noclear Quietly veryquietly ///
      /* Settings options */      ///
      maxvar(numlist)             ///
      matsize(numlist)            ///
      nopermanently               ///
      /* Deprecated options */    ///
      setmem(string)              ///
      Custom(string)              ///
      ]

    version 12

    /***************************************************************************
      Handle deprecated options
    ***************************************************************************/

    if !missing("`setmem'") {
      noi di as error "Option {opt setmem(string)} is deprecated as this command no longer supports Stata version 11. This option therefore no longer allowed."
      error 198
    }
    if !missing("`custom'") {
      noi di as error "Option {opt custom(string)} is deprecated. This option therefore no longer allowed.""
      error 198
    }

    /***************************************************************************
    ****************************************************************************

      STATA VERSION SECTION

    ****************************************************************************
    ***************************************************************************/

    * Get target versions from ietoolkit command
    ietoolkit
    local valid_stata_versions "`r(stata_target_versions)'"

    * Test that the version passed in the options versionnumber() is valid
    if `:list versionnumber in valid_stata_versions' == 0 {
      di as error "{phang}The Stata version number provided in {opt versionumber(`versionnumber')} is not valid or not allowed. The Stata versions currently allowed in this command are:{break}`valid_stata_versions'{p_end}"
      di ""
      error 198
      exit
    }

    *Return the value
    return local version "version `versionnumber'"

    *Set the version specfied in the command
    version `versionnumber'

    /***************************************************************************
    ****************************************************************************

      ADO PATH SECTION

    ****************************************************************************
    ***************************************************************************/

    if !missing(`"`adopath'"') {

      * split out path and ado sub option
      gettoken apath aoption : adopath , parse(",")
      local apath   = trim("`apath'")
      local aoption = trim(subinstr("`aoption'",",","",1))

      if missing("`aoption'") | !inlist("`aoption'", "strict", "nostrict") {
        if missing("`aoption'") {
          local aopterr `"You did not provide any sub-option."'
        }
        else {
          local aopterr `"You provided the sub-option [`aoption']."'
        }
        noi di as error `"{phang}The option {inp:adopath(}{it:{res:`apath'}}{inp:)} requires one of the sub-options [strict] or [nostrict]. `aopterr' See help file for more details.{p_end}"'
        error 198
      }

      * Test if folder exists
      mata : st_numscalar("r(dirExist)", direxists("`apath'"))
      if (`r(dirExist)' == 0) {
        noi di as error `"{phang}The folder path [`apath'] in option [`adopath'] does not exist.{p_end}"'
        error 198
      }

      local aoutput "{phang}{err:ADOPATH:} "

      * Set adopath depending on if strict was used
      if "`aoption'" == "strict" {
        * If strict is used, the replace plus
        sysdir set  PLUS `"`apath'"'
        adopath ++  PLUS
        adopath ++  BASE

        * Remove all adopaths other than
        local morepaths 1
        while (`morepaths' == 1) {
          capture adopath - 3
          if _rc local morepaths 0
        }

        * Update the paths where mata search for commands to mirror adopath
        mata: mata mlib index

        local aoutput `"`aoutput'PLUS adopath was set to [`apath']. All adopaths other than this and BASE have been removed. Only programs and ado-files in this PLUS folder are accessible to Stata until the end of this session."'
      }
      else {
        * Set PERSONAL path to ado path
        sysdir set  PERSONAL `"`apath'"'
        adopath ++  PERSONAL
        adopath ++  BASE

        local aoutput `"`aoutput'PERSONAL adopath was set to [`apath']. All other prior adopath locations remain available."'
      }

      local aoutput `"`aoutput' Do {stata adopath} to see your current setting. These settings will be restored next time you restart Stata.{p_end}"'
    }

    /***************************************************************************
    ****************************************************************************

      HARMONIZE SETTINGS OPTION

    ****************************************************************************
    ***************************************************************************/

    /*********************************
      Check settings related to older versions and Stata IC
    *********************************/

    *Test that maxvar is not set in combination when using Stata IC
    if   !(c(MP) == 1 | c(SE) == 1) & "`maxvar'" != "" {
      di as error "{phang}In Stata IC the maximum number of variables allowed is fixed at 2,047 and maxvar() is therefore not allowed.{p_end}"
      error 198
    }

    /*********************************
      Check input for maxvar and matsize if specified, otherwise set
      maximum value allowed.
    *********************************/

    *Setting maxvar requires a cleared memory. Therefore
    *maxvar() and noclear cannot be used at the same time.
    if "`maxvar'" != "" & "`clear'" != "" {
      di as error "{phang}It is not possible to set the maximum numbers of variables without clearing the data. Therefore noclear and maxvar() cannot be specified at the same time.{p_end}"
      di ""
      error 198
      exit
    }

    foreach maxlocal in maxvar matsize {
      *Set locals with the max and min values fox maxvar and matsize
      if "`maxlocal'" == "maxvar" {
        *Stata 15 MP has a higher maximum number of maxvar
        if c(stata_version) >= 15 & c(MP) == 1 local max 120000
        *For Stata 15 SE and MP and SE for all lower versions
        else local max 32767
        local min 2048
      }
      if "`maxlocal'" == "matsize" {
        local max 11000
        local min 10
      }

      *Test if user set a value for this value
      if "``maxlocal''" != "" {
        *If user specified a value, test that it is between the min and the max
        if !(``maxlocal'' >= `min' & ``maxlocal'' <= `max') {
          di as error "{phang}`maxlocal' must be between `min' and `max' (inclusive) if you are using Stata SE or Stata MP. You entered ``maxlocal''.{p_end}"
          di ""
          *Throw appropriate error if below or above error
          if ``maxlocal'' < `min' error 910
          if ``maxlocal'' > `max' error 912
          exit
        }
      }

      *User did not specify value, use ieboilstart's defaults:
      else {
        *Set maxvar to max value allowed as this is often an issue when working with large survey data
        if "`maxlocal'" == "maxvar" local `maxlocal' `max'
        *Set to the default as the maximum is rarely requered.
        if "`maxlocal'" == "matsize" local `maxlocal' 400
      }
    }

    /*********************************
      Handle general settings options
    *********************************/

    **Default is that these values are set as default values so that
    * these are the default values each time Stata starts.
    if "`nopermanently'" == "" {
      local permanently     " , permanently"
      local permanently_col   "{col 28}, permanently"
    }
    else {
      local permanently     ""
      local permanently_col ""
    }

    /*********************************
      Harmonize settings
    *********************************/

    local setDispLocal "{col 5}{ul:Settings set by this command:}"

    *Set basic memory limits
    if "`clear'" == "" {
      *Setting
      clear all
      local setDispLocal "`setDispLocal'{break}{col 5}clear all"
      **Setting maxvar not allowed in Stata IC.
      if   (c(MP) == 1 | c(SE) == 1) {
        *Setting
        set maxvar `maxvar' `permanently'
        local setDispLocal "`setDispLocal'{break}{col 5}set maxvar {col 22}`maxvar'`permanently_col'"
      }
    }

    *Setting
    set matsize `matsize' `permanently'
    local setDispLocal "`setDispLocal'{break}{col 5}set matsize {col 22}`matsize'`permanently_col'"

    ****************
    *Memory  settings

    *Setting
    set niceness 5  `permanently'
    local setDispLocal "`setDispLocal'{break}{col 5}set niceness{col 22}5`permanently_col'"

    *These settings cannot be modified with data in memory
    if "`clear'" == "" {

      *Settings
      set min_memory 0  `permanently'
      set max_memory .  `permanently'
      local setDispLocal "`setDispLocal'{break}{col 5}set min_memory {col 22}0`permanently_col'{break}{col 5}set max_memory {col 22}.`permanently_col'"

      *Set segment size to the largest value allowed by the operative system
      if c(bit) == 64 {
        set segmentsize  32m  `permanently'
        local setDispLocal "`setDispLocal'{break}{col 5}set segmentsize  {col 22}32m`permanently_col'"
      }
      else {
        set segmentsize  16m  `permanently'
        local setDispLocal "`setDispLocal'{break}{col 5}set segmentsize  {col 22}16m`permanently_col'"
      }
    }


    *********************
    *Set simple settings

    set more off `permanently'
    local setDispLocal "`setDispLocal'{break}{col 5}set more {col 22}off`permanently_col'"

    pause on
    local setDispLocal "`setDispLocal'{break}{col 5}pause {col 22}on"

    set varabbrev off `permanently'
    local setDispLocal "`setDispLocal'{break}{col 5}set varabbrev {col 22}off`permanently_col'"

    set type float `permanently'
    local setDispLocal "`setDispLocal'{break}{col 5}set type {col 22}float`permanently_col'"

    /***************************************************************************
    ****************************************************************************

      Outputs

    ****************************************************************************
    ***************************************************************************/


    /*********************************

      Create return value and output message

    *********************************/

    * if very quietly is used then supress this info
    if "`veryquietly'" == "" {


      if "`quietly'" == "" {
        noi di ""
        noi di as result "{phang}{err:DISCLAIMER:} Due to how settings work in Stata, this command can only attempt to harmonize settings as much as possible across users, but no guarantee can be given that all commands will always behave identically unless the exact same version and type of Stata is used, with the same releases of user-contributed commands installed.{p_end}"
        noi di ""
        noi di `"`setDispLocal'"'

        * If adopath is used output what was done
        if !missing(`"`adopath'"') {
          noi di ""
          noi di as result "`aoutput'"
        }
      }

      noi di ""
      noi di as result "{phang}{err:IMPORTANT:} One setting of this command requires that \`r(version)' is run on the immediate line after this command. Include the quotes \` and ' in \`r(version)'. This sets the Stata version which cannot be done for this purpose inside the command. This message will show regardless if this is already done. Read more on this requirement in the {help ieboilstart :help file}.{p_end}"

    }
  }
  end
