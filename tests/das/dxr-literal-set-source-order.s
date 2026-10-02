        .text
        .set X,1
        MOVE 1,[X]
        .set X,2
        MOVE 2,[X]
        .set X,2
        MOVE 3,[X]
        .set P,target1
        MOVE 4,[P]
        .set P,target2
        MOVE 5,[P]
target1: HALT
target2: HALT
