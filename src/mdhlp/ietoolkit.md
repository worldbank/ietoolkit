# Title

__ietoolkit__ - Returns information on the version of `ietoolkit` installed

For a more descriptive discussion on the intended usage and work flow of this command please see the [DIME Wiki](https://dimewiki.worldbank.org/Ietoolkit).

# Syntax

__ietoolkit__

Note that this command takes no arguments at all.

# Description

`ietoolkit` This command returns the version of `ietoolkit` installed. It can be used  to programmatically test if `ietoolkit` is already installed.

# Options

This command does not take any options.

# Examples

The code below is an example code that can be added to the top of any do-file.  The example code first tests if the command is installed, and install it if not. If it is installed, it tests if the version is less than version 5.0. If it is, it replaces the `ietoolkit` file with the latest version. In your code you can skip the second part if you are not sure which version is required. But you should always have the first part testing that `r(version)` has a value before using it in less than or greater than expressions.

```
cap ietoolkit
if "`r(version)'" == "" {
  *ietoolkit not installed, install it
  ssc install ietoolkit
}
else if `r(version)' < 5.0 {
  *ietoolkit version too old, install the latest version
  ssc install ietoolkit , replace
}
```

# Acknowledgements

We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetic order):

  Luiza Cardoso De Andrade, Seungmin Lee

# Author

All commands in `ietoolkit` is developed by DIME Analytics at DIME, the World Bank's department for Development Impact.

Main author: DIME Analytics, The World Bank

Please send bug-reports, suggestions and requests for clarifications writing "ietoolkit ietoolkit" in the subject line to: dimeanalytics@worldbank.org

You can also see the code, make comments to the code, see the version history of the code, and submit additions or edits to the code through the GitHub repository of `ietoolkit`.
