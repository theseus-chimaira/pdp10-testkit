        MOVEI 1,0
        MOVEM 1,FOO
        MOVEI 2,0
        MOVEM 2,3
        HALT
        .BSS
FOO:    .BLOCK 1
