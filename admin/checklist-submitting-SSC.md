# Checklist for submitting new versions to SSC

- [ ] 1. **Decide on new version number**
  - Look up the current version number. It will be on the format `vX.Y`.
  - If the next release is a major update, decide on the new version number by incrementing the `X` value with 1 and set the `Y` value to 0.
  - If the new release is a small update, decide on the new version number by keeping `X` as is, and incrementing the `Y` value with 1.
  - If needed the values can be made double digits and be on format `vXX.YY`.


- [ ] 2. **Copy this checklist to an issue**
  - On this page, click the `Raw` button and copy all the content of this page into an issue. Call this issue "_Release checklist for vX.Y_". Replace "X.Y" with the version number of the current release. Use this issue to keep track of the progress for this release.


- [ ] 3. **Manage milestones**
  - Edit the name of milestone called `next-release`. Name it `vX.Y`. Replace "X.Y" with the version number of the current release.
  - Create a new milestone and give that milestone the name `next-release`


- [ ] 4. **Merge milestone to `develop`**
  - Make sure that all fixed issues added to the milestone now called `vX.Y` are merged to the `develop` branch
  - For any issues not yet fixed, decide to either:
    - Fix it before continuing with this release
    - Move that issue to the `next-release` milestone


- [ ] 5. **Create version branch `vX.Y`**
  - This branch _MUST_ be created from the `main` branch. Name this branch `vX.Y` where you replace "X.Y" with the version number of the current release.


- [ ] 6. **Merge `develop` to the version branch**
  - Solve all the conflicts in the `vX.Y` branch and then make sure that the sub-steps in this step are done in the `vX.Y` branch and nowhere else.
	- [ ] 6.1 **Test in different operative systems** - This step is not necessary every time, but testing the commands in Stata on each of the PC, Mac and Linux operative systems should be done from time to time. A particularly good time to do this is after writing or editing code that depends on file paths, the console, special settings etc. If testing fails, do one of the following:
		- If a smaller update is required, then make the update in the _version_ branch
		- If a larger update is required, or if the scale of the required update is not clear, then:
  			- Create an issue describing the failed test
			- Create a new branch from the `develop` branch and make the required update there
   			- Once the issue is fixed, merge the new branch to `develop` and then merge `develop` again to the _version_ branch 
	- [ ] 6.2 **Update version and date** - In the `vX.Y` branch, update the version number and date in all ado-files and all dates in all help files. See section below for details.
	- [ ] 6.3 **Update version locals in ietoolkit** - In the _ietoolkit.ado_ file in the `vX.Y` branch, update the _version_ and _versionDate_ locals at the top of the file.
	- [ ] 6.4 **Update version in .pkg and .toc** - This has nothing to do with SSC but should be kept up to date to. This is for when people install directly through GitHub using `net install`. If any new command has been added, remember to add the files for that command to the `.pkg` file.


- [ ] 7 **Create a .zip file**
  - Create a .zip file with all ado-files and help files only. These files are not allowed to be in a sub-folder in this .zip file. No other files should be in this folder.


- [ ] 8. **Email Prof. Baum**
	- [ ] 8.1 - If any commands are added or deleted, make note of that in the email.
	- [ ] 8.2 - If any of the meta info (title, description, keywords, version or author/contact) has changed then include those updates in your email.
  - Email the .zip file created in the previous step to **kit.baum@bc.edu**.


- [ ] 9. **Draft release note**
  - Go to the [release notes](https://github.com/worldbank/ietoolkit/releases) and draft a new release note for the new version. Follow the format from previous releases with links to [issues](https://github.com/worldbank/ietoolkit/issues) solved.


- [ ] 10. **Wait for publication confirmation**
  - Do not proceed pass this step until Prof. Baum has confirmed that the new version is uploaded to the servers.


- [ ] 11. **Merge `vX.Y` branch to `main`**
  - If step 2 and 3 was done correctly, then there should not be any merge conflicts in this step. Once merged, delete the `vX.Y` branch.


- [ ] 12. **Close issues**
  - When the new version is up, close all the [issues](https://github.com/worldbank/ietoolkit/issues) that was solved in the new version.


- [ ] 13. **VERY IMPORTANT STEP - Update `develop` and feature branches**
  - [ ] 13.1 **Update `develop` from `main`**
    - This step brings edits done in the `vX.Y` branch and `main` branch during the release into the `develop` branch. This can either be done with a rebase (more advances, but cleaner history) or a merge (less advance, but messier history).
    - _Rebase_: Rebase the `develop` branch onto `main`. The effect is that it looks as if the `develop` branch was created from where `main` is now.
    - _Merge_: Merge `main` into `develop`. The state of `develop` will be the same as after a rebase, but there will be merge arrows going multiple directions in the network graph. This is not too bad if done only with the `develop` branch, but looks messy if also done with feature branches in next step.
    - [ ] 13.2 **Update feature branches from `develop`**
      - Repeat the same process on all branches that are still open. But update the feature branches from `develop` and not `main`. Often it does not matter if you use `main`, but do it from `develop` in case more edits were already done in `main`.


- [ ] 14. **Publish release note**
  - Once the new version is up on SSC, publish the release note.


- [ ] 15. **Send announce email** - If it is a major release (new commands or significant updates to existing commands), send an email to DIME Team to announce the new version.

---

### Version number and dates in ado-files and help files.

The version number is on the format `X.Y` where the first number is incremented if it is a major release. If the first number is incremented the second number is reset to 0. If it is not a major release, then the first number is left unchanged and the second number is incremented.

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
