# AdventOfCode 2021

This repo simply tracks my solutions for Advent Of Code 2021. As of now my solutions are in Moonscript (local build using luajit), but as time allows I'll update this repo with answers for a variety of scripted/compiled languages.

## How to use

### ALL
- Clone, move into this repo, and make the input directory
  ```
  $ git clone 'https://github.com/SleepyFugu/AdventOfCode2021' && cd AdventOfCode2021 && mkdir -p input
  ```

### Moonscript
- Install moonscript + dependencies (may need to use --local depending on your local policy):
  ```
  $ luarocks install moonscript
  $ luarocks install luafilesystem
  $ luarocks install ansicolors
  ```
- Run `adventofcode.moon`
  ```
  $ moon adventofcode.moon
  ```
