; PDP-6 BLT acceleration regression: 6/9/18/36 bit, long copies and tails.
.text
.globl main
main:
 move 1,dstptr6
 move 2,srcptr6
 movei 3,140
 pushj 17,p10bcopy_v2
 movei 4,src6
 movei 5,dst6
 movei 6,20
check6:
 move 7,(4)
 came 7,(5)
 jrst fail6
 addi 4,1
 addi 5,1
 sojn 6,check6
 move 1,dstptr9
 move 2,srcptr9
 movei 3,102
 pushj 17,p10bcopy_v2
 movei 4,src9
 movei 5,dst9
 movei 6,21
check9:
 move 7,(4)
 came 7,(5)
 jrst fail9
 addi 4,1
 addi 5,1
 sojn 6,check9
 move 1,dstptr18
 move 2,srcptr18
 movei 3,41
 pushj 17,p10bcopy_v2
 movei 4,src18
 movei 5,dst18
 movei 6,21
check18:
 move 7,(4)
 came 7,(5)
 jrst fail18
 addi 4,1
 addi 5,1
 sojn 6,check18
 move 1,dstptr36
 move 2,srcptr36
 movei 3,21
 pushj 17,p10bcopy_v2
 movei 4,src36
 movei 5,dst36
 movei 6,21
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
srcptr6: .word 00360600,,src6
dstptr6: .word 00360600,,dst6
src6:
 .word 010407121520
 .word 0141722253033
 .word 0273235404346
 .word 0424550535661
 .word 0556063667174
 .word 0707376010407
 .word 030611141722
 .word 0162124273235
 .word 0313437424550
 .word 0444752556063
 .word 0576265707376
 .word 0727500030611
 .word 051013162124
 .word 0202326313437
 .word 0333641444752
 .word 0465154576265
dst6:
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
srcptr9: .word 00331100,,src9
dstptr9: .word 00331100,,dst9
src9:
 .word 01004007012
 .word 014017022025
 .word 027032035040
 .word 042045050053
 .word 055060063066
 .word 070073076101
 .word 0103106111114
 .word 0116121124127
 .word 0131134137142
 .word 0144147152155
 .word 0157162165170
 .word 0172175200203
 .word 0205210213216
 .word 0220223226231
 .word 0233236241244
 .word 0246251254257
 .word 0261264000000
dst9:
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
srcptr18: .word 00222200,,src18
dstptr18: .word 00222200,,dst18
src18:
 .word 01000004
 .word 014000017
 .word 027000032
 .word 042000045
 .word 055000060
 .word 070000073
 .word 0103000106
 .word 0116000121
 .word 0131000134
 .word 0144000147
 .word 0157000162
 .word 0172000175
 .word 0205000210
 .word 0220000223
 .word 0233000236
 .word 0246000251
 .word 0261000000
dst18:
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
srcptr36: .word 00004400,,src36
dstptr36: .word 00004400,,dst36
src36:
 .word 01
 .word 014
 .word 027
 .word 042
 .word 055
 .word 070
 .word 0103
 .word 0116
 .word 0131
 .word 0144
 .word 0157
 .word 0172
 .word 0205
 .word 0220
 .word 0233
 .word 0246
 .word 0261
dst36:
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
 .word 00
