Solution = Solution or -> "Dont run this directly"

import
  open
  from io

Solution 1, "day1_depths.input", [[
  ...
  The first order of business is to figure out how quickly the depth increases,
  just so you know what you're dealing with - you never know if the keys will
    get carried into deeper water by an ocean current or a fish or something.

  To do this, count the number of times a depth measurement increases from the
  previous measurement. (There is no measurement before the first measurement.)
  In the example above, the changes are as follows:
]], =>
  count = -1
  last  = 0
  doc   = nil

  with f = assert open(@file, "r"), "Failed to open input file #{@file}!"
    doc = \read("*a")
    assert \close!, "Failed to close #{@file}!"

  for l in string.gmatch(doc, "%d+")
    ok, number = pcall -> tonumber(l)
    continue if not ok
    
    count +=1 if number > last
    last = number

  count

Solution 1, "day1_depths.input", [[
  Your goal now is to count the number of times the sum of
  measurements in this sliding window increases from the
  previous sum. So, compare A with B, then compare B with C,
  then C with D, and so on. Stop when there aren't enough
  measurements left to create a new three-measurement sum.

  Example:
    199  A      
    200  A B    
    208  A B C  
    210    B C D
    200  E   C D
    207  E F   D
    240  E F G  
    269    F G H
    260      G H
    263        H
  
    A: 607 (N/A - no previous sum)
    B: 618 (increased)
    C: 618 (no change)
    D: 617 (decreased)
    E: 647 (increased)
    F: 716 (increased)
    G: 769 (increased)
    H: 792 (increased)
]], =>
  a,b,c = nil,nil,nil
  load_number = (n) ->
    ok, n = pcall( -> tonumber n)
    return nil unless ok
    a,b,c = b,c,n
    true
  
  last,count,doc = 0,-1,doc

  with f = assert open(@file, "r"), "Failed to open input file #{@file}!"
    doc = \read("*a")
    assert \close!, "Failed to close #{@file}!"

  for l in string.gmatch(doc, "%d+")
    continue unless load_number(l)
    continue unless a and b and c
    with door = (a + b + c)
      count += 1 if door > last
      last = door

  count