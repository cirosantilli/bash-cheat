# CONTRIBUTING

## Style

We follow the [Google Style Guide][https://google-styleguide.googlecode.com/svn/trunk/shell.xml]:

-   variable names lowercase, unless constants or environment.

Our additions / modifications:

-   avoid bash extensions, stick to POSIX.

-   use `$HOME` instead of `~`. Same portability, clearer, can be put inside quoted strings.

-   use the dot `.` operator instead of `source` as it is POSIX 7.

-   quote everything except:

    - commands
    - command switches and flags
    - integers and floating point numbers

    Google says don't quote paths, says nothing about URLs.

    We think that is insane since paths can contain any character and therefore break on expansion.

-   single quote by default, unless you need double.

-   command line options: alphabetically sorted within each group, in order:

    - every single char flag (without option) with a single hyphen
    - single char options with value
    - multi char flags, with or without options

-   always use `--` when passing variable number of arguments to separated options from arguments.
    if the utility accepts it.

-   parameter expansion `$var` only dispenses the `{}` if its the only thing inside the quotes.

-   redirection:

    No spaces before and after `>` and `<`:

        echo a 2>'/dev/null'
        cat <'/dev/zero'

    One space before and after pipe `|`:

        echo a | cat
