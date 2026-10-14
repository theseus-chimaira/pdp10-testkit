.TEXT
START:
        MOVEM 1,FOO
        MOVE 2,FOO
        MOVEM 3,BAR
        MOVE 4,BAZ
        MOVEM 5,FOO
        MOVE 5,FOO
        MOVEM 6,FOO(7)
        MOVE 10,FOO(7)
        MOVEM 11,@FOO
        MOVE 12,@FOO
        MOVEM 13,FOO
KEEP:   MOVE 13,FOO
        HALT
.DATA
FOO:   .WORD 0
BAR:   .WORD 0
BAZ:   .WORD 0
