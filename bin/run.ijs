#! /opt/j901/bin/jconsole

require'convert/json general/unittest'

NB. todo: explore using 9!:24'' NB. security level. prevent student
NB. solutions from running certain i/o ops
success=: (;:'status name message') ,: 'pass' ; ({.,{:)@:;:@:,@:>
failure=: (;:'status name message test_code') ,: 'fail' ; ([: > [: {. [: ;: 0&{::) ; (1&{::) ; (8 }. 2&{::)
report=:  failure`success@.(1=#)
status=:  (;:'fail pass') {~ [: *./ ('pass'-:1 0&{::)S:1
version=: <3

NB. REGEX verbs to circunvent the ignore flags on tests
temp_test_path     =: < jpath '~temp/test.ijs'
repl_solution_path =: '[a-zA-Z0-9[-]*]*[.]ijs'&(jcwdpath rxapply)
repl_ignore_flag   =: '_ignore ?=: ?[1-9]*'&( ( ('[1-9]+' ; '0')&rxrplc) rxapply)


main=: monad define
  'slug indir outdir'=. _3{.ARGV NB. name args to vars and record cd
  indir=. jpathsep indir 
  outdir=. jpathsep outdir
  1!:44 indir NB. cd to indir

  (repl_ignore_flag repl_solution_path 1!:1 < indir, 'test.ijs') 1!:2 temp_test_path NB. replace ignore flags and record tests in J's temp folder

  result=. }. }: <;._2 unittest jpath '~temp/test.ijs' NB. run tests
  1!:55 temp_test_path NB. deletes temporary test file

  if. (1<#result) do.
    if. 'Suite Error:'-:1{::result do. NB. error running test suite
      'message_part err_path'=. (({.,:jpathsep@}.)~ >:@(i:&' ')) 13!:12'' NB. Get the path of the script where the error occured
      'i_path err_path'=. indir ,: err_path NB. fill indir to conform shapes
      relative_path=. (-. i_path = err_path) # err_path
      error_message=. (dltbs message_part), ' ', relative_path
      output=. enc_json |: (version, 'error' ; error_message) ,.~ ;:'version status message'
      output 1!:2 < outdir,'/results.json'
      exit 1
    end.
  end. NB. else report pass/fail

  'order tasks'=. |: > cutopen each cutopen 1!:1 < jpath '~temp/helper.txt' NB. get ordering and tasks numbers from temporary helper file
  1!:55 < jpath '~user/temp/helper.txt' NB. deletes helper file
  tasks=. |: ,: ,. (<'task_id') ,: <"0 tasks NB. tasks has shape 4 2 1 in order to simplify the merge


  output=. (report;.1~ [: -. ('|'={.)@>) result NB. report per test
  output=. <"_1 output ,."2 tasks NB. Add tasks info
  output=. (/: order) { (-.&a:"1)each output NB. Remove fill boxes and order
  output=. (;:'version status tests') ,. version , (status,<) output NB. add version, status, and message
  output=. enc_json |: output
  output 1!:2 < outdir,'/results.json'
  exit 0
)

main'' 