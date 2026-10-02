        MOVEI 1,FOO
        HRRZ 1,1
        MOVEI 2,@FOO
        HRRZ 2,2
        MOVEI 3,FOO(4)
        HRRZ 3,3
        MOVEI 4,FOO
L1:     HRRZ 4,4
        HALT
FOO:    .LONG 0
