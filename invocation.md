# Invocation

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
