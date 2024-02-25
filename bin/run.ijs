#! /opt/j901/bin/jconsole

require'convert/json general/unittest'

NB. todo: explore using 9!:24'' NB. security level. prevent student
NB. solutions from running certain i/o ops
success=: (;:'status name message'),:'pass';({.,{:)@:;:@:,@:>
failure=: (;:'status name message test_code'),:'fail';([:>[:{.[:;:0&{::);(1&{::);(8}.2&{::)
report=: failure`success@.(1=#)
status=: (;:'fail pass') {~ [: *./ ('pass'-:1 0&{::)S:1
version=: < 2

main=: monad define
  'slug indir outdir'=. _3{.ARGV NB. name args to vars and record cd
  1!:44 indir NB. cd to indir
  result=. }.}:<;._2 unittest indir,'test.ijs' NB. run tests
  if. (1<#result) do.
    if. 'Suite Error:'-:1{::result do. NB. error running test suite
      output=. enc_json |: ('error';(13!:12'')) ,.~ ;:'status message'
      output 1!:2 < outdir,'/results.json'
      exit 1
    end.
  end. NB. else report pass/fail
  output=. <"_1 (report;.1~[:-.[:>('|'={.)&.>) result NB. report per test
  output=. version , (<,~status) output NB. add version, status, and message
  output=. enc_json |: output ,.~ ;:'version status tests' NB. encode json
  output 1!:2 < outdir,'/results.json'
  exit 0
)

main''