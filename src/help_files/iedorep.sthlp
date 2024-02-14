{smcl}
{* 01 Feb 2024}{...}

{hline}
help for {hi:iedorep}
{hline}

{title:Title}

{phang}{cmdab:iedorep} {hline 2} detects reproducibility errors in do-files automatically by running them multiple times and comparing the Stata state on a line-by-line basis between executions. 

{title:Syntax}

{phang2} {cmdab:iedorep} "{it:/path/do/do-file.do}" , [ {cmdab:alldata allseed allsort} ]

{marker desc}
{title:Description}

{phang}{cmdab:iedorep} provides a reproduciblity assessment of a do-file or project.
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

{phang}{cmdab:iedorep} will first report a warning if the delimiter is changed in the do-file.
  It is not designed to work with delimiters other than Stata's default (a newline).
  It will also report a warning if you use {cmdab:clear all} or {cmdab:ieboilstart};
  specifically, it will re-write these commands to avoid calling {cmdab:discard},
  as this command makes it impossible for {cmdab:iedorep} to store the necessary data for its diagnostics.
  If you experience unusual issues with {cmdab:iedorep}, they are often memory issues;
  in particular, the error "post posty not found" often indicates a memory management conflict.
  Contact the maintainer to resolve these types of issues,
  as they are typically hard-to-find bugs in memory management commands that are not often used.
  {break}

{phang} {cmdab:iedorep} is designed to be used targeting a master do-file (it will work on any file).
  Its verbosity options allow the user to see all changes to data, RNG state,
  and sort seed state, regardless of whether they are flagged as errors.

{marker optslong}
{title:Options}

{phang}The {cmdab:alldata}, {cmdab:allseed} , and {cmdab:allsort} options will
  report any time the data is changed, the RNG state changes, or the sort order of the data changed,
  even if the result is consistent between the two do-file runs.
  This is only recommended for advanced diagnostics;
  for example, if reproducibility problems persist despite no errors appearing.
  There are known cases where inconsistencies occur with very low
  frequency and might not be detected in every given pair of runs.

{marker example}
{title:Example verbose output}

  iedorep "${ietoolkit}/run/iedorep/iedorep-target-1.do" ///
    , alldata allsort allseed

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


{title:Notes}

  {phang}In the example above, the rows without "ERROR!" flags would not appear
  if the verbosity options were not specified.

  {phang}We recommend resolving issues from the top down, since later issues
  may be resolved by fixing earlier ones.
  This is because many reproducibility issues will "cascade":
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
