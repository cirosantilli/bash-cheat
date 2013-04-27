thie repo contains my bash scripts and cheats.

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

#why not to use bash!

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
