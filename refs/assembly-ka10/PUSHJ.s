
pushj_direct_void:
	jrst scalar_memory_forms

pushj_direct_void_ext:
	jrst exv0

pushj_direct_void_arg:
	jrst exv1

pushj_direct_void_two:
	jrst exv2

pushj_direct_void_ptr:
	jrst exvp

pushj_direct_return0:
	jrst exs0

pushj_direct_return1:
	jrst exs1

pushj_direct_return2:
	jrst exs2

pushj_direct_ureturn:
	jrst ext_usint1

pushj_direct_freturn:
			; truncdfsf2
	jrst ext_sfloat1

pushj_direct_ptr_return:
	jrst ext_ptr1

pushj_direct_no_tail:
	pushj 17,exs1
	movem 1,pushj_ga
	addi 1,1
	popj 17,

pushj_direct_no_tail2:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	pushj 17,exs2
	xor 11,1
	movem 11,pushj_gb
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

pushj_direct_float_no_tail:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1	; movdf
	move 11,2	; movdf
			; truncdfsf2
	move 1,10	; movsf
	pushj 17,ext_sfloat1
	movem 1,pushj_fa	; movsf
	fadr 10,1
	move 1,10	; movsf
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

pushj_funcptr_void:
	pushj 17,(1)
	popj 17,

pushj_funcptr_void_no_tail:
	pushj 17,(1)
	aos pushj_ga
	popj 17,

pushj_funcptr_arg:
	move 4,1
	move 1,2
	pushj 17,(4)
	popj 17,

pushj_funcptr_arg_no_tail:
	push 17,10
	move 4,1
	move 10,2
	move 1,2
	pushj 17,(4)
	movem 10,pushj_ga
	pop 17,10
	popj 17,

pushj_funcptr_return:
	move 4,1
	move 1,2
	pushj 17,(4)
	popj 17,

pushj_funcptr_return_no_tail:
	move 4,1
	move 1,2
	pushj 17,(4)
	movem 1,pushj_ga
	addi 1,1
	popj 17,

pushj_funcptr_return2:
	move 4,1
	move 1,2
	move 2,3
	pushj 17,(4)
	popj 17,

pushj_funcptr_return2_no_tail:
	push 17,10
	move 4,1
	move 10,2
	move 1,2
	move 2,3
	pushj 17,(4)
	movem 1,pushj_gb
	xor 1,10
	pop 17,10
	popj 17,

pushj_funcptr_float:
	move 4,1
			; truncdfsf2
	move 1,2	; movsf
	pushj 17,(4)
	popj 17,

pushj_funcptr_float_no_tail:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 4,1
	move 10,2	; movdf
	move 11,3	; movdf
			; truncdfsf2
	move 1,10	; movsf
	pushj 17,(4)
	movem 1,pushj_fa	; movsf
	fadr 10,1
	move 1,10	; movsf
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

pushj_global_void:
	move 4,pushj_vfp
	pushj 17,(4)
	popj 17,

pushj_global_void_no_tail:
	move 4,pushj_vfp
	pushj 17,(4)
	aos pushj_ga
	popj 17,

pushj_global_return:
	pushj 17,@pushj_sfp
	popj 17,

pushj_global_return_no_tail:
	push 17,10
	move 10,1
	pushj 17,@pushj_sfp
	movem 1,pushj_ga
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

pushj_global_return2:
	pushj 17,@pushj_sfp2
	popj 17,

pushj_global_float:
			; truncdfsf2
	pushj 17,@pushj_ffp
	popj 17,

pushj_array_void:
	andi 1,7
	pushj 17,@@pushj_vtab(1)
	popj 17,

pushj_array_void_no_tail:
	push 17,10
	move 10,1
	move 4,1
	andi 4,7
	pushj 17,@@pushj_vtab(4)
	movem 10,pushj_ga
	pop 17,10
	popj 17,

pushj_array_return:
	move 4,1
	andi 4,7
	move 1,2
	pushj 17,@pushj_stab(4)
	popj 17,

pushj_array_return_no_tail:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,1
	andi 10,7
	move 1,2
	pushj 17,@pushj_stab(10)
	movem 1,pushj_buf(10)
	add 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

pushj_struct_void:
	pushj 17,@@(1)
	popj 17,

pushj_struct_void_arg:
	move 4,1
	move 1,2
	pushj 17,@@1(4)
	popj 17,

pushj_struct_return:
	move 4,1
	move 1,2
	pushj 17,@2(4)
	popj 17,

pushj_struct_return2:
	move 4,1
	move 1,2
	move 2,3
	pushj 17,@3(4)
	popj 17,

pushj_struct_float:
	move 4,1
			; truncdfsf2
	move 1,2	; movsf
	pushj 17,@4(4)
	popj 17,

pushj_global_struct_void:
	move 4,pushj_gp
	pushj 17,(4)
	popj 17,

pushj_global_struct_return:
	pushj 17,@pushj_gp+2
	popj 17,

pushj_global_struct_return_no_tail:
	pushj 17,@pushj_gp+2
	movem 1,pushj_ga
	addi 1,1
	popj 17,

pushj_nested_direct:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,exs1
	move 10,1
	move 2,11
	pushj 17,exs2
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

pushj_mixed_direct_indirect:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,2
	pushj 17,exs1
	move 10,1
	pushj 17,(11)
	move 2,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	jrst exs2

pushj_call_in_branch:
	move 4,1
	move 1,2
	jumpl 2,exs1
	pushj 17,(4)
	popj 17,
%L47:
	jrst exs1

pushj_call_in_branch_no_tail:
	move 4,1
	move 1,2
	jumpl 2,%L51
	pushj 17,(4)
%L50:
	movem 1,pushj_ga
	addi 1,1
	popj 17,
%L51:
	pushj 17,exs1
	jrst %L50

pushj_call_in_loop:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	setzb 11,10
	camge 11,2
	jrst %L57
%L59:
	move 1,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L57:
	move 1,10
	pushj 17,(13)
	add 11,1
	addi 10,1
	camge 10,12
	jrst %L57
	jrst %L59

pushj_call_through_temp:
	move 4,1
	move 1,2
	pushj 17,(4)
	popj 17,

pushj_call_void_through_temp:
	pushj 17,(1)
	popj 17,

pushj_return_and_store:
	move 4,1
	move 1,2
	pushj 17,(4)
	movem 1,pushj_uga
	popj 17,

pushj_reg:
	addi 1,1
	move 6,[POINT 18,%L64,35]
	movem 6,(1)
%L64:
	popj 17,

pushj_reg_arg:
	movem 3,pushj_ga
	addi 1,1
	move 6,[POINT 18,%L67,35]
	movem 6,(1)
%L67:
	addi 3,1
	movem 3,pushj_gb
	popj 17,

pushj_sym:
	addi 1,1
	move 6,[POINT 18,%L70,35]
	movem 6,(1)
%L70:
	popj 17,

pushj_sym_arg:
	movem 2,pushj_ga
	addi 1,1
	move 6,[POINT 18,%L75,35]
	movem 6,(1)
%L75:
	popj 17,

	.bss
pushj_vfp:
	.space	4
pushj_sfp:
	.space	4
pushj_sfp2:
	.space	4
pushj_ffp:
	.space	4
pushj_vtab:
	.space	32
pushj_stab:
	.space	32
pushj_ga:
	.space	4
pushj_gb:
	.space	4
pushj_uga:
	.space	4
pushj_fa:
	.space	4
pushj_buf:
	.space	32
pushj_gp:
	.space	20
