#!/bin/bash

set -u # error on undefined variable
set -e # stop execution if one command goes wrong

F="$(basename "$0")"
echo "converts pdf to a bunch of text using tesseract

USAGE

    $F document.pdf orientation split left top right bottom lang

    - orientation is one of 0,1,2,3, meaning the amount of rotation by 90°
    - split is either 0 (already single-paged) or 1 (2 book-pages per pdf-page)
    - (left top right bottom) are the coordinates to crop (after rotation!)
    - lang is a language as in "tesseract -l"

INSTALL UBUNTU

    sudo aptitude install imagemagick ghostscript pdftk exactimage

EXAMPLES

    $F a.pdf 0 0 0 0 0 0 eng

AUTHORS

   Konrad Voelkel <http://blog.konradvoelkel.de/2010/01/linux-ocr-and-pdf-problem-solved/>

      the *major* merit comes from that website writer, not me, I just hacked a little!!

   Ciro Duran Santilli
" 1>&2

pdftk "$1" burst dont_ask
out=${1%.*}.txt
pg=1
echo "" > "$out"
for f in pg_*.pdf
do
  echo -e "\nprocessing page $pg\n"
  f=${f%.*} #noext
  convert -quiet -rotate $[90*$2] -monochrome -normalize -density 300 "$f.pdf" "$f.png"
  convert -quiet -crop $6x$7+$4+$5 "$f.png" "$f.png"
  if [ "1" = "$3" ];
  then
    convert -quiet -crop $[$6/2]x$7+0+0 "$f.png" "$f.1.png"
    convert -quiet -crop 0x$7+$[$6/2]+0 "$f.png" "$f.2.png"
    rm -f "$f.png"
  else
    echo no splitting
  fi
  rm -f "$f.pdf"

  tesseract -l $8 "$f.png" "$f"
  #cuneiform -l $8 -f text -o "$f.txt" "$f.png"

  rm -f "$f.png"
  cat "$f.txt" >> "$out"
  echo -e "#pg$pg\n------------------------------------------------------------\n" >> "$out"
  pg=$(( $pg + 1 ))
  rm "$f.txt"
done

#remove excessive whitespace
perl -0777 -pi -e 's/\s+\n\s+\n+\s+/\n\n/g' "$out" #transform more than two consecutive newlines into two newlines
perl -lapi -e 's/\s+/ /g' "$out" #transform more than one consecutive non newlines whitespaces into one single space
