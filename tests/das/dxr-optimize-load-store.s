        .TEXT
        MOVE 1,FOO
        MOVEM 1,FOO
        MOVE 2,L1
        MOVEM 2,L1
        MOVE 3,.
        MOVEM 3,.
        MOVE 4,FOO
        MOVEM 4,BAR
        MOVE 5,FOO(2)
        MOVEM 5,FOO(2)
        MOVE 6,@FOO
        MOVEM 6,@FOO
        MOVE 7,FOO
        MOVE 7,FOO
        MOVEM 10,BAR
        MOVEM 10,BAR
        HALT
        .DATA
FOO:    .WORD 1
BAR:    .WORD 2
L1:     .WORD 3
