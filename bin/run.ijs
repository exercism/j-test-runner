#!/opt/j901/bin/jconsole

require'convert/json general/unittest'

NB.  echo 9!:24'' NB. security level. prevent student solutions from running certain i/o ops

status=: 0=#@(#~[:-.[:>('OK'-:_2&{.)&.>)@}.

report_test=: ]

main=: monad define
try.
  assert. 5=#ARGV NB. args are jconsole script-file slug indir outdir 
  'cwd slug indir outdir'=. (1!:43'');_3{.ARGV NB. name args to vars and record cd
  1!:44 indir                                  NB. go to indir
  result=. }: <;._2 unittest indir,'test.ijs'  NB. run tests
  report=. (<'status'),:<(;:'fail pass'){::~status result
  report=. report,.~(<'message'),:a:
  report=. report,.~(<'test'),:<report_test &.> }. result
  echo result
  (enc_json report)(1!:2)<outdir,'results.json'
  exit 0
catch. exit 1[echo 13!:12'' end.
)

main''