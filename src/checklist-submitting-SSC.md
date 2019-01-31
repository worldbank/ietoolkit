# Checklist for submitting new versions to SSC

*Copy the list below to an issue when starting the process of publishing a new version of ietoolkit*

- [ ] 1. **Merge to *develop*** - Merge all branches with the changes that should be included in the new version first to the `develop` branch.
- [ ] 2. **Test in different operative systems** - This step is not necessary every time, but testing the commands in Stata on each of the PC, Mac and Linux operative systems should be done from time to time. A particularly good time to do this is after writing or editing code that depends on file paths, the console, special settings etc.
- [ ] 3. **Update version and date** - In the `develop` branch, update the version number and date in all ado-files and all dates in all help files. See section below for details.
- [ ] 4. **Update version locals in ietoolkit** - In the _ietoolkit.ado_ file, update the _version_ and _versionDate_ locals at the top of the file.
- [ ] 5. **Create pull request from *develop* to *master*** - Create a pull request from the `develop` branch to the `master` branch, but do not merge it yet. We only want to merge after the content is published on SSC. The reason why we still want to create the pull request at this point is that any merge conflicts require us to make edits to the code we are sumbitting to SSC.
- [ ] 6. **Make sure that there is no conflicts in the pull request you just created** - Make sure to include any edits this step requires you to do in the version you are sending to SSC. Do not merge yet.
- [ ] 7. **Copy files to archive folder** - Make a folder with named after the new version number in the archive folder Dropbox\DIME Analytics\Data Coordinator\ietoolkit\ietoolkit archive\ and copy all ado-files and help files for all *ietoolkit* commands there.
- [ ] 8. **Create a .zip file** - Create a .zip file with all ado-files and help files in the folder you just created in the archive folder. Then remove all files but the .zip file from the archive folder.
- [ ] 9. **Merge the pull request** - Merge the pull request for this new version. It should not have any conflicts, so just merge it. Remeber to delete the *develop* branch and create a new *develop* branch from the most recent version of the *master* branch.
- [ ] 10. **Email Prof. Baum** - Email the .zip file to **kit.baum@bc.edu**. If any commands are added or deleted, make note of that in the email.
- [ ] 11. **Draft release note** - Go to the [release notes](https://github.com/worldbank/ietoolkit/releases) and draft a new release note for the new version. Follow the format from previous releases with links to [issues](https://github.com/worldbank/ietoolkit/issues) solved.
- [ ] 12. **Wait for publication confirmation** - Do not proceed pass this step until Prof. Baum has confirmed that the new version is uploaded to the servers.
- [ ] 13. **Publish release note** - Once the new version is up on SSC, publish the release note.
- [ ] 14. **Close issues** - When the new version is up, close all the [issues](https://github.com/worldbank/ietoolkit/issues) that was solved in the new version.
- [ ] 15. **Send announce email** - If it is a major release (new commands or significant updates to existing commands), send an email to DIME Team to announce the new version.

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
