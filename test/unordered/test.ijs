load 'rna-transcription.ijs'


temppath=: < jpath '~temp/helper.txt'


before_all=: monad define  
  order=: i.0
  tasks=: i.0
)

after_all=: monad define
  (, LF ,~"1 ":order ,. tasks) 1!:2 temppath
)

test_empty_rna_sequence=: monad define
  order=:order , 1
  tasks=: tasks, 1
  assert ''-:rna''
)

test_rna_complement_of_cytosine_is_guanine=: monad define
  order=:order , 2
  tasks=: tasks, 1
  assert 'C'-:rna'G'
)

test_rna_complement_of_guanine_is_cytosine=: monad define
  order=:order , 3
  tasks=: tasks, 1
  assert 'G'-:rna'C'
)

test_rna_complement_of_thymine_is_adenine=: monad define
  order=:order , 4
  tasks=: tasks, 1
  assert 'A'-:rna'T'
)

test_rna_complement_of_adenine_is_uracil=: monad define
  order=:order , 5
  tasks=: tasks, 1
  assert 'U'-:rna'A'
)

test_rna_complement=: monad define
  order=:order , 6
  tasks=: tasks, 1
  assert 'UGCACCAGAAUU'-:rna'ACGTGGTCTTAA'
)
