
opaque_si:
	movem 1,movm_opaque_si
	move 1,movm_opaque_si
	popj 17,

opaque_sf:
			; truncdfsf2
	movem 1,movm_opaque_sf	; movsf
	move 1,movm_opaque_sf	; movsf
	popj 17,

opaque_df:
	movem 1,movm_opaque_df	; movdf
	movem 2,movm_opaque_df+1	; movdf
	move 1,movm_opaque_df	; movdf
	move 2,movm_opaque_df+1	; movdf
	popj 17,

movm_reg:
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_if:
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_if_positive:
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_local:
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_reuse:
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_mem:
	movm 1,(1)
	popj 17,

movm_mem_plus:
	movm 1,(1)
	add 1,2
	popj 17,

movm_mem_minus:
	movm 1,(1)
	sub 1,2
	popj 17,

movm_volatile_mem:
	move 1,(1)
	movm 1,1
	popj 17,

movm_global_a:
	movm 1,movm_ga
	popj 17,

movm_global_b:
	movm 1,movm_gb
	popj 17,

movm_volatile_global:
	move 1,movm_vga
	movm 1,1
	popj 17,

movm_array:
	andi 2,17
	add 1,2
	movm 1,(1)
	popj 17,

movm_global_array:
	andi 1,17
	movm 1,movm_buf(1)
	popj 17,

movm_struct_a:
	movm 1,(1)
	popj 17,

movm_struct_b:
	movm 1,1(1)
	popj 17,

movm_global_struct_a:
	movm 1,movm_gp
	popj 17,

movm_global_struct_b:
	movm 1,movm_gt+1
	popj 17,

movm_indirect:
	movm 1,@(1)
	popj 17,

movm_indexed_indirect:
	andi 2,17
	add 2,(1)
	movm 1,(2)
	popj 17,

movm_qi:
	lsh 1,33
	ash 1,-33
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_hi:
	hrre 1,1
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_qi_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	movm 1,1
	popj 17,

movm_hi_mem:
	ldb 1,1
	hrre 1,1
	movm 1,1
	popj 17,

movm_expr_add:
	add 1,2
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_expr_sub:
	sub 1,2
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_expr_xor:
	xor 1,2
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_expr_and:
	and 1,2
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_negated_expr:
	movn 1,1
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_shift_expr:
	ash 1,-3
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_literal_positive:
	movei 1,123456
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_literal_negative:
	hrroi 1,654322
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movm_literal_large_negative:
	move 1,[-123456123]
	pushj 17,opaque_si
	movm 1,1
	popj 17,

movmm_reg_mem:
	push 17,10
	move 10,2
	pushj 17,opaque_si
	movmm 1,(10)
	pop 17,10
	popj 17,

movmm_reg_mem_ret_mem:
	push 17,10
	move 10,2
	pushj 17,opaque_si
	movm 1,1
	movem 1,(10)
	pop 17,10
	popj 17,

movmm_reg_mem_ret_abs:
	push 17,10
	move 10,2
	pushj 17,opaque_si
	movm 1,1
	movem 1,(10)
	pop 17,10
	popj 17,

movmm_mem_mem:
	move 1,(1)
	movmm 1,(2)
	popj 17,

movmm_mem_mem_ret:
	movm 1,(1)
	movem 1,(2)
	popj 17,

movmm_volatile:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,opaque_si
	movm 4,1
	movem 4,(10)
	pop 17,10
	popj 17,

movmm_global:
	pushj 17,opaque_si
	movm 1,1
	movem 1,movm_ga
	popj 17,

movmm_global_from_mem:
	movm 1,(1)
	movem 1,movm_gb
	popj 17,

movmm_array:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,3
	pushj 17,opaque_si
	andi 10,17
	add 11,10
	movmm 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movmm_array_ret:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,3
	pushj 17,opaque_si
	andi 10,17
	add 11,10
	movm 1,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movmm_global_array:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,opaque_si
	andi 10,17
	movmm 1,movm_buf(10)
	pop 17,10
	popj 17,

movmm_struct_a:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,opaque_si
	movmm 1,(10)
	pop 17,10
	popj 17,

movmm_struct_b:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,opaque_si
	movmm 1,1(10)
	pop 17,10
	popj 17,

movmm_struct_ret:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,opaque_si
	movm 1,1
	movem 1,1(10)
	pop 17,10
	popj 17,

movmm_global_struct:
	pushj 17,opaque_si
	movmm 1,movm_gp+1
	popj 17,

movmm_indirect:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,opaque_si
	movmm 1,@(10)
	pop 17,10
	popj 17,

movmm_indexed_indirect:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,3
	pushj 17,opaque_si
	andi 10,17
	add 10,(11)
	movmm 1,(10)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movms_mem:
	movms 4,(1)
	move 1,4
	popj 17,

movms_mem_add:
	movms 4,(1)
	add 4,2
	move 1,4
	popj 17,

movms_mem_twice:
	movms 4,(1)
	move 1,4
	popj 17,

movms_mem_void:
	movms (1)
	popj 17,

movms_volatile_mem:
	move 4,(1)
	movm 4,4
	movem 4,(1)
	move 1,(1)
	popj 17,

movms_volatile_void:
	move 4,(1)
	movm 4,4
	movem 4,(1)
	popj 17,

movms_global_a:
	movms 1,movm_ga
	popj 17,

movms_global_b:
	movms 1,movm_gb
	popj 17,

movms_global_void:
	movms movm_gc
	popj 17,

movms_array:
	andi 2,17
	add 1,2
	movms 4,(1)
	move 1,4
	popj 17,

movms_array_void:
	andi 2,17
	add 1,2
	movms (1)
	popj 17,

movms_global_array:
	andi 1,17
	movms 4,movm_buf(1)
	move 1,4
	popj 17,

movms_struct_a:
	movms 4,(1)
	move 1,4
	popj 17,

movms_struct_b:
	movms 4,1(1)
	move 1,4
	popj 17,

movms_struct_void:
	movms 1(1)
	popj 17,

movms_global_struct_a:
	movms 1,movm_gp
	popj 17,

movms_global_struct_b:
	movms 1,movm_gt+1
	popj 17,

movms_indirect:
	movms 4,@(1)
	move 1,4
	popj 17,

movms_indexed_indirect:
	andi 2,17
	add 2,(1)
	movms 1,(2)
	popj 17,

movm_branch_reg:
	pushj 17,opaque_si
	movm 1,1
	movei 4,1
	jumpe 1,%L89
	move 4,1
%L89:
	move 1,4
	popj 17,

movm_branch_mem:
	movm 1,(1)
	camge 1,[-1]
	seto 1,
	popj 17,

movms_branch:
	movms 4,(1)
	movei 1,1
	jumpe 4,%L93
	move 1,4
%L93:
	popj 17,

movm_select:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,2
	move 11,3
	pushj 17,opaque_si
	move 10,1
	move 1,12
	pushj 17,opaque_si
	move 12,1
	movm 1,10
	jumpn 11,%L95
	movm 1,12
%L95:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

movm_call_pressure_reg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	pushj 17,opaque_si
	move 11,1
	movm 10,1
	pushj 17,clobber
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movm_call_pressure_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	movm 10,(1)
	pushj 17,clobber
	add 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movmm_call_pressure:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,opaque_si
	movmm 1,(10)
	pushj 17,clobber
	move 1,(10)
	pop 17,10
	popj 17,

movms_call_pressure:
	push 17,10
	move 10,1
	movms (1)
	pushj 17,clobber
	move 1,(10)
	pop 17,10
	popj 17,

movm_two_values:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	pushj 17,opaque_si
	move 10,1
	move 1,11
	pushj 17,opaque_si
	movm 10,10
	movm 4,1
	add 10,4
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movm_two_mems:
	movm 1,(1)
	movm 4,(2)
	add 1,4
	popj 17,

movmm_two_stores:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	move 13,4
	move 1,3
	pushj 17,opaque_si
	move 12,1
	move 1,13
	pushj 17,opaque_si
	move 13,1
	movmm 12,(10)
	movmm 1,(11)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

movms_two_mems:
	move 4,1
	movms (1)
	movms 1,(2)
	add 1,(4)
	popj 17,

movm_loop_sum:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L114:
	move 4,3
	andi 4,17
	add 4,6
	movm 4,(4)
	add 1,4
	addi 3,1
	sojge 2,%L114	; doloop_end
	popj 17,

movms_loop:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L125:
	move 4,3
	andi 4,17
	add 4,1
	movms (4)
	addi 3,1
	sojge 2,%L125	; doloop_end
	popj 17,

movms_loop_sum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L137:
	move 4,6
	andi 4,17
	add 4,7
	movms 3,(4)
	add 1,3
	addi 6,1
	sojge 2,%L137	; doloop_end
	popj 17,

movm2:
	movm 1,(2)
	popj 17,

movmm3:
	push 17,10
	move 10,2
	pushj 17,opaque_si
	movm 1,1
	movem 1,(10)
	pop 17,10
	popj 17,

movms4:
	movms 4,(1)
	move 1,4
	popj 17,

sfmovm_reg:
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	popj 17,

sfmovm_if:
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	popj 17,

sfmovm_if_positive:
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	popj 17,

sfmovm_local:
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	popj 17,

sfmovm_reuse:
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	popj 17,

sfmovm_mem:
	movm 1,(1)
	popj 17,

sfmovm_volatile_mem:
	move 1,(1)	; movsf
	movm 1,1
	popj 17,

sfmovm_global_a:
	movm 1,movm_sfa
	popj 17,

sfmovm_global_b:
	movm 1,movm_sfb
	popj 17,

sfmovm_volatile_global:
	move 1,movm_vsfa	; movsf
	movm 1,1
	popj 17,

sfmovm_array:
	andi 2,17
	add 1,2
	movm 1,(1)
	popj 17,

sfmovm_global_array:
	andi 1,17
	movm 1,movm_sfbuf(1)
	popj 17,

sfmovm_struct_a:
	movm 1,(1)
	popj 17,

sfmovm_struct_b:
	movm 1,1(1)
	popj 17,

sfmovm_global_struct_a:
	movm 1,movm_gfp
	popj 17,

sfmovm_global_struct_b:
	movm 1,movm_gft+1
	popj 17,

sfmovm_expr_add:
			; truncdfsf2
			; truncdfsf2
	fadr 1,3
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	popj 17,

sfmovm_expr_sub:
			; truncdfsf2
			; truncdfsf2
	fsbr 1,3
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	popj 17,

sfmovm_literal_negative:
	move 1,[.long 570024000000]	; movdf
	move 2,[.long 0]	; movdf
	pushj 17,opaque_sf
	movm 1,1
	popj 17,

sfmovmm_reg_mem:
	push 17,10
	move 10,3
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movmm 1,(10)
	pop 17,10
	popj 17,

sfmovmm_reg_mem_ret:
	push 17,10
	move 10,3
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	movem 1,(10)	; movsf
	pop 17,10
	popj 17,

sfmovmm_mem_mem:
	move 1,(1)	; movsf
	movmm 1,(2)
	popj 17,

sfmovmm_global:
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	movem 1,movm_sfa	; movsf
	popj 17,

sfmovmm_array:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
			; truncdfsf2
	move 1,3	; extendsfdf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	andi 10,17
	add 11,10
	movmm 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sfmovmm_struct_a:
	push 17,10
	move 10,1
			; truncdfsf2
	move 1,2	; extendsfdf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movmm 1,(10)
	pop 17,10
	popj 17,

sfmovms_mem:
	movms 4,(1)
	move 1,4	; movsf
	popj 17,

sfmovms_mem_add:
			; truncdfsf2
	movms 4,(1)
	fadr 4,2
	move 1,4	; movsf
	popj 17,

sfmovms_mem_void:
	movms (1)
	popj 17,

sfmovms_volatile_mem:
	move 4,(1)	; movsf
	movm 4,4
	movem 4,(1)	; movsf
	move 1,(1)	; movsf
	popj 17,

sfmovms_global_a:
	movms 1,movm_sfa
	popj 17,

sfmovms_global_b:
	movms 1,movm_sfb
	popj 17,

sfmovms_global_void:
	movms movm_sfc
	popj 17,

sfmovms_array:
	move 4,1
	andi 2,17
	add 4,2
	movms 1,(4)
	popj 17,

sfmovms_global_array:
	move 4,1
	andi 4,17
	movms 1,movm_sfbuf(4)
	popj 17,

sfmovms_struct_a:
	movms 4,(1)
	move 1,4	; movsf
	popj 17,

sfmovms_struct_b:
	movms 4,1(1)
	move 1,4	; movsf
	popj 17,

sfmovm_branch_reg:
			; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 1,1
	movsi 4,(1.00000000000000000000e0)	; movsf
	jumpe 1,%L256
	move 4,1	; movsf
%L256:
	move 1,4	; movsf
	popj 17,

sfmovm_call_pressure_reg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1	; truncdfsf2
	move 1,11	; extendsfdf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	move 11,1	; movsf
	movm 10,1
	pushj 17,clobber
	fadr 10,11
	move 1,10	; movsf
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sfmovm_two_values:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
			; truncdfsf2
	move 11,3	; truncdfsf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	move 10,1	; movsf
	move 1,11	; extendsfdf2
	movei 2,0	; extendsfdf2
	pushj 17,opaque_sf
	movm 10,10
	movm 4,1
	fadr 10,4
	move 1,10	; movsf
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sfmovms_loop_sum:
	move 7,1
	movei 1,0	; movsf
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L283:
	move 3,6
	andi 3,17
	add 3,7
	movms 4,(3)
	fadr 1,4
	addi 6,1
	sojge 2,%L283	; doloop_end
	popj 17,

dfmovm_reg:
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L285
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L285:
	move 1,4	; movdf
	move 2,5	; movdf
	popj 17,

dfmovm_if:
	pushj 17,opaque_df
	jumpge 1,%L287
	pushj 17,__negdf2
%L287:
	popj 17,

dfmovm_if_positive:
	pushj 17,opaque_df
	move 6,1	; movdf
	move 7,2	; movdf
	jumpge 1,%L290
	pushj 17,__negdf2
	move 6,1	; movdf
	move 7,2	; movdf
%L290:
	move 1,6	; movdf
	move 2,7	; movdf
	popj 17,

dfmovm_local:
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L294
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L294:
	move 1,4	; movdf
	move 2,5	; movdf
	popj 17,

dfmovm_reuse:
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L297
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L297:
	move 1,4	; movdf
	move 2,5	; movdf
	popj 17,

dfmovm_mem:
	move 2,(1)
	move 3,1(1)
	move 4,2
	move 5,3
	jumpge 4,%L300
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,__negdf2
	move 2,1	; movdf
	move 3,2	; movdf
%L300:
	move 1,2	; movdf
	move 2,3	; movdf
	popj 17,

dfmovm_volatile_mem:
	move 4,(1)
	move 5,1(1)
	move 1,4	; movdf
	move 2,5	; movdf
	jumpge 1,%L303
	pushj 17,__negdf2
%L303:
	popj 17,

dfmovm_global_a:
	move 1,movm_dfa	; movdf
	move 2,movm_dfa+1	; movdf
	jumpge 1,%L306
	pushj 17,__negdf2
%L306:
	popj 17,

dfmovm_global_b:
	move 1,movm_dfb	; movdf
	move 2,movm_dfb+1	; movdf
	jumpge 1,%L309
	pushj 17,__negdf2
%L309:
	popj 17,

dfmovm_volatile_global:
	move 1,movm_vdfa	; movdf
	move 2,movm_vdfa+1	; movdf
	jumpge 1,%L312
	pushj 17,__negdf2
%L312:
	popj 17,

dfmovm_array:
	andi 2,17
	lsh 2,1
	add 2,1
	move 6,(2)
	move 7,1(2)
	move 4,6
	move 5,7
	jumpge 4,%L315
	move 1,6	; movdf
	move 2,7	; movdf
	pushj 17,__negdf2
	move 6,1	; movdf
	move 7,2	; movdf
%L315:
	move 1,6	; movdf
	move 2,7	; movdf
	popj 17,

dfmovm_global_array:
	andi 1,17
	lsh 1,1
	xmovei 3,movm_dfbuf(1)
	move 6,movm_dfbuf(1)
	move 7,1(3)
	move 4,6
	move 5,7
	jumpge 4,%L320
	move 1,6	; movdf
	move 2,7	; movdf
	pushj 17,__negdf2
	move 6,1	; movdf
	move 7,2	; movdf
%L320:
	move 1,6	; movdf
	move 2,7	; movdf
	popj 17,

dfmovm_struct_a:
	move 2,(1)
	move 3,1(1)
	move 4,2
	move 5,3
	jumpge 4,%L323
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,__negdf2
	move 2,1	; movdf
	move 3,2	; movdf
%L323:
	move 1,2	; movdf
	move 2,3	; movdf
	popj 17,

dfmovm_struct_b:
	move 2,2(1)
	move 3,3(1)
	move 4,2
	move 5,3
	jumpge 4,%L326
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,__negdf2
	move 2,1	; movdf
	move 3,2	; movdf
%L326:
	move 1,2	; movdf
	move 2,3	; movdf
	popj 17,

dfmovm_global_struct_a:
	move 1,movm_gdp
	move 2,movm_gdp+1
	move 4,1
	move 5,2
	jumpge 4,%L329
	pushj 17,__negdf2
%L329:
	popj 17,

dfmovm_global_struct_b:
	move 1,movm_gdt+2
	move 2,movm_gdt+3
	move 4,1
	move 5,2
	jumpge 4,%L332
	pushj 17,__negdf2
%L332:
	popj 17,

dfmovm_expr_add:
	pushj 17,__adddf3
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L335
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L335:
	move 1,4	; movdf
	move 2,5	; movdf
	popj 17,

dfmovm_expr_sub:
	pushj 17,__subdf3
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L338
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L338:
	move 1,4	; movdf
	move 2,5	; movdf
	popj 17,

dfmovm_literal_negative:
	move 1,[.long 570024000000]	; movdf
	move 2,[.long 0]	; movdf
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L341
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L341:
	move 1,4	; movdf
	move 2,5	; movdf
	popj 17,

dfmovmm_reg_mem:
	push 17,10
	move 10,3
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L344
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L344:
	movem 4,(10)
	movem 5,1(10)
	pop 17,10
	popj 17,

dfmovmm_reg_mem_ret:
	push 17,10
	move 10,3
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L347
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L347:
	movem 4,(10)
	movem 5,1(10)
	move 1,4	; movdf
	move 2,5	; movdf
	pop 17,10
	popj 17,

dfmovmm_mem_mem:
	push 17,10
	move 10,2
	move 6,(1)
	move 7,1(1)
	move 4,6
	move 5,7
	jumpge 4,%L350
	move 1,6	; movdf
	move 2,7	; movdf
	pushj 17,__negdf2
	move 6,1	; movdf
	move 7,2	; movdf
%L350:
	movem 6,(10)
	movem 7,1(10)
	pop 17,10
	popj 17,

dfmovmm_global:
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L353
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L353:
	movem 4,movm_dfa	; movdf
	movem 5,movm_dfa+1	; movdf
	move 1,4	; movdf
	move 2,5	; movdf
	popj 17,

dfmovmm_array:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 1,3	; movdf
	move 2,4	; movdf
	pushj 17,opaque_df
	move 3,1	; movdf
	move 4,2	; movdf
	andi 11,17
	lsh 11,1
	add 11,10
	jumpge 1,%L357
	pushj 17,__negdf2
	move 3,1	; movdf
	move 4,2	; movdf
%L357:
	movem 3,(11)
	movem 4,1(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dfmovmm_struct_a:
	push 17,10
	move 10,1
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L360
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L360:
	movem 4,(10)
	movem 5,1(10)
	pop 17,10
	popj 17,

dfmovms_mem:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 2,(1)
	move 3,1(1)
	move 4,2
	move 5,3
	jumpge 4,%L363
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,__negdf2
	move 2,1	; movdf
	move 3,2	; movdf
%L363:
	movem 2,(10)
	movem 3,1(10)
	move 11,(10)
	move 12,3
	move 1,11	; movdf
	move 2,12	; movdf
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

dfmovms_mem_add:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 13,2	; movdf
	move 14,3	; movdf
	move 6,(1)
	move 7,1(1)
	move 4,6
	move 5,7
	jumpge 4,%L366
	move 1,6	; movdf
	move 2,7	; movdf
	pushj 17,__negdf2
	move 6,1	; movdf
	move 7,2	; movdf
%L366:
	movem 6,(10)
	movem 7,1(10)
	move 11,(10)
	move 12,7
	move 1,11	; movdf
	move 2,12	; movdf
	move 3,13	; movdf
	move 4,14	; movdf
	pushj 17,__adddf3
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

dfmovms_mem_void:
	push 17,10
	move 10,1
	move 2,(1)
	move 3,1(1)
	move 4,2
	move 5,3
	jumpge 4,%L369
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,__negdf2
	move 2,1	; movdf
	move 3,2	; movdf
%L369:
	movem 2,(10)
	movem 3,1(10)
	pop 17,10
	popj 17,

dfmovms_volatile_mem:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 4,(1)
	move 5,1(1)
	jumpge 4,%L372
	move 1,4	; movdf
	move 2,5	; movdf
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L372:
	movem 4,(10)
	movem 5,1(10)
	move 11,(10)
	move 12,5
	move 1,11	; movdf
	move 2,12	; movdf
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

dfmovms_global_a:
	move 1,movm_dfa	; movdf
	move 2,movm_dfa+1	; movdf
	jumpge 1,%L375
	pushj 17,__negdf2
%L375:
	movem 1,movm_dfa	; movdf
	movem 2,movm_dfa+1	; movdf
	popj 17,

dfmovms_global_b:
	move 1,movm_dfb	; movdf
	move 2,movm_dfb+1	; movdf
	jumpge 1,%L378
	pushj 17,__negdf2
%L378:
	movem 1,movm_dfb	; movdf
	movem 2,movm_dfb+1	; movdf
	popj 17,

dfmovms_global_void:
	move 1,movm_dfc	; movdf
	move 2,movm_dfc+1	; movdf
	jumpge 1,%L381
	pushj 17,__negdf2
%L381:
	movem 1,movm_dfc	; movdf
	movem 2,movm_dfc+1	; movdf
	popj 17,

dfmovms_array:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,2
	andi 10,17
	lsh 10,1
	add 10,1
	move 6,(10)
	move 7,1(10)
	move 4,6
	move 5,7
	jumpge 4,%L385
	move 1,6	; movdf
	move 2,7	; movdf
	pushj 17,__negdf2
	move 6,1	; movdf
	move 7,2	; movdf
%L385:
	movem 6,(10)
	movem 7,1(10)
	move 11,(10)
	move 12,7
	move 1,11	; movdf
	move 2,12	; movdf
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

dfmovms_global_array:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	andi 10,17
	lsh 10,1
	xmovei 11,movm_dfbuf(10)
	move 2,movm_dfbuf(10)
	move 3,1(11)
	move 4,2
	move 5,3
	jumpge 4,%L391
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,__negdf2
	move 2,1	; movdf
	move 3,2	; movdf
%L391:
	movem 2,movm_dfbuf(10)
	movem 3,1(11)
	move 12,movm_dfbuf(10)
	move 13,3
	move 1,12	; movdf
	move 2,13	; movdf
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

dfmovms_struct_a:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 2,(1)
	move 3,1(1)
	move 4,2
	move 5,3
	jumpge 4,%L394
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,__negdf2
	move 2,1	; movdf
	move 3,2	; movdf
%L394:
	movem 2,(10)
	movem 3,1(10)
	move 11,(10)
	move 12,3
	move 1,11	; movdf
	move 2,12	; movdf
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

dfmovms_struct_b:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 2,2(1)
	move 3,3(1)
	move 4,2
	move 5,3
	jumpge 4,%L397
	move 1,2	; movdf
	move 2,3	; movdf
	pushj 17,__negdf2
	move 2,1	; movdf
	move 3,2	; movdf
%L397:
	movem 2,2(10)
	movem 3,3(10)
	move 11,2(10)
	move 12,3
	move 1,11	; movdf
	move 2,12	; movdf
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

dfmovm_branch_reg:
	pushj 17,opaque_df
	move 4,1	; movdf
	move 5,2	; movdf
	jumpge 1,%L400
	pushj 17,__negdf2
	move 4,1	; movdf
	move 5,2	; movdf
%L400:
	movsi 1,(1.00000000000000000000e0)	; movdf
	movei 2,0	; movdf
	jumpe 4,%L399
	move 1,4	; movdf
	move 2,5	; movdf
%L399:
	popj 17,

dfmovm_call_pressure_reg:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	pushj 17,opaque_df
	move 10,1	; movdf
	move 11,2	; movdf
	move 12,1	; movdf
	move 13,2	; movdf
	jumpge 1,%L405
	pushj 17,__negdf2
	move 12,1	; movdf
	move 13,2	; movdf
%L405:
	pushj 17,clobber
	move 1,12	; movdf
	move 2,13	; movdf
	move 3,10	; movdf
	move 4,11	; movdf
	pushj 17,__adddf3
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

dfmovm_two_values:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,3	; movdf
	move 13,4	; movdf
	pushj 17,opaque_df
	move 10,1	; movdf
	move 11,2	; movdf
	move 1,12	; movdf
	move 2,13	; movdf
	pushj 17,opaque_df
	move 12,1	; movdf
	move 13,2	; movdf
	jumpge 10,%L408
	move 1,10	; movdf
	move 2,11	; movdf
	pushj 17,__negdf2
	move 10,1	; movdf
	move 11,2	; movdf
%L408:
	move 3,12	; movdf
	move 4,13	; movdf
	jumpge 12,%L410
	move 1,12	; movdf
	move 2,13	; movdf
	pushj 17,__negdf2
	move 3,1	; movdf
	move 4,2	; movdf
%L410:
	move 1,10	; movdf
	move 2,11	; movdf
	pushj 17,__adddf3
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

dfmovms_loop_sum:
	add 17,[14,,14]
	movem 16,-13(17)
	movei 0,-12(17)
	hrli 0,10
	blt 0,-5(17)
	setzb 11,12	; movdf
	move 15,11	; movdf
	move 16,12	; movdf
	move 13,11	; movdf
	move 14,12	; movdf
	movem 1,-4(17)
	movem 2,-3(17)
	movem 11,-1(17)	; movdf
	movem 12,(17)	; movdf
	setzb 6,-2(17)
	caml 6,-3(17)
	jrst %L425
%L423:
	move 10,-2(17)
	andi 10,17
	lsh 10,1
	add 10,-4(17)
	move 11,(10)
	move 12,1(10)
	move 15,11
	move 16,12
	jumpge 15,%L418
	move 1,11	; movdf
	move 2,12	; movdf
	pushj 17,__negdf2
	move 11,1	; movdf
	move 12,2	; movdf
%L418:
	movem 11,(10)
	movem 12,1(10)
	move 13,(10)
	move 14,12
	move 1,-1(17)	; movdf
	move 2,(17)	; movdf
	move 3,13	; movdf
	move 4,14	; movdf
	pushj 17,__adddf3
	movem 1,-1(17)	; movdf
	movem 2,(17)	; movdf
	aos 6,-2(17)
	camge 6,-3(17)
	jrst %L423
%L425:
	move 1,-1(17)	; movdf
	move 2,(17)	; movdf
	move 16,-13(17)
	movei 0,10
	hrli 0,-12(17)
	blt 0,15
	add 17,[-14,,-14]
	popj 17,

	.globl	movm_smoke
movm_smoke:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	move 11,3
	pushj 17,movm_reg
	move 10,1
	move 1,11
	pushj 17,movm_mem
	add 10,1
	move 1,12
	move 2,13
	pushj 17,movm_expr_sub
	add 10,1
	move 1,11
	pushj 17,movms_mem
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.globl	sfmovm_smoke
sfmovm_smoke:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 10,3	; movdf
	move 11,4	; movdf
			; truncdfsf2
			; truncdfsf2
	move 12,1	; extendsfdf2
	movei 13,0	; extendsfdf2
	move 1,12	; movdf
	move 2,13	; movdf
	pushj 17,sfmovm_reg
	move 14,1	; movsf
	move 3,10	; extendsfdf2
	movei 4,0	; extendsfdf2
	move 1,12	; movdf
	move 2,13	; movdf
	pushj 17,sfmovm_expr_sub
	fadr 14,1
	move 1,-6(17)
	pushj 17,sfmovms_mem
	fadr 14,1
	move 1,14	; movsf
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.globl	dfmovm_smoke
dfmovm_smoke:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 10,1	; movdf
	move 11,2	; movdf
	move 12,3	; movdf
	move 13,4	; movdf
	pushj 17,dfmovm_reg
	move 14,1	; movdf
	move 15,2	; movdf
	move 1,10	; movdf
	move 2,11	; movdf
	move 3,12	; movdf
	move 4,13	; movdf
	pushj 17,dfmovm_expr_sub
	move 3,1	; movdf
	move 4,2	; movdf
	move 1,14	; movdf
	move 2,15	; movdf
	pushj 17,__adddf3
	move 10,1	; movdf
	move 11,2	; movdf
	move 1,-7(17)
	pushj 17,dfmovms_mem
	move 3,1	; movdf
	move 4,2	; movdf
	move 1,10	; movdf
	move 2,11	; movdf
	pushj 17,__adddf3
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

movms_both_memaa:
	movms 1,(2)
	popj 17,

movms_both_memab:
	movms 1,(2)
	popj 17,

movms_both_memba:
	movms 1,(2)
	popj 17,

movms_both_membb:
	movms 1,(2)
	popj 17,

movmm_both_regaa:
	movm 1,1
	movem 1,(2)
	popj 17,

movmm_both_regab:
	movm 1,1
	movem 1,(2)
	popj 17,

movmm_both_regba:
	movm 1,1
	movem 1,(2)
	popj 17,

movmm_both_regbb:
	movm 1,1
	movem 1,(2)
	popj 17,

	.bss
movm_ga:
	.space	4
movm_gb:
	.space	4
movm_gc:
	.space	4
movm_vga:
	.space	4
movm_opaque_si:
	.space	4
movm_buf:
	.space	64
movm_sfa:
	.space	4
movm_sfb:
	.space	4
movm_sfc:
	.space	4
movm_vsfa:
	.space	4
movm_opaque_sf:
	.space	4
movm_sfbuf:
	.space	64
movm_dfa:
	.space	8
movm_dfb:
	.space	8
movm_dfc:
	.space	8
movm_vdfa:
	.space	8
movm_opaque_df:
	.space	8
movm_dfbuf:
	.space	128
movm_gp:
	.space	8
movm_gt:
	.space	12
movm_gfp:
	.space	8
movm_gft:
	.space	12
movm_gdp:
	.space	16
movm_gdt:
	.space	24
