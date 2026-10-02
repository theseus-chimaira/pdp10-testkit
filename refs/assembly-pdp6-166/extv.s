
load6_0:
	move 1,s
	ash 1,-36
	popj 17,

lptr6_0:
	move 1,(1)
	ash 1,-36
	popj 17,

lvptr6_0:
	ldb 1,[POINT 9,(1),8]
	lsh 1,33
	ash 1,-36
	popj 17,

lvload6_0:
	ldb 1,[POINT 9,vs,8]
	lsh 1,33
	ash 1,-36
	popj 17,

larr6_0:
	move 1,x6+1
	ash 1,-36
	popj 17,

lvarr6_0:
	ldb 1,[POINT 9,vx6+1,8]
	lsh 1,33
	ash 1,-36
	popj 17,

load6_1:
	move 1,s
	lsh 1,6
	ash 1,-36
	popj 17,

lptr6_1:
	move 1,(1)
	lsh 1,6
	ash 1,-36
	popj 17,

lvptr6_1:
	hlrz 1,(1)
	lsh 1,30
	ash 1,-36
	popj 17,

lvload6_1:
	hlrz 1,vs
	lsh 1,30
	ash 1,-36
	popj 17,

larr6_1:
	move 1,x6+1
	lsh 1,6
	ash 1,-36
	popj 17,

lvarr6_1:
	hlrz 1,vx6+1
	lsh 1,30
	ash 1,-36
	popj 17,

load6_2:
	move 1,s
	lsh 1,14
	ash 1,-36
	popj 17,

lptr6_2:
	move 1,(1)
	lsh 1,14
	ash 1,-36
	popj 17,

lvptr6_2:
	ldb 1,[POINT 9,(1),8]
	lsh 1,36
	ash 1,-36
	popj 17,

lvload6_2:
	ldb 1,[POINT 9,vs,8]
	lsh 1,36
	ash 1,-36
	popj 17,

larr6_2:
	move 1,x6+1
	lsh 1,14
	ash 1,-36
	popj 17,

lvarr6_2:
	ldb 1,[POINT 9,vx6+1,8]
	lsh 1,36
	ash 1,-36
	popj 17,

load6_3:
	move 1,s
	lsh 1,22
	ash 1,-36
	popj 17,

lptr6_3:
	move 1,(1)
	lsh 1,22
	ash 1,-36
	popj 17,

lvptr6_3:
	ldb 1,[POINT 9,(1),8]
	lsh 1,33
	ash 1,-36
	popj 17,

lvload6_3:
	ldb 1,[POINT 9,vs,8]
	lsh 1,33
	ash 1,-36
	popj 17,

larr6_3:
	move 1,x6+1
	lsh 1,22
	ash 1,-36
	popj 17,

lvarr6_3:
	ldb 1,[POINT 9,vx6+1,8]
	lsh 1,33
	ash 1,-36
	popj 17,

load6_4:
	move 1,s
	lsh 1,30
	ash 1,-36
	popj 17,

lptr6_4:
	move 1,(1)
	lsh 1,30
	ash 1,-36
	popj 17,

lvptr6_4:
	hlrz 1,(1)
	lsh 1,30
	ash 1,-36
	popj 17,

lvload6_4:
	hlrz 1,vs
	lsh 1,30
	ash 1,-36
	popj 17,

larr6_4:
	move 1,x6+1
	lsh 1,30
	ash 1,-36
	popj 17,

lvarr6_4:
	hlrz 1,vx6+1
	lsh 1,30
	ash 1,-36
	popj 17,

load6_5:
	move 1,s
	lsh 1,36
	ash 1,-36
	popj 17,

lptr6_5:
	move 1,(1)
	lsh 1,36
	ash 1,-36
	popj 17,

lvptr6_5:
	ldb 1,[POINT 9,(1),8]
	lsh 1,36
	ash 1,-36
	popj 17,

lvload6_5:
	ldb 1,[POINT 9,vs,8]
	lsh 1,36
	ash 1,-36
	popj 17,

larr6_5:
	move 1,x6+1
	lsh 1,36
	ash 1,-36
	popj 17,

lvarr6_5:
	ldb 1,[POINT 9,vx6+1,8]
	lsh 1,36
	ash 1,-36
	popj 17,

load7_0:
	move 1,s+1
	ash 1,-35
	popj 17,

lptr7_0:
	move 1,1(1)
	ash 1,-35
	popj 17,

lvptr7_0:
	addi 1,1
	ldb 1,[POINT 9,(1),8]
	lsh 1,33
	ash 1,-35
	popj 17,

lvload7_0:
	ldb 1,[POINT 9,vs+1,8]
	lsh 1,33
	ash 1,-35
	popj 17,

larr7_0:
	move 1,x7+1
	ash 1,-35
	popj 17,

lvarr7_0:
	ldb 1,[POINT 9,vx7+1,8]
	lsh 1,33
	ash 1,-35
	popj 17,

load7_1:
	move 1,s+1
	lsh 1,7
	ash 1,-35
	popj 17,

lptr7_1:
	move 1,1(1)
	lsh 1,7
	ash 1,-35
	popj 17,

lvptr7_1:
	addi 1,1
	hlrz 1,(1)
	lsh 1,31
	ash 1,-35
	popj 17,

lvload7_1:
	hlrz 1,vs+1
	lsh 1,31
	ash 1,-35
	popj 17,

larr7_1:
	move 1,x7+1
	lsh 1,7
	ash 1,-35
	popj 17,

lvarr7_1:
	hlrz 1,vx7+1
	lsh 1,31
	ash 1,-35
	popj 17,

load7_2:
	move 1,s+1
	lsh 1,16
	ash 1,-35
	popj 17,

lptr7_2:
	move 1,1(1)
	lsh 1,16
	ash 1,-35
	popj 17,

lvptr7_2:
	move 1,1(1)
	lsh 1,16
	ash 1,-35
	popj 17,

lvload7_2:
	move 1,vs+1
	lsh 1,16
	ash 1,-35
	popj 17,

larr7_2:
	move 1,x7+1
	lsh 1,16
	ash 1,-35
	popj 17,

lvarr7_2:
	move 1,vx7+1
	lsh 1,16
	ash 1,-35
	popj 17,

load7_3:
	move 1,s+1
	lsh 1,25
	ash 1,-35
	popj 17,

lptr7_3:
	move 1,1(1)
	lsh 1,25
	ash 1,-35
	popj 17,

lvptr7_3:
	addi 1,1
	hlrz 1,(1)
	lsh 1,25
	ash 1,-35
	popj 17,

lvload7_3:
	hlrz 1,vs+1
	lsh 1,25
	ash 1,-35
	popj 17,

larr7_3:
	move 1,x7+1
	lsh 1,25
	ash 1,-35
	popj 17,

lvarr7_3:
	hlrz 1,vx7+1
	lsh 1,25
	ash 1,-35
	popj 17,

load7_4:
	move 1,s+1
	lsh 1,34
	ash 1,-35
	popj 17,

lptr7_4:
	move 1,1(1)
	lsh 1,34
	ash 1,-35
	popj 17,

lvptr7_4:
	addi 1,1
	ldb 1,[POINT 9,(1),8]
	lsh 1,34
	ash 1,-35
	popj 17,

lvload7_4:
	ldb 1,[POINT 9,vs+1,8]
	lsh 1,34
	ash 1,-35
	popj 17,

larr7_4:
	move 1,x7+1
	lsh 1,34
	ash 1,-35
	popj 17,

lvarr7_4:
	ldb 1,[POINT 9,vx7+1,8]
	lsh 1,34
	ash 1,-35
	popj 17,

load8_0:
	move 1,s+2
	ash 1,-34
	popj 17,

lptr8_0:
	move 1,2(1)
	ash 1,-34
	popj 17,

lvptr8_0:
	addi 1,2
	ldb 1,[POINT 9,(1),8]
	lsh 1,33
	ash 1,-34
	popj 17,

lvload8_0:
	ldb 1,[POINT 9,vs+2,8]
	lsh 1,33
	ash 1,-34
	popj 17,

larr8_0:
	move 1,x8+1
	ash 1,-34
	popj 17,

lvarr8_0:
	ldb 1,[POINT 9,vx8+1,8]
	lsh 1,33
	ash 1,-34
	popj 17,

load8_1:
	move 1,s+2
	lsh 1,10
	ash 1,-34
	popj 17,

lptr8_1:
	move 1,2(1)
	lsh 1,10
	ash 1,-34
	popj 17,

lvptr8_1:
	addi 1,2
	hlrz 1,(1)
	lsh 1,32
	ash 1,-34
	popj 17,

lvload8_1:
	hlrz 1,vs+2
	lsh 1,32
	ash 1,-34
	popj 17,

larr8_1:
	move 1,x8+1
	lsh 1,10
	ash 1,-34
	popj 17,

lvarr8_1:
	hlrz 1,vx8+1
	lsh 1,32
	ash 1,-34
	popj 17,

load8_2:
	move 1,s+2
	lsh 1,20
	ash 1,-34
	popj 17,

lptr8_2:
	move 1,2(1)
	lsh 1,20
	ash 1,-34
	popj 17,

lvptr8_2:
	move 1,2(1)
	lsh 1,20
	ash 1,-34
	popj 17,

lvload8_2:
	move 1,vs+2
	lsh 1,20
	ash 1,-34
	popj 17,

larr8_2:
	move 1,x8+1
	lsh 1,20
	ash 1,-34
	popj 17,

lvarr8_2:
	move 1,vx8+1
	lsh 1,20
	ash 1,-34
	popj 17,

load8_3:
	move 1,s+2
	lsh 1,30
	ash 1,-34
	popj 17,

lptr8_3:
	move 1,2(1)
	lsh 1,30
	ash 1,-34
	popj 17,

lvptr8_3:
	addi 1,2
	hlrz 1,(1)
	lsh 1,30
	ash 1,-34
	popj 17,

lvload8_3:
	hlrz 1,vs+2
	lsh 1,30
	ash 1,-34
	popj 17,

larr8_3:
	move 1,x8+1
	lsh 1,30
	ash 1,-34
	popj 17,

lvarr8_3:
	hlrz 1,vx8+1
	lsh 1,30
	ash 1,-34
	popj 17,

load9_0:
	move 1,s+3
	ash 1,-33
	popj 17,

lptr9_0:
	move 1,3(1)
	ash 1,-33
	popj 17,

lvptr9_0:
	ldb 1,[POINT 9,3(1),8]
	lsh 1,33
	ash 1,-33
	popj 17,

lvload9_0:
	ldb 1,[POINT 9,vs+3,8]
	lsh 1,33
	ash 1,-33
	popj 17,

larr9_0:
	move 1,x9+1
	ash 1,-33
	popj 17,

lvarr9_0:
	ldb 1,[POINT 9,vx9+1,8]
	lsh 1,33
	ash 1,-33
	popj 17,

load9_1:
	move 1,s+3
	lsh 1,11
	ash 1,-33
	popj 17,

lptr9_1:
	move 1,3(1)
	lsh 1,11
	ash 1,-33
	popj 17,

lvptr9_1:
	ldb 1,[POINT 9,3(1),17]
	lsh 1,33
	ash 1,-33
	popj 17,

lvload9_1:
	ldb 1,[POINT 9,vs+3,17]
	lsh 1,33
	ash 1,-33
	popj 17,

larr9_1:
	move 1,x9+1
	lsh 1,11
	ash 1,-33
	popj 17,

lvarr9_1:
	ldb 1,[POINT 9,vx9+1,17]
	lsh 1,33
	ash 1,-33
	popj 17,

load9_2:
	move 1,s+3
	lsh 1,22
	ash 1,-33
	popj 17,

lptr9_2:
	move 1,3(1)
	lsh 1,22
	ash 1,-33
	popj 17,

lvptr9_2:
	ldb 1,[POINT 9,3(1),26]
	lsh 1,33
	ash 1,-33
	popj 17,

lvload9_2:
	ldb 1,[POINT 9,vs+3,26]
	lsh 1,33
	ash 1,-33
	popj 17,

larr9_2:
	move 1,x9+1
	lsh 1,22
	ash 1,-33
	popj 17,

lvarr9_2:
	ldb 1,[POINT 9,vx9+1,26]
	lsh 1,33
	ash 1,-33
	popj 17,

load9_3:
	move 1,s+3
	lsh 1,33
	ash 1,-33
	popj 17,

lptr9_3:
	move 1,3(1)
	lsh 1,33
	ash 1,-33
	popj 17,

lvptr9_3:
	ldb 1,[POINT 9,3(1),35]
	lsh 1,33
	ash 1,-33
	popj 17,

lvload9_3:
	ldb 1,[POINT 9,vs+3,35]
	lsh 1,33
	ash 1,-33
	popj 17,

larr9_3:
	move 1,x9+1
	lsh 1,33
	ash 1,-33
	popj 17,

lvarr9_3:
	ldb 1,[POINT 9,vx9+1,35]
	lsh 1,33
	ash 1,-33
	popj 17,

load16_0:
	move 1,s+4
	ash 1,-24
	popj 17,

lptr16_0:
	move 1,4(1)
	ash 1,-24
	popj 17,

lvptr16_0:
	addi 1,4
	hlrz 1,(1)
	lsh 1,22
	ash 1,-24
	popj 17,

lvload16_0:
	hlrz 1,vs+4
	lsh 1,22
	ash 1,-24
	popj 17,

larr16_0:
	move 1,x16+1
	ash 1,-24
	popj 17,

lvarr16_0:
	hlrz 1,vx16+1
	lsh 1,22
	ash 1,-24
	popj 17,

load16_1:
	move 1,s+4
	lsh 1,20
	ash 1,-24
	popj 17,

lptr16_1:
	move 1,4(1)
	lsh 1,20
	ash 1,-24
	popj 17,

lvptr16_1:
	move 1,4(1)
	lsh 1,20
	ash 1,-24
	popj 17,

lvload16_1:
	move 1,vs+4
	lsh 1,20
	ash 1,-24
	popj 17,

larr16_1:
	move 1,x16+1
	lsh 1,20
	ash 1,-24
	popj 17,

lvarr16_1:
	move 1,vx16+1
	lsh 1,20
	ash 1,-24
	popj 17,

load18_0:
	hlre 1,s+5
	popj 17,

lptr18_0:
	hlre 1,5(1)
	popj 17,

lvptr18_0:
	hlrz 1,5(1)
	hrre 1,1
	popj 17,

lvload18_0:
	hlrz 1,vs+5
	hrre 1,1
	popj 17,

larr18_0:
	hlre 1,x18+1
	popj 17,

lvarr18_0:
	hlrz 1,vx18+1
	hrre 1,1
	popj 17,

load18_1:
	hrre 1,s+5
	popj 17,

lptr18_1:
	hrre 1,5(1)
	popj 17,

lvptr18_1:
	hrrz 1,5(1)
	hrre 1,1
	popj 17,

lvload18_1:
	hrrz 1,vs+5
	hrre 1,1
	popj 17,

larr18_1:
	hrre 1,x18+1
	popj 17,

lvarr18_1:
	hrrz 1,vx18+1
	hrre 1,1
	popj 17,

load32_0:
	move 1,s+6
	ash 1,-4
	popj 17,

lptr32_0:
	move 1,6(1)
	ash 1,-4
	popj 17,

lvptr32_0:
	move 1,6(1)
	ash 1,-4
	popj 17,

lvload32_0:
	move 1,vs+6
	ash 1,-4
	popj 17,

larr32_0:
	move 1,x32+1
	ash 1,-4
	popj 17,

lvarr32_0:
	move 1,vx32+1
	ash 1,-4
	popj 17,

load6_sum:
	move 1,s
	ash 1,-36
	move 4,s
	lsh 4,6
	ash 4,-36
	add 1,4
	move 4,s
	lsh 4,14
	ash 4,-36
	add 1,4
	move 4,s
	lsh 4,22
	ash 4,-36
	add 1,4
	move 4,s
	lsh 4,30
	ash 4,-36
	add 1,4
	move 4,s
	lsh 4,36
	ash 4,-36
	add 1,4
	popj 17,

load7_sum:
	move 1,s+1
	ash 1,-35
	move 4,s+1
	lsh 4,7
	ash 4,-35
	add 1,4
	move 4,s+1
	lsh 4,16
	ash 4,-35
	add 1,4
	move 4,s+1
	lsh 4,25
	ash 4,-35
	add 1,4
	move 4,s+1
	lsh 4,34
	ash 4,-35
	add 1,4
	popj 17,

load8_sum:
	move 1,s+2
	ash 1,-34
	move 4,s+2
	lsh 4,10
	ash 4,-34
	add 1,4
	move 4,s+2
	lsh 4,20
	ash 4,-34
	add 1,4
	move 4,s+2
	lsh 4,30
	ash 4,-34
	add 1,4
	popj 17,

load9_sum:
	move 1,s+3
	ash 1,-33
	move 4,s+3
	lsh 4,11
	ash 4,-33
	add 1,4
	move 4,s+3
	lsh 4,22
	ash 4,-33
	add 1,4
	move 4,s+3
	lsh 4,33
	ash 4,-33
	add 1,4
	popj 17,

load16_sum:
	move 1,s+4
	ash 1,-24
	move 4,s+4
	lsh 4,20
	ash 4,-24
	add 1,4
	popj 17,

load18_sum:
	hlre 1,s+5
	hrre 4,s+5
	add 1,4
	popj 17,

load_mixed_sum:
	move 1,s
	ash 1,-36
	move 4,s+1
	lsh 4,7
	ash 4,-35
	add 1,4
	move 4,s+2
	lsh 4,20
	ash 4,-34
	add 1,4
	move 4,s+3
	lsh 4,33
	ash 4,-33
	add 1,4
	move 4,s+4
	lsh 4,20
	ash 4,-24
	add 1,4
	hlre 4,s+5
	add 1,4
	move 4,s+6
	ash 4,-4
	add 1,4
	popj 17,

load_ptr_mixed_sum:
	move 3,1
	move 1,(1)
	lsh 1,36
	ash 1,-36
	move 4,1(3)
	lsh 4,34
	ash 4,-35
	add 1,4
	move 4,2(3)
	lsh 4,30
	ash 4,-34
	add 1,4
	move 4,3(3)
	lsh 4,22
	ash 4,-33
	add 1,4
	move 4,4(3)
	ash 4,-24
	add 1,4
	hrre 4,5(3)
	add 1,4
	move 4,6(3)
	ash 4,-4
	add 1,4
	popj 17,

load_volatile_mixed_sum:
	move 3,1
	ldb 1,[POINT 9,(1),8]
	lsh 1,33
	ash 1,-36
	addi 3,1
	hlrz 4,(3)
	subi 3,1
	lsh 4,31
	ash 4,-35
	add 1,4
	move 4,2(3)
	lsh 4,20
	ash 4,-34
	add 1,4
	ldb 4,[POINT 9,3(3),35]
	lsh 4,33
	ash 4,-33
	add 1,4
	move 4,4(3)
	lsh 4,20
	ash 4,-24
	add 1,4
	hlrz 4,5(3)
	hrre 4,4
	add 1,4
	move 4,6(3)
	ash 4,-4
	add 1,4
	popj 17,

lidx6:
	setzb 4,5
	move 4,1
	andi 4,17
	idivi 4,14
	move 4,[POINT 6,x6,5]
	move 0,5
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

lidx7:
	setzb 4,5
	move 4,1
	andi 4,17
	idivi 4,12
	move 4,[POINT 7,x7,6]
	move 0,5
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

lidx8:
	andi 1,7
	move 4,[POINT 8,x8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

lidx9:
	andi 1,7
	move 4,[POINT 9,x9,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

lidx16:
	andi 1,3
	move 4,[POINT 18,x16,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 1,(4)
	ash 1,-24
	popj 17,

lidx18:
	andi 1,3
	move 4,[POINT 18,x18,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

lidx32:
	andi 1,1
	move 1,x32(1)
	ash 1,-4
	popj 17,

lvindex6:
	setzb 4,5
	move 4,1
	andi 4,17
	idivi 4,14
	move 4,[POINT 6,vx6,5]
	move 0,5
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

lvindex7:
	setzb 4,5
	move 4,1
	andi 4,17
	idivi 4,12
	move 4,[POINT 7,vx7,6]
	move 0,5
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

lvindex8:
	andi 1,7
	move 4,[POINT 8,vx8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

lvindex9:
	andi 1,7
	move 4,[POINT 9,vx9,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

lvindex16:
	andi 1,3
	move 4,[POINT 18,vx16,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	lsh 1,22
	ash 1,-24
	popj 17,

lvindex18:
	andi 1,3
	move 4,[POINT 18,vx18,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

lvindex32:
	andi 1,1
	move 1,vx32(1)
	ash 1,-4
	popj 17,

lidx6_add:
	setzb 4,5
	move 4,1
	andi 4,17
	idivi 4,14
	move 4,[POINT 6,x6,5]
	move 0,5
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	add 1,2
	popj 17,

lidx7_sub:
	setzb 4,5
	move 4,1
	andi 4,17
	idivi 4,12
	move 4,[POINT 7,x7,6]
	move 0,5
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	sub 1,2
	popj 17,

lidx8_neg:
	andi 1,7
	move 4,[POINT 8,x8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	movn 1,1
	popj 17,

lidx9_shift:
	andi 1,7
	move 4,[POINT 9,x9,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 1,(4)
	ash 1,-35
	popj 17,

lidx16_shift:
	andi 1,3
	move 4,[POINT 18,x16,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 1,(4)
	ash 1,-24
	lsh 1,22
	ash 1,-26
	popj 17,

lidx18_shift:
	andi 1,3
	move 4,[POINT 18,x18,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	ash 1,-11
	hrre 1,1	; extendhisi2
	popj 17,

lidx32_shift:
	andi 1,1
	move 1,x32(1)
	ash 1,-4
	ash 1,-20
	popj 17,

load6_branch_negative:
	seto 1,
	skipge s
	popj 17,
	move 4,s
	ash 4,-36
	move 1,4
	popj 17,

load7_branch_negative:
	move 4,s+1
	lsh 4,7
	ash 4,-35
	seto 1,
	jumpl 4,%L177
	move 1,4
%L177:
	popj 17,

load8_branch_negative:
	move 4,s+2
	lsh 4,20
	ash 4,-34
	seto 1,
	jumpl 4,%L179
	move 1,4
%L179:
	popj 17,

load9_branch_negative:
	move 1,s+3
	lsh 1,33
	ash 1,-33
	camge 1,[-1]
	seto 1,
	popj 17,

load16_branch_negative:
	move 4,s+4
	lsh 4,20
	ash 4,-24
	seto 1,
	jumpl 4,%L183
	move 1,4
%L183:
	popj 17,

load18_branch_negative:
	hlre 1,s+5
	camge 1,[-1]
	seto 1,
	popj 17,

load32_branch_negative:
	move 1,s+6
	ash 1,-4
	camge 1,[-1]
	seto 1,
	popj 17,

load6_branch_zero:
	move 4,s
	andi 4,77
	movei 1,1
	jumpe 4,%L189
	move 4,s
	lsh 4,36
	ash 4,-36
	move 1,4
%L189:
	popj 17,

load9_branch_zero:
	move 4,s+3
	lsh 4,11
	ash 4,-33
	movei 1,1
	jumpe 4,%L191
	move 1,4
%L191:
	popj 17,

load18_branch_zero:
	hrre 4,s+5
	movei 1,1
	jumpe 4,%L193
	move 1,4
%L193:
	popj 17,

load32_branch_zero:
	move 4,s+6
	movei 1,1
	tdnn 4,[-20]
	popj 17,
	move 1,4
	ash 1,-4
	popj 17,

ptr_load6_branch:
	seto 4,
	skipge (1)
	jrst %L197
	move 4,(1)
	ash 4,-36
%L197:
	move 1,4
	popj 17,

ptr_load9_branch:
	move 1,3(1)
	lsh 1,22
	ash 1,-33
	camge 1,[-1]
	seto 1,
	popj 17,

ptr_load18_branch:
	hrre 1,5(1)
	camge 1,[-1]
	seto 1,
	popj 17,

ptr_load32_branch:
	move 1,6(1)
	ash 1,-4
	camge 1,[-1]
	seto 1,
	popj 17,

load6_compare_const:
	move 1,s
	and 1,[-10000000000]
	movsi 6,770000
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

load7_compare_const:
	move 1,s+1
	and 1,[3760000000]
	movsi 6,3760
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

load8_compare_const:
	move 1,s+2
	and 1,[3770000]
	move 6,[3770000]
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

load9_compare_const:
	move 1,s+3
	lsh 1,33
	ash 1,-33
	seto 6,
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

load16_compare_const:
	move 1,s+4
	and 1,[-4000000]
	movsi 6,777774
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

load18_compare_const:
	hrre 1,s+5
	seto 6,
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

load32_compare_const:
	move 1,s+6
	andcmi 1,17
	hrroi 6,777760
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

load6_store_result:
	move 4,1
	move 1,s
	ash 1,-36
	movem 1,(4)
	popj 17,

load9_store_result:
	move 4,1
	move 1,s+3
	lsh 1,11
	ash 1,-33
	movem 1,(4)
	popj 17,

load18_store_result:
	move 4,1
	hrre 1,s+5
	movem 1,(4)
	popj 17,

load32_store_result:
	move 4,1
	move 1,s+6
	ash 1,-4
	movem 1,(4)
	popj 17,

load6_call_pressure:
	push 17,10
	move 10,s
	ash 10,-36
	pushj 17,clobber
	move 4,s
	lsh 4,6
	ash 4,-36
	add 10,4
	move 1,10
	pop 17,10
	popj 17,

load9_call_pressure:
	push 17,10
	move 10,s+3
	ash 10,-33
	pushj 17,clobber
	move 4,s+3
	lsh 4,11
	ash 4,-33
	add 10,4
	move 1,10
	pop 17,10
	popj 17,

load18_call_pressure:
	push 17,10
	hlre 10,s+5
	pushj 17,clobber
	hrre 4,s+5
	add 10,4
	move 1,10
	pop 17,10
	popj 17,

load32_call_pressure:
	push 17,10
	move 10,s+6
	ash 10,-4
	pushj 17,clobber
	move 4,s+6
	ash 4,-4
	add 10,4
	move 1,10
	pop 17,10
	popj 17,

load_array_sum6:
	setzb 2,3
	setzb 7,6
	caml 7,1
	jrst %L234
	move 5,[POINT 6,x6,5]
	subi 1,1
%L235:
	move 2,6
	idivi 2,14
	move 4,5
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,40
	orcmi 4,77
	add 7,4
	addi 6,1
	sojge 1,%L235	; doloop_end
%L234:
	move 1,7
	popj 17,

load_array_sum7:
	setzb 2,3
	setzb 7,6
	caml 7,1
	jrst %L243
	move 5,[POINT 7,x7,6]
	subi 1,1
%L244:
	move 2,6
	idivi 2,12
	move 4,5
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,100
	orcmi 4,177
	add 7,4
	addi 6,1
	sojge 1,%L244	; doloop_end
%L243:
	move 1,7
	popj 17,

load_array_sum8:
	setzb 2,3
	caml 2,1
	jrst %L252
	move 6,[POINT 8,x8,7]
	subi 1,1
%L253:
	move 4,3
	andi 4,7
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	trne 4,200
	orcmi 4,377
	add 2,4
	addi 3,1
	sojge 1,%L253	; doloop_end
%L252:
	move 1,2
	popj 17,

load_array_sum9:
	setzb 2,3
	caml 2,1
	jrst %L261
	move 6,[POINT 9,x9,8]
	subi 1,1
%L262:
	move 4,3
	andi 4,7
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	trne 4,400
	orcmi 4,777
	add 2,4
	addi 3,1
	sojge 1,%L262	; doloop_end
%L261:
	move 1,2
	popj 17,

load_array_sum16:
	setzb 2,3
	caml 2,1
	jrst %L270
	move 6,[POINT 18,x16,17]
	subi 1,1
%L271:
	move 4,3
	andi 4,3
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	move 4,(7)
	ash 4,-24
	add 2,4
	addi 3,1
	sojge 1,%L271	; doloop_end
%L270:
	move 1,2
	popj 17,

load_array_sum18:
	setzb 2,3
	caml 2,1
	jrst %L279
	move 6,[POINT 18,x18,17]
	subi 1,1
%L280:
	move 4,3
	andi 4,3
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	hrre 4,4
	add 2,4
	addi 3,1
	sojge 1,%L280	; doloop_end
%L279:
	move 1,2
	popj 17,

load_array_sum32:
	setzb 2,3
	caml 2,1
	jrst %L288
	subi 1,1
%L289:
	move 4,3
	andi 4,1
	move 4,x32(4)
	ash 4,-4
	add 2,4
	addi 3,1
	sojge 1,%L289	; doloop_end
%L288:
	move 1,2
	popj 17,

load_word_manual_6:
	ash 1,-36
	popj 17,

load_word_manual_7:
	lsh 1,7
	ash 1,-35
	popj 17,

load_word_manual_8:
	lsh 1,10
	ash 1,-34
	popj 17,

load_word_manual_9:
	lsh 1,11
	ash 1,-33
	popj 17,

load_word_manual_16:
	lsh 1,20
	ash 1,-24
	popj 17,

load_word_manual_18_left:
	hlre 1,1
	popj 17,

load_word_manual_18_right:
	hrre 1,1
	popj 17,

load_word_manual_32:
	lsh 1,4
	ash 1,-4
	popj 17,

load_word_manual_var:
	andi 2,17
	lsh 1,(2)
	ash 1,-33
	popj 17,

load9_1_original_shape:
	move 1,s+3
	lsh 1,11
	ash 1,-33
	popj 17,

	.bss
s:
	.space	28
vs:
	.space	28
x6:
	.space	12
x7:
	.space	12
x8:
	.space	8
x9:
	.space	8
x16:
	.space	8
x18:
	.space	8
x32:
	.space	8
vx6:
	.space	12
vx7:
	.space	12
vx8:
	.space	8
vx9:
	.space	8
vx16:
	.space	8
vx18:
	.space	8
vx32:
	.space	8
