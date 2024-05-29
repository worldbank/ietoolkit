# Title

__iekdensity__ - This command plots univariate kernel density estimates by treatment assignment.

# Syntax

__iekdensity__ _yvar_ [if] [in] [weight] , __by__(_treatmentvar_) 
  [ __stat__(_string_) __statstyle__(_string_) __effect__ __control__(_numlist_) __effectformat__(_%fmt_) __**abs**orb__(_varname_) __**reg**ressionoptions__(_string_) __**kdensity**options__(_string_) __color__(_string_) 
            _twoway_options_ ]

Where _yvar_ is a numeric continuous outcome variable, whose distribution is to be plotted by treatment assignment.

| _options_ | Description |
|-----------|-------------|
|  __by__(_treatmentvar_)  |  Treatment (dummy or factor) variable. |

## Content options:

| _options_ | Description |
|-----------|-------------|
| __stat__(_string_) | Add vertical lines for each treatment group with statistic specified. |
| __statstyle__(_string_) | Specify graphic style of statistic lines. |
| __effect__ | Add note with treatment effect, containing point estimate, standard error, and p-value. |
| __control__(_numlist_) | Specify value of variable for control group. |
| __effectformat__(_%fmt_) | Specify format of point estimate and standard error of the treatment effect. |

## Estimation options:
| _options_ | Description |
|-----------|-------------|
| __**abs**orb__(_varname_) | Specify fixed effects variable, if any. |
| __**reg**ressionoptions__(_string_) | Specify regression options. | 
| __**kdensity**options__(_string_) | Specify kernel estimation options. |

## Graphic options:
| _options_ | Description |
|-----------|-------------|
| __color__(_string_) | Specify colors for each group. | 
| _twoway_options_ | Specify graph options. |


# Description

__iekdensity__ is a command that allows to easily plot the distribution of a variable by treatment group.  It also allows to include additional information, such as descriptive statistics and treatment effect(s).

# Options

__**Required options:**__

__by__(treatmentvar) indicates which variable should be used to idenfity the treatment assignment. This can be a dummy variable (0/1) or a factor variable, when there are multiple treatments.

__**Content options**__ 

__stat__(_string_) specifies a descriptive statitistic to be plotted over the kernel density graph. In particular, vertical lines for each treatment group are added. Accepted statistics are: _mean, p1, p5, p50, p75, p90, p95, p99, min_ and _max_.

__statstyle__(_string_) specifies the graphic style to be used for the statistic lines. Namely, you will be able to use __lpattern__(linepatternstyle) and __lwidth__(linewidthstyle) opt ad controlled by option __color__(_string_).

__effect__ adds a note with treatment effect, containing point estimate, standard error, and p-value, to the graph.

__control__(_numlist_) indicates which value the variable __by__(_treatmentvar_) takes for the control group. This is usually equal to 0 when the treatment is binary, but may vary when dealing wi arms.

__effectformat__(_%fmt_) specify the format in which treatment effect point estimate and standard error should be displayed in the graph note.

__**Estimation options:**__

__**abs**orb__(_varname_) indicates the fixed effects variable (for example, the experimental strata when the treatment was stratified) to be included in the estimation. This variable must be numerical.

__**reg**ressionoptions__(_string_) indicates other options to be employed for the treatment effect estimations, for example suppress constant term (__**nocons**tant__) or clustered standard errors (__**cl**uster__(_varname_)). Al regress (or areg when option __absorb()__ is specified) are accepted.

__**kdensity**options__(_string_) specifies kernel estimation options, such as kernel function and half-width of kernel. The default kernel function is __kernel__(_epanechnikov_). Many options accepted by kdensity are : __kernel__(_kernel_), __bwidth__(_#_), __n__(_#_), and all the _cline_options_ (see `help cline_options`) for univariate kernel density estimation.

__**Graphic options:**__

__color__(_string_) indicates the colors to be used for each treatment arm. The colors should come in the order of the values in __by__(_treatmentvar_). For instance, if the treatment is binary, you can set the line colors (color1 color2). See _colorstyle_ (`help colorstyle`).

_twoway_options_ indicates other options to be applied to the graph, such as additional text and lines, changes axes, titles, and legend, etc. (See `help twoway_options`)

# Examples
All the examples below can be run on the Stata's built in automobile data set, by first running this code:

* Open the built in data set

```
sysuse auto
```

* Randomly assign time and treatment dummies

```        
gen treatment = (runiform() < .5)
```

## Example 1

```
iekdensity auto , by(treatment)
```

This is the most basic way to run this command. This will output a graph with the distributions of of the variable of interests (price in this case) by treatment assignment.

## Example 2

```
iekdensity auto , by((treatment) stat(p50)
```

This is an easy way to add descriptive information to the graph. This will output the same graph as above with the addition of two vertical lines for the medians of the control and treatment groups.

## Example 2.1

```
iekdensity auto , by(treatment) stat(p50) statstyle(lpattern(dash) lwithd(2))
```

This changes the style of the median vertical lines.

## Example 2.2

```
iekdensity auto , by(treatment) stat(p50) statstyle(lpattern(dash) lwithd(2)) color(eltblue edkblue)
```

This sets the colors of the control and treatment lines to different shades of blue.

## Example 2.3

```
iekdensity auto , by(treatment) stat(p50) statstyle(lpattern(dash) lwithd(2)) title(auto distribution) subtitle(By Treatment Assignment)
graphregion(color(white)) plotregion(color(white))
```

This changes some of the graphical options.

## Example 3

```
iekdensity auto , by(treatment) stat(p50) effect
```

This adds a note to the graph, displaying the treatment effect in terms of point estimate, standard error and statistical significance.

## Example 3.1

```
iekdensity auto , by(treatment) stat(p50) effect effectformat(%9.0fc)
```

This changes the format of the treatment effect in the note. The point estimate and the standard error now do not include any decimal points.


## Example 4

```
iekdensity auto , by(treatment) effect absorb(foreign)
```

The treatment effect is now derived from a regression controlling for the variable _foreign_ fixed effects.

## Example 4.1

```
iekdensity auto , by(treatment) effect absorb(foreign) regressionoptions(cluster(foreign))
```

The treatment effect is now derived from a regression controlling for the variable foreign fixed effects and clustering standard errors at _foreign_ level.

## Example 5

```
iekdensity auto , by(treatment) kdensityoptions(epan2 bwidth(5))
```

The kernel density is estimated through the alternative Epanechnikov kernel function and half-width of the kernel is specified to be equal to 5.

# Acknowledgements

We would like to acknowledge the help in testing and proofreading we received in relation to this command and help file from (in alphabetic order):
Luiza Andrade


# Feedback, bug reports and contributions

Please send bug-reports, suggestions and requests for clarifications writing "ietoolkit iekdensity" in the subject line to: dimeanalytics@worldbank.org

        
You can also see the code, make comments to the code, see the version history of the code, and submit additions or edits to the code through  [GitHub repository](https://github.com/worldbank/ietoolkit) for `ietoolkit`.

# Authors

All commands in `ietoolkit` are developed by DIME Analytics at DIME, The World Bank's department for Development Impact Evaluations.
        
Main author: Matteo Ruzzante, DIME, The World Bank Group.

        


