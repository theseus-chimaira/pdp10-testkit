
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
	andi 1,17
	move 4,[POINT 9,ldbe_qbuf,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_global_sqint:
	andi 1,17
	move 4,[POINT 9,ldbe_sqbuf,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_global_hint:
	andi 1,17
	move 4,[POINT 18,ldbe_hbuf,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

ldbe_global_c6:
	andi 1,17
	move 4,[POINT 6,ldbe_c6buf,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_global_c7:
	andi 1,17
	move 4,[POINT 7,ldbe_c7buf,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_global_c8:
	andi 1,17
	move 4,[POINT 8,ldbe_c8buf,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_global_c9:
	andi 1,17
	move 4,[POINT 9,ldbe_c9buf,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_global_i6:
	andi 1,17
	move 4,[POINT 6,ldbe_i6buf,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_global_i7:
	andi 1,17
	move 4,[POINT 7,ldbe_i7buf,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_global_i8:
	andi 1,17
	move 4,[POINT 8,ldbe_i8buf,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_global_i9:
	andi 1,17
	move 4,[POINT 9,ldbe_i9buf,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_global_h16:
	andi 1,17
	move 4,[POINT 18,ldbe_h16buf,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 1,(4)
	ash 1,-24
	popj 17,

ldbe_global_h18:
	andi 1,17
	move 4,[POINT 18,ldbe_h18buf,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

ldbe_struct_q:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_struct_sq:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,4
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_struct_c6:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,10
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_struct_c7:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,12
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_struct_c8:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,16
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_struct_c9:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,21
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_struct_i6:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,25
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

ldbe_struct_i7:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,30
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

ldbe_struct_i8:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,33
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

ldbe_struct_i9:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,37
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

ldbe_struct_h16:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,11
	ldb 1,4
	andi 1,17777
	lsh 1,3
	addi 4,1
	ldb 4,4
	lsh 4,-17
	iori 1,(4)
	lsh 1,24
	ash 1,-24
	popj 17,

ldbe_struct_h18:
	andi 2,17
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,53
	ldb 1,4
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
	jrst %L153
	move 4,(1)
	ash 4,-33
%L153:
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
%L180:
	move 3,6
	andi 3,17
	move 4,6
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L176
%L175:
	ibp 3
	sojn 4,%L175	; decrement_and_branch_until_zero
%L176:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 6,1
	sojge 2,%L180	; doloop_end
	popj 17,

ldbe_loop_hint:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L192:
	move 3,6
	andi 3,17
	move 4,6
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L188
%L187:
	ibp 3
	sojn 4,%L187	; decrement_and_branch_until_zero
%L188:
	ldb 4,3
	hrre 4,4
	add 1,4
	addi 6,1
	sojge 2,%L192	; doloop_end
	popj 17,

ldbe_loop_fields:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L202:
	move 4,3
	andi 4,3
	add 4,6
	move 4,(4)
	lsh 4,11
	ash 4,-33
	add 1,4
	addi 3,1
	sojge 2,%L202	; doloop_end
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
