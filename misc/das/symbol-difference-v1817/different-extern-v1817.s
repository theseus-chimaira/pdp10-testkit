/* Reordered unary negation cannot erase distinct external relocations. */
        .text
        .globl different_extern_v1817
        .globl external_a_v1817
        .globl external_b_v1817
different_extern_v1817:
        .word external_a_v1817+(-external_b_v1817)
