#!/usr/bin/env bash

# No default value:

yn=""
msg="do something? (y/n): "
while true; do
  read -p "$msg" yn
  case "$yn" in
    n|y ) break;;
    * ) echo "Invalid choice.";;
  esac
done
echo "You chose: $yn"

# Default value for empty input:

yn=""
msg="do something? ([y]/n): "
while true; do
  read -p "$msg" yn
  case "$yn" in
    n|y ) break;;
    "" ) yn=y; break;;
    * ) echo "Invalid choice.";;
  esac
done
echo "You chose: $yn"

exit 0
