        .entry start
start:  MOVEI   1,msg
        PUSHJ   17,done
done:   POPJ    17,
        .data
msg:    SIXBIT  /HELLO/
        .bss
buf:    BLOCK   4
