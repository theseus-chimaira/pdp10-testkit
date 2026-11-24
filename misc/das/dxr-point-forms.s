        .entry start
start:  LDB 1,[POINT 9,@buf(2),35]
        LDB 2,lp
        HALT
lp:     POINT 7,@buf(3),34
wa:     .long buf+1
bp1:    POINT 6,buf,5
bp2:    POINT 18,buf+2,35
buf:    0
