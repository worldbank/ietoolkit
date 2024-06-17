# Title

__iegitaddmd__ - Creates a placeholder file in subfolders of a GitHub repository folder, which allows committing folder structures with empty folders.

# Syntax

For a more descriptive discussion on the intended usage and work flow of this command please see the [DIME Wiki](https://dimewiki.worldbank.org/Iegitaddmd).

__iegitaddmd__ , __folder__(_full_file_path_) [ __comparefolder__(_full_file_path_) __customfile__(_filename_) __all__ __skip__ __replace__ __skipfolders__(_folder_name_) __**auto**matic__ __**dry**run__ ]

| _options_ | Description |
|-----------|-------------|
| __folder__(_full_file_path_) | Specifies the folder path to the project folder clone where placeholder files will be created |
| __comparefolder__(_full_file_path_) | Specifies the top folder of a folder tree to be compared with `folder()` |
| __customfile__(_filename_) | Specifies a file saved on disk that is used instead of the default file as placeholder |
| __all__ | Creates the placeholder file in every subfolder of `folder()`, whether empty or not |
| __skip__ | If option `all` is used and a folder has a file with same name as placeholder file, then nothing is done |
| __replace__ | If option `all` is used and a folder has a file with same name as placeholder file, then the file is overwritten |
| __skipfolders__(_folder_name_) | List of folders to be skipped. The hidden folder _.git_ is always added to this list, even when option `skip` is not used |
| __**auto**matic__ | Makes the command create placeholder files without prompting the user for each file |
| __**dry**run__ |  Makes the command list all the files that would have been created without this option |

# Description

Git/GitHub does not "_sync_" empty folders, or folder that only contain ignored files.
However, it is common in research projects that these types of folders needs to be shared anyways.
`iegitaddmd` provides a solution to this by creating placeholder files in in these folders.
This placeholder file can then be shared to GitHub and that way the folder is also shared.
`iegitaddmd` is developed with two use cases in mind described below.

<!-- Consider moving use cases to vignetter-->
`Use case 1.` It is common in the beginning of a research project that
a standardized folder structure is set up (for example with `iefolder`)
where some folders that are created are not yet needed.
A common example, is output folders.
If these folders are not shared at the time they are created,
different team members will create them ad-hoc when needed.
That typically leads to them being named differently
which is confusing and could in turn lead to errors.
`iegitaddmd` can solve this by scanning a project folder for all sub-folders
that are completely empty, and create a placeholder file in those folder.

The solution to this use case in `iegitaddmd` is a Stata adaptation of Solution B in
[this post](https://bytefreaks.net/gnulinux/bash/how-to-add-automatically-all-empty-folders-in-git-repository).

`Use case 2.` The second use case is when an already ongoing project is transferred to Git/GitHub.
Then, many files and folders are copied from wherever
they were stored before (for example DropBox) to a clone of the repository.
Files not meant to be shared on GitHub can (and should) be ignored using the _.gitignore_ file.
However, this is likely to create empty folders that are not shared on GitHub.
A clone of this repo would then miss those folder but they might be required folders like
 output folder or folders for intermediate data.
`iegitaddmd` can solve this by scanning the project folder in the old location
and for each sub-folder that exist in the old location but not in the clone
create that folder and put a place holder file in it.
In this use case the option `comparefolder()` is used to indicate that
the clone should be compared to another folder.

The default placeholder file used is named `README.md` and its content explains that it is a placeholder file.
That file name is a special name on GitHub,
and whenever one navigate to a folder on GitHub.com with a `README.md` file,
the content of that file is displayed on that web page.
The placeholder file may be removed as soon as files have been added to the folder.
Or perhaps even better is to keep the file, but edit the content of it such that
it documents the content of that folder for all other team members.

# Options

__folder__(_full_file_path_) is the folder path to the project folder clone where the placeholder files will be created.

__comparefolder__(_full_file_path_) is used to compare a file tree in a different location
and create folders with placeholder files in all folders that exist in
`comparefolder()` but not in `folder()`.
If a folder that does no exist in `folder()` has a subfolder,
then both the folder and the subfolder will be created,
 but the placeholder file is only crated in the sub-folder.
 This is sufficient for sharing both the folder and the subfolder in GitHub.
 If the `comparefolder()` and `folder()` ends with folders with different names,
 for example `folder(${project}/datawork/baseline)` and `comparefolder(${project}/datawork)`,
 then the command will throw an error as it is likely that
 the paths do not point to corresponding folders in the two folder trees.

__customfile__(_filename_) allows the user to specify a file saved on the computer
to be used as the placeholder file instead of the default `README.md` file.
This allows anyone to write their own template placeholder files according to their own preferences.
We recommend that a file of type .md (markdown)
and name README.md is used such that the content is displayed when someone navigate to that folder on GitHub.com.
But this is not a technical requirement, any file type and name can be used as placeholder file.

__all__ creates the placeholder file in `folder()` and in every subfolder, regardless if they are empty or not.
This allows the user to create a placeholder file in every folder that can be
edited with documentation and instructions to the purpose and usage of each subfolder.
This option can also be important when _.gitignore_ is used,
as `iegitaddmd` will not create files to subfolders that
only has ignored file -- in which case the folder will not be synced by GitHub.

__skip__ and __replace__ tells `iegitaddmd` what to do if the option `all` is used
and if any of the folders contain a file with the exact same name as the file the command is trying to create.
If a file with the same name as the placeholder file exist and neither of these options are used,
then the command will throw an error.
If `skip` is used, then nothing is done in the folder where the file with the same name exists
and the command proceeds to the next folder.  
If `replace` is used then the file with the same name is overwritten with
the new placeholder file before the command proceeds to the next folder.

__skipfolders__(_folder_names_) is used to list folders in which a placeholder file should never be created.
You should not list the full folder path in this option, just the folder name.
All folders with that name will be skipped regardless of their location in the project folder.
Any sub-folder of these folders will also be skipped.
A folder name may be listed with or without quotation marks as long as there are no spaces in the names.
If any of the folder names has spaces, then quotation marks must be used for all folder names.

__**auto**matic__ can be used to speed up the creation of placeholders by
telling the command to not prompt the users for confirmation for each file before it is created.
The default is that the command is asking the user before creating each place holder file.
This option should only be used when you are confident you have specified the correct folder paths.
We recommend that you use the `dryrun` with this option to make sure that the folder paths are correct.

__**dry**run__ can be used to safely test that the folder paths are
specified correctly before any placeholder files are created.
When this option it used the command simply lists the file
that would have been created if this option were not used.
Once you are confident that list is correct,
you can remove this option and re-run the command and the files will be created.

# Stored results
<!-- Document all results this command returns as either r-class, e-class or s-class macros -->

# Examples

## Example 1


In this example, there is a GitHub repository in the folder _ProjectA_.
This repository has a folder structure where
some folders are still empty but will later be populated with files.
In order to have all folders, even the empty ones,
synced on all collaborators' cloned local copies of the repository,
the folders need to contain at least one file,
which is being created by the command.

```
global github_folder "C:/Users/JohnSmith/Documents/GitHub/ProjectA"
iegitaddmd , folder("$github_folder")
```


## Example 2

In this example, there is a GitHub repository in the folder _ProjectB_.
This is a project similar to _ProjectA_ above but it has two folders,
called foo and bar in which no placeholder files should ever be created in.
Any subfolders in foo or bar will be skipped as well.
The folder _.git_ is a system folder in git repositories and will always be skipped.

```
global github_folder "C:/Users/JohnSmith/Documents/GitHub/ProjectB"
iegitaddmd , folder("$github_folder") skipfolders("foo" "bar")
```

# Feedback, bug reports and contributions

Please send bug-reports, suggestions and requests for clarifications
writing "ietoolkit iegitaddmd" in the subject line to: dimeanalytics@worldbank.org

You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through [GitHub repository](https://github.com/worldbank/ietoolkit) for `ietoolkit`.

# Author

All commands in `ietoolkit` are developed by DIME Analytics at DIME, The World Bank's department for Development Impact Evaluations.

Main authors: DIME Analytics, The World Bank Group
