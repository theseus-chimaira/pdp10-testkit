        .TEXT
main:   MOVE 1,FOO
        LSH 1,-022
        MOVE 2,FOO
        LSH 2,022
        MOVE 3,FOO
        LSH 4,-022
        MOVE 5,FOO
        LSH 5,-021
        MOVE 6,FOO
keep:   LSH 6,-022
        MOVE 7,FOO
        ANDI 7,0777777
        MOVE 10,FOO
        ANDI 10,0777776
        HALT
        .DATA
FOO:    .WORD 012345,,067770
