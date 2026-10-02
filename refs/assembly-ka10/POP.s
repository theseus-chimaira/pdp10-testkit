
pop_prologue:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

pop_prologue_2:
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

pop_prologue_call:
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

pop_prologue_sf:
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

pop_prologue_sf_call:
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

popsi_mem:
	move 6,(1)
	movem 6,(2)
	subi 1,1
	popj 17,

popsf_mem:
	move 6,(1)	; movsf
	movem 6,(2)	; movsf
	subi 1,1
	popj 17,

popsi_combine:
	pop 1,(2)
	popj 17,

popsf_combine:
	pop 1,(2)
	popj 17,

popsi_reg:
	move 4,(1)
	move 3,(4)
	subi 4,1
	movem 4,(1)
	move 1,3
	popj 17,

popsf_reg:
	move 4,(1)
	move 3,(4)	; movsf
	subi 4,1
	movem 4,(1)
	move 1,3	; movsf
	popj 17,

popsi_reg_combine:
	move 4,(1)
	subi 4,1
	move 3,1(4)
	movem 4,(1)
	move 1,3
	popj 17,

popsf_reg_combine:
	move 4,(1)
	subi 4,1
	move 3,1(4)	; movsf
	movem 4,(1)
	move 1,3	; movsf
	popj 17,

popsi_global:
	move 6,(1)
	movem 6,pop_ga
	subi 1,1
	popj 17,

popsf_global:
	move 6,(1)	; movsf
	movem 6,pop_fa	; movsf
	subi 1,1
	popj 17,

popsi_global_b:
	move 6,(1)
	movem 6,pop_gb
	subi 1,1
	popj 17,

popsf_global_b:
	move 6,(1)	; movsf
	movem 6,pop_fb	; movsf
	subi 1,1
	popj 17,

popsi_array:
	andi 2,17
	move 6,(1)
	movem 6,pop_buf(2)
	subi 1,1
	popj 17,

popsf_array:
	andi 2,17
	move 6,(1)	; movsf
	movem 6,pop_fbuf(2)	; movsf
	subi 1,1
	popj 17,

popsi_struct_a:
	move 6,(1)
	movem 6,(2)
	subi 1,1
	popj 17,

popsi_struct_b:
	move 6,(1)
	movem 6,1(2)
	subi 1,1
	popj 17,

popsf_struct_a:
	move 6,(1)	; movsf
	movem 6,(2)	; movsf
	subi 1,1
	popj 17,

popsf_struct_b:
	move 6,(1)	; movsf
	movem 6,1(2)	; movsf
	subi 1,1
	popj 17,

popsi_global_struct_a:
	move 6,(1)
	movem 6,pop_gp
	subi 1,1
	popj 17,

popsi_global_struct_b:
	move 6,(1)
	movem 6,pop_gp+1
	subi 1,1
	popj 17,

popsf_global_struct_a:
	move 6,(1)	; movsf
	movem 6,pop_fgp	; movsf
	subi 1,1
	popj 17,

popsf_global_struct_b:
	move 6,(1)	; movsf
	movem 6,pop_fgp+1	; movsf
	subi 1,1
	popj 17,

popsi_reg_plus:
	move 3,1
	move 4,(1)
	move 1,(4)
	subi 4,1
	movem 4,(3)
	add 1,2
	popj 17,

popsi_reg_xor:
	move 3,1
	move 4,(1)
	move 1,(4)
	subi 4,1
	movem 4,(3)
	xor 1,2
	popj 17,

popsf_reg_plus:
	move 6,1
			; truncdfsf2
	move 4,(1)
	move 1,(4)	; movsf
	subi 4,1
	movem 4,(6)
	fadr 1,2
	popj 17,

popsi_two:
	move 6,(1)
	movem 6,(2)
	subi 1,1
	move 6,(1)
	movem 6,(3)
	subi 1,1
	popj 17,

popsf_two:
	move 6,(1)	; movsf
	movem 6,(2)	; movsf
	subi 1,1
	move 6,(1)	; movsf
	movem 6,(3)	; movsf
	subi 1,1
	popj 17,

popsi_two_regs:
	move 2,1
	move 4,(1)
	move 1,(4)
	subi 4,1
	move 3,(4)
	subi 4,1
	movem 4,(2)
	add 1,3
	popj 17,

popsf_two_regs:
	move 2,1
	move 4,(1)
	move 1,(4)	; movsf
	subi 4,1
	move 3,(4)	; movsf
	subi 4,1
	movem 4,(2)
	fadr 1,3
	popj 17,

popsi_mixed:
	move 6,(1)
	movem 6,(2)
	subi 1,1
	move 6,(1)
	movem 6,pop_ga
	subi 1,1
	popj 17,

popsf_mixed:
	move 6,(1)	; movsf
	movem 6,(2)	; movsf
	subi 1,1
	move 6,(1)	; movsf
	movem 6,pop_fa	; movsf
	subi 1,1
	popj 17,

popsi_to_volatile:
	move 6,(1)
	movem 6,(2)
	subi 1,1
	popj 17,

popsf_to_volatile:
	move 6,(1)	; movsf
	movem 6,(2)	; movsf
	subi 1,1
	popj 17,

popsi_from_volatile:
	move 4,(1)
	move 3,(4)
	subi 4,1
	movem 4,(1)
	move 1,3
	popj 17,

popsi_postdec_used_twice:
	move 6,(1)
	movem 6,(2)
	subi 1,1
	move 6,(1)
	addm 6,(2)
	popj 17,

popsf_postdec_used_twice:
	move 6,(1)	; movsf
	movem 6,(2)	; movsf
	subi 1,1
	move 6,(1)	; movsf
	fadrm 6,(2)
	popj 17,

popsi_local_stack_like:
	push 17,10
	move 10,1
	move 1,(1)
	subi 10,1
	pushj 17,ext_sint
	add 1,10
	pop 17,10
	popj 17,

popsf_local_stack_like:
	move 1,(1)	; movsf
	jrst ext_sfloat

	.bss
pop_ga:
	.space	4
pop_gb:
	.space	4
pop_fa:
	.space	4
pop_fb:
	.space	4
pop_buf:
	.space	64
pop_fbuf:
	.space	64
pop_gp:
	.space	8
pop_fgp:
	.space	8
