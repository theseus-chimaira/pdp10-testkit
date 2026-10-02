
add_reg_reg:
	add 1,2
	popj 17,

add_ureg_ureg:
	add 1,2
	popj 17,

add_reg_mem:
	add 1,(2)
	popj 17,

add_mem_reg:
	add 2,(1)
	move 1,2
	popj 17,

add_mem_mem:
	move 1,(1)
	add 1,(2)
	popj 17,

add_volatile_mem:
	move 4,(2)
	add 4,1
	move 1,4
	popj 17,

add_global_reg:
	add 1,addsi3_ga
	popj 17,

add_reg_global:
	add 1,addsi3_gb
	popj 17,

add_array_reg:
	andi 2,17
	add 1,2
	add 3,(1)
	move 1,3
	popj 17,

add_reg_array:
	andi 3,17
	add 2,3
	add 1,(2)
	popj 17,

add_global_array:
	andi 1,17
	add 2,addsi3_buf(1)
	move 1,2
	popj 17,

add_struct_a:
	add 2,(1)
	move 1,2
	popj 17,

add_struct_b:
	add 2,1(1)
	move 1,2
	popj 17,

add_global_struct:
	add 1,addsi3_gp
	popj 17,

addi_zero:
	popj 17,

addi_one:
	addi 1,1
	popj 17,

addi_two:
	addi 1,2
	popj 17,

addi_small:
	addi 1,123456
	popj 17,

addi_low9:
	addi 1,777
	popj 17,

addi_low18:
	addi 1,777777
	popj 17,

uaddi_low18:
	addi 1,777777
	popj 17,

subi_one_as_add:
	subi 1,1
	popj 17,

subi_two_as_add:
	subi 1,2
	popj 17,

subi_small_as_add:
	subi 1,123456
	popj 17,

subi_low18_as_add:
	subi 1,777777
	popj 17,

add_large_const:
	add 1,[123456123456]
	popj 17,

add_large_const_left:
	add 1,[123456123456]
	popj 17,

add_large_ones:
	subi 1,1
	popj 17,

add_left_half_const:
	add 1,[-1000000]
	popj 17,

add_right_half_const:
	addi 1,777777
	popj 17,

add_sign_bit_const:
	add 1,[-400000000000]
	popj 17,

add_const_after_expr:
	xor 1,2
	addi 1,123456
	popj 17,

add_negative_const_after_expr:
	xor 1,2
	subi 1,123456
	popj 17,

add_large_const_after_expr:
	add 1,2
	add 1,[123456123456]
	popj 17,

add_qi_promote:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	add 1,2
	popj 17,

add_uqi_promote:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	add 1,2
	popj 17,

add_hi_promote:
	hrre 1,1
	hrre 2,2
	add 1,2
	popj 17,

add_uhi_promote:
	hrrzi 2,(2)	; zero_extendhisi2
	addi 2,(1)
	move 1,2
	popj 17,

add_qi_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	add 1,2
	popj 17,

add_uqi_mem:
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

add_hi_mem:
	ldb 1,1
	hrre 1,1
	add 1,2
	popj 17,

add_uhi_mem:
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

addm_reg:
	addm 2,(1)
	popj 17,

addm_reg_ret:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

addm_mem:
	move 2,(2)
	addm 2,(1)
	popj 17,

addm_mem_ret:
	move 4,(1)
	add 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

addm_global:
	addm 1,addsi3_ga
	popj 17,

addm_global_ret:
	addb 1,addsi3_ga
	popj 17,

addm_array:
	andi 2,17
	add 1,2
	addm 3,(1)
	popj 17,

addm_array_ret:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	addb 1,(4)
	popj 17,

addm_global_array:
	andi 1,17
	addm 2,addsi3_buf(1)
	popj 17,

addm_struct_a:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

addm_struct_b:
	move 4,2
	addb 4,1(1)
	move 1,4
	popj 17,

addm_global_struct:
	addb 1,addsi3_gp+1
	popj 17,

addm_volatile:
	move 4,(1)
	add 4,2
	movem 4,(1)
	popj 17,

addm_volatile_ret:
	move 4,(1)
	add 4,2
	movem 4,(1)
	move 1,(1)
	popj 17,

aos_mem:
	aos (1)
	popj 17,

aos_mem_ret:
	aos 4,(1)
	move 1,4
	popj 17,

sos_mem:
	sos (1)
	popj 17,

sos_mem_ret:
	sos 4,(1)
	move 1,4
	popj 17,

aos_global:
	aos 1,addsi3_ga
	popj 17,

sos_global:
	sos 1,addsi3_gb
	popj 17,

aos_array:
	andi 2,17
	add 1,2
	aos 4,(1)
	move 1,4
	popj 17,

sos_array:
	andi 2,17
	add 1,2
	sos 4,(1)
	move 1,4
	popj 17,

aos_struct:
	aos 4,(1)
	move 1,4
	popj 17,

sos_struct:
	sos 4,1(1)
	move 1,4
	popj 17,

aos_volatile:
	move 4,(1)
	addi 4,1
	movem 4,(1)
	move 1,(1)
	popj 17,

sos_volatile:
	move 4,(1)
	subi 4,1
	movem 4,(1)
	move 1,(1)
	popj 17,

addm_const_small:
	movei 6,123456
	addm 6,(1)
	popj 17,

addm_const_small_ret:
	move 4,(1)
	addi 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

addm_const_large:
	move 6,[123456123456]
	addm 6,(1)
	popj 17,

addm_const_large_ret:
	move 4,(1)
	add 4,[123456123456]
	movem 4,(1)
	move 1,4
	popj 17,

addm_const_negative:
	hrroi 6,654322
	addm 6,(1)
	popj 17,

addm_const_negative_ret:
	move 4,(1)
	subi 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

addi_reg_right_half:
	hrrz 2,2
	add 2,1
	move 1,2
	popj 17,

addi_const_plus_reg_right_half:
	movei 2,1234(2)
	add 2,1
	move 1,2
	popj 17,

addi_reg_right_half_mem:
	hrrz 4,(2)
	add 4,1
	move 1,4
	popj 17,

addi_const_plus_reg_right_half_mem:
	move 4,1
	move 1,(2)
	addi 1,1234
	hrrz 1,1
	add 1,4
	popj 17,

add_nested1:
	add 1,2
	add 1,3
	popj 17,

add_nested_const:
	add 1,2
	addi 1,123456
	popj 17,

add_nested_large_const:
	add 1,2
	add 1,[123456123456]
	popj 17,

add_store_then_use:
	move 4,2
	addb 4,(1)
	add 4,2
	move 1,4
	popj 17,

add_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	add 10,11
	pushj 17,clobber
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

add_mem_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	add 10,(1)
	pushj 17,clobber
	add 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

add_loop_sum:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L107:
	move 4,3
	andi 4,17
	add 4,6
	add 1,(4)
	addi 3,1
	sojge 2,%L107	; doloop_end
	popj 17,

add_loop_update:
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L118:
	move 4,6
	andi 4,17
	add 4,1
	addm 3,(4)
	addi 6,1
	sojge 2,%L118	; doloop_end
	popj 17,

add_loop_update_sum:
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
	addb 3,(4)
	add 1,3
	addi 7,1
	sojge 2,%L130	; doloop_end
	popj 17,

add1:
	add 1,2
	popj 17,

add2:
	add 1,(2)
	popj 17,

addi:
	addi 1,123456
	popj 17,

subi:
	subi 1,123456
	popj 17,

add3:
	add 1,[123456123456]
	popj 17,

addm:
	addb 1,(2)
	popj 17,

	.bss
addsi3_ga:
	.space	4
addsi3_gb:
	.space	4
addsi3_buf:
	.space	64
addsi3_gp:
	.space	8
addsi3_gt:
	.space	12
