#!/usr/bin/env moon
--
-- adventofcode.moon
--  Implements a simple class that makes Question/Answer definitions even
--  easier. Sources all day*.moon files in the local days directory, and
--  expects input files to be in the local input directory. Additionally,
--  executes various and compiles various languages for execution with
--  pretty formatting.
--
-- TODO: Busted testing, Spookfile, etc etc

ok = pcall ->
  require"lfs"
  require"ansicolors"

if not ok
  print "Please install the following dependencies (or add them to LUA_PATH):"
  for d in *{"luafilesystem", "ansicolors"}
    print"luarocks install #{d}"

lfs  = require"lfs"
ansi = require"ansicolors"

-- Type assertions
assert_tbl = (t, err) -> t if assert (type(t) == 'table'), err
assert_num = (n, err) -> n if assert (type(n) == 'number'), err
assert_str = (s, err) -> s if assert (type(s) == 'string'), err
assert_bln = (b, err) -> b if assert (type(b) == 'boolean'), err
assert_usr = (u, err) -> u if assert (type(u) == 'userdata'), err
assert_fun = (f, err) -> f if assert (type(f) == 'function'), err


-- Strip trailng newlines and surrounding whitespace
_G.string.chomp = =>
  @ = @\match "^%s*(.-)%s*$"
  @ = @\gsub "\n$", ""
  return @


-- Return the contents of our file, and make sure the handle is closed
slurp = (f) ->
  tmp = nil
  with assert io.open(f, "r"), "Failed to open input file #{f}!"
    tmp = \read("*a")
    assert \close!, "Failed to close #{f}!"
  return tmp


-- Execute the given command and return the Stdout, Stderr, and Code of
--  said command. io.popen would have been preferred over this method,
--  however unfortunately, thats not always an option so we get around that
--  using this ugly hack.
execute = (c) ->
  outf, errf, extf = os.tmpname!, os.tmpname!, os.tmpname!
  os.execute"#{c} >'#{outf}' 2>'#{errf}'; /bin/echo $? > '#{extf}'"
  out, err, exit = slurp(outf), slurp(errf), slurp(extf)
  lfs.rmdir f for f in *{outf,errf,extf}
  return out\chomp!, err\chomp!, tonumber(exit\chomp!)


get_supported_languages = nil
source_to_lang = nil
supported = nil

do
  __found_or_missing = (bool) ->
    if bool then return "%{bright green}found%{reset}"
    return "%{bright red}missing%{reset}"

  have_command = (command) ->
    _,_,exit = execute("command -v '#{command}'")
    status = __found_or_missing (exit == 0)
    print ansi "%{yellow}[Init]%{reset} Checking for #{command} (#{status})"
    return (exit == 0)

  can_support =
    Shell: -> true
    Wren: -> have_command"wrenc"
    Python: -> have_command"python3"
    C: -> have_command"cc"

  supported_langs = {}

  languages =
    csharp: "C#"
    wren: "Wren"
    moon: "Moonscript"
    cpp: "C++"
    go: "Go"
    sh: "Shell"
    py: "Python"
    c: "C"

  supported = (lang) ->
    supported_langs[lang]

  source_to_lang = (file_name) ->
    assert_str file_name, "filename must be a string (Got: #{file_name})"
    languages[file_name\match"%.(%S-)$"] or "Unknown language"

  get_supported_languages = ->
    for lang, check in pairs can_support
      supported_langs[lang] = check!


-- Solution defines a
export class Solution
  -- Private class variables
  answers = nil

  make_part = (_day, _part) ->
    answers              = {} if answers == nil
    answers[_day]        = {} if answers[_day] == nil
    answers[_day][_part] = {} if answers[_day][_part] == nil

  -- Instance methods
  new: (_day, _part, _file, _name, _func, _source_file) =>
    assert_num _day, "day must be a number (Got: #{_day})"
    assert_str _name, "name must be a string (Got: #{_name})"
    assert_fun _func, "func must be a function (Got: #{_func})"
    assert_num _part, "part must be a number (Got: #{_part})"

    if _file
      assert lfs.attributes"input/#{_file}",
        "input/#{_file} does not exist, provide it or set 'file' to nil"

    if _source_file
      assert_str _source_file, "sourcefile must be a string (Got: #{_source_file})"

    make_part _day, _part
    @name   = _name
    @func   = _func
    @file   = (_file and "input/#{_file}" or nil)
    @source = switch type(_source_file)
                when 'string'
                  _source_file
                when 'nil'
                  '.moon'
                else
                  error "source_file must be a string or nil"

    table.insert answers[_day][_part], self

  get: => @func!

  -- Class methods
  @GetAll: ->
    if not answers
      print"No solutions defined"
      return false

    for day, _ in ipairs answers
      for part, _ in ipairs answers[day]
        print ansi "\n%{yellow}Day #{day}, part #{part}:"
        for alt, _ in ipairs answers[day][part]
          a = answers[day][part][alt]
          filet = "moonscript"
          if source_to_lang(a.source) != "Moonscript"
            filet = "#{a.source}"

          out, err, _ = a\get!
          if type(out == 'string') and  string.len(out) == 0
            out = nil

          if not err
            print ansi "(%{bright}Sln ##{alt}%{reset}/#{filet})>%{reset} %{bright green}#{out}%{reset}"
            continue

          -- External program output
          print ansi "(%{bright}Sln ##{alt}%{reset}/#{filet})>%{reset} %{bright green}#{out or "%{red}empty"}%{reset}"
          if err != "" and err != nil
            print ansi "%{bright red}\t#{err}%{reset}"


get_supported_languages!
init = '%{yellow}[Init]%{reset}'
for f in lfs.dir"days"
  continue if f == "." or f == ".."
  continue unless f\match("day%d+.*$")

  lang = source_to_lang(f)
  continue unless lang == "Moonscript" or supported lang

  switch lang
    when "Moonscript"
      print ansi "#{init} Importing #{f}"
      name = f\gsub("%.moon$","")
      require"days/#{name}"

    -- get the part we're working with from the filename of other scripts
    -- and programs since we can't just load them in individually as with
    -- Moonscript or Lua
    when "Shell"
      d, p, _ = f\match("day(%d+)part(%d+)n?%d-.sh$")
      continue unless d and p

      print ansi "#{init} Creating runner for #{f}"
      sln = Solution tonumber(d), tonumber(p), nil, "extern",
        => execute"sh 'days/#{f}'"
      sln.source = f


    when "Python"
      d, p, _ = f\match("day(%d+)part(%d+)n?%d-.py$")
      continue unless d and p

      print ansi "#{init} Creating runner for #{f}"
      sln = Solution tonumber(d), tonumber(p), nil, "extern",
        => execute"python3 'days/#{f}'"
      sln.source = f


    when "Wren"
      d, p, _ = f\match("day(%d+)part(%d+)n?%d-.wren$")
      continue unless d and p

      print ansi "#{init} Creating runner for #{f}"
      sln = Solution tonumber(d), tonumber(p), nil, "extern",
        => execute"wrenc 'days/#{f}'"
      sln.source = f


    when "C","C++"
      d, p, _ = f\match("day(%d+)part(%d+)n?%d-%.c$")
      continue unless d and p

      if not lfs.attributes"build"
        assert lfs.mkdir"build", "failed to make build"

      print ansi "%{yellow}[Init]%{reset} Compiling #{f} ..."
      _, err, exit = execute"cc -o 'build/#{f}'.out 'days/#{f}'"

      if exit > 0
        -- If we failed to compile, then we don't actually want to exec
        -- later, so we just return the compilation error, the code and
        -- "Failed to compile". Everything else is handled normally
        print ansi "%{bright red}[Init]%{reset}   Failed to compile (exit: #{exit})"
        sln = Solution tonumber(d), tonumber(p), nil, "extern",
          => return "Failed to compile", "\n#{err}", exit
        sln.source = f
        continue

      -- Otherwise, we queue up a Solution that runs the file. Execution
      -- is handled as normal from there on.
      print ansi "#{init}   Success, creating runner for #{f}"
      sln = Solution tonumber(d), tonumber(p), nil, "extern",
        => execute"'build/#{f}'.out"
      sln.source = f


Solution.GetAll!