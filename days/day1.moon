Solution = Solution or ->
  print"Dont run this directly"
  os.exit 1

import
  open
  from io

part1_problem = [[
  The first order of business is to figure out how quickly the depth
  increases, just so you know what you're dealing with - you never know if
  the keys will get carried into deeper water by an ocean current or a fish
   or something.

  To do this, count the number of times a depth measurement increases from
  the previous measurement. (There is no measurement before the first
  measurement.)
  
  In the example above, the changes are as follows:
    199 (N/A - no previous measurement)
    200 (increased)
    208 (increased)
    210 (increased)
    200 (decreased)
    207 (increased)
    240 (increased)
    269 (increased)
    260 (decreased)
    263 (increased)
]]

part2_problem = [[
  Your goal now is to count the number of times the sum of measurements in
  this sliding window increases from the previous sum. So, compare A with
  B, then compare B with C, then C with D, and so on. Stop when there
  aren't enough measurements left to create a new three-measurement sum.

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
]]

-- Return the contents of our file, and make sure the handle is closed
slurp = (f) ->
  tmp = nil
  with assert open(f, "r"), "Failed to open input file #{f}!"
    tmp = \read("*a")
    assert \close!, "Failed to close #{f}!"
  return tmp

  
-- Simply, count the number of times that the previous depth was lower
-- than the current depth.
Solution 1, 1, "day1_depths.input", part1_problem, =>
  with depths = slurp @file
    -- Init count to -1 for to minimize conditionals. last for clarity.
    count, last = -1, 0

    for l in depths\gmatch "%d+"
      ok, number = pcall -> tonumber(l) -- Type assertion catch
      continue if not ok

      count +=1 if number > last
      last = number
    return count


-- Emulate a stack for the sliding door algorithm, and rotate variables
--  a, b, and c. Sum every loop and return the number of times those sums
--  were greater than the previous sum.
Solution 1, 2, "day1_depths.input", part2_problem, =>
  -- Our sliding door. a, b, c are the "stack" and the function load_number
  --  rotates those variables on call.
  a,b,c = nil,nil,nil
  load_number = (n) ->
    ok, n = pcall -> tonumber n
    return nil unless ok
    a,b,c = b,c,n
    return true
  
  count, last, count = -1, 0
  with depths = slurp @file
    for l in string.gmatch(depths, "%d+")
      continue unless load_number(l)
      continue unless a and b and c
      with door = (a + b + c)
        count += 1 if door > last
        last = door

  return count