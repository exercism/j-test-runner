#!/opt/j901/bin/jconsole

require'convert/json general/unittest'

main=: monad define
try.
  assert. 5=#ARGV
  'cwd slug indir outdir'=. (1!:43'');_3{.ARGV
  1!:44 indir
  result=. unittest indir,'test.ijs'
  echo 'still alive'
  echo result
NB.  echo 9!:24'' NB. security level. prevent student solutions from running certain i/o ops
  exit 0
catch. exit 1[echo 13!:12'' end.
)

main''