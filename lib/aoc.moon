-- Type assertions
assert_tbl = (t, err) -> t if assert (type(t) == 'table'), err
assert_num = (n, err) -> n if assert (type(n) == 'number'), err
assert_str = (s, err) -> s if assert (type(s) == 'string'), err
assert_bln = (b, err) -> b if assert (type(b) == 'boolean'), err
assert_usr = (u, err) -> u if assert (type(u) == 'userdata'), err
assert_fun = (f, err) -> f if assert (type(f) == 'function'), err

-- Print some debugging information using the moon libraries provided
--  print function. This only runs if DEBUG if provided in the env
debug = (want) ->
  if os.getenv("DEBUG")
    require"moon".p want

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


{
  :binary_to_number
  :assert_tbl
  :assert_num
  :assert_str
  :assert_bln
  :assert_usr
  :assert_fun
  :filter
  :debug
  :slurp
}