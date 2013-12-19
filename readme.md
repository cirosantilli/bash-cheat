Simple bash scripts and cheats.

Bash is a backwards compatible version of `sh` with extensions.

It is probably the most widespread version of `sh` today.

POSIX 7 specifies a `sh` utility, and the GNU implementations of both `bash` and `sh` contain many extensions.

You should avoid relying on those features when writing portable code.

Differences between GNU bash, GNU sh, and POSIX sh shall be noted.

POSIX mandates things like

- POSIX language features, which account for a large part of its language features.

    All language features are documented in this directory.

- utilities

    In practice some utilities are almost always implemented as built-ins such as:

    - cd
    - eval
    - read

    because they directly affect the inner state of the shell, for example its variables or the current dirctory.

    Other commands which could be implemented as separate binaries,
    but it may be that bash or sh also implement built-in versions of those,
    which is the case for example:

    - echo
    - printf
    - test

    POSIX does not specify if commands must be built-ins or separate binaries in path.

    It is possible that those commands also have a separate binary implementation in the path.

    In that case, the built-in version will be used.

Utilities mandated by POSIX shall not in general be docummented here, even if bash or sh implement them as built-ins.
This is so because it is arbitrary if utilities are a part of bash or separate binaries, so it does not make sense to
document them together with bash.

Utilities that exist only as sh or bash built-ins and which are not mandated by POSIX shall be documented here.

# featured

scripts that you may like follow. the others may be useless.

## find-music-make-m3u

check the recursive function which for each directory, makes an m3u all.m3u with all music under that directory.

ex:

* **dir1**
    * f11.wma
    * **dir11**
        * f111.mp3
        * f112.ogg

becomes:

* **dir1**
    * all.m3u
    * f11.wma
    * **dir11**
        * all.m3u
        * f111.mp3
        * f112.ogg

where the all.m3u contains all music files under its parent dir.

# why not to use bash

bash is evil:

- has evil quoting
- has arithmetics, boolean arithmetics, etc
- evil to get values out of functions
- does not cross operating systems
- lacks good libraries
- slow

bash has the following good things:

- process management (pipes, stdout, jobs)
- file io (`echo a > b`)
- history
- tab completion (partially circunvented by other languages editor autocompletion)

# command line interface

Execute commands from a file and exit:

    echo 'echo a' > a.sh
    bash a.sh

Execute commands from stdin and exit:

    [ `echo 'echo a' | bash` = a ] || exit 1

- `-c`: execute commands from string and exit:

        [ `bash -c 'echo a'` = a ] || exit 1

- `-s`: add command line arguments to stdin input or `-c` execution:

        [ `bash -c 'echo $1$2' -s a b` = ab ] || exit 1
        [ `'echo $1$2' | bash -s a b` = ab ] || exit 1
