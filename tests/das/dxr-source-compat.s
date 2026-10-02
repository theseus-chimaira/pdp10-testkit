.file "ignored.c"
.ident "ignored"
.loc 1 1 0
.section .text
.entry main
main:   MOVEI 1,msg
        JRST done
.section .rodata
msg:    SIXBIT /HI/
.section .bss
zero:   .space 2
.sect .text
done:  HALT
.end
