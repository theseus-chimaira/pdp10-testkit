
dpb_qi_store:
	dpb 1,2
	popj 17,

dpb_qi_store_ret:
	andi 1,777	; zero_extendqisi2
	dpb 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

dpb_sqi_store:
	dpb 1,2
	popj 17,

dpb_sqi_store_ret:
	andi 1,777	; zero_extendqisi2
	dpb 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

dpb_uqi_store:
	dpb 1,2
	popj 17,

dpb_uqi_store_ret:
	andi 1,777	; zero_extendqisi2
	dpb 1,2
	popj 17,

dpb_hi_store:
	dpb 1,2	; movhi
	popj 17,

dpb_hi_store_ret:
	hrrzi 1,(1)	; zero_extendhisi2
	dpb 1,2	; movhi
	hrre 1,1
	popj 17,

dpb_uhi_store:
	dpb 1,2	; movhi
	popj 17,

dpb_uhi_store_ret:
	hrrzi 1,(1)	; zero_extendhisi2
	dpb 1,2	; movhi
	popj 17,

dpb_qi_const:
	movei 4,123
	dpb 4,1
	popj 17,

dpb_qi_const_neg:
	hrroi 4,777655
	dpb 4,1
	popj 17,

dpb_uqi_const_masked:
	seto 4,
	dpb 4,1
	popj 17,

dpb_hi_const:
	movei 4,123456
	dpb 4,1	; movhi
	popj 17,

dpb_uhi_const_masked:
	seto 4,
	dpb 4,1	; movhi
	popj 17,

dpb_qi_from_sint:
	dpb 1,2
	popj 17,

dpb_sqi_from_sint:
	dpb 1,2
	popj 17,

dpb_uqi_from_sint:
	dpb 1,2
	popj 17,

dpb_hi_from_sint:
	dpb 1,2	; movhi
	popj 17,

dpb_uhi_from_sint:
	dpb 1,2	; movhi
	popj 17,

dpb_qi_index:
	andi 1,777	; zero_extendqisi2
	move 4,3
	andi 4,3
	andi 3,17
	ash 3,-2	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L24
%L23:
	ibp 2
	sojn 4,%L23	; decrement_and_branch_until_zero
%L24:
	dpb 1,2
	popj 17,

dpb_qi_index_ret:
	andi 1,777	; zero_extendqisi2
	move 5,3
	andi 5,17
	move 7,3
	andi 7,3
	move 4,7
	move 6,5
	ash 6,-2	; ashrsi3_pointer
	add 6,2
	jumpe 7,%L28
%L27:
	ibp 6
	sojn 4,%L27	; decrement_and_branch_until_zero
%L28:
	dpb 1,6
	move 3,5
	ash 3,-2	; ashrsi3_pointer
	add 3,2
	skipn 4,7
	jrst %L31
%L30:
	ibp 3
	sojn 4,%L30	; decrement_and_branch_until_zero
%L31:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

dpb_sqi_index:
	andi 1,777	; zero_extendqisi2
	move 4,3
	andi 4,3
	andi 3,17
	ash 3,-2	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L35
%L34:
	ibp 2
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	dpb 1,2
	popj 17,

dpb_uqi_index:
	andi 1,777	; zero_extendqisi2
	move 4,3
	andi 4,3
	andi 3,17
	ash 3,-2	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L39
%L38:
	ibp 2
	sojn 4,%L38	; decrement_and_branch_until_zero
%L39:
	dpb 1,2
	popj 17,

dpb_hi_index:
	hrrzi 1,(1)	; zero_extendhisi2
	move 4,3
	andi 4,1
	andi 3,17
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L43
%L42:
	ibp 2
	sojn 4,%L42	; decrement_and_branch_until_zero
%L43:
	dpb 1,2	; movhi
	popj 17,

dpb_uhi_index:
	hrrzi 1,(1)	; zero_extendhisi2
	move 4,3
	andi 4,1
	andi 3,17
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L47
%L46:
	ibp 2
	sojn 4,%L46	; decrement_and_branch_until_zero
%L47:
	dpb 1,2	; movhi
	popj 17,

dpb_global_qi:
	andi 2,17
	move 4,[POINT 9,dpb_qbuf,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	popj 17,

dpb_global_sqi:
	andi 2,17
	move 4,[POINT 9,dpb_sqbuf,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	popj 17,

dpb_global_uqi:
	andi 2,17
	move 4,[POINT 9,dpb_uqbuf,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	popj 17,

dpb_global_hi:
	andi 2,17
	move 4,[POINT 18,dpb_hbuf,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	popj 17,

dpb_global_uhi:
	andi 2,17
	move 4,[POINT 18,dpb_uhbuf,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	popj 17,

dpb_struct_qi:
	andi 3,17
	move 4,1
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

dpb_struct_uqi:
	andi 3,17
	move 4,1
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,4
	dpb 2,4
	popj 17,

dpb_struct_sqi:
	andi 3,17
	move 4,1
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,10
	dpb 2,4
	popj 17,

dpb_volatile_qi:
	andi 1,777	; zero_extendqisi2
	dpb 1,2
	popj 17,

dpb_volatile_qi_ret:
	andi 1,777	; zero_extendqisi2
	dpb 1,2
	ldb 1,2
	trne 1,400
	orcmi 1,777
	popj 17,

dpb_volatile_hi:
	hrrzi 1,(1)	; zero_extendhisi2
	dpb 1,2	; movhi
	popj 17,

dpb_volatile_hi_ret:
	hrrzi 1,(1)	; zero_extendhisi2
	dpb 1,2	; movhi
	ldb 1,2
	hrre 1,1
	popj 17,

dpb_bit8_a:
	dpb 2,[POINT 8,1,15]
	popj 17,

dpb_bit8_const:
	movei 4,252
	dpb 4,[POINT 8,1,15]
	popj 17,

dpb_bit8_ptr:
	dpb 2,[POINT 8,(1),15]
	popj 17,

dpb_bit8_ptr_const:
	movsi 6,1774
	iorm 6,(1)
	popj 17,

dpb_bit9_a:
	dpb 2,[POINT 9,1,8]
	popj 17,

dpb_bit9_b:
	dpb 2,[POINT 9,1,17]
	popj 17,

dpb_bit9_c:
	dpb 2,[POINT 9,1,26]
	popj 17,

dpb_bit9_d:
	dpb 2,[POINT 9,1,35]
	popj 17,

dpb_bit9_ptr_a:
	dpb 2,[POINT 9,(1),8]
	popj 17,

dpb_bit9_ptr_b:
	dpb 2,[POINT 9,(1),17]
	popj 17,

dpb_bit9_ptr_c:
	dpb 2,[POINT 9,(1),26]
	popj 17,

dpb_bit9_ptr_d:
	dpb 2,[POINT 9,(1),35]
	popj 17,

dpb_bit6:
	dpb 2,[POINT 6,1,5]
	popj 17,

dpb_bit7:
	dpb 2,[POINT 7,1,12]
	popj 17,

dpb_bit8:
	dpb 2,[POINT 8,1,20]
	popj 17,

dpb_bit9:
	dpb 2,[POINT 9,1,29]
	popj 17,

dpb_bit6_ptr:
	dpb 2,[POINT 6,(1),5]
	popj 17,

dpb_bit7_ptr:
	dpb 2,[POINT 7,(1),12]
	popj 17,

dpb_bit8_6789_ptr:
	dpb 2,[POINT 8,(1),20]
	popj 17,

dpb_bit9_ptr:
	dpb 2,[POINT 9,(1),29]
	popj 17,

dpb_bit18_left:
	hrlz 1,2
	popj 17,

dpb_bit18_right:
	hrrz 1,2
	popj 17,

dpb_bit18_ptr_left:
	hrlm 2,(1)
	popj 17,

dpb_bit18_ptr_right:
	hrrm 2,(1)
	popj 17,

dpb_mixed_q0:
	dpb 3,[POINT 9,1,11]
	popj 17,

dpb_mixed_q1:
	dpb 3,[POINT 9,1,20]
	popj 17,

dpb_mixed_h1:
	hrlz 2,3
	popj 17,

dpb_mixed_q2:
	dpb 3,[POINT 9,2,26]
	popj 17,

dpb_mixed_ptr_q0:
	dpb 2,[POINT 9,(1),11]
	popj 17,

dpb_mixed_ptr_q1:
	dpb 2,[POINT 9,(1),20]
	popj 17,

dpb_mixed_ptr_h1:
	hrlm 2,1(1)
	popj 17,

dpb_mixed_ptr_q2:
	dpb 2,[POINT 9,1(1),26]
	popj 17,

dpb_signed_bit9:
	dpb 2,[POINT 9,1,8]
	popj 17,

dpb_signed_bit18:
	dpb 2,[POINT 18,1,26]
	popj 17,

dpb_unsigned_after_signed:
	dpb 2,[POINT 9,1,35]
	popj 17,

dpb_signed_ptr_bit9:
	dpb 2,[POINT 9,(1),8]
	popj 17,

dpb_signed_ptr_bit18:
	dpb 2,[POINT 18,(1),26]
	popj 17,

dpb_global_bit8:
	dpb 1,[POINT 8,dpb_g8,15]
	popj 17,

dpb_global_bit9_b:
	dpb 1,[POINT 9,dpb_g9,17]
	popj 17,

dpb_global_bit9_d:
	dpb 1,[POINT 9,dpb_g9,35]
	popj 17,

dpb_global_bit18_left:
	hrlm 1,dpb_g18
	popj 17,

dpb_global_bit18_right:
	hrrm 1,dpb_g18
	popj 17,

dpb_global_mixed:
	dpb 1,[POINT 9,dpb_gmixed,11]
	addi 1,1
	dpb 1,[POINT 9,dpb_gmixed,20]
	addi 1,1
	hrlm 1,dpb_gmixed+1
	addi 1,1
	dpb 1,[POINT 9,dpb_gmixed+1,26]
	popj 17,

dpb_multiple_fields:
	dpb 2,[POINT 9,1,8]
	addi 2,1
	dpb 2,[POINT 9,1,17]
	addi 2,1
	dpb 2,[POINT 9,1,26]
	addi 2,1
	dpb 2,[POINT 9,1,35]
	popj 17,

dpb_multiple_fields_ptr:
	dpb 2,[POINT 9,(1),8]
	addi 2,1
	dpb 2,[POINT 9,(1),17]
	addi 2,1
	dpb 2,[POINT 9,(1),26]
	addi 2,1
	dpb 2,[POINT 9,(1),35]
	popj 17,

dpb_masked_field:
	andi 2,777
	dpb 2,[POINT 9,1,26]
	popj 17,

dpb_masked_half:
	hrr 1,2
	popj 17,

dpb_shifted_field:
	ash 2,-3
	dpb 2,[POINT 9,1,17]
	popj 17,

dpb_shifted_half:
	ash 2,-11
	hrlz 1,2
	popj 17,

dpb_store_then_sum:
	dpb 3,1
	dpb 4,2	; movhi
	ldb 1,1
	trne 1,400
	orcmi 1,777
	hrre 4,4
	add 1,4
	popj 17,

dpb_field_then_sum:
	move 4,1
	dpb 2,[POINT 9,(1),8]
	addi 2,1
	dpb 2,[POINT 9,(1),17]
	move 1,(1)
	lsh 1,-33
	ldb 4,[POINT 9,(4),17]
	add 1,4
	popj 17,

dpb_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 10,4
	dpb 3,1
	pushj 17,clobber
	dpb 10,11	; movhi
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dpb_field_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	dpb 2,[POINT 9,(11),8]
	pushj 17,clobber
	addi 10,1
	dpb 10,[POINT 9,(11),35]
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.comm	dpb_qbuf, 16
	.comm	dpb_uqbuf, 16
	.comm	dpb_sqbuf, 16
	.comm	dpb_hbuf, 32
	.comm	dpb_uhbuf, 32
	.comm	dpb_g8, 4
	.comm	dpb_g9, 4
	.comm	dpb_g6789, 4
	.comm	dpb_g18, 4
	.comm	dpb_gmixed, 8
	.comm	dpb_gsigned, 4
	.comm	dpb_gchars, 48
