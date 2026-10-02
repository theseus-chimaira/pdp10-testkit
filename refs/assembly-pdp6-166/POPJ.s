
popj_void:
	popj 17,

popj_void_call:
	jrst clobber

popj_sint_zero:
	movei 1,0
	popj 17,

popj_sint_one:
	movei 1,1
	popj 17,

popj_sint_arg:
	popj 17,

popj_sint_add:
	add 1,2
	popj 17,

popj_sint_global:
	move 1,popj_ga
	popj 17,

popj_sint_store_return:
	movem 1,popj_ga
	popj 17,

popj_sint_call:
	jrst ext_sint

popj_sint_call_add:
	push 17,10
	move 10,2
	pushj 17,ext_sint
	add 1,10
	pop 17,10
	popj 17,

popj_sint_after_call:
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

popj_usint_arg:
	popj 17,

popj_usint_add:
	add 1,2
	popj 17,

popj_usint_call:
	jrst ext_usint

popj_sfloat_arg:
			; truncdfsf2
	popj 17,

popj_sfloat_add:
			; truncdfsf2
			; truncdfsf2
	fadr 1,3
	popj 17,

popj_sfloat_call:
			; truncdfsf2
	jrst ext_sfloat

popj_ptr_arg:
	popj 17,

popj_ptr_inc:
	addi 1,1
	popj 17,

popj_ptr_call:
	jrst ext_ptr

popj_vptr_arg:
	popj 17,

popj_vptr_call:
	jrst ext_vptr

popj_struct_return:
	move 4,1
	move 5,2
	move 1,4
	move 2,5
	popj 17,

popj_struct_global:
	move 1,popj_gp
	move 2,popj_gp+1
	popj 17,

popj_many_args:
	add 1,2
	add 1,3
	add 1,4
	add 1,-1(17)
	add 1,-2(17)
	popj 17,

popj_many_locals:
	add 1,2
	add 1,popj_ga
	add 1,popj_gb
	xori 1,123456
	popj 17,

popj_branch:
	camle 1,2
	move 1,2
	popj 17,

popj_branch_call:
	caml 1,2
	move 1,2
	jrst ext_sint

popj_loop:
	setzb 3,4
	caml 3,1
	jrst %L39
	subi 1,1
%L40:
	add 3,4
	addi 4,1
	sojge 1,%L40	; doloop_end
%L39:
	move 1,3
	popj 17,

popj_switch:
	move 4,1
	andi 4,3
	cain 4,1
	jrst %L44
	caig 4,1
	jrst %L49
	caie 4,2
%L41:
	popj 17,
	move 1,popj_ga
	add 1,popj_gb
	popj 17,
%L49:
	jumpn 4,%L41
	move 1,popj_ga
	popj 17,
%L44:
	move 1,popj_gb
	popj 17,

popj_store_globals:
	movem 1,popj_ga
	movem 2,popj_gb
	popj 17,

popj_store_unsigned:
	xor 1,2
	movem 1,popj_uga
	popj 17,

popj_store_float:
			; truncdfsf2
	movem 1,popj_fa	; movsf
	popj 17,

popj_computed_arg:
	jumpe 1,%L54
	move 4,1
	tlo 4,331100
%L54:
	jrst (4)

popj_computed_local:
	skipn 1,(1)
	jrst (4)
	move 4,1
	tlo 4,331100
	jrst (4)

popj_computed_store:
	skipn 1,(1)
	jrst (4)
	move 4,1
	tlo 4,331100
	jrst (4)

	.bss
popj_ga:
	.space	4
popj_gb:
	.space	4
popj_uga:
	.space	4
popj_fa:
	.space	4
popj_gp:
	.space	8
