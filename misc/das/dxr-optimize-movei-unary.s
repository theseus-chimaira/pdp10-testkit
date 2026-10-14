        MOVEI 1,0123456
        HRRE 1,1
        MOVEI 2,0123456
        SETCM 2,2
        MOVEI 3,0123456
        HRLZ 3,3
        MOVEI 4,0123456
        MOVS 4,4
        MOVEI 5,FOO
        HRRE 5,5
        MOVEI 6,0123456
L1:     HRRE 6,6
        HALT
FOO:    .LONG 0
