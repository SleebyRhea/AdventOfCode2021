#!/bin/sh
FILE=input/day1.input
. ./adventofcode.sh

if test "$SKIPSLOWRUNS" = 1
then
  echo 'Skipped ($SKIPSLOWRUNS=1)'
  exit 0
fi

Main ()
{ a=0 ; b=0 ; c=0 ; count=0

  while read -r n
  do
    case $n in
      # is it not a number?
      (''|*[!0-9]*) continue ;;
    esac

    popped="$c"
    c="$b"
    b="$a"
    a="$n"

    for x in "$a" "$b" "$c" "$popped"
      do test "$x" = 0 && continue 2
    done

    old_sum="$( expr "$b" + "$c" + "$popped" )"
    new_sum="$( expr "$a" + "$b" + "$c" )"
    if test $new_sum -gt $old_sum
      then count="$( expr "$count" + 1 )"
    fi
  done <"$FILE"
  echo "$count"
}

Main "$@"