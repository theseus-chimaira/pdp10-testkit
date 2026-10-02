        MOVEI 1,1
        MOVEI 1,2
        MOVEI 2,3
        MOVE 2,FOO
        MOVE 3,4
        MOVEI 3,5
        MOVEI 4,7
        MOVE 4,4
L0:     MOVEI 5,1
        MOVEI 5,2
        MOVEI 6,1
L1:     MOVEI 6,2
        MOVEI 7,1
        MOVE 7,FOO(7)
        MOVE 10,FOO
        MOVEI 10,1
        MOVE 11,12
        MOVEI 11,3
        HALT
FOO:    .WORD 012345
