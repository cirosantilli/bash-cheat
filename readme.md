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

# Featured

This showcases scripts that I find:

* good enough
* original enough
* hard enough to make

that I recommend you to check out

## ubuntu-howto

how to do install and use stuff on Ubuntu/Linux.

I put every program I install there, and how to use it:

- so that I won't forget
- so that it may be useful to you

For programs that are too large, they may get their own files in this repo like git.cheatsheet.

Look for the cheatsheet extension.

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
