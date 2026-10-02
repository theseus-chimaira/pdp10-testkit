        .globl main
main:
        ldb 1,LP
        ldb 2,[POINT 9,foo,35]
        popj 17,
LP:
        POINT 9,foo,8
foo:
        0
