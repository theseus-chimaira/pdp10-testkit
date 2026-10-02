	.data
	.align	2
ptr_scalar_schar:
	.long	scalar_schar+301989888
	.align	2
ptr_array_schar:
	.long	array_schar+150994944

ld_static_schar:
	hrre 1,scalar_schar
	popj 17,

st_static_schar:
	movem 1,scalar_schar
	popj 17,

st_ret_static_schar:
	movem 1,scalar_schar
	lsh 1,33
	ash 1,-33
	popj 17,

ld_volatile_schar:
	hrre 1,vscalar_schar
	popj 17,

st_volatile_schar:
	movem 1,vscalar_schar
	popj 17,

ld_struct_schar:
	move 1,box_schar
	ash 1,-33
	popj 17,

st_struct_schar:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,box_schar,8]
	addi 1,1
	dpb 1,[POINT 9,box_schar,17]
	popj 17,

ld_vstruct_schar:
	ldb 1,[POINT 9,vbox_schar,8]
	lsh 1,33
	ash 1,-33
	popj 17,

st_vstruct_schar:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vbox_schar,8]
	addi 1,1
	dpb 1,[POINT 9,vbox_schar,17]
	popj 17,

ld_array_schar:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_schar,8]
	jumpe 4,%L14
%L13:
	ibp 3
	sojn 4,%L13	; decrement_and_branch_until_zero
%L14:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

st_array_schar:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_schar,8]
	jumpe 4,%L17
%L16:
	ibp 3
	sojn 4,%L16	; decrement_and_branch_until_zero
%L17:
	dpb 2,3
	popj 17,

st_ret_array_schar:
	andi 2,777	; zero_extendqisi2
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 9,array_schar,8]
	jumpe 4,%L20
%L19:
	ibp 3
	sojn 4,%L19	; decrement_and_branch_until_zero
%L20:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 9,array_schar,8]
	jumpe 1,%L22
%L21:
	ibp 4
	sojn 1,%L21	; decrement_and_branch_until_zero
%L22:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ld_varray_schar:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,varray_schar,8]
	jumpe 4,%L25
%L24:
	ibp 1
	sojn 4,%L24	; decrement_and_branch_until_zero
%L25:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

st_varray_schar:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,varray_schar,8]
	jumpe 4,%L28
%L27:
	ibp 3
	sojn 4,%L27	; decrement_and_branch_until_zero
%L28:
	dpb 2,3
	popj 17,

ld_pointer_schar:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

st_pointer_schar:
	dpb 2,1
	popj 17,

st_ret_pointer_schar:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

ld_global_pointer_schar:
	ldb 1,ptr_scalar_schar
	ldb 6,ptr_array_schar
	add 1,6
	lsh 1,33
	ash 1,-33
	popj 17,

ptr_static_schar:
	move 1,[POINT 18,scalar_schar,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,array_schar,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,box_schar,8]
	jrst scalar_memory_forms

ld_stack_schar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_schar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_schar:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,331100
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_schar:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,scalar_schar,35]
	add 1,6
	movem 1,scalar_schar
	lsh 1,33
	ash 1,-33
	popj 17,

update_pointer_schar:
	andi 2,777	; zero_extendqisi2
	ldb 6,1
	add 2,6
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

sum_array_schar:
	setzb 6,2
	caml 6,1
	jrst %L56
	subi 1,1
%L57:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_schar,8]
	jumpe 4,%L53
%L52:
	ibp 3
	sojn 4,%L52	; decrement_and_branch_until_zero
%L53:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 6,4
	addi 2,1
	sojge 1,%L57	; doloop_end
%L56:
	move 1,6
	popj 17,

call_with_scalar_schar:
	push 17,10
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_schar:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 13,2
	andi 10,777
	move 15,2
	andi 15,7
	move 14,2
	andi 14,3
	move 4,14
	move 12,15
	ash 12,-2	; ashrsi3_pointer
	add 12,[POINT 9,array_schar,8]
	jumpe 14,%L63
%L62:
	ibp 12
	sojn 4,%L62	; decrement_and_branch_until_zero
%L63:
	move 11,10
	lsh 11,33
	ash 11,-33
	move 1,11
	pushj 17,st_static_schar
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_volatile_schar
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_struct_schar
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_vstruct_schar
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,15
	pushj 17,st_array_schar
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,14
	pushj 17,st_varray_schar
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,12
	pushj 17,st_pointer_schar
	pushj 17,ptr_static_schar
	move 1,11
	pushj 17,ptr_stack_schar
	pushj 17,ld_static_schar
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,11
	pushj 17,st_ret_static_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_volatile_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_struct_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_vstruct_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,15
	pushj 17,ld_array_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	addi 13,1
	andi 13,7
	move 1,13
	move 2,11
	pushj 17,st_ret_array_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,14
	pushj 17,ld_varray_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	pushj 17,ld_pointer_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	move 2,11
	pushj 17,st_ret_pointer_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_global_pointer_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,ld_stack_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,st_stack_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,update_static_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	move 2,11
	pushj 17,update_pointer_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	movei 1,4
	pushj 17,sum_array_schar
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_schar
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_schar:
	lsh 1,33
	ash 1,-33
	seto 4,
	jumpl 1,%L64
	skipe 4,1
	movei 4,1
%L64:
	move 1,4
	popj 17,

sign_load_static_schar:
	hrre 1,scalar_schar
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_uchar:
	.long	scalar_uchar+301989888
	.align	2
ptr_array_uchar:
	.long	array_uchar+150994944

ld_static_uchar:
	move 1,scalar_uchar
	popj 17,

st_static_uchar:
	movem 1,scalar_uchar
	popj 17,

st_ret_static_uchar:
	movem 1,scalar_uchar
	popj 17,

ld_volatile_uchar:
	move 1,vscalar_uchar
	popj 17,

st_volatile_uchar:
	movem 1,vscalar_uchar
	popj 17,

ld_struct_uchar:
	move 1,box_uchar
	lsh 1,-33
	popj 17,

st_struct_uchar:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,box_uchar,8]
	addi 1,1
	dpb 1,[POINT 9,box_uchar,17]
	popj 17,

ld_vstruct_uchar:
	ldb 1,[POINT 9,vbox_uchar,8]
	popj 17,

st_vstruct_uchar:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vbox_uchar,8]
	addi 1,1
	dpb 1,[POINT 9,vbox_uchar,17]
	popj 17,

ld_array_uchar:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uchar,8]
	jumpe 4,%L81
%L80:
	ibp 3
	sojn 4,%L80	; decrement_and_branch_until_zero
%L81:
	ldb 1,3
	popj 17,

st_array_uchar:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uchar,8]
	jumpe 4,%L84
%L83:
	ibp 3
	sojn 4,%L83	; decrement_and_branch_until_zero
%L84:
	dpb 2,3
	popj 17,

st_ret_array_uchar:
	andi 2,777	; zero_extendqisi2
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 9,array_uchar,8]
	jumpe 4,%L87
%L86:
	ibp 3
	sojn 4,%L86	; decrement_and_branch_until_zero
%L87:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 9,array_uchar,8]
	jumpe 1,%L89
%L88:
	ibp 4
	sojn 1,%L88	; decrement_and_branch_until_zero
%L89:
	ldb 1,4
	popj 17,

ld_varray_uchar:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,varray_uchar,8]
	jumpe 4,%L92
%L91:
	ibp 1
	sojn 4,%L91	; decrement_and_branch_until_zero
%L92:
	ldb 1,1
	popj 17,

st_varray_uchar:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,varray_uchar,8]
	jumpe 4,%L95
%L94:
	ibp 3
	sojn 4,%L94	; decrement_and_branch_until_zero
%L95:
	dpb 2,3
	popj 17,

ld_pointer_uchar:
	ldb 1,1
	popj 17,

st_pointer_uchar:
	dpb 2,1
	popj 17,

st_ret_pointer_uchar:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	move 1,2
	popj 17,

ld_global_pointer_uchar:
	ldb 1,ptr_scalar_uchar
	ldb 6,ptr_array_uchar
	add 1,6
	andi 1,777	; zero_extendqisi2
	popj 17,

ptr_static_uchar:
	move 1,[POINT 18,scalar_uchar,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,array_uchar,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,box_uchar,8]
	jrst scalar_memory_forms

ld_stack_uchar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_uchar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_uchar:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,331100
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_uchar:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,scalar_uchar,35]
	add 1,6
	movem 1,scalar_uchar
	andi 1,777
	popj 17,

update_pointer_uchar:
	andi 2,777	; zero_extendqisi2
	ldb 6,1
	add 2,6
	dpb 2,1
	andi 2,777
	move 1,2
	popj 17,

sum_array_uchar:
	setzb 6,2
	caml 6,1
	jrst %L123
	subi 1,1
%L124:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uchar,8]
	jumpe 4,%L120
%L119:
	ibp 3
	sojn 4,%L119	; decrement_and_branch_until_zero
%L120:
	ldb 3,3
	add 6,3
	addi 2,1
	sojge 1,%L124	; doloop_end
%L123:
	move 1,6
	popj 17,

call_with_scalar_uchar:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_uchar:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 13,2
	move 11,1
	andi 11,777	; zero_extendqisi2
	move 15,2
	andi 15,7
	move 14,2
	andi 14,3
	move 4,14
	move 12,15
	ash 12,-2	; ashrsi3_pointer
	add 12,[POINT 9,array_uchar,8]
	jumpe 14,%L130
%L129:
	ibp 12
	sojn 4,%L129	; decrement_and_branch_until_zero
%L130:
	move 1,11
	pushj 17,st_static_uchar
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_volatile_uchar
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_struct_uchar
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_vstruct_uchar
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	move 1,15
	pushj 17,st_array_uchar
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	move 1,14
	pushj 17,st_varray_uchar
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	subi 11,6
	move 1,12
	pushj 17,st_pointer_uchar
	pushj 17,ptr_static_uchar
	move 1,11
	pushj 17,ptr_stack_uchar
	pushj 17,ld_static_uchar
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,11
	pushj 17,st_ret_static_uchar
	add 10,1
	pushj 17,ld_volatile_uchar
	add 10,1
	pushj 17,ld_struct_uchar
	add 10,1
	pushj 17,ld_vstruct_uchar
	add 10,1
	move 1,15
	pushj 17,ld_array_uchar
	add 10,1
	addi 13,1
	andi 13,7
	move 1,13
	move 2,11
	pushj 17,st_ret_array_uchar
	add 10,1
	move 1,14
	pushj 17,ld_varray_uchar
	add 10,1
	move 1,12
	pushj 17,ld_pointer_uchar
	add 10,1
	move 1,12
	move 2,11
	pushj 17,st_ret_pointer_uchar
	add 10,1
	pushj 17,ld_global_pointer_uchar
	add 10,1
	move 1,11
	pushj 17,ld_stack_uchar
	add 10,1
	move 1,11
	pushj 17,st_stack_uchar
	add 10,1
	move 1,11
	pushj 17,update_static_uchar
	add 10,1
	move 1,12
	move 2,11
	pushj 17,update_pointer_uchar
	add 10,1
	movei 1,4
	pushj 17,sum_array_uchar
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_uchar
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_uchar:
	ldb 1,1
	popj 17,

unsigned_branch_uchar:
	andi 1,777	; zero_extendqisi2
	movei 3,0
	jumpe 1,%L132
	tlc 1,400000
	move 6,[-377777777601]
	camle 1,6
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L132:
	move 1,3
	popj 17,

	.data
	.align	2
ptr_scalar_sQint:
	.long	scalar_sQint+301989888
	.align	2
ptr_array_sQint:
	.long	array_sQint+150994944

ld_static_sQint:
	hrre 1,scalar_sQint
	popj 17,

st_static_sQint:
	movem 1,scalar_sQint
	popj 17,

st_ret_static_sQint:
	movem 1,scalar_sQint
	lsh 1,33
	ash 1,-33
	popj 17,

ld_volatile_sQint:
	hrre 1,vscalar_sQint
	popj 17,

st_volatile_sQint:
	movem 1,vscalar_sQint
	popj 17,

ld_struct_sQint:
	move 1,box_sQint
	ash 1,-33
	popj 17,

st_struct_sQint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,box_sQint,8]
	addi 1,1
	dpb 1,[POINT 9,box_sQint,17]
	popj 17,

ld_vstruct_sQint:
	ldb 1,[POINT 9,vbox_sQint,8]
	lsh 1,33
	ash 1,-33
	popj 17,

st_vstruct_sQint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vbox_sQint,8]
	addi 1,1
	dpb 1,[POINT 9,vbox_sQint,17]
	popj 17,

ld_array_sQint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sQint,8]
	jumpe 4,%L148
%L147:
	ibp 3
	sojn 4,%L147	; decrement_and_branch_until_zero
%L148:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

st_array_sQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sQint,8]
	jumpe 4,%L151
%L150:
	ibp 3
	sojn 4,%L150	; decrement_and_branch_until_zero
%L151:
	dpb 2,3
	popj 17,

st_ret_array_sQint:
	andi 2,777	; zero_extendqisi2
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 9,array_sQint,8]
	jumpe 4,%L154
%L153:
	ibp 3
	sojn 4,%L153	; decrement_and_branch_until_zero
%L154:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 9,array_sQint,8]
	jumpe 1,%L156
%L155:
	ibp 4
	sojn 1,%L155	; decrement_and_branch_until_zero
%L156:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ld_varray_sQint:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,varray_sQint,8]
	jumpe 4,%L159
%L158:
	ibp 1
	sojn 4,%L158	; decrement_and_branch_until_zero
%L159:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

st_varray_sQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,varray_sQint,8]
	jumpe 4,%L162
%L161:
	ibp 3
	sojn 4,%L161	; decrement_and_branch_until_zero
%L162:
	dpb 2,3
	popj 17,

ld_pointer_sQint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

st_pointer_sQint:
	dpb 2,1
	popj 17,

st_ret_pointer_sQint:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

ld_global_pointer_sQint:
	ldb 1,ptr_scalar_sQint
	ldb 6,ptr_array_sQint
	add 1,6
	lsh 1,33
	ash 1,-33
	popj 17,

ptr_static_sQint:
	move 1,[POINT 18,scalar_sQint,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,array_sQint,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,box_sQint,8]
	jrst scalar_memory_forms

ld_stack_sQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_sQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_sQint:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,331100
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_sQint:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,scalar_sQint,35]
	add 1,6
	movem 1,scalar_sQint
	lsh 1,33
	ash 1,-33
	popj 17,

update_pointer_sQint:
	andi 2,777	; zero_extendqisi2
	ldb 6,1
	add 2,6
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

sum_array_sQint:
	setzb 6,2
	caml 6,1
	jrst %L190
	subi 1,1
%L191:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sQint,8]
	jumpe 4,%L187
%L186:
	ibp 3
	sojn 4,%L186	; decrement_and_branch_until_zero
%L187:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 6,4
	addi 2,1
	sojge 1,%L191	; doloop_end
%L190:
	move 1,6
	popj 17,

call_with_scalar_sQint:
	push 17,10
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_sQint:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 13,2
	andi 10,777
	move 15,2
	andi 15,7
	move 14,2
	andi 14,3
	move 4,14
	move 12,15
	ash 12,-2	; ashrsi3_pointer
	add 12,[POINT 9,array_sQint,8]
	jumpe 14,%L197
%L196:
	ibp 12
	sojn 4,%L196	; decrement_and_branch_until_zero
%L197:
	move 11,10
	lsh 11,33
	ash 11,-33
	move 1,11
	pushj 17,st_static_sQint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_volatile_sQint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_struct_sQint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_vstruct_sQint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,15
	pushj 17,st_array_sQint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,14
	pushj 17,st_varray_sQint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,12
	pushj 17,st_pointer_sQint
	pushj 17,ptr_static_sQint
	move 1,11
	pushj 17,ptr_stack_sQint
	pushj 17,ld_static_sQint
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,11
	pushj 17,st_ret_static_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_volatile_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_struct_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_vstruct_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,15
	pushj 17,ld_array_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	addi 13,1
	andi 13,7
	move 1,13
	move 2,11
	pushj 17,st_ret_array_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,14
	pushj 17,ld_varray_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	pushj 17,ld_pointer_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	move 2,11
	pushj 17,st_ret_pointer_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_global_pointer_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,ld_stack_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,st_stack_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,update_static_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	move 2,11
	pushj 17,update_pointer_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	movei 1,4
	pushj 17,sum_array_sQint
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_sQint
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_sQint:
	lsh 1,33
	ash 1,-33
	seto 4,
	jumpl 1,%L198
	skipe 4,1
	movei 4,1
%L198:
	move 1,4
	popj 17,

sign_load_static_sQint:
	hrre 1,scalar_sQint
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_uQint:
	.long	scalar_uQint+301989888
	.align	2
ptr_array_uQint:
	.long	array_uQint+150994944

ld_static_uQint:
	move 1,scalar_uQint
	popj 17,

st_static_uQint:
	movem 1,scalar_uQint
	popj 17,

st_ret_static_uQint:
	movem 1,scalar_uQint
	popj 17,

ld_volatile_uQint:
	move 1,vscalar_uQint
	popj 17,

st_volatile_uQint:
	movem 1,vscalar_uQint
	popj 17,

ld_struct_uQint:
	move 1,box_uQint
	lsh 1,-33
	popj 17,

st_struct_uQint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,box_uQint,8]
	addi 1,1
	dpb 1,[POINT 9,box_uQint,17]
	popj 17,

ld_vstruct_uQint:
	ldb 1,[POINT 9,vbox_uQint,8]
	popj 17,

st_vstruct_uQint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vbox_uQint,8]
	addi 1,1
	dpb 1,[POINT 9,vbox_uQint,17]
	popj 17,

ld_array_uQint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uQint,8]
	jumpe 4,%L215
%L214:
	ibp 3
	sojn 4,%L214	; decrement_and_branch_until_zero
%L215:
	ldb 1,3
	popj 17,

st_array_uQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uQint,8]
	jumpe 4,%L218
%L217:
	ibp 3
	sojn 4,%L217	; decrement_and_branch_until_zero
%L218:
	dpb 2,3
	popj 17,

st_ret_array_uQint:
	andi 2,777	; zero_extendqisi2
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 9,array_uQint,8]
	jumpe 4,%L221
%L220:
	ibp 3
	sojn 4,%L220	; decrement_and_branch_until_zero
%L221:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 9,array_uQint,8]
	jumpe 1,%L223
%L222:
	ibp 4
	sojn 1,%L222	; decrement_and_branch_until_zero
%L223:
	ldb 1,4
	popj 17,

ld_varray_uQint:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,varray_uQint,8]
	jumpe 4,%L226
%L225:
	ibp 1
	sojn 4,%L225	; decrement_and_branch_until_zero
%L226:
	ldb 1,1
	popj 17,

st_varray_uQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,varray_uQint,8]
	jumpe 4,%L229
%L228:
	ibp 3
	sojn 4,%L228	; decrement_and_branch_until_zero
%L229:
	dpb 2,3
	popj 17,

ld_pointer_uQint:
	ldb 1,1
	popj 17,

st_pointer_uQint:
	dpb 2,1
	popj 17,

st_ret_pointer_uQint:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	move 1,2
	popj 17,

ld_global_pointer_uQint:
	ldb 1,ptr_scalar_uQint
	ldb 6,ptr_array_uQint
	add 1,6
	andi 1,777	; zero_extendqisi2
	popj 17,

ptr_static_uQint:
	move 1,[POINT 18,scalar_uQint,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,array_uQint,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,box_uQint,8]
	jrst scalar_memory_forms

ld_stack_uQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_uQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_uQint:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,331100
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_uQint:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,scalar_uQint,35]
	add 1,6
	movem 1,scalar_uQint
	andi 1,777
	popj 17,

update_pointer_uQint:
	andi 2,777	; zero_extendqisi2
	ldb 6,1
	add 2,6
	dpb 2,1
	andi 2,777
	move 1,2
	popj 17,

sum_array_uQint:
	setzb 6,2
	caml 6,1
	jrst %L257
	subi 1,1
%L258:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uQint,8]
	jumpe 4,%L254
%L253:
	ibp 3
	sojn 4,%L253	; decrement_and_branch_until_zero
%L254:
	ldb 3,3
	add 6,3
	addi 2,1
	sojge 1,%L258	; doloop_end
%L257:
	move 1,6
	popj 17,

call_with_scalar_uQint:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_uQint:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 13,2
	move 11,1
	andi 11,777	; zero_extendqisi2
	move 15,2
	andi 15,7
	move 14,2
	andi 14,3
	move 4,14
	move 12,15
	ash 12,-2	; ashrsi3_pointer
	add 12,[POINT 9,array_uQint,8]
	jumpe 14,%L264
%L263:
	ibp 12
	sojn 4,%L263	; decrement_and_branch_until_zero
%L264:
	move 1,11
	pushj 17,st_static_uQint
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_volatile_uQint
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_struct_uQint
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_vstruct_uQint
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	move 1,15
	pushj 17,st_array_uQint
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	move 1,14
	pushj 17,st_varray_uQint
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	subi 11,6
	move 1,12
	pushj 17,st_pointer_uQint
	pushj 17,ptr_static_uQint
	move 1,11
	pushj 17,ptr_stack_uQint
	pushj 17,ld_static_uQint
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,11
	pushj 17,st_ret_static_uQint
	add 10,1
	pushj 17,ld_volatile_uQint
	add 10,1
	pushj 17,ld_struct_uQint
	add 10,1
	pushj 17,ld_vstruct_uQint
	add 10,1
	move 1,15
	pushj 17,ld_array_uQint
	add 10,1
	addi 13,1
	andi 13,7
	move 1,13
	move 2,11
	pushj 17,st_ret_array_uQint
	add 10,1
	move 1,14
	pushj 17,ld_varray_uQint
	add 10,1
	move 1,12
	pushj 17,ld_pointer_uQint
	add 10,1
	move 1,12
	move 2,11
	pushj 17,st_ret_pointer_uQint
	add 10,1
	pushj 17,ld_global_pointer_uQint
	add 10,1
	move 1,11
	pushj 17,ld_stack_uQint
	add 10,1
	move 1,11
	pushj 17,st_stack_uQint
	add 10,1
	move 1,11
	pushj 17,update_static_uQint
	add 10,1
	move 1,12
	move 2,11
	pushj 17,update_pointer_uQint
	add 10,1
	movei 1,4
	pushj 17,sum_array_uQint
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_uQint
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_uQint:
	ldb 1,1
	popj 17,

unsigned_branch_uQint:
	andi 1,777	; zero_extendqisi2
	movei 3,0
	jumpe 1,%L266
	tlc 1,400000
	move 6,[-377777777601]
	camle 1,6
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L266:
	move 1,3
	popj 17,

	.data
	.align	2
ptr_scalar_Hint:
	.long	scalar_Hint+301989888
	.align	2
ptr_array_Hint:
	.long	array_Hint+301989889

ld_static_Hint:
	hrre 1,scalar_Hint
	popj 17,

st_static_Hint:
	movem 1,scalar_Hint
	popj 17,

st_ret_static_Hint:
	movem 1,scalar_Hint
	hrre 1,1
	popj 17,

ld_volatile_Hint:
	hrre 1,vscalar_Hint
	popj 17,

st_volatile_Hint:
	movem 1,vscalar_Hint
	popj 17,

ld_struct_Hint:
	hlre 1,box_Hint
	popj 17,

st_struct_Hint:
	hrrzi 1,(1)	; zero_extendhisi2
	hrlm 1,box_Hint
	addi 1,1
	hrrm 1,box_Hint
	popj 17,

ld_vstruct_Hint:
	hlrz 1,vbox_Hint
	hrre 1,1
	popj 17,

st_vstruct_Hint:
	hrrzi 1,(1)	; zero_extendhisi2
	hrlm 1,vbox_Hint
	addi 1,1
	hrrm 1,vbox_Hint
	popj 17,

ld_array_Hint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_Hint,17]
	jumpe 4,%L282
%L281:
	ibp 3
	sojn 4,%L281	; decrement_and_branch_until_zero
%L282:
	ldb 1,3
	hrre 1,1
	popj 17,

st_array_Hint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_Hint,17]
	jumpe 4,%L285
%L284:
	ibp 3
	sojn 4,%L284	; decrement_and_branch_until_zero
%L285:
	dpb 2,3	; movhi
	popj 17,

st_ret_array_Hint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 6,1
	move 4,1
	andi 4,1
	ash 6,-1	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 18,array_Hint,17]
	jumpe 4,%L288
%L287:
	ibp 3
	sojn 4,%L287	; decrement_and_branch_until_zero
%L288:
	dpb 2,3	; movhi
	andi 1,1
	move 4,6
	add 4,[POINT 18,array_Hint,17]
	jumpe 1,%L290
%L289:
	ibp 4
	sojn 1,%L289	; decrement_and_branch_until_zero
%L290:
	ldb 1,4
	hrre 1,1
	popj 17,

ld_varray_Hint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,varray_Hint,17]
	jumpe 4,%L293
%L292:
	ibp 3
	sojn 4,%L292	; decrement_and_branch_until_zero
%L293:
	ldb 1,3
	hrre 1,1
	popj 17,

st_varray_Hint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,varray_Hint,17]
	jumpe 4,%L296
%L295:
	ibp 3
	sojn 4,%L295	; decrement_and_branch_until_zero
%L296:
	dpb 2,3	; movhi
	popj 17,

ld_pointer_Hint:
	ldb 1,1
	hrre 1,1
	popj 17,

st_pointer_Hint:
	dpb 2,1	; movhi
	popj 17,

st_ret_pointer_Hint:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	hrre 2,2
	move 1,2
	popj 17,

ld_global_pointer_Hint:
	ldb 1,ptr_scalar_Hint
	ldb 6,ptr_array_Hint
	add 1,6
	hrre 1,1	; extendhisi2
	popj 17,

ptr_static_Hint:
	move 1,[POINT 18,scalar_Hint,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,array_Hint+1,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,box_Hint,17]
	jrst scalar_memory_forms

ld_stack_Hint:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_Hint:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_Hint:
	add 17,[3,,3]
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,-2(17)
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,-1(17)
	tlo 1,222200
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

update_static_Hint:
	hlrz 6,scalar_Hint
	addi 6,(1)
	movem 6,scalar_Hint
	hrre 1,6
	popj 17,

update_pointer_Hint:
	move 4,1
	ldb 1,1
	addi 1,(2)
	dpb 1,4	; movhi
	hrre 1,1
	popj 17,

sum_array_Hint:
	setzb 6,2
	caml 6,1
	jrst %L324
	subi 1,1
%L325:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_Hint,17]
	jumpe 4,%L321
%L320:
	ibp 3
	sojn 4,%L320	; decrement_and_branch_until_zero
%L321:
	ldb 4,3
	hrre 4,4
	add 6,4
	addi 2,1
	sojge 1,%L325	; doloop_end
%L324:
	move 1,6
	popj 17,

call_with_scalar_Hint:
	push 17,10
	hrre 10,1
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_Hint:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	hrrz 10,1
	move 15,2
	andi 15,7
	move 4,2
	andi 4,1
	move 13,15
	ash 13,-1	; ashrsi3_pointer
	add 13,[POINT 18,array_Hint,17]
	jumpe 4,%L331
%L330:
	ibp 13
	sojn 4,%L330	; decrement_and_branch_until_zero
%L331:
	hrre 11,10	; extendhisi2
	move 1,11
	pushj 17,st_static_Hint
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,st_volatile_Hint
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,st_struct_Hint
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,st_vstruct_Hint
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,15
	pushj 17,st_array_Hint
	move 12,14
	andi 12,3
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,12
	pushj 17,st_varray_Hint
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,13
	pushj 17,st_pointer_Hint
	pushj 17,ptr_static_Hint
	move 1,11
	pushj 17,ptr_stack_Hint
	pushj 17,ld_static_Hint
	hrre 10,1	; extendhisi2
	move 1,11
	pushj 17,st_ret_static_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	pushj 17,ld_volatile_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	pushj 17,ld_struct_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	pushj 17,ld_vstruct_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,15
	pushj 17,ld_array_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,11
	pushj 17,st_ret_array_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,12
	pushj 17,ld_varray_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,13
	pushj 17,ld_pointer_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,13
	move 2,11
	pushj 17,st_ret_pointer_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	pushj 17,ld_global_pointer_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,ld_stack_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,st_stack_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,update_static_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,13
	move 2,11
	pushj 17,update_pointer_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	movei 1,4
	pushj 17,sum_array_Hint
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_Hint
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_Hint:
	hrre 1,1
	seto 4,
	jumpl 1,%L332
	skipe 4,1
	movei 4,1
%L332:
	move 1,4
	popj 17,

sign_load_static_Hint:
	hrre 1,scalar_Hint
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_uHint:
	.long	scalar_uHint+301989888
	.align	2
ptr_array_uHint:
	.long	array_uHint+301989889

ld_static_uHint:
	move 1,scalar_uHint
	popj 17,

st_static_uHint:
	movem 1,scalar_uHint
	popj 17,

st_ret_static_uHint:
	movem 1,scalar_uHint
	popj 17,

ld_volatile_uHint:
	move 1,vscalar_uHint
	popj 17,

st_volatile_uHint:
	movem 1,vscalar_uHint
	popj 17,

ld_struct_uHint:
	hlrz 1,box_uHint
	popj 17,

st_struct_uHint:
	hrrzi 1,(1)	; zero_extendhisi2
	hrlm 1,box_uHint
	addi 1,1
	hrrm 1,box_uHint
	popj 17,

ld_vstruct_uHint:
	hlrz 1,vbox_uHint
	popj 17,

st_vstruct_uHint:
	hrrzi 1,(1)	; zero_extendhisi2
	hrlm 1,vbox_uHint
	addi 1,1
	hrrm 1,vbox_uHint
	popj 17,

ld_array_uHint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_uHint,17]
	jumpe 4,%L349
%L348:
	ibp 3
	sojn 4,%L348	; decrement_and_branch_until_zero
%L349:
	ldb 1,3
	popj 17,

st_array_uHint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_uHint,17]
	jumpe 4,%L352
%L351:
	ibp 3
	sojn 4,%L351	; decrement_and_branch_until_zero
%L352:
	dpb 2,3	; movhi
	popj 17,

st_ret_array_uHint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 6,1
	move 4,1
	andi 4,1
	ash 6,-1	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 18,array_uHint,17]
	jumpe 4,%L355
%L354:
	ibp 3
	sojn 4,%L354	; decrement_and_branch_until_zero
%L355:
	dpb 2,3	; movhi
	andi 1,1
	move 4,6
	add 4,[POINT 18,array_uHint,17]
	jumpe 1,%L357
%L356:
	ibp 4
	sojn 1,%L356	; decrement_and_branch_until_zero
%L357:
	ldb 1,4
	popj 17,

ld_varray_uHint:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,varray_uHint,17]
	jumpe 4,%L360
%L359:
	ibp 1
	sojn 4,%L359	; decrement_and_branch_until_zero
%L360:
	ldb 1,1
	popj 17,

st_varray_uHint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,varray_uHint,17]
	jumpe 4,%L363
%L362:
	ibp 3
	sojn 4,%L362	; decrement_and_branch_until_zero
%L363:
	dpb 2,3	; movhi
	popj 17,

ld_pointer_uHint:
	ldb 1,1
	popj 17,

st_pointer_uHint:
	dpb 2,1	; movhi
	popj 17,

st_ret_pointer_uHint:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	move 1,2
	popj 17,

ld_global_pointer_uHint:
	ldb 1,ptr_scalar_uHint
	ldb 6,ptr_array_uHint
	add 1,6
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

ptr_static_uHint:
	move 1,[POINT 18,scalar_uHint,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,array_uHint+1,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,box_uHint,17]
	jrst scalar_memory_forms

ld_stack_uHint:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_uHint:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_uHint:
	add 17,[3,,3]
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,-2(17)
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,-1(17)
	tlo 1,222200
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

update_static_uHint:
	hlrz 6,scalar_uHint
	addi 6,(1)
	movem 6,scalar_uHint
	hrrz 1,6
	popj 17,

update_pointer_uHint:
	move 4,1
	ldb 1,1
	addi 1,(2)
	dpb 1,4	; movhi
	hrrz 1,1
	popj 17,

sum_array_uHint:
	setzb 6,2
	caml 6,1
	jrst %L391
	subi 1,1
%L392:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_uHint,17]
	jumpe 4,%L388
%L387:
	ibp 3
	sojn 4,%L387	; decrement_and_branch_until_zero
%L388:
	ldb 3,3
	add 6,3
	addi 2,1
	sojge 1,%L392	; doloop_end
%L391:
	move 1,6
	popj 17,

call_with_scalar_uHint:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_uHint:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 15,2
	andi 15,7
	move 4,2
	andi 4,1
	move 13,15
	ash 13,-1	; ashrsi3_pointer
	add 13,[POINT 18,array_uHint,17]
	jumpe 4,%L398
%L397:
	ibp 13
	sojn 4,%L397	; decrement_and_branch_until_zero
%L398:
	move 1,12
	pushj 17,st_static_uHint
	movei 1,1(12)
	pushj 17,st_volatile_uHint
	movei 1,2(12)
	pushj 17,st_struct_uHint
	movei 1,3(12)
	pushj 17,st_vstruct_uHint
	movei 2,4(12)
	move 1,15
	pushj 17,st_array_uHint
	move 11,14
	andi 11,3
	movei 2,5(12)
	move 1,11
	pushj 17,st_varray_uHint
	movei 2,6(12)
	move 1,13
	pushj 17,st_pointer_uHint
	pushj 17,ptr_static_uHint
	move 1,12
	pushj 17,ptr_stack_uHint
	pushj 17,ld_static_uHint
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,12
	pushj 17,st_ret_static_uHint
	add 10,1
	pushj 17,ld_volatile_uHint
	add 10,1
	pushj 17,ld_struct_uHint
	add 10,1
	pushj 17,ld_vstruct_uHint
	add 10,1
	move 1,15
	pushj 17,ld_array_uHint
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,12
	pushj 17,st_ret_array_uHint
	add 10,1
	move 1,11
	pushj 17,ld_varray_uHint
	add 10,1
	move 1,13
	pushj 17,ld_pointer_uHint
	add 10,1
	move 1,13
	move 2,12
	pushj 17,st_ret_pointer_uHint
	add 10,1
	pushj 17,ld_global_pointer_uHint
	add 10,1
	move 1,12
	pushj 17,ld_stack_uHint
	add 10,1
	move 1,12
	pushj 17,st_stack_uHint
	add 10,1
	move 1,12
	pushj 17,update_static_uHint
	add 10,1
	move 1,13
	move 2,12
	pushj 17,update_pointer_uHint
	add 10,1
	movei 1,4
	pushj 17,sum_array_uHint
	add 10,1
	move 1,12
	pushj 17,call_with_scalar_uHint
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_uHint:
	ldb 1,1
	popj 17,

unsigned_branch_uHint:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 3,0
	jumpe 1,%L400
	tlc 1,400000
	move 6,[-377777777601]
	camle 1,6
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L400:
	move 1,3
	popj 17,

	.data
	.align	2
ptr_scalar_char6:
	.long	scalar_char6+301989888
	.align	2
ptr_array_char6:
	.long	array_char6+12985565184

ld_static_char6:
	hrre 1,scalar_char6
	popj 17,

st_static_char6:
	movem 1,scalar_char6
	popj 17,

st_ret_static_char6:
	lsh 1,36
	ash 1,-36
	movem 1,scalar_char6
	lsh 1,36
	ash 1,-36
	popj 17,

ld_volatile_char6:
	ldb 1,[POINT 18,vscalar_char6,35]
	trne 1,40
	orcmi 1,77
	popj 17,

st_volatile_char6:
	lsh 1,36
	ash 1,-36
	movem 1,vscalar_char6
	popj 17,

ld_struct_char6:
	move 1,box_char6
	ash 1,-36
	popj 17,

st_struct_char6:
	lsh 1,36
	ash 1,-36
	dpb 1,[POINT 6,box_char6,5]
	addi 1,1
	dpb 1,[POINT 6,box_char6,11]
	popj 17,

ld_vstruct_char6:
	move 1,vbox_char6
	ash 1,-36
	popj 17,

st_vstruct_char6:
	lsh 1,36
	ash 1,-36
	dpb 1,[POINT 6,vbox_char6,5]
	addi 1,1
	dpb 1,[POINT 6,vbox_char6,11]
	popj 17,

ld_array_char6:
	move 4,[POINT 6,array_char6,5]
	jumple 1,%L416
%L415:
	ibp 4
	sojg 1,%L415	; decrement_and_branch_until_zero
%L416:
	jumpe 1,%L418
%L417:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L417
%L418:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

st_array_char6:
	lsh 2,36
	ash 2,-36
	move 4,[POINT 6,array_char6,5]
	jumple 1,%L421
%L420:
	ibp 4
	sojg 1,%L420	; decrement_and_branch_until_zero
%L421:
	jumpe 1,%L423
%L422:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L422
%L423:
	dpb 2,4
	popj 17,

st_ret_array_char6:
	lsh 2,36
	ash 2,-36
	move 3,[POINT 6,array_char6,5]
	move 4,1
	jumple 1,%L426
%L425:
	ibp 3
	sojg 4,%L425	; decrement_and_branch_until_zero
%L426:
	jumpe 4,%L428
%L427:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L427
%L428:
	dpb 2,3
	move 3,[POINT 6,array_char6,5]
	skipg 4,1
	jrst %L430
%L429:
	ibp 3
	sojg 4,%L429	; decrement_and_branch_until_zero
%L430:
	jumpe 4,%L432
%L431:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L431
%L432:
	ldb 1,3
	trne 1,40
	orcmi 1,77
	popj 17,

ld_varray_char6:
	move 4,[POINT 6,varray_char6,5]
	jumple 1,%L435
%L434:
	ibp 4
	sojg 1,%L434	; decrement_and_branch_until_zero
%L435:
	jumpe 1,%L437
%L436:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L436
%L437:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

st_varray_char6:
	lsh 2,36
	ash 2,-36
	move 4,[POINT 6,varray_char6,5]
	jumple 1,%L440
%L439:
	ibp 4
	sojg 1,%L439	; decrement_and_branch_until_zero
%L440:
	jumpe 1,%L442
%L441:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L441
%L442:
	dpb 2,4
	popj 17,

ld_pointer_char6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

st_pointer_char6:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

st_ret_pointer_char6:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	lsh 2,36
	ash 2,-36
	move 1,2
	popj 17,

ld_global_pointer_char6:
	ldb 1,ptr_scalar_char6
	ldb 6,ptr_array_char6
	add 1,6
	lsh 1,36
	ash 1,-36
	popj 17,

ptr_static_char6:
	move 1,[POINT 18,scalar_char6,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 6,array_char6,23]
	pushj 17,scalar_memory_forms
	move 1,[POINT 6,box_char6,5]
	jrst scalar_memory_forms

ld_stack_char6:
	add 17,[1,,1]
	lsh 1,36
	ash 1,-36
	movem 1,(17)
	move 1,(17)
	lsh 1,36
	ash 1,-36
	add 17,[-1,,-1]
	popj 17,

st_stack_char6:
	add 17,[1,,1]
	lsh 1,36
	ash 1,-36
	movem 1,(17)
	move 1,(17)
	lsh 1,36
	ash 1,-36
	add 17,[-1,,-1]
	popj 17,

ptr_stack_char6:
	add 17,[2,,2]
	lsh 1,36
	ash 1,-36
	dpb 1,[POINT 9,-1(17),35]
	dpb 1,[POINT 6,(17),5]
	addi 1,1
	dpb 1,[POINT 6,(17),11]
	addi 1,1
	dpb 1,[POINT 6,(17),17]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,360600
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_char6:
	lsh 1,36
	ash 1,-36
	ldb 6,[POINT 18,scalar_char6,35]
	add 1,6
	movem 1,scalar_char6
	lsh 1,36
	ash 1,-36
	popj 17,

update_pointer_char6:
	lsh 2,36
	ash 2,-36
	ldb 6,1
	add 2,6
	dpb 2,1
	lsh 2,36
	ash 2,-36
	move 1,2
	popj 17,

sum_array_char6:
	setzb 6,2
	caml 6,1
	jrst %L472
	subi 1,1
%L473:
	move 3,[POINT 6,array_char6,5]
	move 4,2
	jumple 2,%L467
%L466:
	ibp 3
	sojg 4,%L466	; decrement_and_branch_until_zero
%L467:
	jumpe 4,%L469
%L468:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L468
%L469:
	ldb 4,3
	trne 4,40
	orcmi 4,77
	add 6,4
	addi 2,1
	sojge 1,%L473	; doloop_end
%L472:
	move 1,6
	popj 17,

call_with_scalar_char6:
	push 17,10
	move 10,1
	lsh 10,36
	ash 10,-36
	lsh 10,36
	ash 10,-36
	lsh 10,36
	ash 10,-36
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_char6:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	lsh 1,36
	ash 1,-36
	move 10,1
	lsh 10,36
	ash 10,-36
	move 15,2
	andi 15,7
	move 13,[POINT 6,array_char6,5]
	move 4,15
	jumple 15,%L479
%L478:
	ibp 13
	sojg 4,%L478	; decrement_and_branch_until_zero
%L479:
	jumpe 4,%L481
%L480:
	subi 13,1
	ibp 13
	ibp 13
	ibp 13
	ibp 13
	ibp 13
	aojl 4,%L480
%L481:
	move 11,10
	lsh 11,36
	ash 11,-36
	move 1,11
	pushj 17,st_static_char6
	move 1,10
	addi 1,1
	lsh 1,36
	ash 1,-36
	pushj 17,st_volatile_char6
	move 1,10
	addi 1,2
	lsh 1,36
	ash 1,-36
	pushj 17,st_struct_char6
	move 1,10
	addi 1,3
	lsh 1,36
	ash 1,-36
	pushj 17,st_vstruct_char6
	move 2,10
	addi 2,4
	lsh 2,36
	ash 2,-36
	move 1,15
	pushj 17,st_array_char6
	move 12,14
	andi 12,3
	move 2,10
	addi 2,5
	lsh 2,36
	ash 2,-36
	move 1,12
	pushj 17,st_varray_char6
	move 2,10
	addi 2,6
	lsh 2,36
	ash 2,-36
	move 1,13
	pushj 17,st_pointer_char6
	pushj 17,ptr_static_char6
	move 1,11
	pushj 17,ptr_stack_char6
	pushj 17,ld_static_char6
	move 10,1
	lsh 10,36
	ash 10,-36
	move 1,11
	pushj 17,st_ret_static_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	pushj 17,ld_volatile_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	pushj 17,ld_struct_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	pushj 17,ld_vstruct_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,15
	pushj 17,ld_array_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,11
	pushj 17,st_ret_array_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,12
	pushj 17,ld_varray_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,13
	pushj 17,ld_pointer_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,13
	move 2,11
	pushj 17,st_ret_pointer_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	pushj 17,ld_global_pointer_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,ld_stack_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,st_stack_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,update_static_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,13
	move 2,11
	pushj 17,update_pointer_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	movei 1,4
	pushj 17,sum_array_char6
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_char6
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_char6:
	lsh 1,36
	ash 1,-36
	lsh 1,33
	ash 1,-33
	seto 4,
	jumpl 1,%L482
	skipe 4,1
	movei 4,1
%L482:
	move 1,4
	popj 17,

sign_load_static_char6:
	hrre 1,scalar_char6
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_uchar6:
	.long	scalar_uchar6+301989888
	.align	2
ptr_array_uchar6:
	.long	array_uchar6+12985565184

ld_static_uchar6:
	move 1,scalar_uchar6
	popj 17,

st_static_uchar6:
	movem 1,scalar_uchar6
	popj 17,

st_ret_static_uchar6:
	andi 1,77
	movem 1,scalar_uchar6
	andi 1,77
	popj 17,

ld_volatile_uchar6:
	ldb 1,[POINT 18,vscalar_uchar6,35]
	popj 17,

st_volatile_uchar6:
	andi 1,77
	movem 1,vscalar_uchar6
	popj 17,

ld_struct_uchar6:
	move 1,box_uchar6
	lsh 1,-36
	popj 17,

st_struct_uchar6:
	andi 1,77
	dpb 1,[POINT 6,box_uchar6,5]
	addi 1,1
	dpb 1,[POINT 6,box_uchar6,11]
	popj 17,

ld_vstruct_uchar6:
	move 1,vbox_uchar6
	lsh 1,-36
	popj 17,

st_vstruct_uchar6:
	andi 1,77
	dpb 1,[POINT 6,vbox_uchar6,5]
	addi 1,1
	dpb 1,[POINT 6,vbox_uchar6,11]
	popj 17,

ld_array_uchar6:
	move 4,[POINT 6,array_uchar6,5]
	jumple 1,%L499
%L498:
	ibp 4
	sojg 1,%L498	; decrement_and_branch_until_zero
%L499:
	jumpe 1,%L501
%L500:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L500
%L501:
	ldb 1,4
	popj 17,

st_array_uchar6:
	andi 2,77
	move 4,[POINT 6,array_uchar6,5]
	jumple 1,%L504
%L503:
	ibp 4
	sojg 1,%L503	; decrement_and_branch_until_zero
%L504:
	jumpe 1,%L506
%L505:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L505
%L506:
	dpb 2,4
	popj 17,

st_ret_array_uchar6:
	andi 2,77
	move 3,[POINT 6,array_uchar6,5]
	move 4,1
	jumple 1,%L509
%L508:
	ibp 3
	sojg 4,%L508	; decrement_and_branch_until_zero
%L509:
	jumpe 4,%L511
%L510:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L510
%L511:
	dpb 2,3
	move 3,[POINT 6,array_uchar6,5]
	skipg 4,1
	jrst %L513
%L512:
	ibp 3
	sojg 4,%L512	; decrement_and_branch_until_zero
%L513:
	jumpe 4,%L515
%L514:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L514
%L515:
	ldb 1,3
	popj 17,

ld_varray_uchar6:
	move 4,[POINT 6,varray_uchar6,5]
	jumple 1,%L518
%L517:
	ibp 4
	sojg 1,%L517	; decrement_and_branch_until_zero
%L518:
	jumpe 1,%L520
%L519:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L519
%L520:
	ldb 1,4
	popj 17,

st_varray_uchar6:
	andi 2,77
	move 4,[POINT 6,varray_uchar6,5]
	jumple 1,%L523
%L522:
	ibp 4
	sojg 1,%L522	; decrement_and_branch_until_zero
%L523:
	jumpe 1,%L525
%L524:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L524
%L525:
	dpb 2,4
	popj 17,

ld_pointer_uchar6:
	ldb 1,1
	popj 17,

st_pointer_uchar6:
	andi 2,77
	dpb 2,1
	popj 17,

st_ret_pointer_uchar6:
	andi 2,77
	dpb 2,1
	andi 2,77
	move 1,2
	popj 17,

ld_global_pointer_uchar6:
	ldb 1,ptr_scalar_uchar6
	ldb 6,ptr_array_uchar6
	add 1,6
	andi 1,77
	popj 17,

ptr_static_uchar6:
	move 1,[POINT 18,scalar_uchar6,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 6,array_uchar6,23]
	pushj 17,scalar_memory_forms
	move 1,[POINT 6,box_uchar6,5]
	jrst scalar_memory_forms

ld_stack_uchar6:
	add 17,[1,,1]
	andi 1,77
	movem 1,(17)
	move 1,(17)
	andi 1,77
	add 17,[-1,,-1]
	popj 17,

st_stack_uchar6:
	add 17,[1,,1]
	andi 1,77
	movem 1,(17)
	move 1,(17)
	andi 1,77
	add 17,[-1,,-1]
	popj 17,

ptr_stack_uchar6:
	add 17,[2,,2]
	andi 1,77
	dpb 1,[POINT 9,-1(17),35]
	dpb 1,[POINT 6,(17),5]
	addi 1,1
	dpb 1,[POINT 6,(17),11]
	addi 1,1
	dpb 1,[POINT 6,(17),17]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,360600
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_uchar6:
	andi 1,77
	ldb 6,[POINT 18,scalar_uchar6,35]
	add 1,6
	movem 1,scalar_uchar6
	andi 1,77
	popj 17,

update_pointer_uchar6:
	andi 2,77
	ldb 6,1
	add 2,6
	dpb 2,1
	andi 2,77
	move 1,2
	popj 17,

sum_array_uchar6:
	setzb 6,2
	caml 6,1
	jrst %L555
	subi 1,1
%L556:
	move 3,[POINT 6,array_uchar6,5]
	move 4,2
	jumple 2,%L550
%L549:
	ibp 3
	sojg 4,%L549	; decrement_and_branch_until_zero
%L550:
	jumpe 4,%L552
%L551:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L551
%L552:
	ldb 4,3
	add 6,4
	addi 2,1
	sojge 1,%L556	; doloop_end
%L555:
	move 1,6
	popj 17,

call_with_scalar_uchar6:
	push 17,10
	move 10,1
	andi 10,77
	andi 10,77
	andi 10,77
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_uchar6:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	andi 1,77
	move 10,1
	andi 10,77
	move 15,2
	andi 15,7
	move 13,[POINT 6,array_uchar6,5]
	move 4,15
	jumple 15,%L562
%L561:
	ibp 13
	sojg 4,%L561	; decrement_and_branch_until_zero
%L562:
	jumpe 4,%L564
%L563:
	subi 13,1
	ibp 13
	ibp 13
	ibp 13
	ibp 13
	ibp 13
	aojl 4,%L563
%L564:
	move 11,10
	andi 11,77
	move 1,11
	pushj 17,st_static_uchar6
	move 1,10
	addi 1,1
	andi 1,77
	pushj 17,st_volatile_uchar6
	move 1,10
	addi 1,2
	andi 1,77
	pushj 17,st_struct_uchar6
	move 1,10
	addi 1,3
	andi 1,77
	pushj 17,st_vstruct_uchar6
	move 2,10
	addi 2,4
	andi 2,77
	move 1,15
	pushj 17,st_array_uchar6
	move 12,14
	andi 12,3
	move 2,10
	addi 2,5
	andi 2,77
	move 1,12
	pushj 17,st_varray_uchar6
	move 2,10
	addi 2,6
	andi 2,77
	move 1,13
	pushj 17,st_pointer_uchar6
	pushj 17,ptr_static_uchar6
	move 1,11
	pushj 17,ptr_stack_uchar6
	pushj 17,ld_static_uchar6
	move 10,1
	andi 10,77
	move 1,11
	pushj 17,st_ret_static_uchar6
	andi 1,77
	add 10,1
	pushj 17,ld_volatile_uchar6
	andi 1,77
	add 10,1
	pushj 17,ld_struct_uchar6
	andi 1,77
	add 10,1
	pushj 17,ld_vstruct_uchar6
	andi 1,77
	add 10,1
	move 1,15
	pushj 17,ld_array_uchar6
	andi 1,77
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,11
	pushj 17,st_ret_array_uchar6
	andi 1,77
	add 10,1
	move 1,12
	pushj 17,ld_varray_uchar6
	andi 1,77
	add 10,1
	move 1,13
	pushj 17,ld_pointer_uchar6
	andi 1,77
	add 10,1
	move 1,13
	move 2,11
	pushj 17,st_ret_pointer_uchar6
	andi 1,77
	add 10,1
	pushj 17,ld_global_pointer_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,ld_stack_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,st_stack_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,update_static_uchar6
	andi 1,77
	add 10,1
	move 1,13
	move 2,11
	pushj 17,update_pointer_uchar6
	andi 1,77
	add 10,1
	movei 1,4
	pushj 17,sum_array_uchar6
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_uchar6
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_uchar6:
	ldb 1,1
	popj 17,

unsigned_branch_uchar6:
	andi 1,77
	skipe 1
	movei 1,1
	popj 17,

	.data
	.align	2
ptr_scalar_char7:
	.long	scalar_char7+301989888
	.align	2
ptr_array_char7:
	.long	array_char7+8707375104

ld_static_char7:
	hrre 1,scalar_char7
	popj 17,

st_static_char7:
	movem 1,scalar_char7
	popj 17,

st_ret_static_char7:
	lsh 1,35
	ash 1,-35
	movem 1,scalar_char7
	lsh 1,35
	ash 1,-35
	popj 17,

ld_volatile_char7:
	ldb 1,[POINT 18,vscalar_char7,35]
	trne 1,100
	orcmi 1,177
	popj 17,

st_volatile_char7:
	lsh 1,35
	ash 1,-35
	movem 1,vscalar_char7
	popj 17,

ld_struct_char7:
	move 1,box_char7
	ash 1,-35
	popj 17,

st_struct_char7:
	lsh 1,35
	ash 1,-35
	dpb 1,[POINT 7,box_char7,6]
	addi 1,1
	dpb 1,[POINT 7,box_char7,13]
	popj 17,

ld_vstruct_char7:
	move 1,vbox_char7
	ash 1,-35
	popj 17,

st_vstruct_char7:
	lsh 1,35
	ash 1,-35
	dpb 1,[POINT 7,vbox_char7,6]
	addi 1,1
	dpb 1,[POINT 7,vbox_char7,13]
	popj 17,

ld_array_char7:
	move 4,[POINT 7,array_char7,6]
	jumple 1,%L582
%L581:
	ibp 4
	sojg 1,%L581	; decrement_and_branch_until_zero
%L582:
	jumpe 1,%L584
%L583:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L583
%L584:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

st_array_char7:
	lsh 2,35
	ash 2,-35
	move 4,[POINT 7,array_char7,6]
	jumple 1,%L587
%L586:
	ibp 4
	sojg 1,%L586	; decrement_and_branch_until_zero
%L587:
	jumpe 1,%L589
%L588:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L588
%L589:
	dpb 2,4
	popj 17,

st_ret_array_char7:
	lsh 2,35
	ash 2,-35
	move 3,[POINT 7,array_char7,6]
	move 4,1
	jumple 1,%L592
%L591:
	ibp 3
	sojg 4,%L591	; decrement_and_branch_until_zero
%L592:
	jumpe 4,%L594
%L593:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L593
%L594:
	dpb 2,3
	move 3,[POINT 7,array_char7,6]
	skipg 4,1
	jrst %L596
%L595:
	ibp 3
	sojg 4,%L595	; decrement_and_branch_until_zero
%L596:
	jumpe 4,%L598
%L597:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L597
%L598:
	ldb 1,3
	trne 1,100
	orcmi 1,177
	popj 17,

ld_varray_char7:
	move 4,[POINT 7,varray_char7,6]
	jumple 1,%L601
%L600:
	ibp 4
	sojg 1,%L600	; decrement_and_branch_until_zero
%L601:
	jumpe 1,%L603
%L602:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L602
%L603:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

st_varray_char7:
	lsh 2,35
	ash 2,-35
	move 4,[POINT 7,varray_char7,6]
	jumple 1,%L606
%L605:
	ibp 4
	sojg 1,%L605	; decrement_and_branch_until_zero
%L606:
	jumpe 1,%L608
%L607:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L607
%L608:
	dpb 2,4
	popj 17,

ld_pointer_char7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

st_pointer_char7:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

st_ret_pointer_char7:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	lsh 2,35
	ash 2,-35
	move 1,2
	popj 17,

ld_global_pointer_char7:
	ldb 1,ptr_scalar_char7
	ldb 6,ptr_array_char7
	add 1,6
	lsh 1,35
	ash 1,-35
	popj 17,

ptr_static_char7:
	move 1,[POINT 18,scalar_char7,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 7,array_char7,27]
	pushj 17,scalar_memory_forms
	move 1,[POINT 7,box_char7,6]
	jrst scalar_memory_forms

ld_stack_char7:
	add 17,[1,,1]
	lsh 1,35
	ash 1,-35
	movem 1,(17)
	move 1,(17)
	lsh 1,35
	ash 1,-35
	add 17,[-1,,-1]
	popj 17,

st_stack_char7:
	add 17,[1,,1]
	lsh 1,35
	ash 1,-35
	movem 1,(17)
	move 1,(17)
	lsh 1,35
	ash 1,-35
	add 17,[-1,,-1]
	popj 17,

ptr_stack_char7:
	add 17,[2,,2]
	lsh 1,35
	ash 1,-35
	dpb 1,[POINT 9,-1(17),35]
	dpb 1,[POINT 7,(17),6]
	addi 1,1
	dpb 1,[POINT 7,(17),13]
	addi 1,1
	dpb 1,[POINT 7,(17),20]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,350700
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_char7:
	lsh 1,35
	ash 1,-35
	ldb 6,[POINT 18,scalar_char7,35]
	add 1,6
	movem 1,scalar_char7
	lsh 1,35
	ash 1,-35
	popj 17,

update_pointer_char7:
	lsh 2,35
	ash 2,-35
	ldb 6,1
	add 2,6
	dpb 2,1
	lsh 2,35
	ash 2,-35
	move 1,2
	popj 17,

sum_array_char7:
	setzb 6,2
	caml 6,1
	jrst %L638
	subi 1,1
%L639:
	move 3,[POINT 7,array_char7,6]
	move 4,2
	jumple 2,%L633
%L632:
	ibp 3
	sojg 4,%L632	; decrement_and_branch_until_zero
%L633:
	jumpe 4,%L635
%L634:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L634
%L635:
	ldb 4,3
	trne 4,100
	orcmi 4,177
	add 6,4
	addi 2,1
	sojge 1,%L639	; doloop_end
%L638:
	move 1,6
	popj 17,

call_with_scalar_char7:
	push 17,10
	move 10,1
	lsh 10,35
	ash 10,-35
	lsh 10,35
	ash 10,-35
	lsh 10,35
	ash 10,-35
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_char7:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	lsh 1,35
	ash 1,-35
	move 10,1
	lsh 10,35
	ash 10,-35
	move 15,2
	andi 15,7
	move 13,[POINT 7,array_char7,6]
	move 4,15
	jumple 15,%L645
%L644:
	ibp 13
	sojg 4,%L644	; decrement_and_branch_until_zero
%L645:
	jumpe 4,%L647
%L646:
	subi 13,1
	ibp 13
	ibp 13
	ibp 13
	ibp 13
	aojl 4,%L646
%L647:
	move 11,10
	lsh 11,35
	ash 11,-35
	move 1,11
	pushj 17,st_static_char7
	move 1,10
	addi 1,1
	lsh 1,35
	ash 1,-35
	pushj 17,st_volatile_char7
	move 1,10
	addi 1,2
	lsh 1,35
	ash 1,-35
	pushj 17,st_struct_char7
	move 1,10
	addi 1,3
	lsh 1,35
	ash 1,-35
	pushj 17,st_vstruct_char7
	move 2,10
	addi 2,4
	lsh 2,35
	ash 2,-35
	move 1,15
	pushj 17,st_array_char7
	move 12,14
	andi 12,3
	move 2,10
	addi 2,5
	lsh 2,35
	ash 2,-35
	move 1,12
	pushj 17,st_varray_char7
	move 2,10
	addi 2,6
	lsh 2,35
	ash 2,-35
	move 1,13
	pushj 17,st_pointer_char7
	pushj 17,ptr_static_char7
	move 1,11
	pushj 17,ptr_stack_char7
	pushj 17,ld_static_char7
	move 10,1
	lsh 10,35
	ash 10,-35
	move 1,11
	pushj 17,st_ret_static_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	pushj 17,ld_volatile_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	pushj 17,ld_struct_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	pushj 17,ld_vstruct_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,15
	pushj 17,ld_array_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,11
	pushj 17,st_ret_array_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,12
	pushj 17,ld_varray_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,13
	pushj 17,ld_pointer_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,13
	move 2,11
	pushj 17,st_ret_pointer_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	pushj 17,ld_global_pointer_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,ld_stack_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,st_stack_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,update_static_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,13
	move 2,11
	pushj 17,update_pointer_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	movei 1,4
	pushj 17,sum_array_char7
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_char7
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_char7:
	lsh 1,35
	ash 1,-35
	lsh 1,33
	ash 1,-33
	seto 4,
	jumpl 1,%L648
	skipe 4,1
	movei 4,1
%L648:
	move 1,4
	popj 17,

sign_load_static_char7:
	hrre 1,scalar_char7
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_uchar7:
	.long	scalar_uchar7+301989888
	.align	2
ptr_array_uchar7:
	.long	array_uchar7+8707375104

ld_static_uchar7:
	move 1,scalar_uchar7
	popj 17,

st_static_uchar7:
	movem 1,scalar_uchar7
	popj 17,

st_ret_static_uchar7:
	andi 1,177
	movem 1,scalar_uchar7
	andi 1,177
	popj 17,

ld_volatile_uchar7:
	ldb 1,[POINT 18,vscalar_uchar7,35]
	popj 17,

st_volatile_uchar7:
	andi 1,177
	movem 1,vscalar_uchar7
	popj 17,

ld_struct_uchar7:
	move 1,box_uchar7
	lsh 1,-35
	popj 17,

st_struct_uchar7:
	andi 1,177
	dpb 1,[POINT 7,box_uchar7,6]
	addi 1,1
	dpb 1,[POINT 7,box_uchar7,13]
	popj 17,

ld_vstruct_uchar7:
	move 1,vbox_uchar7
	lsh 1,-35
	popj 17,

st_vstruct_uchar7:
	andi 1,177
	dpb 1,[POINT 7,vbox_uchar7,6]
	addi 1,1
	dpb 1,[POINT 7,vbox_uchar7,13]
	popj 17,

ld_array_uchar7:
	move 4,[POINT 7,array_uchar7,6]
	jumple 1,%L665
%L664:
	ibp 4
	sojg 1,%L664	; decrement_and_branch_until_zero
%L665:
	jumpe 1,%L667
%L666:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L666
%L667:
	ldb 1,4
	popj 17,

st_array_uchar7:
	andi 2,177
	move 4,[POINT 7,array_uchar7,6]
	jumple 1,%L670
%L669:
	ibp 4
	sojg 1,%L669	; decrement_and_branch_until_zero
%L670:
	jumpe 1,%L672
%L671:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L671
%L672:
	dpb 2,4
	popj 17,

st_ret_array_uchar7:
	andi 2,177
	move 3,[POINT 7,array_uchar7,6]
	move 4,1
	jumple 1,%L675
%L674:
	ibp 3
	sojg 4,%L674	; decrement_and_branch_until_zero
%L675:
	jumpe 4,%L677
%L676:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L676
%L677:
	dpb 2,3
	move 3,[POINT 7,array_uchar7,6]
	skipg 4,1
	jrst %L679
%L678:
	ibp 3
	sojg 4,%L678	; decrement_and_branch_until_zero
%L679:
	jumpe 4,%L681
%L680:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L680
%L681:
	ldb 1,3
	popj 17,

ld_varray_uchar7:
	move 4,[POINT 7,varray_uchar7,6]
	jumple 1,%L684
%L683:
	ibp 4
	sojg 1,%L683	; decrement_and_branch_until_zero
%L684:
	jumpe 1,%L686
%L685:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L685
%L686:
	ldb 1,4
	popj 17,

st_varray_uchar7:
	andi 2,177
	move 4,[POINT 7,varray_uchar7,6]
	jumple 1,%L689
%L688:
	ibp 4
	sojg 1,%L688	; decrement_and_branch_until_zero
%L689:
	jumpe 1,%L691
%L690:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L690
%L691:
	dpb 2,4
	popj 17,

ld_pointer_uchar7:
	ldb 1,1
	popj 17,

st_pointer_uchar7:
	andi 2,177
	dpb 2,1
	popj 17,

st_ret_pointer_uchar7:
	andi 2,177
	dpb 2,1
	andi 2,177
	move 1,2
	popj 17,

ld_global_pointer_uchar7:
	ldb 1,ptr_scalar_uchar7
	ldb 6,ptr_array_uchar7
	add 1,6
	andi 1,177
	popj 17,

ptr_static_uchar7:
	move 1,[POINT 18,scalar_uchar7,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 7,array_uchar7,27]
	pushj 17,scalar_memory_forms
	move 1,[POINT 7,box_uchar7,6]
	jrst scalar_memory_forms

ld_stack_uchar7:
	add 17,[1,,1]
	andi 1,177
	movem 1,(17)
	move 1,(17)
	andi 1,177
	add 17,[-1,,-1]
	popj 17,

st_stack_uchar7:
	add 17,[1,,1]
	andi 1,177
	movem 1,(17)
	move 1,(17)
	andi 1,177
	add 17,[-1,,-1]
	popj 17,

ptr_stack_uchar7:
	add 17,[2,,2]
	andi 1,177
	dpb 1,[POINT 9,-1(17),35]
	dpb 1,[POINT 7,(17),6]
	addi 1,1
	dpb 1,[POINT 7,(17),13]
	addi 1,1
	dpb 1,[POINT 7,(17),20]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,350700
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_uchar7:
	andi 1,177
	ldb 6,[POINT 18,scalar_uchar7,35]
	add 1,6
	movem 1,scalar_uchar7
	andi 1,177
	popj 17,

update_pointer_uchar7:
	andi 2,177
	ldb 6,1
	add 2,6
	dpb 2,1
	andi 2,177
	move 1,2
	popj 17,

sum_array_uchar7:
	setzb 6,2
	caml 6,1
	jrst %L721
	subi 1,1
%L722:
	move 3,[POINT 7,array_uchar7,6]
	move 4,2
	jumple 2,%L716
%L715:
	ibp 3
	sojg 4,%L715	; decrement_and_branch_until_zero
%L716:
	jumpe 4,%L718
%L717:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L717
%L718:
	ldb 4,3
	add 6,4
	addi 2,1
	sojge 1,%L722	; doloop_end
%L721:
	move 1,6
	popj 17,

call_with_scalar_uchar7:
	push 17,10
	move 10,1
	andi 10,177
	andi 10,177
	andi 10,177
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_uchar7:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	andi 1,177
	move 10,1
	andi 10,177
	move 15,2
	andi 15,7
	move 13,[POINT 7,array_uchar7,6]
	move 4,15
	jumple 15,%L728
%L727:
	ibp 13
	sojg 4,%L727	; decrement_and_branch_until_zero
%L728:
	jumpe 4,%L730
%L729:
	subi 13,1
	ibp 13
	ibp 13
	ibp 13
	ibp 13
	aojl 4,%L729
%L730:
	move 11,10
	andi 11,177
	move 1,11
	pushj 17,st_static_uchar7
	move 1,10
	addi 1,1
	andi 1,177
	pushj 17,st_volatile_uchar7
	move 1,10
	addi 1,2
	andi 1,177
	pushj 17,st_struct_uchar7
	move 1,10
	addi 1,3
	andi 1,177
	pushj 17,st_vstruct_uchar7
	move 2,10
	addi 2,4
	andi 2,177
	move 1,15
	pushj 17,st_array_uchar7
	move 12,14
	andi 12,3
	move 2,10
	addi 2,5
	andi 2,177
	move 1,12
	pushj 17,st_varray_uchar7
	move 2,10
	addi 2,6
	andi 2,177
	move 1,13
	pushj 17,st_pointer_uchar7
	pushj 17,ptr_static_uchar7
	move 1,11
	pushj 17,ptr_stack_uchar7
	pushj 17,ld_static_uchar7
	move 10,1
	andi 10,177
	move 1,11
	pushj 17,st_ret_static_uchar7
	andi 1,177
	add 10,1
	pushj 17,ld_volatile_uchar7
	andi 1,177
	add 10,1
	pushj 17,ld_struct_uchar7
	andi 1,177
	add 10,1
	pushj 17,ld_vstruct_uchar7
	andi 1,177
	add 10,1
	move 1,15
	pushj 17,ld_array_uchar7
	andi 1,177
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,11
	pushj 17,st_ret_array_uchar7
	andi 1,177
	add 10,1
	move 1,12
	pushj 17,ld_varray_uchar7
	andi 1,177
	add 10,1
	move 1,13
	pushj 17,ld_pointer_uchar7
	andi 1,177
	add 10,1
	move 1,13
	move 2,11
	pushj 17,st_ret_pointer_uchar7
	andi 1,177
	add 10,1
	pushj 17,ld_global_pointer_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,ld_stack_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,st_stack_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,update_static_uchar7
	andi 1,177
	add 10,1
	move 1,13
	move 2,11
	pushj 17,update_pointer_uchar7
	andi 1,177
	add 10,1
	movei 1,4
	pushj 17,sum_array_uchar7
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_uchar7
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_uchar7:
	ldb 1,1
	popj 17,

unsigned_branch_uchar7:
	andi 1,177
	skipe 1
	movei 1,1
	popj 17,

	.data
	.align	2
ptr_scalar_char8:
	.long	scalar_char8+301989888
	.align	2
ptr_array_char8:
	.long	array_char8+4429185024

ld_static_char8:
	hrre 1,scalar_char8
	popj 17,

st_static_char8:
	movem 1,scalar_char8
	popj 17,

st_ret_static_char8:
	lsh 1,34
	ash 1,-34
	movem 1,scalar_char8
	lsh 1,34
	ash 1,-34
	popj 17,

ld_volatile_char8:
	ldb 1,[POINT 18,vscalar_char8,35]
	trne 1,200
	orcmi 1,377
	popj 17,

st_volatile_char8:
	lsh 1,34
	ash 1,-34
	movem 1,vscalar_char8
	popj 17,

ld_struct_char8:
	move 1,box_char8
	ash 1,-34
	popj 17,

st_struct_char8:
	lsh 1,34
	ash 1,-34
	dpb 1,[POINT 8,box_char8,7]
	addi 1,1
	dpb 1,[POINT 8,box_char8,15]
	popj 17,

ld_vstruct_char8:
	move 1,vbox_char8
	ash 1,-34
	popj 17,

st_vstruct_char8:
	lsh 1,34
	ash 1,-34
	dpb 1,[POINT 8,vbox_char8,7]
	addi 1,1
	dpb 1,[POINT 8,vbox_char8,15]
	popj 17,

ld_array_char8:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,array_char8,7]
	jumpe 4,%L748
%L747:
	ibp 3
	sojn 4,%L747	; decrement_and_branch_until_zero
%L748:
	ldb 1,3
	trne 1,200
	orcmi 1,377
	popj 17,

st_array_char8:
	lsh 2,34
	ash 2,-34
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,array_char8,7]
	jumpe 4,%L751
%L750:
	ibp 3
	sojn 4,%L750	; decrement_and_branch_until_zero
%L751:
	dpb 2,3
	popj 17,

st_ret_array_char8:
	lsh 2,34
	ash 2,-34
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 8,array_char8,7]
	jumpe 4,%L754
%L753:
	ibp 3
	sojn 4,%L753	; decrement_and_branch_until_zero
%L754:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 8,array_char8,7]
	jumpe 1,%L756
%L755:
	ibp 4
	sojn 1,%L755	; decrement_and_branch_until_zero
%L756:
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

ld_varray_char8:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,varray_char8,7]
	jumpe 4,%L759
%L758:
	ibp 1
	sojn 4,%L758	; decrement_and_branch_until_zero
%L759:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

st_varray_char8:
	lsh 2,34
	ash 2,-34
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,varray_char8,7]
	jumpe 4,%L762
%L761:
	ibp 3
	sojn 4,%L761	; decrement_and_branch_until_zero
%L762:
	dpb 2,3
	popj 17,

ld_pointer_char8:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

st_pointer_char8:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

st_ret_pointer_char8:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	lsh 2,34
	ash 2,-34
	move 1,2
	popj 17,

ld_global_pointer_char8:
	ldb 1,ptr_scalar_char8
	ldb 6,ptr_array_char8
	add 1,6
	lsh 1,34
	ash 1,-34
	popj 17,

ptr_static_char8:
	move 1,[POINT 18,scalar_char8,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 8,array_char8,31]
	pushj 17,scalar_memory_forms
	move 1,[POINT 8,box_char8,7]
	jrst scalar_memory_forms

ld_stack_char8:
	add 17,[1,,1]
	lsh 1,34
	ash 1,-34
	movem 1,(17)
	move 1,(17)
	lsh 1,34
	ash 1,-34
	add 17,[-1,,-1]
	popj 17,

st_stack_char8:
	add 17,[1,,1]
	lsh 1,34
	ash 1,-34
	movem 1,(17)
	move 1,(17)
	lsh 1,34
	ash 1,-34
	add 17,[-1,,-1]
	popj 17,

ptr_stack_char8:
	add 17,[2,,2]
	lsh 1,34
	ash 1,-34
	dpb 1,[POINT 9,-1(17),35]
	dpb 1,[POINT 8,(17),7]
	addi 1,1
	dpb 1,[POINT 8,(17),15]
	addi 1,1
	dpb 1,[POINT 8,(17),23]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,341000
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_char8:
	lsh 1,34
	ash 1,-34
	ldb 6,[POINT 18,scalar_char8,35]
	add 1,6
	movem 1,scalar_char8
	lsh 1,34
	ash 1,-34
	popj 17,

update_pointer_char8:
	lsh 2,34
	ash 2,-34
	ldb 6,1
	add 2,6
	dpb 2,1
	lsh 2,34
	ash 2,-34
	move 1,2
	popj 17,

sum_array_char8:
	setzb 6,2
	caml 6,1
	jrst %L790
	subi 1,1
%L791:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,array_char8,7]
	jumpe 4,%L787
%L786:
	ibp 3
	sojn 4,%L786	; decrement_and_branch_until_zero
%L787:
	ldb 4,3
	trne 4,200
	orcmi 4,377
	add 6,4
	addi 2,1
	sojge 1,%L791	; doloop_end
%L790:
	move 1,6
	popj 17,

call_with_scalar_char8:
	push 17,10
	move 10,1
	lsh 10,34
	ash 10,-34
	lsh 10,34
	ash 10,-34
	lsh 10,34
	ash 10,-34
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_char8:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 13,2
	lsh 1,34
	ash 1,-34
	move 10,1
	lsh 10,34
	ash 10,-34
	move 15,2
	andi 15,7
	move 14,2
	andi 14,3
	move 4,14
	move 12,15
	ash 12,-2	; ashrsi3_pointer
	add 12,[POINT 8,array_char8,7]
	jumpe 14,%L797
%L796:
	ibp 12
	sojn 4,%L796	; decrement_and_branch_until_zero
%L797:
	move 11,10
	lsh 11,34
	ash 11,-34
	move 1,11
	pushj 17,st_static_char8
	move 1,10
	addi 1,1
	lsh 1,34
	ash 1,-34
	pushj 17,st_volatile_char8
	move 1,10
	addi 1,2
	lsh 1,34
	ash 1,-34
	pushj 17,st_struct_char8
	move 1,10
	addi 1,3
	lsh 1,34
	ash 1,-34
	pushj 17,st_vstruct_char8
	move 2,10
	addi 2,4
	lsh 2,34
	ash 2,-34
	move 1,15
	pushj 17,st_array_char8
	move 2,10
	addi 2,5
	lsh 2,34
	ash 2,-34
	move 1,14
	pushj 17,st_varray_char8
	move 2,10
	addi 2,6
	lsh 2,34
	ash 2,-34
	move 1,12
	pushj 17,st_pointer_char8
	pushj 17,ptr_static_char8
	move 1,11
	pushj 17,ptr_stack_char8
	pushj 17,ld_static_char8
	move 10,1
	lsh 10,34
	ash 10,-34
	move 1,11
	pushj 17,st_ret_static_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	pushj 17,ld_volatile_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	pushj 17,ld_struct_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	pushj 17,ld_vstruct_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,15
	pushj 17,ld_array_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	addi 13,1
	andi 13,7
	move 1,13
	move 2,11
	pushj 17,st_ret_array_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,14
	pushj 17,ld_varray_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,12
	pushj 17,ld_pointer_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,12
	move 2,11
	pushj 17,st_ret_pointer_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	pushj 17,ld_global_pointer_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,ld_stack_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,st_stack_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,update_static_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,12
	move 2,11
	pushj 17,update_pointer_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	movei 1,4
	pushj 17,sum_array_char8
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_char8
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_char8:
	lsh 1,34
	ash 1,-34
	lsh 1,33
	ash 1,-33
	seto 4,
	jumpl 1,%L798
	skipe 4,1
	movei 4,1
%L798:
	move 1,4
	popj 17,

sign_load_static_char8:
	hrre 1,scalar_char8
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_uchar8:
	.long	scalar_uchar8+301989888
	.align	2
ptr_array_uchar8:
	.long	array_uchar8+4429185024

ld_static_uchar8:
	move 1,scalar_uchar8
	popj 17,

st_static_uchar8:
	movem 1,scalar_uchar8
	popj 17,

st_ret_static_uchar8:
	andi 1,377
	movem 1,scalar_uchar8
	andi 1,377
	popj 17,

ld_volatile_uchar8:
	ldb 1,[POINT 18,vscalar_uchar8,35]
	popj 17,

st_volatile_uchar8:
	andi 1,377
	movem 1,vscalar_uchar8
	popj 17,

ld_struct_uchar8:
	move 1,box_uchar8
	lsh 1,-34
	popj 17,

st_struct_uchar8:
	andi 1,377
	dpb 1,[POINT 8,box_uchar8,7]
	addi 1,1
	dpb 1,[POINT 8,box_uchar8,15]
	popj 17,

ld_vstruct_uchar8:
	move 1,vbox_uchar8
	lsh 1,-34
	popj 17,

st_vstruct_uchar8:
	andi 1,377
	dpb 1,[POINT 8,vbox_uchar8,7]
	addi 1,1
	dpb 1,[POINT 8,vbox_uchar8,15]
	popj 17,

ld_array_uchar8:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,array_uchar8,7]
	jumpe 4,%L815
%L814:
	ibp 3
	sojn 4,%L814	; decrement_and_branch_until_zero
%L815:
	ldb 1,3
	popj 17,

st_array_uchar8:
	andi 2,377
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,array_uchar8,7]
	jumpe 4,%L818
%L817:
	ibp 3
	sojn 4,%L817	; decrement_and_branch_until_zero
%L818:
	dpb 2,3
	popj 17,

st_ret_array_uchar8:
	andi 2,377
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 8,array_uchar8,7]
	jumpe 4,%L821
%L820:
	ibp 3
	sojn 4,%L820	; decrement_and_branch_until_zero
%L821:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 8,array_uchar8,7]
	jumpe 1,%L823
%L822:
	ibp 4
	sojn 1,%L822	; decrement_and_branch_until_zero
%L823:
	ldb 1,4
	popj 17,

ld_varray_uchar8:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,varray_uchar8,7]
	jumpe 4,%L826
%L825:
	ibp 1
	sojn 4,%L825	; decrement_and_branch_until_zero
%L826:
	ldb 1,1
	popj 17,

st_varray_uchar8:
	andi 2,377
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,varray_uchar8,7]
	jumpe 4,%L829
%L828:
	ibp 3
	sojn 4,%L828	; decrement_and_branch_until_zero
%L829:
	dpb 2,3
	popj 17,

ld_pointer_uchar8:
	ldb 1,1
	popj 17,

st_pointer_uchar8:
	andi 2,377
	dpb 2,1
	popj 17,

st_ret_pointer_uchar8:
	andi 2,377
	dpb 2,1
	andi 2,377
	move 1,2
	popj 17,

ld_global_pointer_uchar8:
	ldb 1,ptr_scalar_uchar8
	ldb 6,ptr_array_uchar8
	add 1,6
	andi 1,377
	popj 17,

ptr_static_uchar8:
	move 1,[POINT 18,scalar_uchar8,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 8,array_uchar8,31]
	pushj 17,scalar_memory_forms
	move 1,[POINT 8,box_uchar8,7]
	jrst scalar_memory_forms

ld_stack_uchar8:
	add 17,[1,,1]
	andi 1,377
	movem 1,(17)
	move 1,(17)
	andi 1,377
	add 17,[-1,,-1]
	popj 17,

st_stack_uchar8:
	add 17,[1,,1]
	andi 1,377
	movem 1,(17)
	move 1,(17)
	andi 1,377
	add 17,[-1,,-1]
	popj 17,

ptr_stack_uchar8:
	add 17,[2,,2]
	andi 1,377
	dpb 1,[POINT 9,-1(17),35]
	dpb 1,[POINT 8,(17),7]
	addi 1,1
	dpb 1,[POINT 8,(17),15]
	addi 1,1
	dpb 1,[POINT 8,(17),23]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,341000
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_uchar8:
	andi 1,377
	ldb 6,[POINT 18,scalar_uchar8,35]
	add 1,6
	movem 1,scalar_uchar8
	andi 1,377
	popj 17,

update_pointer_uchar8:
	andi 2,377
	ldb 6,1
	add 2,6
	dpb 2,1
	andi 2,377
	move 1,2
	popj 17,

sum_array_uchar8:
	setzb 6,2
	caml 6,1
	jrst %L857
	subi 1,1
%L858:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,array_uchar8,7]
	jumpe 4,%L854
%L853:
	ibp 3
	sojn 4,%L853	; decrement_and_branch_until_zero
%L854:
	ldb 4,3
	add 6,4
	addi 2,1
	sojge 1,%L858	; doloop_end
%L857:
	move 1,6
	popj 17,

call_with_scalar_uchar8:
	push 17,10
	move 10,1
	andi 10,377
	andi 10,377
	andi 10,377
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_uchar8:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 13,2
	andi 1,377
	move 10,1
	andi 10,377
	move 15,2
	andi 15,7
	move 14,2
	andi 14,3
	move 4,14
	move 12,15
	ash 12,-2	; ashrsi3_pointer
	add 12,[POINT 8,array_uchar8,7]
	jumpe 14,%L864
%L863:
	ibp 12
	sojn 4,%L863	; decrement_and_branch_until_zero
%L864:
	move 11,10
	andi 11,377
	move 1,11
	pushj 17,st_static_uchar8
	move 1,10
	addi 1,1
	andi 1,377
	pushj 17,st_volatile_uchar8
	move 1,10
	addi 1,2
	andi 1,377
	pushj 17,st_struct_uchar8
	move 1,10
	addi 1,3
	andi 1,377
	pushj 17,st_vstruct_uchar8
	move 2,10
	addi 2,4
	andi 2,377
	move 1,15
	pushj 17,st_array_uchar8
	move 2,10
	addi 2,5
	andi 2,377
	move 1,14
	pushj 17,st_varray_uchar8
	move 2,10
	addi 2,6
	andi 2,377
	move 1,12
	pushj 17,st_pointer_uchar8
	pushj 17,ptr_static_uchar8
	move 1,11
	pushj 17,ptr_stack_uchar8
	pushj 17,ld_static_uchar8
	move 10,1
	andi 10,377
	move 1,11
	pushj 17,st_ret_static_uchar8
	andi 1,377
	add 10,1
	pushj 17,ld_volatile_uchar8
	andi 1,377
	add 10,1
	pushj 17,ld_struct_uchar8
	andi 1,377
	add 10,1
	pushj 17,ld_vstruct_uchar8
	andi 1,377
	add 10,1
	move 1,15
	pushj 17,ld_array_uchar8
	andi 1,377
	add 10,1
	addi 13,1
	andi 13,7
	move 1,13
	move 2,11
	pushj 17,st_ret_array_uchar8
	andi 1,377
	add 10,1
	move 1,14
	pushj 17,ld_varray_uchar8
	andi 1,377
	add 10,1
	move 1,12
	pushj 17,ld_pointer_uchar8
	andi 1,377
	add 10,1
	move 1,12
	move 2,11
	pushj 17,st_ret_pointer_uchar8
	andi 1,377
	add 10,1
	pushj 17,ld_global_pointer_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,ld_stack_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,st_stack_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,update_static_uchar8
	andi 1,377
	add 10,1
	move 1,12
	move 2,11
	pushj 17,update_pointer_uchar8
	andi 1,377
	add 10,1
	movei 1,4
	pushj 17,sum_array_uchar8
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_uchar8
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_uchar8:
	ldb 1,1
	popj 17,

unsigned_branch_uchar8:
	andi 1,377
	movei 3,0
	jumpe 1,%L866
	skipl 3,1
	cail 3,200
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L866:
	move 1,3
	popj 17,

	.data
	.align	2
ptr_scalar_char9:
	.long	scalar_char9+301989888
	.align	2
ptr_array_char9:
	.long	array_char9+150994944

ld_static_char9:
	hrre 1,scalar_char9
	popj 17,

st_static_char9:
	movem 1,scalar_char9
	popj 17,

st_ret_static_char9:
	movem 1,scalar_char9
	lsh 1,33
	ash 1,-33
	popj 17,

ld_volatile_char9:
	hrre 1,vscalar_char9
	popj 17,

st_volatile_char9:
	movem 1,vscalar_char9
	popj 17,

ld_struct_char9:
	move 1,box_char9
	ash 1,-33
	popj 17,

st_struct_char9:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,box_char9,8]
	addi 1,1
	dpb 1,[POINT 9,box_char9,17]
	popj 17,

ld_vstruct_char9:
	ldb 1,[POINT 9,vbox_char9,8]
	lsh 1,33
	ash 1,-33
	popj 17,

st_vstruct_char9:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vbox_char9,8]
	addi 1,1
	dpb 1,[POINT 9,vbox_char9,17]
	popj 17,

ld_array_char9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_char9,8]
	jumpe 4,%L882
%L881:
	ibp 3
	sojn 4,%L881	; decrement_and_branch_until_zero
%L882:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

st_array_char9:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_char9,8]
	jumpe 4,%L885
%L884:
	ibp 3
	sojn 4,%L884	; decrement_and_branch_until_zero
%L885:
	dpb 2,3
	popj 17,

st_ret_array_char9:
	andi 2,777	; zero_extendqisi2
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 9,array_char9,8]
	jumpe 4,%L888
%L887:
	ibp 3
	sojn 4,%L887	; decrement_and_branch_until_zero
%L888:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 9,array_char9,8]
	jumpe 1,%L890
%L889:
	ibp 4
	sojn 1,%L889	; decrement_and_branch_until_zero
%L890:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ld_varray_char9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,varray_char9,8]
	jumpe 4,%L893
%L892:
	ibp 1
	sojn 4,%L892	; decrement_and_branch_until_zero
%L893:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

st_varray_char9:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,varray_char9,8]
	jumpe 4,%L896
%L895:
	ibp 3
	sojn 4,%L895	; decrement_and_branch_until_zero
%L896:
	dpb 2,3
	popj 17,

ld_pointer_char9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

st_pointer_char9:
	dpb 2,1
	popj 17,

st_ret_pointer_char9:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

ld_global_pointer_char9:
	ldb 1,ptr_scalar_char9
	ldb 6,ptr_array_char9
	add 1,6
	lsh 1,33
	ash 1,-33
	popj 17,

ptr_static_char9:
	move 1,[POINT 18,scalar_char9,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,array_char9,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,box_char9,8]
	jrst scalar_memory_forms

ld_stack_char9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_char9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_char9:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,331100
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_char9:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,scalar_char9,35]
	add 1,6
	movem 1,scalar_char9
	lsh 1,33
	ash 1,-33
	popj 17,

update_pointer_char9:
	andi 2,777	; zero_extendqisi2
	ldb 6,1
	add 2,6
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

sum_array_char9:
	setzb 6,2
	caml 6,1
	jrst %L924
	subi 1,1
%L925:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_char9,8]
	jumpe 4,%L921
%L920:
	ibp 3
	sojn 4,%L920	; decrement_and_branch_until_zero
%L921:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 6,4
	addi 2,1
	sojge 1,%L925	; doloop_end
%L924:
	move 1,6
	popj 17,

call_with_scalar_char9:
	push 17,10
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_char9:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 13,2
	andi 10,777
	move 15,2
	andi 15,7
	move 14,2
	andi 14,3
	move 4,14
	move 12,15
	ash 12,-2	; ashrsi3_pointer
	add 12,[POINT 9,array_char9,8]
	jumpe 14,%L931
%L930:
	ibp 12
	sojn 4,%L930	; decrement_and_branch_until_zero
%L931:
	move 11,10
	lsh 11,33
	ash 11,-33
	move 1,11
	pushj 17,st_static_char9
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_volatile_char9
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_struct_char9
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,st_vstruct_char9
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,15
	pushj 17,st_array_char9
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,14
	pushj 17,st_varray_char9
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,12
	pushj 17,st_pointer_char9
	pushj 17,ptr_static_char9
	move 1,11
	pushj 17,ptr_stack_char9
	pushj 17,ld_static_char9
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,11
	pushj 17,st_ret_static_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_volatile_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_struct_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_vstruct_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,15
	pushj 17,ld_array_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	addi 13,1
	andi 13,7
	move 1,13
	move 2,11
	pushj 17,st_ret_array_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,14
	pushj 17,ld_varray_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	pushj 17,ld_pointer_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	move 2,11
	pushj 17,st_ret_pointer_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	pushj 17,ld_global_pointer_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,ld_stack_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,st_stack_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,update_static_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,12
	move 2,11
	pushj 17,update_pointer_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	movei 1,4
	pushj 17,sum_array_char9
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_char9
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_char9:
	lsh 1,33
	ash 1,-33
	seto 4,
	jumpl 1,%L932
	skipe 4,1
	movei 4,1
%L932:
	move 1,4
	popj 17,

sign_load_static_char9:
	hrre 1,scalar_char9
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_uchar9:
	.long	scalar_uchar9+301989888
	.align	2
ptr_array_uchar9:
	.long	array_uchar9+150994944

ld_static_uchar9:
	move 1,scalar_uchar9
	popj 17,

st_static_uchar9:
	movem 1,scalar_uchar9
	popj 17,

st_ret_static_uchar9:
	movem 1,scalar_uchar9
	popj 17,

ld_volatile_uchar9:
	move 1,vscalar_uchar9
	popj 17,

st_volatile_uchar9:
	movem 1,vscalar_uchar9
	popj 17,

ld_struct_uchar9:
	move 1,box_uchar9
	lsh 1,-33
	popj 17,

st_struct_uchar9:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,box_uchar9,8]
	addi 1,1
	dpb 1,[POINT 9,box_uchar9,17]
	popj 17,

ld_vstruct_uchar9:
	ldb 1,[POINT 9,vbox_uchar9,8]
	popj 17,

st_vstruct_uchar9:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vbox_uchar9,8]
	addi 1,1
	dpb 1,[POINT 9,vbox_uchar9,17]
	popj 17,

ld_array_uchar9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uchar9,8]
	jumpe 4,%L949
%L948:
	ibp 3
	sojn 4,%L948	; decrement_and_branch_until_zero
%L949:
	ldb 1,3
	popj 17,

st_array_uchar9:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uchar9,8]
	jumpe 4,%L952
%L951:
	ibp 3
	sojn 4,%L951	; decrement_and_branch_until_zero
%L952:
	dpb 2,3
	popj 17,

st_ret_array_uchar9:
	andi 2,777	; zero_extendqisi2
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 9,array_uchar9,8]
	jumpe 4,%L955
%L954:
	ibp 3
	sojn 4,%L954	; decrement_and_branch_until_zero
%L955:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 9,array_uchar9,8]
	jumpe 1,%L957
%L956:
	ibp 4
	sojn 1,%L956	; decrement_and_branch_until_zero
%L957:
	ldb 1,4
	popj 17,

ld_varray_uchar9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,varray_uchar9,8]
	jumpe 4,%L960
%L959:
	ibp 1
	sojn 4,%L959	; decrement_and_branch_until_zero
%L960:
	ldb 1,1
	popj 17,

st_varray_uchar9:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,varray_uchar9,8]
	jumpe 4,%L963
%L962:
	ibp 3
	sojn 4,%L962	; decrement_and_branch_until_zero
%L963:
	dpb 2,3
	popj 17,

ld_pointer_uchar9:
	ldb 1,1
	popj 17,

st_pointer_uchar9:
	dpb 2,1
	popj 17,

st_ret_pointer_uchar9:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	move 1,2
	popj 17,

ld_global_pointer_uchar9:
	ldb 1,ptr_scalar_uchar9
	ldb 6,ptr_array_uchar9
	add 1,6
	andi 1,777	; zero_extendqisi2
	popj 17,

ptr_static_uchar9:
	move 1,[POINT 18,scalar_uchar9,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,array_uchar9,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,box_uchar9,8]
	jrst scalar_memory_forms

ld_stack_uchar9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_uchar9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_uchar9:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,(17)
	tlo 1,331100
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

update_static_uchar9:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,scalar_uchar9,35]
	add 1,6
	movem 1,scalar_uchar9
	andi 1,777
	popj 17,

update_pointer_uchar9:
	andi 2,777	; zero_extendqisi2
	ldb 6,1
	add 2,6
	dpb 2,1
	andi 2,777
	move 1,2
	popj 17,

sum_array_uchar9:
	setzb 6,2
	caml 6,1
	jrst %L991
	subi 1,1
%L992:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uchar9,8]
	jumpe 4,%L988
%L987:
	ibp 3
	sojn 4,%L987	; decrement_and_branch_until_zero
%L988:
	ldb 3,3
	add 6,3
	addi 2,1
	sojge 1,%L992	; doloop_end
%L991:
	move 1,6
	popj 17,

call_with_scalar_uchar9:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_uchar9:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 13,2
	move 11,1
	andi 11,777	; zero_extendqisi2
	move 15,2
	andi 15,7
	move 14,2
	andi 14,3
	move 4,14
	move 12,15
	ash 12,-2	; ashrsi3_pointer
	add 12,[POINT 9,array_uchar9,8]
	jumpe 14,%L998
%L997:
	ibp 12
	sojn 4,%L997	; decrement_and_branch_until_zero
%L998:
	move 1,11
	pushj 17,st_static_uchar9
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_volatile_uchar9
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_struct_uchar9
	addi 11,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,st_vstruct_uchar9
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	move 1,15
	pushj 17,st_array_uchar9
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	move 1,14
	pushj 17,st_varray_uchar9
	addi 11,1
	move 2,11
	andi 2,777	; zero_extendqisi2
	subi 11,6
	move 1,12
	pushj 17,st_pointer_uchar9
	pushj 17,ptr_static_uchar9
	move 1,11
	pushj 17,ptr_stack_uchar9
	pushj 17,ld_static_uchar9
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,11
	pushj 17,st_ret_static_uchar9
	add 10,1
	pushj 17,ld_volatile_uchar9
	add 10,1
	pushj 17,ld_struct_uchar9
	add 10,1
	pushj 17,ld_vstruct_uchar9
	add 10,1
	move 1,15
	pushj 17,ld_array_uchar9
	add 10,1
	addi 13,1
	andi 13,7
	move 1,13
	move 2,11
	pushj 17,st_ret_array_uchar9
	add 10,1
	move 1,14
	pushj 17,ld_varray_uchar9
	add 10,1
	move 1,12
	pushj 17,ld_pointer_uchar9
	add 10,1
	move 1,12
	move 2,11
	pushj 17,st_ret_pointer_uchar9
	add 10,1
	pushj 17,ld_global_pointer_uchar9
	add 10,1
	move 1,11
	pushj 17,ld_stack_uchar9
	add 10,1
	move 1,11
	pushj 17,st_stack_uchar9
	add 10,1
	move 1,11
	pushj 17,update_static_uchar9
	add 10,1
	move 1,12
	move 2,11
	pushj 17,update_pointer_uchar9
	add 10,1
	movei 1,4
	pushj 17,sum_array_uchar9
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_uchar9
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_uchar9:
	ldb 1,1
	popj 17,

unsigned_branch_uchar9:
	andi 1,777	; zero_extendqisi2
	movei 3,0
	jumpe 1,%L1000
	tlc 1,400000
	move 6,[-377777777601]
	camle 1,6
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L1000:
	move 1,3
	popj 17,

	.data
	.align	2
ptr_scalar_short16:
	.long	scalar_short16+301989888
	.align	2
ptr_array_short16:
	.long	array_short16+301989889

ld_static_short16:
	hlrz 1,scalar_short16
	lsh 1,24
	ash 1,-24
	popj 17,

st_static_short16:
	lsh 1,24
	ash 1,-24
	movem 1,scalar_short16
	popj 17,

st_ret_static_short16:
	lsh 1,24
	ash 1,-24
	movem 1,scalar_short16
	lsh 1,24
	ash 1,-24
	popj 17,

ld_volatile_short16:
	hlrz 1,vscalar_short16
	lsh 1,24
	ash 1,-24
	popj 17,

st_volatile_short16:
	lsh 1,24
	ash 1,-24
	movem 1,vscalar_short16
	popj 17,

ld_struct_short16:
	move 1,box_short16
	ash 1,-24
	popj 17,

st_struct_short16:
	lsh 1,24
	ash 1,-24
	dpb 1,[POINT 16,box_short16,15]
	addi 1,1
	dpb 1,[POINT 16,box_short16,31]
	popj 17,

ld_vstruct_short16:
	move 1,vbox_short16
	ash 1,-24
	popj 17,

st_vstruct_short16:
	lsh 1,24
	ash 1,-24
	dpb 1,[POINT 16,vbox_short16,15]
	addi 1,1
	dpb 1,[POINT 16,vbox_short16,31]
	popj 17,

ld_array_short16:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_short16,17]
	jumpe 4,%L1016
%L1015:
	ibp 3
	sojn 4,%L1015	; decrement_and_branch_until_zero
%L1016:
	move 1,(3)
	ash 1,-24
	popj 17,

st_array_short16:
	lsh 2,24
	ash 2,-24
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_short16,17]
	jumpe 4,%L1019
%L1018:
	ibp 3
	sojn 4,%L1018	; decrement_and_branch_until_zero
%L1019:
	dpb 2,3	; movhi
	popj 17,

st_ret_array_short16:
	lsh 2,24
	ash 2,-24
	move 6,1
	move 4,1
	andi 4,1
	ash 6,-1	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 18,array_short16,17]
	jumpe 4,%L1022
%L1021:
	ibp 3
	sojn 4,%L1021	; decrement_and_branch_until_zero
%L1022:
	dpb 2,3	; movhi
	andi 1,1
	move 4,6
	add 4,[POINT 18,array_short16,17]
	jumpe 1,%L1024
%L1023:
	ibp 4
	sojn 1,%L1023	; decrement_and_branch_until_zero
%L1024:
	move 1,(4)
	ash 1,-24
	popj 17,

ld_varray_short16:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,varray_short16,17]
	jumpe 4,%L1027
%L1026:
	ibp 1
	sojn 4,%L1026	; decrement_and_branch_until_zero
%L1027:
	ldb 1,1
	lsh 1,22
	ash 1,-24
	popj 17,

st_varray_short16:
	lsh 2,24
	ash 2,-24
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,varray_short16,17]
	jumpe 4,%L1030
%L1029:
	ibp 3
	sojn 4,%L1029	; decrement_and_branch_until_zero
%L1030:
	dpb 2,3	; movhi
	popj 17,

ld_pointer_short16:
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

st_pointer_short16:
	lsh 2,24
	ash 2,-24
	dpb 2,1	; movhi
	popj 17,

st_ret_pointer_short16:
	lsh 2,24
	ash 2,-24
	dpb 2,1	; movhi
	lsh 2,24
	ash 2,-24
	move 1,2
	popj 17,

ld_global_pointer_short16:
	ldb 1,ptr_scalar_short16
	ldb 6,ptr_array_short16
	add 1,6
	lsh 1,24
	ash 1,-24
	popj 17,

ptr_static_short16:
	move 1,[POINT 18,scalar_short16,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,array_short16+1,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,box_short16,17]
	jrst scalar_memory_forms

ld_stack_short16:
	add 17,[1,,1]
	lsh 1,24
	ash 1,-24
	movem 1,(17)
	move 1,(17)
	lsh 1,24
	ash 1,-24
	add 17,[-1,,-1]
	popj 17,

st_stack_short16:
	add 17,[1,,1]
	lsh 1,24
	ash 1,-24
	movem 1,(17)
	move 1,(17)
	lsh 1,24
	ash 1,-24
	add 17,[-1,,-1]
	popj 17,

ptr_stack_short16:
	add 17,[3,,3]
	lsh 1,24
	ash 1,-24
	hrrm 1,-2(17)
	dpb 1,[POINT 16,-1(17),15]
	addi 1,1
	dpb 1,[POINT 16,-1(17),31]
	addi 1,1
	dpb 1,[POINT 16,(17),15]
	movei 1,-2(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,-1(17)
	tlo 1,222200
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

update_static_short16:
	lsh 1,24
	ash 1,-24
	hlrz 6,scalar_short16
	add 1,6
	movem 1,scalar_short16
	lsh 1,24
	ash 1,-24
	popj 17,

update_pointer_short16:
	lsh 2,24
	ash 2,-24
	ldb 6,1
	add 2,6
	dpb 2,1	; movhi
	lsh 2,24
	ash 2,-24
	move 1,2
	popj 17,

sum_array_short16:
	setzb 6,2
	caml 6,1
	jrst %L1058
	subi 1,1
%L1059:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_short16,17]
	jumpe 4,%L1055
%L1054:
	ibp 3
	sojn 4,%L1054	; decrement_and_branch_until_zero
%L1055:
	move 4,(3)
	ash 4,-24
	add 6,4
	addi 2,1
	sojge 1,%L1059	; doloop_end
%L1058:
	move 1,6
	popj 17,

call_with_scalar_short16:
	push 17,10
	move 10,1
	lsh 10,24
	ash 10,-24
	lsh 10,24
	ash 10,-24
	lsh 10,24
	ash 10,-24
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_short16:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	lsh 1,24
	ash 1,-24
	move 10,1
	lsh 10,24
	ash 10,-24
	move 15,2
	andi 15,7
	move 4,2
	andi 4,1
	move 13,15
	ash 13,-1	; ashrsi3_pointer
	add 13,[POINT 18,array_short16,17]
	jumpe 4,%L1065
%L1064:
	ibp 13
	sojn 4,%L1064	; decrement_and_branch_until_zero
%L1065:
	move 11,10
	lsh 11,24
	ash 11,-24
	move 1,11
	pushj 17,st_static_short16
	move 1,10
	addi 1,1
	lsh 1,24
	ash 1,-24
	pushj 17,st_volatile_short16
	move 1,10
	addi 1,2
	lsh 1,24
	ash 1,-24
	pushj 17,st_struct_short16
	move 1,10
	addi 1,3
	lsh 1,24
	ash 1,-24
	pushj 17,st_vstruct_short16
	move 2,10
	addi 2,4
	lsh 2,24
	ash 2,-24
	move 1,15
	pushj 17,st_array_short16
	move 12,14
	andi 12,3
	move 2,10
	addi 2,5
	lsh 2,24
	ash 2,-24
	move 1,12
	pushj 17,st_varray_short16
	move 2,10
	addi 2,6
	lsh 2,24
	ash 2,-24
	move 1,13
	pushj 17,st_pointer_short16
	pushj 17,ptr_static_short16
	move 1,11
	pushj 17,ptr_stack_short16
	pushj 17,ld_static_short16
	move 10,1
	lsh 10,24
	ash 10,-24
	move 1,11
	pushj 17,st_ret_static_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	pushj 17,ld_volatile_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	pushj 17,ld_struct_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	pushj 17,ld_vstruct_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,15
	pushj 17,ld_array_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,11
	pushj 17,st_ret_array_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,12
	pushj 17,ld_varray_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,13
	pushj 17,ld_pointer_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,13
	move 2,11
	pushj 17,st_ret_pointer_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	pushj 17,ld_global_pointer_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,ld_stack_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,st_stack_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,update_static_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,13
	move 2,11
	pushj 17,update_pointer_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	movei 1,4
	pushj 17,sum_array_short16
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_short16
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_short16:
	lsh 1,24
	ash 1,-24
	hrre 1,1	; extendhisi2
	seto 4,
	jumpl 1,%L1066
	skipe 4,1
	movei 4,1
%L1066:
	move 1,4
	popj 17,

sign_load_static_short16:
	hrre 1,scalar_short16
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_ushort16:
	.long	scalar_ushort16+301989888
	.align	2
ptr_array_ushort16:
	.long	array_ushort16+301989889

ld_static_ushort16:
	hlrz 1,scalar_ushort16
	andi 1,177777
	popj 17,

st_static_ushort16:
	andi 1,177777
	movem 1,scalar_ushort16
	popj 17,

st_ret_static_ushort16:
	andi 1,177777
	movem 1,scalar_ushort16
	andi 1,177777
	popj 17,

ld_volatile_ushort16:
	hlrz 1,vscalar_ushort16
	andi 1,177777
	popj 17,

st_volatile_ushort16:
	andi 1,177777
	movem 1,vscalar_ushort16
	popj 17,

ld_struct_ushort16:
	move 1,box_ushort16
	lsh 1,-24
	popj 17,

st_struct_ushort16:
	andi 1,177777
	dpb 1,[POINT 16,box_ushort16,15]
	addi 1,1
	dpb 1,[POINT 16,box_ushort16,31]
	popj 17,

ld_vstruct_ushort16:
	move 1,vbox_ushort16
	lsh 1,-24
	popj 17,

st_vstruct_ushort16:
	andi 1,177777
	dpb 1,[POINT 16,vbox_ushort16,15]
	addi 1,1
	dpb 1,[POINT 16,vbox_ushort16,31]
	popj 17,

ld_array_ushort16:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,array_ushort16,17]
	jumpe 4,%L1083
%L1082:
	ibp 1
	sojn 4,%L1082	; decrement_and_branch_until_zero
%L1083:
	move 1,(1)
	lsh 1,-24
	popj 17,

st_array_ushort16:
	andi 2,177777
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_ushort16,17]
	jumpe 4,%L1086
%L1085:
	ibp 3
	sojn 4,%L1085	; decrement_and_branch_until_zero
%L1086:
	dpb 2,3	; movhi
	popj 17,

st_ret_array_ushort16:
	andi 2,177777
	move 6,1
	move 4,1
	andi 4,1
	ash 6,-1	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 18,array_ushort16,17]
	jumpe 4,%L1089
%L1088:
	ibp 3
	sojn 4,%L1088	; decrement_and_branch_until_zero
%L1089:
	dpb 2,3	; movhi
	andi 1,1
	move 4,6
	add 4,[POINT 18,array_ushort16,17]
	jumpe 1,%L1091
%L1090:
	ibp 4
	sojn 1,%L1090	; decrement_and_branch_until_zero
%L1091:
	move 1,(4)
	lsh 1,-24
	popj 17,

ld_varray_ushort16:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,varray_ushort16,17]
	jumpe 4,%L1094
%L1093:
	ibp 1
	sojn 4,%L1093	; decrement_and_branch_until_zero
%L1094:
	move 1,(1)
	lsh 1,-24
	popj 17,

st_varray_ushort16:
	andi 2,177777
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,varray_ushort16,17]
	jumpe 4,%L1097
%L1096:
	ibp 3
	sojn 4,%L1096	; decrement_and_branch_until_zero
%L1097:
	dpb 2,3	; movhi
	popj 17,

ld_pointer_ushort16:
	ldb 1,1
	andi 1,177777
	popj 17,

st_pointer_ushort16:
	andi 2,177777
	dpb 2,1	; movhi
	popj 17,

st_ret_pointer_ushort16:
	andi 2,177777
	dpb 2,1	; movhi
	andi 2,177777
	move 1,2
	popj 17,

ld_global_pointer_ushort16:
	ldb 1,ptr_scalar_ushort16
	ldb 6,ptr_array_ushort16
	add 1,6
	andi 1,177777
	popj 17,

ptr_static_ushort16:
	move 1,[POINT 18,scalar_ushort16,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,array_ushort16+1,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,box_ushort16,17]
	jrst scalar_memory_forms

ld_stack_ushort16:
	add 17,[1,,1]
	andi 1,177777
	movem 1,(17)
	move 1,(17)
	andi 1,177777
	add 17,[-1,,-1]
	popj 17,

st_stack_ushort16:
	add 17,[1,,1]
	andi 1,177777
	movem 1,(17)
	move 1,(17)
	andi 1,177777
	add 17,[-1,,-1]
	popj 17,

ptr_stack_ushort16:
	add 17,[3,,3]
	andi 1,177777
	hrrm 1,-2(17)
	dpb 1,[POINT 16,-1(17),15]
	addi 1,1
	dpb 1,[POINT 16,-1(17),31]
	addi 1,1
	dpb 1,[POINT 16,(17),15]
	movei 1,-2(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,-1(17)
	tlo 1,222200
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

update_static_ushort16:
	andi 1,177777
	hlrz 6,scalar_ushort16
	add 1,6
	movem 1,scalar_ushort16
	andi 1,177777
	popj 17,

update_pointer_ushort16:
	andi 2,177777
	ldb 6,1
	add 2,6
	dpb 2,1	; movhi
	andi 2,177777
	move 1,2
	popj 17,

sum_array_ushort16:
	setzb 6,2
	caml 6,1
	jrst %L1125
	subi 1,1
%L1126:
	move 3,2
	andi 3,1
	move 4,2
	ash 4,-1	; ashrsi3_pointer
	add 4,[POINT 18,array_ushort16,17]
	jumpe 3,%L1122
%L1121:
	ibp 4
	sojn 3,%L1121	; decrement_and_branch_until_zero
%L1122:
	move 4,(4)
	lsh 4,-24
	add 6,4
	addi 2,1
	sojge 1,%L1126	; doloop_end
%L1125:
	move 1,6
	popj 17,

call_with_scalar_ushort16:
	push 17,10
	move 10,1
	andi 10,177777
	andi 10,177777
	andi 10,177777
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_ushort16:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	andi 1,177777
	move 10,1
	andi 10,177777
	move 15,2
	andi 15,7
	move 4,2
	andi 4,1
	move 13,15
	ash 13,-1	; ashrsi3_pointer
	add 13,[POINT 18,array_ushort16,17]
	jumpe 4,%L1132
%L1131:
	ibp 13
	sojn 4,%L1131	; decrement_and_branch_until_zero
%L1132:
	move 11,10
	andi 11,177777
	move 1,11
	pushj 17,st_static_ushort16
	move 1,10
	addi 1,1
	andi 1,177777
	pushj 17,st_volatile_ushort16
	move 1,10
	addi 1,2
	andi 1,177777
	pushj 17,st_struct_ushort16
	move 1,10
	addi 1,3
	andi 1,177777
	pushj 17,st_vstruct_ushort16
	move 2,10
	addi 2,4
	andi 2,177777
	move 1,15
	pushj 17,st_array_ushort16
	move 12,14
	andi 12,3
	move 2,10
	addi 2,5
	andi 2,177777
	move 1,12
	pushj 17,st_varray_ushort16
	move 2,10
	addi 2,6
	andi 2,177777
	move 1,13
	pushj 17,st_pointer_ushort16
	pushj 17,ptr_static_ushort16
	move 1,11
	pushj 17,ptr_stack_ushort16
	pushj 17,ld_static_ushort16
	move 10,1
	andi 10,177777
	move 1,11
	pushj 17,st_ret_static_ushort16
	andi 1,177777
	add 10,1
	pushj 17,ld_volatile_ushort16
	andi 1,177777
	add 10,1
	pushj 17,ld_struct_ushort16
	andi 1,177777
	add 10,1
	pushj 17,ld_vstruct_ushort16
	andi 1,177777
	add 10,1
	move 1,15
	pushj 17,ld_array_ushort16
	andi 1,177777
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,11
	pushj 17,st_ret_array_ushort16
	andi 1,177777
	add 10,1
	move 1,12
	pushj 17,ld_varray_ushort16
	andi 1,177777
	add 10,1
	move 1,13
	pushj 17,ld_pointer_ushort16
	andi 1,177777
	add 10,1
	move 1,13
	move 2,11
	pushj 17,st_ret_pointer_ushort16
	andi 1,177777
	add 10,1
	pushj 17,ld_global_pointer_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,ld_stack_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,st_stack_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,update_static_ushort16
	andi 1,177777
	add 10,1
	move 1,13
	move 2,11
	pushj 17,update_pointer_ushort16
	andi 1,177777
	add 10,1
	movei 1,4
	pushj 17,sum_array_ushort16
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_ushort16
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_ushort16:
	ldb 1,1
	andi 1,177777
	popj 17,

unsigned_branch_ushort16:
	andi 1,177777
	movei 3,0
	jumpe 1,%L1134
	skipl 3,1
	cail 3,200
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L1134:
	move 1,3
	popj 17,

	.data
	.align	2
ptr_scalar_short18:
	.long	scalar_short18+301989888
	.align	2
ptr_array_short18:
	.long	array_short18+301989889

ld_static_short18:
	hrre 1,scalar_short18
	popj 17,

st_static_short18:
	movem 1,scalar_short18
	popj 17,

st_ret_static_short18:
	movem 1,scalar_short18
	hrre 1,1
	popj 17,

ld_volatile_short18:
	hrre 1,vscalar_short18
	popj 17,

st_volatile_short18:
	movem 1,vscalar_short18
	popj 17,

ld_struct_short18:
	hlre 1,box_short18
	popj 17,

st_struct_short18:
	hrrzi 1,(1)	; zero_extendhisi2
	hrlm 1,box_short18
	addi 1,1
	hrrm 1,box_short18
	popj 17,

ld_vstruct_short18:
	hlrz 1,vbox_short18
	hrre 1,1
	popj 17,

st_vstruct_short18:
	hrrzi 1,(1)	; zero_extendhisi2
	hrlm 1,vbox_short18
	addi 1,1
	hrrm 1,vbox_short18
	popj 17,

ld_array_short18:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_short18,17]
	jumpe 4,%L1150
%L1149:
	ibp 3
	sojn 4,%L1149	; decrement_and_branch_until_zero
%L1150:
	ldb 1,3
	hrre 1,1
	popj 17,

st_array_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_short18,17]
	jumpe 4,%L1153
%L1152:
	ibp 3
	sojn 4,%L1152	; decrement_and_branch_until_zero
%L1153:
	dpb 2,3	; movhi
	popj 17,

st_ret_array_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 6,1
	move 4,1
	andi 4,1
	ash 6,-1	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 18,array_short18,17]
	jumpe 4,%L1156
%L1155:
	ibp 3
	sojn 4,%L1155	; decrement_and_branch_until_zero
%L1156:
	dpb 2,3	; movhi
	andi 1,1
	move 4,6
	add 4,[POINT 18,array_short18,17]
	jumpe 1,%L1158
%L1157:
	ibp 4
	sojn 1,%L1157	; decrement_and_branch_until_zero
%L1158:
	ldb 1,4
	hrre 1,1
	popj 17,

ld_varray_short18:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,varray_short18,17]
	jumpe 4,%L1161
%L1160:
	ibp 3
	sojn 4,%L1160	; decrement_and_branch_until_zero
%L1161:
	ldb 1,3
	hrre 1,1
	popj 17,

st_varray_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,varray_short18,17]
	jumpe 4,%L1164
%L1163:
	ibp 3
	sojn 4,%L1163	; decrement_and_branch_until_zero
%L1164:
	dpb 2,3	; movhi
	popj 17,

ld_pointer_short18:
	ldb 1,1
	hrre 1,1
	popj 17,

st_pointer_short18:
	dpb 2,1	; movhi
	popj 17,

st_ret_pointer_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	hrre 2,2
	move 1,2
	popj 17,

ld_global_pointer_short18:
	ldb 1,ptr_scalar_short18
	ldb 6,ptr_array_short18
	add 1,6
	hrre 1,1	; extendhisi2
	popj 17,

ptr_static_short18:
	move 1,[POINT 18,scalar_short18,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,array_short18+1,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,box_short18,17]
	jrst scalar_memory_forms

ld_stack_short18:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_short18:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	hrre 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_short18:
	add 17,[3,,3]
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,-2(17)
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,-1(17)
	tlo 1,222200
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

update_static_short18:
	hlrz 6,scalar_short18
	addi 6,(1)
	movem 6,scalar_short18
	hrre 1,6
	popj 17,

update_pointer_short18:
	move 4,1
	ldb 1,1
	addi 1,(2)
	dpb 1,4	; movhi
	hrre 1,1
	popj 17,

sum_array_short18:
	setzb 6,2
	caml 6,1
	jrst %L1192
	subi 1,1
%L1193:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_short18,17]
	jumpe 4,%L1189
%L1188:
	ibp 3
	sojn 4,%L1188	; decrement_and_branch_until_zero
%L1189:
	ldb 4,3
	hrre 4,4
	add 6,4
	addi 2,1
	sojge 1,%L1193	; doloop_end
%L1192:
	move 1,6
	popj 17,

call_with_scalar_short18:
	push 17,10
	hrre 10,1
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_short18:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	hrrz 10,1
	move 15,2
	andi 15,7
	move 4,2
	andi 4,1
	move 13,15
	ash 13,-1	; ashrsi3_pointer
	add 13,[POINT 18,array_short18,17]
	jumpe 4,%L1199
%L1198:
	ibp 13
	sojn 4,%L1198	; decrement_and_branch_until_zero
%L1199:
	hrre 11,10	; extendhisi2
	move 1,11
	pushj 17,st_static_short18
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,st_volatile_short18
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,st_struct_short18
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,st_vstruct_short18
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,15
	pushj 17,st_array_short18
	move 12,14
	andi 12,3
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,12
	pushj 17,st_varray_short18
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,13
	pushj 17,st_pointer_short18
	pushj 17,ptr_static_short18
	move 1,11
	pushj 17,ptr_stack_short18
	pushj 17,ld_static_short18
	hrre 10,1	; extendhisi2
	move 1,11
	pushj 17,st_ret_static_short18
	hrre 1,1	; extendhisi2
	add 10,1
	pushj 17,ld_volatile_short18
	hrre 1,1	; extendhisi2
	add 10,1
	pushj 17,ld_struct_short18
	hrre 1,1	; extendhisi2
	add 10,1
	pushj 17,ld_vstruct_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,15
	pushj 17,ld_array_short18
	hrre 1,1	; extendhisi2
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,11
	pushj 17,st_ret_array_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,12
	pushj 17,ld_varray_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,13
	pushj 17,ld_pointer_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,13
	move 2,11
	pushj 17,st_ret_pointer_short18
	hrre 1,1	; extendhisi2
	add 10,1
	pushj 17,ld_global_pointer_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,ld_stack_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,st_stack_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,update_static_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,13
	move 2,11
	pushj 17,update_pointer_short18
	hrre 1,1	; extendhisi2
	add 10,1
	movei 1,4
	pushj 17,sum_array_short18
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_short18
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_short18:
	hrre 1,1
	seto 4,
	jumpl 1,%L1200
	skipe 4,1
	movei 4,1
%L1200:
	move 1,4
	popj 17,

sign_load_static_short18:
	hrre 1,scalar_short18
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_ushort18:
	.long	scalar_ushort18+301989888
	.align	2
ptr_array_ushort18:
	.long	array_ushort18+301989889

ld_static_ushort18:
	move 1,scalar_ushort18
	popj 17,

st_static_ushort18:
	movem 1,scalar_ushort18
	popj 17,

st_ret_static_ushort18:
	movem 1,scalar_ushort18
	popj 17,

ld_volatile_ushort18:
	move 1,vscalar_ushort18
	popj 17,

st_volatile_ushort18:
	movem 1,vscalar_ushort18
	popj 17,

ld_struct_ushort18:
	hlrz 1,box_ushort18
	popj 17,

st_struct_ushort18:
	hrrzi 1,(1)	; zero_extendhisi2
	hrlm 1,box_ushort18
	addi 1,1
	hrrm 1,box_ushort18
	popj 17,

ld_vstruct_ushort18:
	hlrz 1,vbox_ushort18
	popj 17,

st_vstruct_ushort18:
	hrrzi 1,(1)	; zero_extendhisi2
	hrlm 1,vbox_ushort18
	addi 1,1
	hrrm 1,vbox_ushort18
	popj 17,

ld_array_ushort18:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_ushort18,17]
	jumpe 4,%L1217
%L1216:
	ibp 3
	sojn 4,%L1216	; decrement_and_branch_until_zero
%L1217:
	ldb 1,3
	popj 17,

st_array_ushort18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_ushort18,17]
	jumpe 4,%L1220
%L1219:
	ibp 3
	sojn 4,%L1219	; decrement_and_branch_until_zero
%L1220:
	dpb 2,3	; movhi
	popj 17,

st_ret_array_ushort18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 6,1
	move 4,1
	andi 4,1
	ash 6,-1	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 18,array_ushort18,17]
	jumpe 4,%L1223
%L1222:
	ibp 3
	sojn 4,%L1222	; decrement_and_branch_until_zero
%L1223:
	dpb 2,3	; movhi
	andi 1,1
	move 4,6
	add 4,[POINT 18,array_ushort18,17]
	jumpe 1,%L1225
%L1224:
	ibp 4
	sojn 1,%L1224	; decrement_and_branch_until_zero
%L1225:
	ldb 1,4
	popj 17,

ld_varray_ushort18:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,varray_ushort18,17]
	jumpe 4,%L1228
%L1227:
	ibp 1
	sojn 4,%L1227	; decrement_and_branch_until_zero
%L1228:
	ldb 1,1
	popj 17,

st_varray_ushort18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,varray_ushort18,17]
	jumpe 4,%L1231
%L1230:
	ibp 3
	sojn 4,%L1230	; decrement_and_branch_until_zero
%L1231:
	dpb 2,3	; movhi
	popj 17,

ld_pointer_ushort18:
	ldb 1,1
	popj 17,

st_pointer_ushort18:
	dpb 2,1	; movhi
	popj 17,

st_ret_pointer_ushort18:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	move 1,2
	popj 17,

ld_global_pointer_ushort18:
	ldb 1,ptr_scalar_ushort18
	ldb 6,ptr_array_ushort18
	add 1,6
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

ptr_static_ushort18:
	move 1,[POINT 18,scalar_ushort18,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,array_ushort18+1,35]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,box_ushort18,17]
	jrst scalar_memory_forms

ld_stack_ushort18:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_ushort18:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_ushort18:
	add 17,[3,,3]
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,-2(17)
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	pushj 17,scalar_memory_forms
	movei 1,-1(17)
	tlo 1,222200
	ibp 1
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

update_static_ushort18:
	hlrz 6,scalar_ushort18
	addi 6,(1)
	movem 6,scalar_ushort18
	hrrz 1,6
	popj 17,

update_pointer_ushort18:
	move 4,1
	ldb 1,1
	addi 1,(2)
	dpb 1,4	; movhi
	hrrz 1,1
	popj 17,

sum_array_ushort18:
	setzb 6,2
	caml 6,1
	jrst %L1259
	subi 1,1
%L1260:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,array_ushort18,17]
	jumpe 4,%L1256
%L1255:
	ibp 3
	sojn 4,%L1255	; decrement_and_branch_until_zero
%L1256:
	ldb 3,3
	add 6,3
	addi 2,1
	sojge 1,%L1260	; doloop_end
%L1259:
	move 1,6
	popj 17,

call_with_scalar_ushort18:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,10
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_ushort18:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 14,2
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 15,2
	andi 15,7
	move 4,2
	andi 4,1
	move 13,15
	ash 13,-1	; ashrsi3_pointer
	add 13,[POINT 18,array_ushort18,17]
	jumpe 4,%L1266
%L1265:
	ibp 13
	sojn 4,%L1265	; decrement_and_branch_until_zero
%L1266:
	move 1,12
	pushj 17,st_static_ushort18
	movei 1,1(12)
	pushj 17,st_volatile_ushort18
	movei 1,2(12)
	pushj 17,st_struct_ushort18
	movei 1,3(12)
	pushj 17,st_vstruct_ushort18
	movei 2,4(12)
	move 1,15
	pushj 17,st_array_ushort18
	move 11,14
	andi 11,3
	movei 2,5(12)
	move 1,11
	pushj 17,st_varray_ushort18
	movei 2,6(12)
	move 1,13
	pushj 17,st_pointer_ushort18
	pushj 17,ptr_static_ushort18
	move 1,12
	pushj 17,ptr_stack_ushort18
	pushj 17,ld_static_ushort18
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,12
	pushj 17,st_ret_static_ushort18
	add 10,1
	pushj 17,ld_volatile_ushort18
	add 10,1
	pushj 17,ld_struct_ushort18
	add 10,1
	pushj 17,ld_vstruct_ushort18
	add 10,1
	move 1,15
	pushj 17,ld_array_ushort18
	add 10,1
	addi 14,1
	andi 14,7
	move 1,14
	move 2,12
	pushj 17,st_ret_array_ushort18
	add 10,1
	move 1,11
	pushj 17,ld_varray_ushort18
	add 10,1
	move 1,13
	pushj 17,ld_pointer_ushort18
	add 10,1
	move 1,13
	move 2,12
	pushj 17,st_ret_pointer_ushort18
	add 10,1
	pushj 17,ld_global_pointer_ushort18
	add 10,1
	move 1,12
	pushj 17,ld_stack_ushort18
	add 10,1
	move 1,12
	pushj 17,st_stack_ushort18
	add 10,1
	move 1,12
	pushj 17,update_static_ushort18
	add 10,1
	move 1,13
	move 2,12
	pushj 17,update_pointer_ushort18
	add 10,1
	movei 1,4
	pushj 17,sum_array_ushort18
	add 10,1
	move 1,12
	pushj 17,call_with_scalar_ushort18
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_ushort18:
	ldb 1,1
	popj 17,

unsigned_branch_ushort18:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 3,0
	jumpe 1,%L1268
	tlc 1,400000
	move 6,[-377777777601]
	camle 1,6
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L1268:
	move 1,3
	popj 17,

	.data
	.align	2
ptr_scalar_int32:
	.long	scalar_int32
	.align	2
ptr_array_int32:
	.long	array_int32+3

ld_static_int32:
	move 1,scalar_int32
	popj 17,

st_static_int32:
	movem 1,scalar_int32
	popj 17,

st_ret_static_int32:
	movem 1,scalar_int32
	popj 17,

ld_volatile_int32:
	move 1,vscalar_int32
	popj 17,

st_volatile_int32:
	movem 1,vscalar_int32
	popj 17,

ld_struct_int32:
	move 1,box_int32
	ash 1,-4
	popj 17,

st_struct_int32:
	move 4,1
	lsh 4,4
	movem 4,box_int32
	addi 1,1
	dpb 1,[POINT 32,box_int32+1,31]
	popj 17,

ld_vstruct_int32:
	move 1,vbox_int32
	ash 1,-4
	popj 17,

st_vstruct_int32:
	move 4,1
	lsh 4,4
	movem 4,vbox_int32
	addi 1,1
	dpb 1,[POINT 32,vbox_int32+1,31]
	popj 17,

ld_array_int32:
	move 1,array_int32(1)
	ash 1,-4
	popj 17,

st_array_int32:
	movei 4,array_int32
	jumple 1,%L1286
%L1285:
	ibp 4
	sojg 1,%L1285	; decrement_and_branch_until_zero
%L1286:
	jumpe 1,%L1288
%L1287:
	subi 4,1
	aojl 1,%L1287
%L1288:
	dpb 2,[POINT 32,(4),31]
	popj 17,

st_ret_array_int32:
	movei 3,array_int32
	move 4,1
	jumple 1,%L1292
%L1291:
	ibp 3
	sojg 4,%L1291	; decrement_and_branch_until_zero
%L1292:
	jumpe 4,%L1294
%L1293:
	subi 3,1
	aojl 4,%L1293
%L1294:
	dpb 2,[POINT 32,(3),31]
	move 1,array_int32(1)
	ash 1,-4
	popj 17,

ld_varray_int32:
	move 1,varray_int32(1)
	ash 1,-4
	popj 17,

st_varray_int32:
	movei 4,varray_int32
	jumple 1,%L1299
%L1298:
	ibp 4
	sojg 1,%L1298	; decrement_and_branch_until_zero
%L1299:
	jumpe 1,%L1301
%L1300:
	subi 4,1
	aojl 1,%L1300
%L1301:
	dpb 2,[POINT 32,(4),31]
	popj 17,

ld_pointer_int32:
	move 1,(1)
	popj 17,

st_pointer_int32:
	movem 2,(1)
	popj 17,

st_ret_pointer_int32:
	movem 2,(1)
	move 1,2
	popj 17,

ld_global_pointer_int32:
	move 4,ptr_array_int32
	move 3,ptr_scalar_int32
	move 1,(3)
	add 1,(4)
	popj 17,

ptr_static_int32:
	movei 1,scalar_int32
	pushj 17,scalar_memory_forms
	movei 1,array_int32+3
	pushj 17,scalar_memory_forms
	movei 1,box_int32
	jrst scalar_memory_forms

ld_stack_int32:
	add 17,[1,,1]
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_int32:
	add 17,[1,,1]
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_int32:
	add 17,[4,,4]
	movem 1,(17)
	dpb 1,[POINT 32,-3(17),31]
	addi 1,1
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	dpb 1,[POINT 32,-1(17),31]
	movei 1,(17)
	pushj 17,scalar_memory_forms
	movei 1,-3(17)
	addi 1,1
	pushj 17,scalar_memory_forms
	add 17,[-4,,-4]
	popj 17,

update_static_int32:
	addb 1,scalar_int32
	popj 17,

update_pointer_int32:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

sum_array_int32:
	setzb 2,3
	caml 2,1
	jrst %L1331
	subi 1,1
%L1332:
	move 4,array_int32(3)
	ash 4,-4
	add 2,4
	addi 3,1
	sojge 1,%L1332	; doloop_end
%L1331:
	move 1,2
	popj 17,

call_with_scalar_int32:
	push 17,10
	move 10,1
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_int32:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	move 13,2
	andi 13,7
	xmovei 14,array_int32(13)
	pushj 17,st_static_int32
	move 1,11
	addi 1,1
	pushj 17,st_volatile_int32
	move 1,11
	addi 1,2
	pushj 17,st_struct_int32
	move 1,11
	addi 1,3
	pushj 17,st_vstruct_int32
	move 2,11
	addi 2,4
	move 1,13
	pushj 17,st_array_int32
	move 15,12
	andi 15,3
	move 2,11
	addi 2,5
	move 1,15
	pushj 17,st_varray_int32
	move 2,11
	addi 2,6
	move 1,14
	pushj 17,st_pointer_int32
	pushj 17,ptr_static_int32
	move 1,11
	pushj 17,ptr_stack_int32
	pushj 17,ld_static_int32
	move 10,1
	move 1,11
	pushj 17,st_ret_static_int32
	add 10,1
	pushj 17,ld_volatile_int32
	add 10,1
	pushj 17,ld_struct_int32
	add 10,1
	pushj 17,ld_vstruct_int32
	add 10,1
	move 1,13
	pushj 17,ld_array_int32
	add 10,1
	addi 12,1
	andi 12,7
	move 1,12
	move 2,11
	pushj 17,st_ret_array_int32
	add 10,1
	move 1,15
	pushj 17,ld_varray_int32
	add 10,1
	move 1,14
	pushj 17,ld_pointer_int32
	add 10,1
	move 1,14
	move 2,11
	pushj 17,st_ret_pointer_int32
	add 10,1
	pushj 17,ld_global_pointer_int32
	add 10,1
	move 1,11
	pushj 17,ld_stack_int32
	add 10,1
	move 1,11
	pushj 17,st_stack_int32
	add 10,1
	move 1,11
	pushj 17,update_static_int32
	add 10,1
	move 1,14
	move 2,11
	pushj 17,update_pointer_int32
	add 10,1
	movei 1,4
	pushj 17,sum_array_int32
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_int32
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

sign_branch_int32:
	seto 4,
	jumpl 1,%L1337
	skipe 4,1
	movei 4,1
%L1337:
	move 1,4
	popj 17,

sign_load_static_int32:
	move 1,scalar_int32
	lsh 1,-43
	popj 17,

	.data
	.align	2
ptr_scalar_uint32:
	.long	scalar_uint32
	.align	2
ptr_array_uint32:
	.long	array_uint32+3

ld_static_uint32:
	move 1,scalar_uint32
	popj 17,

st_static_uint32:
	movem 1,scalar_uint32
	popj 17,

st_ret_static_uint32:
	movem 1,scalar_uint32
	popj 17,

ld_volatile_uint32:
	move 1,vscalar_uint32
	popj 17,

st_volatile_uint32:
	movem 1,vscalar_uint32
	popj 17,

ld_struct_uint32:
	move 1,box_uint32
	lsh 1,-4
	popj 17,

st_struct_uint32:
	move 4,1
	lsh 4,4
	movem 4,box_uint32
	addi 1,1
	dpb 1,[POINT 32,box_uint32+1,31]
	popj 17,

ld_vstruct_uint32:
	move 1,vbox_uint32
	lsh 1,-4
	popj 17,

st_vstruct_uint32:
	move 4,1
	lsh 4,4
	movem 4,vbox_uint32
	addi 1,1
	dpb 1,[POINT 32,vbox_uint32+1,31]
	popj 17,

ld_array_uint32:
	move 1,array_uint32(1)
	lsh 1,-4
	popj 17,

st_array_uint32:
	movei 4,array_uint32
	jumple 1,%L1356
%L1355:
	ibp 4
	sojg 1,%L1355	; decrement_and_branch_until_zero
%L1356:
	jumpe 1,%L1358
%L1357:
	subi 4,1
	aojl 1,%L1357
%L1358:
	dpb 2,[POINT 32,(4),31]
	popj 17,

st_ret_array_uint32:
	movei 3,array_uint32
	move 4,1
	jumple 1,%L1362
%L1361:
	ibp 3
	sojg 4,%L1361	; decrement_and_branch_until_zero
%L1362:
	jumpe 4,%L1364
%L1363:
	subi 3,1
	aojl 4,%L1363
%L1364:
	dpb 2,[POINT 32,(3),31]
	move 1,array_uint32(1)
	lsh 1,-4
	popj 17,

ld_varray_uint32:
	move 1,varray_uint32(1)
	lsh 1,-4
	popj 17,

st_varray_uint32:
	movei 4,varray_uint32
	jumple 1,%L1369
%L1368:
	ibp 4
	sojg 1,%L1368	; decrement_and_branch_until_zero
%L1369:
	jumpe 1,%L1371
%L1370:
	subi 4,1
	aojl 1,%L1370
%L1371:
	dpb 2,[POINT 32,(4),31]
	popj 17,

ld_pointer_uint32:
	move 1,(1)
	popj 17,

st_pointer_uint32:
	movem 2,(1)
	popj 17,

st_ret_pointer_uint32:
	movem 2,(1)
	move 1,2
	popj 17,

ld_global_pointer_uint32:
	move 4,ptr_array_uint32
	move 3,ptr_scalar_uint32
	move 1,(3)
	add 1,(4)
	popj 17,

ptr_static_uint32:
	movei 1,scalar_uint32
	pushj 17,scalar_memory_forms
	movei 1,array_uint32+3
	pushj 17,scalar_memory_forms
	movei 1,box_uint32
	jrst scalar_memory_forms

ld_stack_uint32:
	add 17,[1,,1]
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

st_stack_uint32:
	add 17,[1,,1]
	movem 1,(17)
	move 1,(17)
	add 17,[-1,,-1]
	popj 17,

ptr_stack_uint32:
	add 17,[4,,4]
	movem 1,(17)
	dpb 1,[POINT 32,-3(17),31]
	addi 1,1
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	dpb 1,[POINT 32,-1(17),31]
	movei 1,(17)
	pushj 17,scalar_memory_forms
	movei 1,-3(17)
	addi 1,1
	pushj 17,scalar_memory_forms
	add 17,[-4,,-4]
	popj 17,

update_static_uint32:
	addb 1,scalar_uint32
	popj 17,

update_pointer_uint32:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

sum_array_uint32:
	setzb 2,3
	caml 2,1
	jrst %L1401
	subi 1,1
%L1402:
	move 4,array_uint32(3)
	lsh 4,-4
	add 2,4
	addi 3,1
	sojge 1,%L1402	; doloop_end
%L1401:
	move 1,2
	popj 17,

call_with_scalar_uint32:
	push 17,10
	move 10,1
	pushj 17,use_int
	move 1,10
	pop 17,10
	popj 17,

use_scalar_uint32:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	move 13,2
	andi 13,7
	xmovei 14,array_uint32(13)
	pushj 17,st_static_uint32
	move 1,11
	addi 1,1
	pushj 17,st_volatile_uint32
	move 1,11
	addi 1,2
	pushj 17,st_struct_uint32
	move 1,11
	addi 1,3
	pushj 17,st_vstruct_uint32
	move 2,11
	addi 2,4
	move 1,13
	pushj 17,st_array_uint32
	move 15,12
	andi 15,3
	move 2,11
	addi 2,5
	move 1,15
	pushj 17,st_varray_uint32
	move 2,11
	addi 2,6
	move 1,14
	pushj 17,st_pointer_uint32
	pushj 17,ptr_static_uint32
	move 1,11
	pushj 17,ptr_stack_uint32
	pushj 17,ld_static_uint32
	move 10,1
	move 1,11
	pushj 17,st_ret_static_uint32
	add 10,1
	pushj 17,ld_volatile_uint32
	add 10,1
	pushj 17,ld_struct_uint32
	add 10,1
	pushj 17,ld_vstruct_uint32
	add 10,1
	move 1,13
	pushj 17,ld_array_uint32
	add 10,1
	addi 12,1
	andi 12,7
	move 1,12
	move 2,11
	pushj 17,st_ret_array_uint32
	add 10,1
	move 1,15
	pushj 17,ld_varray_uint32
	add 10,1
	move 1,14
	pushj 17,ld_pointer_uint32
	add 10,1
	move 1,14
	move 2,11
	pushj 17,st_ret_pointer_uint32
	add 10,1
	pushj 17,ld_global_pointer_uint32
	add 10,1
	move 1,11
	pushj 17,ld_stack_uint32
	add 10,1
	move 1,11
	pushj 17,st_stack_uint32
	add 10,1
	move 1,11
	pushj 17,update_static_uint32
	add 10,1
	move 1,14
	move 2,11
	pushj 17,update_pointer_uint32
	add 10,1
	movei 1,4
	pushj 17,sum_array_uint32
	add 10,1
	move 1,11
	pushj 17,call_with_scalar_uint32
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

zero_load_uint32:
	move 1,(1)
	popj 17,

unsigned_branch_uint32:
	movei 3,0
	jumpe 1,%L1408
	skipl 3,1
	cail 3,200
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L1408:
	move 1,3
	popj 17,

	.globl	use_scalars
use_scalars:
	add 17,[10,,10]
	movem 16,-7(17)
	movei 0,-6(17)
	hrli 0,10
	blt 0,-1(17)
	move 13,1
	move 12,2
	move 14,1
	lsh 14,33
	ash 14,-33
	move 1,14
	pushj 17,use_scalar_schar
	move 11,1
	move 15,13
	andi 15,777	; zero_extendqisi2
	move 1,15
	move 2,12
	pushj 17,use_scalar_uchar
	add 11,1
	move 1,14
	move 2,12
	pushj 17,use_scalar_sQint
	add 11,1
	move 1,15
	move 2,12
	pushj 17,use_scalar_uQint
	add 11,1
	hrre 6,13	; extendhisi2
	movem 6,(17)
	move 1,6
	move 2,12
	pushj 17,use_scalar_Hint
	add 11,1
	move 16,13
	hrrzi 16,(16)	; zero_extendhisi2
	move 1,16
	move 2,12
	pushj 17,use_scalar_uHint
	add 11,1
	move 10,13
	move 1,13
	lsh 1,36
	ash 1,-36
	move 2,12
	pushj 17,use_scalar_char6
	add 11,1
	move 1,13
	andi 1,77
	move 2,12
	pushj 17,use_scalar_uchar6
	add 11,1
	move 1,13
	lsh 1,35
	ash 1,-35
	move 2,12
	pushj 17,use_scalar_char7
	add 11,1
	move 1,13
	andi 1,177
	move 2,12
	pushj 17,use_scalar_uchar7
	add 11,1
	move 1,13
	lsh 1,34
	ash 1,-34
	move 2,12
	pushj 17,use_scalar_char8
	add 11,1
	andi 10,377
	move 1,10
	move 2,12
	pushj 17,use_scalar_uchar8
	add 11,1
	move 1,14
	move 2,12
	pushj 17,use_scalar_char9
	add 11,1
	move 1,15
	move 2,12
	pushj 17,use_scalar_uchar9
	add 11,1
	move 10,13
	move 1,13
	lsh 1,24
	ash 1,-24
	move 2,12
	pushj 17,use_scalar_short16
	add 11,1
	andi 10,177777
	move 1,10
	move 2,12
	pushj 17,use_scalar_ushort16
	add 11,1
	move 1,(17)
	move 2,12
	pushj 17,use_scalar_short18
	add 11,1
	move 1,16
	move 2,12
	pushj 17,use_scalar_ushort18
	add 11,1
	move 1,13
	move 2,12
	pushj 17,use_scalar_int32
	add 11,1
	move 1,13
	move 2,12
	pushj 17,use_scalar_uint32
	add 11,1
	move 1,11
	move 16,-7(17)
	movei 0,10
	hrli 0,-6(17)
	blt 0,15
	add 17,[-10,,-10]
	popj 17,

	.globl	uscbra
uscbra:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,1
	lsh 13,33
	ash 13,-33
	move 1,13
	pushj 17,sign_branch_schar
	move 10,1
	move 14,12
	andi 14,777	; zero_extendqisi2
	move 1,14
	pushj 17,unsigned_branch_uchar
	add 10,1
	move 1,13
	pushj 17,sign_branch_sQint
	add 10,1
	move 1,14
	pushj 17,unsigned_branch_uQint
	add 10,1
	hrre 16,12	; extendhisi2
	move 1,16
	pushj 17,sign_branch_Hint
	add 10,1
	move 15,12
	hrrzi 15,(15)	; zero_extendhisi2
	move 1,15
	pushj 17,unsigned_branch_uHint
	add 10,1
	move 11,12
	move 1,12
	lsh 1,36
	ash 1,-36
	pushj 17,sign_branch_char6
	add 10,1
	move 1,12
	andi 1,77
	pushj 17,unsigned_branch_uchar6
	add 10,1
	move 1,12
	lsh 1,35
	ash 1,-35
	pushj 17,sign_branch_char7
	add 10,1
	move 1,12
	andi 1,177
	pushj 17,unsigned_branch_uchar7
	add 10,1
	move 1,12
	lsh 1,34
	ash 1,-34
	pushj 17,sign_branch_char8
	add 10,1
	andi 11,377
	move 1,11
	pushj 17,unsigned_branch_uchar8
	add 10,1
	move 1,13
	pushj 17,sign_branch_char9
	add 10,1
	move 1,14
	pushj 17,unsigned_branch_uchar9
	add 10,1
	move 11,12
	move 1,12
	lsh 1,24
	ash 1,-24
	pushj 17,sign_branch_short16
	add 10,1
	andi 11,177777
	move 1,11
	pushj 17,unsigned_branch_ushort16
	add 10,1
	move 1,16
	pushj 17,sign_branch_short18
	add 10,1
	move 1,15
	pushj 17,unsigned_branch_ushort18
	add 10,1
	move 1,12
	pushj 17,sign_branch_int32
	add 10,1
	move 1,12
	pushj 17,unsigned_branch_uint32
	add 10,1
	pushj 17,sign_load_static_schar
	add 10,1
	pushj 17,sign_load_static_sQint
	add 10,1
	pushj 17,sign_load_static_Hint
	add 10,1
	pushj 17,sign_load_static_char6
	add 10,1
	pushj 17,sign_load_static_char7
	add 10,1
	pushj 17,sign_load_static_char8
	add 10,1
	pushj 17,sign_load_static_char9
	add 10,1
	pushj 17,sign_load_static_short16
	add 10,1
	pushj 17,sign_load_static_short18
	add 10,1
	pushj 17,sign_load_static_int32
	add 10,1
	move 1,[POINT 18,scalar_uchar,35]
	pushj 17,zero_load_uchar
	add 10,1
	move 1,[POINT 18,scalar_uQint,35]
	pushj 17,zero_load_uQint
	add 10,1
	move 1,[POINT 18,scalar_uHint,35]
	pushj 17,zero_load_uHint
	add 10,1
	move 1,[POINT 18,scalar_uchar6,35]
	pushj 17,zero_load_uchar6
	add 10,1
	move 1,[POINT 18,scalar_uchar7,35]
	pushj 17,zero_load_uchar7
	add 10,1
	move 1,[POINT 18,scalar_uchar8,35]
	pushj 17,zero_load_uchar8
	add 10,1
	move 1,[POINT 18,scalar_uchar9,35]
	pushj 17,zero_load_uchar9
	add 10,1
	move 1,[POINT 18,scalar_ushort16,35]
	pushj 17,zero_load_ushort16
	add 10,1
	move 1,[POINT 18,scalar_ushort18,35]
	pushj 17,zero_load_ushort18
	add 10,1
	movei 1,scalar_uint32
	pushj 17,zero_load_uint32
	add 10,1
	move 1,10
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

	.bss
scalar_schar:
	.space	4
vscalar_schar:
	.space	4
array_schar:
	.space	8
varray_schar:
	.space	4
box_schar:
	.space	4
vbox_schar:
	.space	4
scalar_uchar:
	.space	4
vscalar_uchar:
	.space	4
array_uchar:
	.space	8
varray_uchar:
	.space	4
box_uchar:
	.space	4
vbox_uchar:
	.space	4
scalar_sQint:
	.space	4
vscalar_sQint:
	.space	4
array_sQint:
	.space	8
varray_sQint:
	.space	4
box_sQint:
	.space	4
vbox_sQint:
	.space	4
scalar_uQint:
	.space	4
vscalar_uQint:
	.space	4
array_uQint:
	.space	8
varray_uQint:
	.space	4
box_uQint:
	.space	4
vbox_uQint:
	.space	4
scalar_Hint:
	.space	4
vscalar_Hint:
	.space	4
array_Hint:
	.space	16
varray_Hint:
	.space	8
box_Hint:
	.space	4
vbox_Hint:
	.space	4
scalar_uHint:
	.space	4
vscalar_uHint:
	.space	4
array_uHint:
	.space	16
varray_uHint:
	.space	8
box_uHint:
	.space	4
vbox_uHint:
	.space	4
scalar_char6:
	.space	4
vscalar_char6:
	.space	4
array_char6:
	.space	8
varray_char6:
	.space	4
box_char6:
	.space	4
vbox_char6:
	.space	4
scalar_uchar6:
	.space	4
vscalar_uchar6:
	.space	4
array_uchar6:
	.space	8
varray_uchar6:
	.space	4
box_uchar6:
	.space	4
vbox_uchar6:
	.space	4
scalar_char7:
	.space	4
vscalar_char7:
	.space	4
array_char7:
	.space	8
varray_char7:
	.space	4
box_char7:
	.space	4
vbox_char7:
	.space	4
scalar_uchar7:
	.space	4
vscalar_uchar7:
	.space	4
array_uchar7:
	.space	8
varray_uchar7:
	.space	4
box_uchar7:
	.space	4
vbox_uchar7:
	.space	4
scalar_char8:
	.space	4
vscalar_char8:
	.space	4
array_char8:
	.space	8
varray_char8:
	.space	4
box_char8:
	.space	4
vbox_char8:
	.space	4
scalar_uchar8:
	.space	4
vscalar_uchar8:
	.space	4
array_uchar8:
	.space	8
varray_uchar8:
	.space	4
box_uchar8:
	.space	4
vbox_uchar8:
	.space	4
scalar_char9:
	.space	4
vscalar_char9:
	.space	4
array_char9:
	.space	8
varray_char9:
	.space	4
box_char9:
	.space	4
vbox_char9:
	.space	4
scalar_uchar9:
	.space	4
vscalar_uchar9:
	.space	4
array_uchar9:
	.space	8
varray_uchar9:
	.space	4
box_uchar9:
	.space	4
vbox_uchar9:
	.space	4
scalar_short16:
	.space	4
vscalar_short16:
	.space	4
array_short16:
	.space	16
varray_short16:
	.space	8
box_short16:
	.space	4
vbox_short16:
	.space	4
scalar_ushort16:
	.space	4
vscalar_ushort16:
	.space	4
array_ushort16:
	.space	16
varray_ushort16:
	.space	8
box_ushort16:
	.space	4
vbox_ushort16:
	.space	4
scalar_short18:
	.space	4
vscalar_short18:
	.space	4
array_short18:
	.space	16
varray_short18:
	.space	8
box_short18:
	.space	4
vbox_short18:
	.space	4
scalar_ushort18:
	.space	4
vscalar_ushort18:
	.space	4
array_ushort18:
	.space	16
varray_ushort18:
	.space	8
box_ushort18:
	.space	4
vbox_ushort18:
	.space	4
scalar_int32:
	.space	4
vscalar_int32:
	.space	4
array_int32:
	.space	32
varray_int32:
	.space	16
box_int32:
	.space	8
vbox_int32:
	.space	8
scalar_uint32:
	.space	4
vscalar_uint32:
	.space	4
array_uint32:
	.space	32
varray_uint32:
	.space	16
box_uint32:
	.space	8
vbox_uint32:
	.space	8
