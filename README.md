**ietoolkit**
=====
##**Stata Commands for Impact Evaluations**

### **Install and Update**
To install **ietoolkit**, type **`ssc install ietoolkit`** in Stata. If you see anything mentioned here (in the master branch) that you do not see reflected in the commands in ietoolkit in Stata on your computer, then you might not have the latest version of **ietoolkit** installed. To update all files associated with **ietoolkit** type **`adoupdate ietoolkit, update`** in Stata. (It is wise to be in the habit of regularly checking if any of your .ado files installed in Stata need updates by typing **`adoupdate`**.)

Stata version 11 or later is required for this command.

### **Background**
These commands are developed by people that work at or with the unit for Development Impact Evaluations (DIME) at the The World Bank. While the commands are developed with best practices for impact evaluations in mind, we still hope and think that these commands can be useful outside our field as well.

###**Bug Reports and Feature Requests**
If you are familiar with GitHub go to the **Contributions** section below for advanced instructions.

An easy but still very efficient way to provide any feedback on these commands is to create an *issue* in GitHub. You can read *issues* submitted by other users or create a new *issue* in the top menu below [ worldbank**/ietoolkit**](https://github.com/worldbank/ietoolkit) at [https://github.com/worldbank/ietoolkit](https://github.com/worldbank/ietoolkit). While the word *issue* has a negative connotation outside GitHub, it can be used for any kind of feedback. If you have an idea for a new command, or a new feature on an existing command, creating an *issue* is a great tool for suggesting that. Please read already existing *issues* to check whether someone else has made the same suggestion or reported the same error before creating a new *issue*.


### **Content**

**ietoolkit** provides a set of commands that address different aspects of data management and data analysis in relation to Impact Evaluations. The list of commands will be extended continuously, and suggestions for new commands are greatly appreciated. Some of the commands are related to standardized best practices developed at DIME (The World Bank’s unit for Impact Evaluations). For these commands, the corresponding help files provide justifications for the standardized best practices applied. 

 - **ieduplicates** and **iecompdup** are useful tools to identify and correct for duplicates, particulary in primary survey data
 - **iebaltab** is a tool for multiple treatment arm balance tables
 - **ieboilstart** and **ieboilsave** standardizes the boilerplate code at the top of all do-files and the checks applied before saving a data set

### **Contributions**
If you are not familiar with GitHub see the **Bug reports and feature requests** section above for a less technical but still very helpful way to contribute to **ietoolkit**.

GitHub is a wonderful tool for collaboration on code. We appreciate contributions directly to the code and will of course give credit to anyone providing contributions that we merge to the master branch. If you have any questions on anything in this section, please do not hisitate to email kbjarkefur@worldbank.com.

The Stata files on the `master` branch are the files most recently released on the SSC server. README, LICENSE and similar files are updated directly to `master` in between releases. Check out any of the `develop` branches (if there are any) if you want to see what future updates we are currently working on.

Please make your "fork and pull requests" from the `master` branch only if you wish to contribute to README, LICENSE or similar meta data files. If you wish to make contribution to any Stata file, then please **do not** use the `master` branch. If you wish to make a contribution to any Stata files that we have published at least once, then please fork from the `develop` branch. The `develop` branch include all minor edits we have made to already published commands since the last release that we will include in the next version released on the SSC server.

All Stata commands we are working on that we have yet to release a first version of is found in the branches called `develop-NAME` where *NAME* corresponds to the working name of the command that is yet to be published. If you wish to contribute to any of those commands, then please fork from the branch of the command you want to contribute to, and only make edits to the .ado/.do and .sthlp that correspond to that command. If you want to make contributions to multiple commands yet to be released, then you will have to fork from multiple branches.

If you wish to make a contribution by making a "fork and pull request" but are not exactly sure how to do so, feel free to send an email to kbjarkefur@worldbank.com.

### **License**
**ietoolkit** is developed under MIT license. See http://adampritchard.mit-license.org/ or see [the `LICENSE` file](https://github.com/worldbank/ietoolkit/blob/master/LICENSE) for details.

### **Main Author**
Kristoffer Bjärkefur (kbjarkefur@worldbank.com)
