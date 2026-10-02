.text
        jumpn 1,L1
        jrst L2
L1:
        movei 2,1
L2:
        jumpl 3,L3
        jrst L4
L3:
        movei 4,2
L4:
        .word 0
