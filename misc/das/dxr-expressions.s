        .word 2+3*4
        .word (2+3)*4
        .word 1<<5+1
        .word 077&033
        .word 010^003|020
        .word ~0
        .word -7/3
        .word -7%3
        .word -1>>1
base:   .word 0
        .word base-base+5
        MOVEI 1,(2+3)*4
        MOVE 2,base(3)
