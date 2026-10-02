
fp_one:
	addi 1,1
	popj 17,

fp_two:
	addi 1,2
	popj 17,

fp_three:
	addi 1,3
	popj 17,

fp_neg:
	movn 1,1
	popj 17,

fp_not:
	setca 1,
	popj 17,

ufp_one:
	addi 1,1
	popj 17,

ufp_flip:
	xori 1,77
	popj 17,

bin_add:
	add 1,2
	popj 17,

bin_sub:
	sub 1,2
	popj 17,

bin_mul_small:
	imul 1,2
	popj 17,

cb_inc:
	aos (1)
	popj 17,

cb_neg:
	movns (1)
	popj 17,

q_inc:
	addi 1,1
	lsh 1,33
	ash 1,-33
	popj 17,

q_neg:
	movn 1,1
	lsh 1,33
	ash 1,-33
	popj 17,

uq_inc:
	addi 1,1
	andi 1,777
	popj 17,

h_inc:
	addi 1,1
	hrre 1,1
	popj 17,

h_neg:
	movni 1,(1)
	hrre 1,1	; extendhisi2
	popj 17,

uh_inc:
	movei 1,1(1)
	popj 17,

c_inc:
	addi 1,1
	andi 1,777
	popj 17,

uc_inc:
	addi 1,1
	andi 1,777
	popj 17,

	.data
	.align	2
g_ifn:
	.long	fp_one
	.align	2
g_ifn2:
	.long	fp_two
	.align	2
g_ifn_table:
	.long	fp_one
	.long	fp_two
	.long	fp_three
	.long	fp_neg
	.long	fp_not
	.align	2
g_ufn_table:
	.long	ufp_one
	.long	ufp_flip
	.align	2
g_bin_table:
	.long	bin_add
	.long	bin_sub
	.long	bin_mul_small
	.align	2
g_cb_table:
	.long	cb_inc
	.long	cb_neg
	.align	2
g_q_table:
	.long	q_inc
	.long	q_neg
	.align	2
g_uq_table:
	.long	uq_inc
	.align	2
g_h_table:
	.long	h_inc
	.long	h_neg
	.align	2
g_uh_table:
	.long	uh_inc
	.align	2
g_c_table:
	.long	c_inc
	.align	2
g_uc_table:
	.long	uc_inc
	.align	2
g_slot:
	.long	fp_two
	.long	10
	.align	2
g_pair:
	.long	fp_one
	.long	fp_neg
	.align	2
g_slots:
	.long	fp_one
	.long	1
	.long	fp_two
	.long	2
	.long	fp_neg
	.long	3
	.align	2
g_table_slot:
	.long	fp_one
	.long	fp_two
	.long	fp_neg
	.long	1
	.long	2
	.long	3
	.align	2
g_bin_slot:
	.long	bin_add
	.long	4
	.long	5
	.align	2
g_cb_slot:
	.long	cb_inc
	.long	7

call_fp_arg:
	move 4,1
	move 1,2
	pushj 17,(4)
	popj 17,

call_fp_global:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,@g_ifn
	move 10,1
	move 1,11
	pushj 17,@g_ifn2
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

call_fp_cond:
	movei 4,fp_one
	jumpn 1,%L59
	movei 4,fp_two
%L59:
	pushj 17,(4)
	popj 17,

choose_fp_cond:
	movei 4,fp_neg
	jumpl 1,%L64
	movei 4,fp_one
	jumpe 1,%L64
	movei 4,fp_two
%L64:
	move 1,4
	popj 17,

call_fp_returned:
	push 17,10
	move 10,2
	pushj 17,choose_fp_cond
	move 4,1
	move 1,10
	pushj 17,(4)
	pop 17,10
	popj 17,

call_fp_table_local:
	add 17,[4,,4]
	move 4,1
	movei 6,fp_one
	movem 6,-3(17)
	movei 6,fp_two
	movem 6,-2(17)
	movei 6,fp_three
	movem 6,-1(17)
	movei 6,fp_neg
	movem 6,(17)
	andi 4,3
	movei 6,-3(17)
	add 4,6
	move 1,2
	pushj 17,@(4)
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
fp_table%0:
	.long	fp_one
	.long	fp_two
	.long	fp_three
	.long	fp_not

call_fp_table_static:
	move 4,1
	andi 4,3
	move 1,2
	pushj 17,@fp_table%0(4)
	popj 17,

call_fp_table_global:
	move 6,1
	move 4,[314631463147]
	mul 4,1
	ashc 4,-44
	move 3,5
	ash 3,-1
	move 4,1
	ash 4,-43
	sub 3,4
	move 4,3
	lsh 4,2
	add 4,3
	sub 6,4
	move 1,2
	pushj 17,@g_ifn_table(6)
	popj 17,

call_fp_struct:
	move 4,1
	add 2,1(1)
	move 1,2
	pushj 17,@(4)
	popj 17,

call_fp_global_struct:
	add 1,g_slot+1
	pushj 17,@g_slot
	popj 17,

call_fp_struct_array:
	move 6,1
	move 4,[252525252526]
	mul 4,1
	ashc 4,-44
	move 3,1
	ash 3,-43
	move 7,5
	sub 7,3
	move 4,7
	lsh 4,1
	add 4,7
	sub 6,4
	lsh 6,1
	add 2,g_slots+1(6)
	move 1,2
	pushj 17,@g_slots(6)
	popj 17,

call_fp_struct_table:
	move 6,1
	move 4,[252525252526]
	mul 4,1
	ashc 4,-44
	move 3,1
	ash 3,-43
	move 7,5
	sub 7,3
	move 4,7
	lsh 4,1
	add 4,7
	sub 6,4
	add 2,g_table_slot+3(6)
	move 1,2
	pushj 17,@g_table_slot(6)
	popj 17,

call_fp_pair:
	jumpe 1,%L97
	move 4,g_pair
%L98:
	move 1,2
	pushj 17,(4)
	popj 17,
%L97:
	move 4,g_pair+1
	jrst %L98

call_fp_pointer:
	move 4,1
	move 1,2
	pushj 17,@(4)
	popj 17,

store_fp_pointer:
	move 3,1
	move 1,2
	movei 4,fp_neg
	jumpn 2,%L103
	movei 4,fp_one
%L103:
	movem 4,(3)
	pushj 17,(4)
	popj 17,

call_fp_volatile:
	movem 1,v_ifn
	move 4,v_ifn
	move 1,2
	pushj 17,(4)
	popj 17,

compare_fp:
	move 4,1
	move 1,2
	camn 4,[fp_one]
	jrst %L116
	camn 4,[fp_neg]
	jrst %L113
	pushj 17,(4)
	addi 1,2
%L109:
	popj 17,
%L113:
	pushj 17,fp_neg
	addi 1,3
	popj 17,
%L116:
	pushj 17,fp_one
	aoja 1,%L109

call_bin_arg:
	move 4,1
	move 1,2
	move 2,3
	pushj 17,(4)
	popj 17,

call_bin_table:
	move 6,1
	move 4,[252525252526]
	mul 4,1
	ashc 4,-44
	ash 1,-43
	move 7,5
	sub 7,1
	move 4,7
	lsh 4,1
	add 4,7
	sub 6,4
	move 1,2
	move 2,3
	pushj 17,@g_bin_table(6)
	popj 17,

call_bin_struct:
	move 4,1
	move 1,1(1)
	move 2,2(4)
	pushj 17,@(4)
	popj 17,

call_bin_volatile:
	movem 1,v_binfn
	move 4,v_binfn
	move 1,2
	move 2,3
	pushj 17,(4)
	popj 17,

call_unsigned_fp:
	move 4,1
	andi 4,1
	move 1,2
	pushj 17,@g_ufn_table(4)
	popj 17,

call_callback:
	add 17,[1,,1]
	move 4,1
	movem 2,(17)
	movei 1,(17)
	pushj 17,(4)
	movei 4,(17)
	move 1,(4)
	add 17,[-1,,-1]
	popj 17,

call_callback_table:
	add 17,[1,,1]
	move 4,1
	movem 2,(17)
	andi 4,1
	movei 1,(17)
	pushj 17,@@g_cb_table(4)
	movei 4,(17)
	move 1,(4)
	add 17,[-1,,-1]
	popj 17,

call_callback_struct:
	add 17,[1,,1]
	move 4,1
	move 6,1(1)
	movem 6,(17)
	movei 1,(17)
	pushj 17,@@(4)
	movei 4,(17)
	move 1,(4)
	add 17,[-1,,-1]
	popj 17,

call_callback_volatile:
	add 17,[1,,1]
	movem 2,(17)
	movem 1,v_vfn
	move 4,v_vfn
	movei 1,(17)
	pushj 17,(4)
	movei 4,(17)
	move 1,(4)
	add 17,[-1,,-1]
	popj 17,

call_small_return:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 11,2
	andi 12,1
	move 1,2
	lsh 1,33
	ash 1,-33
	pushj 17,@g_q_table(12)
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 14,11
	andi 14,777	; zero_extendqisi2
	move 1,14
	pushj 17,@g_uq_table
	move 15,1
	andi 15,777	; zero_extendqisi2
	hrre 1,11	; extendhisi2
	pushj 17,@g_h_table(12)
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	hrrzi 11,(11)	; zero_extendhisi2
	move 1,11
	pushj 17,@g_uh_table
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,14
	pushj 17,@g_c_table
	move 11,1
	andi 11,777	; zero_extendqisi2
	move 1,14
	pushj 17,@g_uc_table
	lsh 10,33
	ash 10,-33
	add 10,15
	hrre 12,12	; extendhisi2
	add 10,12
	add 10,13
	add 10,11
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

call_local_struct:
	movei 3,fp_three
	jumpn 1,%L134
	movei 3,fp_not
%L134:
	move 5,1
	addi 5,4
	jumpn 1,%L142
	movei 3,fp_two
%L142:
	add 2,5
	move 1,2
	pushj 17,(3)
	popj 17,

use_function_pointer:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,-1(17)
	move 12,1
	move 11,2
	movei 6,fp_two
	movem 6,(17)
	move 1,6
	pushj 17,call_fp_arg
	move 10,1
	move 1,11
	pushj 17,call_fp_global
	add 10,1
	move 1,11
	pushj 17,call_fp_cond
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_fp_returned
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_fp_table_local
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_fp_table_static
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_fp_table_global
	add 10,1
	movei 1,g_slot
	move 2,11
	pushj 17,call_fp_struct
	add 10,1
	move 1,11
	pushj 17,call_fp_global_struct
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_fp_struct_array
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_fp_struct_table
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_fp_pair
	add 10,1
	movei 1,(17)
	move 2,11
	pushj 17,call_fp_pointer
	add 10,1
	move 1,17
	move 2,11
	pushj 17,store_fp_pointer
	add 10,1
	movei 13,(17)
	move 1,(13)
	move 2,11
	pushj 17,call_fp_volatile
	add 10,1
	move 1,(13)
	move 2,11
	pushj 17,compare_fp
	add 10,1
	movei 1,bin_add
	move 2,11
	move 3,12
	pushj 17,call_bin_arg
	add 10,1
	move 1,12
	move 2,11
	move 3,12
	pushj 17,call_bin_table
	add 10,1
	movei 1,g_bin_slot
	pushj 17,call_bin_struct
	add 10,1
	movei 1,bin_sub
	move 2,11
	move 3,12
	pushj 17,call_bin_volatile
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_unsigned_fp
	add 10,1
	movei 1,cb_inc
	move 2,11
	pushj 17,call_callback
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_callback_table
	add 10,1
	movei 1,g_cb_slot
	pushj 17,call_callback_struct
	add 10,1
	movei 1,cb_neg
	move 2,11
	pushj 17,call_callback_volatile
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_small_return
	add 10,1
	move 1,12
	move 2,11
	pushj 17,call_local_struct
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-4(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

	.bss
v_ifn:
	.space	4
v_binfn:
	.space	4
v_vfn:
	.space	4
