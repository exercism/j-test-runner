load 'rna-transcription.ijs'


before_all=: monad define
  (]Description =: (3 : 'descriptions=: i.0')`(3 : 'descriptions=: descriptions , < y'))@.0 ''
  (]Order       =: (3 : 'order=: i.0')`(3 : 'order=: order , < y'))@.0 ''
  (]Task        =: (3 : 'tasks=: i.0')`(3 : 'tasks=: tasks , < y'))@.0 ''
)


rna_transcription_test_01_ignore=: 0
test_rna_transcription_test_01  =: monad define
  Description@.1 ('Single nucleotides')
  Order@.1 (1)
  Task@.1 (1)

  assert 'G' -: to_rna 'C'
  assert 'C' -: to_rna 'G'
  assert 'A' -: to_rna 'T'
  assert 'U' -: to_rna 'A'
)

rna_transcription_test_02_ignore=: 1 NB. Change this value to 0 to run this test
test_rna_transcription_test_02  =: monad define
  Description@.1 ('Empty RNA sequence')
  Order@.1 (2)
  Task@.1 (1)

  assert '' -: to_rna ''
)

rna_transcription_test_03_ignore=: 1 NB. Change this value to 0 to run this test
test_rna_transcription_test_03  =: monad define
  Description@.1 ('Invalid nucleotides')
  Order@.1 (3)
  Task@.1 (2)

  assert 'X' -: to_rna 'U'
  assert 'XX' -: to_rna 'UU' NB. This assertion will fail
)

rna_transcription_test_04_ignore=: 1 NB. Change this value to 0 to run this test
test_rna_transcription_test_04  =: monad define
  Description@.1 ('RNA complement')
  Order@.1 (4)
  Task@.1 (1)

  assert 'UGCACCAGAAUU' -: to_rna 'ACGTGGTCTTAA'
  assert 'UGCACCAGAAUU' -: to_rna 'ACGTGGTCTTAA'
)
