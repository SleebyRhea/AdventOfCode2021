Solution = Solution or ->
  print"Dont run this directly"
  os.exit 1

import
  open
  from io

part1_problem = [[  ]]

debug = (want) ->
  require"moon".p want

-- Return the contents of our file, and make sure the handle is closed
slurp = (f) ->
  tmp = nil
  with assert open(f, "r"), "Failed to open input file #{f}!"
    tmp = \read("*a")
    assert \close!, "Failed to close #{f}!"
  return tmp


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
      

Solution 3, 1, "day3.input", part1_problem, =>
  gamma, espilon = 0, 0

  
  table.concat = (tbl) ->
    newstring = ""
    for v in ipairs tbl
      newstring = "#{newstring}#{v}"
    return newstring


  l_one_unpack = {}
  data = slurp @file
  for binary in string.gmatch(data, "[0-1]+")
    i = 1
    for bit in binary\gmatch"."
      l_one_unpack[i] = {} if not l_one_unpack[i]
      table.insert l_one_unpack[i],tonumber(bit)
      i += 1
      
  -- Unpack our tables into strings
  gamma_string = ""
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
    else
      gamma_string = "#{gamma_string}1"


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
    
    if zero < one
      epsilon_string = "#{epsilon_string}0"
    else
      epsilon_string = "#{epsilon_string}1"

  gamma   = binary_to_number gamma_string
  epsilon = binary_to_number epsilon_string

  return epsilon * gamma


Solution 3, 2, "day3.input", part1_problem, =>
  data     = slurp @file

  -- Anonymous function to run a function on a table. This is useful
  -- for filtration, and is pretty much just sugar for a for/do loop
  filter = (bindata,func) ->
    for _, binary in ipairs bindata
      func(binary)

  -- Final resting place for our data
  original_data = {}
  oxygen_filter = {}
  carbon_filter = {}
  o_rating = 0
  c_rating = 0

  for binary in data\gmatch("[0-1]+")
    table.insert original_data, binary

  do 
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
      if ones > zeros
        owant = "1"
        cwant = "0"
      else
        owant = "0"
        cwant = "1"
    
    filter original_data, (binary) ->
      first = binary\match"."
      switch first
        when owant
          table.insert oxygen_filter, binary
        when cwant
          table.insert carbon_filter, binary

    oxy_iter = 1
    while #oxygen_filter > 1
      filtered_oxy_want  = nil
      filtered_oxy_ones  = 0
      filtered_oxy_zeros = 0

      new_oxy_filter = {}
      oxy_iter += 1

      filter oxygen_filter, (binary) ->
        bit = binary\match(".",oxy_iter)
        switch bit
          when "1"
            filtered_oxy_ones += 1
          when "0"
            filtered_oxy_zeros += 1
        if filtered_oxy_ones > filtered_oxy_zeros
          filtered_oxy_want = "1"
        elseif filtered_oxy_ones == filtered_oxy_zeros
          filtered_oxy_want = "1"
        else
          filtered_oxy_want = "0"

      filter oxygen_filter, (binary) ->
        bit = binary\match("(.)", oxy_iter)
        if bit == filtered_oxy_want
          table.insert new_oxy_filter, binary

      oxygen_filter = new_oxy_filter


    co2_iter = 1
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

    o_rating = binary_to_number oxygen_filter[1]
    c_rating = binary_to_number carbon_filter[1]
  return o_rating * c_rating
