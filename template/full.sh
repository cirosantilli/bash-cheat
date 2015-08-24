#!/usr/bin/env bash

set -u # error on undefined variable
set -e # stop execution if one command goes wrong

usage() {
  F="$(basename "$0")"
  echo "$F [OPTION]... [FILE]...

One line summary.

# Options

  -o option o

# Install on Ubuntu 12.04

		sudo aptitude install

# Examples

		$F

#Invocation
" 1>&2
}

# Check only:
for cmd in "latex" "pandoc"; do
  printf "%-10s" "$cmd"
  if hash "$cmd" 2>/dev/null; then printf "OK\n"; else printf "missing\n"; fi
done

# check suggest ubuntu pacakge if missing.
CMD=
PKG=
if -n which "$CMD" &> /dev/null; then
  echo "$CMD
not found. To install on Ubuntu: 
  sudo apt-get install $PKG
" 1>&2
  exit 1
fi

# check and suggest wget script if missing.
CMD=
URL=
if -n which "$CMD" &> /dev/null; then
  echo $CMD'
not found. To install:
  INPATH=~/bin
  OUT=$INPATH/'$CMD'
  wget -nc -O "$OUT" "'$URL'" && \
  chmod +x \"\$OUT\"
' 1>&2
fi

# Optional args
FLAG=false
IPATH="./"
OPATH="./"

while getopts hi:o: OPT; do
  case "$OPT" in
    f)
      FLAG=true
      ;;
    h)
      usage
      exit 0
      ;;
    i)
      IPATH=$OPTARG
      ;;
    o)
      OPATH=$OPTARG
      ;;
    \?)
      usage
      exit 2
      ;;
  esac
done

shift "$(($OPTIND - 1))"

# Obligatory positional args.
if [ $# -gt 0 ]; then
  ="$1"
  shift
else
  echo "too few arguments" 1>&2
  usage
  exit 2
fi

# Positional args with default.
if [ $# -gt 0 ]; then
  ="$1"
  shift
else
  =
fi

# There must be no args left.
if [ $# -gt 0 ]; then
  echo "too many arguments" 1>&2
  usage
  exit 2
fi

# There must still be args left: undefined number.
if [ $# -eq 0 ]; then
  usage
  exit 2
fi

for in "$@"; do

done

exit 0
