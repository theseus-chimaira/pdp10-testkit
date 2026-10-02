
	.globl	zero_extendhisi2_1
zero_extendhisi2_1:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

	.globl	zxhi2
zxhi2:
	hrrzi 2,(2)	; zero_extendhisi2
	move 1,2
	popj 17,

zxhisi_reg:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

zxhisi_reg_local:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

zxhisi_reg_reuse:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

zxhisi_reg_plus:
	addi 2,(1)
	move 1,2
	popj 17,

zxhisi_reg_minus:
	hrrzi 1,(1)	; zero_extendhisi2
	sub 1,2
	popj 17,

zxhisi_reg_xor:
	xori 2,(1)
	move 1,2
	popj 17,

zxhisi_reg_or:
	iori 2,(1)
	move 1,2
	popj 17,

zxhisi_reg_and:
	andi 2,(1)
	move 1,2
	popj 17,

zxhisi_reg_shift_left:
	hrrzi 1,(1)	; zero_extendhisi2
	lsh 1,1
	popj 17,

zxhisi_reg_shift_right:
	ldb 1,[POINT 17,1,34]
	popj 17,

zxhisi_mem:
	ldb 1,1
	popj 17,

zxhisi_mem_local:
	ldb 1,1
	popj 17,

zxhisi_mem_plus:
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

zxhisi_mem_xor:
	ldb 1,1
	xor 2,1
	move 1,2
	popj 17,

zxhisi_mem_mem:
	ldb 2,2
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

zxhisi_global_a:
	move 1,zxhisi_ga
	popj 17,

zxhisi_global_b:
	move 1,zxhisi_gb
	popj 17,

zxhisi_global_local:
	move 1,zxhisi_ga
	popj 17,

zxhisi_global_plus:
	hlrz 6,zxhisi_ga
	add 1,6
	popj 17,

zxhisi_volatile_global:
	move 1,zxhisi_vga
	popj 17,

zxhisi_volatile_mem:
	ldb 1,1
	popj 17,

zxhisi_array:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L27
%L26:
	ibp 1
	sojn 4,%L26	; decrement_and_branch_until_zero
%L27:
	ldb 1,1
	popj 17,

zxhisi_array_local:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L31
%L30:
	ibp 1
	sojn 4,%L30	; decrement_and_branch_until_zero
%L31:
	ldb 1,1
	popj 17,

zxhisi_array_plus:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L35
%L34:
	ibp 1
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

zxhisi_global_array:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,zxhisi_buf,17]
	jumpe 4,%L38
%L37:
	ibp 1
	sojn 4,%L37	; decrement_and_branch_until_zero
%L38:
	ldb 1,1
	popj 17,

zxhisi_global_array_local:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,zxhisi_buf,17]
	jumpe 4,%L41
%L40:
	ibp 1
	sojn 4,%L40	; decrement_and_branch_until_zero
%L41:
	ldb 1,1
	popj 17,

zxhisi_struct_a:
	hlrz 1,(1)
	popj 17,

zxhisi_struct_b:
	hrrz 1,(1)
	popj 17,

zxhisi_struct_ab_sum:
	move 4,1
	hlrz 1,(1)
	hrrz 4,(4)
	add 1,4
	popj 17,

zxhisi_three_abc_sum:
	hlrz 4,(1)
	hrrz 3,(1)
	hlrz 2,1(1)
	add 4,3
	add 4,2
	move 1,4
	popj 17,

zxhisi_global_struct_a:
	hlrz 1,zxhisi_gp
	popj 17,

zxhisi_global_struct_b:
	hrrz 1,zxhisi_gp
	popj 17,

zxhisi_global_three:
	hlrz 1,zxhisi_gt
	hrrz 4,zxhisi_gt
	hlrz 3,zxhisi_gt+1
	add 1,4
	add 1,3
	popj 17,

zxhisi_indirect:
	ldb 1,(1)
	popj 17,

zxhisi_indexed_indirect:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 2,(1)
	jumpe 4,%L53
%L52:
	ibp 2
	sojn 4,%L52	; decrement_and_branch_until_zero
%L53:
	ldb 1,2
	popj 17,

zxhisi_call:
	pushj 17,uhfunc
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

zxhisi_call_plus:
	push 17,10
	move 10,1
	pushj 17,uhfunc
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

zxhisi_store:
	hrrzm 2,(1)
	popj 17,

zxhisi_store_return:
	hrrzi 2,(2)	; zero_extendhisi2
	movem 2,(1)
	move 1,2
	popj 17,

zxhisi_store_return_mem:
	hrrzi 2,(2)	; zero_extendhisi2
	movem 2,(1)
	move 1,2
	popj 17,

zxhisi_store_global:
	hrrzm 1,zxhisi_sga
	popj 17,

zxhisi_store_global_return:
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,zxhisi_sga
	popj 17,

zxhisi_store_volatile:
	hrrzi 2,(2)	; zero_extendhisi2
	movem 2,(1)
	popj 17,

zxhisi_store_volatile_return:
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,zxhisi_vsga
	move 1,zxhisi_vsga
	popj 17,

zxhisi_store_array:
	andi 2,17
	add 1,2
	hrrzm 3,(1)
	popj 17,

zxhisi_store_array_return:
	hrrzi 3,(3)	; zero_extendhisi2
	andi 2,17
	add 1,2
	movem 3,(1)
	move 1,3
	popj 17,

zxhisi_store_global_array:
	andi 1,17
	hrrzm 2,zxhisi_sbuf(1)
	popj 17,

zxhisi_store_global_array_return:
	hrrzi 2,(2)	; zero_extendhisi2
	andi 1,17
	movem 2,zxhisi_sbuf(1)
	move 1,2
	popj 17,

zxhisi_store_hi:
	dpb 2,1	; movhi
	popj 17,

zxhisi_store_hi_return:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	move 1,2
	popj 17,

zxhisi_branch_zero:
	hrrzi 1,(1)	; zero_extendhisi2
	jumpe 1,%L72
	move 2,3
%L72:
	move 1,2
	popj 17,

zxhisi_branch_nonzero:
	hrrzi 1,(1)	; zero_extendhisi2
	jumpn 1,%L74
	move 2,3
%L74:
	move 1,2
	popj 17,

zxhisi_branch_right_bit:
	trnn 1,1
	move 2,3
	move 1,2
	popj 17,

zxhisi_branch_hi_signbit:
	trnn 1,400000
	move 2,3
	move 1,2
	popj 17,

zxhisi_likely:
	hrrzi 1,(1)	; zero_extendhisi2
	move 4,1
	jumpe 1,%L82
%L80:
	move 1,4
	popj 17,
%L82:
	movei 4,0
	jrst %L80

zxhisi_unlikely:
	hrrzi 1,(1)	; zero_extendhisi2
	move 4,1
	jumpn 1,%L83
	movei 4,0
%L83:
	move 1,4
	popj 17,

zxhisi_sources_live:
	hrrzi 1,(1)	; zero_extendhisi2
	lsh 1,1
	add 1,2
	popj 17,

zxhisi_mem_sources_live:
	ldb 1,1
	lsh 1,1
	add 1,2
	popj 17,

zxhisi_call_pressure_reg:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	pushj 17,clobber
	lsh 10,1
	move 1,10
	pop 17,10
	popj 17,

zxhisi_call_pressure_mem:
	push 17,10
	ldb 10,1
	pushj 17,clobber
	lsh 10,1
	move 1,10
	pop 17,10
	popj 17,

zxhisi_store_call_pressure:
	push 17,10
	move 10,1
	hrrzm 2,(1)
	pushj 17,clobber
	move 1,(10)
	pop 17,10
	popj 17,

zxhisi_loop_sum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L101:
	move 3,6
	andi 3,17
	move 4,6
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L97
%L96:
	ibp 3
	sojn 4,%L96	; decrement_and_branch_until_zero
%L97:
	ldb 3,3
	add 1,3
	addi 6,1
	sojge 2,%L101	; doloop_end
	popj 17,

zxhisi_loop_store:
	movei 7,0
	caml 7,3
	popj 17,
	subi 3,1
%L114:
	move 4,7
	andi 4,17
	move 5,2
	add 5,4
	move 6,7
	andi 6,1
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 6,%L110
%L109:
	ibp 4
	sojn 6,%L109	; decrement_and_branch_until_zero
%L110:
	ldb 4,4
	movem 4,(5)
	addi 7,1
	sojge 3,%L114	; doloop_end
	popj 17,

zxhisi_loop_store_sum:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	setzb 1,5
	caml 1,3
	jrst %L127
	subi 3,1
%L128:
	move 7,5
	andi 7,17
	move 2,10
	add 2,7
	move 4,5
	andi 4,1
	move 6,7
	ash 6,-1	; ashrsi3_pointer
	add 6,11
	jumpe 4,%L123
%L122:
	ibp 6
	sojn 4,%L122	; decrement_and_branch_until_zero
%L123:
	ldb 4,6
	movem 4,(2)
	add 7,10
	add 1,(7)
	addi 5,1
	sojge 3,%L128	; doloop_end
%L127:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

zero_extendhisi2_both_regaa:
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(2)
	popj 17,

zero_extendhisi2_both_regab:
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(2)
	popj 17,

zero_extendhisi2_both_regba:
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(2)
	popj 17,

zero_extendhisi2_both_regbb:
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(2)
	popj 17,

zero_extendhisi2_both_memaa:
	hrrzs 1,(2)
	popj 17,

zero_extendhisi2_both_memab:
	hrrzs 1,(2)
	popj 17,

zero_extendhisi2_both_memba:
	hrrzs 1,(2)
	popj 17,

zero_extendhisi2_both_membb:
	hrrzs 1,(2)
	popj 17,

	.globl	zxhs
zxhs:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	hrrzi 11,(11)	; zero_extendhisi2
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,11
	pushj 17,zero_extendhisi2_1
	move 10,1
	move 1,11
	move 2,12
	pushj 17,zxhi2
	add 10,1
	move 1,11
	move 2,12
	pushj 17,zxhisi_reg_plus
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	zxhm
zxhm:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 11,2
	move 13,3
	pushj 17,zxhisi_mem
	move 10,1
	move 1,12
	move 2,11
	pushj 17,zxhisi_mem_mem
	add 10,1
	ldb 2,12
	move 1,13
	pushj 17,zxhisi_store_return
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.globl	zxhc
zxhc:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,2
	move 10,3
	hrrzi 10,(10)	; zero_extendhisi2
	pushj 17,zxhisi_loop_sum
	move 11,1
	move 1,10
	move 2,12
	move 3,11
	pushj 17,zxhisi_branch_nonzero
	add 11,1
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.bss
zxhisi_ga:
	.space	4
zxhisi_gb:
	.space	4
zxhisi_vga:
	.space	4
zxhisi_buf:
	.space	32
zxhisi_sga:
	.space	4
zxhisi_vsga:
	.space	4
zxhisi_sbuf:
	.space	64
zxhisi_gp:
	.space	4
zxhisi_gt:
	.space	8
