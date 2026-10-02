	.data
	.align	2
wp:
	.long	1
	.long	2
	.space	3
	.word	3000000000
	.align	2
swp:
	.long	68719476735
	.long	2
	.space	3
	.word	775000000000
	.align	2
swp2:
	.long	68719476725
	.long	12
	.space	3
	.word	763000000000
	.align	2
wm:
	.space	3
	.word	1000000000
	.long	2
	.space	3
	.word	3000000000
	.align	2
swm:
	.space	3
	.word	777000000000
	.long	2
	.space	3
	.word	775000000000
	.align	2
wb:
	.word	251627340516
	.align	2
swb:
	.word	777777637435
	.align	2
glo_p:
	.long	wp
	.align	2
ghi_p:
	.long	wp+1
	.align	2
garr_p:
	.long	wa+3
	.align	2
gslo_p:
	.long	swp
	.align	2
gtag_p:
	.long	wp+32312918018

store_word32_low:
	lsh 1,4
	movem 1,wp
	popj 17,

store_word32_high:
	dpb 1,[POINT 32,wp+1,31]
	popj 17,

store_word32_low_ret:
	move 4,1
	lsh 4,4
	movem 4,wp
	tlz 1,740000
	popj 17,

store_word32_high_ret:
	dpb 1,[POINT 32,wp+1,31]
	tlz 1,740000
	popj 17,

load_word32_low:
	move 1,wp
	lsh 1,-4
	popj 17,

load_word32_high:
	move 1,wp+1
	lsh 1,-4
	popj 17,

store_sword32_low:
	lsh 1,4
	movem 1,swp
	popj 17,

store_sword32_high:
	dpb 1,[POINT 32,swp+1,31]
	popj 17,

load_sword32_low:
	move 1,swp
	ash 1,-4
	popj 17,

load_sword32_high:
	move 1,swp+1
	ash 1,-4
	popj 17,

copy_word32_pair:
	move 6,(2)
	andcmi 6,17
	movem 6,(1)
	move 4,1(2)
	lsh 4,-4
	dpb 4,[POINT 32,1(1),31]
	move 4,2(2)
	lsh 4,-36
	dpb 4,[POINT 6,2(1),5]
	popj 17,

copy_sword32_pair:
	move 6,(2)
	andcmi 6,17
	movem 6,(1)
	move 4,1(2)
	ash 4,-4
	dpb 4,[POINT 32,1(1),31]
	move 4,2(2)
	ash 4,-36
	dpb 4,[POINT 6,2(1),5]
	popj 17,

store_word32_mixed:
	move 4,2
	lsh 4,36
	movem 4,wm
	lsh 1,4
	movem 1,wm+1
	addi 2,1
	dpb 2,[POINT 6,wm+2,5]
	popj 17,

store_sword32_mixed:
	move 4,2
	lsh 4,36
	movem 4,swm
	lsh 1,4
	movem 1,swm+1
	subi 2,1
	dpb 2,[POINT 6,swm+2,5]
	popj 17,

load_word32_mixed:
	move 1,wm+1
	lsh 1,-4
	move 4,wm
	lsh 4,-36
	add 1,4
	move 4,wm+2
	lsh 4,-36
	add 1,4
	popj 17,

load_sword32_mixed:
	move 1,swm+1
	ash 1,-4
	move 4,swm
	ash 4,-36
	add 1,4
	move 4,swm+2
	ash 4,-36
	add 1,4
	popj 17,

store_bits_mid:
	dpb 1,[POINT 32,wb,33]
	popj 17,

load_bits_mid:
	ldb 1,[POINT 32,wb,33]
	popj 17,

preserve_bits_mid:
	movei 4,1
	dpb 4,[POINT 2,wb,1]
	movei 4,2
	dpb 4,[POINT 2,wb,35]
	dpb 1,[POINT 32,wb,33]
	move 3,wb
	lsh 3,-42
	ldb 4,[POINT 2,wb,35]
	add 3,4
	move 4,wb
	and 4,[177777777774]
	move 1,3
	addi 1,1
	jumpn 4,%L26
	move 1,3
%L26:
	popj 17,

store_sbits_mid:
	dpb 1,[POINT 32,swb,33]
	popj 17,

preserve_sbits_mid:
	movsi 6,600000
	iorm 6,swb
	movei 4,1
	dpb 4,[POINT 2,swb,35]
	dpb 1,[POINT 32,swb,33]
	move 3,swb
	ash 3,-42
	move 4,swb
	lsh 4,42
	ash 4,-42
	add 3,4
	ldb 1,[POINT 1,swb,2]
	add 1,3
	popj 17,

store_word32_array:
	movei 4,wa
	jumple 1,%L32
%L31:
	ibp 4
	sojg 1,%L31	; decrement_and_branch_until_zero
%L32:
	jumpe 1,%L34
%L33:
	subi 4,1
	aojl 1,%L33
%L34:
	dpb 2,[POINT 32,(4),31]
	popj 17,

load_word32_array:
	move 1,wa(1)
	lsh 1,-4
	popj 17,

store_sword32_array:
	movei 4,sa
	jumple 1,%L39
%L38:
	ibp 4
	sojg 1,%L38	; decrement_and_branch_until_zero
%L39:
	jumpe 1,%L41
%L40:
	subi 4,1
	aojl 1,%L40
%L41:
	dpb 2,[POINT 32,(4),31]
	popj 17,

load_sword32_array:
	move 1,sa(1)
	ash 1,-4
	popj 17,

sum_word32_array:
	setzb 2,3
	caml 2,1
	jrst %L50
	subi 1,1
%L51:
	move 4,wa(3)
	lsh 4,-4
	add 2,4
	addi 3,1
	sojge 1,%L51	; doloop_end
%L50:
	move 1,2
	popj 17,

sum_sword32_array:
	setzb 2,3
	caml 2,1
	jrst %L59
	subi 1,1
%L60:
	move 4,sa(3)
	ash 4,-4
	add 2,4
	addi 3,1
	sojge 1,%L60	; doloop_end
%L59:
	move 1,2
	popj 17,

store_word32_pointer:
	movem 2,(1)
	popj 17,

load_word32_pointer:
	move 1,(1)
	popj 17,

store_word32_pointer_ret:
	movem 2,(1)
	move 1,2
	popj 17,

update_word32_pointer:
	addm 2,(1)
	popj 17,

store_sword32_pointer:
	movem 2,(1)
	popj 17,

load_sword32_pointer:
	move 1,(1)
	popj 17,

store_word32_indexed:
	add 1,2
	movem 3,(1)
	popj 17,

load_word32_indexed:
	add 1,2
	move 1,(1)
	popj 17,

store_word32_preinc:
	movem 2,1(1)
	popj 17,

load_word32_postinc:
	move 1,(1)
	popj 17,

store_word32_struct_array:
	move 7,1
	lsh 7,1
	movei 6,wpa
	move 4,7
	add 4,1
	jumple 4,%L76
%L75:
	ibp 6
	sojg 4,%L75	; decrement_and_branch_until_zero
%L76:
	jumpe 4,%L78
%L77:
	subi 6,1
	aojl 4,%L77
%L78:
	move 4,2
	lsh 4,4
	movem 4,(6)
	movei 6,wpa
	move 4,7
	add 4,1
	jumple 4,%L81
%L80:
	ibp 6
	sojg 4,%L80	; decrement_and_branch_until_zero
%L81:
	jumpe 4,%L83
%L82:
	subi 6,1
	aojl 4,%L82
%L83:
	addi 2,1
	dpb 2,[POINT 32,1(6),31]
	move 4,1
	lsh 4,3
	add 4,1
	xmovei 4,wpa(4)
	dpb 3,[POINT 6,2(4),5]
	popj 17,

load_word32_struct_array:
	move 3,1
	move 4,1
	lsh 4,1
	add 4,1
	move 1,wpa(4)
	lsh 1,-4
	move 4,wpa+1(4)
	lsh 4,-4
	add 1,4
	move 4,3
	lsh 4,3
	add 4,3
	move 4,wpa+2(4)
	lsh 4,-36
	add 1,4
	popj 17,

store_word32_mix_array:
	move 6,3
	move 7,1
	lsh 7,3
	move 3,7
	add 3,1
	move 4,6
	lsh 4,36
	movem 4,wma(3)
	move 4,1
	lsh 4,1
	movei 3,wma
	add 4,1
	jumple 4,%L88
%L87:
	ibp 3
	sojg 4,%L87	; decrement_and_branch_until_zero
%L88:
	jumpe 4,%L90
%L89:
	subi 3,1
	aojl 4,%L89
%L90:
	lsh 2,4
	movem 2,1(3)
	add 1,7
	xmovei 4,wma(1)
	addi 6,1
	dpb 6,[POINT 6,2(4),5]
	popj 17,

load_word32_mix_array:
	move 3,1
	move 4,1
	lsh 4,1
	add 4,1
	move 1,wma+1(4)
	lsh 1,-4
	move 2,3
	lsh 2,3
	add 2,3
	move 4,wma(2)
	lsh 4,-36
	add 1,4
	move 4,wma+2(2)
	lsh 4,-36
	add 1,4
	popj 17,

store_word32_nested:
	move 4,2
	lsh 4,36
	movem 4,wn
	move 4,2
	lsh 4,36
	add 4,[10000000000]
	movem 4,wn+1
	move 4,1
	lsh 4,4
	movem 4,wn+2
	addi 2,2
	dpb 2,[POINT 6,wn+3,5]
	addi 1,1
	dpb 1,[POINT 32,wn+4,31]
	addi 2,1
	dpb 2,[POINT 6,wn+5,5]
	popj 17,

load_word32_nested:
	move 1,wn
	lsh 1,-36
	move 4,wn+1
	lsh 4,-36
	add 1,4
	move 4,wn+2
	lsh 4,-4
	add 1,4
	move 4,wn+3
	lsh 4,-36
	add 1,4
	move 4,wn+4
	lsh 4,-4
	add 1,4
	move 4,wn+5
	lsh 4,-36
	add 1,4
	popj 17,

store_word32_volatile:
	movem 1,vu32
	move 4,1
	addi 4,1
	lsh 4,4
	movem 4,vwp
	addi 1,2
	dpb 1,[POINT 32,vwp+1,31]
	movei 4,3
	dpb 4,[POINT 6,vwp+2,5]
	movsi 6,40000
	movem 6,vwm
	addi 1,3
	move 4,1
	lsh 4,4
	movem 4,vwm+1
	movei 4,6
	dpb 4,[POINT 6,vwm+2,5]
	addi 1,2
	dpb 1,[POINT 32,vwb,33]
	popj 17,

load_word32_volatile:
	move 4,vwp
	lsh 4,-4
	move 1,vu32
	add 1,4
	move 4,vwp+1
	lsh 4,-4
	add 1,4
	move 4,vwp+2
	lsh 4,-36
	add 1,4
	move 4,vwm
	lsh 4,-36
	add 1,4
	move 4,vwm+1
	lsh 4,-4
	add 1,4
	move 4,vwm+2
	lsh 4,-36
	add 1,4
	ldb 4,[POINT 32,vwb,33]
	add 1,4
	popj 17,

store_sword32_volatile:
	movem 1,vs32
	popj 17,

load_sword32_volatile:
	move 1,vs32
	popj 17,

store_word32_global_ptrs:
	move 4,glo_p
	movem 1,(4)
	move 4,ghi_p
	move 6,1
	addi 6,1
	movem 6,(4)
	move 4,garr_p
	addi 1,2
	movem 1,(4)
	movei 4,7
	dpb 4,gtag_p
	move 3,ghi_p
	move 4,glo_p
	move 1,(4)
	add 1,(3)
	move 4,garr_p
	add 1,(4)
	ldb 4,gtag_p
	add 1,4
	popj 17,

store_sword32_global_ptrs:
	move 4,gslo_p
	movem 1,(4)
	move 4,gslo_p
	move 1,(4)
	popj 17,

store_word32_stack:
	add 17,[6,,6]
	movsi 6,10000
	movem 6,-5(17)
	move 4,1
	lsh 4,4
	movem 4,-4(17)
	movei 4,2
	dpb 4,[POINT 6,-3(17),5]
	addi 1,1
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	dpb 1,[POINT 32,-1(17),31]
	addi 1,1
	dpb 1,[POINT 32,(17),31]
	move 1,-4(17)
	lsh 1,-4
	move 4,-5(17)
	lsh 4,-36
	add 1,4
	move 4,-3(17)
	lsh 4,-36
	add 1,4
	move 4,-2(17)
	lsh 4,-4
	add 1,4
	move 4,-1(17)
	lsh 4,-4
	add 1,4
	move 4,(17)
	lsh 4,-4
	add 1,4
	add 17,[-6,,-6]
	popj 17,

union_word32_roundtrip:
	dpb 1,[POINT 32,wu,31]
	move 1,wu
	ash 1,-4
	popj 17,

branch_word32_zero:
	lsh 1,4
	movem 1,wp
	andcmi 1,17
	movei 4,0
	jumpe 1,%L102
	seto 4,
	came 1,[-20]
	movei 4,1
%L102:
	move 1,4
	popj 17,

	.globl	use_word_insert_32
use_word_insert_32:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	andi 12,3
	pushj 17,store_word32_low
	move 10,11
	aos 1,10
	pushj 17,store_word32_high
	move 1,11
	pushj 17,store_sword32_low
	move 1,10
	pushj 17,store_sword32_high
	move 1,11
	addi 1,2
	movei 2,3
	pushj 17,store_word32_mixed
	move 1,11
	addi 1,3
	hrroi 2,777774
	pushj 17,store_sword32_mixed
	move 1,11
	addi 1,4
	pushj 17,store_bits_mid
	move 1,11
	addi 1,5
	pushj 17,store_sbits_mid
	move 2,11
	addi 2,6
	move 1,12
	pushj 17,store_word32_array
	move 2,11
	addi 2,7
	move 1,12
	pushj 17,store_sword32_array
	move 2,11
	addi 2,10
	movei 1,wp
	pushj 17,store_word32_pointer
	move 2,11
	addi 2,11
	movei 1,swp
	pushj 17,store_sword32_pointer
	move 3,11
	addi 3,12
	movei 1,wa
	move 2,12
	pushj 17,store_word32_indexed
	move 2,11
	addi 2,13
	movei 1,wa
	pushj 17,store_word32_preinc
	move 2,11
	addi 2,14
	move 1,12
	movei 3,5
	pushj 17,store_word32_struct_array
	move 2,11
	addi 2,15
	move 1,12
	movei 3,6
	pushj 17,store_word32_mix_array
	move 1,11
	addi 1,16
	movei 2,7
	pushj 17,store_word32_nested
	move 1,11
	addi 1,17
	pushj 17,store_word32_volatile
	move 1,11
	addi 1,20
	pushj 17,store_sword32_volatile
	move 1,11
	addi 1,21
	pushj 17,store_word32_low_ret
	move 10,1
	move 1,11
	addi 1,22
	pushj 17,store_word32_high_ret
	add 10,1
	pushj 17,load_word32_low
	add 10,1
	pushj 17,load_word32_high
	add 10,1
	pushj 17,load_sword32_low
	add 10,1
	pushj 17,load_sword32_high
	add 10,1
	pushj 17,load_word32_mixed
	add 10,1
	pushj 17,load_sword32_mixed
	add 10,1
	pushj 17,load_bits_mid
	add 10,1
	move 1,11
	addi 1,23
	pushj 17,preserve_bits_mid
	add 10,1
	move 1,11
	addi 1,24
	pushj 17,preserve_sbits_mid
	add 10,1
	move 1,12
	pushj 17,load_word32_array
	add 10,1
	move 1,12
	pushj 17,load_sword32_array
	add 10,1
	movei 1,4
	pushj 17,sum_word32_array
	add 10,1
	movei 1,4
	pushj 17,sum_sword32_array
	add 10,1
	movei 1,wp+1
	pushj 17,load_word32_pointer
	add 10,1
	move 2,11
	addi 2,25
	movei 1,wp
	pushj 17,store_word32_pointer_ret
	add 10,1
	movei 1,wa
	move 2,12
	pushj 17,load_word32_indexed
	add 10,1
	movei 1,wa
	pushj 17,load_word32_postinc
	add 10,1
	move 1,12
	pushj 17,load_word32_struct_array
	add 10,1
	move 1,12
	pushj 17,load_word32_mix_array
	add 10,1
	pushj 17,load_word32_nested
	add 10,1
	pushj 17,load_word32_volatile
	add 10,1
	pushj 17,load_sword32_volatile
	add 10,1
	move 1,11
	addi 1,26
	pushj 17,store_word32_global_ptrs
	add 10,1
	move 1,11
	addi 1,27
	pushj 17,store_sword32_global_ptrs
	add 10,1
	move 1,11
	addi 1,30
	pushj 17,store_word32_stack
	add 10,1
	move 1,11
	addi 1,31
	pushj 17,union_word32_roundtrip
	add 10,1
	move 1,11
	pushj 17,branch_word32_zero
	add 10,1
	movei 1,wpa
	movei 2,wp
	pushj 17,copy_word32_pair
	movei 1,swp
	movei 2,swp2
	pushj 17,copy_sword32_pair
	movei 1,wp
	move 2,10
	pushj 17,update_word32_pointer
	move 4,wp
	lsh 4,-4
	add 10,4
	move 4,wpa
	lsh 4,-4
	add 10,4
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.bss
wn:
	.space	24
wu:
	.space	4
vwp:
	.space	12
vwm:
	.space	12
vwb:
	.space	4
vu32:
	.space	4
vs32:
	.space	4
wa:
	.space	28
sa:
	.space	28
wpa:
	.space	48
wma:
	.space	48
