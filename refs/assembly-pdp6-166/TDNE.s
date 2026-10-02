	.data
	.align	2
tdne_mask_a:
	.word	123456123456
	.align	2
tdne_mask_b:
	.word	525252252525

tdne_clear_lit_a:
	tdne 1,[123456123456]
	movei 1,0
	popj 17,

tdne_clear_lit_b:
	tdne 1,[-252525525253]
	movei 1,0
	popj 17,

tdne_clear_lit_c:
	tdne 1,[-70707707071]
	movei 1,0
	popj 17,

tdne_clear_lit_d:
	tdne 1,[-377777777001]
	movei 1,0
	popj 17,

tdne_clear_likely_lit_a:
	tdne 1,[123456123456]
	movei 1,0
	popj 17,

tdne_clear_likely_lit_b:
	tdne 1,[-252525525253]
	movei 1,0
	popj 17,

tdne_clear_unlikely_lit_a:
	tdnn 1,[123456123456]
%L14:
	popj 17,
	movei 1,0
	popj 17,

tdne_clear_unlikely_lit_b:
	tdnn 1,[-252525525253]
%L17:
	popj 17,
	movei 1,0
	popj 17,

tdne_bool_lit_a:
	and 1,[123456123456]
	skipe 1
	movei 1,1
	popj 17,

tdne_bool_lit_b:
	and 1,[-252525525253]
	skipe 1
	movei 1,1
	popj 17,

tdne_select_lit_a:
	tdnn 1,[123456123456]
	move 2,3
	move 1,2
	popj 17,

tdne_select_lit_b:
	tdnn 1,[-252525525253]
	move 2,3
	move 1,2
	popj 17,

tdne_mem:
	tdne 1,(2)
	movei 1,0
	popj 17,

tdne_mem_likely:
	tdne 1,(2)
	movei 1,0
	popj 17,

tdne_mem_unlikely:
	tdnn 1,(2)
%L30:
	popj 17,
	movei 1,0
	popj 17,

tdne_mem_bool:
	and 1,(2)
	skipe 1
	movei 1,1
	popj 17,

tdne_mem_select:
	tdnn 1,(2)
	move 3,4
	move 1,3
	popj 17,

tdne_mem_call:
	tdnn 1,(2)
%L36:
	popj 17,
	pushj 17,f
	popj 17,

tdne_mem_call_likely:
	tdne 1,(2)
	pushj 17,f
	popj 17,

tdne_mem_call_unlikely:
	tdnn 1,(2)
%L41:
	popj 17,
	pushj 17,f
	popj 17,

tdne_global_a:
	tdne 1,tdne_ga
	movei 1,0
	popj 17,

tdne_global_b:
	tdne 1,tdne_gb
	movei 1,0
	popj 17,

tdne_static_mask_a:
	tdne 1,tdne_mask_a
	movei 1,0
	popj 17,

tdne_static_mask_b:
	tdne 1,tdne_mask_b
	movei 1,0
	popj 17,

tdne_global_bool:
	and 1,tdne_ga
	skipe 1
	movei 1,1
	popj 17,

tdne_global_select:
	tdnn 1,tdne_ga
	move 2,3
	move 1,2
	popj 17,

tdne_global_call:
	tdnn 1,tdne_ga
%L55:
	popj 17,
	pushj 17,f
	popj 17,

tdne_array:
	andi 3,17
	add 2,3
	tdne 1,(2)
	movei 1,0
	popj 17,

tdne_array_bool:
	andi 3,17
	add 2,3
	and 1,(2)
	skipe 1
	movei 1,1
	popj 17,

tdne_array_call:
	andi 3,17
	add 2,3
	tdnn 1,(2)
%L63:
	popj 17,
	pushj 17,f
	popj 17,

tdne_global_array:
	andi 2,17
	tdne 1,tdne_buf(2)
	movei 1,0
	popj 17,

tdne_global_array_bool:
	andi 2,17
	and 1,tdne_buf(2)
	skipe 1
	movei 1,1
	popj 17,

tdne_global_array_call:
	andi 2,17
	tdnn 1,tdne_buf(2)
%L70:
	popj 17,
	pushj 17,f
	popj 17,

tdne_struct_a:
	tdne 1,(2)
	movei 1,0
	popj 17,

tdne_struct_b:
	tdne 1,1(2)
	movei 1,0
	popj 17,

tdne_struct_a_bool:
	and 1,(2)
	skipe 1
	movei 1,1
	popj 17,

tdne_struct_b_bool:
	and 1,1(2)
	skipe 1
	movei 1,1
	popj 17,

tdne_global_struct_a:
	tdne 1,tdne_gp
	movei 1,0
	popj 17,

tdne_global_struct_b:
	tdne 1,tdne_gp+1
	movei 1,0
	popj 17,

tdne_indirect:
	tdne 1,@(2)
	movei 1,0
	popj 17,

tdne_volatile:
	move 4,(2)
	tdne 1,4
	movei 1,0
	popj 17,

tdne_volatile_bool:
	move 4,1
	move 1,(2)
	and 1,4
	skipe 1
	movei 1,1
	popj 17,

tdne_computed_mask:
	xor 2,[123456123456]
	tdne 1,2
	movei 1,0
	popj 17,

tdne_computed_mask_2:
	ior 2,[-252525525253]
	tdne 1,2
	movei 1,0
	popj 17,

tdne_loaded_mask:
	tdne 1,(2)
	movei 1,0
	popj 17,

tdne_loaded_mask_call:
	tdnn 1,(2)
%L94:
	popj 17,
	pushj 17,f
	popj 17,

utdne_mem:
	tdne 1,(2)
	movei 1,0
	popj 17,

utdne_literal:
	tdne 1,[123456123456]
	movei 1,0
	popj 17,

utdne_bool:
	and 1,(2)
	skipe 1
	movei 1,1
	popj 17,

tdne_qi:
	ldb 2,2
	tdne 1,2
	movei 1,0
	popj 17,

tdne_hi:
	ldb 2,2
	tdne 1,2
	movei 1,0
	popj 17,

tdne_qi_bool:
	ldb 2,2
	and 1,2
	skipe 1
	movei 1,1
	popj 17,

tdne_hi_bool:
	ldb 2,2
	and 1,2
	skipe 1
	movei 1,1
	popj 17,

	.bss
tdne_ga:
	.space	4
tdne_gb:
	.space	4
tdne_buf:
	.space	64
tdne_gp:
	.space	8
