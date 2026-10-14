        .TEXT
main:
        MOVEI 2,target
        ADD 1,2
        MOVEI 2,0
        MOVEI 3,3
        ADD 4,3
        MOVE 3,foo(3)
        MOVEI 5,1
        ADD 6,5
barrier:
        MOVE 5,foo
        HALT
foo:    WORD 7
target: WORD 11
