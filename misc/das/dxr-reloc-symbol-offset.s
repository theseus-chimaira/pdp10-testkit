        .entry start
start:  MOVEI   1,target-1
        MOVEI   2,target+2
        WORD    0,,target-2
        WORD    0,,target+3
        WORD    target-start
        WORD    target-.-1
        HALT
 target: WORD    0
