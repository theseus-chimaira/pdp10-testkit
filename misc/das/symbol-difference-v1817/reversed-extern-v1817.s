/* A negative base followed by a positive distinct base cannot cancel. */
        .text
        .globl reversed_extern_v1817
        .globl external_a_v1817
        .globl external_b_v1817
reversed_extern_v1817:
        .word -external_a_v1817+external_b_v1817
