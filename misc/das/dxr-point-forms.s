        .entry start
start:  LDB 1,[POINT 9,@buf(2),35]
        LDB 2,lp
        HALT
lp:     POINT 7,@buf(3),34
giwa:   GIW buf+1
ow1:    OWGBP 46,buf
ow2:    OWGBP 76,GIW buf+2
buf:    0
