
ldb_uqi:
	ldb 1,1
	popj 17,

ldb_uhi:
	ldb 1,1
	popj 17,

ldb_uchar6:
	ldb 1,1
	popj 17,

ldb_uchar7:
	ldb 1,1
	popj 17,

ldb_uchar8:
	ldb 1,1
	popj 17,

ldb_uchar9:
	ldb 1,1
	popj 17,

ldb_ushort16:
	ldb 1,1
	andi 1,177777
	popj 17,

ldb_ushort18:
	ldb 1,1
	popj 17,

ldb_uqi_twice:
	ldb 1,1
	lsh 1,1
	popj 17,

ldb_uhi_twice:
	ldb 1,1
	lsh 1,1
	popj 17,

ldb_uqi_add:
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

ldb_uhi_add:
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

ldb_uqi_and:
	ldb 1,1
	popj 17,

ldb_uhi_and:
	ldb 1,1
	popj 17,

ldb_uqi_or:
	ldb 1,1
	ior 2,1
	move 1,2
	popj 17,

ldb_uhi_or:
	ldb 1,1
	ior 2,1
	move 1,2
	popj 17,

ldb_uqi_xor:
	ldb 1,1
	xor 2,1
	move 1,2
	popj 17,

ldb_uhi_xor:
	ldb 1,1
	xor 2,1
	move 1,2
	popj 17,

ldb_uqi_shift_left:
	ldb 1,1
	lsh 1,3
	popj 17,

ldb_uqi_shift_right:
	ldb 1,1
	lsh 1,-3
	andi 1,777	; zero_extendqisi2
	popj 17,

ldb_uhi_shift_left:
	ldb 1,1
	lsh 1,11
	popj 17,

ldb_uhi_shift_right:
	ldb 1,1
	lsh 1,-11
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

ldb_uqi_index:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L26
%L25:
	ibp 1
	sojn 4,%L25	; decrement_and_branch_until_zero
%L26:
	ldb 1,1
	popj 17,

ldb_uhi_index:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L30
%L29:
	ibp 1
	sojn 4,%L29	; decrement_and_branch_until_zero
%L30:
	ldb 1,1
	popj 17,

ldb_uchar6_index:
	andi 2,17
	jumple 2,%L34
%L33:
	ibp 1
	sojg 2,%L33	; decrement_and_branch_until_zero
%L34:
	jumpe 2,%L36
%L35:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L35
%L36:
	ldb 1,1
	popj 17,

ldb_uchar7_index:
	andi 2,17
	jumple 2,%L40
%L39:
	ibp 1
	sojg 2,%L39	; decrement_and_branch_until_zero
%L40:
	jumpe 2,%L42
%L41:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L41
%L42:
	ldb 1,1
	popj 17,

ldb_uchar8_index:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L46
%L45:
	ibp 1
	sojn 4,%L45	; decrement_and_branch_until_zero
%L46:
	ldb 1,1
	popj 17,

ldb_uchar9_index:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L50
%L49:
	ibp 1
	sojn 4,%L49	; decrement_and_branch_until_zero
%L50:
	ldb 1,1
	popj 17,

ldb_ushort16_index:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L54
%L53:
	ibp 1
	sojn 4,%L53	; decrement_and_branch_until_zero
%L54:
	ldb 1,1
	andi 1,177777
	popj 17,

ldb_ushort18_index:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L58
%L57:
	ibp 1
	sojn 4,%L57	; decrement_and_branch_until_zero
%L58:
	ldb 1,1
	popj 17,

ldb_global_uqi:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,ldb_qbuf,8]
	jumpe 4,%L61
%L60:
	ibp 1
	sojn 4,%L60	; decrement_and_branch_until_zero
%L61:
	ldb 1,1
	popj 17,

ldb_global_uhi:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,ldb_hbuf,17]
	jumpe 4,%L64
%L63:
	ibp 1
	sojn 4,%L63	; decrement_and_branch_until_zero
%L64:
	ldb 1,1
	popj 17,

ldb_global_c6:
	move 4,[POINT 6,ldb_c6buf,5]
	andi 1,17
	jumple 1,%L67
%L66:
	ibp 4
	sojg 1,%L66	; decrement_and_branch_until_zero
%L67:
	jumpe 1,%L69
%L68:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L68
%L69:
	ldb 1,4
	popj 17,

ldb_global_c7:
	move 4,[POINT 7,ldb_c7buf,6]
	andi 1,17
	jumple 1,%L72
%L71:
	ibp 4
	sojg 1,%L71	; decrement_and_branch_until_zero
%L72:
	jumpe 1,%L74
%L73:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L73
%L74:
	ldb 1,4
	popj 17,

ldb_global_c8:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,ldb_c8buf,7]
	jumpe 4,%L77
%L76:
	ibp 1
	sojn 4,%L76	; decrement_and_branch_until_zero
%L77:
	ldb 1,1
	popj 17,

ldb_global_c9:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,ldb_c9buf,8]
	jumpe 4,%L80
%L79:
	ibp 1
	sojn 4,%L79	; decrement_and_branch_until_zero
%L80:
	ldb 1,1
	popj 17,

ldb_global_h16:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,ldb_h16buf,17]
	jumpe 4,%L83
%L82:
	ibp 1
	sojn 4,%L82	; decrement_and_branch_until_zero
%L83:
	move 1,(1)
	lsh 1,-24
	popj 17,

ldb_global_h18:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,ldb_h18buf,17]
	jumpe 4,%L86
%L85:
	ibp 1
	sojn 4,%L85	; decrement_and_branch_until_zero
%L86:
	ldb 1,1
	popj 17,

ldb_struct_q:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L89
%L88:
	ibp 1
	sojn 4,%L88	; decrement_and_branch_until_zero
%L89:
	ldb 1,1
	popj 17,

ldb_struct_h:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L92
%L91:
	ibp 1
	sojn 4,%L91	; decrement_and_branch_until_zero
%L92:
	addi 1,4
	ldb 1,1
	popj 17,

ldb_struct_c6:
	andi 2,17
	jumple 2,%L95
%L94:
	ibp 1
	sojg 2,%L94	; decrement_and_branch_until_zero
%L95:
	jumpe 2,%L97
%L96:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L96
%L97:
	addi 1,14
	ldb 1,1
	popj 17,

ldb_struct_c7:
	andi 2,17
	jumple 2,%L100
%L99:
	ibp 1
	sojg 2,%L99	; decrement_and_branch_until_zero
%L100:
	jumpe 2,%L102
%L101:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L101
%L102:
	addi 1,16
	ldb 1,1
	popj 17,

ldb_struct_c8:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L105
%L104:
	ibp 1
	sojn 4,%L104	; decrement_and_branch_until_zero
%L105:
	addi 1,22
	ldb 1,1
	popj 17,

ldb_struct_c9:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L108
%L107:
	ibp 1
	sojn 4,%L107	; decrement_and_branch_until_zero
%L108:
	addi 1,25
	ldb 1,1
	popj 17,

ldb_struct_h16:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L111
%L110:
	ibp 1
	sojn 4,%L110	; decrement_and_branch_until_zero
%L111:
	addi 1,7
	ldb 1,1
	move 4,1
	andi 4,17777
	lsh 4,3
	lsh 1,-17
	ior 1,4
	andi 1,177777
	popj 17,

ldb_struct_h18:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L114
%L113:
	ibp 1
	sojn 4,%L113	; decrement_and_branch_until_zero
%L114:
	addi 1,41
	ldb 1,1
	popj 17,

ldb_volatile_uqi:
	ldb 1,1
	popj 17,

ldb_volatile_uhi:
	ldb 1,1
	popj 17,

ldb_volatile_uchar8:
	ldb 1,1
	popj 17,

ldb_volatile_uchar9:
	ldb 1,1
	popj 17,

ldb_volatile_ushort18:
	ldb 1,1
	popj 17,

ldb_bit6_a:
	lsh 1,-36
	popj 17,

ldb_bit6_c:
	ldb 1,[POINT 6,1,17]
	popj 17,

ldb_bit6_f:
	ldb 1,[POINT 6,1,35]
	popj 17,

ldb_bit7_a:
	lsh 1,-35
	popj 17,

ldb_bit7_c:
	ldb 1,[POINT 7,1,20]
	popj 17,

ldb_bit8_a:
	ldb 1,[POINT 8,1,15]
	popj 17,

ldb_bit8_b:
	ldb 1,[POINT 8,1,23]
	popj 17,

ldb_bit9_a:
	lsh 1,-33
	popj 17,

ldb_bit9_b:
	ldb 1,[POINT 9,1,17]
	popj 17,

ldb_bit9_c:
	ldb 1,[POINT 9,1,26]
	popj 17,

ldb_bit9_d:
	ldb 1,[POINT 9,1,35]
	popj 17,

ldb_bit18_left:
	hlrz 1,1
	popj 17,

ldb_bit18_right:
	hrrz 1,1
	popj 17,

ldb_bit6_ptr_a:
	move 1,(1)
	lsh 1,-36
	popj 17,

ldb_bit6_ptr_f:
	ldb 1,[POINT 6,(1),35]
	popj 17,

ldb_bit7_ptr_b:
	ldb 1,[POINT 7,(1),13]
	popj 17,

ldb_bit8_ptr_a:
	ldb 1,[POINT 8,(1),15]
	popj 17,

ldb_bit8_ptr_b:
	ldb 1,[POINT 8,(1),23]
	popj 17,

ldb_bit9_ptr_a:
	move 1,(1)
	lsh 1,-33
	popj 17,

ldb_bit9_ptr_b:
	ldb 1,[POINT 9,(1),17]
	popj 17,

ldb_bit9_ptr_c:
	ldb 1,[POINT 9,(1),26]
	popj 17,

ldb_bit9_ptr_d:
	ldb 1,[POINT 9,(1),35]
	popj 17,

ldb_bit18_ptr_left:
	hlrz 1,(1)
	popj 17,

ldb_bit18_ptr_right:
	hrrz 1,(1)
	popj 17,

ldb_mixed_q0:
	ldb 1,[POINT 9,1,11]
	popj 17,

ldb_mixed_q1:
	ldb 1,[POINT 9,1,20]
	popj 17,

ldb_mixed_h0:
	ldb 1,[POINT 15,1,35]
	popj 17,

ldb_mixed_h1:
	hlrz 1,2
	popj 17,

ldb_mixed_q2:
	ldb 1,[POINT 9,2,26]
	popj 17,

ldb_mixed_ptr_q0:
	ldb 1,[POINT 9,(1),11]
	popj 17,

ldb_mixed_ptr_q1:
	ldb 1,[POINT 9,(1),20]
	popj 17,

ldb_mixed_ptr_h0:
	ldb 1,[POINT 15,(1),35]
	popj 17,

ldb_mixed_ptr_h1:
	hlrz 1,1(1)
	popj 17,

ldb_mixed_ptr_q2:
	ldb 1,[POINT 9,1(1),26]
	popj 17,

ldb_global_bit6:
	ldb 1,[POINT 6,ldb_g6,17]
	popj 17,

ldb_global_bit7:
	ldb 1,[POINT 7,ldb_g7,13]
	popj 17,

ldb_global_bit8:
	ldb 1,[POINT 8,ldb_g8,15]
	popj 17,

ldb_global_bit9:
	ldb 1,[POINT 9,ldb_g9,35]
	popj 17,

ldb_global_bit18_left:
	hlrz 1,ldb_g18
	popj 17,

ldb_global_bit18_right:
	hrrz 1,ldb_g18
	popj 17,

ldb_global_mixed_q0:
	ldb 1,[POINT 9,ldb_gmixed,11]
	popj 17,

ldb_global_mixed_h1:
	hlrz 1,ldb_gmixed+1
	popj 17,

ldb_global_mixed_q2:
	ldb 1,[POINT 9,ldb_gmixed+1,26]
	popj 17,

ldb_bit9_add:
	ldb 1,[POINT 9,(1),17]
	add 1,2
	popj 17,

ldb_bit18_add:
	hrrz 1,(1)
	add 1,2
	popj 17,

ldb_bit9_mask:
	ldb 1,[POINT 9,(1),26]
	popj 17,

ldb_bit18_mask:
	hlrz 1,(1)
	popj 17,

ldb_bit9_shift_left:
	ldb 1,[POINT 9,(1),35]
	lsh 1,11
	popj 17,

ldb_bit18_shift_right:
	ldb 1,[POINT 9,(1),26]
	popj 17,

ldb_two_qi:
	ldb 2,2
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

ldb_two_hi:
	ldb 2,2
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

ldb_qi_hi:
	ldb 2,2
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

ldb_two_fields:
	move 4,1
	move 1,(1)
	lsh 1,-33
	ldb 4,[POINT 9,(4),35]
	add 1,4
	popj 17,

ldb_mixed_fields:
	move 3,1
	ldb 1,[POINT 9,(1),11]
	ldb 4,[POINT 9,(3),20]
	add 1,4
	hlrz 4,1(3)
	add 1,4
	ldb 4,[POINT 9,1(3),26]
	add 1,4
	popj 17,

ldb_call_pressure_qi:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	ldb 10,1
	pushj 17,clobber
	ldb 11,11
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ldb_call_pressure_hi:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	ldb 10,1
	pushj 17,clobber
	ldb 11,11
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ldb_call_pressure_field:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	ldb 10,[POINT 9,(1),17]
	pushj 17,clobber
	ldb 4,[POINT 9,(11),35]
	add 10,4
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ldb_loop_qi:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L188:
	move 3,6
	andi 3,17
	move 4,6
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L184
%L183:
	ibp 3
	sojn 4,%L183	; decrement_and_branch_until_zero
%L184:
	ldb 3,3
	add 1,3
	addi 6,1
	sojge 2,%L188	; doloop_end
	popj 17,

ldb_loop_hi:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L200:
	move 3,6
	andi 3,17
	move 4,6
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L196
%L195:
	ibp 3
	sojn 4,%L195	; decrement_and_branch_until_zero
%L196:
	ldb 3,3
	add 1,3
	addi 6,1
	sojge 2,%L200	; doloop_end
	popj 17,

ldb_loop_fields:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L210:
	move 4,3
	andi 4,3
	add 4,6
	ldb 4,[POINT 9,(4),17]
	add 1,4
	addi 3,1
	sojge 2,%L210	; doloop_end
	popj 17,

	.bss
ldb_qbuf:
	.space	16
ldb_hbuf:
	.space	32
ldb_c6buf:
	.space	16
ldb_c7buf:
	.space	16
ldb_c8buf:
	.space	16
ldb_c9buf:
	.space	16
ldb_h16buf:
	.space	32
ldb_h18buf:
	.space	32
ldb_g6:
	.space	4
ldb_g7:
	.space	4
ldb_g8:
	.space	4
ldb_g9:
	.space	4
ldb_g18:
	.space	4
ldb_gmixed:
	.space	8
ldb_gchars:
	.space	164
