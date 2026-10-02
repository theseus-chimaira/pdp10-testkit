
umax:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 1,2
	popj 17,

umax_commuted:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_if:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umax_if_commuted:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 1,2
	popj 17,

umax_ge:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 1,2
	popj 17,

umax_ge_commuted:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_lt:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 1,2
	popj 17,

umax_lt_commuted:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_le:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_le_commuted:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 1,2
	popj 17,

umax_zero:
	popj 17,

umax_zero_commuted:
	popj 17,

umax_one:
	move 2,1
	tlc 2,400000
	move 3,[-377777777777]
	movei 4,1
	camge 2,3
	move 1,4
	popj 17,

umax_small_positive:
	move 2,1
	tlc 2,400000
	move 3,[-377777777655]
	movei 4,123
	camge 2,3
	move 1,4
	popj 17,

umax_large_positive:
	move 2,1
	tlc 2,400000
	move 3,[-377777654322]
	movei 4,123456
	camge 2,3
	move 1,4
	popj 17,

umax_right_half:
	move 2,1
	tlc 2,400000
	hrloi 3,400000
	movei 4,777777
	camge 2,3
	move 1,4
	popj 17,

umax_left_half:
	move 2,1
	tlc 2,400000
	movsi 3,377777
	movsi 4,777777
	camge 2,3
	move 1,4
	popj 17,

umax_high_bit:
	move 2,1
	tlc 2,400000
	movei 3,0
	movsi 4,400000
	camge 2,3
	move 1,4
	popj 17,

umax_all_ones:
	seto 1,
	popj 17,

umax_const_left:
	move 2,1
	tlc 2,400000
	move 3,[-377777654322]
	movei 4,123456
	camge 2,3
	move 1,4
	popj 17,

umax_high_const_left:
	move 4,1
	jumpl 1,%L25
	movsi 4,400000
%L25:
	move 1,4
	popj 17,

umax_all_ones_left:
	seto 1,
	popj 17,

umax_mem:
	move 3,(2)
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 1,(2)
	popj 17,

umax_mem_commuted:
	move 3,1
	tlc 3,400000
	move 4,(2)
	tlc 4,400000
	camle 4,3
	move 1,(2)
	popj 17,

umax_mem_mem:
	move 3,1
	move 4,(2)
	tlc 4,400000
	move 1,(1)
	tlc 1,400000
	camge 1,4
	skipa 1,(2)
	move 1,(3)
	popj 17,

umax_global:
	move 3,umax_ga
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 1,umax_ga
	popj 17,

umax_global_commuted:
	move 3,1
	tlc 3,400000
	move 4,umax_ga
	tlc 4,400000
	camle 4,3
	move 1,umax_ga
	popj 17,

umax_global_global:
	move 4,umax_gb
	tlc 4,400000
	move 1,umax_ga
	tlc 1,400000
	camge 1,4
	skipa 1,umax_gb
	move 1,umax_ga
	popj 17,

umax_volatile_global:
	move 2,1
	move 1,umax_vga
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 1,2
	popj 17,

umax_volatile_mem:
	move 6,1
	move 1,(2)
	move 3,1
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camge 3,4
	move 1,6
	popj 17,

umax_array:
	andi 2,17
	add 1,2
	move 2,(1)
	tlc 2,400000
	move 4,3
	tlc 4,400000
	camle 2,4
	move 3,(1)
	move 1,3
	popj 17,

umax_array_commuted:
	andi 2,17
	add 1,2
	move 2,3
	tlc 2,400000
	move 4,(1)
	tlc 4,400000
	camle 4,2
	move 3,(1)
	move 1,3
	popj 17,

umax_array_array:
	andi 2,17
	add 2,1
	andi 3,17
	add 3,1
	move 4,(3)
	tlc 4,400000
	move 1,(2)
	tlc 1,400000
	camge 1,4
	skipa 1,(3)
	move 1,(2)
	popj 17,

umax_global_array:
	andi 1,17
	move 3,umax_buf(1)
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 2,umax_buf(1)
	move 1,2
	popj 17,

umax_global_array_array:
	move 4,1
	andi 4,17
	andi 2,17
	move 3,umax_buf(2)
	tlc 3,400000
	move 1,umax_buf(4)
	tlc 1,400000
	camge 1,3
	skipa 1,umax_buf(2)
	move 1,umax_buf(4)
	popj 17,

umax_struct_a:
	move 3,(1)
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 2,(1)
	move 1,2
	popj 17,

umax_struct_b:
	move 3,2
	tlc 3,400000
	move 4,1(1)
	tlc 4,400000
	camle 4,3
	move 2,1(1)
	move 1,2
	popj 17,

umax_struct_ab:
	move 3,1(1)
	tlc 3,400000
	move 4,(1)
	tlc 4,400000
	camge 4,3
	skipa 4,1(1)
	move 4,(1)
	move 1,4
	popj 17,

umax_trip_ab:
	move 3,1(1)
	tlc 3,400000
	move 4,(1)
	tlc 4,400000
	camge 4,3
	skipa 4,1(1)
	move 4,(1)
	move 1,4
	popj 17,

umax_trip_abc:
	move 3,1
	move 4,1(1)
	tlc 4,400000
	move 1,(1)
	tlc 1,400000
	camge 1,4
	skipa 1,1(3)
	move 1,(3)
	move 2,2(3)
	tlc 2,400000
	move 4,1
	tlc 4,400000
	camle 2,4
	move 1,2(3)
	popj 17,

umax_global_struct:
	move 4,umax_gp+1
	tlc 4,400000
	move 1,umax_gp
	tlc 1,400000
	camge 1,4
	skipa 1,umax_gp+1
	move 1,umax_gp
	popj 17,

umax_global_trip:
	move 4,umax_gt+1
	tlc 4,400000
	move 1,umax_gt
	tlc 1,400000
	camge 1,4
	skipa 1,umax_gt+1
	move 1,umax_gt
	move 3,umax_gt+2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 1,umax_gt+2
	popj 17,

umax_store:
	move 6,3
	tlc 6,400000
	move 4,2
	tlc 4,400000
	camge 6,4
	move 3,2
	movem 3,(1)
	popj 17,

umax_store_return:
	move 6,3
	tlc 6,400000
	move 4,2
	tlc 4,400000
	camge 6,4
	move 3,2
	movem 3,(1)
	move 1,3
	popj 17,

umax_store_global:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	movem 2,umax_ga
	popj 17,

umax_store_array:
	andi 2,17
	add 1,2
	move 6,4
	tlc 6,400000
	move 2,3
	tlc 2,400000
	camge 6,2
	move 4,3
	movem 4,(1)
	popj 17,

umax_store_struct_a:
	move 6,3
	tlc 6,400000
	move 4,2
	tlc 4,400000
	camge 6,4
	move 3,2
	movem 3,(1)
	popj 17,

umax_store_then_use:
	move 7,3
	tlc 7,400000
	move 6,2
	tlc 6,400000
	camge 7,6
	move 3,2
	movem 3,(1)
	add 4,3
	move 1,4
	popj 17,

umax_add:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	add 2,3
	move 1,2
	popj 17,

umax_sub:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	sub 2,3
	move 1,2
	popj 17,

umax_xor:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	xor 2,3
	move 1,2
	popj 17,

umax_or:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	ior 2,3
	move 1,2
	popj 17,

umax_and:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	and 2,3
	move 1,2
	popj 17,

umax_mul:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	imul 2,3
	move 1,2
	popj 17,

umax_nested_add:
	move 7,2
	tlc 7,400000
	move 6,1
	tlc 6,400000
	camge 7,6
	move 2,1
	move 6,4
	tlc 6,400000
	move 1,3
	tlc 1,400000
	camge 6,1
	move 4,3
	add 2,4
	move 1,2
	popj 17,

umax_nested_max:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	move 1,3
	tlc 1,400000
	move 4,2
	tlc 4,400000
	camge 1,4
	move 3,2
	move 1,3
	popj 17,

umax_nested_max4:
	move 7,2
	tlc 7,400000
	move 6,1
	tlc 6,400000
	camge 7,6
	move 2,1
	move 6,4
	tlc 6,400000
	move 1,3
	tlc 1,400000
	camge 6,1
	move 4,3
	move 1,4
	tlc 1,400000
	move 3,2
	tlc 3,400000
	camge 1,3
	move 4,2
	move 1,4
	popj 17,

umax_local:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_local_sources_live:
	move 6,1
	move 1,2
	tlc 1,400000
	move 4,6
	tlc 4,400000
	camle 1,4
	skipa 1,2
	move 1,6
	add 1,6
	add 1,2
	add 1,3
	popj 17,

umax_memory_sources_live:
	move 6,(1)
	move 2,(2)
	move 1,2
	tlc 1,400000
	move 4,6
	tlc 4,400000
	camle 1,4
	skipa 1,2
	move 1,6
	add 1,6
	add 1,2
	add 1,3
	popj 17,

umax_reuse_left:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_reuse_right:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_if_result_zero:
	move 7,4
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	move 1,3
	jumpe 2,%L72
	move 1,7
%L72:
	popj 17,

umax_if_result_nonzero:
	move 7,4
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	move 1,3
	jumpn 2,%L74
	move 1,7
%L74:
	popj 17,

umax_if_result_highbit:
	move 7,4
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	move 1,3
	jumpl 2,%L76
	move 1,7
%L76:
	popj 17,

umax_if_result_right_nonzero:
	move 7,4
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camge 6,4
	move 2,1
	hrrz 2,2
	move 1,3
	jumpn 2,%L78
	move 1,7
%L78:
	popj 17,

umax_likely:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umax_unlikely:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umax_after_if:
	jumpe 1,%L85
	addi 2,1
%L86:
	move 1,3
	tlc 1,400000
	move 4,2
	tlc 4,400000
	camle 1,4
	skipa 1,3
	move 1,2
	popj 17,
%L85:
	aoja 3,%L86

umax_before_if:
	move 7,4
	move 6,3
	tlc 6,400000
	move 4,2
	tlc 4,400000
	camge 6,4
	move 3,2
	move 4,3
	add 4,7
	jumpn 1,%L87
	move 4,3
	sub 4,7
%L87:
	move 1,4
	popj 17,

umax_switch:
	push 17,10
	move 7,1
	move 6,2
	move 10,3
	move 5,1
	andi 5,3
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	skipa 1,10
	move 1,2
	cain 5,1
	jrst %L89
	move 2,5
	tlc 2,400000
	move 3,4
	move 4,7
	tlc 4,400000
	camle 3,4
	skipa 1,6
	move 1,7
	camge 2,[-377777777777]
	jrst %L89
	move 3,10
	tlc 3,400000
	move 4,7
	tlc 4,400000
	camle 3,4
	skipa 1,10
	move 1,7
	cain 5,2
	jrst %L89
	move 2,4
	movei 3,0
	movsi 4,400000
	camle 2,3
	skipa 1,7
	move 1,4
%L89:
	pop 17,10
	popj 17,

umax_loop_pair:
	move 5,1
	move 1,(1)
	movei 7,1
	caml 7,2
	popj 17,
	move 6,2
	subi 6,2
%L104:
	move 4,7
	andi 4,17
	add 4,5
	move 2,(4)
	tlc 2,400000
	move 3,1
	tlc 3,400000
	camle 2,3
	move 1,(4)
	addi 7,1
	sojge 6,%L104	; doloop_end
	popj 17,

umax_loop_two_arrays:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 7,(1)
	movei 5,0
	caml 5,3
	jrst %L113
	move 6,3
	subi 6,1
%L114:
	move 3,5
	andi 3,17
	move 1,10
	add 1,3
	add 3,11
	move 2,(3)
	tlc 2,400000
	move 4,(1)
	tlc 4,400000
	camge 4,2
	skipa 4,(3)
	move 4,(1)
	move 2,4
	tlc 2,400000
	move 3,7
	tlc 3,400000
	camle 2,3
	move 7,4
	addi 5,1
	sojge 6,%L114	; doloop_end
%L113:
	move 1,7
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

umax_loop_accumulate:
	move 6,3
	subi 6,1
	jumple 3,%L121
%L119:
	move 4,2
	tlc 4,400000
	move 3,1
	tlc 3,400000
	camle 4,3
	move 1,2
	addi 2,1
	move 4,6
	subi 6,1
	jumpg 4,%L119
%L121:
	popj 17,

umax_uqi:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_uqi_si:
	andi 1,777	; zero_extendqisi2
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrzi 2,(2)	; zero_extendhisi2
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umax_uhi_si:
	hrrzi 1,(1)	; zero_extendhisi2
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

	.globl	umaxsi3_smoke
umaxsi3_smoke:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 10,2
	move 11,3
	pushj 17,umax
	move 2,10
	move 3,11
	pushj 17,umax_nested_max
	move 2,11
	move 3,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	jrst umax_add

	.globl	ux3mem
ux3mem:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	move 10,3
	pushj 17,umax_mem_mem
	move 2,1
	move 1,11
	move 3,10
	pushj 17,umax_store_return
	move 3,1
	move 1,11
	move 2,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	jrst umax_memory_sources_live

	.globl	ux3ctl
ux3ctl:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,2
	move 11,3
	pushj 17,umax_loop_pair
	move 2,1
	skipe 11
	movei 11,1
	move 1,11
	move 3,umax_ga
	move 4,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	jrst umax_before_if

	.bss
umax_ga:
	.space	4
umax_gb:
	.space	4
umax_vga:
	.space	4
umax_buf:
	.space	64
umax_gp:
	.space	8
umax_gt:
	.space	12
