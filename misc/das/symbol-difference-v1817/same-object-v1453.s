/*
 * Two defined labels in the same TEXT section have a fixed difference,
 * even when the object is linked at a different load address.
 */
        .text
        .globl same_difference_v1453
same_difference_v1453:
        blt 1,060+(local_end_v1453-local_begin_v1453)-1
local_begin_v1453:
        setz 0,
        popj 17,
local_end_v1453:
