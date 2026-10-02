        .ifndef LATER
        .word 1
        .endif
        .ifdef LATER
        .word 077
        .endif
        .if 0
HIDDEN: .word 077
        .endif
        .ifndef HIDDEN
        .word 2
        .endif
LATER:  .word 3
        .ifdef LATER
        .word 4
        .endif
        .ifndef SELF
        .set SELF,5
        .word SELF
        .endif
        .ifdef SELF
        .word 6
        .endif
        .set N,3
        .rept N
        .word 7
        .endr
        .rept 2
        .rept 2
        .word 010
        .endr
        .include "dxr-rept-include.inc"
        .endr
        .rept 0
        BADOP 1,2
        .include "this-file-must-not-exist.s"
        .endr
        .rept 1
        .rept 1
        .rept 1
        .rept 1
        .rept 1
        .rept 1
        .rept 1
        .rept 1
        .word 012
        .endr
        .endr
        .endr
        .endr
        .endr
        .endr
        .endr
        .endr
