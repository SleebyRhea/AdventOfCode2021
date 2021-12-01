ok, _ = pcall ->
  require"lfs"
  require"ansicolors"

if not ok
  print "Please install the following dependencies (or add them to LUA_PATH):"
  for d in *{"luafilesystem", "ansicolors"}
    print"luarocks install #{d}"

lfs  = require"lfs"
ansi = require"ansicolors"

assert_tbl = (t, err) -> t if assert (type(t) == 'table'), err
assert_num = (n, err) -> n if assert (type(n) == 'number'), err
assert_str = (s, err) -> s if assert (type(s) == 'string'), err
assert_bln = (b, err) -> b if assert (type(b) == 'boolean'), err
assert_usr = (u, err) -> u if assert (type(u) == 'userdata'), err
assert_fun = (f, err) -> f if assert (type(f) == 'function'), err

class Answer
  answers = nil
  new: (_day, _file, _problem, _func) =>
    assert_num _day, "day must be a number (Got: #{_day})"
    assert_str _file, "file must be a string (Got: #{_file}"
    assert_str _problem, "problem must be a string (Got: #{_problem})"
    assert_fun _func, "func must be a function (Got: #{_func})"
    assert lfs.attributes"input/#{_file}",
      "input/#{_file} does not exist, please provide it"    

    @problem, @file, @func = _problem, "input/#{_file}", _func
    answers = {} if answers == nil
    answers[_day] = {} unless type(answers[_day]) == 'table'
    table.insert answers[_day], self

  @GetAll: ->
    for day, _ in ipairs answers
      for part, _ in ipairs answers[day]
        with a = answers[day][part]
          print ansi "%{yellow}Day #{day}, part #{part}:%{reset}%{white}"
          print ansi ">%{reset} %{bright green underline}#{a\get!}%{reset}"
    
  get: => @func!
{ :Answer }