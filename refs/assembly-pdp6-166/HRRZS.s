
hrrzs_mem:
	hrrzs 4,(1)
	move 1,4
	popj 17,

hrrzs_mem_alt:
	hrrzs 4,(1)
	move 1,4
	popj 17,

hrrzs_mem_return_ac:
	hrrzs 4,(1)
	move 1,4
	popj 17,

hrrzs_global:
	hrrzs 1,hrrzs_ga
	popj 17,

hrrzs_global_b:
	hrrzs 1,hrrzs_gb
	popj 17,

hrrzs_array:
	andi 2,17
	add 1,2
	hrrzs 4,(1)
	move 1,4
	popj 17,

hrrzs_global_array:
	andi 1,17
	hrrzs 4,hrrzs_buf(1)
	move 1,4
	popj 17,

hrrzs_struct_a:
	hrrzs 4,(1)
	move 1,4
	popj 17,

hrrzs_struct_b:
	hrrzs 4,1(1)
	move 1,4
	popj 17,

hrrzs_global_struct_a:
	hrrzs 1,hrrzs_gp
	popj 17,

hrrzs_global_struct_b:
	hrrzs 1,hrrzs_gp+1
	popj 17,

hrrzs_indirect:
	hrrzs 4,@(1)
	move 1,4
	popj 17,

hrrzs_volatile:
	move 4,1
	move 1,(1)
	hrrz 1,1
	movem 1,(4)
	popj 17,

hrrzs_volatile_global:
	move 1,hrrzs_vga
	hrrz 1,1
	movem 1,hrrzs_vga
	popj 17,

hrrzs_add:
	hrrzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

hrrzs_sub:
	hrrzs 4,(1)
	sub 4,2
	move 1,4
	popj 17,

hrrzs_xor:
	hrrzs 4,(1)
	xor 4,2
	move 1,4
	popj 17,

hrrzs_or:
	hrrzs 4,(1)
	ior 4,2
	move 1,4
	popj 17,

hrrzs_and:
	hrrzs 4,(1)
	and 4,2
	move 1,4
	popj 17,

hrrzs_call_add:
	push 17,10
	hrrzs 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hrrzs_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	hrrzs 1,(10)
	add 1,4
	pop 17,10
	popj 17,

hrrzs_if_result_zero:
	hrrzs 4,(1)
	move 1,2
	jumpe 4,%L24
	move 1,3
%L24:
	popj 17,

hrrzs_if_result_nonzero:
	hrrzs 4,(1)
	move 1,2
	jumpn 4,%L26
	move 1,3
%L26:
	popj 17,

hrrzs_if_result_negative:
	hrrzs 4,(1)
	move 1,2
	jumpl 4,%L28
	move 1,3
%L28:
	popj 17,

hrrzs_likely:
	hrrzs 4,(1)
	move 1,4
	jumpe 4,%L32
%L30:
	popj 17,
%L32:
	movei 1,0
	popj 17,

hrrzs_unlikely:
	hrrzs 4,(1)
	move 1,4
	jumpn 4,%L33
	movei 1,0
%L33:
	popj 17,

hrrzs_left_is_zero:
	move 6,(1)
	hrrzm 6,(1)
	movei 1,0
	popj 17,

hrrzs_right_bits:
	hrrzs 4,(1)
	move 1,4
	popj 17,

hrrzs_right_nonzero:
	hrrzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hrrzs_left_zero_bool:
	move 6,(1)
	hrrzm 6,(1)
	movei 1,1
	popj 17,

hrrzs_mix_after_zero:
	hrrzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

hrrzs_source_live:
	move 3,1
	move 4,(1)
	hrrz 1,4
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hrrzs_right_source_live:
	hrrzs 4,(1)
	lsh 4,1
	move 1,4
	popj 17,

hrrzs_left_source_dead:
	move 4,(1)
	hrrz 3,4
	movem 3,(1)
	hllz 4,4
	add 3,4
	move 1,3
	popj 17,

hrrzs_two_updates:
	hrrzs 3,(1)
	hrrzs 4,(2)
	add 3,4
	move 1,3
	popj 17,

hrrzs_loop:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L50
	move 3,(6)
%L48:
	hrrzs 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L48
	movem 1,(6)
%L50:
	popj 17,

hrrzs_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L58
	move 3,(6)
%L56:
	hrrz 3,3
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L56
	movem 3,(6)
%L58:
	popj 17,

hrrzs_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L67
%L65:
	hrrzs 4,(1)
	move 3,2
	jumpe 4,%L60
	subi 2,1
	jumpg 3,%L65
%L67:
	move 3,(1)
%L60:
	move 1,3
	popj 17,

hrrzs_store_then_load:
	hrrzs 4,(1)
	move 1,4
	popj 17,

hrrzs_store_then_bool:
	hrrzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hrrzs_store_then_add:
	hrrzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhrrzs_mem:
	hrrzs 4,(1)
	move 1,4
	popj 17,

uhrrzs_global:
	hrrzs 1,hrrzs_uga
	popj 17,

uhrrzs_array:
	andi 2,17
	add 1,2
	hrrzs 4,(1)
	move 1,4
	popj 17,

uhrrzs_global_array:
	andi 1,17
	hrrzs 4,hrrzs_ubuf(1)
	move 1,4
	popj 17,

uhrrzs_struct_a:
	hrrzs 4,(1)
	move 1,4
	popj 17,

uhrrzs_global_struct_a:
	hrrzs 1,hrrzs_ugp
	popj 17,

uhrrzs_add:
	hrrzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhrrzs_bool:
	hrrzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

uhrrzs_right_bits:
	hrrzs 4,(1)
	move 1,4
	popj 17,

hrrzs_sqi_temp:
	lsh 2,33
	ash 2,-33
	hrrz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrrzs_uqi_temp:
	andi 2,777
	movem 2,(1)
	move 1,2
	popj 17,

hrrzs_hi_temp:
	hrrz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrrzs_uhi_temp:
	hrrz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

	.bss
hrrzs_ga:
	.space	4
hrrzs_gb:
	.space	4
hrrzs_uga:
	.space	4
hrrzs_vga:
	.space	4
hrrzs_buf:
	.space	64
hrrzs_ubuf:
	.space	64
hrrzs_gp:
	.space	8
hrrzs_ugp:
	.space	8
