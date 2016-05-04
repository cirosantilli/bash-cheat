# Built-ins

Some utilities are almost always implemented as built-ins such as:

- `cd`
- `eval`
- `read`

because they directly affect the inner state of the shell, for example its variables or the current directory.

Other commands which could be implemented as separate binaries, but it may be that bash or sh also implement built-in versions of those, which is the case for example:

- `echo`
- `printf`
- `test`
- `time` <http://stackoverflow.com/questions/8870333/shell-time-command-source-code>

POSIX does not specify if commands must be built-ins or separate binaries in path. TODO check

TODO: Include info on special vs regular built-ins. GNU Bash info <http://www.gnu.org/software/bash/manual/html_node/Special-Builtins.html>. POSIX info: <http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_14>

It is possible that those commands also have a separate binary implementation in the path.

In that case, the built-in version will be used.
