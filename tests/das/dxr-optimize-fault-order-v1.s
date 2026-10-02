        MOVEI 1,5
        MOVE 1,FOO
        MOVE 2,BAR
        PUSH 17,2
        MOVE 2,BAZ
        MOVEI 3,TARGET
        ADD 4,3
        MOVE 3,FOO
        HALT
FOO:    .WORD 1
BAR:    .WORD 2
BAZ:    .WORD 3
TARGET: .WORD 4
