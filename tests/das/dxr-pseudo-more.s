        .entry start
start:  MOVEI 1,msg
        HALT
msg:    SIXBIT /ABCDEFghijkL/
small:  .sixbit /Z/
bytes:  .byte 6 1 2 3 4 5 6 (12)0777 010
        .byte 36,0123456701234
