
setca_reg:
	setca 1,
	popj 17,

setca_reg_plus:
	add 1,2
	setca 1,
	popj 17,

setca_reg_xor:
	eqv 1,2
	popj 17,

setca_reg_and:
	orcb 1,2
	popj 17,

setca_reg_or:
	andcb 1,2
	popj 17,

setca_global_value:
	setcm 1,setca_ga
	popj 17,

setca_array_value:
	andi 1,17
	setcm 1,setca_buf(1)
	popj 17,

setca_struct_a:
	setcm 1,(1)
	popj 17,

setca_struct_b:
	setcm 1,1(1)
	popj 17,

setca_global_struct_a:
	setcm 1,setca_gp
	popj 17,

setca_global_struct_b:
	setcm 1,setca_gp+1
	popj 17,

setcam_mem:
	setcam 1,(2)
	popj 17,

setcam_global:
	setcam 1,setca_ga
	popj 17,

setcam_global_b:
	setcam 1,setca_gb
	popj 17,

setcam_array:
	andi 3,17
	add 2,3
	setcam 1,(2)
	popj 17,

setcam_global_array:
	andi 2,17
	setcam 1,setca_buf(2)
	popj 17,

setcam_struct_a:
	setcam 1,(2)
	popj 17,

setcam_struct_b:
	setcam 1,1(2)
	popj 17,

setcam_from_expr:
	add 1,2
	setcam 1,(3)
	popj 17,

setcam_volatile:
	setca 1,
	movem 1,(2)
	popj 17,

setcam_return_original:
	setcam 1,(2)
	popj 17,

setcam_return_loaded:
	setcab 1,(2)
	popj 17,

setcab_mem_return:
	setcab 1,(2)
	popj 17,

setcab_global_return:
	setcab 1,setca_ga
	popj 17,

setcab_array_return:
	andi 3,17
	add 2,3
	setcab 1,(2)
	popj 17,

setcab_struct_a_return:
	setcab 1,(2)
	popj 17,

setcab_struct_b_return:
	setcab 1,1(2)
	popj 17,

usetca_reg:
	setca 1,
	popj 17,

usetca_reg_plus:
	add 1,2
	setca 1,
	popj 17,

usetcam_mem:
	setcam 1,(2)
	popj 17,

usetcam_global:
	setcam 1,setca_uga
	popj 17,

usetcab_mem_return:
	setcab 1,(2)
	popj 17,

setca_qi:
	lsh 1,33
	ash 1,-33
	setca 1,
	popj 17,

setca_uqi:
	orcbi 1,777
	popj 17,

setca_hi:
	hrre 1,1
	setca 1,
	popj 17,

setca_uhi:
	orcbi 1,777777
	popj 17,

setcam_qi:
	lsh 1,33
	ash 1,-33
	setcam 1,(2)
	popj 17,

setcam_uqi:
	orcbi 1,777
	movem 1,(2)
	popj 17,

setcam_hi:
	hrre 1,1
	setcam 1,(2)
	popj 17,

setcam_uhi:
	orcbi 1,777777
	movem 1,(2)
	popj 17,

setca_chain:
	xor 2,1
	move 1,2
	popj 17,

setca_double:
	popj 17,

setcab_reg_memaa:
	setcab 1,(2)
	popj 17,

setcab_reg_memab:
	setcab 1,(2)
	popj 17,

setcab_reg_memba:
	setcab 1,(2)
	popj 17,

setcab_reg_membb:
	setcab 1,(2)
	popj 17,

usetcab_reg_memaa:
	setcab 1,(2)
	popj 17,

usetcab_reg_memab:
	setcab 1,(2)
	popj 17,

usetcab_reg_memba:
	setcab 1,(2)
	popj 17,

usetcab_reg_membb:
	setcab 1,(2)
	popj 17,

	.bss
setca_ga:
	.space	4
setca_gb:
	.space	4
setca_uga:
	.space	4
setca_buf:
	.space	64
setca_gp:
	.space	8
