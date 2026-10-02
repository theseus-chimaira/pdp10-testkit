        .entry start
        .equ BIG,012345670123
        .equ ALIAS,target
        .set N,1
        .equ E51,7
start:  WORD BIG
        WORD N
        .set N,2
        WORD N
        MOVEI 1,ALIAS
target: HALT
