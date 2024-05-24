# Title

__iedropone__ - an extension of the command `drop` with features preventing additional observations are unintentionally dropped.

For a more descriptive discussion on the intended usage and work flow of this command please see the [DIME Wiki](https://dimewiki.worldbank.org/Iedropone).

# Syntax

__iedropone__ [__if__] , [ __**n**umobs__(_integer_) __mvar__(_varname_) __mval__(_list of values_) __zerook__ ]

| _options_ | Description |
|-----------|-------------|
| __**n**umobs__(_integer_) | Number of observations that is allowed to be dropped - default is 1 |
| __mvar__(_varname_) | Allows that no observation is dropped |
| __mval__(_list of values_) | Variable for which multiple values should be dropped - must be used together with `mval()` |
| __zerook__ | The list of values in `mvar()` that should be dropped - must be used together with `mvar()` |

# Description
<!-- Longer description of the intended use of the command and best practices related to the usage -->


This commands might be easier to understand by following the examples below before reading the description or the explanations of the options.

`iedropone` has the same purpose as the Stata built-in command `drop` when dropping observations.
However, `iedropone` safeguards that no additional observations are unintentionally dropped,
or that changes are made to the data so that the observations that are supposed to be dropped are no longer dropped.

`iedropone` checks that no more or fewer observations than intended are dropped.
For example, in the case that one observation has been identified to be dropped,
then we want to make sure that when re-running the do-file no other observations are dropped
even if more observations are added to that data set or changed in any other way.

While the default is 1,
`iedropone` allows the user to set any another number of observation that should be dropped.
If the number of observations that fit the drop condition is different,
then the command will throw an error.

# Options

__**n**umobs__(_integer_) this allows the user to set the number of observation that should be dropped.
The default is 1 but any positive integer can be used.
The command throws an error if any other number of observations match the drop condition.

__mvar__(_varname_) and __mval__(_list of values_) allows that multiple values in one variable are dropped.
These two options must be used together.  
If the variable in `mvar()` is a string variable
and some of the values in `mval()` includes spaces,
then the list of values in mval() must be listed exactly as in example 4 below.
The command loops over the values in `mval()`
and drops the observations that satisfy the if condition and each of the value in `mval()`.
For example:

```
iedropone if village == 100 , mvar(household_id) mval(21 22 23)
```

is identical to:

```
iedropone if village == 100 & household_id == 21
iedropone if village == 100 & household_id == 22
iedropone if village == 100 & household_id == 23
```

The default is that exactly one observation should be dropped for each value in `mval()`
unless `numobs()` or `zerook` is used.
If those options are used then, then they apply to all values in `mval()` separately.

__mval__(_list of values_) - see __mvar__(_varname_) above.

__zerook__ allows that no observations are dropped.
The default is that an error is thrown if no observations are dropped.

# Stored results
<!-- Document all results this command returns as either r-class, e-class or s-class macros -->

# Examples


## Example 1.

Let's say that we have identified the household with the ID 712047 to be incorrect and it should be dropped.
Identical to `drop if household_id == 712047` but it will test that
exactly one observation is dropped each time the do-file runs.
This guarantees that we will get an error message that
no observation is dropped if someone makes a change to the ID.
Otherwise we would unknowingly keep this incorrect observation in our data set.

Similarly, if a new observation is added that is the correct household with ID 712047,
then both observation would be dropped without warning if we would have used `drop if household_id == 712047`.
`iedropone` can be used as below to make sure that only that one observations is dropped.
And if the data changes such that two observations are dropped,
then the command will throw and error.

```
iedropone if household_id == 712047
```

## Example 2.

Let's say we have added a new household with the ID 712047.
In order to drop only one of those observations we must expand
the if-condition to indicate which one of them we want to drop.

```
iedropone if household_id == 712047 & household_head == "Bob Smith"
```

## Example 3.

Let's say we added a new household with the ID 712047 but we want to drop exactly both of them,
then we can use the option `numobs()`.  
The command will now throw an error if not exactly
two observations have the household ID 712047.

```
iedropone if household_id == 712047, numobs(2)
```

# Feedback, bug reports and contributions

Please send bug-reports, suggestions and requests for clarifications
writing "ietoolkit iedropone" in the subject line to: dimeanalytics@worldbank.org

You can also see the code, make comments to the code, see the version
history of the code, and submit additions or edits to the code through [GitHub repository](https://github.com/worldbank/ietoolkit) for `ietoolkit`.

# Author

All commands in `ietoolkit` are developed by DIME Analytics at DIME, The World Bank's department for Development Impact Evaluations.

Main authors: DIME Analytics, The World Bank Group
