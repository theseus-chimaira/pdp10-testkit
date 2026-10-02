        .text
        MOVE 3,FOO(4)
        MOVE 6,3
        MOVEI 3,1
        MOVE 5,FOO(3)
        MOVE 7,5
        MOVE 5,0(5)
        HALT
FOO:    .WORD 012345
