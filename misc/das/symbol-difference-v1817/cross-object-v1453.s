/*
 * Both exported symbols are in a DIFFERENT object.  DOBJ1 cannot
 * relocate their difference; DAS must reject this object rather
 * than encoding the incorrect constant 000057.
 */
        .text
        .globl difference_begin_v1453
        .globl difference_end_v1453
        blt 1,060+(difference_end_v1453-difference_begin_v1453)-1
