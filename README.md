**ietoolkit**
=====
##**Stata Commands for Impact Evaluations**

### **install and update**
To install **ietoolkit**, type **`ssc install ietoolkit`** in Stata. If you see anything mentioned here (in the master branch) that you do not see reflected in the commands in ietoolkit in Stata on your computer, then you might not have the latest version of **ietoolkit** installed. To update **ietoolkit** type **`adoupdate ietoolkit, update`** to update all the files associated with this package. (It is wise to have the habit of regularly checking if any of your .ado files installed in Stata needs updates by typing **`adoupdate`**.)

### **Background**
These commands are developed by people that work at or with the unit for Development Impact Evaluations (DIME) at the The World Bank. While the commands are developed with best practices for impact evaluations in mind, we still hope and think that these commands can be useful outside our field as well.

###**Bug reports and feature requests**
If you are familiar with GitHub go to the **Contributions** section below for advanced instructions.

A really easy but still very efficient way to provide any feedback on these commands is to create an *issue* in GitHub. You can read *issues* submitted by other users or create a new *issue* in the top menu below <font color="blue">worldbank</font>**/<font color="blue">ietoolkit</font>** at [https://github.com/worldbank/ietoolkit](https://github.com/worldbank/ietoolkit). While the word *issue* has a negative connotation outside GitHub, it can be used for any kind of feedback. If you have an idea for a new command, or a new feature on an existing command, creating an *issue* is a great tool for suggesting that. Please read if someone else have made the same suggestion or reported the same error before creating a new *issue*.


### **Content**

**ietoolkit** provides a set of commands that address different aspects of data management and data analysis in relation to Impact Evaluations. The list of commands will be extended continuously, and suggestions on new commands are highly appreciated. Some of the commands are related to standardized best practices developed at DIME (The World Bank’s unit for Impact Evaluations). For these commands, the corresponding help files provide justifications for the standardized best practices applied. 

 - **ieduplicates** and **iecompdup** are useful tools to identify and correct for duplicates, particulary in primary survey data
 - **iebaltab** is a tool for multiple treatment arm balance tables
 - **ieboilstart** and **ieboilsave** standardizes the boilerplate code at the top of all do-files and the checks applied before saving a data set

### **Contributions**
If you are not familiar with GitHub see the **Bug reports and feature requests** section above for a less technical but still very helpful way to contribute to **ietoolkit**.

GitHub is a wonderful tool for collaboration on code. We appreciate contributions directly to the code and will of course give credit to anyone providing contributions that we merge to the master branch.

Please make your "fork and pull requests" from the `master` branch unless you want to contribute to something that currently only exist in any other branch. Feel free to check out the `develop` branch to see what future updates we are currently working on. If you want to make a contribution by making a "fork and pull requests" but are not exactly sure how to do so, feel free to send an email to kbjarkefur@worldbank.com.

### **License**
**ietoolkit** is developed under MIT license. See http://adampritchard.mit-license.org/ or see [the `LICENSE` file](https://github.com/worldbank/ietoolkit/blob/master/LICENSE) for details.

### **Main Author**
Kristoffer Bjärkefur (kbjarkefur@worldbank.com)
