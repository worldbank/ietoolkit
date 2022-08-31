{smcl}
{* 11 Jan 2022}{...}

{hline}
help for {hi:iedorep}
{hline}

{title:Title}

{phang}{cmdab:iedorep} {hline 2} Returns information on the version of iedorep installed

{phang}For a more descriptive discussion on the intended usage and work flow of this
command please see the {browse "https://dimewiki.worldbank.org/wiki/iedorep":DIME Wiki}.

{title:Syntax}

{phang2} {cmdab:iedorep} "{it:/path/do/do-file.do}" , [ {cmdab:r:ecursive} {cmdab:alldata allseed allsort} ]

{marker desc}
{title:Description}

{phang}{cmdab:iedorep} provides a replicability assessment of a do-file or project.
  It should be used when a do-file or project is complete to detect any
  instabilities or likely sources of replication errors.
  {break}
  
{phang}{cmdab:iedorep} will run the do-file twice and flag three types of possible
  errors between the first and the second run of the do-file.
  (1) Changes to data which leave the data at a different state 
  in the same line of the do-file. (Changes in the datasignature)
  (2) Changes to the random number generator state 
  which result in a different state at the same line in the do-file. (Changes in the RNG state)
  (3) Changes to the sort order of the data which leave the data
  in a different sort order at the same line of the do-file. (Changes in the sortseed)
  {break}
  
{phang} {cmdab:iedorep} is designed to be used targeting a master do-file (it will work on any file).
  When done this way with the {cmdab:recursive} option, it will recursively
  run on do-files that are run by other do-files if errors are detected there.
  Finally, its verbosity options allow the user to see all changes to data, RNG state,
  and sort seed state, regardless of whether they are flagged as errors.

{marker optslong}
{title:Options}

{phang}The {cmdab:recursive} option requests that {cmdab:iedorep} detect when errors
  are flagged following a line that uses {cmdab:do} or {cmdab:run}
  to execute "sub" do-files. If such errors are detected (ie, if the sub-do-file
  leaves the data, RNG state, or sort order different in the second run),
  {cmdab:iedorep} will execute again targeting that filepath.
  
{phang}The {cmdab:alldata}, {cmdab:allseed} , and {cmdab:allsort} options will
  report any time the data is changed, the RNG state changes, or the sort order of the data changed,
  even if the result is consistent between the two do-file runs.
  This is only recommended for advanced diagnostics; 
  for example, if replicability problems persist despite no errors appearing.
  There are known cases where inconsistencies occur with very low
  frequency and might not be detected in every given pair of runs.

{marker example}
{title:Example verbose output}

  iedorep "${ietoolkit}/run/iedorep/iedorep-target-1.do" ///
    , alldata allsort allseed recursive

  +---------------------------------------------------------------+
  | Line |           Data |        Seed |          Sort | Subfile |
  |------+----------------+-------------+---------------+---------|
  |    5 |        Changed |             |               |         |
  |   11 |        Changed |             |               |         |
  |   13 |                |             |        Sorted |         |
  |   15 |                |             | ERROR! Sorted |         |
  |   19 | ERROR! Changed |             |               |         |
  |------+----------------+-------------+---------------+---------|
  |   20 | ERROR! Changed | ERROR! Used |               |         |
  |   22 |                |        Used |               |         |
  |   24 | ERROR! Changed |             | ERROR! Sorted |         |
  |   26 | ERROR! Changed |             | ERROR! Sorted |     Yes |
  +---------------------------------------------------------------+
 
  Errors detected in the following sub do-files; starting recursion.

  +----------------------------------------------------------------------------+
  | Line |                                                                Path |
  |------+---------------------------------------------------------------------|
  |   26 | "/Users/bbdaniels/GitHub/ietoolkit/run/iedorep/iedorep-target-2.do" |
  +----------------------------------------------------------------------------+
  
  ...

{title:Notes}

  {phang}In the example above, the rows without "ERROR!" flags would not appear
  if the verbosity options were not specified. Similarly,
  if the recursion option were not specified, the second message would not appear
  and execution would stop here. Since it was specified,
  a similar report will be created for the next file.
  
  {phang}We recommend resolving issues from the top down, since later issues
  may be resolved by fixing earlier ones.
  This is because many replicability issues will "cascade": 
  An inconsistent RNG state early in the do-file will cause many types of
  later data creation (such as randomization assignment) to fail to reproduce.
  Both issues will be fixed by resolving the first one.
  Similarly, a single data inconsistency will cause every subsequent data check to fail
  until new data is loaded that matches the data state in the first run,
  but there may only be one true issue in the do-file.

{title:Acknowledgements}

...

{title:Author}

{phang}Main author: Benjamin Daniels, DIME Analytics, The World Bank Group

{phang}Please send bug-reports, suggestions and requests for clarifications
     writing "ietoolkit iedorep" in the subject line to:{break}
     dimeanalytics@worldbank.org

{phang}You can also see the code, make comments to the code, see the version
     history of the code, and submit additions or edits to the code through {browse "https://github.com/worldbank/ietoolkit":the GitHub repository of ietoolkit}.{p_end}
