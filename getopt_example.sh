#!/usr/bin/env bash
set -eu


# Default values.
debug=false
force=false
noshort=false
out_path=-
verbose=false

# Handle CLI arguments.
parsed=$(getopt -o d,f,,o:,v -l debug,force,noshort,output:,verbose -- "$@")
eval set -- "$parsed"
while true; do
  case "$1" in
    -d|--debug)
      debug=true
      shift
      ;;
    -f|--force)
      force=true
      shift
      ;;
    --noshort)
      noshort=true
      shift
      ;;
    -o|--output)
      out_path="$2"
      shift 2
      ;;
    -v|--verbose)
      verbose=true
      shift
      ;;
    --)
      shift
      break
      ;;
  esac
done
if [ $# -gt 0 ]; then
  in_path="$1"
  shift
else
  in_path=-
fi

# Action.
printf "\
verbose: ${verbose}
force: ${force}
debug: ${debug}
in_path: ${in_path}
noshort: ${noshort}
out_path: ${out_path}
positional: $@
"
