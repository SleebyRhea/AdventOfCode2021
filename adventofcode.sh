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