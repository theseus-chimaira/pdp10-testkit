        .text
        MOVEI 2,TARGET
        MOVE 6,2
        MOVE 2,1
        MOVEI 3,TARGET
        MOVE 7,3
L1:     MOVE 3,1
        HALT
TARGET: .WORD 012345
