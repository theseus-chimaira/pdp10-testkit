/* Different output sections are independently relocated at DOBJ link. */
        .text
        .globl different_section_v1817
different_section_v1817:
        .word data_label_v1817-text_label_v1817
text_label_v1817:
        halt .
        .data
data_label_v1817:
        .word 0
