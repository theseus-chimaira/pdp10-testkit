        .ENTRY START
        .TEXT
START:  MOVEI   1,MESSAGE
        MOVEI   2,VALUE
        MOVEI   3,VALUE
        JRST    DONE
MESSAGE: ASCII  "A/*B"
DONE:   HALT
        .DATA
VALUE:  WORD    012345
        .TEXT
        MOVEI   4,4
        MOVEI   5,5
