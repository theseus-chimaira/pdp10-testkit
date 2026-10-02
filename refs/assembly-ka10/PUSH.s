
push_prologue:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

push_prologue_2:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,3
	move 12,4
	add 10,2
	pushj 17,clobber
	add 10,11
	add 10,12
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

push_prologue_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	pushj 17,ext_sint
	move 10,1
	pushj 17,clobber
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

push_prologue_sf:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1	; movdf
	move 11,2	; movdf
			; truncdfsf2
	pushj 17,clobber
	move 1,10	; movsf
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

push_prologue_sf_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,3	; movdf
	move 11,4	; movdf
			; truncdfsf2
			; truncdfsf2
	pushj 17,ext_sfloat
	move 12,1	; movsf
	pushj 17,clobber
	fadr 10,12
	move 1,10	; movsf
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

pushsi_reg:
	addi 1,1
	movem 2,(1)
	popj 17,

pushsi_mem:
	addi 1,1
	move 2,(2)
	movem 2,(1)
	popj 17,

pushsf_reg:
	addi 1,1
	movem 2,(1)	; truncdfsf2
	popj 17,

pushsf_mem:
	addi 1,1
	move 2,(2)	; movsf
	movem 2,(1)	; movsf
	popj 17,

pushsi_global:
	addi 1,1
	move 6,push_ga
	movem 6,(1)
	popj 17,

pushsi_global_b:
	addi 1,1
	move 6,push_gb
	movem 6,(1)
	popj 17,

pushsf_global:
	addi 1,1
	move 6,push_fa	; movsf
	movem 6,(1)	; movsf
	popj 17,

pushsf_global_b:
	addi 1,1
	move 6,push_fb	; movsf
	movem 6,(1)	; movsf
	popj 17,

pushsi_const_zero:
	addi 1,1
	setzm (1)
	popj 17,

pushsi_const_one:
	addi 1,1
	movei 6,1
	movem 6,(1)
	popj 17,

pushsi_const_small:
	addi 1,1
	movei 6,123456
	movem 6,(1)
	popj 17,

pushsi_const_big:
	addi 1,1
	move 6,[123456123456]
	movem 6,(1)
	popj 17,

pushsi_array_src:
	addi 1,1
	andi 3,17
	add 2,3
	move 2,(2)
	movem 2,(1)
	popj 17,

pushsf_array_src:
	addi 1,1
	andi 3,17
	add 2,3
	move 2,(2)	; movsf
	movem 2,(1)	; movsf
	popj 17,

pushsi_global_array_src:
	addi 1,1
	andi 2,17
	move 2,push_buf(2)
	movem 2,(1)
	popj 17,

pushsf_global_array_src:
	addi 1,1
	andi 2,17
	move 2,push_fbuf(2)	; movsf
	movem 2,(1)	; movsf
	popj 17,

pushsi_struct_a:
	addi 1,1
	move 2,(2)
	movem 2,(1)
	popj 17,

pushsi_struct_b:
	addi 1,1
	move 2,1(2)
	movem 2,(1)
	popj 17,

pushsf_struct_a:
	addi 1,1
	move 2,(2)	; movsf
	movem 2,(1)	; movsf
	popj 17,

pushsf_struct_b:
	addi 1,1
	move 2,1(2)	; movsf
	movem 2,(1)	; movsf
	popj 17,

pushsi_global_struct_a:
	addi 1,1
	move 6,push_gp
	movem 6,(1)
	popj 17,

pushsi_global_struct_b:
	addi 1,1
	move 6,push_gp+1
	movem 6,(1)
	popj 17,

pushsf_global_struct_a:
	addi 1,1
	move 6,push_fgp	; movsf
	movem 6,(1)	; movsf
	popj 17,

pushsf_global_struct_b:
	addi 1,1
	move 6,push_fgp+1	; movsf
	movem 6,(1)	; movsf
	popj 17,

pushsi_expr_add:
	addi 1,1
	add 2,3
	movem 2,(1)
	popj 17,

pushsi_expr_xor:
	addi 1,1
	xor 2,3
	movem 2,(1)
	popj 17,

pushsi_expr_and:
	addi 1,1
	and 2,3
	movem 2,(1)
	popj 17,

pushsi_expr_or:
	addi 1,1
	ior 2,3
	movem 2,(1)
	popj 17,

pushsf_expr_add:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-2(17)
	move 6,4
	move 7,-1(17)
			; truncdfsf2
			; truncdfsf2
	addi 1,1
	fadr 2,6
	movem 2,(1)	; movsf
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

pushsi_call:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,ext_sint
	addi 10,1
	movem 1,(10)
	move 1,10
	pop 17,10
	popj 17,

pushsf_call:
	push 17,10
	move 10,1
			; truncdfsf2
	move 1,2	; movsf
	pushj 17,ext_sfloat
	addi 10,1
	movem 1,(10)	; movsf
	move 1,10
	pop 17,10
	popj 17,

pushsi_two_regs:
	addi 1,1
	movem 2,(1)
	addi 1,1
	movem 3,(1)
	popj 17,

pushsi_two_mem:
	addi 1,1
	move 2,(2)
	movem 2,(1)
	addi 1,1
	move 3,(3)
	movem 3,(1)
	popj 17,

pushsf_two_regs:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-2(17)
	move 6,4
	move 7,-1(17)
	addi 1,1
	movem 2,(1)	; truncdfsf2
	addi 1,1
	movem 6,(1)	; truncdfsf2
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

pushsf_two_mem:
	addi 1,1
	move 2,(2)	; movsf
	movem 2,(1)	; movsf
	addi 1,1
	move 3,(3)	; movsf
	movem 3,(1)	; movsf
	popj 17,

pushsi_mixed:
	addi 1,1
	move 2,(2)
	movem 2,(1)
	addi 1,1
	move 6,push_ga
	movem 6,(1)
	addi 1,1
	movei 6,123456
	movem 6,(1)
	popj 17,

pushsf_mixed:
	addi 1,1
	move 2,(2)	; movsf
	movem 2,(1)	; movsf
	addi 1,1
	move 6,push_fa	; movsf
	movem 6,(1)	; movsf
	popj 17,

pushsi_from_volatile:
	addi 1,1
	move 2,(2)
	movem 2,(1)
	popj 17,

pushsf_from_volatile:
	addi 1,1
	move 2,(2)	; movsf
	movem 2,(1)	; movsf
	popj 17,

pushsi_to_volatile:
	addi 1,1
	movem 2,(1)
	popj 17,

pushsf_to_volatile:
			; truncdfsf2
	addi 1,1
	movem 2,(1)	; movsf
	popj 17,

pushsi_post_value_used:
	addi 1,1
	movem 2,(1)
	add 3,2
	movem 3,push_ga
	popj 17,

pushsf_post_value_used:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-2(17)
	move 6,4
	move 7,-1(17)
			; truncdfsf2
			; truncdfsf2
	addi 1,1
	movem 2,(1)	; movsf
	fadr 6,2
	movem 6,push_fa	; movsf
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

pushsi_update_through_pp:
	move 4,1
	move 1,(1)
	addi 1,1
	movem 2,(1)
	movem 1,(4)
	popj 17,

pushsf_update_through_pp:
	move 4,1
	move 1,(1)
	addi 1,1
	movem 2,(1)	; truncdfsf2
	movem 1,(4)
	popj 17,

pushsi_return_pushed:
	move 4,(1)
	addi 4,1
	movem 2,(4)
	movem 4,(1)
	move 1,2
	popj 17,

pushsf_return_pushed:
			; truncdfsf2
	move 4,(1)
	addi 4,1
	movem 2,(4)	; movsf
	movem 4,(1)
	move 1,2	; movsf
	popj 17,

pushsi_preinc_combine:
	addi 1,1
	movem 2,(1)
	popj 17,

pushsf_preinc_combine:
	addi 1,1
	movem 2,(1)	; truncdfsf2
	popj 17,

pushsi_preinc_mem_combine:
	addi 1,1
	move 2,(2)
	movem 2,(1)
	popj 17,

pushsf_preinc_mem_combine:
	addi 1,1
	move 2,(2)	; movsf
	movem 2,(1)	; movsf
	popj 17,

pushsi_local_stack_like:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,ext_sint
	addi 10,1
	movem 1,(10)
	move 1,10
	pop 17,10
	popj 17,

pushsf_local_stack_like:
	push 17,10
	move 10,1
			; truncdfsf2
	move 1,2	; movsf
	pushj 17,ext_sfloat
	addi 10,1
	movem 1,(10)	; movsf
	move 1,10
	pop 17,10
	popj 17,

	.bss
push_ga:
	.space	4
push_gb:
	.space	4
push_fa:
	.space	4
push_fb:
	.space	4
push_buf:
	.space	64
push_fbuf:
	.space	64
push_gp:
	.space	8
push_fgp:
	.space	8
