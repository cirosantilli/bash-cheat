dependencies for each script are documented in lines as follows:

    ^#?DEPENDENCY_TYPE=DEPENDENCY_VALUE

those lines must come before the first non comment line in the file.

current DEPENDENCY_TYPE are:

- deps:         space separated list of scripts relative to current dir.
- ubuntu-deps:  space separated list of ppas. can be installed with `aptitude` for example.
- python-deps:  space separated list of pypi packages. Can be installed via `pip` for example.
