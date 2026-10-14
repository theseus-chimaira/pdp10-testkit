        .entry start
start:  MOVEI 1,ptr
        MOVEI 2,[OWGBP 70,ptr]
        HALT
ptr:    GIW text
text:   .ascii /HELLO/
zero:   .asciz /A/
