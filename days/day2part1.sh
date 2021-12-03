#!/bin/sh
FILE=input/day2_paths.input
. ./adventofcode.sh

if test "$SKIPSLOWRUNS" = 1
then
  echo 'Skipped ($SKIPSLOWRUNS=1)'
  exit 0
fi

Main()
{ x=0 ; y=0 ; final=0
  while read -r d n
  do is_number "$n" || continue
    case $d in
           (up) y=$(expr $y - $n) ;;
         (down) y=$(expr $y + $n) ;;
      (forward) x=$(expr $x + $n) ;;
    esac

  done <"$FILE"
  echo "$(expr $x '*' $y)"
}

Main "$@"