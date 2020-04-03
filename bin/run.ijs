#!/opt/j901/bin/jconsole

require'convert/json general/unittest'

NB. todo: 9!:24'' NB. security level. prevent student solutions from running certain i/o ops
NB. overall have status/message/tests
NB. for each test have name/status/message/output
success=: (;:'status name message'),:'pass';({.,{:)@:;:@:,@:>
failure=: (;:'status name message'),:'fail';([:>[:{.[:;:0&{::);(8}.2&{::)
report=: failure`success@.(1=#)
status=: (;:'fail pass') {~ [: *./ ('pass'-:1 0&{::)S:1

main=: monad define
try.
  assert. 5=#ARGV NB. args are jconsole script-file slug indir outdir 
  'cwd slug indir outdir'=. (1!:43'');_3{.ARGV NB. name args to vars and record cd
  1!:44 indir NB. cd to indir
  result=. }.}:<;._2 unittest indir,'test.ijs' NB. run tests
  output=. <"_1 (report;.1~[:-.[:>('|'={.)&.>) result NB. report per test
  output=. (<,~'';status) output NB. add status and message
  output=. enc_json |: output ,.~ ;:'message status tests' NB. encode josn
  output 1!:2 < outdir,'results.json' NB. write outdier/results.json
  exit 0
catch.
  exit 1[echo 13!:12''
end.
)

main''