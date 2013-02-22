# featured

scripts that you may like follow. the others may be useless.

## cheat/linux

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

##why not to use bash!

bash is evil:

- has evil quoting
- has arithmetics, boolean arithmetics, etc
- evil to get values out of functions
- does not cross operating systems
- lacks good libraries
- slow

bash has 2 good things:

- pipes
- calling methods
