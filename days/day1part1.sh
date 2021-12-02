#!/bin/sh
#
#
#

file=input/day1_depths.input

if ! test -f "$file"
then
  echo "Can't find ${file}"
  exit 1
fi

last=0
SLOW=0

if test "$SLOW" = 1
  then count=-1
  else count=''
fi

while read -r depth
do
  test "$depth" -gt "$last" && {
    if test "$SLOW" = 1
      then count="$(expr "$count" + 1)"
      else count="${count}".
    fi
  }

  last="$depth"
done <"$file"

# Lack of quotes are significant. This breaks if unquoted due to how wc 
# formats its results
if test "$SLOW" = 1
  then echo "$count"
  else echo $(expr $(echo $count | grep -o '\.' | wc -l) - 1 )
fi