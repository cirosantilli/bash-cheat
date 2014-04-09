Dependencies for each script are documented in lines as follows:

    ^#?DEPENDENCY_TYPE=DEPENDENCY_VALUE

Those lines must come before the first non comment line in the file.

Current `DEPENDENCY_TYPE` are:

- `deps`:         space separated list of scripts relative to current dir.
- `ubuntu-deps`:  space separated list of PPAs. Can be installed with `aptitude` for example.
- `python-deps`:  space separated list of PyPI packages. Can be installed via `pip` for example.

Only reasonably complex scripts will be kept here. Simpler stuff will go directly in `.bashrc` aliases or functions.
