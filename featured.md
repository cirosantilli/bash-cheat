% Featured bash scripts
% Ciro Duran Santilli

This showcases scripts that I find:

* good enough
* original enough
* hard enough to make

that I recommend you to check out

# find-music-make-m3u
  
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
