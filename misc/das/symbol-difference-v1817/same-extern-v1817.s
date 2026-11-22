/* Repeated use of one undefined external symbol cancels the same base. */
        .text
        .globl same_extern_v1817
        .globl external_v1817
same_extern_v1817:
        .word external_v1817-external_v1817
        .word external_v1817+(-external_v1817)
        .word -external_v1817+external_v1817
        halt .
