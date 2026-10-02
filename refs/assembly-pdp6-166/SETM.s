
setm_mem:
	move 1,(1)
	popj 17,

setm_mem_2:
	movei 4,0
	skipe (2)
	move 4,(1)
	move 1,4
	popj 17,

setm_global_a:
	move 1,setm_ga
	popj 17,

setm_global_b:
	move 1,setm_gb
	popj 17,

setm_array:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

setm_global_array:
	andi 1,17
	move 1,setm_buf(1)
	popj 17,

setm_struct_a:
	move 1,(1)
	popj 17,

setm_struct_b:
	move 1,1(1)
	popj 17,

setm_global_struct_a:
	move 1,setm_gp
	popj 17,

setm_global_struct_b:
	move 1,setm_gp+1
	popj 17,

setm_indirect:
	move 1,@(1)
	popj 17,

setm_volatile:
	move 1,(1)
	popj 17,

setmi_small:
	movei 1,123456
	popj 17,

setmi_one:
	movei 1,1
	popj 17,

setmi_low18:
	movei 1,777777
	popj 17,

setmi_alt:
	movei 1,525252
	popj 17,

setmi_sparse:
	movei 1,707070
	popj 17,

setmi_fullword:
	move 1,[123456123456]
	popj 17,

setmi_left:
	movsi 1,123456
	popj 17,

setmi_right:
	movei 1,123456
	popj 17,

setmi_sign:
	movsi 1,400000
	popj 17,

setmi_mixed:
	move 1,[-252525525253]
	popj 17,

setmm_self:
	popj 17,

setmm_global_a:
	popj 17,

setmm_global_b:
	popj 17,

setmm_array:
	popj 17,

setmm_global_array:
	popj 17,

setmm_struct_a:
	popj 17,

setmm_struct_b:
	popj 17,

setmm_global_struct_a:
	popj 17,

setmm_global_struct_b:
	popj 17,

setmm_indirect:
	popj 17,

setmm_volatile:
	move 6,(1)
	movem 6,(1)
	popj 17,

setmm_volatile_global_a:
	move 6,setm_ga
	movem 6,setm_ga
	popj 17,

setmm_volatile_array:
	andi 2,17
	add 1,2
	move 6,(1)
	movem 6,(1)
	popj 17,

setmm_volatile_struct_a:
	move 6,(1)
	movem 6,(1)
	popj 17,

setmb_mem:
	move 1,(1)
	popj 17,

setmb_mem_temp:
	move 1,(1)
	popj 17,

setmb_global_a:
	move 1,setm_ga
	popj 17,

setmb_global_b:
	move 1,setm_gb
	popj 17,

setmb_array:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

setmb_array_temp:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

setmb_global_array:
	andi 1,17
	move 1,setm_buf(1)
	popj 17,

setmb_struct_a:
	move 1,(1)
	popj 17,

setmb_struct_b:
	move 1,1(1)
	popj 17,

setmb_struct_a_temp:
	move 1,(1)
	popj 17,

setmb_struct_b_temp:
	move 1,1(1)
	popj 17,

setmb_global_struct_a:
	move 1,setm_gp
	popj 17,

setmb_global_struct_b:
	move 1,setm_gp+1
	popj 17,

setmb_indirect:
	move 1,@(1)
	popj 17,

setmb_volatile:
	move 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

setmb_volatile_array:
	andi 2,17
	add 1,2
	move 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

setmb_volatile_struct_a:
	move 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

setm_copy_mem:
	move 2,(2)
	movem 2,(1)
	popj 17,

setm_copy_mem_return:
	move 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

setm_copy_global_to_mem:
	move 6,setm_ga
	movem 6,(1)
	popj 17,

setm_copy_mem_to_global:
	move 1,(1)
	movem 1,setm_ga
	popj 17,

setm_copy_mem_to_global_return:
	move 1,(1)
	movem 1,setm_ga
	popj 17,

setm_copy_array:
	andi 3,17
	add 1,3
	add 3,2
	move 3,(3)
	movem 3,(1)
	popj 17,

setm_copy_array_return:
	move 4,1
	andi 3,17
	add 2,3
	move 1,(2)
	add 3,4
	movem 1,(3)
	popj 17,

setm_copy_struct:
	move 2,(2)
	movem 2,(1)
	popj 17,

setm_copy_struct_return:
	move 4,1(2)
	movem 4,1(1)
	move 1,4
	popj 17,

usetm_mem:
	move 1,(1)
	popj 17,

usetm_global:
	move 1,setm_uga
	popj 17,

usetm_array:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

usetm_global_array:
	andi 1,17
	move 1,setm_ubuf(1)
	popj 17,

usetm_struct_a:
	move 1,(1)
	popj 17,

usetm_global_struct_a:
	move 1,setm_ugp
	popj 17,

usetmi_small:
	movei 1,123456
	popj 17,

usetmi_low18:
	movei 1,777777
	popj 17,

usetmi_fullword:
	move 1,[123456123456]
	popj 17,

usetmm_self:
	popj 17,

usetmm_global:
	popj 17,

usetmm_array:
	popj 17,

usetmm_volatile:
	move 6,(1)
	movem 6,(1)
	popj 17,

usetmb_mem:
	move 1,(1)
	popj 17,

usetmb_mem_temp:
	move 1,(1)
	popj 17,

usetmb_global:
	move 1,setm_uga
	popj 17,

usetmb_array:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

setm_qi:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

setm_uqi:
	ldb 1,1
	popj 17,

setm_hi:
	ldb 1,1
	hrre 1,1
	popj 17,

setm_uhi:
	ldb 1,1
	popj 17,

setmm_qi:
	popj 17,

setmm_uqi:
	popj 17,

setmm_hi:
	popj 17,

setmm_uhi:
	popj 17,

setmb_qi:
	move 4,1
	ldb 1,1
	dpb 1,4
	lsh 1,33
	ash 1,-33
	popj 17,

setmb_uqi:
	ldb 4,1
	dpb 4,1
	move 1,4
	popj 17,

setmb_hi:
	move 4,1
	ldb 1,1
	dpb 1,4	; movhi
	hrre 1,1	; extendhisi2
	popj 17,

setmb_uhi:
	ldb 4,1
	dpb 4,1	; movhi
	move 1,4
	popj 17,

setm_select:
	jumpe 3,%L118
	move 1,(1)
%L117:
	popj 17,
%L118:
	move 1,(2)
	popj 17,

setm_after_call:
	push 17,10
	move 10,1
	pushj 17,f
	move 1,(10)
	pop 17,10
	popj 17,

setm_store_two_from_source:
	move 1,(1)
	movem 1,(2)
	movem 1,(3)
	popj 17,

setm_reload_chain:
	move 4,(1)
	movem 4,1(1)
	move 1,4
	popj 17,

	.bss
setm_ga:
	.space	4
setm_gb:
	.space	4
setm_uga:
	.space	4
setm_buf:
	.space	64
setm_ubuf:
	.space	64
setm_gp:
	.space	8
setm_ugp:
	.space	8
