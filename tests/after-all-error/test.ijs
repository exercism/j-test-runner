load 'rna-transcription.ijs'


rna_transcription_test_01_ignore=: 0
test_rna_transcription_test_01  =: monad define
  Description=: 'Empty RNA sequence'

  assert '' -: to_rna ''
)

rna_transcription_test_02_ignore=:0
test_rna_transcription_test_02  =: monad define
  Description=: 'RNA complement of thymine is adenine'

  assert 'A' -: to_rna 'T'
)

rna_transcription_test_03_ignore=:0
test_rna_transcription_test_03  =: monad define
  Description=: 'RNA complement of cytosine is guanine'

  assert 'U' -: to_rna 'C' NB. This test will fail
)

rna_transcription_test_04_ignore=:0
test_rna_transcription_test_04  =: monad define
  Description=: 'RNA complement'

  assert 'UGCACCAGAAUU' -: to_rna 'ACGTGGTCTTAA'
)

after_all=:{{
  
}}
