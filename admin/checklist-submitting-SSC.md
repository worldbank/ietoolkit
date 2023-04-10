# Checklist for submitting new versions to SSC

*Copy the list below to an issue when starting the process of publishing a new version of ietoolkit*

- [ ] 1. **Merge to *develop*** - Merge all branches with the changes that should be included in the new version first to the `develop` branch.
- [ ] 2. **Create version branch** - This branch _MUST_ be created from the `main` branch. Name this branch the same as the version number you are about to release. For example, `v1.1`, `v2.32` etc.
- [ ] 3. **Merge *develop* to the version branch** - Solve all the conflicts in the version branch and then make sure that step 3.1-3.4 are done in the version branch and nowhere else.
	- [ ] 3.1 **Test in different operative systems** - This step is not necessary every time, but testing the commands in Stata on each of the PC, Mac and Linux operative systems should be done from time to time. A particularly good time to do this is after writing or editing code that depends on file paths, the console, special settings etc. If small updates are needed, then do them in the _version_ branch, otherwise do them in branches of the `develop` branch, merge those to `develop` and then re-merge `develop` to the version branch and test again.
	- [ ] 3.2 **Update version and date** - In the _version_ branch, update the version number and date in all ado-files and all dates in all help files. See section below for details.
	- [ ] 3.3 **Update version locals in ietoolkit** - In the _ietoolkit.ado_ file in the _version_ branch, update the _version_ and _versionDate_ locals at the top of the file.
	- [ ] 3.4 **Update version in .pkg and .toc** - This has nothing to do with SSC but should be kept up to date to. This is for when people install directly through GitHub using `net install`. If any new command has been added, remember to add the files for that command to the `.pkg` file.
	- [ ] 3.5 **Create a .zip file** - Create a .zip file with all ado-files and help files only. These files are not allowed to be in a sub-folder in this .zip file. No other files should be in this folder. Make a copy of this file in the archive folder of this package.
- [ ] 4. **Email Prof. Baum** - Email the .zip file created in step 3.5 to **kit.baum@bc.edu**.
	- [ ] 4.1 - If any commands are added or deleted, make note of that in the email.
	- [ ] 4.2 - If any of the meta info (title, description, keywords, version or author/contact) has changed then include those updates in your email.
- [ ] 5. **Draft release note** - Go to the [release notes](https://github.com/worldbank/ietoolkit/releases) and draft a new release note for the new version. Follow the format from previous releases with links to [issues](https://github.com/worldbank/ietoolkit/issues) solved.
- [ ] 6. **Wait for publication confirmation** - Do not proceed pass this step until Prof. Baum has confirmed that the new version is uploaded to the servers.
- [ ] 7. **Merge version branch to *main*** - If step 2 and 3 was done correctly, then there should not be any merge conflicts in this step. Once merged, delete the `version` branch.
- [ ] 8. **Rebase *develop* to *main*** - This step brings edits done in 3 and 3.1, as well as version updates done in 3.2 and 3.3 into the *develop* branch. The same result can be accomplished - although by creating a slightly messier history - by merging *main* into *develop*. Regardless if the branches are merged or rebased, if any branches created of *develop* was not included in this version, make sure to rebase them to *develop* afterwards, otherwise there is a big risk for very messy conflicts in the future.
- [ ] 9. **Publish release note** - Once the new version is up on SSC, publish the release note.
- [ ] 10. **Close issues** - When the new version is up, close all the [issues](https://github.com/worldbank/ietoolkit/issues) that was solved in the new version.
- [ ] 11. **Send announce email** - If it is a major release (new commands or significant updates to existing commands), send an email to DIME Team to announce the new version.

### Version number and dates in ado-files and help files.

The version number is on the format `number.number` where the first number is incremented if it is a major release. If the first number is incremented the second number is reset to 0. If it is not a major release, then the first number is left unchanged and the second number is incremented.

Version number and date in ado-file. Change both version number and date. Make sure that this line is the very first line in the ado-file.
```
*! version 5.4 15DEC2017  DIME Analytics  dimeanalytics@worldbank.org

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
