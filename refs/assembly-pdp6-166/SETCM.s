
setcm_reg:
	setca 1,
	popj 17,

setcm_mem:
	setcm 1,(1)
	popj 17,

setcm_mem_plus:
	setcm 1,(1)
	add 1,2
	popj 17,

setcm_mem_xor:
	eqv 2,(1)
	move 1,2
	popj 17,

setcm_global_a:
	setcm 1,setcm_ga
	popj 17,

setcm_global_b:
	setcm 1,setcm_gb
	popj 17,

setcm_array:
	andi 2,17
	add 1,2
	setcm 1,(1)
	popj 17,

setcm_global_array:
	andi 1,17
	setcm 1,setcm_buf(1)
	popj 17,

setcm_struct_a:
	setcm 1,(1)
	popj 17,

setcm_struct_b:
	setcm 1,1(1)
	popj 17,

setcm_global_struct_a:
	setcm 1,setcm_gp
	popj 17,

setcm_global_struct_b:
	setcm 1,setcm_gp+1
	popj 17,

setcm_indirect:
	setcm 1,@(1)
	popj 17,

setcm_volatile_mem:
	move 1,(1)
	setca 1,
	popj 17,

setcm_const_zero:
	seto 1,
	popj 17,

setcm_const_one:
	hrroi 1,777776
	popj 17,

setcm_const_small:
	hrroi 1,654321
	popj 17,

setcm_const_low9:
	hrroi 1,777000
	popj 17,

setcm_const_low18:
	movsi 1,777777
	popj 17,

setcm_const_literal:
	move 1,[-123456123457]
	popj 17,

setcm_const_left_half:
	movei 1,777777
	popj 17,

setcm_const_right_half:
	movsi 1,777777
	popj 17,

setcm_const_sign_bit:
	hrloi 1,377777
	popj 17,

setcmm_mem:
	setcmm (1)
	popj 17,

setcmm_global_a:
	setcmm setcm_ga
	popj 17,

setcmm_global_b:
	setcmm setcm_gb
	popj 17,

setcmm_array:
	andi 2,17
	add 1,2
	setcmm (1)
	popj 17,

setcmm_global_array:
	andi 1,17
	setcmm setcm_buf(1)
	popj 17,

setcmm_struct_a:
	setcmm (1)
	popj 17,

setcmm_struct_b:
	setcmm 1(1)
	popj 17,

setcmm_indirect:
	setcmm @(1)
	popj 17,

setcmm_volatile_mem:
	move 4,(1)
	setca 4,
	movem 4,(1)
	popj 17,

setcmm_return_mem:
	setcmb (1),4
	move 1,4
	popj 17,

setcmm_return_global:
	setcmb setcm_ga,1
	popj 17,

setcmm_return_array:
	andi 2,17
	add 1,2
	setcmb (1),4
	move 1,4
	popj 17,

setcmm_return_struct_a:
	setcmb (1),4
	move 1,4
	popj 17,

setcmm_return_struct_b:
	setcmb 1(1),4
	move 1,4
	popj 17,

usetcm_reg:
	setca 1,
	popj 17,

usetcm_mem:
	setcm 1,(1)
	popj 17,

usetcm_global:
	setcm 1,setcm_uga
	popj 17,

usetcmm_mem:
	setcmm (1)
	popj 17,

usetcmm_global:
	setcmm setcm_uga
	popj 17,

usetcmb_return:
	setcmb (1),4
	move 1,4
	popj 17,

setcm_qi:
	lsh 1,33
	ash 1,-33
	setca 1,
	popj 17,

setcm_uqi:
	orcbi 1,777
	popj 17,

setcm_hi:
	hrre 1,1
	setca 1,
	popj 17,

setcm_uhi:
	orcbi 1,777777
	popj 17,

setcm_qi_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	setca 1,
	popj 17,

setcm_uqi_mem:
	ldb 1,1
	setca 1,
	popj 17,

setcm_hi_mem:
	ldb 1,1
	hrre 1,1
	setca 1,
	popj 17,

setcm_uhi_mem:
	ldb 1,1
	setca 1,
	popj 17,

setcmm_qi_mem:
	ldb 4,1
	setca 4,
	dpb 4,1
	popj 17,

setcmm_uqi_mem:
	ldb 4,1
	setca 4,
	dpb 4,1
	popj 17,

setcmm_hi_mem:
	ldb 4,1
	setca 4,
	dpb 4,1	; movhi
	popj 17,

setcmm_uhi_mem:
	ldb 4,1
	setca 4,
	dpb 4,1	; movhi
	popj 17,

setcm_chain:
	xor 2,1
	move 1,2
	popj 17,

setcm_double:
	popj 17,

setcm_mixed_mem_reg:
	setcm 1,(1)
	setca 2,
	add 1,2
	popj 17,

setcmm_two:
	setcmm (1)
	setcmm (2)
	popj 17,

setcmb_memaa:
	setcmb (2),1
	popj 17,

setcmb_memab:
	setcmb (2),1
	popj 17,

setcmb_memba:
	setcmb (2),1
	popj 17,

setcmb_membb:
	setcmb (2),1
	popj 17,

usetcmb_memaa:
	setcmb (2),1
	popj 17,

usetcmb_memab:
	setcmb (2),1
	popj 17,

usetcmb_memba:
	setcmb (2),1
	popj 17,

usetcmb_membb:
	setcmb (2),1
	popj 17,

	.bss
setcm_ga:
	.space	4
setcm_gb:
	.space	4
setcm_uga:
	.space	4
setcm_buf:
	.space	64
setcm_gp:
	.space	8
