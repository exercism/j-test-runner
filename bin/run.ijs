require'convert/json general/unittest'

NB. TODO task_ID handling for concept exercises

NB. `file_config`:
NB. make the solution path absolute
NB. override ignore flags
NB. append the code who will collect the test information during execution 
file_config=: monad define
  tp=. '[a-zA-Z0-9[-]*]*[.]ijs'&(jcwdpath rxapply)
  ti=. '_ignore ?=: ?[1-9]*'&(('\d+' ; '0')&rxrplc rxapply)
  info=. ,&{{)n
before_each=: monad define
  eo__=: eo__ ,<y
)
after_each=: monad define
  (y,'_Description__')=: Description
  (y,'_Code__')=: ('(Description=:.+\n|Task=:.+\n)';'') rxrplc 5!:5 <'test_', y
  NB. (y,'_Task__')=: (Task"_ :: 1) y
  NB. erase 'Description Task'
)
}}

  info@ti@tp y
)

NB. each line starting with `|` is aditional information for test result above
NB. The result is a list of boxes where # y equals the number of tests
format_results=:{{
  -.&a: (#fo) {. (<;.1~ '|' ~: {.@>) -.&a: }. <;._2 y
}}

NB. TODO: find a simplified way obtain the test order
test_sort=:{{
  y /: u i."_ 0 v
}}


report=: {{
  td=. 0 {:: ;:@:>@:{. y
  tn=. (td,'_Description')~ "_
  tc=. (td,'_Code')~ "_
  NB. tt=. (td,'_Task')~ "_
  tfm=.  dtb@:(LF&joinstring@:}:@}.)
  tem=.  dtb@:(LF&joinstring@:}:)
  success=. (;:'status name test_code') ,: 'pass' ; tn ; tc
  failure=. (;:'status name message test_code') ,: 'fail' ; tn ; tfm ; tc
  error  =. (;:'status message') ,: 'error' ; tem
  
  (failure`error@.(('Suite Error:';'Test Error:')e.~{.))`success@.(1=#) y
}}

status=: 'fail'"_`{.@.(1=#)@~.@:(1 0&{:: S: 1)


main=: monad define
  'slug indir outdir'=. _3{.ARGV                                                       
  indir =. jpathsep abspath indir
  outdir=. jpathsep abspath outdir
  write_output=. (< outdir,'/results.json') 1!:2~ enc_json@:|: 
  temp_path=. jpath '~temp/test.ijs'
  version=. < 3

  1!:44 indir
  tests=. freads 'test.ijs'  
  
  NB. `eo` and 'fo' are used to control the execution order of the tests
  eo=: ''
  fo=: 5&}.each ('test_.*_test_\d+') rxall tests
  
  
  (<temp_path) 1!:2~ file_config tests
  results=. format_results unittest temp_path   NB. run the test and group the results
  results=. report each results
  
  if. 'error' -: s=. status results do. 
    output=. (;:'version status message') ,. version , (0;1) {:: results
    write_output output
    exit 1
  else.
    output=. (;:'version status tests') ,. version , s ; < fo test_sort eo results
    write_output output
    exit 0
  end.
)

main ''
