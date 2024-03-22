#! /opt/j901/bin/jconsole

require'convert/json general/unittest'

NB. todo: explore using 9!:24'' NB. security level. prevent student
NB. solutions from running certain i/o ops
success=: (;:'status name message') ,: 'pass' ; ({.,{:)@:;:@:,@:>
failure=: (;:'status name message test_code') ,: 'fail' ; ([: > [: {. [: ;: 0&{::) ; (1&{::) ; (8 }. 2&{::)
report=:  failure`success@.(1=#)
status=:  (;:'fail pass') {~ [: *./ ('pass'-:1 0&{::)S:1
version=: <'3'

main=: monad define
  'slug indir outdir'=. _3{.ARGV NB. name args to vars and record cd
  1!:44 indir NB. cd to indir
  result=. }. }: <;._2 unittest indir,'test.ijs' NB. run tests
  'order tasks'=. |: > cutopen each cutopen 1!:1 < jpath '~temp/helper.txt' NB. get ordering and tasks numbers from temporary helper file
  1!:55 < jpath '~user/temp/helper.txt' NB. deletes helper file
  tasks=. |: ,: ,. (<'task_id') ,: <"0 tasks NB. tasks has shape 4 2 1 in order to simplify the merge

  if. (1<#result) do.
    if. 'Suite Error:'-:1{::result do. NB. error running test suite
      output=. enc_json |: ('error';(13!:12'')) ,.~ ;:'status message'
      output 1!:2 < outdir,'/results.json'
      exit 1
    end.
  end. NB. else report pass/fail
  output=. (report;.1~ [: -. ('|'={.)@>) result NB. report per test
  output=. <"_1 output ,."2 tasks NB. Add tasks info
  output=. (/: order) { (-.&a:"1)each output NB. Remove fill boxes and order
  output=. (;:'version status tests') ,. version , (status,<) output NB. add version, status, and message
  output=. enc_json |: output
  output 1!:2 < outdir,'/results.json'
  exit 0
)

main'' 