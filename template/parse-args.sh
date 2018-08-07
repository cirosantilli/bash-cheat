#!/usr/bin/env bash

# Very small argparse implementation.
#
# Does not deal with multiple concatenated short options :-(
# Therefore, double options don't need double slash:
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#
# Tests:
#
#     ./parse-args.sh -f -v asdf qwer zxcv
#     ./parse-args.sh -f -v asdf -- qwer zxcv
#     ./parse-args.sh -f -- -v asdf qwer zxcv
#     ./parse-args.sh -- -v asdf qwer zxcv
#     ./parse-args.sh -f -v

set -eu
i=1
flag=false
var=
while [ $i -le $# ]; do
  arg="$1"
  case "$arg" in
    -f|-flag)
      flag=true
    ;;
    -v|-var)
      shift
      var="$1"
    ;;
    --)
      shift
      break
    ;;
    -*)
      printf 'Uknown option.'
      exit 1
    ;;
    *)
      break
    ;;
  esac
  shift
done
printf "flag = ${flag}\n"
printf "var = ${var}\n"
echo "positional = " "$@"
