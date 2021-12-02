Solution = Solution or ->
  print"Dont run this directly"
  os.exit 1

import
  open
  from io

[[

  Ill clean this up in the morning. Its midnight and Im fucking tired.


]]




Solution 2, "day2_paths.input", [[ None ]], =>
  count,last,doc = -1,0,nil

  with assert open(@file, "r"), "Failed to open input file #{@file}!"
    doc = \read("*a")
    assert \close!, "Failed to close #{@file}!"


  x, y = 0, 0

  iter = (word, digit) ->
    assert (type(word) == 'string'), "Not a string"
    assert (type(digit) == 'number'), "Not a number (#{digit})"

    switch word
      when 'forward'
        x += digit
      when 'back' --just going to assume thats a thing in p2
        x -= digit
      when 'up'
        y -= digit
      when 'down'
        y += digit

  for word, digit in string.gmatch(doc, "(%w+)%s+(%d+)")
    ok, n = pcall -> tonumber(digit)
    continue if not ok or not word or not digit
    iter word, n
  
  return x * y


Solution 2, "day2_paths.input", [[ None ]], =>
  count,last,doc = -1,0,nil

  with assert open(@file, "r"), "Failed to open input file #{@file}!"
    doc = \read("*a")
    assert \close!, "Failed to close #{@file}!"


  x, y, z = 0, 0, 0

  iter = (word, digit) ->
    assert (type(word) == 'string'), "Not a string"
    assert (type(digit) == 'number'), "Not a number (#{digit})"

    switch word
      when 'forward'
        x += digit
        y += z * digit
      when 'back' --just going to assume thats a thing in p2
        x -= digit
      when 'up'
        z -= digit
      when 'down'
        z += digit

  for word, digit in string.gmatch(doc, "(%w+)%s+(%d+)")
    ok, n = pcall -> tonumber(digit)
    continue if not ok or not word or not digit
    iter word, n
  
  return x * y