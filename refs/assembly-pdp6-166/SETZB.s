
setzb_mem_return:
	setzb 1,(1)
	popj 17,

setzb_mem_return_zero:
	setzb 1,(1)
	popj 17,

setzb_global_a:
	setzb 1,setzb_ga
	popj 17,

setzb_global_b:
	setzb 1,setzb_gb
	popj 17,

setzb_array:
	andi 2,17
	add 1,2
	setzb 1,(1)
	popj 17,

setzb_global_array:
	andi 1,17
	setzb 1,setzb_buf(1)
	popj 17,

setzb_struct_a:
	setzb 1,(1)
	popj 17,

setzb_struct_b:
	setzb 1,1(1)
	popj 17,

setzb_global_struct_a:
	setzb 1,setzb_gp
	popj 17,

setzb_global_struct_b:
	setzb 1,setzb_gp+1
	popj 17,

setzb_indirect:
	setzb 1,@(1)
	popj 17,

setzb_volatile:
	setzm (1)
	move 1,(1)
	popj 17,

setzb_two_mem:
	setzm (1)
	setzb 1,(2)
	popj 17,

setzb_chain:
	setzm (1)
	setzb 1,(2)
	popj 17,

setzb_after_expr:
	setzb 1,(1)
	popj 17,

setzb_branch:
	setzb 1,(1)
	popj 17,

setzb_local_store:
	setzb 1,(1)
	popj 17,

setzb_local_store_load:
	setzb 1,(1)
	popj 17,

usetzb_mem_return:
	setzb 1,(1)
	popj 17,

usetzb_mem_return_zero:
	setzb 1,(1)
	popj 17,

usetzb_global:
	setzb 1,setzb_uga
	popj 17,

usetzb_array:
	andi 2,17
	add 1,2
	setzb 1,(1)
	popj 17,

usetzb_global_array:
	andi 1,17
	setzb 1,setzb_ubuf(1)
	popj 17,

usetzb_struct_a:
	setzb 1,(1)
	popj 17,

usetzb_struct_b:
	setzb 1,1(1)
	popj 17,

usetzb_global_struct_a:
	setzb 1,setzb_ugp
	popj 17,

usetzb_global_struct_b:
	setzb 1,setzb_ugp+1
	popj 17,

setzb_qi_return:
	movei 4,0
	dpb 4,1
	movei 1,0
	popj 17,

setzb_uqi_return:
	movei 4,0
	dpb 4,1
	movei 1,0
	popj 17,

setzb_hi_return:
	movei 4,0
	dpb 4,1	; movhi
	movei 1,0
	popj 17,

setzb_uhi_return:
	movei 4,0
	dpb 4,1	; movhi
	movei 1,0
	popj 17,

setzb_qi_promote:
	movei 4,0
	dpb 4,1
	movei 1,0
	popj 17,

setzb_uqi_promote:
	movei 4,0
	dpb 4,1
	movei 1,0
	popj 17,

setzb_hi_promote:
	movei 4,0
	dpb 4,1	; movhi
	movei 1,0
	popj 17,

setzb_uhi_promote:
	movei 4,0
	dpb 4,1	; movhi
	movei 1,0
	popj 17,

setzb_memaa:
	setzb 1,(2)
	popj 17,

setzb_memab:
	setzb 1,(2)
	popj 17,

setzb_memba:
	setzb 1,(2)
	popj 17,

setzb_membb:
	setzb 1,(2)
	popj 17,

usetzb_memaa:
	setzb 1,(2)
	popj 17,

usetzb_memab:
	setzb 1,(2)
	popj 17,

usetzb_memba:
	setzb 1,(2)
	popj 17,

usetzb_membb:
	setzb 1,(2)
	popj 17,

	.bss
setzb_ga:
	.space	4
setzb_gb:
	.space	4
setzb_uga:
	.space	4
setzb_buf:
	.space	64
setzb_ubuf:
	.space	64
setzb_gp:
	.space	8
setzb_ugp:
	.space	8
