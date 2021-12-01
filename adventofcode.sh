#!/bin/sh
#
# adventofcode.sh:
#   Implements a simple structure for answering AdventOfCode
#   problems in Shell
#

Main()
{
  if ! test -d days || test -d input
  then
    echo "Run this from a location with a 'days' directory, and an 'input' directory" >&2
    exit 1
  fi
}

files=''

for cmd in find sed
do
  command -v "$cmd" >&/dev/null \
    && . "$cmd"
done

Main