# AdventOfCode 2021

This repo simply tracks my solutions for Advent Of Code 2021. As of now my solutions are in [Moonscript](https://moonscript.org/) (local build using [luajit](https://luajit.org/)), but as time allows I'll update this repo with answers for a variety of scripted/compiled languages.

## How to use
- Clone, move into this repo, and make the input directory
  ```
  $ git clone 'https://github.com/SleepyFugu/AdventOfCode2021' && cd AdventOfCode2021 && mkdir -p input
  ```
- **adventofcode.moon** currently supports Moonscript, Shell, Python 3 and C. Simply adding files within the local **days** directory with the format `day[0-9]+part[0-9]+n?[0-9]+.ext` will suffice to have a file loaded.

### Moonscript
- Install moonscript + lua dependencies ([luarocks](https://luarocks.org/) will be the simplest way, though you may need to use `--local` depending on your local policy):
  ```
  $ luarocks install moonscript
  $ luarocks install luafilesystem
  $ luarocks install ansicolors
  ```
- Run **_adventofcode.moon_**
  ```
  $ moon adventofcode.moon
  ```

### FAQ
- Why didn't you just make a `Makefile`?
  - I don't have a good answer for you. I just didn't feel like it :)
- Why Moonscript?
  - I like Moonscript.