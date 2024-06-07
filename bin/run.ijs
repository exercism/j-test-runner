#! /opt/j9.5/bin/jconsole

require'convert/json general/unittest'

NB. todo: explore using 9!:24'' NB. security level. prevent student solutions from running certain i/o ops.
NB. Simplify the process of substitution of test_name by description
NB. Refactor method to include test_code at passing tests

NB. ===================================================================================================================

NB. Those verbs are used only for the failure case
  get_test_code =: dltbs@(1 }. _2 {:: ])
  get_message   =: LF joinstring [: ~. [: }.each (<< 1 _3)&{::                         NB. if the verb does not produce a noun result the error_message has two lines
  get_test_name =: [: >@{.@;: 0&{::

success=: (;:'status name message') ,: 'pass' ; ({. , {:)@:;:@:,@:>                    NB. Message will allways be 'OK'
failure=: (;:'status name message test_code') ,: 'fail' ; get_test_name ; get_message ; get_test_code

NB. ===================================================================================================================

report=:  failure`success@.(1=#)                                                       NB. `report will decide to apply either `success or `failure for a single test result
status=:  (;:'fail pass') {~ [: *./ ('pass'-:1 0&{::)S:1
version=: < 3

NB. ===================================================================================================================

NB. REGEX verbs to circumvent the ignore flags on tests
temp_test_path     =: < jpath '~temp/test.ijs'
repl_solution_path =: '[a-zA-Z0-9[-]*]*[.]ijs'&(jcwdpath rxapply)
repl_ignore_flag   =: '_ignore ?=: ?[1-9]*'&( ( ('[1-9]+' ; '0')&rxrplc) rxapply)


NB. Code to be appended to the end of a test to manange the creation of helper files
helper_files_code=: noun define
after_all=: monad define
  require 'convert/json'
  'descrPath orderPath tasksPath'=: ([: <@jpath '~temp/'&,@,&'.json')each ;: 'descriptions order tasks'
  (descrPath 1!:2~ enc_json) descriptions
  (orderPath 1!:2~ enc_json)^:((#\ descriptions) -.@-: >) order
  (tasksPath 1!:2~ enc_json)^:(-.@-:&'') tasks
)

NB. Path for helper files
'descrPath orderPath tasksPath'=: ([: <@jpath '~temp/'&,@,&'.json')each ;: 'descriptions order tasks'

NB. ==================================================================================================================



main=: monad define
  'slug indir outdir'=. _3{.ARGV                                                       NB. name args to vars and record cd
  indir =. jpathsep indir
  outdir=. jpathsep outdir
  1!:44 indir                                                                          NB. cd to indir

  test=. 1!:1 < indir, 'test.ijs'
  test=. repl_ignore_flag repl_solution_path test                                      NB. replace ignore flags and relative paths
  test=. test , helper_files_code                                                      NB. append code to create the helper files
  test 1!:2 temp_test_path                                                             NB. record the modified test file

  result=. }. }: <;._2 unittest jpath '~temp/test.ijs'                                 NB. run tests
  1!:55 temp_test_path                                                                 NB. deletes temporary test file

  if. (1<#result) do.
    if. 'Suite Error:'-:1{::result do.                                                 NB. error running test suite
      'message_part err_path'=. (({. ,: jpathsep@}.)~ >:@(i:&' ')) 13!:12''            NB. Get the path of the script where the error occured
      'i_path err_path'=. indir ,: err_path                                            NB. fill indir to conform shapes
      relative_path=. (-. i_path = err_path) # err_path
      error_message=. (dltbs message_part), ' ', relative_path
      output=. enc_json |: (;:'version status message') ,. version, 'error' ; error_message
      output 1!:2 < outdir,'/results.json'
      exit 1
    end.
  end.                                                                                 NB. else report pass/fail

  NB. Get the data from temporary files
  descriptions=. dec_json 1!:1 descrPath                                               NB. the decription file will allways be created; it's absence is an error
  order       =. (<:@>@dec_json@(1!:1) :: '') orderPath                                NB. if order file does not exists the test were executed as defined
  sort_exec   =. order&((] {~ /:@/:)^:('' -.@-: [))                                    NB. sort tests by order of execution if necessary
  tasks       =. (dec_json@(1!:1) :: (<"0 '1' #~ # descriptions)) tasksPath            NB. if tasks file does not exists task_id is '1' for all tests

  (1!:55 :: '') descrPath                                                              NB. deletes helper file
  (1!:55 :: '') orderPath
  (1!:55 :: '') tasksPath

  assertions  =. |: ,: (<'test_code') ,: sort_exec 'assert .*' rxall test
  descriptions=. |: ,: (<'name') ,: descriptions                                       NB. descriptions and tasks has shape (# tests) 2 1 in order to simplify the merge
  tasks       =. |: ,: (<'task_id') ,: ":each tasks

  output=. (report;.1~ [: -. ('|'={.)@>) result                                        NB. report per test
  output=. <"_1 descriptions ,."2 output ,."2 assertions ,."2 tasks                    NB. Add tasks, assertion and descriptions info
  output=. (-.&(a:,a:)) @:(}.@:((<2 0)&C.))&.(|:"2) each output                        NB. Remove test_name and fill boxes after reorder labels
  output=. ((1 1 1 1 0 1&#)`(1 1 0 1 1&#)@.('pass' -: 0 1&{::))&.(|:"2) each output    NB. Alter message to assertions if test passes
  output=. sort_exec output                                                            NB. Apply order if necesssary
  output=. (;:'version status tests') ,. version , (status,<) output                   NB. add version, status, and message
  output=. enc_json |: output
  output 1!:2 < outdir,'/results.json'
  exit 0
)

main''
