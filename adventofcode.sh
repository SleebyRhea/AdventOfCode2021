#!/bin/sh
#
# adventofcode.sh:
#   Implements a simple structure for answering AdventOfCode
#   problems in Shell
#

if ! test -f "$FILE"
then
  echo "Can't find ${FILE}, please place it in input/"
  exit 1
fi

is_number()
{
  case $n in
    (''|*[!0-9]*) return 1 ;;
  esac

  return 0
}