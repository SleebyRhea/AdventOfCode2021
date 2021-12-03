-- Type assertions
assert_tbl = (t, err) -> t if assert (type(t) == 'table'), err
assert_num = (n, err) -> n if assert (type(n) == 'number'), err
assert_str = (s, err) -> s if assert (type(s) == 'string'), err
assert_bln = (b, err) -> b if assert (type(b) == 'boolean'), err
assert_usr = (u, err) -> u if assert (type(u) == 'userdata'), err
assert_fun = (f, err) -> f if assert (type(f) == 'function'), err


  
{
  :assert_tbl
  :assert_num
  :assert_str
  :assert_bln
  :assert_usr
  :assert_fun
}