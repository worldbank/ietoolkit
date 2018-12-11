**ietoolkit - Stata Commands for Impact Evaluations**
=====

### **Install and Update**
To install **ietoolkit**, type **`ssc install ietoolkit`** in Stata. If you see anything mentioned here (in the master branch) that you do not see reflected in the commands in **ietoolkit** in Stata on your computer, then you might not have the latest version of **ietoolkit** installed. To update all files associated with **ietoolkit** type **`adoupdate ietoolkit, update`** in Stata. (It is wise to be in the habit of regularly checking if any of your .ado files installed in Stata need updates by typing **`adoupdate`**.)

Stata version 11 or later is required for this package of commands.

While all users should use **`ssc install ietoolkit`** to install published versions of **ietoolkit** that are tested for public release, it is also possible to install versions of the command that we are currently developing. Anyone is free to do so, but this method is intended only for when testing not yet released versions of **ietoolkit**. The instructions for how to do so are found here [here](https://github.com/worldbank/ietoolkit/blob/master/admin/testfolder/test-instructions.md).

### **Background**
These commands are developed by people that work at or with the Development Impact Evaluations (DIME) unit at the World Bank. While the commands are developed with best practices for impact evaluations in mind, these commands can be useful outside that field as well.

### **Bug Reports and Feature Requests**
If you are familiar with GitHub go to the **Contributions** section below for advanced instructions.

An easy but still very efficient way to provide any feedback on these commands is to create an *issue* in GitHub. You can read *issues* submitted by other users or create a new *issue* in the top menu below [**worldbank**/**ietoolkit**](https://github.com/worldbank/ietoolkit) at [https://github.com/worldbank/ietoolkit](https://github.com/worldbank/ietoolkit). While the word *issue* has a negative connotation outside GitHub, it can be used for any kind of feedback. If you have an idea for a new command, or a new feature on an existing command, creating an *issue* is a great tool for suggesting that. Please read already existing *issues* to check whether someone else has made the same suggestion or reported the same error before creating a new *issue*.

While we have a slight preference for receiving feedback here on GitHub, you are still very welcome to send a regular email with your feedback to [dimeanalytics@worldbank.org](mailto:dimeanalytics@worldbank.org).

### **Content**
**ietoolkit** provides a set of commands that address different aspects of data management and data analysis in relation to Impact Evaluations. The list of commands will be extended continuously, and suggestions for new commands are greatly appreciated. Some of the commands are related to standardized best practices developed at DIME (The World Bank’s unit for Impact Evaluations). For these commands, the corresponding help files provide justifications for the standardized best practices applied.

 - **ietoolkit** returns meta info on the version of _ietoolkit_ installed. Can be used to ensure that the team uses the same version.
 - **iebaltab** is a tool for multiple treatment arm balance tables
 - **ieddtab** is a tool for difference-in-difference regression tables
 - **ieduplicates** and **iecompdup** are useful tools to identify and correct for duplicates, particulary in primary survey data
 - **ieboilstart** standardizes the boilerplate code at the top of all do-files
 - **iefolder** sets up project folders and master do-files according to DIME's recommended folder structure
 - **iegitaddmd** adds placeholder README.md files to all empty subfolders allowing them to be synced on GitHub
 - **iematch** is an algorithm for matching observations in one group to the "most similar" observations in another group
 - **iegraph** produces graphs of estimation results in common impact evaluation regression models
 - **iedropone** drops observations and controls that the correct number was dropped
 - **ieboilsave** performs checks before saving a data set

### **Contributions**
If you are not familiar with GitHub see the **Bug reports and feature requests** section above for a less technical but still very helpful way to contribute to **ietoolkit**.

GitHub is a wonderful tool for collaboration on code. We appreciate contributions directly to the code and will of course give credit to anyone providing contributions that we merge to the master branch. If you have any questions on anything in this section, please do not hesitate to email [dimeanalytics@worldbank.org](mailto:dimeanalytics@worldbank.org). See [CONTRIBUTING.md](https://github.com/worldbank/ietoolkit/blob/master/CONTRIBUTING.md) for some more details on for example naming conventions.

The Stata files on the `master` branch are the files most recently released on the SSC server. README, LICENSE and similar files are updated directly to `master` in between releases. Check out any of the `develop` branches (if there are any) if you want to see what future updates we are currently working on.

Please make pull requests to the `master` branch **only** if you wish to contribute to README, LICENSE or similar meta data files. If you wish to make a contribution to any Stata file, then please **do not** use the `master` branch. If you wish to make a contribution to any Stata files that we have published at least once, then please fork from and make your pull request to the `develop` branch. The `develop` branch includes all minor edits we have made to already published commands since the last release that we will include in the next version released on the SSC server. If your addition is related to a specific issue in this repository, then see the naming convention in the [CONTRIBUTING.md](https://github.com/worldbank/ietoolkit/blob/master/CONTRIBUTING.md) file.

All Stata commands we are working on that we have yet to release a first version of, are found in the branches called `develop-NAME` where *NAME* corresponds to the working name of the command that is yet to be published. If you wish to contribute to any of those commands, then please fork from the branch of the command you want to contribute to, and only make edits to the .ado/.do and .sthlp that correspond to that command. If you want to make contributions to multiple commands that have yet to be released, then you will have to fork from and make pull request to multiple branches.

If you wish to make a contribution by making *forks and pull requests* but are not exactly sure how to do so, feel free to send an email to [dimeanalytics@worldbank.org](mailto:dimeanalytics@worldbank.org).

### Other DIME Anlytics Repositories
* [Stata adofiles repository](https://github.com/worldbank/stata)
* [Stata Visual Library](https://worldbank.github.io/Stata-IE-Visual-Library/)
* [DIME LaTeX templates and training](https://github.com/worldbank/DIME-LaTeX-Templates)

### **License**
**ietoolkit** is developed under MIT license. See http://adampritchard.mit-license.org/ or see [the `LICENSE` file](https://github.com/worldbank/ietoolkit/blob/master/LICENSE) for details.

### **Main Contact**
Luiza Cardoso de Andrade ([dimeanalytics@worldbank.org](mailto:dimeanalytics@worldbank.org))

### **Authors**
Kristoffer Bjärkefur, Luiza Cardoso de Andrade, Benjamin Daniels, Mrijan Rimal
