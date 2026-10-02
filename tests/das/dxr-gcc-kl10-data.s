        .text
        .globl start
start:
        .long %EXIND(1,2,0123456701),1,%EXIND(0,0,0)
        .long 010040000000,GIW target
target:
        .long 0
