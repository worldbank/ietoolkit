# `IETOOLKIT` test Folder

This folder contains the files used to test new versions of `ietoolkit`
before they are released.

## How to run the test files?

The files in this folder are meant to be run using the Stata project file
`ietoolkit.stpr` found in the top folder of this repo.

If you have not already, start by cloning this repo to your computer.
Then click the `ietoolkit.stpr` and the test project opens in a window
that looks like the do-file editor.
One difference is that to the left you will see a file tree.
In this tree you will see files like `ieboilstart.do`, `ieddtab.do` etc.
and a file called `main.do`.

If you only want to test a single commands you simply click on
the run file for that command and run this.
Since this test environment use a Stata project
you do not need to set a root path.

You only need to run the file `main.do` in case you want to run
the test files for all commands in `ietoolkit` that there is a run file for.
Note that after running the run file `ieboilstart.do`
you need to restart Stata to restore the settings that run file changed.

## How do I know if the test was successful?

The tests are successful if these two conditions are satisfied:

* The file(s) ran without error
* The outputs generated are identical to
output already committed and pushed to the "outputs" folders for each command.

If a command does not have any output
or if the output are not committed to this repo,
then the tests are only done in the code of the run files.
For example by using `assert` or `capture`/`_rc` to test error codes.

It is practically impossible to design tests for every single potential bug.
We include new tests here for any bug that we find such that
it is made very unlikely that a similar bug can ever be published in the future.
If you have found a bug that slipped past these tests,
then we would be very grateful if you would report that bug
[here](https://github.com/worldbank/ietoolkit/issues).

## Do we recommend using Stata projects in research projects?

If you are a devoted reader of the resources published by our team
[DIME Analytics](https://www.worldbank.org/en/research/dime/data-and-analytics),
then you might notice that we typically do not recommend using Stata projects.

While it is true that we are typically recommending
[dynamic absolute root-paths](https://worldbank.github.io/dime-data-handbook/coding.html#writing-file-paths)
as our preferred standard,
we never make any recommendations against using Stata projects when appropriate.

We think that dynamic absolute root-paths is always a good practice,
while Stata projects are only a good practice when
no file paths in a project point to anything outside the code folder.
Many research projects share code over GitHub
while sharing the raw data over syncing software like DropBox or OneDrive.
In those cases, we do not see any other good practice way than
using dynamic absolute root-paths to create a reproducible project.

In this test environment, then we know for sure that all folder paths
will only point to files inside the clone of this repo.
Stata projects are therefore a convenient solution here,
that makes the testing easier to do, which helps us to do it more often.

To keep DIME Analytic's recommendations simple,
we try to identify a single best practice that
can be used in many cases and even better in all cases.
For file paths,
we still think that dynamic absolute root-paths is the best fit for
that single recommendation.
It would have worked reliable in this test environment as well.
This has never been intended to mean that there is never a case
when some other practice might be an equally or perhaps better fit.
