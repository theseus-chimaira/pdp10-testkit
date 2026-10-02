        .TEXT
        XCT LMOVE
        XCT LIMMED
        XCT LZERO
        XCT LSELF
        XCT LRET
        XCT LBRANCH
        HALT
LMOVE:  MOVE 1,FOO
        HRRZ 1,1
LIMMED: MOVEI 2,3
        ADDI 2,4
LZERO:  MOVEI 3,0
        MOVEM 3,4
LSELF:  MOVE 5,5
        SETZ 6,
LRET:   MOVEI 7,FOO
        MOVE 10,7
        MOVEI 7,0
LBRANCH:JUMPN 11,LBT
        JRST LBE
LBT:    MOVEI 12,1
LBE:    SETZ 13,
        HALT
FOO:    .WORD 012345
