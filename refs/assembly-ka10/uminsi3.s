
umin:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 1,2
	popj 17,

umin_commuted:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_if:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umin_if_commuted:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 1,2
	popj 17,

umin_le:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 1,2
	popj 17,

umin_le_commuted:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_gt:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 1,2
	popj 17,

umin_gt_commuted:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_ge:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_ge_commuted:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 1,2
	popj 17,

umin_zero:
	movei 1,0
	popj 17,

umin_zero_commuted:
	movei 1,0
	popj 17,

umin_one:
	skipe 1
	movei 1,1
	popj 17,

umin_small_positive:
	move 2,1
	tlc 2,400000
	move 3,[-377777777655]
	movei 4,123
	camle 2,3
	move 1,4
	popj 17,

umin_large_positive:
	move 2,1
	tlc 2,400000
	move 3,[-377777654322]
	movei 4,123456
	camle 2,3
	move 1,4
	popj 17,

umin_right_half:
	move 2,1
	tlc 2,400000
	hrloi 3,400000
	movei 4,777777
	camle 2,3
	move 1,4
	popj 17,

umin_left_half:
	move 2,1
	tlc 2,400000
	movsi 3,377777
	movsi 4,777777
	camle 2,3
	move 1,4
	popj 17,

umin_high_bit:
	move 4,1
	jumpl 1,%L25
%L24:
	move 1,4
	popj 17,
%L25:
	movsi 4,400000
	jrst %L24

umin_all_ones:
	move 2,1
	tlc 2,400000
	hrloi 3,377777
	seto 4,
	camle 2,3
	move 1,4
	popj 17,

umin_const_left:
	move 2,1
	tlc 2,400000
	move 3,[-377777654322]
	movei 4,123456
	camle 2,3
	move 1,4
	popj 17,

umin_high_const_left:
	move 2,1
	tlc 2,400000
	movei 3,0
	movsi 4,400000
	camle 2,3
	move 1,4
	popj 17,

umin_all_ones_left:
	popj 17,

umin_mem:
	move 3,(2)
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 1,(2)
	popj 17,

umin_mem_commuted:
	move 3,1
	tlc 3,400000
	move 4,(2)
	tlc 4,400000
	camge 4,3
	move 1,(2)
	popj 17,

umin_mem_mem:
	move 3,1
	move 4,(2)
	tlc 4,400000
	move 1,(1)
	tlc 1,400000
	camle 1,4
	skipa 1,(2)
	move 1,(3)
	popj 17,

umin_global:
	move 3,umin_ga
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 1,umin_ga
	popj 17,

umin_global_commuted:
	move 3,1
	tlc 3,400000
	move 4,umin_ga
	tlc 4,400000
	camge 4,3
	move 1,umin_ga
	popj 17,

umin_global_global:
	move 4,umin_gb
	tlc 4,400000
	move 1,umin_ga
	tlc 1,400000
	camle 1,4
	skipa 1,umin_gb
	move 1,umin_ga
	popj 17,

umin_volatile_global:
	move 2,1
	move 1,umin_vga
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	move 1,2
	popj 17,

umin_volatile_mem:
	move 6,1
	move 1,(2)
	move 3,1
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	move 1,6
	popj 17,

umin_array:
	andi 2,17
	add 1,2
	move 2,(1)
	tlc 2,400000
	move 4,3
	tlc 4,400000
	camge 2,4
	move 3,(1)
	move 1,3
	popj 17,

umin_array_commuted:
	andi 2,17
	add 1,2
	move 2,3
	tlc 2,400000
	move 4,(1)
	tlc 4,400000
	camge 4,2
	move 3,(1)
	move 1,3
	popj 17,

umin_array_array:
	andi 2,17
	add 2,1
	andi 3,17
	add 3,1
	move 4,(3)
	tlc 4,400000
	move 1,(2)
	tlc 1,400000
	camle 1,4
	skipa 1,(3)
	move 1,(2)
	popj 17,

umin_global_array:
	andi 1,17
	move 3,umin_buf(1)
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 2,umin_buf(1)
	move 1,2
	popj 17,

umin_global_array_array:
	move 4,1
	andi 4,17
	andi 2,17
	move 3,umin_buf(2)
	tlc 3,400000
	move 1,umin_buf(4)
	tlc 1,400000
	camle 1,3
	skipa 1,umin_buf(2)
	move 1,umin_buf(4)
	popj 17,

umin_struct_a:
	move 3,(1)
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 2,(1)
	move 1,2
	popj 17,

umin_struct_b:
	move 3,2
	tlc 3,400000
	move 4,1(1)
	tlc 4,400000
	camge 4,3
	move 2,1(1)
	move 1,2
	popj 17,

umin_struct_ab:
	move 3,1(1)
	tlc 3,400000
	move 4,(1)
	tlc 4,400000
	camle 4,3
	skipa 4,1(1)
	move 4,(1)
	move 1,4
	popj 17,

umin_trip_ab:
	move 3,1(1)
	tlc 3,400000
	move 4,(1)
	tlc 4,400000
	camle 4,3
	skipa 4,1(1)
	move 4,(1)
	move 1,4
	popj 17,

umin_trip_abc:
	move 3,1
	move 4,1(1)
	tlc 4,400000
	move 1,(1)
	tlc 1,400000
	camle 1,4
	skipa 1,1(3)
	move 1,(3)
	move 2,2(3)
	tlc 2,400000
	move 4,1
	tlc 4,400000
	camge 2,4
	move 1,2(3)
	popj 17,

umin_global_struct:
	move 4,umin_gp+1
	tlc 4,400000
	move 1,umin_gp
	tlc 1,400000
	camle 1,4
	skipa 1,umin_gp+1
	move 1,umin_gp
	popj 17,

umin_global_trip:
	move 4,umin_gtrip+1
	tlc 4,400000
	move 1,umin_gtrip
	tlc 1,400000
	camle 1,4
	skipa 1,umin_gtrip+1
	move 1,umin_gtrip
	move 3,umin_gtrip+2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	move 1,umin_gtrip+2
	popj 17,

umin_store:
	move 6,3
	tlc 6,400000
	move 4,2
	tlc 4,400000
	camle 6,4
	move 3,2
	movem 3,(1)
	popj 17,

umin_store_return:
	move 6,3
	tlc 6,400000
	move 4,2
	tlc 4,400000
	camle 6,4
	move 3,2
	movem 3,(1)
	move 1,3
	popj 17,

umin_store_global:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	movem 2,umin_ga
	popj 17,

umin_store_array:
	andi 2,17
	add 1,2
	move 6,4
	tlc 6,400000
	move 2,3
	tlc 2,400000
	camle 6,2
	move 4,3
	movem 4,(1)
	popj 17,

umin_store_struct_a:
	move 6,3
	tlc 6,400000
	move 4,2
	tlc 4,400000
	camle 6,4
	move 3,2
	movem 3,(1)
	popj 17,

umin_store_then_use:
	move 7,3
	tlc 7,400000
	move 6,2
	tlc 6,400000
	camle 7,6
	move 3,2
	movem 3,(1)
	add 4,3
	move 1,4
	popj 17,

umin_add:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	add 2,3
	move 1,2
	popj 17,

umin_sub:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	sub 2,3
	move 1,2
	popj 17,

umin_xor:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	xor 2,3
	move 1,2
	popj 17,

umin_or:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	ior 2,3
	move 1,2
	popj 17,

umin_and:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	and 2,3
	move 1,2
	popj 17,

umin_mul:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	imul 2,3
	move 1,2
	popj 17,

umin_nested_add:
	move 7,2
	tlc 7,400000
	move 6,1
	tlc 6,400000
	camle 7,6
	move 2,1
	move 6,4
	tlc 6,400000
	move 1,3
	tlc 1,400000
	camle 6,1
	move 4,3
	add 2,4
	move 1,2
	popj 17,

umin_nested_min:
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	move 1,3
	tlc 1,400000
	move 4,2
	tlc 4,400000
	camle 1,4
	move 3,2
	move 1,3
	popj 17,

umin_nested_min4:
	move 7,2
	tlc 7,400000
	move 6,1
	tlc 6,400000
	camle 7,6
	move 2,1
	move 6,4
	tlc 6,400000
	move 1,3
	tlc 1,400000
	camle 6,1
	move 4,3
	move 1,4
	tlc 1,400000
	move 3,2
	tlc 3,400000
	camle 1,3
	move 4,2
	move 1,4
	popj 17,

umin_local:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_local_sources_live:
	move 6,1
	move 1,2
	tlc 1,400000
	move 4,6
	tlc 4,400000
	camge 1,4
	skipa 1,2
	move 1,6
	add 1,6
	add 1,2
	add 1,3
	popj 17,

umin_memory_sources_live:
	move 6,(1)
	move 2,(2)
	move 1,2
	tlc 1,400000
	move 4,6
	tlc 4,400000
	camge 1,4
	skipa 1,2
	move 1,6
	add 1,6
	add 1,2
	add 1,3
	popj 17,

umin_reuse_left:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_reuse_right:
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_if_result_zero:
	move 7,4
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	move 1,3
	jumpe 2,%L75
	move 1,7
%L75:
	popj 17,

umin_if_result_nonzero:
	move 7,4
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	move 1,3
	jumpn 2,%L77
	move 1,7
%L77:
	popj 17,

umin_if_result_highbit:
	move 7,4
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	move 1,3
	jumpl 2,%L79
	move 1,7
%L79:
	popj 17,

umin_if_result_right_nonzero:
	move 7,4
	move 6,2
	tlc 6,400000
	move 4,1
	tlc 4,400000
	camle 6,4
	move 2,1
	hrrz 2,2
	move 1,3
	jumpn 2,%L81
	move 1,7
%L81:
	popj 17,

umin_likely:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umin_unlikely:
	move 3,1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	move 2,1
	move 1,2
	popj 17,

umin_after_if:
	jumpe 1,%L88
	addi 2,1
%L89:
	move 1,3
	tlc 1,400000
	move 4,2
	tlc 4,400000
	camge 1,4
	skipa 1,3
	move 1,2
	popj 17,
%L88:
	aoja 3,%L89

umin_before_if:
	move 7,4
	move 6,3
	tlc 6,400000
	move 4,2
	tlc 4,400000
	camle 6,4
	move 3,2
	move 4,3
	add 4,7
	jumpn 1,%L90
	move 4,3
	sub 4,7
%L90:
	move 1,4
	popj 17,

umin_switch:
	push 17,10
	move 6,1
	move 7,2
	move 10,3
	move 5,1
	andi 5,3
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camge 3,4
	skipa 1,10
	move 1,2
	cain 5,1
	jrst %L92
	move 2,5
	tlc 2,400000
	move 3,4
	move 4,6
	tlc 4,400000
	camge 3,4
	skipa 1,7
	move 1,6
	camge 2,[-377777777777]
	jrst %L92
	move 3,10
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camge 3,4
	skipa 1,10
	move 1,6
	cain 5,2
	jrst %L92
	move 1,6
	jumpl 6,%L101
%L92:
	pop 17,10
	popj 17,
%L101:
	movsi 1,400000
	jrst %L92

umin_loop_pair:
	move 5,1
	move 1,(1)
	movei 7,1
	caml 7,2
	popj 17,
	move 6,2
	subi 6,2
%L110:
	move 4,7
	andi 4,17
	add 4,5
	move 2,(4)
	tlc 2,400000
	move 3,1
	tlc 3,400000
	camge 2,3
	move 1,(4)
	addi 7,1
	sojge 6,%L110	; doloop_end
	popj 17,

umin_loop_two_arrays:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 7,(1)
	movei 5,0
	caml 5,3
	jrst %L119
	move 6,3
	subi 6,1
%L120:
	move 3,5
	andi 3,17
	move 1,10
	add 1,3
	add 3,11
	move 2,(3)
	tlc 2,400000
	move 4,(1)
	tlc 4,400000
	camle 4,2
	skipa 4,(3)
	move 4,(1)
	move 2,4
	tlc 2,400000
	move 3,7
	tlc 3,400000
	camge 2,3
	move 7,4
	addi 5,1
	sojge 6,%L120	; doloop_end
%L119:
	move 1,7
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

umin_loop_accumulate:
	move 6,3
	subi 6,1
	jumple 3,%L127
%L125:
	move 4,2
	tlc 4,400000
	move 3,1
	tlc 3,400000
	camge 4,3
	move 1,2
	addi 2,1
	move 4,6
	subi 6,1
	jumpg 4,%L125
%L127:
	popj 17,

umin_uqi:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_uqi_si:
	andi 1,777	; zero_extendqisi2
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrzi 2,(2)	; zero_extendhisi2
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

umin_uhi_si:
	hrrzi 1,(1)	; zero_extendhisi2
	move 3,2
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	move 2,1
	move 1,2
	popj 17,

	.globl	uminsi3_smoke
uminsi3_smoke:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 10,2
	move 11,3
	pushj 17,umin
	move 2,10
	move 3,11
	pushj 17,umin_nested_min
	move 2,11
	move 3,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	jrst umin_add

	.globl	un3mem
un3mem:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	move 10,3
	pushj 17,umin_mem_mem
	move 2,1
	move 1,11
	move 3,10
	pushj 17,umin_store_return
	move 3,1
	move 1,11
	move 2,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	jrst umin_memory_sources_live

	.globl	un3ctl
un3ctl:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,2
	move 11,3
	pushj 17,umin_loop_pair
	move 2,1
	skipe 11
	movei 11,1
	move 1,11
	move 3,umin_ga
	move 4,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	jrst umin_before_if

	.bss
umin_ga:
	.space	4
umin_gb:
	.space	4
umin_vga:
	.space	4
umin_buf:
	.space	64
umin_gp:
	.space	8
umin_gtrip:
	.space	12
