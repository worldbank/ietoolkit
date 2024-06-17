# Title

__iefolder__ - sets up project folders and master do-files according to World Bank DIME's standards.

# Syntax

For a more descriptive discussion on the intended usage and work flow of this command please see the [DIME Wiki](https://dimewiki.worldbank.org/Iefolder)

_When initially setting up the `DataWork` folder in a new project_:

__iefolder__ new _project_name_ , __**proj**ectfolder__(_directory_)

_When adding folders to and already existing `DataWork` folder_:

__iefolder__ new _item_type_ _item_name_ , __**proj**ectfolder__(_directory_) [__abbreviation__(_string_) __subfolder__(_folder_)]

where _item_type_ is either _round_, _unitofobs_ or _subfolder_. See details on _item_type_ and _item_name_ below.

| _options_ | Description |
|-----------|-------------|
| __**proj**ectfolder__(_directory_) | The location of the project folder where the _DataWork_ folder should be created (new projects), or where it is located (new rounds, unitofobs and subfolders). |
| __abbreviation__(_string_) | Optional abbreviation of round name to be used to make globals shorter. Can only be used with `iefolder new round`. |
| __subfolder__(_folder_) | Creates the round folders inside a subfolder to _DataWork_. Only works with new rounds and only after the subfolder has been created with `iefolder new subfolder`. |

# Description

`iefolder` automates the process of setting up the folders and
master do-files where all the data work will take place in a project folder.
The folder structure set up by `iefolder` follows DIME's best practices.

In addition to setting up the _DataWork_ folder and its folder structure,
the command creates master do-files linking to
all main folders in the folder structure.
These master do-files are updated whenever more rounds,
units of observations, and subfolders are added to
the project folder using this command.

## Item types

This command can create either a new _DataWork_ folder or add folders
to an existing _DataWork_ folder.
The existing _DataWork_ folder must have been created with
`iefolder` for the additions to work.
A new _DataWork_ folder is created using specifying project.
There are three types of folders that can be added to an existing folder
by specifying _round_, _unitofobs_ or _subfolder_.
See the next paragraphs for descriptions.

__project__ sets up a new _DataWork_ folder and its initial folder structure.
You must always do this before you can do anything else.
It also sets up the main master do-file for this _DataWork_ folder.
`iefolder` is implemented so that you can keep working for years
with your project in between adding folders.
The command reads and preserves changes made manually to the _DataWork_ folder
and master do-file before adding more folders using `iefolder`.

__round__ folders are folders specific to a data collection round,
for example, Baseline, Endline, Follow Up etc.
(See subfolder below if your project is more complex than that.)
When adding a new round, a round folder is added to the _DataWork_ folder,
and inside it the round folder structure described
[here](https://dimewik/wiki/DataWork_Survey_Round) is created.
`iefolder` also creates a master do-file specific for this round with
globals referencing the main folders in the folder structure
specific to this round.
Folders are created in two places, both in the _DataWork_ folder,
and in the Encrypted folder.

__unitofobs__ folders are folders specific to a unit of observation,
for example the master data set folder.
Read more about master data sets and the folder structure
this commands sets up for you at here.
A master data folder for each new unit of observation is created in two places.
Both in the MasterData folder in the _DataWork_ folder,
and in the Encrypted folder.

__subfolder__ can be used to organize project folders with
a lot of data collections.
For examples, instead of having only one baseline data collection,
a project might have a student, a teacher,
and a school data collections during baseline.
You can then first create a baseline folder in the project folder using
_subfolder_ and then creating round-folders for student, teacher, school, etc.,
inside the sub-folder suing _round_ with the option __subfolder__(_baseeline_).
When creating a subfolder,
only a single folder is created in the _DataWork_ folder which is empty.
The main master do-file is however updated with a global to this folder.

# Options

__**proj**ectfolder__(_directory_) should point to the same folder
regardless of which _item_type_ is created.
If new project is specified,
the file path should point to where _DataWork_ should be created,
and if new round or new project is specified,
it should point to where _DataWork_ was already created.
See how the file path is the same both time when `iefolder`
is called twice in Example 1 below.

__abbreviation__(_string_) can be used to shorten the globals created
in the master do-files that point to the sub-folders to round folders.
For example, if you create a new round called Baseline,
as in Example 1, then a global to the _DataSet_ folder called Baseline_dt
will be created in the master do-file.
If the abbreviation option would have been used,
like in Example 2, then the global would have been called BL_dt.

__subfolder__(_folder_) creates a round folder inside
the folder specified in this option.
This option can only be used when creating a new round.
The folder specified must have been created using `iefolder`. See example 3.

# Examples

## Example 1

```
global projectFolder "C:/Users/Documents/DropBox/ProjectABC"

iefolder new project , projectfolder("$projectFolder")
iefolder new round baseline , projectfolder("$projectFolder")
```

In the example above, in the line the first time `iefolder` is used,
a folder called _DataWork_ is created at the location of
`C:/Users/Documents/DropBox/ProjectABC`.
In the line where `iefolder` used a second time,
a folder for the baseline round is created inside the _DataWork_ folder.
Note that the folder provided in `projectfolder()` is the same both times.

Both the _DataWork_ folder and the baseline folder created have
sub-folders and master do-files creating globals pointing to these.

## Example 2

```
global projectFolder "C:/Users/Documents/DropBox/ProjectABC"

iefolder new project , projectfolder("$projectFolder")
iefolder new round baseline , projectfolder("$projectFolder") abbreviation("BL")
```

The example above creates the same folder structure as in Example 1,
but in the globals in the master do-files the abbreviation BL
is used instead of baseline.
But the folders created on disk will still be called baseline.

## Example 3

This example shows how to use subfolders.

```
global projectFolder "C:/Users/Documents/DropBox/ProjectABC"

iefolder new project , projectfolder("$projectFolder")

iefolder new subfolder baseline , projectfolder("$projectFolder")
iefolder new round studentBL , projectfolder("$projectFolder") subfolder("baseline")
iefolder new round teacherBL , projectfolder("$projectFolder") subfolder("baseline")
```

The code above creates a new _DataWork_ folder inside the folder ProjectABC.
Then subfolder is used to create a folder called baseline.
Then the two baseline rounds, student and teacher,
are created inside the folder baseline.

The code below shows how the endline folder can be created in the same folder.
Note that the rounds need to have unique names even across subfolders,
and that is why the student and teacher round have the suffix EL.

```
global projectFolder "C:/Users/Documents/DropBox/ProjectABC"

iefolder new subfolder endline , projectfolder("$projectFolder")
iefolder new round studentEL , projectfolder("$projectFolder") subfolder("endline")
iefolder new round teacherEL , projectfolder("$projectFolder") subfolder("endline")
```

## Example 4

The example below is meant to describe an intended workflow
for a full life cycle of an impact evaluation.
First we need to set up the _DataWork_ folder.
We do that using `iefolder new project`. Like this:

```
iefolder new project , projectfolder("C:/DropBox/ProjectABC")
```

Our first data collection will be a baseline
where the unit of observation is households.
We therefore need to set up folders for the unit of observation "households".
In the encrypted master folder for "households"
you can create your list over households and you have a subfolder called Sampling
where you can keep do files and data with identifying information.
We create all of that by using `iefolder new unitofobs household`. Like this:

```
iefolder new unitofobs household , projectfolder("C:/DropBox/ProjectABC") abbreviation("BL")
```

When we are ready to start preparing for the baseline
we want to create the baseline folder.
We do that using `iefolder new round baseline`. Like this:

```
iefolder new round baseline , projectfolder("C:/DropBox/ProjectABC") abbreviation("BL")
```

At this point we can collect the baseline data,
save the data in the folders we created and write the report.
Then long stretches of time might pass before we need to use the command.

Let's say that when we plan for midline
we also want to collect data about the villages
that the households we interview in baseline live in.
Then we need to create a new master folder for the unit of observation villages.
We do that using `iefolder new unitofobs village`. Like this:

```
iefolder new unitofobs village , projectfolder("C:/DropBox/ProjectABC")
```

Then we need to create the rounds used for the midline round
for both households and for villages.
Since this is separate data collection
(although they might happen at the same time).
We create those folders like this:

```
iefolder new round midline       , projectfolder("C:/DropBox/ProjectABC") abbreviation("ML")
iefolder new round midlineVillage, projectfolder("C:/DropBox/ProjectABC") abbreviation("MLvill")
```

Finally, in the last round of data collection,
we are only collecting data on households again.
Since we are not collecting data on any new unit of observation,
we do not need to create any new master folder.

```
iefolder new round endline , projectfolder("C:/DropBox/ProjectABC") abbreviation("EL")
```

# Acknowledgements

This command was initially suggested by Esteban J. Quinones, University of Wisconsin-Madison.

We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetical order):

Guadalupe Bedoya

Laura Costica

Mrijan Rimal

Sakina Shibuya

Seungmin Lee


# Feedback, bug reports and contributions

Please send bug-reports, suggestions and requests for clarifications
writing "ietoolkit iefolder" in the subject line to: dimeanalytics@worldbank.org

You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through [GitHub repository](https://github.com/worldbank/ietoolkit) for `ietoolkit`.

# Author

All commands in `ietoolkit` are developed by DIME Analytics at DIME, The World Bank's department for Development Impact Evaluations.

Main authors: Kristoffer Bjarkefur, Luiza Cardoso De Andrade, DIME Analytics, The World Bank Group
