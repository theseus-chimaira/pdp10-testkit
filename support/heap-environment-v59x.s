; Explicit test-owned arena: 4096 words = 16384 target C bytes.
; Not part of either compiler library or the ordinary startup.
.text
.globl __p10rt_heap_init_v59x
__p10rt_heap_init_v59x:
        move 1,[POINT 9,__p10rt_heap_v59x,8]
        movei 2,040000
        jrst p10heap_init_v1
.bss
__p10rt_heap_v59x:
        .block 010000
