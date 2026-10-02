        .text
start:  .word 1
        .align 3
text_aligned:
        .word 2
        .data
        .word 3
        .align 4
data_aligned:
        .word 4
        .bss
        .block 1
        .align 3
bss_aligned:
        .block 1
