load 'nucleotide-count.ijs'

nucleotid_counts_test_01_ignore=: 0
test_nucleotid_counts_test_01  =: monad define
  Description=:'empty strand'
  
  NB. Expected=: 0 0 0 0
  assert 0 0 0 0 -: nucleotide_counts ''
)

nucleotid_counts_test_02_ignore=: 1 NB. Change this value to 0 to run this test
test_nucleotid_counts_test_02  =: monad define
  Description=:'can count one nucleotide in single-character input'
  
  NB. Expected=: 0 0 1 0
  assert 0 0 1 0 -: nucleotide_counts 1$'G'
)

nucleotid_counts_test_03_ignore=: 1 NB. Change this value to 0 to run this test
test_nucleotid_counts_test_03  =: monad define
  Description=:'strand with repeated nucleotide'
  
  NB. Expected=: 0 0 7 0
  assert 0 0 7 0 -: nucleotide_counts 'GGGGGGG'
)

nucleotid_counts_test_04_ignore=: 1 NB. Change this value to 0 to run this test
test_nucleotid_counts_test_04  =: monad define
  Description=:'strand with multiple nucleotides'
  
  NB. Expected=: 20 12 17 21
  assert 20 12 17 21 -: nucleotide_counts 'AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC'
)

nucleotid_counts_test_05_ignore=: 1 NB. Change this value to 0 to run this test
nucleotid_counts_test_05_expect=: 'domain error'
test_nucleotid_counts_test_05  =: monad define
  Description=:'strand with invalid nucleotides'
  
  NB. Expected=: 'domain error'
  assert (>@{: 9!:8 '') -: nucleotide_counts 'AGXXACT'
)
