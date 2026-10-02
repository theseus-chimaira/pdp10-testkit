
ldbe_qint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_sqint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_hint:
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_char6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_char7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_char8:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_char9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_int6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_int7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_int8:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_int9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_short16:
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

ldbe_short18:
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_qint_twice:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	lsh 1,1
	popj 17,

ldbe_hint_twice:
	ldb 1,1
	hrre 1,1
	lsh 1,1
	popj 17,

ldbe_qint_add:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	add 1,2
	popj 17,

ldbe_hint_add:
	ldb 1,1
	hrre 1,1
	add 1,2
	popj 17,

ldbe_qint_sub:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	sub 1,2
	popj 17,

ldbe_hint_sub:
	ldb 1,1
	hrre 1,1
	sub 1,2
	popj 17,

ldbe_qint_neg:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	movn 1,1
	popj 17,

ldbe_hint_neg:
	ldb 1,1
	hrre 1,1
	movn 1,1
	popj 17,

ldbe_qint_and:
	ldb 1,1
	popj 17,

ldbe_hint_and:
	ldb 1,1
	popj 17,

ldbe_qint_shift_left:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	lsh 1,3
	popj 17,

ldbe_qint_shift_right:
	move 1,(1)
	ash 1,-36
	popj 17,

ldbe_hint_shift_left:
	ldb 1,1
	hrre 1,1
	lsh 1,11
	popj 17,

ldbe_hint_shift_right:
	ldb 1,1
	hrre 1,1
	ash 1,-11
	hrre 1,1	; extendhisi2
	popj 17,

ldbe_qint_index:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L31
%L30:
	ibp 1
	sojn 4,%L30	; decrement_and_branch_until_zero
%L31:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_sqint_index:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L35
%L34:
	ibp 1
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_hint_index:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L39
%L38:
	ibp 1
	sojn 4,%L38	; decrement_and_branch_until_zero
%L39:
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_char6_index:
	andi 2,17
	jumple 2,%L43
%L42:
	ibp 1
	sojg 2,%L42	; decrement_and_branch_until_zero
%L43:
	jumpe 2,%L45
%L44:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L44
%L45:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_char7_index:
	andi 2,17
	jumple 2,%L49
%L48:
	ibp 1
	sojg 2,%L48	; decrement_and_branch_until_zero
%L49:
	jumpe 2,%L51
%L50:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L50
%L51:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_char8_index:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L55
%L54:
	ibp 1
	sojn 4,%L54	; decrement_and_branch_until_zero
%L55:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_char9_index:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L59
%L58:
	ibp 1
	sojn 4,%L58	; decrement_and_branch_until_zero
%L59:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_short16_index:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L63
%L62:
	ibp 1
	sojn 4,%L62	; decrement_and_branch_until_zero
%L63:
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

ldbe_short18_index:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L67
%L66:
	ibp 1
	sojn 4,%L66	; decrement_and_branch_until_zero
%L67:
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_global_qint:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,ldbe_qbuf,8]
	jumpe 4,%L70
%L69:
	ibp 1
	sojn 4,%L69	; decrement_and_branch_until_zero
%L70:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_global_sqint:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,ldbe_sqbuf,8]
	jumpe 4,%L73
%L72:
	ibp 1
	sojn 4,%L72	; decrement_and_branch_until_zero
%L73:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_global_hint:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,ldbe_hbuf,17]
	jumpe 4,%L76
%L75:
	ibp 1
	sojn 4,%L75	; decrement_and_branch_until_zero
%L76:
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_global_c6:
	move 4,[POINT 6,ldbe_c6buf,5]
	andi 1,17
	jumple 1,%L79
%L78:
	ibp 4
	sojg 1,%L78	; decrement_and_branch_until_zero
%L79:
	jumpe 1,%L81
%L80:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L80
%L81:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_global_c7:
	move 4,[POINT 7,ldbe_c7buf,6]
	andi 1,17
	jumple 1,%L84
%L83:
	ibp 4
	sojg 1,%L83	; decrement_and_branch_until_zero
%L84:
	jumpe 1,%L86
%L85:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L85
%L86:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_global_c8:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,ldbe_c8buf,7]
	jumpe 4,%L89
%L88:
	ibp 1
	sojn 4,%L88	; decrement_and_branch_until_zero
%L89:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_global_c9:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,ldbe_c9buf,8]
	jumpe 4,%L92
%L91:
	ibp 1
	sojn 4,%L91	; decrement_and_branch_until_zero
%L92:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_global_i6:
	move 4,[POINT 6,ldbe_i6buf,5]
	andi 1,17
	jumple 1,%L95
%L94:
	ibp 4
	sojg 1,%L94	; decrement_and_branch_until_zero
%L95:
	jumpe 1,%L97
%L96:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L96
%L97:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_global_i7:
	move 4,[POINT 7,ldbe_i7buf,6]
	andi 1,17
	jumple 1,%L100
%L99:
	ibp 4
	sojg 1,%L99	; decrement_and_branch_until_zero
%L100:
	jumpe 1,%L102
%L101:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L101
%L102:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_global_i8:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,ldbe_i8buf,7]
	jumpe 4,%L105
%L104:
	ibp 1
	sojn 4,%L104	; decrement_and_branch_until_zero
%L105:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_global_i9:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,ldbe_i9buf,8]
	jumpe 4,%L108
%L107:
	ibp 1
	sojn 4,%L107	; decrement_and_branch_until_zero
%L108:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_global_h16:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,ldbe_h16buf,17]
	jumpe 4,%L111
%L110:
	ibp 1
	sojn 4,%L110	; decrement_and_branch_until_zero
%L111:
	move 1,(1)
	ash 1,-24
	popj 17,

ldbe_global_h18:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,ldbe_h18buf,17]
	jumpe 4,%L114
%L113:
	ibp 1
	sojn 4,%L113	; decrement_and_branch_until_zero
%L114:
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_struct_q:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L117
%L116:
	ibp 1
	sojn 4,%L116	; decrement_and_branch_until_zero
%L117:
	move 1,(1)
	ash 1,-33
	popj 17,

ldbe_struct_sq:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L120
%L119:
	ibp 1
	sojn 4,%L119	; decrement_and_branch_until_zero
%L120:
	addi 1,4
	move 1,(1)
	ash 1,-33
	popj 17,

ldbe_struct_c6:
	andi 2,17
	jumple 2,%L123
%L122:
	ibp 1
	sojg 2,%L122	; decrement_and_branch_until_zero
%L123:
	jumpe 2,%L125
%L124:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L124
%L125:
	addi 1,10
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_struct_c7:
	andi 2,17
	jumple 2,%L128
%L127:
	ibp 1
	sojg 2,%L127	; decrement_and_branch_until_zero
%L128:
	jumpe 2,%L130
%L129:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L129
%L130:
	addi 1,12
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_struct_c8:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L133
%L132:
	ibp 1
	sojn 4,%L132	; decrement_and_branch_until_zero
%L133:
	addi 1,16
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_struct_c9:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L136
%L135:
	ibp 1
	sojn 4,%L135	; decrement_and_branch_until_zero
%L136:
	addi 1,21
	move 1,(1)
	ash 1,-33
	popj 17,

ldbe_struct_i6:
	andi 2,17
	jumple 2,%L139
%L138:
	ibp 1
	sojg 2,%L138	; decrement_and_branch_until_zero
%L139:
	jumpe 2,%L141
%L140:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L140
%L141:
	addi 1,25
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_struct_i7:
	andi 2,17
	jumple 2,%L144
%L143:
	ibp 1
	sojg 2,%L143	; decrement_and_branch_until_zero
%L144:
	jumpe 2,%L146
%L145:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L145
%L146:
	addi 1,30
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_struct_i8:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L149
%L148:
	ibp 1
	sojn 4,%L148	; decrement_and_branch_until_zero
%L149:
	addi 1,33
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_struct_i9:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L152
%L151:
	ibp 1
	sojn 4,%L151	; decrement_and_branch_until_zero
%L152:
	addi 1,37
	move 1,(1)
	ash 1,-33
	popj 17,

ldbe_struct_h16:
	move 3,1
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 3,2
	jumpe 4,%L155
%L154:
	ibp 3
	sojn 4,%L154	; decrement_and_branch_until_zero
%L155:
	addi 3,11
	ldb 1,3
	andi 1,17777
	lsh 1,3
	addi 3,1
	ldb 4,3
	lsh 4,-17
	iori 1,(4)
	lsh 1,24
	ash 1,-24
	popj 17,

ldbe_struct_h18:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L158
%L157:
	ibp 1
	sojn 4,%L157	; decrement_and_branch_until_zero
%L158:
	addi 1,53
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_volatile_qint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_volatile_sqint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_volatile_hint:
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_volatile_char8:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_volatile_char9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_volatile_short18:
	ldb 1,1
	hrre 1,1
	popj 17,

ldbe_bit6_a:
	ash 1,-36
	popj 17,

ldbe_bit6_c:
	lsh 1,14
	ash 1,-36
	popj 17,

ldbe_bit6_f:
	lsh 1,36
	ash 1,-36
	popj 17,

ldbe_bit7_a:
	ash 1,-35
	popj 17,

ldbe_bit7_c:
	lsh 1,16
	ash 1,-35
	popj 17,

ldbe_bit8_a:
	lsh 1,10
	ash 1,-34
	popj 17,

ldbe_bit8_b:
	lsh 1,20
	ash 1,-34
	popj 17,

ldbe_bit9_a:
	ash 1,-33
	popj 17,

ldbe_bit9_b:
	lsh 1,11
	ash 1,-33
	popj 17,

ldbe_bit9_c:
	lsh 1,22
	ash 1,-33
	popj 17,

ldbe_bit9_d:
	lsh 1,33
	ash 1,-33
	popj 17,

ldbe_bit16_a:
	ash 1,-24
	popj 17,

ldbe_bit16_b:
	lsh 1,20
	ash 1,-24
	popj 17,

ldbe_bit18_left:
	hlre 1,1
	popj 17,

ldbe_bit18_right:
	hrre 1,1
	popj 17,

ldbe_bit6_ptr_a:
	move 1,(1)
	ash 1,-36
	popj 17,

ldbe_bit6_ptr_f:
	move 1,(1)
	lsh 1,36
	ash 1,-36
	popj 17,

ldbe_bit7_ptr_b:
	move 1,(1)
	lsh 1,7
	ash 1,-35
	popj 17,

ldbe_bit8_ptr_a:
	move 1,(1)
	lsh 1,10
	ash 1,-34
	popj 17,

ldbe_bit8_ptr_b:
	move 1,(1)
	lsh 1,20
	ash 1,-34
	popj 17,

ldbe_bit9_ptr_a:
	move 1,(1)
	ash 1,-33
	popj 17,

ldbe_bit9_ptr_b:
	move 1,(1)
	lsh 1,11
	ash 1,-33
	popj 17,

ldbe_bit9_ptr_c:
	move 1,(1)
	lsh 1,22
	ash 1,-33
	popj 17,

ldbe_bit9_ptr_d:
	move 1,(1)
	lsh 1,33
	ash 1,-33
	popj 17,

ldbe_bit16_ptr_a:
	move 1,(1)
	ash 1,-24
	popj 17,

ldbe_bit16_ptr_b:
	move 1,(1)
	lsh 1,20
	ash 1,-24
	popj 17,

ldbe_bit18_ptr_left:
	hlre 1,(1)
	popj 17,

ldbe_bit18_ptr_right:
	hrre 1,(1)
	popj 17,

ldbe_mixed_q0:
	lsh 1,3
	ash 1,-33
	popj 17,

ldbe_mixed_q1:
	lsh 1,14
	ash 1,-33
	popj 17,

ldbe_mixed_h0:
	lsh 1,25
	ash 1,-25
	popj 17,

ldbe_mixed_h1:
	hlre 1,2
	popj 17,

ldbe_mixed_q2:
	move 1,2
	lsh 1,22
	ash 1,-33
	popj 17,

ldbe_mixed_ptr_q0:
	move 1,(1)
	lsh 1,3
	ash 1,-33
	popj 17,

ldbe_mixed_ptr_q1:
	move 1,(1)
	lsh 1,14
	ash 1,-33
	popj 17,

ldbe_mixed_ptr_h0:
	move 1,(1)
	lsh 1,25
	ash 1,-25
	popj 17,

ldbe_mixed_ptr_h1:
	hlre 1,1(1)
	popj 17,

ldbe_mixed_ptr_q2:
	move 1,1(1)
	lsh 1,22
	ash 1,-33
	popj 17,

ldbe_global_bit6:
	move 1,ldbe_g6
	lsh 1,14
	ash 1,-36
	popj 17,

ldbe_global_bit7:
	move 1,ldbe_g7
	lsh 1,7
	ash 1,-35
	popj 17,

ldbe_global_bit8:
	move 1,ldbe_g8
	lsh 1,10
	ash 1,-34
	popj 17,

ldbe_global_bit9:
	move 1,ldbe_g9
	lsh 1,33
	ash 1,-33
	popj 17,

ldbe_global_bit16:
	move 1,ldbe_g16
	lsh 1,20
	ash 1,-24
	popj 17,

ldbe_global_bit18_left:
	hlre 1,ldbe_g18
	popj 17,

ldbe_global_bit18_right:
	hrre 1,ldbe_g18
	popj 17,

ldbe_global_mixed_q0:
	move 1,ldbe_gmixed
	lsh 1,3
	ash 1,-33
	popj 17,

ldbe_global_mixed_h1:
	hlre 1,ldbe_gmixed+1
	popj 17,

ldbe_global_mixed_q2:
	move 1,ldbe_gmixed+1
	lsh 1,22
	ash 1,-33
	popj 17,

ldbe_bit9_add:
	move 1,(1)
	lsh 1,11
	ash 1,-33
	add 1,2
	popj 17,

ldbe_bit18_add:
	hrre 1,(1)
	add 1,2
	popj 17,

ldbe_bit9_neg:
	move 1,(1)
	lsh 1,22
	ash 1,-33
	movn 1,1
	popj 17,

ldbe_bit18_neg:
	hlre 1,(1)
	movn 1,1
	popj 17,

ldbe_bit9_shift_right:
	move 1,(1)
	lsh 1,33
	ash 1,-36
	popj 17,

ldbe_bit18_shift_right:
	move 1,(1)
	lsh 1,22
	ash 1,-33
	popj 17,

ldbe_bit9_compare_neg:
	seto 4,
	skipge (1)
	jrst %L219
	move 4,(1)
	ash 4,-33
%L219:
	move 1,4
	popj 17,

ldbe_bit18_compare_neg:
	hrre 1,(1)
	camge 1,[-1]
	seto 1,
	popj 17,

ldbe_qint_compare_neg:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	camge 1,[-1]
	seto 1,
	popj 17,

ldbe_hint_compare_neg:
	ldb 1,1
	hrre 1,1
	camge 1,[-1]
	seto 1,
	popj 17,

ldbe_two_qint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	ldb 4,2
	trne 4,400
	orcmi 4,777
	add 1,4
	popj 17,

ldbe_two_hint:
	ldb 1,1
	hrre 1,1
	ldb 4,2
	hrre 4,4
	add 1,4
	popj 17,

ldbe_qint_hint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	ldb 4,2
	hrre 4,4
	add 1,4
	popj 17,

ldbe_two_fields:
	move 4,1
	move 1,(1)
	ash 1,-33
	move 4,(4)
	lsh 4,33
	ash 4,-33
	add 1,4
	popj 17,

ldbe_mixed_fields:
	move 3,1
	move 1,(1)
	lsh 1,3
	ash 1,-33
	move 4,(3)
	lsh 4,14
	ash 4,-33
	add 1,4
	hlre 4,1(3)
	add 1,4
	move 4,1(3)
	lsh 4,22
	ash 4,-33
	add 1,4
	popj 17,

ldbe_call_pressure_qint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	ldb 10,1
	trne 10,400
	orcmi 10,777
	pushj 17,clobber
	ldb 4,11
	trne 4,400
	orcmi 4,777
	add 10,4
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ldbe_call_pressure_hint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	ldb 10,1
	hrre 10,10
	pushj 17,clobber
	ldb 4,11
	hrre 4,4
	add 10,4
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ldbe_call_pressure_field:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,(1)
	lsh 10,11
	ash 10,-33
	pushj 17,clobber
	move 4,(11)
	lsh 4,33
	ash 4,-33
	add 10,4
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ldbe_loop_qint:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L246:
	move 3,6
	andi 3,17
	move 4,6
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L242
%L241:
	ibp 3
	sojn 4,%L241	; decrement_and_branch_until_zero
%L242:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 6,1
	sojge 2,%L246	; doloop_end
	popj 17,

ldbe_loop_hint:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L258:
	move 3,6
	andi 3,17
	move 4,6
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L254
%L253:
	ibp 3
	sojn 4,%L253	; decrement_and_branch_until_zero
%L254:
	ldb 4,3
	hrre 4,4
	add 1,4
	addi 6,1
	sojge 2,%L258	; doloop_end
	popj 17,

ldbe_loop_fields:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L268:
	move 4,3
	andi 4,3
	add 4,6
	move 4,(4)
	lsh 4,11
	ash 4,-33
	add 1,4
	addi 3,1
	sojge 2,%L268	; doloop_end
	popj 17,

	.bss
ldbe_qbuf:
	.space	16
ldbe_sqbuf:
	.space	16
ldbe_hbuf:
	.space	32
ldbe_c6buf:
	.space	16
ldbe_c7buf:
	.space	16
ldbe_c8buf:
	.space	16
ldbe_c9buf:
	.space	16
ldbe_i6buf:
	.space	16
ldbe_i7buf:
	.space	16
ldbe_i8buf:
	.space	16
ldbe_i9buf:
	.space	16
ldbe_h16buf:
	.space	32
ldbe_h18buf:
	.space	32
ldbe_g6:
	.space	4
ldbe_g7:
	.space	4
ldbe_g8:
	.space	4
ldbe_g9:
	.space	4
ldbe_g16:
	.space	4
ldbe_g18:
	.space	4
ldbe_gmixed:
	.space	8
ldbe_gchars:
	.space	204
