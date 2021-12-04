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

import
  slurp
  assert_tbl
  assert_num
  assert_str
  assert_bln
  assert_usr
  assert_fun
  from require"lib/aoc"


-- Strip trailng newlines and surrounding whitespace
_G.string.chomp = =>
  @ = @\match "^%s*(.-)%s*$"
  @ = @\gsub "\n$", ""
  return @


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
    if bool then return "found"
    return "missing"

  have_command = (command) ->
    _,_,exit = execute("command -v '#{command}'")
    status = __found_or_missing (exit == 0)
    print "[Init] Checking for #{command} (#{status})"
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
  new: (_day, _part, _file, _func, _source_file) =>
    assert_num _day, "day must be a number (Got: #{_day})"
    assert_fun _func, "func must be a function (Got: #{_func})"
    assert_num _part, "part must be a number (Got: #{_part})"

    if _file
      assert lfs.attributes"input/#{_file}",
        "input/#{_file} does not exist, provide it or set 'file' to nil"

    if _source_file
      assert_str _source_file, "sourcefile must be a string (Got: #{_source_file})"

    make_part _day, _part
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
        print "\nDay #{day}, part #{part}:"
        for alt, _ in ipairs answers[day][part]
          a = answers[day][part][alt]
          filet = "moonscript"
          if source_to_lang(a.source) != "Moonscript"
            filet = "#{a.source}"

          out, err, exit = nil, nil, nil
          ok, msg = pcall ->
            out, err, exit = a\get!
          if not ok
            print "(Sln ##{alt}/#{filet})> Caught error!"
            print "#{msg}" if type(msg) == 'string'
            continue

          if type(out == 'string') and  string.len(out) == 0
            out = nil

          if not err
            print "(Sln ##{alt}/#{filet})> #{out}"
            continue

          -- External program output
          print "(Sln ##{alt}/#{filet})> #{out or "empty"}"
          if err != "" and err != nil
            print "\t#{err}"


get_supported_languages!
init = '[Init]'
for f in lfs.dir"days"
  continue if f == "." or f == ".."
  continue unless f\match("day%d+.*$")

  lang = source_to_lang(f)
  continue unless lang == "Moonscript" or supported lang

  switch lang
    when "Moonscript"
      print "#{init} Importing #{f}"
      name = f\gsub("%.moon$","")
      require"days/#{name}"

    -- get the part we're working with from the filename of other scripts
    -- and programs since we can't just load them in individually as with
    -- Moonscript or Lua
    when "Shell"
      d, p, _ = f\match("day(%d+)part(%d+)n?%d-.sh$")
      continue unless d and p

      print "#{init} Creating runner for #{f}"
      sln = Solution tonumber(d), tonumber(p), nil,
        => execute"sh 'days/#{f}'"
      sln.source = f


    when "Python"
      d, p, _ = f\match("day(%d+)part(%d+)n?%d-.py$")
      continue unless d and p

      print "#{init} Creating runner for #{f}"
      sln = Solution tonumber(d), tonumber(p), nil,
        => execute"python3 'days/#{f}'"
      sln.source = f


    when "Wren"
      d, p, _ = f\match("day(%d+)part(%d+)n?%d-.wren$")
      continue unless d and p

      print "#{init} Creating runner for #{f}"
      sln = Solution tonumber(d), tonumber(p), nil,
        => execute"wrenc 'days/#{f}'"
      sln.source = f


    when "C","C++"
      d, p, _ = f\match("day(%d+)part(%d+)n?%d-%.c$")
      continue unless d and p

      if not lfs.attributes"build"
        assert lfs.mkdir"build", "failed to make build"

      print "[Init] Compiling #{f} ..."
      _, err, exit = execute"cc -o 'build/#{f}'.out 'days/#{f}'"

      if exit > 0
        -- If we failed to compile, then we don't actually want to exec
        -- later, so we just return the compilation error, the code and
        -- "Failed to compile". Everything else is handled normally
        print "[Init]   Failed to compile (exit: #{exit})"
        sln = Solution tonumber(d), tonumber(p), nil,
          => return "Failed to compile", "\n#{err}", exit
        sln.source = f
        continue

      -- Otherwise, we queue up a Solution that runs the file. Execution
      -- is handled as normal from there on.
      print "#{init}   Success, creating runner for #{f}"
      sln = Solution tonumber(d), tonumber(p), nil,
        => execute"'build/#{f}'.out"
      sln.source = f


Solution.GetAll!