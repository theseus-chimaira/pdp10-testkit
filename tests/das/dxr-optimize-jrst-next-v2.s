        .text
start:
        jrst next1
next1:
        movei 1,1
        jrst keep1
        jfcl 0,0
keep1:
        movei 2,2
        jrst next2
next2:  movei 3,3
        caie 4,0
        jrst guarded
guarded:
        movei 4,4

        move 1,seed
        jrst far
        move 1,far
far:
        movei 5,5
seed:
        .word 0

labeled_jrst:
        jrst next3
next3:
        popj 17,