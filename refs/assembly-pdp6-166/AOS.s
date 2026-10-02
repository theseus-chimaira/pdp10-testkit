
aos_plain:
	aos (1)
	popj 17,

aos_post_plain:
	aos (1)
	popj 17,

aos_value_pre:
	aos 1,(1)
	popj 17,

aos_value_post:
	move 4,(1)
	aos (1)
	move 1,4
	popj 17,

aos_value_plus_arg:
	aos (1)
	add 2,(1)
	move 1,2
	popj 17,

aos_value_twice:
	aos 1,(1)
	lsh 1,1
	popj 17,

aos_local_addr:
	addi 1,1
	popj 17,

aos_through_arg:
	aos 1,(1)
	add 1,(2)
	popj 17,

aos_volatile_plain:
	move 4,(1)
	addi 4,1
	movem 4,(1)
	popj 17,

aos_volatile_value:
	move 4,(1)
	addi 4,1
	movem 4,(1)
	move 1,(1)
	popj 17,

aos_l:
	aosge (1)
	jrst f
	popj 17,

aos_l_inv:
	aosl (1)
	jrst f
	popj 17,

aos_l_value:
	push 17,10
	aosl 10,(1)
	jrst %L16
	pushj 17,f
	add 10,1
%L16:
	move 1,10
	pop 17,10
	popj 17,

aos_l_value_inv:
	push 17,10
	aosge 10,(1)
	jrst %L18
	pushj 17,f
	add 10,1
%L18:
	move 1,10
	pop 17,10
	popj 17,

aos_l_loop:
	move 6,1
	move 1,(1)
	move 3,1
	movn 4,1
	jumpl 1,%L26
	movei 4,1
%L26:
	subi 4,1
%L25:
	add 2,3
	aos 1,3
	sojge 4,%L25	; doloop_end
	movem 1,(6)
	add 1,2
	popj 17,

aos_e:
	aosn (1)
	jrst f
	popj 17,

aos_e_inv:
	aose (1)
	jrst f
	popj 17,

aos_e_value:
	aosn 1,(1)
	pushj 17,f
	popj 17,

aos_e_value_inv:
	push 17,10
	aosn 10,(1)
	jrst %L34
	pushj 17,f
	add 10,1
%L34:
	move 1,10
	pop 17,10
	popj 17,

aos_e_loop:
	move 3,1
	move 4,(1)
%L36:
	add 2,4
	aos 1,4
	jumpe 1,%L36
	movem 1,(3)
	add 1,2
	popj 17,

aos_le:
	aosg (1)
	jrst f
	popj 17,

aos_le_inv:
	aosle (1)
	jrst f
	popj 17,

aos_le_value:
	push 17,10
	aosle 10,(1)
	jrst %L46
	pushj 17,f
	add 10,1
%L46:
	move 1,10
	pop 17,10
	popj 17,

aos_le_value_inv:
	push 17,10
	aosg 10,(1)
	jrst %L48
	pushj 17,f
	add 10,1
%L48:
	move 1,10
	pop 17,10
	popj 17,

aos_le_loop:
	move 6,1
	move 1,(1)
	move 3,1
	movei 4,1
	sub 4,1
	cail 1,1
	movei 4,1
	subi 4,1
%L55:
	add 2,3
	aos 1,3
	sojge 4,%L55	; doloop_end
	movem 1,(6)
	add 1,2
	popj 17,

aos_ge:
	aosl (1)
	jrst f
	popj 17,

aos_ge_inv:
	aosge (1)
	jrst f
	popj 17,

aos_ge_value:
	push 17,10
	aosge 10,(1)
	jrst %L62
	pushj 17,f
	add 10,1
%L62:
	move 1,10
	pop 17,10
	popj 17,

aos_ge_value_inv:
	push 17,10
	aosl 10,(1)
	jrst %L64
	pushj 17,f
	add 10,1
%L64:
	move 1,10
	pop 17,10
	popj 17,

aos_ge_loop:
	move 3,1
	move 4,(1)
%L66:
	add 2,4
	aos 1,4
	jumpge 1,%L66
	movem 1,(3)
	add 1,2
	popj 17,

aos_n:
	aose (1)
	jrst f
	popj 17,

aos_n_inv:
	aosn (1)
	jrst f
	popj 17,

aos_n_value:
	push 17,10
	aosn 10,(1)
	jrst %L76
	pushj 17,f
	add 10,1
%L76:
	move 1,10
	pop 17,10
	popj 17,

aos_n_value_inv:
	aosn 1,(1)
	pushj 17,f
	popj 17,

aos_n_loop:
	move 6,1
	move 1,(1)
	move 3,1
	movn 4,1
	jumpn 1,%L86
	movei 4,1
%L86:
	subi 4,1
%L85:
	add 2,3
	aos 1,3
	sojge 4,%L85	; doloop_end
	movem 1,(6)
	add 1,2
	popj 17,

aos_g:
	aosle (1)
	jrst f
	popj 17,

aos_g_inv:
	aosg (1)
	jrst f
	popj 17,

aos_g_value:
	push 17,10
	aosg 10,(1)
	jrst %L92
	pushj 17,f
	add 10,1
%L92:
	move 1,10
	pop 17,10
	popj 17,

aos_g_value_inv:
	push 17,10
	aosle 10,(1)
	jrst %L94
	pushj 17,f
	add 10,1
%L94:
	move 1,10
	pop 17,10
	popj 17,

aos_g_loop:
	move 3,1
	move 4,(1)
%L96:
	add 2,4
	aos 1,4
	jumpg 1,%L96
	movem 1,(3)
	add 1,2
	popj 17,

aos_call_pressure:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	move 13,3
	aos 10,(1)
	pushj 17,clobber
	add 10,12
	add 10,13
	add 10,(11)
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

aos_branch_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	aosg 1,(1)
	jrst %L103
	pushj 17,clobber
	move 1,(10)
%L103:
	add 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

aos_array_elem:
	andi 2,7
	add 1,2
	aos 1,(1)
	popj 17,

aos_array_elem_void:
	andi 2,7
	add 1,2
	aos (1)
	popj 17,

aos_struct_member:
	move 4,1
	move 1,1(1)
	move 6,1
	addi 6,1
	movem 6,1(4)
	move 1,6
	popj 17,

aos_struct_member_void:
	aos 2(1)
	popj 17,

aos_nested:
%L111:
	aos (2)
	add 3,(2)
	aose (1)
	jrst %L111
	add 3,(2)
	move 1,3
	popj 17,

aos_edge_minus_one:
	setzb 1,(1)
	popj 17,

aos_edge_zero:
	movei 6,1
	movem 6,(1)
	movei 1,1
	popj 17,

aos_edge_sign:
	movsi 6,400000
	movem 6,(1)
	movsi 1,400000
	popj 17,

	.comm	p, 4
