#!/usr/bin/env wrenc
// 
// adventofcode.wren:
//  Implements a simple class that makes Question/Answer
//  definitions even easier. Sources all day*.wren files
//  in the local days directory, and expects input files
//  to be in the local input directory.
//

class Solution {
  construct new(day,file,prob,func) {
    if (!day is Number) Fiber.abort("day must be a Number (Got: %(day))")
    if (!file is String) Fiber.abort("file must be a String (Got: %(file))")
    if (!prob is String) Fiber.abort("prob must be a String (Got: %(prob))")
    if (!func is Number) Fiber.abort("func must be an Fn (Got: %(func))")

    if (!__answers is List) __answers = {}
    if (!__answers[day] is List) __answers[day] = {}
    

  }

  static GetAll {
    
  }
}