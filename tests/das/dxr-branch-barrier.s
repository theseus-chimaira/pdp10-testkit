.text
start:
        jrst L1
.if 1
.endif
L1:
        movei 1,1
        jumpn 2,L2
        jrst L3
.if 1
.endif
L2:
        movei 3,2
L3:
        .word 0
