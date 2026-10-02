        .TEXT
        MOVE 1,FOO(1)
        HRRZ 1,1
        MOVE 2,@10
        MOVE 2,@10
        MOVE 3,FOO(3)
        MOVE 3,FOO(3)
        MOVE 4,.
        MOVE 4,.
        HALT
        .DATA
FOO:    .WORD 012345
