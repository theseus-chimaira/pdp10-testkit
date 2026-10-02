        .text
start:
        skipa 1,.+1
        x%180+0762200000000
        jrst done
x%180:
        .word 0
done:
        jrst done
