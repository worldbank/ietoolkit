*This file is meant to be run from master_test.

cap program drop   test_returns
    program define test_returns

    syntax, command(string) name(string) type(string) value(string) [number]

    *Test if missing
    if "`value'" == "" {
        noi di as error "{phang2}`command': `type' r(`name') is missing.{p_end}"
        error 198
    }

    *If it is supposed to be a number, then test that
    if "`number'" == "number" {
        capture confirm number `value'
        if _rc {
            noi di as error "{phang2}`command': `type' r(`name') with value [`value'] is not a number.{p_end}"
            confirm number `value'
        }
    }

    *Report that things seems ok
    noi di "{phang2}`command': `type' r(`name') with value [`value'] seems ok!{p_end}"

end
