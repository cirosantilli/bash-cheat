# Note to myself

Bash is evil, has evil quoting, evil to get values out of functions, evil to do list operations and does not cross operating systems.

Bash has 2 good things: find and pipes.

Now that I warned myself, to the bash!

# About

This is my collection of simple bash scripts and related languages ( only awk for the moment ).

I use this to

- learn bash
- automate simple repetitive tasks

For more complex tasks, I tend to use python scripts instead.

# Dependencies

Before you use this collection, run

    install-depencies-apt-get

if you have apt-get on your distro so that you have all the necessary dependencies.

# File naming convention

## Extensions

* no extension : runnable scripts

* .bashsrc : sourceable files (to be used in scripts with '.' (dot) operator instead of run directly )

* .cheatsheet : a cheatsheet ( collection of related commands with simple examples and explanaitions, whole script not to be run directly)

* . exts : holds a newline separated list of extensions associated to each file type for use with multiple applications

* .BUG : scripts that contain a known bug. the bug should be indicated in the header.

* .NOTEST : scripts that have not been tested

## Word separation

'-' (hyphen) as seem to be the most standard for bash scripts

# Abbreviations

* ext : extension
* IPATH : INPUT_PATH
* IPUT : INPUT
* opt-ext : optional extension
* OPUT : OUTPUT
* OPATH : OUTPUT_PATH
* wrap : wrapper. on filenames, indicates a convenient simplified interface for a function.
