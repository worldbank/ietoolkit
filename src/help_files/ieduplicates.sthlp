{smcl}
{* 14 Nov 2017}{...}
{hline}
help for {hi:ieduplicates}
{hline}

{title:Title}

{phang2}{cmdab:ieduplicates} {hline 2} Identify duplicates in ID variable and export them in 
an Excel file that also can be used to correct the duplicates

{title:Syntax}

{phang2}
{cmdab:ieduplicates}
{it:ID_varname}
, {cmdab:fol:der(}{it:string}{cmd:)} {cmdab:unique:vars(}{it:varlist}{cmd:)} 
[{cmdab:keep:vars(}{it:varlist}{cmd:)} {cmdab:tostringok} {cmdab:droprest}  
{cmdab:nodaily} {cmdab:suf:fix(}{it:string}{cmd:)} {cmdab:min:precision(}{it:numlist}{cmd:)]}

{phang2}where {it:ID_varname} is the variable that will be controlled for duplicates

{marker opts}{...}
{synoptset 28}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:fol:der(}{it:string}{cmd:)}}folder in which the duplicate report will be saved{p_end}
{synopt :{cmdab:unique:vars(}{it:varlist}{cmd:)}}variables used as unique ID within groups of duplicates in {it:ID_varname}{p_end}
{synopt :{cmdab:keep:vars(}{it:varlist}{cmd:)}}variables used to be included in the Excel report in addition to {it:ID_varname} and {cmdab:unique:vars()} {p_end}
{synopt :{cmdab:tostringok}}allows {it:ID_varname} to be recasted to string if required{p_end}
{synopt :{cmdab:droprest}}disables the requirement that duplicates must be explicitly deleted{p_end}
{synopt :{cmdab:suf:fix(}{it:string}{cmd:)}}allows the user to add a suffix to the filename of the Excel report{p_end}
{synopt :{cmdab:nodaily}}disables daily back-up copies of the Excel report{p_end}
{synopt :{cmdab:min:precision(}{it:numlist}{cmd:)}}({it:rarely used}) manually set the precision when exporting and importing time variables to and from the Excel file{p_end}
{synoptline}

{title:Description}

{dlgtab:In brief:}
{pstd}{cmd:ieduplicates} outputs a report with any duplicates in {it:ID_varname} to an Excel file 
and return the data set without those duplicates. Each time {cmd:ieduplicates} executes, it first 
looks for an already created version of the Excel report, and applies any corrections already listed in it
before generating a new report. Note that there is no need import the corrections manually. This command 
reads the corrections directly from the Excel file as long as the is saved at the same folder location 
with the same file name.

{dlgtab:In more detail:}
{pstd}{cmd:ieduplicates} takes duplicates observations in {it:ID_varname} and export 
them to an Excel report in directory {cmdab:fol:der(}{it:string}{cmd:)}. {it:ID_varname} 
is per definition not unique in this Excel Report and {cmdab:unique:vars(}{it:varlist}{cmd:)} 
needs to be specified in order to have a unique reference for each row in the Excel report. The
{it:varlist} in {cmdab:unique:vars(}{it:varlist}{cmd:)} must uniquely and fully identify all 
observations in the Excel report, either on its own or together with {it:ID_varname}. {cmd:ieduplicates}
then returns the data set without these duplicates.

{pstd}The Excel report includes three columns called {it:correct}, {it:drop} and {it:newID}. 
Each of them represents one way to correct the duplicates. If {it:correct} is indicated with 
a "Yes" then that observation is kept unchanged, if {it:drop} is indicated with a "yes" then 
that observation is deleted and if {it:newID} is indicated then that observation is assigned 
a new ID using the value in column {it:newID}. After corrections are entered, the report should 
be saved in the same location {cmdab:fol:der(}{it:string}{cmd:)} without any changes to its name.

{pstd}Before outputting a new report {cmd:ieduplicates} always checks if there already are an 
Excel report with corrections and applies those corrections before generating a new report. It is 
at this stage that {cmdab:unique:vars(}{it:varlist}{cmd:)} is required as it otherwise is impossible 
to know which duplicate within a group of duplicates that should be corrected in which way.

{pstd}{cmd:ieduplicates} keeps only one observation if a group of duplicates are duplicates in 
all variables across the data set without any action is needed in the Excel report. These cases 
are not even exported to the Excel report.

{pstd}{cmdab:keep:vars(}{it:varlist}{cmd:)} allows the user to include more variables in the Excel report 
that can help identifying each duplicate is supposed to be corrected. The report also includes two 
columns {it:initials} and {it:notes}. Using these columns is not required but it is recommended to use {it:initials} 
to keep track of who decided how to correct that duplicate and to use {it:notes} to document why 
the correction was chosen. If {it:initials} and {it:notes} are used, then the Excel report also functions
as an excellent documentation of the correction made. 

{space 4}{hline}

{title:Options}

{phang}{cmdab:fol:der(}{it:string}{cmd:)} specifies the folder where previous Excel 
files will be looked for, and where the updated Excel Report will be exported. Note that 
this folder needs to have a subfolder called {it:Daily} where the duplicate report 
file is backed up daily.

{phang}{cmdab:unique:vars(}{it:varlist}{cmd:)} list variables that by themselves or together 
with {it:ID_varname} uniquely identifies all observations. This varlist is required when the corrections are 
imported back into Stata and merged with the original data set. Time variables 
should always be avoided if possible in {cmdab:uniquevars()}. See option {cmdab:min:precision()} for
an explanation of why time variables should be avoided. Data that has been downloaded from 
a server usually has a variable called "KEY" or similar. Such a variable would be optimal 
for {cmdab:unique:vars(}{it:varlist}{cmd:)}. 

{phang}{cmdab:keep:vars(}{it:varlist}{cmd:)} list variables to be included in the exported 
Excel report. These variables can help team members identifying which observation to keep, 
drop and assign a new ID to. For data integrity reasons, be careful not to export and share 
Excel files including both identifying variables and names together with {it:ID_varname}.

{phang}{cmdab:tostringok} allows {it:ID_varname} to be turned into a string variable in case 
{it:ID_varname} is numeric but a value listed in {it:newID} is non-numeric. Otherwise an error is generated.

{phang}{cmdab:droprest} disables the requirement that duplicates must be explicitly deleted.
The default is that if one of the duplicates in a group of duplicates has a 
correction, then that correction is only valid if all other duplicates in that 
group have a correction as well. For example, if there are four observation with
the same value for {it:ID_varname} and one is correct, one needs a new ID and 
two are incorrect and should be deleted. Then the first one is indicated to be 
kept in the {it:correct} column, the second one is given a new ID in {it:newID} 
and the other two observations must be indicated for deletion in {it:drop} 
unless {cmdab:droprest}. The first two corrections are not considered valid and 
will cause an error in case if {cmdab:droprest} is not specified and the other 
two observations are not explicitly indicated to be dropped. It is recommended 
to not use {cmdab:droprest} and to manually indicate all deletions to avoid 
mistakes, but this option exist for cases when that might be very inconvenient.

{phang}{cmdab:suf:fix(}{it:string}{cmd:)} allows the user to set a unique file name suffix to 
the Excel report. This is meant to be used when a project has multiple data sets that are 
checked for duplicates seperately. The command will not work as intended (most liekly even 
crash) if the duplicate report for one data set is used when checking for duplicates in 
another data set. To prevent this, the Excel report must either be exported to seperate folders or 
be assigned different file names using this option. If the string in suffix() is, for example, "AAA", 
then the report exported will be "iedupreport_AAA.xlsx". Any characters allowed in file names in 
Excel and in Stata are allowed in suffix(). Note, that if suffix() is added after the first report is outputted, 
then the name of the outputted report must be updated manually. The command will otherwise not 
apply any changes already entered in the original report.  

{phang}{cmdab:nodaily} disables the generation of daily back-up copies of the 
Excel report. The default is that the command saves dated copies of the Excel 
report in a sub-folder called Daily in the folder specified in {cmdab:folder()}. If 
the folder Daily does not exist, then it is creaetd unless the 
option {cmdab:nodaily} is used.

{phang}{cmdab:min:precision(}{it:numlist}{cmd:)} is rarely used but can be used 
to manually set the precision (in minutes) when exporting and importing a time 
variable to and from the Excel report. Time variables should always be avoided 
if possible in {cmdab:uniquevars()}, but sometimes they are the only option. While
Stata and Excel both keep a very high precision in time variables, they do so 
slightly differently, and this can generate a difference of a few seconds after 
a time variable was exported to Excel and then imported back to Stata. If the 
time variable is used in {cmdab:uniquevars()}, then the time variable may no 
longer be identical to its original value after it is imported back to Stata, and it 
may therefore no longer be possible to use it to merge the Excel data to the correct Stata 
observation. If this happens, then {cmdab:min:precision()} can be used to set the
precision manually. This should only be considered a solution of last resort, 
as lowering the precision increases the risk the time variable no longer uniquely
identifies each observation. The typical user will never use this option.


{title:The Excel Report}

{pstd}A report of duplicates will be created in {cmdab:fol:der(}{it:string}{cmd:)} 
if any duplicates in {it:ID_varname} were found. The folder listed in 
{cmdab:fol:der(}{it:string}{cmd:)} must have a subfolder called {it:Daily} 
where daily back-ups of the report are saved. If a report is back-uped already 
that day, then that report will be overwritten. 

{pstd}All duplicates in a group of duplicates must have a correction indicated. If 
one or more duplicates are indicated as correct in {it:correct} or assigned a new 
ID in {it:newID}, then all other duplicates with the same value in {it:ID_varname} must
be explicitly indicated for deletion. This requirement may (but probably 
shouldn't) be disabled by option {cmdab:droprest}.

{dlgtab:Columns in Excel Report filled in automatically:}

{phang}{it:dupListID} stores an auto incremented duplicate list ID that is used 
to maintain the sort order in the Excel Report regardless of how the data in memory
is sorted at the time {cmd:ieduplicates} is executed.

{phang}{it:dateListed} stores the date the duplicate was first identified.

{phang}{it:dateFixed} stores the date a valid correction was imported the first 
time for that duplicate.

{dlgtab:Columns in Excel Report to be filled in manually by a user:}

{phang}{it:correct} is used to indicate that the duplicate should be kept. Valid values are 
restricted to "yes" and "y" to reduce the risk of unintended entries. The values 
are not sensitive to case. All valid values are changed to "yes" lower case when 
imported. If {it:correct} is indicated then both {it:drop} and {it:newID} must be
left empty.

{phang}{it:drop} is used to indicate that the duplicate should be deleted. Valid values are 
restricted to "yes" and "y" to reduce the risk of unintended entries. The values 
are not sensitive to case. All valid values are changed to "yes" lower case when 
imported. If {it:drop} is indicated then both {it:correct} and {it:newID} must be
left empty.

{phang}{it:newID} is used to assign a new ID values to a duplicate. If {it:ID_varname} 
is a string then all values are valid for {it:newID}. If {it:ID_varname} is numeric then
only digits are valid, unless the option {cmdab:tostringok} is specified. 
If {cmdab:tostringok} is specified and {it:newID} is non-numeric, then {it:ID_varname} 
is recasted to a string variable. If {it:newID} is indicated then both {it:correct} and {it:drop} must be
left empty.

{phang}{it:initials} allows the team working with this data to keep track on who 
decided on corrections.

{phang}{it:notes} allows the team working with this data to document the reason 
for the duplicates and the why one type of correction was chosen over the others.

{dlgtab:Columns in Excel Report with data from the data set:}

{pstd}The columns above are followed by the values in {cmdab:unique:vars(}{it:varlist}{cmd:)} 
and in {cmdab:keep:vars(}{it:varlist}{cmd:)}. These column keeps the name the 
variables have in the data set. These variables can help the team to identify 
which correction should be applied to which duplicate.

{space 4}{hline}

{marker results}{...}
{title:Stored results}

{pstd}
{cmdab:ieduplicates} stores the following results in {hi:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(numDup)}}number of unresolved duplicates{p_end}
{p2colreset}{...}

{pstd}
{cmd:r(numDup)} is intended to allow for the option to pause Stata in case unresolved duplicates 
are found. See example 4 below for a code example on how to use {cmd:r(numDup)}. See {help pause} for instructions 
on how to resume the execution of the code if Stata is paused.


{title:Examples}

{pstd}
{hi:Example 1.}

{phang2}{inp:ieduplicates HHID, folder(C:\myImpactEvaluation\baseline\data) uniquevars(KEY)}{p_end}

{pmore}Specified like this {cmdab:ieduplicates} start by looking for any corrections in any 
duplicates report in the folder C:\myImpactEvaluation\baseline\data. If there is a report 
with corrections those corrections are applied to the data set. Then the command looks for 
unresolved duplicates in HHID and exports a new report if any duplicates were found. The data 
set is returned without any of the unresolved duplicates. The variable KEY is used to separate
observations that are duplication in the ID var.

{phang}
{hi:Example 2.}

{phang2}{inp:ieduplicates HHID, folder(C:\myImpactEvaluation\baseline\data) keepvars(enumerator) uniquevars(KEY)}{p_end}

{pmore}Similar to the example above, but it also includes the variable enumerator in the Excel 
report which is most likely helpful if the data set is collected through a household survey.

{phang}
{hi:Example 3.} Using {cmd:r(numDup)} to pause the execution of the code if 
unresolved duplicates were found

{phang2}{inp:ieduplicates HHID, folder(C:\myImpactEvaluation\baseline\data) uniquevars(KEY)}{p_end}
{phang2}{inp:if (r(numDup) != 0) {c -(}}{p_end}
{phang3}{inp:pause}{p_end}
{phang2}{inp:{c )-}}{p_end}

{phang}
{hi:Example 4.} Using the Excel file. The table below could be the report generated in Example 2 above. Make the viewer window wider and reload the page if the table below does not display properly!

{col 3}{c TLC}{hline 116}{c TRC}
{col 3}{c |}{col 4}HHID{col 10}dupListID{col 21}dateListed{col 33}dateFixed{col 44}correct{col 53}drop{col 59}newID{col 65}initials{col 75}note{col 94}KEY{col 107}enumerator{col 120}{c |}
{col 3}{c LT}{hline 116}{c RT}
{col 3}{c |}{col 4}4321{col 10}1{col 21}27Dec2015{col 33}02Jan2016{col 44}yes{col 53}   {col 59}    {col 65}KB{col 75}double submission{col 94}{it:uniquevalue}{col 107}{it:keepvarvalue}{col 120}{c |}
{col 3}{c |}{col 4}4321{col 10}2{col 21}27Dec2015{col 33}02Jan2016{col 44}   {col 53}yes{col 59}    {col 65}KB{col 75}double submission{col 94}{it:uniquevalue}{col 107}{it:keepvarvalue}{col 120}{c |}
{col 3}{c |}{col 4}7365{col 10}3{col 21}03Jan2016{col 33}         {col 44}   {col 53}   {col 59}    {col 65}  {col 75}                 {col 94}{it:uniquevalue}{col 107}{it:keepvarvalue}{col 120}{c |}
{col 3}{c |}{col 4}7365{col 10}4{col 21}03Jan2016{col 33}         {col 44}   {col 53}   {col 59}    {col 65}  {col 75}                 {col 94}{it:uniquevalue}{col 107}{it:keepvarvalue}{col 120}{c |}
{col 3}{c |}{col 4}1145{col 10}5{col 21}03Jan2016{col 33}11Jan2016{col 44}   {col 53}   {col 59}1245{col 65}IB{col 75}incorrect id     {col 94}{it:uniquevalue}{col 107}{it:keepvarvalue}{col 120}{c |}
{col 3}{c |}{col 4}1145{col 10}6{col 21}03Jan2016{col 33}11Jan2016{col 44}yes{col 53}   {col 59}    {col 65}IB{col 75}correct id       {col 94}{it:uniquevalue}{col 107}{it:keepvarvalue}{col 120}{c |}
{col 3}{c |}{col 4}9834{col 10}7{col 21}11Jan2016{col 33}         {col 44}   {col 53}   {col 59}    {col 65}  {col 75}                 {col 94}{it:uniquevalue}{col 107}{it:keepvarvalue}{col 120}{c |}
{col 3}{c |}{col 4}9834{col 10}8{col 21}11Jan2016{col 33}         {col 44}   {col 53}   {col 59}    {col 65}  {col 75}                 {col 94}{it:uniquevalue}{col 107}{it:keepvarvalue}{col 120}{c |}
{col 3}{c BLC}{hline 116}{c BRC}

{pmore}The table above shows an example of an Excel report with 4 duplicates groups with 
two duplicates in each groups. The duplicates in 4321 and in 1145 have both been corrected 
but 7365 and 9834 are still unresolved. Before any observation was corrected, all observations had 
{it:dateFixed}, {it:correct}, {it:drop}, {it:newID}, {it:initials} and {it:note} empty just like the observations for ID 7365 and 9834. {it:dateFixed} 
is not updated by the user, the command adds this date the first time the correction is made.

{pmore}Observation with dupListID == 5 was found to have been 
assigned the incorrect ID while the data was collected. This observation is assigned the correct ID in {it:newID}
and observation dupListID == 6 is indicated to be correct. Someone with initials IB made this 
correction and made a note. This note can and should be more descriptive but is kept short in this example.

{pmore}Observations with dupListID == 1 and dupListID == 2 were identified as a duplicate submissions of the same 
observation. One is kept and one is dropped, usually it does not matter which you keep and which you drop, but that should be confirmed.

{pmore}Both corrections described in the example would have been easily identified using this command's sister command {help iecompdup}.

{title:Acknowledgements}

{phang}I would like to acknowledge the help in testing and proofreading I received in relation to this command and help file from (in alphabetic order):{p_end}
{pmore}Mehrab Ali{break}Michell Dong{break}Paula Gonzales{break}Seungmin Lee

{title:Author}

{phang}Kristoffer Bjärkefur, The World Bank, DECIE

{phang}Please send bug-reports, suggestions and requests for clarifications 
		 writing "ietools ieduplicates" in the subject line to:{break}
		 kbjarkefur@worldbank.org
		 
{phang}You can also see the code, make comments to the code, see the version 
		 history of the code, and submit additions or edits to the code through
		 the github repository of ietoolkit:{break}
		 {browse "https://github.com/worldbank/ietoolkit"}


