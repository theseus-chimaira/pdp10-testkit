
subsi3:
	sub 1,2
	popj 17,

sub_reg_reg:
	sub 1,2
	popj 17,

usub_reg_reg:
	sub 1,2
	popj 17,

sub_local:
	sub 1,2
	popj 17,

sub_reuse_left:
	sub 1,2
	popj 17,

sub_reuse_right:
	sub 1,2
	popj 17,

sub_chain:
	sub 1,2
	sub 1,3
	popj 17,

sub_from_add:
	add 1,2
	sub 1,3
	popj 17,

sub_from_call:
	push 17,10
	move 10,1
	pushj 17,f
	sub 1,10
	pop 17,10
	popj 17,

sub_call_rhs:
	push 17,10
	move 10,1
	pushj 17,f
	sub 10,1
	move 1,10
	pop 17,10
	popj 17,

usub_from_call:
	push 17,10
	move 10,1
	pushj 17,uf
	sub 1,10
	pop 17,10
	popj 17,

sub_reg_mem:
	sub 1,(2)
	popj 17,

sub_mem_reg:
	move 1,(1)
	sub 1,2
	popj 17,

sub_mem_mem:
	move 1,(1)
	sub 1,(2)
	popj 17,

sub_volatile_mem:
	move 4,(2)
	sub 1,4
	popj 17,

sub_mem_volatile:
	move 1,(1)
	sub 1,2
	popj 17,

sub_global_reg:
	move 4,1
	move 1,subsi3_ga
	sub 1,4
	popj 17,

sub_reg_global:
	sub 1,subsi3_gb
	popj 17,

sub_volatile_global:
	move 4,subsi3_vga
	sub 1,4
	popj 17,

usub_global_reg:
	move 4,1
	move 1,usubsi3_ga
	sub 1,4
	popj 17,

usub_reg_global:
	sub 1,usubsi3_gb
	popj 17,

usub_volatile_global:
	move 4,usubsi3_vga
	sub 1,4
	popj 17,

sub_array_reg:
	andi 2,17
	add 1,2
	move 1,(1)
	sub 1,3
	popj 17,

sub_reg_array:
	andi 3,17
	add 2,3
	sub 1,(2)
	popj 17,

sub_global_array:
	andi 1,17
	move 1,subsi3_buf(1)
	sub 1,2
	popj 17,

sub_reg_global_array:
	andi 2,17
	sub 1,subsi3_buf(2)
	popj 17,

usub_array_reg:
	andi 2,17
	add 1,2
	move 1,(1)
	sub 1,3
	popj 17,

usub_reg_array:
	andi 3,17
	add 2,3
	sub 1,(2)
	popj 17,

usub_global_array:
	andi 1,17
	move 1,usubsi3_buf(1)
	sub 1,2
	popj 17,

sub_struct_a:
	move 1,(1)
	sub 1,2
	popj 17,

sub_struct_b:
	sub 2,1(1)
	move 1,2
	popj 17,

sub_struct_two:
	move 4,1
	move 1,(1)
	sub 1,1(4)
	popj 17,

sub_struct_three:
	move 4,(1)
	sub 4,1(1)
	sub 4,2(1)
	move 1,4
	popj 17,

sub_global_struct_a:
	move 4,1
	move 1,subsi3_gp
	sub 1,4
	popj 17,

sub_global_struct_b:
	sub 1,subsi3_gp+1
	popj 17,

sub_global_struct_three:
	move 1,subsi3_gt
	sub 1,subsi3_gt+2
	popj 17,

usub_global_struct_a:
	move 4,1
	move 1,usubsi3_gp
	sub 1,4
	popj 17,

subi_zero:
	popj 17,

subi_one:
	subi 1,1
	popj 17,

subi_two:
	subi 1,2
	popj 17,

subi_small:
	subi 1,12345
	popj 17,

subi_right_max:
	subi 1,777777
	popj 17,

subi_left_const:
	add 1,[-123456000000]
	popj 17,

subi_full_const:
	add 1,[-123456123456]
	popj 17,

subi_minus_one:
	addi 1,1
	popj 17,

subi_minus_small:
	addi 1,12345
	popj 17,

usubi_one:
	subi 1,1
	popj 17,

usubi_right_max:
	subi 1,777777
	popj 17,

usubi_full_const:
	add 1,[-123456123456]
	popj 17,

sub_right_half:
	subi 1,(2)
	popj 17,

sub_right_half_plus:
	subi 1,123(2)
	popj 17,

sub_right_half_array:
	andi 3,17
	add 2,3
	hrrz 4,(2)
	sub 1,4
	popj 17,

usub_right_half:
	subi 1,(2)
	popj 17,

usub_right_half_plus:
	subi 1,123(2)
	popj 17,

sub_store_plain:
	move 4,(1)
	sub 4,2
	movem 4,(1)
	popj 17,

sub_store_inverse:
	subm 2,(1)
	popj 17,

sub_store_inverse_return:
	move 4,2
	subb 4,(1)
	move 1,4
	popj 17,

sub_store_global:
	move 4,subsi3_ga
	sub 4,1
	movem 4,subsi3_ga
	popj 17,

sub_store_global_inverse:
	subm 1,subsi3_ga
	popj 17,

sub_store_global_inverse_return:
	subb 1,subsi3_ga
	popj 17,

sub_store_array:
	andi 1,17
	move 4,subsi3_buf(1)
	sub 4,2
	movem 4,subsi3_buf(1)
	popj 17,

sub_store_array_inverse:
	andi 1,17
	subm 2,subsi3_buf(1)
	popj 17,

sub_store_array_inverse_return:
	andi 1,17
	move 4,2
	subb 4,subsi3_buf(1)
	move 1,4
	popj 17,

sub_store_struct_a:
	subm 2,(1)
	popj 17,

sub_store_struct_a_return:
	move 4,2
	subb 4,(1)
	move 1,4
	popj 17,

usub_store_inverse:
	subm 2,(1)
	popj 17,

usub_store_inverse_return:
	move 4,2
	subb 4,(1)
	move 1,4
	popj 17,

sub_dec_mem:
	sos (1)
	popj 17,

sub_dec_mem_return:
	sos 4,(1)
	move 1,4
	popj 17,

sub_dec_global:
	sos subsi3_gc
	popj 17,

sub_dec_global_return:
	sos 1,subsi3_gc
	popj 17,

sub_dec_array:
	andi 1,17
	sos subsi3_buf(1)
	popj 17,

sub_dec_array_return:
	andi 1,17
	sos 4,subsi3_buf(1)
	move 1,4
	popj 17,

sub_eq_zero:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

sub_ne_zero:
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

sub_lt_zero:
	sub 1,2
	lsh 1,-43
	popj 17,

sub_ge_zero:
	sub 1,2
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

sub_gt_const:
	sub 1,2
	movei 6,123
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

sub_range:
	sub 1,2
	seto 4,
	camge 1,[-100]
	jrst %L84
	movei 6,100
	camg 1,6
	tdza 4,4
	movei 4,1
%L84:
	move 1,4
	popj 17,

sub_after_call:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	pushj 17,f
	sub 1,10
	pop 17,10
	popj 17,

sub_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	pushj 17,f
	move 11,1
	pushj 17,clobber
	move 1,11
	subb 1,(10)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sub_global_after_call:
	push 17,10
	pushj 17,f
	move 10,1
	pushj 17,clobber
	sub 10,subsi3_ga
	move 1,10
	pop 17,10
	popj 17,

	.bss
subsi3_ga:
	.space	4
subsi3_gb:
	.space	4
subsi3_gc:
	.space	4
subsi3_vga:
	.space	4
subsi3_buf:
	.space	64
usubsi3_ga:
	.space	4
usubsi3_gb:
	.space	4
usubsi3_vga:
	.space	4
usubsi3_buf:
	.space	64
subsi3_gp:
	.space	8
subsi3_gt:
	.space	12
usubsi3_gp:
	.space	8
