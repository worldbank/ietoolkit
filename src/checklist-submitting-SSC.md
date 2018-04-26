# Checklist for submitting new versions to SSC

1. **Merge to *develop*** - Merge all branches with the changes that should be included in the new version first to the `develop` branch.
1. **Test in different operative systems** - This step is not necessary every time, but testing the commands in Stata on each of the PC, Mac and Linux operative systems should be done from time to time. A particularly good time to do this is after writing or editing code that depends on file paths, the console, special settings etc.
1. **Update version and date** - In the `develop` branch, update the version number and date in all ado-files and all dates in all help files. See section below for details.
1. **Update version locals in ietoolkit** - In the _ietoolkit.ado_ file, update the _version_ and _versionDate_ locals at the top of the file.
1. **Merge to *master*** - Merge the `develop` branch to the `master` branch.
1. **Copy files to archive folder** - Make a folder with the version name in the archive folder Dropbox\DIME Analytics\Data Coordinator\ietoolkit\ietoolkit archive\ and copy all ado-files and help files for all *ietoolkit* commands there.
1. **Create a .zip file** - Create a .zip file with all ado-files and help files in the folder you just created in the archive folder. Then remove all files but the .zip file from the archive folder.
1. **Email Prof. Baum** - Email the .zip file to **kit.baum@bc.edu**.
1. **Draft release note** - Go to the [release notes](https://github.com/worldbank/ietoolkit/releases) and draft a new release note for the new version. Follow the format from previous releases with links to [issues](https://github.com/worldbank/ietoolkit/issues) solved.
1. **Publish release note** - Once the new version is up on SSC, publish the release note.
1. **Close issues** - When the new version is up, close all the [issues](https://github.com/worldbank/ietoolkit/issues) that was solved in the new version.
1. **Send announce email** - If it is a major release (new commands or significant updates to existing commands), send an email to DIME Team to announce the new version.

### Version number and dates in ado-files and help files.

The version number is on the format `number.number` where the first number is incremented if it is a major release. If the first number is incremented the second number is reset to 0. If it is not a major release, then the first number is left unchanged and the second number is incremented.

Version number and date in ado-file. Change both version number and date. Make sure that this line is the very first line in the ado-file.
```
*! version 5.4 15DEC2017  DIME Analytics lcardosodeandrad@worldbank.org
		
	capture program drop ietoolkit
	program ietoolkit
```

Date at the top of the help file. Change only the date, there is no version number in the help file.
```
{smcl}
{* 15 Dec 2017}{...}
{hline}
help for {hi:ietoolkit}
{hline}
```
