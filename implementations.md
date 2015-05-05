# Implementations

## sh

## ash

## dash

POSIX 7 specifies a `sh` utility.

`bash` implements all of `sh` and adds many extensions. The dominant bash implementation is by GNU <http://www.gnu.org/software/bash/>

`dash` is a descendant of the <http://en.wikipedia.org/wiki/Almquist_shell> It is meant to me more lightweight and faster. TODO does it share codebase with bash?

`bash --posix` turns on POSIX mode which attempts to be fully POSIX compatible and turns off most extensions. It does not seem to be possible to turn on POSIX mode from inside a script.

Ubuntu 14.04 symlinks `/bin/sh` into `/bin/dash`, and `man dash` says:

> Only features designated by POSIX, plus a few Berkeley extensions,
> are being incorporated into this shell.

You should avoid relying on extensions so that your code will be more portable.

The actual history of all those shells is mind bending. Just for the `ash` family: <http://www.in-ulm.de/~mascheck/various/ash/>

Differences between GNU bash, POSIX and `sh` shall be noted in this directory.

See also:

- <http://askubuntu.com/questions/141928/what-is-difference-between-bin-sh-and-bin-bash>
- <http://stackoverflow.com/questions/5725296/difference-between-sh-and-bash>
- <http://unix.stackexchange.com/questions/44912/are-dash-ash-and-sh-script-100-compatible>

## BusyBox

Lightweight, single executable implementation of `sh` and most POSIX utilities without any shared dependencies. Used embedded systems with very little resources.
