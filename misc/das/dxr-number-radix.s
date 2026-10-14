        .text
start:
        .long 10
        .long 010
        .long 34525
        .long 034525
        MOVEI 1,10
        MOVEI 2,010
        MOVEI 3,0d10
        MOVEI 4,start+10
        MOVEI 5,start+0d10
        MOVE 6,[10]
        MOVE 7,[0d10]
        MOVE 10,[POINT 9,start+10,8]
        GIW start+10
        OWGBP 46,start+10
        .long start+29142024192
