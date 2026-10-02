        /* whole-line GAS block comment */
        .ENTRY START
        .TEXT
START:  MOVEI   1,MESSAGE /* trailing comment */
        MOVEI   /* embedded comment */ 2,VALUE
        MOVEI   3,VALUE /* first */ /* second */
        /* multi-line comment begins
           and continues here */
        JRST    DONE
MESSAGE: ASCII  "A/*B"
DONE:   HALT
        .DATA
VALUE:  WORD    012345
        .TEXT
        .macro CMOV reg,val
        MOVEI   \reg,/* macro body */\val
        .endm
        CMOV    4,4
        .rept   1
        MOVEI   5,/* rept body */5
        .endr
