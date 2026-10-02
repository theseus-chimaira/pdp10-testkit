
move_reg:
	popj 17,

move_reg_second:
	move 1,2
	popj 17,

umove_reg:
	popj 17,

umove_reg_second:
	move 1,2
	popj 17,

move_mem:
	move 1,(1)
	popj 17,

move_mem_offset:
	move 1,1(1)
	popj 17,

move_mem_index:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

umove_mem:
	move 1,(1)
	popj 17,

umove_mem_index:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

move_volatile_mem:
	move 1,(1)
	popj 17,

move_volatile_mem_offset:
	move 1,1(1)
	popj 17,

move_global:
	move 1,movsi_g0
	popj 17,

move_global_1:
	move 1,movsi_g1
	popj 17,

umove_global:
	move 1,movsi_ug0
	popj 17,

move_vglobal:
	move 1,movsi_vg0
	popj 17,

move_array:
	andi 1,17
	move 1,movsi_buf(1)
	popj 17,

umove_array:
	andi 1,17
	move 1,movsi_ubuf(1)
	popj 17,

move_struct:
	move 1,(1)
	popj 17,

move_struct_b:
	move 1,1(1)
	popj 17,

umove_struct:
	move 1,(1)
	popj 17,

move_global_struct:
	move 1,movsi_gp
	popj 17,

move_global_struct_b:
	move 1,movsi_gp+1
	popj 17,

umove_global_struct:
	move 1,movsi_ugp
	popj 17,

movem_reg:
	movem 2,(1)
	popj 17,

movem_reg_offset:
	movem 2,1(1)
	popj 17,

movem_reg_index:
	andi 2,17
	add 1,2
	movem 3,(1)
	popj 17,

umovem_reg:
	movem 2,(1)
	popj 17,

umovem_reg_index:
	andi 2,17
	add 1,2
	movem 3,(1)
	popj 17,

movem_volatile:
	movem 2,(1)
	popj 17,

movem_volatile_offset:
	movem 2,1(1)
	popj 17,

movem_global:
	movem 1,movsi_g0
	popj 17,

movem_global_1:
	movem 1,movsi_g1
	popj 17,

umovem_global:
	movem 1,movsi_ug0
	popj 17,

movem_vglobal:
	movem 1,movsi_vg0
	popj 17,

movem_array:
	andi 1,17
	movem 2,movsi_buf(1)
	popj 17,

umovem_array:
	andi 1,17
	movem 2,movsi_ubuf(1)
	popj 17,

movem_struct:
	movem 2,(1)
	popj 17,

movem_struct_b:
	movem 2,1(1)
	popj 17,

umovem_struct:
	movem 2,(1)
	popj 17,

movem_global_struct:
	movem 1,movsi_gp
	popj 17,

movem_global_struct_b:
	movem 1,movsi_gp+1
	popj 17,

umovem_global_struct:
	movem 1,movsi_ugp
	popj 17,

movem_reg_ret:
	movem 2,(1)
	move 1,2
	popj 17,

movem_global_ret:
	movem 1,movsi_g0
	popj 17,

movem_array_ret:
	andi 1,17
	movem 2,movsi_buf(1)
	move 1,2
	popj 17,

movem_struct_ret:
	movem 2,(1)
	move 1,2
	popj 17,

move_mem_to_mem:
	move 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

umove_mem_to_mem:
	move 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

move_mem_to_global:
	move 1,(1)
	movem 1,movsi_g0
	popj 17,

move_global_to_mem:
	move 4,1
	move 1,movsi_g0
	movem 1,(4)
	popj 17,

move_array_to_array:
	andi 1,17
	andi 2,17
	move 1,movsi_buf(1)
	movem 1,movsi_buf(2)
	popj 17,

move_struct_to_struct:
	move 4,(2)
	movem 4,1(1)
	move 1,4
	popj 17,

move_local_copy:
	popj 17,

move_local_chain:
	popj 17,

move_local_array:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	move 6,-3(17)
	movem 6,-1(17)
	move 6,-2(17)
	movem 6,(17)
	move 1,-1(17)
	xor 1,6
	add 17,[-4,,-4]
	popj 17,

move_local_address_escape:
	popj 17,

movei_zero:
	movei 1,0
	popj 17,

movei_one:
	movei 1,1
	popj 17,

movei_small:
	movei 1,123456
	popj 17,

movei_low9:
	movei 1,777
	popj 17,

movei_low18:
	movei 1,777777
	popj 17,

umovei_low18:
	movei 1,777777
	popj 17,

movsi_zero_left:
	movei 1,0
	popj 17,

movsi_small:
	movsi 1,123456
	popj 17,

movsi_one_left:
	movsi 1,1
	popj 17,

movsi_all_left:
	movsi 1,777777
	popj 17,

hrroi_small:
	hrroi 1,654322
	popj 17,

hrroi_one:
	seto 1,
	popj 17,

hrroi_low9:
	hrroi 1,777001
	popj 17,

hrroi_low18:
	hrroi 1,1
	popj 17,

hrloi_small:
	hrloi 1,123456
	popj 17,

hrloi_zero_left:
	movei 1,777777
	popj 17,

hrloi_all_left:
	seto 1,
	popj 17,

move_literal_large:
	move 1,[123456123456]
	popj 17,

move_literal_sparse:
	move 1,[-252525525253]
	popj 17,

move_literal_sign:
	movsi 1,400000
	popj 17,

move_literal_right_half:
	movei 1,777777
	popj 17,

move_literal_left_half:
	movsi 1,777777
	popj 17,

umove_literal_large:
	move 1,[123456123456]
	popj 17,

umove_literal_allones:
	seto 1,
	popj 17,

movem_const_zero:
	setzm (1)
	popj 17,

movem_const_one:
	movei 6,1
	movem 6,(1)
	popj 17,

movem_const_small:
	movei 6,123456
	movem 6,(1)
	popj 17,

movem_const_movsi:
	movsi 6,123456
	movem 6,(1)
	popj 17,

movem_const_hrroi:
	hrroi 6,654322
	movem 6,(1)
	popj 17,

movem_const_hrloi:
	hrloi 6,123456
	movem 6,(1)
	popj 17,

movem_const_large:
	move 6,[123456123456]
	movem 6,(1)
	popj 17,

movem_const_large_ret:
	move 6,[123456123456]
	movem 6,(1)
	move 1,6
	popj 17,

movem_global_const_small:
	movei 6,123456
	movem 6,movsi_g0
	popj 17,

movem_global_const_movsi:
	movsi 6,123456
	movem 6,movsi_g0
	popj 17,

movem_global_const_hrroi:
	hrroi 6,654322
	movem 6,movsi_g0
	popj 17,

movem_global_const_hrloi:
	hrloi 6,123456
	movem 6,movsi_g0
	popj 17,

movem_global_const_large:
	move 6,[123456123456]
	movem 6,movsi_g0
	popj 17,

movem_global_const_large_ret:
	move 6,[123456123456]
	movem 6,movsi_g0
	move 1,6
	popj 17,

movem_array_const_small:
	andi 1,17
	movei 6,123456
	movem 6,movsi_buf(1)
	popj 17,

movem_array_const_large:
	andi 1,17
	move 6,[123456123456]
	movem 6,movsi_buf(1)
	popj 17,

movem_array_const_large_ret:
	andi 1,17
	move 6,[123456123456]
	movem 6,movsi_buf(1)
	move 1,6
	popj 17,

move_select_arg:
	jumpn 1,%L103
	move 2,3
%L103:
	move 1,2
	popj 17,

move_select_mem:
	jumpe 1,%L106
	move 1,(2)
%L105:
	popj 17,
%L106:
	move 1,(3)
	popj 17,

move_select_global:
	jumpe 1,%L108
	move 1,movsi_g0
%L107:
	popj 17,
%L108:
	move 1,movsi_g1
	popj 17,

move_branch_store:
	jumpe 1,%L110
	movem 3,(2)
%L111:
	move 1,(2)
	popj 17,
%L110:
	movem 4,(2)
	jrst %L111

move_branch_global_store:
	jumpe 1,%L113
	movem 2,movsi_g0
%L114:
	move 1,movsi_g0
	popj 17,
%L113:
	movem 3,movsi_g0
	jrst %L114

move_live_across_call:
	push 17,10
	move 10,1
	movei 1,1
	pushj 17,sink_int
	move 1,10
	pop 17,10
	popj 17,

move_live_across_call_2:
	push 17,10
	move 10,2
	pushj 17,sink_sint
	move 1,10
	pop 17,10
	popj 17,

move_store_across_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,10
	pushj 17,sink_sint
	movem 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

move_load_across_call:
	push 17,10
	move 10,(1)
	move 1,10
	pushj 17,sink_sint
	move 1,10
	pop 17,10
	popj 17,

move_many_args:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,3
	move 3,-4(17)
	move 10,-5(17)
	move 12,1
	jumpn 3,%L121
	move 12,2
%L121:
	move 1,10
	pushj 17,sink_int
	move 1,11
	jumpn 10,%L119
	move 1,12
%L119:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

move_many_moves:
	movem 1,movsi_g0
	movem 2,movsi_g1
	movem 3,movsi_g2
	move 1,4
	popj 17,

move_many_stores:
	movem 1,movsi_buf
	movem 2,movsi_buf+1
	movem 3,movsi_buf+2
	move 1,movsi_buf
	xor 1,movsi_buf+1
	xor 1,3
	popj 17,

move_loop_copy:
	move 5,1
	setzb 1,7
	caml 1,3
	popj 17,
	move 6,3
	subi 6,1
%L135:
	move 4,7
	andi 4,17
	move 3,2
	add 3,4
	move 1,(3)
	add 4,5
	movem 1,(4)
	addi 7,1
	sojge 6,%L135	; doloop_end
	popj 17,

umove_loop_copy:
	move 5,1
	setzb 1,7
	caml 1,3
	popj 17,
	move 6,3
	subi 6,1
%L146:
	move 4,7
	andi 4,17
	move 3,2
	add 3,4
	move 1,(3)
	add 4,5
	movem 1,(4)
	addi 7,1
	sojge 6,%L146	; doloop_end
	popj 17,

move_loop_fill:
	move 7,1
	move 1,3
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L156:
	move 4,6
	andi 4,17
	add 4,7
	movem 1,(4)
	addi 6,1
	sojge 2,%L156	; doloop_end
	popj 17,

move_loop_select:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 2,3
	move 3,-3(17)
	setzb 1,5
	caml 1,4
	jrst %L169
	move 7,4
	subi 7,1
%L170:
	jumpe 3,%L162
	move 6,5
	andi 6,17
	move 4,11
%L171:
	add 4,6
	move 1,(4)
	add 6,10
	movem 1,(6)
	addi 5,1
	sojge 7,%L170	; doloop_end
%L169:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L162:
	move 6,5
	andi 6,17
	move 4,2
	jrst %L171

move_volatile_copy:
	move 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

move_volatile_global_copy:
	move 1,movsi_vg0
	movem 1,movsi_vg1
	popj 17,

move_from_qi:
	lsh 1,33
	ash 1,-33
	popj 17,

move_from_hi:
	hrre 1,1
	popj 17,

move_from_uqi:
	andi 1,777	; zero_extendqisi2
	popj 17,

move_from_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

movem_from_qi:
	lsh 2,33
	ash 2,-33
	movem 2,(1)
	popj 17,

movem_from_hi:
	hrre 2,2
	movem 2,(1)
	popj 17,

move_to_qi:
	lsh 1,33
	ash 1,-33
	popj 17,

move_to_hi:
	hrre 1,1	; extendhisi2
	popj 17,

move_struct_local:
	popj 17,

move_struct_local_b:
	move 1,2
	popj 17,

move_nested_struct_copy:
	move 6,(2)
	movem 6,(1)
	move 2,1(2)
	movem 2,1(1)
	xor 6,2
	move 1,6
	popj 17,

move1:
	move 1,2
	popj 17,

move2:
	move 1,(2)
	popj 17,

movei:
	movei 1,123456
	popj 17,

movsi:
	movsi 1,123456
	popj 17,

hrroi:
	hrroi 1,654322
	popj 17,

hrloi:
	hrloi 1,123456
	popj 17,

move3:
	move 1,[123456123456]
	popj 17,

movem:
	movem 1,(2)
	popj 17,

	.bss
movsi_g0:
	.space	4
movsi_g1:
	.space	4
movsi_g2:
	.space	4
movsi_ug0:
	.space	4
movsi_ug1:
	.space	4
movsi_vg0:
	.space	4
movsi_vg1:
	.space	4
movsi_buf:
	.space	64
movsi_ubuf:
	.space	64
movsi_gp:
	.space	8
movsi_ugp:
	.space	8
