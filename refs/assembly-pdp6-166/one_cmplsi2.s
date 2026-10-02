
not_reg:
	setca 1,
	popj 17,

unot_reg:
	setca 1,
	popj 17,

not_mem:
	setcm 1,(1)
	popj 17,

unot_mem:
	setcm 1,(1)
	popj 17,

not_volatile_mem:
	move 1,(1)
	setca 1,
	popj 17,

not_global:
	setcm 1,onecmpl_g0
	popj 17,

unot_global:
	setcm 1,onecmpl_ug0
	popj 17,

not_array:
	andi 1,17
	setcm 1,onecmpl_buf(1)
	popj 17,

unot_uarray:
	andi 1,17
	setcm 1,onecmpl_ubuf(1)
	popj 17,

not_struct_a:
	setcm 1,(1)
	popj 17,

not_struct_b:
	setcm 1,1(1)
	popj 17,

unot_struct_a:
	setcm 1,(1)
	popj 17,

not_global_struct_a:
	setcm 1,onecmpl_gp
	popj 17,

not_global_struct_b:
	setcm 1,onecmpl_gp+1
	popj 17,

unot_global_struct_a:
	setcm 1,onecmpl_ugp
	popj 17,

not_store_reg:
	setcam 2,(1)
	popj 17,

unot_store_reg:
	setcam 2,(1)
	popj 17,

not_store_reg_ret:
	move 4,2
	setcab 4,(1)
	move 1,4
	popj 17,

not_store_mem:
	setcmm (1)
	popj 17,

not_store_mem_ret:
	setcmb (1),4
	move 1,4
	popj 17,

unot_store_mem:
	setcmm (1)
	popj 17,

unot_store_mem_ret:
	setcmb (1),4
	move 1,4
	popj 17,

not_store_volatile_mem:
	move 4,(1)
	setca 4,
	movem 4,(1)
	popj 17,

not_store_volatile_mem_ret:
	move 4,(1)
	setca 4,
	movem 4,(1)
	move 1,(1)
	popj 17,

not_store_global_reg:
	setcam 1,onecmpl_g0
	popj 17,

not_store_global_reg_ret:
	setcab 1,onecmpl_g0
	popj 17,

not_store_global_mem:
	setcmm onecmpl_g0
	popj 17,

not_store_global_mem_ret:
	setcmb onecmpl_g0,1
	popj 17,

not_store_array_reg:
	andi 1,17
	setcam 2,onecmpl_buf(1)
	popj 17,

not_store_array_reg_ret:
	andi 1,17
	move 4,2
	setcab 4,onecmpl_buf(1)
	move 1,4
	popj 17,

not_store_array_mem:
	andi 1,17
	setcmm onecmpl_buf(1)
	popj 17,

not_store_array_mem_ret:
	andi 1,17
	setcmb onecmpl_buf(1),4
	move 1,4
	popj 17,

not_store_struct_reg:
	setcam 2,(1)
	popj 17,

not_store_struct_reg_ret:
	move 4,2
	setcab 4,(1)
	move 1,4
	popj 17,

not_store_struct_mem:
	setcmm (1)
	popj 17,

not_store_struct_mem_ret:
	setcmb (1),4
	move 1,4
	popj 17,

not_store_global_struct_mem:
	setcmm onecmpl_gp
	popj 17,

not_store_global_struct_mem_ret:
	setcmb onecmpl_gp,1
	popj 17,

not_expr_add:
	add 1,2
	setca 1,
	popj 17,

not_expr_sub:
	sub 1,2
	setca 1,
	popj 17,

not_expr_and:
	and 1,2
	setca 1,
	popj 17,

not_expr_ior:
	ior 1,2
	setca 1,
	popj 17,

not_expr_xor:
	xor 1,2
	setca 1,
	popj 17,

not_expr_shift:
	andi 2,17
	lsh 1,(2)
	setca 1,
	popj 17,

not_then_add:
	setca 1,
	add 1,2
	popj 17,

not_then_sub:
	setca 1,
	sub 2,1
	move 1,2
	popj 17,

not_then_and:
	andca 1,2
	popj 17,

not_then_ior:
	orca 1,2
	popj 17,

not_then_xor:
	eqv 1,2
	popj 17,

double_not:
	popj 17,

udouble_not:
	popj 17,

not_const_zero:
	seto 1,
	popj 17,

not_const_one:
	hrroi 1,777776
	popj 17,

not_const_small:
	hrroi 1,654321
	popj 17,

not_const_low9:
	hrroi 1,777000
	popj 17,

not_const_low18:
	movsi 1,777777
	popj 17,

not_const_large:
	move 1,[-123456123457]
	popj 17,

not_store_const_zero:
	setom (1)
	popj 17,

not_store_const_one:
	hrroi 6,777776
	movem 6,(1)
	popj 17,

not_store_const_small:
	hrroi 6,654321
	movem 6,(1)
	popj 17,

not_store_const_large:
	move 6,[-123456123457]
	movem 6,(1)
	popj 17,

not_qi:
	lsh 1,33
	ash 1,-33
	setca 1,
	popj 17,

not_uqi:
	orcbi 1,777
	popj 17,

not_hi:
	hrre 1,1
	setca 1,
	popj 17,

not_uhi:
	orcbi 1,777777
	popj 17,

not_qi_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	setca 1,
	popj 17,

not_uqi_mem:
	ldb 1,1
	setca 1,
	popj 17,

not_hi_mem:
	ldb 1,1
	hrre 1,1
	setca 1,
	popj 17,

not_uhi_mem:
	ldb 1,1
	setca 1,
	popj 17,

not_store_qi:
	setca 2,
	dpb 2,1
	popj 17,

not_store_hi:
	setca 2,
	dpb 2,1	; movhi
	popj 17,

not_branch_zero:
	setca 1,
	movei 4,1
	jumpe 1,%L72
	move 4,1
%L72:
	move 1,4
	popj 17,

not_branch_nonzero:
	setca 1,
	move 4,1
	jumpn 1,%L74
	movei 4,1
%L74:
	move 1,4
	popj 17,

not_branch_negative:
	setca 1,
	camge 1,[-1]
	seto 1,
	popj 17,

not_branch_positive:
	setca 1,
	caige 1,0
	movei 1,0
	popj 17,

not_mem_branch_zero:
	setcm 4,(1)
	movei 1,1
	jumpe 4,%L80
	move 1,4
%L80:
	popj 17,

not_mem_branch_negative:
	setcm 1,(1)
	camge 1,[-1]
	seto 1,
	popj 17,

not_select:
	setca 2,
	jumpn 1,%L84
	setcm 2,3
%L84:
	move 1,2
	popj 17,

not_select_mem:
	jumpe 1,%L87
	setcm 1,(2)
%L86:
	popj 17,
%L87:
	setcm 1,(3)
	popj 17,

not_store_select:
	jumpe 1,%L89
	setcam 3,(2)
%L90:
	move 1,(2)
	popj 17,
%L89:
	setcam 4,(2)
	jrst %L90

not_call_pressure:
	push 17,10
	move 10,1
	setca 10,
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

not_mem_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	setcm 10,(1)
	pushj 17,clobber
	setcm 4,(11)
	add 10,4
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

not_store_call_pressure:
	push 17,10
	move 10,1
	setcam 2,(1)
	pushj 17,clobber
	move 1,(10)
	pop 17,10
	popj 17,

not_loop_sum:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L103:
	move 4,3
	andi 4,17
	add 4,6
	setcm 4,(4)
	add 1,4
	addi 3,1
	sojge 2,%L103	; doloop_end
	popj 17,

not_loop_update:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L114:
	move 4,3
	andi 4,17
	add 4,1
	setcmm (4)
	addi 3,1
	sojge 2,%L114	; doloop_end
	popj 17,

not_loop_update_sum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L126:
	move 4,6
	andi 4,17
	add 4,7
	setcmb (4),3
	add 1,3
	addi 6,1
	sojge 2,%L126	; doloop_end
	popj 17,

not_loop_store:
	move 5,1
	setzb 1,7
	caml 1,3
	popj 17,
	move 6,3
	subi 6,1
%L137:
	move 4,7
	andi 4,17
	move 3,2
	add 3,4
	setcm 1,(3)
	add 4,5
	movem 1,(4)
	addi 7,1
	sojge 6,%L137	; doloop_end
	popj 17,

setca:
	setca 1,
	popj 17,

setcm1:
	setca 2,
	move 1,2
	popj 17,

setcm2:
	setcm 1,(2)
	popj 17,

setcam:
	setcab 1,(2)
	popj 17,

setcmm:
	setcmb (2),1
	popj 17,

	.bss
onecmpl_g0:
	.space	4
onecmpl_g1:
	.space	4
onecmpl_ug0:
	.space	4
onecmpl_buf:
	.space	64
onecmpl_ubuf:
	.space	64
onecmpl_gp:
	.space	8
onecmpl_ugp:
	.space	8
