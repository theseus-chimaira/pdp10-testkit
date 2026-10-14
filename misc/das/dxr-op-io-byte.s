        .entry start
start:  CONO 200,foo
        HRROI 2,foo+1
        JUMPN 2,done
        SETO 3,
done:   HALT
        .data
foo:    .byte 6,1,2,3,4,5,6,7
        .bss
buf:    BLOCK 3
