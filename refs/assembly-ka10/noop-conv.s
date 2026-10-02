	.data
	.align	2
g_int_from_char:
	.long	gi
	.align	2
g_int_from_uchar:
	.long	gi
	.align	2
g_sint_from_char:
	.long	gs
	.align	2
g_char_from_int:
	.long	gi
	.align	2
g_char6_from_char:
	.long	gc6+32312918016
	.align	2
g_h18_from_char:
	.long	gh18+19629342720

noop:
	popj 17,

noop_int_uchar:
	popj 17,

noop_int_schar:
	popj 17,

noop_int_void:
	popj 17,

noop_uint_char:
	popj 17,

noop_sint_char:
	popj 17,

noop_usint_char:
	popj 17,

noop_dint_char:
	popj 17,

noop_char_int:
	hrrz 1,1
	jumpe 1,%L24
	move 4,1
	tlo 4,331100
%L24:
	move 1,4
	popj 17,

noop_uchar_int:
	hrrz 1,1
	jumpe 1,%L27
	move 4,1
	tlo 4,331100
%L27:
	move 1,4
	popj 17,

noop_char6_char:
	popj 17,

noop_char7_char:
	popj 17,

noop_char8_char:
	popj 17,

noop_char9_char:
	popj 17,

noop_uchar6_uchar:
	popj 17,

noop_uchar7_uchar:
	popj 17,

noop_uchar8_uchar:
	popj 17,

noop_uchar9_uchar:
	popj 17,

noop_short16_char:
	jumpe 1,%L55
	move 3,1
	tlc 3,113300
%L55:
	jumpe 3,%L54
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L54:
	move 1,4
	popj 17,

noop_ushort16_uchar:
	jumpe 1,%L58
	move 3,1
	tlc 3,113300
%L58:
	jumpe 3,%L57
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L57:
	move 1,4
	popj 17,

noop_short18_char:
	jumpe 1,%L61
	move 3,1
	tlc 3,113300
%L61:
	jumpe 3,%L60
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L60:
	move 1,4
	popj 17,

noop_ushort18_uchar:
	jumpe 1,%L64
	move 3,1
	tlc 3,113300
%L64:
	jumpe 3,%L63
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L63:
	move 1,4
	popj 17,

noop_int_char6:
	popj 17,

noop_int_char9:
	popj 17,

noop_sint_short18:
	popj 17,

load_noop_int:
	pushj 17,noop
	move 1,(1)
	popj 17,

store_noop_int:
	push 17,10
	move 10,2
	pushj 17,noop
	movem 10,(1)
	pop 17,10
	popj 17,

load_noop_sint:
	pushj 17,noop_sint_char
	move 1,(1)
	popj 17,

store_noop_sint:
	push 17,10
	move 10,2
	pushj 17,noop_sint_char
	movem 10,(1)
	pop 17,10
	popj 17,

load_noop_char6:
	pushj 17,noop_char6_char
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

store_noop_char6:
	push 17,10
	move 10,2
	lsh 10,36
	ash 10,-36
	pushj 17,noop_char6_char
	dpb 10,1
	pop 17,10
	popj 17,

load_noop_short18:
	pushj 17,noop_short18_char
	ldb 1,1
	hrre 1,1
	popj 17,

store_noop_short18:
	push 17,10
	move 10,2
	hrrzi 10,(10)	; zero_extendhisi2
	pushj 17,noop_short18_char
	dpb 10,1	; movhi
	pop 17,10
	popj 17,

noop_int_plus:
	push 17,10
	move 10,2
	pushj 17,noop
	add 1,10
	pop 17,10
	popj 17,

noop_char6_plus:
	push 17,10
	move 10,2
	pushj 17,noop_char6_char
	jumple 10,%L84
%L83:
	ibp 1
	sojg 10,%L83	; decrement_and_branch_until_zero
%L84:
	jumpe 10,%L86
%L85:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 10,%L85
%L86:
	pop 17,10
	popj 17,

noop_short18_plus:
	push 17,10
	move 10,2
	pushj 17,noop_short18_char
	move 4,10
	andi 4,1
	ash 10,-1	; ashrsi3_pointer
	add 1,10
	jumpe 4,%L90
%L89:
	ibp 1
	sojn 4,%L89	; decrement_and_branch_until_zero
%L90:
	pop 17,10
	popj 17,

noop_int_diff:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	pushj 17,noop
	move 10,1
	move 1,11
	pushj 17,noop
	sub 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

noop_char6_diff:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,2
	pushj 17,noop_char6_char
	move 13,1
	move 1,12
	pushj 17,noop_char6_char
	move 10,13
	sub 10,1
	muli 10,14
	move 1,11
	ash 1,-1
	add 1,%BADL6(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

noop_short18_diff:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,2
	pushj 17,noop_short18_char
	move 13,1
	move 1,12
	pushj 17,noop_short18_char
	move 10,13
	sub 10,1
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

noop_compare_int:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 11,2
	pushj 17,noop
	move 10,1
	move 1,11
	pushj 17,noop_int_uchar
	movei 4,1
	camn 10,1
	jrst %L100
	move 1,12
	pushj 17,noop_int_char6
	move 10,1
	move 1,11
	pushj 17,noop_int_char9
	camn 10,1
	tdza 4,4
	movei 4,1
	lsh 4,1
%L100:
	move 1,4
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

noop_volatile_int:
	movem 1,v_intp
	move 1,v_intp
	popj 17,

noop_volatile_sint:
	movem 1,v_sintp
	move 1,v_sintp
	popj 17,

noop_volatile_char:
	movem 1,v_charp
	move 4,v_charp
	hrrz 4,4
	jumpe 4,%L108
	move 3,4
	tlo 3,331100
%L108:
	move 1,3
	popj 17,

noop_volatile_char6:
	movem 1,v_char6p
	move 1,v_char6p
	popj 17,

noop_volatile_h18:
	movem 1,v_h18p
	move 4,v_h18p
	jumpe 4,%L115
	move 2,4
	tlc 2,113300
%L115:
	jumpe 2,%L114
	move 3,2
	tlc 3,3300
	tlz 3,110000
%L114:
	move 1,3
	popj 17,

call_noop_int:
	jrst use_intp

call_noop_sint:
	jrst use_sintp

call_noop_char6:
	jrst use_char6p

call_noop_short18:
	jumpe 1,%L129
	move 3,1
	tlc 3,113300
%L129:
	jumpe 3,%L128
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L128:
	move 1,4
	jrst use_short18p

	.globl	use_noop_conv
use_noop_conv:
	add 17,[13,,13]
	movem 16,-12(17)
	movem 10,-11(17)
	movem 11,-10(17)
	movem 13,-7(17)
	movem 14,-6(17)
	movem 15,-5(17)
	setzm -3(17)
	setzm -2(17)
	setzm -1(17)
	setzm (17)
	move 16,1
	movem 2,-4(17)
	move 13,3
	move 15,4
	move 11,-15(17)
	move 2,11
	pushj 17,store_noop_int
	move 1,-4(17)
	move 2,11
	pushj 17,store_noop_sint
	move 2,11
	lsh 2,36
	ash 2,-36
	move 1,15
	pushj 17,store_noop_char6
	hrre 2,11	; extendhisi2
	move 1,-14(17)
	pushj 17,store_noop_short18
	move 1,16
	pushj 17,call_noop_int
	move 1,-4(17)
	pushj 17,call_noop_sint
	move 1,15
	pushj 17,call_noop_char6
	move 1,-14(17)
	pushj 17,call_noop_short18
	move 1,16
	pushj 17,load_noop_int
	move 10,1
	move 1,-4(17)
	pushj 17,load_noop_sint
	add 10,1
	move 1,13
	pushj 17,noop_dint_char
	add 10,1(1)
	move 1,15
	pushj 17,load_noop_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,-14(17)
	pushj 17,load_noop_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 14,11
	andi 14,3
	move 1,16
	move 2,14
	pushj 17,noop_int_plus
	sub 1,16
	add 10,1
	andi 11,7
	move 1,15
	move 2,11
	pushj 17,noop_char6_plus
	sub 1,15
	movem 1,-3(17)
	move 6,1
	muli 6,14
	move 4,7
	ash 4,-1
	add 4,%BADL6(6)
	add 10,4
	move 1,-14(17)
	move 2,14
	pushj 17,noop_short18_plus
	sub 1,-14(17)
	movem 1,-1(17)
	move 6,1
	muli 6,4
	move 4,7
	ash 4,-1
	add 4,%BADLH(6)
	add 10,4
	movei 1,gi
	move 2,g_int_from_char
	pushj 17,noop_int_diff
	add 10,1
	move 1,[POINT 6,gc6,5]
	move 2,g_char6_from_char
	pushj 17,noop_char6_diff
	add 10,1
	move 1,[POINT 18,gh18,17]
	move 2,g_h18_from_char
	pushj 17,noop_short18_diff
	add 10,1
	move 1,16
	move 2,g_int_from_uchar
	pushj 17,noop_compare_int
	add 10,1
	move 1,16
	pushj 17,noop_volatile_int
	came 1,16
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,-4(17)
	pushj 17,noop_volatile_sint
	came 1,-4(17)
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 9,gc,8]
	pushj 17,noop_volatile_char
	move 7,[POINT 9,gc,8]
	came 1,7
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,15
	pushj 17,noop_volatile_char6
	came 1,15
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,-14(17)
	pushj 17,noop_volatile_h18
	came 1,-14(17)
	tdza 1,1
	movei 1,1
	add 10,1
	movei 1,gui
	pushj 17,noop_uint_char
	movei 6,gui
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	movei 1,gus
	pushj 17,noop_usint_char
	movei 7,gus
	came 1,7
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 9,gc,8]
	pushj 17,noop_char_int
	move 6,[POINT 9,gc,8]
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 9,guc,8]
	pushj 17,noop_uchar_int
	move 7,[POINT 9,guc,8]
	came 1,7
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 7,gc7,6]
	pushj 17,noop_char7_char
	move 6,[POINT 7,gc7,6]
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 8,gc8,7]
	pushj 17,noop_char8_char
	move 7,[POINT 8,gc8,7]
	came 1,7
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 9,gc9,8]
	pushj 17,noop_char9_char
	move 6,[POINT 9,gc9,8]
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 6,gc6,5]
	pushj 17,noop_uchar6_uchar
	move 7,[POINT 6,gc6,5]
	came 1,7
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 7,gc7,6]
	pushj 17,noop_uchar7_uchar
	move 6,[POINT 7,gc7,6]
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 8,gc8,7]
	pushj 17,noop_uchar8_uchar
	move 7,[POINT 8,gc8,7]
	came 1,7
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 9,gc9,8]
	pushj 17,noop_uchar9_uchar
	move 6,[POINT 9,gc9,8]
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 18,gh16,17]
	pushj 17,noop_short16_char
	move 7,[POINT 18,gh16,17]
	came 1,7
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,7
	pushj 17,noop_ushort16_uchar
	move 6,[POINT 18,gh16,17]
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 18,gh18,17]
	pushj 17,noop_ushort18_uchar
	move 7,[POINT 18,gh18,17]
	came 1,7
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,-4(17)
	pushj 17,noop_sint_short18
	came 1,-4(17)
	tdza 1,1
	movei 1,1
	add 10,1
	move 6,g_sint_from_char
	movei 7,gs
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 6,g_char_from_int
	movei 7,gi
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	add 10,gd+1
	move 1,10
	move 16,-12(17)
	move 10,-11(17)
	move 11,-10(17)
	move 13,-7(17)
	move 14,-6(17)
	move 15,-5(17)
	add 17,[-13,,-13]
	popj 17,

	.bss
gi:
	.space	4
gui:
	.space	4
gs:
	.space	4
gus:
	.space	4
gd:
	.space	8
gc:
	.space	12
guc:
	.space	12
gc6:
	.space	12
gc7:
	.space	12
gc8:
	.space	12
gc9:
	.space	12
gh16:
	.space	16
gh18:
	.space	16
v_intp:
	.space	4
v_sintp:
	.space	4
v_charp:
	.space	4
v_char6p:
	.space	4
v_h18p:
	.space	4
