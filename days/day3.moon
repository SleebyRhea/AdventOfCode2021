Solution = Solution or ->
  print"Dont run this directly"
  os.exit 1

import
  open
  from io

part1_problem = [[
  Each bit in the gamma rate can be determined by finding
  the most common bit in the corresponding position of all numbers in the
  diagnostic report. Example:

    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010

  Considering only the first bit of each number, there are five 0 bits and
  seven 1 bits. Since the most common bit is 1, the first bit of the gamma
  rate is 1.

  The most common second bit of the numbers in the diagnostic report is 0,
  so the second bit of the gamma rate is 0.

  The most common value of the third, fourth, and fifth bits are 1, 1, and
  0, respectively, and so the final three bits of the gamma rate are 110.

  So, the gamma rate is the binary number 10110, or 22 in decimal.

  The epsilon rate is calculated in a similar way; rather than use the most
  common bit, the least common bit from each position is used. So, the
  epsilon rate is 01001, or 9 in decimal. Multiplying the gamma rate (22)
  by the epsilon rate (9) produces the power consumption, 198.

  Use the binary numbers in your diagnostic report to calculate the gamma
  rate and epsilon rate, then multiply them together. What is the power
  consumption of the submarine? (Be sure to represent your answer in decimal,
  not binary.)
]]

part2_problem = [[
  Next, you should verify the life support rating, which can be determined
  by multiplying the oxygen generator rating by the CO2 scrubber rating.

  Both the oxygen generator rating and the CO2 scrubber rating are values
  that can be found in your diagnostic report - finding them is the tricky
  part. Both values are located using a similar process that involves
  filtering out values until only one remains. Before searching for either
  rating value, start with the full list of binary numbers from your
  diagnostic report and consider just the first bit of those numbers.
  Then:

  Keep only numbers selected by the bit criteria for the type of rating
  value for which you are searching. Discard numbers which do not match
  the bit criteria.

  If you only have one number left, stop; this is the rating value for
  which you are searching. Otherwise, repeat the process, considering the
  next bit to the right.

  The bit criteria depends on which type of rating value you want to find:

  Oxygen:
    To find oxygen generator rating, determine the most common value
    (0 or 1) in the current bit position, and keep only numbers with that
    bit in that position. If 0 and 1 are equally common, keep values with
    a 1 in the position being considered.
  
  Carbon
    To find CO2 scrubber rating, determine the least common value (0 or 1)
    in the current bit position, and keep only numbers with that bit in
    that position. If 0 and 1 are equally common, keep values with a 0 in
    the position being considered.
    
  Use the binary numbers in your diagnostic report to calculate the oxygen
  generator rating and CO2 scrubber rating, then multiply them together.
  What is the life support rating of the submarine? (Be sure to represent
  your answer in decimal, not binary.)
]]

debug = (want) -> require"moon".p want

-- Return the contents of our file, and make sure the handle is closed
slurp = (f) ->
  tmp = nil
  with assert open(f, "r"), "Failed to open input file #{f}!"
    tmp = \read("*a")
    assert \close!, "Failed to close #{f}!"
  return tmp

-- Power of 2 based conversion of a bitfield string into a decimal number 
--  Add the power of "2 to the iter" for each bit in a bitfield
binary_to_number = (binary) ->
  assert (type(binary) == "string"), "binary_to_number expects a string"
  number = 0
  len    = #binary
  with r = binary\reverse!
    i = 0
    for b in r\gmatch"."
      if b == "1" then number += math.pow(2, i) 
      i += 1
  return tonumber(number)

-- Anonymous function to run a function on a table. This is useful
-- for filtration, and is pretty much just sugar for a for/do loop
filter = (bindata,func) ->
  for _, binary in ipairs bindata
    func(binary)

  
-- Solution 3/1
--  Determine the Gamma and Epsilon values given binary inputs and 
--  calculate the power rating from those value by multiplying them
--  together once acquired. 
Solution 3, 1, "day3.input", part1_problem, =>
  gamma, espilon = 0, 0
  l_one_unpack = {}
  data = slurp @file
  
  -- Restructure the binary inputs such that they are converted as follows:
  --
  -- From:
  --   1 1 1 0 
  --   1 0 0 0
  --   1 0 0 0 
  --   1 1 1 0
  --
  -- To:
  --
  --   1 1 1 1
  --   1 0 0 1
  --   1 0 0 1
  --   0 0 0 0
  -- 
  -- This makes it easier to operate on later, as we only need a single loop
  -- for Gamma and Epsilon
  for binary in string.gmatch(data, "[0-1]+")
    i = 1
    for bit in binary\gmatch"."
      l_one_unpack[i] = {} if not l_one_unpack[i]
      table.insert l_one_unpack[i],tonumber(bit)
      i += 1
      
  -- Pack our tables into strings, based on whether or not 1s or 0s are
  -- are more common. If zeros were more common than ones, add a 0 to gamma
  -- and a 1 to epsilon. Else, the opposite.
  gamma_string = ""
  epsilon_string = ""
  for _, binary in ipairs l_one_unpack
    zero = 0
    one  = 1
    for _, bit in ipairs binary
      switch bit
        when 0
          zero += 1
        when 1
          one += 1
    
    if zero > one
      gamma_string = "#{gamma_string}0"
      epsilon_string = "#{epsilon_string}1"
    else
      gamma_string = "#{gamma_string}1"
      epsilon_string = "#{epsilon_string}0"

  -- Convert those strings into decimal
  gamma   = binary_to_number gamma_string
  epsilon = binary_to_number epsilon_string

  -- Multiply
  return epsilon * gamma


-- Solution 3/2 
--  Filter Oxygen and Carbon values and calcalute the life support rating
--  using the Diagnostic data from part 1
Solution 3, 2, "day3.input", part2_problem, =>
  data     = slurp @file

  -- Final resting place for our data
  original_data = {}
  oxygen_filter = {}
  carbon_filter = {}
  o_rating = 0
  c_rating = 0

  -- Dump binary data into a table that we can run filters on
  for binary in data\gmatch("[0-1]+")
    table.insert original_data, binary

  do 
    oxy_iter = 1
    co2_iter = 1
    owant = nil 
    cwant = nil
    ones  = 0
    zeros = 0

    -- First, get our desired oxygen and carbon inputs
    filter original_data, (binary) ->
      first = binary\match"."
      switch first
        when "1"
          ones += 1
        when "0"
          zeros += 1

      -- If we have more ones than zeros, then oxygen wants ones, and carbon
      -- wants zeros. Else, the opposite is true. If they are equal, leave
      -- this alone, as there is no difference.
      if ones > zeros
        owant = "1"
        cwant = "0"
      else
        owant = "0"
        cwant = "1"
    
    -- Runs the given filter on our original data. This extracts the different
    -- binary values into their appropriate filter table based on the owant
    -- and cwant variables declared above.
    filter original_data, (binary) ->
      first = binary\match"."
      switch first
        when owant
          table.insert oxygen_filter, binary
        when cwant
          table.insert carbon_filter, binary

    -- While loop that will operate until there is only one value left in
    -- oxygen_filter. This works as we will be overloading this later with
    -- a new table, that is checked at runtime.
    while #oxygen_filter > 1
      filtered_oxy_want  = nil
      filtered_oxy_ones  = 0
      filtered_oxy_zeros = 0

      new_oxy_filter = {}
      oxy_iter += 1

      -- Runs a filter that operates on a **single** bit, received from
      -- the position in the string "oxy_iter". This makes use of the
      -- match functions ability to start filtering a given value. Here,
      -- the value given is w/e number is saved in oxy_iter.
      filter oxygen_filter, (binary) ->
        bit = binary\match(".",oxy_iter)
        switch bit
          when "1"
            filtered_oxy_ones += 1
          when "0"
            filtered_oxy_zeros += 1
        
        -- Oxy wants the most common bit in a given bit field, so we set
        -- our wants here. We provide an elseif condition to assert that
        -- we end up with "1" as the winner in a tie.
        if filtered_oxy_ones > filtered_oxy_zeros
          filtered_oxy_want = "1"
        elseif filtered_oxy_ones == filtered_oxy_zeros
          filtered_oxy_want = "1"
        else
          filtered_oxy_want = "0"

      -- Run a filter on oxygen_filter looking for values in the "oxy_iter"
      -- field that match the desired bit (1 or 0)
      filter oxygen_filter, (binary) ->
        bit = binary\match("(.)", oxy_iter)
        if bit == filtered_oxy_want
          table.insert new_oxy_filter, binary

      oxygen_filter = new_oxy_filter

    
    -- Concepts repeat here, however the desired values are simple the
    -- opposite of Oxygens.
    while #carbon_filter > 1
      filtered_co2_want  = nil
      filtered_co2_ones  = 0
      filtered_co2_zeros = 0

      new_co2_filter = {}
      co2_iter += 1

      filter carbon_filter, (binary) ->
        bit = binary\match(".",co2_iter)
        switch bit
          when "1"
            filtered_co2_ones += 1
          when "0"
            filtered_co2_zeros += 1
        
        if filtered_co2_ones < filtered_co2_zeros
          filtered_co2_want = "1"
        elseif filtered_co2_ones == filtered_co2_zeros
          filtered_co2_want = "0"
        else
          filtered_co2_want = "0"

      filter carbon_filter, (binary) ->
        bit = binary\match("(.)", co2_iter)
        if bit == filtered_co2_want
          table.insert new_co2_filter, binary

      carbon_filter = new_co2_filter
    -- Convert our only table value ([1]) into a decimal number
    o_rating = binary_to_number oxygen_filter[1]
    c_rating = binary_to_number carbon_filter[1]

  -- Return the multiplied value of those ratings
  return o_rating * c_rating
