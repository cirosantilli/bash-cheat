Simple Bash scripts and cheats. `sh` and other variants may also be included.

Most useful files:

- [cheat](cheat): main cheatsheet.
- [bin/find-music-make-m3u](bin/find-music-make-m3u)

#Introduction

Bash is a backwards compatible version of `sh` with extensions.

It is probably the most widespread version of `sh` today.

Google coding guidelines recommend that it be the only shell variant used.

POSIX 7 specifies a `sh` utility, and the GNU implementations of both `bash` and `sh` contain many extensions.

In modern systems such as Ubuntu 12.04, invoking as either `sh` or `bash --posix` turns on POSIX mode which attempts to be fully POSIX compatible. It does not seem to be possible to turn on POSIX mode from inside a script.

You should avoid relying on those features when writing portable code.

Differences between GNU bash, GNU sh, and POSIX sh shall be noted in this directory.

POSIX mandates things like:

- POSIX language features, which account for a large part of its language features.

    All language features are documented in this directory.

- utilities, either build-in or not.

Utilities mandated by POSIX shall not in general be documented here, even if bash or sh implement them as built-ins.

This is so because it is arbitrary if utilities are a part of bash or separate binaries, so it does not make sense to document them together with Bash.

Utilities that exist only as sh or bash built-ins and which are not mandated by POSIX shall be documented here.

#Why use Bash

Bash golfs extremely well for:

- process management (pipes, stdout, jobs)
- file IO (`echo a > b`)
- history
- tab completion, partially circumvented on other languages by editor autocompletion

#Why not to use Bash

Bash is evil:

- has evil quoting
- has arithmetics, boolean arithmetics, etc
- evil to get values out of functions
- does not cross operating systems
- lacks good libraries
- slow

#Build-ins

Some utilities are almost always implemented as built-ins such as:

- `cd`
- `eval`
- `read`

because they directly affect the inner state of the shell, for example its variables or the current dirctory.

Other commands which could be implemented as separate binaries, but it may be that bash or sh also implement built-in versions of those, which is the case for example:

- `echo`
- `printf`
- `test`

POSIX does not specify if commands must be built-ins or separate binaries in path.
TODO: possibly false.
Include info on special vs regular built-ins:
GNU Bash info <http://www.gnu.org/software/bash/manual/html_node/Special-Builtins.html>
POSIX info: <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_14>

It is possible that those commands also have a separate binary implementation in the path.

In that case, the built-in version will be used.

#Command line interface

#Invocation

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

- `-c`: execute commands from string and exit:

        [ `bash -c 'echo a'` = a ] || exit 1

- `-s`: add command line arguments to stdin input or `-c` execution:

        [ `bash -c 'echo $1$2' -s a b` = ab ] || exit 1
        [ `'echo $1$2' | bash -s a b` = ab ] || exit 1

- `--rcfile`: use given rc file instead of `~/.bashrc`.

    Important because of the famous combo:

        bash --rcfile <(echo ". ~/.bashrc; a=b")

    Which opens a new interactive bash shell with certain commands added to it.

#RC files

See below.

#Files autosourced at startup

They are the way to specify things to all shells such as:

- environment variables, notably `PATH`
- alias
- functions

Explained in detail at `man bash` `INVOCATION` section: very good read.

Nice (closed) SO answer: <http://stackoverflow.com/questions/415403/whats-the-difference-between-bashrc-bash-profile-and-environment>

Different files are sourced based on how bash was invocated. There are two boolean invocation parameters to consider:

- login shell or not?

    In the past, there were no GUI, so the first thing you saw was a shell. That was the login shell.

    On Ubuntu, you can get login shells via `Ctrl + Alt + F1`. If you do `bash` from there, you get non-login shell.

    `man bash` says that:

    > A login shell is one whose first character of argument zero is a -, or one started with the --login option.

    Check if current shell is a login shell:

        shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'

- interactive shell or not?

    To get a non interactive shell, use:

    - `bash script.sh`
    - `bash -c 'echo a'`

    When you open a `xterm` window, you are in an interactive shell.

    `man bash` says that:

    > An interactive shell is one started without non-option arguments and without the -c option whose standard input and error are both connected to terminals (as determined by isatty(3)), or one started with the -i option.  PS1 is set and $- includes i if bash is interactive, allowing a shell script or a startup file to test this state.

    So, to determine if you are on interactive shell or not, do:

        [[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'

    Consequence of `PS1` no being set:

    > **Never** source `~/.bashrc` nor `~/.profile` from a non-interactive script

    because `~/.bashrc` often modifies `PS1` and expects it to be defined, and `~/.profile` often sources `~/.bashrc`.

The files which may be sourced depending on the above parameters are:

- `/etc/profile`. Login.
- `~/.bash_profile`. Login. Ubuntu 12.04 default template sources `.profile` here.
- `~/.bash_login`. Login if `bash_profile` not found. Never use this.
- `~/.profile`. Login if neither `bash_profile` nor `bash_login` are found. Also used by `sh`, so only portable code here.
- `/etc/bash.bashrc`. Non-login interactive.
- `~/.bashrc` Non-login interactive. It is common practice to source this file from the `~/.profile` family,
    so that interactive login shells will also gain commands like aliases.

The above is only a general outline of the most important behaviors. See `man bash` for the nitty-gritty.

As usual, the `/etc` files are shared amongst all users, while those under `~` are only for a single user. `/etc/` files are always sourced before the home counterparts.

Things that are not inherited such as `alias` must be declared on the `.bashrc` family.

If you want your `PATH` to be visible to applications launched from the GUI launcher method (Ubuntu Dash or other methods analogous to Windows start menu), you must put it into the `.profile` family, since they will be launched from a login shell.

Put all `sh` portable commands in `.profile`, and source `.profile` from `.bash_profile`. Done by default by Ubuntu 12.04.

When you modify the `.profile` family, you must log out, and login again for changes to take effect. Logout from a login shell can be done via `logout`, and from Ubuntu GUI, you have to use the GUI. Should be close to shutdown.
