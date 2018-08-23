#!/usr/bin/env bash
set -eu

# CLI arguments.
parsed=$(getopt -o dfo:v -l debug,force,output:,verbose -- "$@")
echo "parsed: ${parsed}"
eval set -- "$parsed"
d=n
f=n
v=n
out_path=-
while true; do
  case "$1" in
    -d|--debug)
      d=y
      shift
      ;;
    -f|--force)
      f=y
      shift
      ;;
    -v|--verbose)
      v=y
      shift
      ;;
    -o|--output)
      out_path="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Programming error"
      exit 3
      ;;
  esac
done
if [ $# -gt 0 ]; then
  in_path="$1"
else
  in_path=-
fi

# Action.
printf "\
verbose: ${v}
force: ${f}
debug: ${d}
in: ${in_path}
out: ${out_path}
"
