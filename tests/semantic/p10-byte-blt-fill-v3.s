; Long BLT fill: 6/9/18/36 bit, whole words and partial tails.
.text
.globl main
main:
 move 1,ptr6
 move 2,value6
 movei 3,142
 pushj 17,p10bfill_v2
 movei 4,dst6
 movei 5,expected6
 movei 6,21
check6:
 move 7,(4)
 came 7,(5)
 jrst fail6
 addi 4,1
 addi 5,1
 sojn 6,check6
 move 1,ptr9
 move 2,value9
 movei 3,102
 pushj 17,p10bfill_v2
 movei 4,dst9
 movei 5,expected9
 movei 6,21
check9:
 move 7,(4)
 came 7,(5)
 jrst fail9
 addi 4,1
 addi 5,1
 sojn 6,check9
 move 1,ptr18
 move 2,value18
 movei 3,41
 pushj 17,p10bfill_v2
 movei 4,dst18
 movei 5,expected18
 movei 6,21
check18:
 move 7,(4)
 came 7,(5)
 jrst fail18
 addi 4,1
 addi 5,1
 sojn 6,check18
 move 1,ptr36
 move 2,value36
 movei 3,20
 pushj 17,p10bfill_v2
 movei 4,dst36
 movei 5,expected36
 movei 6,20
check36:
 move 7,(4)
 came 7,(5)
 jrst fail36
 addi 4,1
 addi 5,1
 sojn 6,check36
 setz 1,
 popj 17,
fail6:
 movei 1,1
 popj 17,
fail9:
 movei 1,2
 popj 17,
fail18:
 movei 1,3
 popj 17,
fail36:
 movei 1,4
 popj 17,
.data
ptr6: .word 0360600,,dst6
value6: .word 017
expected6:
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171717171717
 .word 0171700000000
dst6:
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
ptr9: .word 0331100,,dst9
value9: .word 0123
expected9:
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123123123
 .word 0123123000000
dst9:
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
ptr18: .word 0222200,,dst18
value18: .word 0123456
expected18:
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456123456
 .word 0123456000000
dst18:
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
ptr36: .word 0004400,,dst36
value36: .word 0400000000001
expected36:
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
 .word 0400000000001
dst36:
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
 .word 0
