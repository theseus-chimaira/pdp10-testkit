        .text
start:  .word 1
        .org 1+3
text_org:
        .word 2
        .data
        .word 3
        .org 3
data_org:
        .word 4
        .bss
        .block 1
        .org 4
bss_org:
        .block 1
        .text
        .p2align 3
p2aligned:
        .zero 5
