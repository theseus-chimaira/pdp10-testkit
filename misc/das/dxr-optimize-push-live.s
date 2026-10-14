        MOVE 1,FOO
        PUSH 17,1
        MOVEI 1,3
        MOVE 2,BAR
        PUSH 17,2
        MOVE 2,BAZ
        MOVE 3,FOO
        PUSH 17,3
        ADD 3,4
        MOVE 4,FOO
        PUSH 17,4
L1:     MOVEI 4,1
        MOVE 17,FOO
        PUSH 17,17
        MOVEI 17,1
        MOVE 5,FOO(6)
        PUSH 17,5
        MOVEI 5,1
L2:     MOVE 6,FOO
        PUSH 17,6
        MOVEI 6,1
        MOVE 7,FOO
L3:     PUSH 17,7
        MOVEI 7,1
        HALT
FOO:    .WORD 011111
BAR:    .WORD 022222
BAZ:    .WORD 033333
