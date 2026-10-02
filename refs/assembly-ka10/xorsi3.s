
xor1:
	xor 1,2
	popj 17,

xor2:
	xor 1,(2)
	popj 17,

xori:
	xori 1,123456
	popj 17,

tlc:
	tlc 1,123456
	popj 17,

eqvi:
	eqvi 1,123456
	popj 17,

xor3:
	xor 1,[123456123456]
	popj 17,

xorm:
	xorm 1,(2)
	popj 17,

xor_reg:
	xor 1,2
	popj 17,

xor_reg_commuted:
	xor 2,1
	move 1,2
	popj 17,

xor_self:
	movei 1,0
	popj 17,

xor_zero:
	popj 17,

xor_ones:
	setca 1,
	popj 17,

xor_not_shape:
	setca 1,
	popj 17,

xor_local:
	xor 1,2
	popj 17,

xor_reuse_left:
	xor 1,2
	popj 17,

xor_reuse_right:
	xor 2,1
	move 1,2
	popj 17,

xor_from_add:
	add 1,2
	xor 1,3
	popj 17,

xor_from_sub:
	sub 1,2
	xor 1,3
	popj 17,

xor_from_and:
	and 1,2
	xor 1,3
	popj 17,

xor_from_or:
	ior 1,2
	xor 1,3
	popj 17,

xor_from_call:
	push 17,10
	move 10,1
	pushj 17,f
	xor 1,10
	pop 17,10
	popj 17,

xor_right_imm:
	xori 1,123456
	popj 17,

xor_right_imm_small:
	xori 1,123
	popj 17,

xor_right_imm_highbit:
	xori 1,400000
	popj 17,

xor_right_imm_all:
	xori 1,777777
	popj 17,

xor_left_imm:
	tlc 1,123456
	popj 17,

xor_left_imm_small:
	tlc 1,1230
	popj 17,

xor_left_imm_sign:
	tlc 1,400000
	popj 17,

xor_left_imm_all:
	tlc 1,777777
	popj 17,

xor_full_literal:
	xor 1,[123456123456]
	popj 17,

xor_full_literal_alt:
	xor 1,[-252525525253]
	popj 17,

xor_eqvi_right:
	eqvi 1,123456
	popj 17,

xor_eqvi_left:
	xor 1,[-123456000001]
	popj 17,

xor_eqvi_full:
	xor 1,[-123456123457]
	popj 17,

xor_mem_right:
	xor 1,(2)
	popj 17,

xor_mem_left:
	xor 2,(1)
	move 1,2
	popj 17,

xor_mem_mem:
	move 1,(1)
	xor 1,(2)
	popj 17,

xor_mem_loaded:
	move 1,(1)
	xor 1,(2)
	popj 17,

xor_global_right:
	xor 1,xor_ga
	popj 17,

xor_global_left:
	xor 1,xor_ga
	popj 17,

xor_global_global:
	move 1,xor_ga
	xor 1,xor_gb
	popj 17,

xor_volatile_right:
	move 4,1
	move 1,xor_vga
	xor 1,4
	popj 17,

xor_volatile_left:
	move 4,1
	move 1,xor_vga
	xor 1,4
	popj 17,

xor_volatile_mem:
	move 1,(1)
	move 4,(2)
	xor 1,4
	popj 17,

xor_array_right:
	andi 3,17
	add 2,3
	xor 1,(2)
	popj 17,

xor_array_left:
	andi 2,17
	add 1,2
	xor 3,(1)
	move 1,3
	popj 17,

xor_array_array:
	andi 2,17
	add 2,1
	andi 3,17
	add 1,3
	move 2,(2)
	xor 2,(1)
	move 1,2
	popj 17,

xor_global_array_right:
	andi 2,17
	xor 1,xor_buf(2)
	popj 17,

xor_global_array_left:
	andi 1,17
	xor 2,xor_buf(1)
	move 1,2
	popj 17,

xor_struct_a:
	xor 2,(1)
	move 1,2
	popj 17,

xor_struct_b:
	xor 1,1(2)
	popj 17,

xor_struct_ab:
	move 6,(1)
	xor 6,1(1)
	move 1,6
	popj 17,

xor_three_ab:
	move 6,(1)
	xor 6,1(1)
	move 1,6
	popj 17,

xor_three_abc:
	move 4,(1)
	xor 4,1(1)
	xor 4,2(1)
	move 1,4
	popj 17,

xor_global_struct_a:
	xor 1,xor_gp
	popj 17,

xor_global_struct_b:
	xor 1,xor_gp+1
	popj 17,

xor_global_three:
	move 1,xor_gt
	xor 1,xor_gt+1
	xor 1,xor_gt+2
	popj 17,

xor_indirect_right:
	xor 1,@(2)
	popj 17,

xor_indirect_left:
	xor 2,@(1)
	move 1,2
	popj 17,

xor_indexed_indirect:
	andi 2,17
	add 2,(1)
	xor 3,(2)
	move 1,3
	popj 17,

xorm_reg_mem:
	xorm 1,(2)
	popj 17,

xorm_reg_mem_op:
	xorm 1,(2)
	popj 17,

xorm_reg_mem_ret_mem:
	xorb 1,(2)
	popj 17,

xorm_reg_mem_ret_result:
	xorb 1,(2)
	popj 17,

xorm_mem_mem:
	move 1,(1)
	xorm 1,(2)
	popj 17,

xorm_mem_mem_ret:
	move 6,(2)
	xor 6,(1)
	move 1,6
	movem 6,(2)
	popj 17,

xorm_global:
	xorm 1,xor_ga
	popj 17,

xorm_global_ret:
	xorb 1,xor_ga
	popj 17,

xorm_global_from_mem:
	move 1,(1)
	xorm 1,xor_gb
	popj 17,

xorm_global_from_mem_ret:
	move 6,xor_gb
	xor 6,(1)
	move 1,6
	movem 6,xor_gb
	popj 17,

xorm_array:
	andi 2,17
	add 1,2
	xorm 3,(1)
	popj 17,

xorm_array_ret:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	xorb 1,(4)
	popj 17,

xorm_global_array:
	andi 1,17
	xorm 2,xor_buf(1)
	popj 17,

xorm_global_array_ret:
	andi 1,17
	move 4,2
	xorb 4,xor_buf(1)
	move 1,4
	popj 17,

xorm_struct_a:
	xorm 2,(1)
	popj 17,

xorm_struct_b:
	xorm 2,1(1)
	popj 17,

xorm_struct_ret:
	move 4,2
	xorb 4,1(1)
	move 1,4
	popj 17,

xorm_global_struct:
	xorm 1,xor_gp+1
	popj 17,

xorm_global_struct_ret:
	xorb 1,xor_gp+1
	popj 17,

xorm_indirect:
	xorm 2,@(1)
	popj 17,

xorm_indirect_ret:
	move 4,2
	xorb 4,@(1)
	move 1,4
	popj 17,

xorm_indexed_indirect:
	andi 2,17
	add 2,(1)
	xorm 3,(2)
	popj 17,

xorm_indexed_indirect_ret:
	andi 2,17
	add 2,(1)
	move 1,3
	xorb 1,(2)
	popj 17,

xorm_volatile:
	move 4,(1)
	xor 4,2
	movem 4,(1)
	popj 17,

xorm_volatile_ret:
	move 4,(1)
	xor 4,2
	movem 4,(1)
	move 1,(1)
	popj 17,

xorb_mem:
	xorb 1,(2)
	popj 17,

xorb_mem_add:
	xorb 1,(2)
	add 1,3
	popj 17,

xorb_mem_xor:
	xorb 1,(2)
	xor 1,3
	popj 17,

xorb_global:
	xorb 1,xor_ga
	popj 17,

xorb_array:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	xorb 1,(4)
	popj 17,

xorb_struct_a:
	move 4,2
	xorb 4,(1)
	move 1,4
	popj 17,

xorb_volatile:
	move 4,(1)
	xor 2,4
	movem 2,(1)
	move 1,2
	popj 17,

xorb_source_live:
	move 6,1
	move 4,(2)
	xor 1,4
	movem 1,(2)
	add 1,6
	add 1,4
	add 1,3
	popj 17,

xor_add:
	xor 1,2
	add 1,3
	popj 17,

xor_sub:
	xor 1,2
	sub 1,3
	popj 17,

xor_and:
	xor 1,2
	and 1,3
	popj 17,

xor_or:
	xor 1,2
	ior 1,3
	popj 17,

xor_xor_again:
	xor 1,2
	xor 1,3
	popj 17,

xor_mul:
	xor 1,2
	imul 1,3
	popj 17,

xor_sources_live:
	move 4,1
	xor 1,2
	add 1,4
	add 1,2
	add 1,3
	popj 17,

xor_memory_sources_live:
	move 6,1
	move 4,(2)
	move 1,(1)
	xor 1,4
	add 1,(6)
	add 1,4
	add 1,3
	popj 17,

xor_two_values:
	xor 1,2
	xor 3,4
	add 1,3
	popj 17,

xor_two_mems:
	move 1,(1)
	xor 1,(2)
	move 3,(3)
	xor 3,(4)
	add 1,3
	popj 17,

xor_branch_zero:
	came 1,2
	move 3,4
	move 1,3
	popj 17,

xor_branch_nonzero:
	camn 1,2
	move 3,4
	move 1,3
	popj 17,

xor_branch_negative:
	xor 1,2
	jumpl 1,%L125
	move 3,4
%L125:
	move 1,3
	popj 17,

xor_branch_positive:
	xor 1,2
	jumple 1,%L129
%L127:
	move 1,3
	popj 17,
%L129:
	move 3,4
	jrst %L127

xor_likely:
	move 4,1
	xor 2,1
	move 1,2
	jumpe 2,%L132
%L130:
	popj 17,
%L132:
	move 1,4
	popj 17,

xor_unlikely:
	xor 1,2
	move 4,1
	jumpn 1,%L133
	move 4,2
%L133:
	move 1,4
	popj 17,

xor_call_pressure_reg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	xor 10,1
	pushj 17,clobber
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

xor_call_pressure_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,(1)
	xor 11,(2)
	pushj 17,clobber
	add 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

xorm_call_pressure:
	push 17,10
	move 10,1
	xorm 2,(1)
	pushj 17,clobber
	move 1,(10)
	pop 17,10
	popj 17,

xorb_call_pressure:
	push 17,10
	move 10,2
	xorb 10,(1)
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

xor_loop_sum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L148:
	move 4,6
	andi 4,17
	add 4,7
	move 4,(4)
	xor 4,3
	add 1,4
	addi 6,1
	sojge 2,%L148	; doloop_end
	popj 17,

xorm_loop:
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L159:
	move 4,6
	andi 4,17
	add 4,1
	xorm 3,(4)
	addi 6,1
	sojge 2,%L159	; doloop_end
	popj 17,

xorm_loop_sum:
	move 5,1
	move 7,3
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L171:
	move 4,6
	andi 4,17
	add 4,5
	move 3,7
	xorb 3,(4)
	add 1,3
	addi 6,1
	sojge 2,%L171	; doloop_end
	popj 17,

xorb_loop_sum:
	move 5,1
	move 7,3
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L182:
	move 4,6
	andi 4,17
	add 4,5
	move 3,7
	xorb 3,(4)
	add 1,3
	addi 6,1
	sojge 2,%L182	; doloop_end
	popj 17,

uxor_reg:
	xor 1,2
	popj 17,

uxor_mem:
	xor 1,(2)
	popj 17,

uxor_mem_mem:
	move 1,(1)
	xor 1,(2)
	popj 17,

uxor_right_imm:
	xori 1,123456
	popj 17,

uxor_left_imm:
	tlc 1,123456
	popj 17,

uxor_full_literal:
	xor 1,[123456123456]
	popj 17,

uxor_eqvi_right:
	eqvi 1,123456
	popj 17,

uxor_global:
	xor 1,uxor_ga
	popj 17,

uxor_volatile:
	move 4,1
	move 1,uxor_vga
	xor 1,4
	popj 17,

uxor_array:
	andi 2,17
	add 1,2
	xor 3,(1)
	move 1,3
	popj 17,

uxor_global_array:
	andi 1,17
	xor 2,uxor_buf(1)
	move 1,2
	popj 17,

uxor_struct_a:
	xor 2,(1)
	move 1,2
	popj 17,

uxor_global_struct:
	move 1,uxor_gp
	xor 1,uxor_gp+1
	popj 17,

uxorm_mem:
	xorm 1,(2)
	popj 17,

uxorm_mem_ret:
	xorb 1,(2)
	popj 17,

uxorb_mem:
	xorb 1,(2)
	popj 17,

uxor_add:
	xor 1,2
	add 1,3
	popj 17,

uxor_branch_nonzero:
	camn 1,2
	move 3,4
	move 1,3
	popj 17,

xor_sqi:
	xor 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

xor_sqi_si:
	lsh 1,33
	ash 1,-33
	xor 1,2
	popj 17,

xor_hi:
	xor 2,1
	hrre 2,2
	move 1,2
	popj 17,

xor_hi_si:
	hrre 1,1
	xor 1,2
	popj 17,

xor_uqi:
	xor 2,1
	andi 2,777
	move 1,2
	popj 17,

xor_uhi:
	hrrzi 2,(2)	; zero_extendhisi2
	xori 2,(1)
	move 1,2
	popj 17,

xor_both_reg_memaa:
	xorb 1,(2)
	popj 17,

xor_both_reg_memab:
	xorb 1,(2)
	popj 17,

xor_both_reg_memba:
	xorb 1,(2)
	popj 17,

xor_both_reg_membb:
	xorb 1,(2)
	popj 17,

xorm_both_memaa:
	xorb 1,(2)
	popj 17,

xorm_both_memab:
	xorb 1,(2)
	popj 17,

xorm_both_memba:
	xorb 1,(2)
	popj 17,

xorm_both_membb:
	xorb 1,(2)
	popj 17,

	.globl	xorsi3_smoke
xorsi3_smoke:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 14,1
	move 12,2
	move 13,3
	pushj 17,xor1
	move 11,1
	pushj 17,xori
	move 10,1
	add 10,11
	move 1,12
	pushj 17,tlc
	add 10,1
	move 1,13
	pushj 17,eqvi
	add 10,1
	move 1,14
	move 2,12
	move 3,13
	pushj 17,xor_add
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.globl	xor3mm
xor3mm:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	move 11,3
	pushj 17,xor_mem_mem
	move 10,1
	move 1,11
	move 2,12
	pushj 17,xorb_mem
	add 10,1
	move 1,11
	move 2,13
	pushj 17,xorm_reg_mem_ret_mem
	add 10,1
	move 1,12
	move 2,13
	move 3,11
	pushj 17,xor_memory_sources_live
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.globl	xor3ct
xor3ct:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	move 13,3
	pushj 17,xor_loop_sum
	move 10,1
	move 1,11
	move 2,12
	move 3,10
	pushj 17,xorm_loop_sum
	add 10,1
	move 1,10
	move 2,13
	move 3,12
	move 4,13
	pushj 17,xor_branch_nonzero
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.bss
xor_ga:
	.space	4
xor_gb:
	.space	4
xor_gc:
	.space	4
xor_vga:
	.space	4
xor_buf:
	.space	64
uxor_ga:
	.space	4
uxor_gb:
	.space	4
uxor_vga:
	.space	4
uxor_buf:
	.space	64
xor_gp:
	.space	8
xor_gt:
	.space	12
uxor_gp:
	.space	8
