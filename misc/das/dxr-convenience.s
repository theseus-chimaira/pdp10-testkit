        .entry start
start:  MOVEI 1,ptr
        MOVEI 2,[POINT 9,ptr,8]
        HALT
ptr:    .long text
text:   .ascii /HELLO/
zero:   .asciz /A/
