
ior_reg_reg:
	ior 1,2
	popj 17,

uior_reg_reg:
	ior 1,2
	popj 17,

ior_reg_mem:
	ior 1,(2)
	popj 17,

ior_mem_reg:
	ior 2,(1)
	move 1,2
	popj 17,

ior_mem_mem:
	move 1,(1)
	ior 1,(2)
	popj 17,

uior_reg_mem:
	ior 1,(2)
	popj 17,

ior_volatile_mem:
	move 4,(2)
	ior 4,1
	move 1,4
	popj 17,

ior_global_reg:
	ior 1,iorsi3_ga
	popj 17,

ior_reg_global:
	ior 1,iorsi3_gb
	popj 17,

uior_global_reg:
	ior 1,iorsi3_uga
	popj 17,

ior_array_reg:
	andi 2,17
	add 1,2
	ior 3,(1)
	move 1,3
	popj 17,

ior_reg_array:
	andi 3,17
	add 2,3
	ior 1,(2)
	popj 17,

uior_array_reg:
	andi 2,17
	add 1,2
	ior 3,(1)
	move 1,3
	popj 17,

ior_global_array:
	andi 1,17
	ior 2,iorsi3_buf(1)
	move 1,2
	popj 17,

ior_struct_a:
	ior 2,(1)
	move 1,2
	popj 17,

ior_struct_b:
	ior 2,1(1)
	move 1,2
	popj 17,

ior_global_struct:
	ior 1,iorsi3_gp
	popj 17,

iori_zero:
	popj 17,

iori_one:
	iori 1,1
	popj 17,

iori_small:
	iori 1,123456
	popj 17,

iori_low9:
	iori 1,777
	popj 17,

iori_low18:
	hllo 1,1
	popj 17,

uiori_low18:
	hllo 1,1
	popj 17,

tlo_small:
	tlo 1,123456
	popj 17,

tlo_one_left_bit:
	tlo 1,400000
	popj 17,

tlo_many_left_bits:
	tlo 1,525252
	popj 17,

tlo_all_left:
	hrro 1,1
	popj 17,

tlo_after_expr:
	xor 1,2
	tlo 1,123456
	popj 17,

orcmi_small:
	orcmi 1,123456
	popj 17,

orcmi_one:
	orcmi 1,1
	popj 17,

orcmi_low9:
	orcmi 1,777
	popj 17,

orcmi_low18:
	hrro 1,1
	popj 17,

uorcmi_low18:
	hrro 1,1
	popj 17,

orcmi_after_expr:
	and 1,2
	orcmi 1,123456
	popj 17,

ior_large_literal:
	ior 1,[123456123456]
	popj 17,

ior_large_literal_left:
	ior 1,[123456123456]
	popj 17,

ior_sparse_literal:
	ior 1,[-252525525253]
	popj 17,

ior_left_half_only:
	hrro 1,1
	popj 17,

ior_right_half_only:
	hllo 1,1
	popj 17,

ior_sign_bit:
	tlo 1,400000
	popj 17,

uior_large_literal:
	ior 1,[123456123456]
	popj 17,

ior_const_after_expr:
	add 1,2
	ior 1,[123456123456]
	popj 17,

ior_qi_promote:
	ior 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

ior_uqi_promote:
	ior 2,1
	andi 2,777
	move 1,2
	popj 17,

ior_hi_promote:
	ior 2,1
	hrre 2,2
	move 1,2
	popj 17,

ior_uhi_promote:
	hrrzi 2,(2)	; zero_extendhisi2
	iori 2,(1)
	move 1,2
	popj 17,

ior_qi_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	ior 1,2
	popj 17,

ior_uqi_mem:
	ldb 1,1
	ior 2,1
	move 1,2
	popj 17,

ior_hi_mem:
	ldb 1,1
	hrre 1,1
	ior 1,2
	popj 17,

ior_uhi_mem:
	ldb 1,1
	ior 2,1
	move 1,2
	popj 17,

iorm_reg:
	iorm 2,(1)
	popj 17,

iorm_reg_alt:
	iorm 2,(1)
	popj 17,

iorm_reg_ret:
	move 4,2
	iorb 4,(1)
	move 1,4
	popj 17,

iorm_reg_ret_alt:
	move 4,2
	iorb 4,(1)
	move 1,4
	popj 17,

iorm_mem:
	move 2,(2)
	iorm 2,(1)
	popj 17,

iorm_mem_ret:
	move 4,(1)
	ior 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

iorm_global:
	iorm 1,iorsi3_ga
	popj 17,

iorm_global_ret:
	iorb 1,iorsi3_ga
	popj 17,

iorm_array:
	andi 2,17
	add 1,2
	iorm 3,(1)
	popj 17,

iorm_array_ret:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	iorb 1,(4)
	popj 17,

iorm_global_array:
	andi 1,17
	iorm 2,iorsi3_buf(1)
	popj 17,

iorm_struct_a:
	move 4,2
	iorb 4,(1)
	move 1,4
	popj 17,

iorm_struct_b:
	move 4,2
	iorb 4,1(1)
	move 1,4
	popj 17,

iorm_global_struct:
	iorb 1,iorsi3_gp+1
	popj 17,

iorm_volatile:
	move 4,(1)
	ior 4,2
	movem 4,(1)
	popj 17,

iorm_volatile_ret:
	move 4,(1)
	ior 4,2
	movem 4,(1)
	move 1,(1)
	popj 17,

iorm_const_small:
	movei 6,123456
	iorm 6,(1)
	popj 17,

iorm_const_small_ret:
	move 4,(1)
	iori 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

iorm_const_low18:
	move 6,(1)
	hllom 6,(1)
	popj 17,

iorm_const_low18_ret:
	hllos 4,(1)
	move 1,4
	popj 17,

iorm_const_tlo:
	movsi 6,123456
	iorm 6,(1)
	popj 17,

iorm_const_tlo_ret:
	move 4,(1)
	tlo 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

iorm_const_orcmi:
	hrroi 6,654321
	iorm 6,(1)
	popj 17,

iorm_const_orcmi_ret:
	move 4,(1)
	orcmi 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

iorm_const_large:
	move 6,[123456123456]
	iorm 6,(1)
	popj 17,

iorm_const_large_ret:
	move 4,(1)
	ior 4,[123456123456]
	movem 4,(1)
	move 1,4
	popj 17,

iorm_const_zero:
	popj 17,

iorm_const_zero_ret:
	move 1,(1)
	popj 17,

iorm_const_ones:
	setom (1)
	popj 17,

iorm_const_ones_ret:
	setom (1)
	seto 1,
	popj 17,

ior_reg_mask_right:
	hrrz 2,2
	ior 2,1
	move 1,2
	popj 17,

ior_reg_mask_left:
	hrlz 2,2
	ior 2,1
	move 1,2
	popj 17,

ior_reg_mask_orcmi:
	orcbi 2,777777
	ior 2,1
	move 1,2
	popj 17,

ior_nested1:
	ior 1,2
	ior 1,3
	popj 17,

ior_nested_const:
	xor 1,2
	ior 1,2
	iori 1,123456
	popj 17,

ior_nested_large_const:
	and 2,1
	ior 2,1
	ior 2,[123456123456]
	move 1,2
	popj 17,

ior_store_then_use:
	move 4,2
	iorb 4,(1)
	ior 4,2
	move 1,4
	popj 17,

ior_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	ior 10,11
	pushj 17,clobber
	ior 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ior_mem_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	ior 10,(1)
	pushj 17,clobber
	ior 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ior_loop_sum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L107:
	move 4,6
	andi 4,17
	add 4,7
	move 4,(4)
	ior 4,3
	add 1,4
	addi 6,1
	sojge 2,%L107	; doloop_end
	popj 17,

ior_loop_update:
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L118:
	move 4,6
	andi 4,17
	add 4,1
	iorm 3,(4)
	addi 6,1
	sojge 2,%L118	; doloop_end
	popj 17,

ior_loop_update_sum:
	move 5,1
	move 6,3
	setzb 1,7
	caml 1,2
	popj 17,
	subi 2,1
%L130:
	move 4,7
	andi 4,17
	add 4,5
	move 3,6
	iorb 3,(4)
	add 1,3
	addi 7,1
	sojge 2,%L130	; doloop_end
	popj 17,

ior_branch_zero:
	movei 1,0
	popj 17,

ior_branch_nonzero:
	popj 17,

ior_branch_sign:
	movei 1,0
	popj 17,

ior1:
	ior 1,2
	popj 17,

ior2:
	ior 1,(2)
	popj 17,

iori:
	iori 1,123456
	popj 17,

tlo:
	tlo 1,123456
	popj 17,

orcmi:
	orcmi 1,123456
	popj 17,

ior3:
	ior 1,[123456123456]
	popj 17,

iorm:
	iorb 1,(2)
	popj 17,

	.bss
iorsi3_ga:
	.space	4
iorsi3_gb:
	.space	4
iorsi3_uga:
	.space	4
iorsi3_buf:
	.space	64
iorsi3_ubuf:
	.space	64
iorsi3_gp:
	.space	8
iorsi3_gt:
	.space	12
