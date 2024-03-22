load 'nucleotide-count.ijs'


temppath=: < jpath '~temp/helper.txt'


before_all =: monad define  
  order=: i.0
  tasks=: i.0
)

after_all =: monad define
  (, LF ,~"1 ":order ,. tasks) 1!:2 temppath
)

nuc_cnt1_ignore=:0
test_nuc_cnt1=: monad define
  order=:order , 1
  tasks=:tasks , 1
  assert 0 0 0 0-:nuc_cnt''
)

nuc_cnt2_ignore=:0
test_nuc_cnt2=: monad define
  order=:order , 2
  tasks=:tasks , 1
  assert 0 0 1 0-:nuc_cnt 1$'G'
)

nuc_cnt3_ignore=:0
test_nuc_cnt3=: monad define
  order=:order , 3
  tasks=:tasks , 1
  assert 0 0 7 0-:nuc_cnt'GGGGGGG'
)

nuc_cnt4_ignore=:0
test_nuc_cnt4=: monad define
  order=:order , 4
  tasks=:tasks , 1
  assert 20 12 17 21-:nuc_cnt'AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC'
)
