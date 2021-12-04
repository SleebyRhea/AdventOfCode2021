Solution = Solution or ->
  print"Dont run this directly"
  os.exit 1

import
  open
  from io

[[
  Day 2 Part 1
  ============

  Your horizontal position and depth both start at 0. The steps above would
  then modify them as follows:

    forward 5 adds 5 to your horizontal position, a total of 5.
    down 5 adds 5 to your depth, resulting in a value of 5.
    forward 8 adds 8 to your horizontal position, a total of 13.
    up 3 decreases your depth by 3, resulting in a value of 2.
    down 8 adds 8 to your depth, resulting in a value of 10.
    forward 2 adds 2 to your horizontal position, a total of 15.

  After following these instructions, you would have a horizontal position
  of 15 and a depth of 10. (Multiplying these together produces 150.)

  Calculate the horizontal position and depth you would have after following
   the planned course. What do you get if you multiply your final horizontal
     position by your final depth? ]]

[[
  Day 2 Part 2
  ============

  In addition to horizontal position and depth, you'll also need to track a
  third value, aim, which also starts at 0. The commands also mean something
   entirely different than you first thought:

    down X increases your aim by X units.
    up X decreases your aim by X units.
    forward X does two things:
    It increases your horizontal position by X units.
    It increases your depth by your aim multiplied by X.

  Again note that since you're on a submarine, down and up do the opposite
  of what you might expect: "down" means aiming in the positive direction.

  Now, the above example does something different:
    forward 5 adds 5 to your horizontal position, a total of 5.
    Because your aim is 0, your depth does not change.
    down 5 adds 5 to your aim, resulting in a value of 5.
    forward 8 adds 8 to your horizontal position, a total of 13.
    Because your aim is 5, your depth increases by 8*5=40.
    up 3 decreases your aim by 3, resulting in a value of 2.
    down 8 adds 8 to your aim, resulting in a value of 10.
    forward 2 adds 2 to your horizontal position, a total of 15.
    Because your aim is 10, your depth increases by 2*10=20 to a total of 60.

  Using this new interpretation of the commands, calculate the horizontal 
  osition and depth you would have after following the planned course. What
  do you get if you multiply your final horizontal position by your final
  depth?
]]

Solution 2, 1, "day2.input", =>
  doc = nil
  with assert open(@file, "r"), "Failed to open input file #{@file}!"
    doc = \read("*a")
    assert \close!, "Failed to close #{@file}!"

  x, y = 0, 0

  increment = (word, digit) ->
    assert (type(word) == 'string'), "Not a string"
    assert (type(digit) == 'number'), "Not a number (#{digit})"

    switch word
      when 'forward'
        x += digit
      when 'up'
        y -= digit
      when 'down'
        y += digit

  for word, digit in string.gmatch(doc, "(%w+)%s+(%d+)")
    ok, n = pcall -> tonumber(digit)
    continue if not ok or not word or not digit
    increment word, n
  
  return x * y


Solution 2, 2, "day2.input", =>
  doc = nil

  with assert open(@file, "r"), "Failed to open input file #{@file}!"
    doc = \read("*a")
    assert \close!, "Failed to close #{@file}!"

  x, y, z = 0, 0, 0

  increment = (word, digit) ->
    assert (type(word) == 'string'), "Not a string"
    assert (type(digit) == 'number'), "Not a number (#{digit})"

    switch word
      when 'forward'
        x += digit
        y += z * digit
      when 'up'
        z -= digit
      when 'down'
        z += digit

  for word, digit in string.gmatch(doc, "(%w+)%s+(%d+)")
    ok, n = pcall -> tonumber(digit)
    continue if not ok or not word or not digit
    increment word, n
  
  return x * y
