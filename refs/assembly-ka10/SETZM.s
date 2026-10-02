
setzm_sint:
	setzm (1)
	popj 17,

setzm_usint:
	setzm (1)
	popj 17,

setzm_sfloat:
	setzm (1)	; movsf
	popj 17,

setzm_dfloat:
	setzm (1)
	setzm 1(1)
	popj 17,

setzm_dint:
	setzm (1)
	setzm 1(1)
	popj 17,

setzm_udint:
	setzm (1)
	setzm 1(1)
	popj 17,

setzm_global_sint:
	setzm setzm_ga
	popj 17,

setzm_global_sint_b:
	setzm setzm_gb
	popj 17,

setzm_global_usint:
	setzm setzm_uga
	popj 17,

setzm_global_sfloat:
	setzm setzm_fa	; movsf
	popj 17,

setzm_global_sfloat_b:
	setzm setzm_fb	; movsf
	popj 17,

setzm_global_dfloat:
	setzm setzm_dfa	; movdf
	setzm setzm_dfa+1	; movdf
	popj 17,

setzm_global_dfloat_b:
	setzm setzm_dfb	; movdf
	setzm setzm_dfb+1	; movdf
	popj 17,

setzm_global_dint:
	setzm setzm_da
	setzm setzm_da+1
	popj 17,

setzm_global_udint:
	setzm setzm_uda
	setzm setzm_uda+1
	popj 17,

setzm_array_sint:
	andi 2,17
	add 1,2
	setzm (1)
	popj 17,

setzm_array_usint:
	andi 2,17
	add 1,2
	setzm (1)
	popj 17,

setzm_array_sfloat:
	andi 2,17
	add 1,2
	setzm (1)	; movsf
	popj 17,

setzm_array_dfloat:
	andi 2,7
	lsh 2,1
	add 2,1
	setzm (2)
	setzm 1(2)
	popj 17,

setzm_array_dint:
	andi 2,7
	lsh 2,1
	add 2,1
	setzm (2)
	setzm 1(2)
	popj 17,

setzm_global_array_sint:
	andi 1,17
	setzm setzm_buf(1)
	popj 17,

setzm_global_array_usint:
	andi 1,17
	setzm setzm_ubuf(1)
	popj 17,

setzm_global_array_sfloat:
	andi 1,17
	setzm setzm_fbuf(1)	; movsf
	popj 17,

setzm_global_array_dfloat:
	andi 1,7
	lsh 1,1
	setzm setzm_dfbuf(1)
	setzm setzm_dfbuf+1(1)
	popj 17,

setzm_global_array_dint:
	andi 1,7
	lsh 1,1
	setzm setzm_dbuf(1)
	setzm setzm_dbuf+1(1)
	popj 17,

setzm_struct_a:
	setzm (1)
	popj 17,

setzm_struct_b:
	setzm 1(1)
	popj 17,

setzm_global_struct_a:
	setzm setzm_gp
	popj 17,

setzm_global_struct_b:
	setzm setzm_gp+1
	popj 17,

setzm_mixed_sint:
	setzm (1)
	popj 17,

setzm_mixed_usint:
	setzm 1(1)
	popj 17,

setzm_mixed_sfloat:
	setzm 2(1)	; movsf
	popj 17,

setzm_mixed_dfloat:
	setzm 3(1)
	setzm 4(1)
	popj 17,

setzm_mixed_dint:
	setzm 5(1)
	setzm 6(1)
	popj 17,

setzm_global_mixed_sint:
	setzm setzm_gm
	popj 17,

setzm_global_mixed_usint:
	setzm setzm_gm+1
	popj 17,

setzm_global_mixed_sfloat:
	setzm setzm_gm+2	; movsf
	popj 17,

setzm_global_mixed_dfloat:
	setzm setzm_gm+3
	setzm setzm_gm+4
	popj 17,

setzm_global_mixed_dint:
	setzm setzm_gm+5
	setzm setzm_gm+6
	popj 17,

setzm_indirect:
	setzm @(1)
	popj 17,

setzm_dindirect:
	move 4,(1)
	setzm (4)
	setzm 1(4)
	popj 17,

setzm_volatile_sint:
	setzm (1)
	popj 17,

setzm_volatile_usint:
	setzm (1)
	popj 17,

setzm_volatile_sfloat:
	setzm (1)	; movsf
	popj 17,

setzm_two_sint:
	setzm (1)
	setzm (2)
	popj 17,

setzm_two_mixed:
	setzm (1)
	setzm (2)	; movsf
	popj 17,

setzm_three_globals:
	setzm setzm_ga
	setzm setzm_gb
	setzm setzm_uga
	popj 17,

setzm_qi:
	movei 4,0
	dpb 4,1
	popj 17,

setzm_uqi:
	movei 4,0
	dpb 4,1
	popj 17,

setzm_hi:
	movei 4,0
	dpb 4,1	; movhi
	popj 17,

setzm_uhi:
	movei 4,0
	dpb 4,1	; movhi
	popj 17,

setzm_qi_array:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L60
%L59:
	ibp 1
	sojn 4,%L59	; decrement_and_branch_until_zero
%L60:
	movei 4,0
	dpb 4,1
	popj 17,

setzm_uqi_array:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L64
%L63:
	ibp 1
	sojn 4,%L63	; decrement_and_branch_until_zero
%L64:
	movei 4,0
	dpb 4,1
	popj 17,

setzm_hi_array:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L68
%L67:
	ibp 1
	sojn 4,%L67	; decrement_and_branch_until_zero
%L68:
	movei 4,0
	dpb 4,1	; movhi
	popj 17,

setzm_uhi_array:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L72
%L71:
	ibp 1
	sojn 4,%L71	; decrement_and_branch_until_zero
%L72:
	movei 4,0
	dpb 4,1	; movhi
	popj 17,

setzm_from_branch:
	setzm (1)
	popj 17,

setzm_after_expr:
	setzm (1)
	popj 17,

setzm_store_then_return_old_shape:
	addi 2,1
	setzm (1)
	move 1,2
	popj 17,

	.bss
setzm_ga:
	.space	4
setzm_gb:
	.space	4
setzm_uga:
	.space	4
setzm_fa:
	.space	4
setzm_fb:
	.space	4
setzm_dfa:
	.space	8
setzm_dfb:
	.space	8
setzm_da:
	.space	8
setzm_uda:
	.space	8
setzm_buf:
	.space	64
setzm_ubuf:
	.space	64
setzm_fbuf:
	.space	64
setzm_dfbuf:
	.space	64
setzm_dbuf:
	.space	64
setzm_gp:
	.space	8
setzm_gm:
	.space	28
