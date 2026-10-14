        .if 1
        .word 1
        .else
        BADOP 1,2
        .endif
        .if 0
        .include "this-file-must-not-exist.s"
        .word UNDEFINED
        .else
        .word 2
        .if 3-3
        BADOP 2,3
        .else
        .word 3
        .endif
        .endif
