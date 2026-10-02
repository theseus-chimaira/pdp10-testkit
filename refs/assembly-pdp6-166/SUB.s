
sub_reg_reg:
	sub 1,2
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

sub_global_a:
	sub 1,sub_ga
	popj 17,

sub_global_b:
	move 1,sub_ga
	sub 1,sub_gb
	popj 17,

sub_array:
	andi 2,17
	add 1,2
	sub 3,(1)
	move 1,3
	popj 17,

sub_global_array:
	andi 1,17
	sub 2,sub_buf(1)
	move 1,2
	popj 17,

sub_struct_a:
	sub 2,(1)
	move 1,2
	popj 17,

sub_struct_b:
	sub 2,1(1)
	move 1,2
	popj 17,

sub_global_struct_a:
	sub 1,sub_gp
	popj 17,

sub_global_struct_b:
	sub 1,sub_gp+1
	popj 17,

sub_indirect:
	sub 2,@(1)
	move 1,2
	popj 17,

sub_volatile:
	move 4,(2)
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
	subi 1,123456
	popj 17,

subi_max18:
	subi 1,777777
	popj 17,

subi_neg_small:
	addi 1,123456
	popj 17,

sub_literal:
	add 1,[-123456123456]
	popj 17,

sub_literal_left:
	add 1,[1000000]
	popj 17,

sub_literal_right:
	subi 1,777777
	popj 17,

sub_literal_sign:
	add 1,[-400000000000]
	popj 17,

sub_literal_sparse:
	add 1,[252525525253]
	popj 17,

subm_reg_mem:
	subm 1,(2)
	popj 17,

subm_global_a:
	subm 1,sub_ga
	popj 17,

subm_global_b:
	subm 1,sub_gb
	popj 17,

subm_array:
	andi 2,17
	add 1,2
	subm 3,(1)
	popj 17,

subm_global_array:
	andi 1,17
	subm 2,sub_buf(1)
	popj 17,

subm_struct_a:
	subm 2,(1)
	popj 17,

subm_struct_b:
	subm 2,1(1)
	popj 17,

subm_global_struct_a:
	subm 1,sub_gp
	popj 17,

subm_global_struct_b:
	subm 1,sub_gp+1
	popj 17,

subm_indirect:
	subm 2,@(1)
	popj 17,

subm_volatile:
	move 4,(2)
	sub 1,4
	movem 1,(2)
	popj 17,

subm_const_small:
	movei 4,123456
	subm 4,(1)
	popj 17,

subm_const_literal:
	move 4,[123456123456]
	subm 4,(1)
	popj 17,

subm_return_mem:
	subb 1,(2)
	popj 17,

subm_return_global:
	subb 1,sub_ga
	popj 17,

subm_return_array:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	subb 1,(4)
	popj 17,

subm_return_struct_a:
	move 4,2
	subb 4,(1)
	move 1,4
	popj 17,

subm_return_struct_b:
	move 4,2
	subb 4,1(1)
	move 1,4
	popj 17,

subb_mem_return:
	subb 1,(2)
	popj 17,

subb_global_return:
	subb 1,sub_ga
	popj 17,

subb_array_return:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	subb 1,(4)
	popj 17,

subb_struct_a_return:
	move 4,2
	subb 4,(1)
	move 1,4
	popj 17,

subb_struct_b_return:
	move 4,2
	subb 4,1(1)
	move 1,4
	popj 17,

usub_reg_reg:
	sub 1,2
	popj 17,

usub_reg_mem:
	sub 1,(2)
	popj 17,

usub_global:
	sub 1,sub_uga
	popj 17,

usub_array:
	andi 2,17
	add 1,2
	sub 3,(1)
	move 1,3
	popj 17,

usubi_small:
	subi 1,123456
	popj 17,

usubi_max18:
	subi 1,777777
	popj 17,

usub_literal:
	add 1,[-123456123456]
	popj 17,

usubm_mem:
	subm 1,(2)
	popj 17,

usubm_global:
	subm 1,sub_uga
	popj 17,

usubm_array:
	andi 2,17
	add 1,2
	subm 3,(1)
	popj 17,

usubb_mem_return:
	subb 1,(2)
	popj 17,

usubb_global_return:
	subb 1,sub_uga
	popj 17,

sub_qi:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	sub 1,2
	popj 17,

sub_uqi:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	sub 1,2
	popj 17,

sub_hi:
	hrre 1,1
	hrre 2,2
	sub 1,2
	popj 17,

sub_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	subi 1,(2)
	popj 17,

sub_qi_mem:
	lsh 1,33
	ash 1,-33
	ldb 4,2
	trne 4,400
	orcmi 4,777
	sub 1,4
	popj 17,

sub_uqi_mem:
	andi 1,777	; zero_extendqisi2
	ldb 2,2
	sub 1,2
	popj 17,

sub_hi_mem:
	hrre 1,1
	ldb 4,2
	hrre 4,4
	sub 1,4
	popj 17,

sub_uhi_mem:
	hrrzi 1,(1)	; zero_extendhisi2
	ldb 2,2
	sub 1,2
	popj 17,

subm_qi:
	ldb 6,2
	sub 1,6
	dpb 1,2
	popj 17,

subm_uqi:
	ldb 6,2
	sub 1,6
	dpb 1,2
	popj 17,

subm_hi:
	ldb 6,2
	sub 1,6
	dpb 1,2	; movhi
	popj 17,

subm_uhi:
	ldb 6,2
	sub 1,6
	dpb 1,2	; movhi
	popj 17,

sub_ptr_reg:
	sub 1,2
	popj 17,

sub_ptr_small:
	subi 1,123456
	popj 17,

sub_ptr_one:
	subi 1,1
	popj 17,

sub_ptr_mem:
	sub 1,(2)
	popj 17,

sub_byte_ptr_reg:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L94
%L93:
	ibp 1
	sojn 4,%L93	; decrement_and_branch_until_zero
%L94:
	popj 17,

sub_byte_ptr_one:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

sub_byte_ptr_small:
	subi 1,25
	ibp 1
	popj 17,

sub_half_ptr_reg:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L100
%L99:
	ibp 1
	sojn 4,%L99	; decrement_and_branch_until_zero
%L100:
	popj 17,

sub_half_ptr_one:
	subi 1,1
	ibp 1
	popj 17,

sub_chain:
	sub 1,2
	sub 1,3
	popj 17,

sub_chain_mem:
	sub 1,(2)
	sub 1,(3)
	popj 17,

sub_neg_relation:
	add 1,2
	popj 17,

sub_store_then_use:
	move 6,1
	sub 6,2
	move 2,6
	movem 6,(3)
	sub 2,1
	move 1,2
	popj 17,

subb_reg_memaa:
	subb 1,(2)
	popj 17,

subb_reg_memab:
	subb 1,(2)
	popj 17,

subb_reg_memba:
	subb 1,(2)
	popj 17,

subb_reg_membb:
	subb 1,(2)
	popj 17,

usubb_reg_memaa:
	subb 1,(2)
	popj 17,

usubb_reg_memab:
	subb 1,(2)
	popj 17,

usubb_reg_memba:
	subb 1,(2)
	popj 17,

usubb_reg_membb:
	subb 1,(2)
	popj 17,

	.bss
sub_ga:
	.space	4
sub_gb:
	.space	4
sub_uga:
	.space	4
sub_buf:
	.space	64
sub_ubuf:
	.space	64
sub_gp:
	.space	8
sub_ugp:
	.space	8
