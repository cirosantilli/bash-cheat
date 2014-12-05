# RC files

# Files autosourced at startup

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
