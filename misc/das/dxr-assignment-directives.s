        .entry start
        .set COND,1
start:
        .if COND
        .word 1
        .else
        .word 077
        .endif
        .set SPACE_BYTES,8
        .space SPACE_BYTES
        .set ALIGN_POWER,4
        .align ALIGN_POWER
aligned:
        .word 2
        .set ZERO_BYTES,8
        .zero ZERO_BYTES
        .set BYTE_SIZE,6
        .set BYTE_VALUE,3
        BYTE BYTE_SIZE,BYTE_VALUE,(12)0776
        .set POINT_SIZE,9
        .set POINT_POS,35
ptr:    POINT POINT_SIZE,target,POINT_POS
        .set ORIGIN,12
        .org ORIGIN
target: .word 4
        .set COND,0
        .if COND
        .word 076
        .else
        .word 5
        .endif
