# Bash Cheat

Bash information, cheatsheets and simple scripts.

Most useful files:

- [main.sh](main.sh): main cheatsheet
- [template/full.sh](main.sh): template for simple CLI interfaces
- [bin/find-music-make-m3u](bin/find-music-make-m3u)

## Introduction

Bash is a backwards compatible version of `sh` with extensions.

It is probably the most widespread version of `sh` today.

[Google coding guidelines](https://en.bitcoin.it/wiki/Satoshi_Client_Node_Discovery)
recommend that it be the only shell variant used.

## Implementations

## sh

## ash

## dash

POSIX 7 specifies a `sh` utility.

`bash` implements all of `sh` and adds many extensions.
The dominant bash implementation is by GNU <http://www.gnu.org/software/bash/>

`dash` is a descendant of the <http://en.wikipedia.org/wiki/Almquist_shell>
It is meant to me more lightweight and faster.
TODO does it share codebase with bash?

`bash --posix` turns on POSIX mode which attempts to be fully POSIX compatible
and turns off most extensions.
It does not seem to be possible to turn on POSIX mode from inside a script.

Ubuntu 14.04 symlinks `/bin/sh` into `/bin/dash`, and `man dash` says:

> Only features designated by POSIX, plus a few Berkeley extensions,
> are being incorporated into this shell.

You should avoid relying on extensions so that your code will be more portable.

The actual history of all those shells is mind bending. Just for the `ash` family:
<http://www.in-ulm.de/~mascheck/various/ash/>

Differences between GNU bash, POSIX and `sh` shall be noted in this directory.

See also:

- <http://askubuntu.com/questions/141928/what-is-difference-between-bin-sh-and-bin-bash>
- <http://stackoverflow.com/questions/5725296/difference-between-sh-and-bash>
- <http://unix.stackexchange.com/questions/44912/are-dash-ash-and-sh-script-100-compatible>

## This repository focuses on the language

POSIX mandates things like:

-   POSIX language features, which account for a large part of its language features.

    All language features are documented in this directory.

-   utilities, either build-in or not, e.g. `ls`, `mkdir`, etc.

    As a rule of thumb, utilities which seem touch bash internals,
    and are more easily implemented as built-ins will be documented here,
    e.g. `cd`, `pwd`.

    Other utilities which feel more external will documented at the
    [Linux Cheat](https://github.com/cirosantilli/linux-cheat/tree/96a1478c66190df4c219bdbb79bde2a3e2cc2423)

## Style guides

-   Google style guide: <https://google-styleguide.googlecode.com/svn/trunk/shell.xml>

    - Variable names lowercase, unless constants or environment.

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

## Why use Bash

Bash golfs extremely well for:

- process management (pipes, stdout, jobs)
- file IO (`echo a > b`)
- history
- tab completion, partially circumvented on other languages by editor autocompletion

## Why not to use Bash

Bash is evil:

- has evil quoting
- has arithmetics, boolean arithmetics, etc.
- evil to get values out of functions
- does not cross operating systems
- lacks good libraries
- slow

## Built-ins

Some utilities are almost always implemented as built-ins such as:

- `cd`
- `eval`
- `read`

because they directly affect the inner state of the shell,
for example its variables or the current directory.

Other commands which could be implemented as separate binaries,
but it may be that bash or sh also implement built-in versions of those,
which is the case for example:

- `echo`
- `printf`
- `test`

POSIX does not specify if commands must be built-ins or separate binaries in path. TODO check

TODO: Include info on special vs regular built-ins.
GNU Bash info <http://www.gnu.org/software/bash/manual/html_node/Special-Builtins.html>.
POSIX info: <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_14>

It is possible that those commands also have a separate binary implementation in the path.

In that case, the built-in version will be used.

## Command line interface

## Invocation

CLI invocation can use:

- `set` options via `[-+]<op>`
- `shopt` options via `[-+O <op>]`
- other options specific to the CLI invocation, which can be found at the top of `man bash`.

This section shall only document options which are exclusive for the command line invocation.

Execute commands from a file and exit:

    cd /tmp
    echo 'echo a' > a.sh
    [ `bash a.sh` = a ] || exit 1

Execute commands from stdin and exit:

    [ `echo 'echo a' | bash` = a ] || exit 1

-   `-c`: execute commands from string and exit:

        [ `bash -c 'echo a'` = a ] || exit 1

-   `-s`: add command line arguments to stdin input or `-c` execution:

        [ `bash -c 'echo $1$2' -s a b` = ab ] || exit 1
        [ `'echo $1$2' | bash -s a b` = ab ] || exit 1

-   `--rcfile`: use given rc file instead of `~/.bashrc`.

    Important because of the famous combo:

        bash --rcfile <(echo ". ~/.bashrc; a=b")

    Which opens a new interactive bash shell with certain commands added to it.

##RC files

See below.

##Files autosourced at startup

They are the way to specify things to all shells such as:

- environment variables, notably `PATH`
- alias
- functions

Explained in detail at `man bash` `INVOCATION` section: very good read.

Nice (closed) SO answer:
<http://stackoverflow.com/questions/415403/whats-the-difference-between-bashrc-bash-profile-and-environment>

Different files are sourced based on how bash was invocated.
There are two boolean invocation parameters to consider:

-   login shell or not?

    In the past, there were no GUI, so the first thing you saw was a shell. That was the login shell.

    On Ubuntu, you can get login shells via `Ctrl + Alt + F1`. If you do `bash` from there, you get non-login shell.

    `man bash` says that:

    > A login shell is one whose first character of argument zero is a -, or one started with the --login option.

    Check if current shell is a login shell:

        shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'

-   interactive shell or not?

    To get a non interactive shell, use:

    - `bash script.sh`
    - `bash -c 'echo a'`

    When you open a `xterm` window, you are in an interactive shell.

    `man bash` says that:

    > An interactive shell is one started without non-option arguments
    > and without the -c option whose standard input and error are both connected
    > to terminals (as determined by isatty(3)), or one started with the -i option.
    > PS1 is set and $- includes i if bash is interactive,
    > allowing a shell script or a startup file to test this state.

    So, to determine if you are on interactive shell or not, do:

        [[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'

    Ubuntu 12.04's default `~/.bashrc` does implies:

    > **Never** source `~/.bashrc` nor `~/.profile` from a non-interactive script.

    because the default `~/.bashrc` like Ubuntu's modify `PS1` and expect it to be defined,
    and `~/.profile` often sources `~/.bashrc`.

The files which may be sourced depending on the above parameters are:

-   `/etc/profile`. Login.

-   `~/.bash_profile`. Login. Ubuntu 12.04 default template sources `.profile` here.

-   `~/.bash_login`. Login if `bash_profile` not found. Never use this.

-   `~/.profile`. Login if neither `bash_profile` nor `bash_login` are found.
    Also used by `sh`, so only portable code here.

-   `/etc/bash.bashrc`. Non-login interactive.

-   `~/.bashrc` Non-login interactive. It is common practice to source this file from the `~/.profile` family,
    so that interactive login shells will also gain commands like aliases.

The above is only a general outline of the most important behaviors. See `man bash` for the nitty-gritty.

As usual, the `/etc` files are shared amongst all users,
while those under `~` are only for a single user.
`/etc/` files are always sourced before the home counterparts.

Things that are not inherited such as `alias` must be declared on the `.bashrc` family.

If you want your `PATH` to be visible to applications launched from the GUI launcher method
(Ubuntu Dash or other methods analogous to Windows start menu),
you must put it into the `.profile` family,
since they will be launched from a login shell.

Put all `sh` portable commands in `.profile`,
and source `.profile` from `.bash_profile`. Done by default by Ubuntu 12.04.

When you modify the `.profile` family, you must log out,
and login again for changes to take effect.
Logout from a login shell can be done via `logout`,
and from Ubuntu GUI, you have to use the GUI. Should be close to `shutdown`.
