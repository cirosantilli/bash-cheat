#about

simple and *dirty* bash scripts and linux how-tos

they are dirty because bash is insane, for professional stuff, use python.

## why perl is here

im also including perl here, since I'll never learn it for real,
so not worth making a separate repo, and I'm gonna use perl
lapes and pies without mercy where regexes are needed.

##why not to use bash!

Bash is evil:

- has evil quoting
- has arithmetics, boolean arithmetics, etc
- evil to get values out of functions
- does not cross operating systems
- lacks good libraries
- slow

bash has 3 good things:
- pipes
- calling methods

(find was the second, but after I learnt python and 
about ack, I changed my mind)

I shall only do extremelly simple stuff with bash, and nothing more than that!

Now that I warned myself, to the bash!

# dependencies

Before you use this collection, run

    install-depencies-apt-get

if you have apt-get on your distro so that you have all the necessary dependencies.

#file naming convention

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

## linux.cheatsheet

my most important file.

how to do install and use stuff on Ubuntu/Linux.

I put every program I install there, and how to use it.

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

## dush and dushf

great for exploring where you hd is too filled

dushf when it takes a long time for each du
