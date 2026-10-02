        MOVEI 1,0
        MOVEM 1,5
        MOVEI 5,0
        MOVEM 5,FOO
        MOVEI 2,0
L1:     MOVEM 2,BAR
        MOVEI 3,0
        MOVEM 3,BAR(3)
        MOVEI 4,0
        MOVEM 4,.(4)
        HALT
        .BSS
FOO:    .BLOCK 1
BAR:    .BLOCK 1
