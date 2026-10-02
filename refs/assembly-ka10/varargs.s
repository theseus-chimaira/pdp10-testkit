	.data
	.align	2
gvpair:
	.long	1
	.long	2
	.align	2
gvdpair:
	.long	0
	.long	3
	.long	68719476735
	.long	68719476732

add1:
	addi 1,1
	popj 17,

sub1:
	subi 1,1
	popj 17,

neg1:
	movn 1,1
	popj 17,

sink_int:
	movem 1,gv0
	popj 17,

sink_dint:
	movem 1,gdbuf
	movem 2,gdbuf+1
	popj 17,

sum_mixed:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,11
	move 2,10
	pushj 17,__builtin_va_start
	move 4,11
	subi 4,1
	move 2,-3(4)
	move 1,10
	add 1,(4)
	add 1,-1(4)
	move 3,-2(4)
	andi 3,777
	add 1,3
	hrre 2,2	; extendhisi2
	add 1,2
	add 1,-4(4)
	skipe 4,-5(4)
	add 1,(4)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_many_ints:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,11
	move 2,10
	pushj 17,__builtin_va_start
	move 4,11
	subi 4,1
	add 10,(4)
	add 10,-1(4)
	add 10,-2(4)
	add 10,-3(4)
	add 10,-4(4)
	add 10,-5(4)
	add 10,-6(4)
	add 10,-7(4)
	add 10,-10(4)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

xor_unsigned_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 4,0
	caml 4,11
	jrst %L16
	move 1,11
	subi 1,1
%L17:
	subi 10,1
	xor 4,(10)
	sojge 1,%L17	; doloop_end
%L16:
	move 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_char_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,11
	jrst %L25
	move 1,11
	subi 1,1
%L26:
	subi 10,1
	move 4,(10)
	andi 4,777
	add 3,4
	sojge 1,%L26	; doloop_end
%L25:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_signed_char_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,11
	jrst %L34
	move 1,11
	subi 1,1
%L35:
	subi 10,1
	move 4,(10)
	lsh 4,33
	ash 4,-33
	add 3,4
	sojge 1,%L35	; doloop_end
%L34:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_unsigned_char_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,11
	jrst %L43
	move 1,11
	subi 1,1
%L44:
	subi 10,1
	move 4,(10)
	andi 4,777
	add 3,4
	sojge 1,%L44	; doloop_end
%L43:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_short_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,11
	jrst %L52
	move 1,11
	subi 1,1
%L53:
	subi 10,1
	hrre 4,(10)
	add 3,4
	sojge 1,%L53	; doloop_end
%L52:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_ushort_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,11
	jrst %L61
	move 1,11
	subi 1,1
%L62:
	subi 10,1
	hrrz 4,(10)
	add 3,4
	sojge 1,%L62	; doloop_end
%L61:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_qi_promoted_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,11
	jrst %L70
	move 1,11
	subi 1,1
%L71:
	subi 10,1
	move 4,(10)
	lsh 4,33
	ash 4,-33
	add 3,4
	sojge 1,%L71	; doloop_end
%L70:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_hi_promoted_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,11
	jrst %L79
	move 1,11
	subi 1,1
%L80:
	subi 10,1
	move 4,(10)
	hrre 4,4	; extendhisi2
	add 3,4
	sojge 1,%L80	; doloop_end
%L79:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_sized_promoted_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,11
	move 2,10
	pushj 17,__builtin_va_start
	move 3,11
	subi 3,1
	move 2,-3(3)
	move 6,-5(3)
	ldb 1,[POINT 9,(3),35]
	lsh 1,36
	ash 1,-36
	ldb 4,[POINT 9,-1(3),35]
	lsh 4,35
	ash 4,-35
	add 1,4
	ldb 4,[POINT 9,-2(3),35]
	lsh 4,34
	ash 4,-34
	add 1,4
	lsh 2,33
	ash 2,-33
	hrrz 4,-4(3)
	lsh 4,24
	ash 4,-24
	add 2,4
	add 1,2
	hrre 6,6	; extendhisi2
	add 6,-6(3)
	add 1,6
	add 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_ptr_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,11
	jrst %L90
	move 1,11
	subi 1,1
%L91:
	subi 10,1
	skipe 4,(10)
	add 3,(4)
	sojge 1,%L91	; doloop_end
%L90:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_byte_ptr_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,11
	move 2,10
	pushj 17,__builtin_va_start
	move 2,11
	subi 2,1
	move 4,-1(2)
	ildb 1,4
	ldb 6,(2)
	add 1,6
	add 1,10
	move 4,-2(2)
	ibp 4
	ildb 3,4
	trne 3,40
	orcmi 3,77
	move 4,-3(2)
	ibp 4
	ibp 4
	ildb 4,4
	trne 4,100
	orcmi 4,177
	add 3,4
	move 4,-4(2)
	addi 4,1
	ldb 4,4
	trne 4,200
	orcmi 4,377
	add 3,4
	move 4,-5(2)
	addi 4,1
	ildb 4,4
	trne 4,400
	orcmi 4,777
	add 3,4
	add 1,3
	ldb 3,-6(2)
	lsh 3,24
	ash 3,-24
	move 4,-7(2)
	ibp 4
	ldb 4,4
	hrre 4,4
	add 3,4
	add 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_machine_ptr_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,11
	move 2,10
	pushj 17,__builtin_va_start
	move 4,11
	subi 4,1
	move 7,-6(4)
	move 6,-7(4)
	move 2,-10(4)
	ldb 1,(4)
	trne 1,400
	orcmi 1,777
	ldb 5,-1(4)
	add 1,5
	ldb 3,-2(4)
	hrre 3,3
	add 1,3
	ldb 5,-3(4)
	add 1,5
	add 1,10
	move 5,@-4(4)
	add 5,@-5(4)
	add 1,5
	move 4,1(7)
	add 4,1(6)
	add 1,4
	move 4,(2)
	add 4,1(2)
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_dint_va:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 1,12
	move 2,13
	pushj 17,__builtin_va_start
	setzb 6,7
	jumple 13,%L101
	move 1,13
	subi 1,1
%L102:
	subi 12,2
	move 10,(12)
	move 11,1(12)
	move 5,7
	add 5,11
	move 3,5
	tlc 3,400000
	move 2,7
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,10
	add 4,3
	move 6,4
	move 7,5
	sojge 1,%L102	; doloop_end
%L101:
	move 1,6
	move 2,7
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

xor_udint_va:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 1,12
	move 2,13
	pushj 17,__builtin_va_start
	setzb 1,2
	jumple 13,%L110
	move 6,13
	subi 6,1
%L111:
	subi 12,2
	move 10,(12)
	move 11,1(12)
	move 4,1
	xor 4,10
	move 5,2
	xor 5,11
	move 1,4
	move 2,5
	sojge 6,%L111	; doloop_end
%L110:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

mixed_dint_va:
	add 17,[14,,14]
	movem 16,-13(17)
	movei 0,-12(17)
	hrli 0,10
	blt 0,-5(17)
	setzm -3(17)
	setzm -2(17)
	setzm -1(17)
	setzm (17)
	movem 1,-4(17)
	move 1,16
	move 2,-4(17)
	pushj 17,__builtin_va_start
	move 4,16
	subi 4,2
	move 10,(4)
	move 11,1(4)
	move 12,-2(4)
	move 13,-1(4)
	move 1,-3(4)
	move 7,-4(4)
	move 5,11
	add 5,13
	move 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,12
	add 4,3
	move 14,(1)
	move 15,1(1)
	move 3,5
	add 3,15
	move 1,3
	tlc 1,400000
	move 6,5
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 2,4
	add 2,14
	add 2,1
	move 6,(7)
	movem 6,-3(17)
	move 6,1(7)
	movem 6,-2(17)
	move 5,6
	add 5,3
	move 1,5
	tlc 1,400000
	move 6,3
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 4,-3(17)
	add 4,2
	add 4,1
	move 2,2(7)
	movem 2,-1(17)
	move 7,3(7)
	movem 7,(17)
	move 7,5
	move 3,(17)
	sub 7,3
	move 3,7
	tlc 3,400000
	move 2,5
	tlc 2,400000
	camg 3,2
	tdza 3,3
	movei 3,1
	move 6,4
	move 2,-1(17)
	sub 6,2
	sub 6,3
	move 5,-4(17)
	move 3,5
	ash 3,-43
	move 4,3
	move 2,7
	add 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	add 1,4
	add 1,3
	move 16,-13(17)
	movei 0,10
	hrli 0,-12(17)
	blt 0,15
	add 17,[-14,,-14]
	popj 17,

call_int_fn_va:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 1,10
	move 2,11
	pushj 17,__builtin_va_start
	move 4,10
	subi 4,1
	move 12,-1(4)
	move 1,11
	pushj 17,@(4)
	move 10,1
	aos 1,11
	pushj 17,(12)
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

consume_with_callback:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,11
	move 2,10
	pushj 17,__builtin_va_start
	move 4,11
	subi 4,1
	add 10,-1(4)
	move 1,10
	pushj 17,@@(4)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_pairs_va:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 1,12
	move 2,13
	pushj 17,__builtin_va_start
	movei 3,0
	caml 3,13
	jrst %L122
	move 1,13
	subi 1,1
%L123:
	subi 12,2
	move 10,(12)
	move 11,1(12)
	move 4,10
	add 4,11
	add 3,4
	sojge 1,%L123	; doloop_end
%L122:
	move 1,3
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

restart_va:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 1,11
	move 2,10
	pushj 17,__builtin_va_start
	subi 11,1
	move 13,(11)
	move 1,11
	subi 1,1
	move 12,-1(11)
	move 2,10
	pushj 17,__builtin_va_start
	add 10,13
	add 10,12
	add 10,-2(11)
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

skip_and_read_va:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,11
	move 2,10
	pushj 17,__builtin_va_start
	move 4,11
	subi 4,1
	move 1,(4)
	move 3,-2(4)
	move 2,-3(4)
	skipn 4,-1(4)
	jrst %L126
	add 1,10
	add 1,(4)
%L127:
	add 1,3
	add 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L126:
	add 1,10
	jrst %L127

local_varargs_arrays:
	add 17,[32,,32]
	movem 10,-31(17)
	movem 1,-30(17)
	move 3,1
	addi 3,1
	movem 3,-27(17)
	move 2,1
	addi 2,2
	movem 2,-26(17)
	move 4,1
	addi 4,3
	movem 4,-25(17)
	move 6,1
	addi 6,4
	movem 6,-24(17)
	addi 6,1
	movem 6,-23(17)
	movem 1,-22(17)
	dpb 3,[POINT 9,-22(17),17]
	movem 2,-20(17)
	dpb 4,[POINT 9,-20(17),17]
	movem 1,-16(17)
	dpb 3,[POINT 9,-16(17),17]
	movem 2,-15(17)
	hrrm 4,-15(17)
	move 5,1
	ash 1,-43
	movem 1,-13(17)
	movem 5,-12(17)
	move 5,3
	ash 3,-43
	movem 3,-11(17)
	movem 5,-10(17)
	move 5,2
	ash 2,-43
	movem 2,-7(17)
	movem 5,-6(17)
	movei 4,-30(17)
	movem 4,(17)
	move 6,4
	addi 6,1
	movem 6,-1(17)
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-4(17)
	addi 4,5
	movem 4,-5(17)
	movei 1,6
	pushj 17,sum_ptr_va
	move 10,1
	move 4,-22(17)
	lsh 4,-33
	movem 4,(17)
	ldb 4,[POINT 9,-22(17),17]
	movem 4,-1(17)
	move 4,-20(17)
	lsh 4,-33
	movem 4,-2(17)
	ldb 4,[POINT 9,-20(17),17]
	movem 4,-3(17)
	movei 1,4
	pushj 17,sum_char_va
	add 10,1
	move 4,-16(17)
	ash 4,-33
	movem 4,(17)
	move 4,-16(17)
	lsh 4,11
	ash 4,-33
	movem 4,-1(17)
	movei 1,2
	pushj 17,sum_qi_promoted_va
	add 10,1
	move 6,-15(17)
	hlrem 6,(17)
	hrre 4,-15(17)
	movem 4,-1(17)
	movei 1,2
	pushj 17,sum_hi_promoted_va
	add 10,1
	move 6,-13(17)
	movem 6,-1(17)
	move 6,-12(17)
	movem 6,(17)
	move 6,-11(17)
	movem 6,-3(17)
	move 6,-10(17)
	movem 6,-2(17)
	move 6,-7(17)
	movem 6,-5(17)
	move 6,-6(17)
	movem 6,-4(17)
	movei 1,3
	pushj 17,sum_dint_va
	add 10,2
	move 1,10
	move 10,-31(17)
	add 17,[-32,,-32]
	popj 17,

	.globl	use_varargs
use_varargs:
	add 17,[35,,35]
	movem 16,-34(17)
	movei 0,-33(17)
	hrli 0,10
	blt 0,-26(17)
	move 11,1
	movem 1,gv0
	move 5,1
	addi 5,1
	movem 5,-21(17)
	movem 5,gv1
	addi 5,1
	movem 5,-20(17)
	movem 5,guv0
	addi 5,1
	movem 5,-17(17)
	movem 5,vgv0
	dpb 1,[POINT 9,gcbuf,8]
	move 5,-21(17)
	dpb 5,[POINT 9,gcbuf,17]
	move 5,-20(17)
	dpb 5,[POINT 9,gucbuf,8]
	move 5,-17(17)
	dpb 5,[POINT 9,gucbuf,17]
	dpb 1,[POINT 9,gqbuf,8]
	move 5,-21(17)
	dpb 5,[POINT 9,gqbuf,17]
	move 5,-20(17)
	dpb 5,[POINT 9,guqbuf,8]
	move 5,-17(17)
	hrlm 5,ghbuf
	move 5,1
	addi 5,4
	movem 5,-16(17)
	hrlm 5,guhbuf
	addi 5,1
	movem 5,-15(17)
	movem 5,gsbuf
	addi 5,1
	movem 5,-14(17)
	movem 5,gusbuf
	addi 5,1
	movem 5,-13(17)
	move 3,5
	ash 3,-43
	movem 3,gdbuf
	movem 5,gdbuf+1
	move 16,1
	addi 16,10
	move 3,16
	ash 3,-43
	movem 3,gudbuf
	movem 16,gudbuf+1
	dpb 1,[POINT 6,g6buf,17]
	move 5,-21(17)
	dpb 5,[POINT 7,g7buf,27]
	move 5,-20(17)
	dpb 5,[POINT 8,g8buf+1,7]
	move 5,-17(17)
	dpb 5,[POINT 9,g9buf+1,17]
	move 5,-16(17)
	dpb 5,[POINT 16,gs16buf,15]
	move 5,-15(17)
	hrrm 5,gs18buf
	move 3,1
	ash 3,-43
	move 4,3
	move 6,gvdpair
	move 7,gvdpair+1
	move 15,1
	add 15,7
	move 2,15
	tlc 2,400000
	move 3,1
	tlc 3,400000
	caml 2,3
	tdza 2,2
	movei 2,1
	movem 2,-12(17)
	move 14,4
	add 14,6
	addm 14,-12(17)
	move 14,-12(17)
	move 3,1
	addi 3,11
	move 5,3
	ash 3,-43
	move 4,3
	move 12,gvdpair+2
	move 13,gvdpair+3
	move 6,5
	sub 6,13
	movem 6,-24(17)
	move 2,6
	tlc 2,400000
	move 3,5
	tlc 3,400000
	camg 2,3
	tdza 3,3
	movei 3,1
	sub 4,12
	movem 4,-25(17)
	move 5,4
	sub 5,3
	movem 5,-11(17)
	movem 5,-25(17)
	addi 11,12
	move 13,11
	movei 12,0
	aos 5,11
	movem 5,-22(17)
	subi 11,13
	movei 6,0
	movem 6,-23(17)
	movem 14,vgvd0
	movem 15,vgvd0+1
	movem 11,(17)
	movei 5,2
	movem 5,-1(17)
	movei 6,101
	movem 6,-2(17)
	hrroi 5,777775
	movem 5,-3(17)
	movei 6,5
	movem 6,-4(17)
	movei 5,gv0
	movem 5,-5(17)
	movei 1,7
	pushj 17,sum_mixed
	move 10,1
	movem 11,(17)
	move 6,-21(17)
	movem 6,-1(17)
	move 5,-20(17)
	movem 5,-2(17)
	move 6,-17(17)
	movem 6,-3(17)
	move 5,-16(17)
	movem 5,-4(17)
	move 6,-15(17)
	movem 6,-5(17)
	move 5,-14(17)
	movem 5,-6(17)
	move 6,-13(17)
	movem 6,-7(17)
	movem 16,-10(17)
	movei 1,11
	pushj 17,sum_many_ints
	add 10,1
	movei 5,1
	movem 5,(17)
	movei 6,2
	movem 6,-1(17)
	movei 5,4
	movem 5,-2(17)
	movei 6,10
	movem 6,-3(17)
	move 5,guv0
	movem 5,-4(17)
	movei 1,5
	pushj 17,xor_unsigned_va
	add 10,1
	movei 6,141
	movem 6,(17)
	movei 5,142
	movem 5,-1(17)
	movei 6,143
	movem 6,-2(17)
	movem 11,-3(17)
	setom -4(17)
	movei 1,5
	pushj 17,sum_char_va
	add 10,1
	setom (17)
	movem 11,-1(17)
	movei 5,144
	movem 5,-2(17)
	movei 6,145
	movem 6,-3(17)
	movei 1,4
	pushj 17,sum_signed_char_va
	add 10,1
	movei 5,377
	movem 5,(17)
	movem 11,-1(17)
	movei 6,146
	movem 6,-2(17)
	movei 5,147
	movem 5,-3(17)
	movei 1,4
	pushj 17,sum_unsigned_char_va
	add 10,1
	movei 6,1
	movem 6,(17)
	movei 5,2
	movem 5,-1(17)
	movei 6,3
	movem 6,-2(17)
	movem 11,-3(17)
	hrroi 5,777774
	movem 5,-4(17)
	movei 1,5
	pushj 17,sum_short_va
	add 10,1
	movei 6,177777
	movem 6,(17)
	movem 11,-1(17)
	movei 5,5
	movem 5,-2(17)
	movei 6,6
	movem 6,-3(17)
	movei 1,4
	pushj 17,sum_ushort_va
	add 10,1
	move 4,gqbuf
	ash 4,-33
	movem 4,(17)
	move 4,guqbuf
	lsh 4,-33
	movem 4,-1(17)
	move 4,gcbuf
	lsh 4,-33
	movem 4,-2(17)
	move 4,gucbuf
	lsh 4,-33
	movem 4,-3(17)
	movei 1,4
	pushj 17,sum_qi_promoted_va
	add 10,1
	move 5,ghbuf
	hlrem 5,(17)
	move 6,guhbuf
	hlrzm 6,-1(17)
	move 4,gs16buf
	ash 4,-24
	movem 4,-2(17)
	hrre 4,gs18buf
	movem 4,-3(17)
	movei 1,4
	pushj 17,sum_hi_promoted_va
	add 10,1
	move 4,g6buf
	lsh 4,14
	ash 4,-36
	movem 4,(17)
	move 4,g7buf
	lsh 4,25
	ash 4,-35
	movem 4,-1(17)
	move 4,g8buf+1
	ash 4,-34
	movem 4,-2(17)
	move 4,g9buf+1
	lsh 4,11
	ash 4,-33
	movem 4,-3(17)
	move 4,gs16buf
	ash 4,-24
	movem 4,-4(17)
	hrre 4,gs18buf
	movem 4,-5(17)
	movem 11,-6(17)
	movei 1,7
	pushj 17,sum_sized_promoted_va
	add 10,1
	movei 5,gv0
	movem 5,(17)
	movei 6,gv1
	movem 6,-1(17)
	setzm -2(17)
	movei 5,vgv0
	movem 5,-3(17)
	movei 1,4
	pushj 17,sum_ptr_va
	add 10,1
	move 6,[POINT 9,gcbuf,8]
	movem 6,(17)
	move 5,[POINT 9,gucbuf,8]
	movem 5,-1(17)
	move 6,[POINT 6,g6buf,5]
	movem 6,-2(17)
	move 5,[POINT 7,g7buf,6]
	movem 5,-3(17)
	move 6,[POINT 8,g8buf,7]
	movem 6,-4(17)
	move 5,[POINT 9,g9buf,8]
	movem 5,-5(17)
	move 6,[POINT 18,gs16buf,17]
	movem 6,-6(17)
	move 5,[POINT 18,gs18buf,17]
	movem 5,-7(17)
	movei 1,10
	pushj 17,sum_byte_ptr_va
	add 10,1
	move 6,[POINT 9,gqbuf,8]
	movem 6,(17)
	move 5,[POINT 9,guqbuf,8]
	movem 5,-1(17)
	move 6,[POINT 18,ghbuf,17]
	movem 6,-2(17)
	move 5,[POINT 18,guhbuf,17]
	movem 5,-3(17)
	movei 6,gsbuf
	movem 6,-4(17)
	movei 5,gusbuf
	movem 5,-5(17)
	movei 6,gdbuf
	movem 6,-6(17)
	movei 5,gudbuf
	movem 5,-7(17)
	movei 6,gvpair
	movem 6,-10(17)
	movei 1,11
	pushj 17,sum_machine_ptr_va
	add 10,1
	move 5,-12(17)
	movem 5,-1(17)
	movem 15,(17)
	move 6,-11(17)
	movem 6,-3(17)
	move 5,-24(17)
	movem 5,-2(17)
	move 6,gdbuf
	movem 6,-5(17)
	move 5,gdbuf+1
	movem 5,-4(17)
	move 6,vgvd0
	movem 6,-7(17)
	move 5,vgvd0+1
	movem 5,-6(17)
	movei 1,4
	pushj 17,sum_dint_va
	add 10,2
	movem 12,-1(17)
	movem 13,(17)
	move 6,-23(17)
	movem 6,-3(17)
	move 5,-22(17)
	movem 5,-2(17)
	move 6,gudbuf
	movem 6,-5(17)
	move 5,gudbuf+1
	movem 5,-4(17)
	setzm -7(17)
	movei 6,17
	movem 6,-6(17)
	movei 1,4
	pushj 17,xor_udint_va
	add 10,2
	move 5,-12(17)
	movem 5,-1(17)
	movem 15,(17)
	movem 12,-3(17)
	movem 13,-2(17)
	movei 6,gdbuf
	movem 6,-4(17)
	movei 5,gvdpair
	movem 5,-5(17)
	movei 1,3
	pushj 17,mixed_dint_va
	add 10,2
	movei 6,add1
	movem 6,(17)
	movei 5,sub1
	movem 5,-1(17)
	move 1,11
	pushj 17,call_int_fn_va
	add 10,1
	movei 6,neg1
	movem 6,(17)
	movei 5,add1
	movem 5,-1(17)
	move 1,11
	pushj 17,call_int_fn_va
	add 10,1
	movei 6,sink_int
	movem 6,(17)
	movei 5,3
	movem 5,-1(17)
	move 1,11
	pushj 17,consume_with_callback
	move 6,-12(17)
	movem 6,-1(17)
	movem 15,(17)
	move 5,-11(17)
	movem 5,-3(17)
	move 6,-24(17)
	movem 6,-2(17)
	movei 1,2
	pushj 17,sum_dint_va
	pushj 17,sink_dint
	movem 11,-1(17)
	move 5,-21(17)
	movem 5,(17)
	move 6,-20(17)
	movem 6,-3(17)
	move 5,-17(17)
	movem 5,-2(17)
	movei 1,2
	pushj 17,sum_pairs_va
	add 10,1
	move 6,-21(17)
	movem 6,(17)
	move 5,-20(17)
	movem 5,-1(17)
	move 1,11
	pushj 17,restart_va
	add 10,1
	move 6,-21(17)
	movem 6,(17)
	movei 5,gv1
	movem 5,-1(17)
	move 6,-20(17)
	movem 6,-2(17)
	move 5,-17(17)
	movem 5,-3(17)
	move 1,11
	pushj 17,skip_and_read_va
	add 10,1
	move 1,11
	pushj 17,local_varargs_arrays
	add 10,1
	move 1,10
	move 16,-34(17)
	movei 0,10
	hrli 0,-33(17)
	blt 0,15
	add 17,[-35,,-35]
	popj 17,

	.bss
gv0:
	.space	4
gv1:
	.space	4
guv0:
	.space	4
gcbuf:
	.space	12
gucbuf:
	.space	12
gqbuf:
	.space	8
guqbuf:
	.space	8
ghbuf:
	.space	16
guhbuf:
	.space	16
gsbuf:
	.space	32
gusbuf:
	.space	32
gdbuf:
	.space	32
gudbuf:
	.space	32
g6buf:
	.space	8
g7buf:
	.space	8
g8buf:
	.space	8
g9buf:
	.space	8
gs16buf:
	.space	16
gs18buf:
	.space	16
vgv0:
	.space	4
vgvd0:
	.space	8
