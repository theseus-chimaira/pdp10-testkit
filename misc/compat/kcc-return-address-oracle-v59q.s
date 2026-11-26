        .text
        .globl main
        .globl fail_id
main:
        movem 17,saved_sp
        movei 1,1
        movem 1,fail_id
        pushj 17,ra_leaf
leaf_pc:
        came 1,[POINT 9,leaf_pc,8]
         jrst failed
        came 17,saved_sp
         jrst failed
        movei 1,2
        movem 1,fail_id
        movei 1,27
        pushj 17,ra_fixed
fixed_pc:
        came 1,[POINT 9,fixed_pc,8]
         jrst failed
        came 17,saved_sp
         jrst failed
        movei 1,3
        movem 1,fail_id
        movei 1,23
        pushj 17,ra_dynamic
dynamic_pc:
        came 1,[POINT 9,dynamic_pc,8]
         jrst failed
        came 17,saved_sp
         jrst failed
        movei 1,4
        movem 1,fail_id
        movei 1,41
        pushj 17,ra_dynamic
dynamic_pc2:
        came 1,[POINT 9,dynamic_pc2,8]
         jrst failed
        came 17,saved_sp
         jrst failed
        movei 1,5
        movem 1,fail_id
        pushj 17,ra_deeper
        jumpe 1,passed
failed:
        movei 1,1
        popj 17,
passed:
        setzm fail_id
        setz 1,
        popj 17,
        .bss
fail_id: .block 1
saved_sp: .block 1
