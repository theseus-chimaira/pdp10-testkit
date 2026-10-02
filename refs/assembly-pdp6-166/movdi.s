
make_di:
	push 17,10
	move 5,1
	ash 1,-43
	move 4,1
	lshc 4,44
	move 7,2
	movei 6,0
	move 2,5
	add 2,7
	move 3,2
	tlc 3,400000
	move 10,5
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,4
	add 1,6
	add 1,3
	pop 17,10
	popj 17,

make_udi:
	push 17,10
	move 5,1
	movei 4,0
	lshc 4,44
	move 7,2
	movei 6,0
	move 2,5
	add 2,7
	move 3,2
	tlc 3,400000
	move 10,5
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,4
	add 1,6
	add 1,3
	pop 17,10
	popj 17,

movdi_arg0:
	popj 17,

movdi_arg1:
	move 1,3
	move 2,4
	popj 17,

movdi_arg2:
	move 6,-2(17)
	move 7,-1(17)
	move 1,6
	move 2,7
	popj 17,

movdi_uarg0:
	popj 17,

movdi_uarg1:
	move 1,3
	move 2,4
	popj 17,

movdi_load:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_load_offset:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

movdi_load_index:
	andi 2,17
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	popj 17,

movdi_uload:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_uload_index:
	andi 2,17
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	popj 17,

movdi_load_volatile:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_load_volatile_offset:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

movdi_load_global:
	move 1,movdi_g0
	move 2,movdi_g0+1
	popj 17,

movdi_load_global_1:
	move 1,movdi_g1
	move 2,movdi_g1+1
	popj 17,

movdi_uload_global:
	move 1,movdi_ug0
	move 2,movdi_ug0+1
	popj 17,

movdi_load_vglobal:
	move 1,movdi_vg0
	move 2,movdi_vg0+1
	popj 17,

movdi_load_array:
	andi 1,17
	lsh 1,1
	move 4,movdi_buf(1)
	move 5,movdi_buf+1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_uload_array:
	andi 1,17
	lsh 1,1
	move 4,movdi_ubuf(1)
	move 5,movdi_ubuf+1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_load_struct:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_load_struct_b:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

movdi_uload_struct:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_load_global_struct:
	move 1,movdi_gp
	move 2,movdi_gp+1
	popj 17,

movdi_load_global_struct_b:
	move 1,movdi_gp+2
	move 2,movdi_gp+3
	popj 17,

movdi_uload_global_struct:
	move 1,movdi_ugp
	move 2,movdi_ugp+1
	popj 17,

movdi_store:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

movdi_store_offset:
	movem 2,2(1)
	movem 3,3(1)
	popj 17,

movdi_store_index:
	andi 2,17
	lsh 2,1
	add 2,1
	movem 3,(2)
	movem 4,1(2)
	popj 17,

movdi_ustore:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

movdi_ustore_index:
	andi 2,17
	lsh 2,1
	add 2,1
	movem 3,(2)
	movem 4,1(2)
	popj 17,

movdi_store_volatile:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

movdi_store_volatile_offset:
	movem 2,2(1)
	movem 3,3(1)
	popj 17,

movdi_store_global:
	movem 1,movdi_g0
	movem 2,movdi_g0+1
	popj 17,

movdi_store_global_1:
	movem 1,movdi_g1
	movem 2,movdi_g1+1
	popj 17,

movdi_ustore_global:
	movem 1,movdi_ug0
	movem 2,movdi_ug0+1
	popj 17,

movdi_store_vglobal:
	movem 1,movdi_vg0
	movem 2,movdi_vg0+1
	popj 17,

movdi_store_array:
	andi 1,17
	lsh 1,1
	movem 2,movdi_buf(1)
	movem 3,movdi_buf+1(1)
	popj 17,

movdi_ustore_array:
	andi 1,17
	lsh 1,1
	movem 2,movdi_ubuf(1)
	movem 3,movdi_ubuf+1(1)
	popj 17,

movdi_store_struct:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

movdi_store_struct_b:
	movem 2,2(1)
	movem 3,3(1)
	popj 17,

movdi_ustore_struct:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

movdi_store_global_struct:
	movem 1,movdi_gp
	movem 2,movdi_gp+1
	popj 17,

movdi_store_global_struct_b:
	movem 1,movdi_gp+2
	movem 2,movdi_gp+3
	popj 17,

movdi_ustore_global_struct:
	movem 1,movdi_ugp
	movem 2,movdi_ugp+1
	popj 17,

movdi_store_ret:
	movem 2,(1)
	movem 3,1(1)
	move 4,(1)
	move 5,3
	move 1,4
	move 2,5
	popj 17,

movdi_store_global_ret:
	movem 1,movdi_g0
	movem 2,movdi_g0+1
	popj 17,

movdi_store_array_ret:
	andi 1,17
	lsh 1,1
	movem 2,movdi_buf(1)
	movem 3,movdi_buf+1(1)
	move 4,movdi_buf(1)
	move 5,3
	move 1,4
	move 2,5
	popj 17,

movdi_store_struct_ret:
	movem 2,(1)
	movem 3,1(1)
	move 4,(1)
	move 5,3
	move 1,4
	move 2,5
	popj 17,

movdi_mem_to_mem:
	move 4,(2)
	move 5,1(2)
	movem 4,(1)
	movem 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_umem_to_mem:
	move 4,(2)
	move 5,1(2)
	movem 4,(1)
	movem 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_mem_to_global:
	move 4,(1)
	move 5,1(1)
	movem 4,movdi_g0
	movem 5,movdi_g0+1
	move 1,4
	move 2,5
	popj 17,

movdi_global_to_mem:
	move 4,1
	move 1,movdi_g0
	move 2,movdi_g0+1
	movem 1,(4)
	movem 2,1(4)
	popj 17,

movdi_array_to_array:
	andi 1,17
	andi 2,17
	lsh 1,1
	move 4,movdi_buf(1)
	move 5,movdi_buf+1(1)
	lsh 2,1
	movem 4,movdi_buf(2)
	movem 5,movdi_buf+1(2)
	move 6,movdi_buf(2)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

movdi_struct_to_struct:
	move 4,(2)
	move 5,1(2)
	movem 4,2(1)
	movem 5,3(1)
	move 6,2(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

movdi_local_copy:
	popj 17,

movdi_local_chain:
	popj 17,

movdi_local_array:
	add 17,[12,,12]
	movem 10,-11(17)
	movem 11,-10(17)
	movem 1,-7(17)
	movem 2,-6(17)
	movem 3,-5(17)
	movem 4,-4(17)
	move 5,-7(17)
	movem 5,-3(17)
	move 5,-6(17)
	movem 5,-2(17)
	move 5,-5(17)
	movem 5,-1(17)
	move 5,-4(17)
	movem 5,(17)
	move 6,-3(17)
	move 7,-2(17)
	move 10,-1(17)
	xor 6,10
	xor 7,5
	move 1,6
	move 2,7
	move 10,-11(17)
	move 11,-10(17)
	add 17,[-12,,-12]
	popj 17,

movdi_local_address_escape:
	add 17,[2,,2]
	movei 3,-1(17)
	movem 1,(3)
	movem 2,1(3)
	move 4,(3)
	move 5,2
	move 1,4
	move 2,5
	add 17,[-2,,-2]
	popj 17,

movdi_const_zero:
	setzb 1,2
	popj 17,

movdi_const_one:
	movei 1,0
	movei 2,1
	popj 17,

movdi_const_minus_one:
	seto 1,
	movni 2,1
	popj 17,

movdi_const_low18:
	movei 1,0
	movei 2,777777
	popj 17,

movdi_const_low36:
	move 1,[0]
	move 2,[777777777777]
	popj 17,

movdi_const_high_word:
	movei 1,1
	movei 2,0
	jrst make_di

movdi_const_large:
	movei 1,123456
	movei 2,654321
	jrst make_di

movdi_const_large_neg:
	movei 1,123456
	movei 2,654321
	pushj 17,make_di
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	popj 17,

movdi_const_original_shape:
	move 1,[123456123456]
	move 2,[654321654321]
	popj 17,

movdi_uconst_zero:
	setzb 1,2
	popj 17,

movdi_uconst_one:
	movei 1,0
	movei 2,1
	popj 17,

movdi_uconst_low36:
	move 1,[0]
	move 2,[777777777777]
	popj 17,

movdi_uconst_high_word:
	movei 1,1
	movei 2,0
	jrst make_udi

movdi_uconst_large:
	movei 1,123456
	movei 2,654321
	jrst make_udi

movdi_store_const_zero:
	setzm (1)
	setzm 1(1)
	popj 17,

movdi_store_const_one:
	setzm (1)
	movei 6,1
	movem 6,1(1)
	popj 17,

movdi_store_const_minus_one:
	hrloi 6,1777
	movem 6,(1)
	setom 1(1)
	popj 17,

movdi_store_const_large:
	push 17,10
	move 10,1
	movei 1,123456
	movei 2,654321
	pushj 17,make_di
	movem 1,(10)
	movem 2,1(10)
	pop 17,10
	popj 17,

movdi_store_const_large_ret:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movei 1,123456
	movei 2,654321
	pushj 17,make_di
	movem 1,(12)
	movem 2,1(12)
	move 10,(12)
	move 11,2
	move 1,10
	move 2,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

movdi_store_global_const_large:
	movei 1,123456
	movei 2,654321
	pushj 17,make_di
	movem 1,movdi_g0
	movem 2,movdi_g0+1
	popj 17,

movdi_store_global_const_large_ret:
	movei 1,123456
	movei 2,654321
	pushj 17,make_di
	movem 1,movdi_g0
	movem 2,movdi_g0+1
	popj 17,

movdi_store_array_const_large:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	andi 10,17
	lsh 10,1
	xmovei 11,movdi_buf(10)
	movei 1,123456
	movei 2,654321
	pushj 17,make_di
	movem 1,movdi_buf(10)
	movem 2,1(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movdi_store_array_const_large_ret:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	andi 12,17
	lsh 12,1
	xmovei 13,movdi_buf(12)
	movei 1,123456
	movei 2,654321
	pushj 17,make_di
	movem 1,movdi_buf(12)
	movem 2,1(13)
	move 10,movdi_buf(12)
	move 11,2
	move 1,10
	move 2,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

movdi_select_arg:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	move 7,4
	jumpn 1,%L88
	move 2,6
	move 3,7
%L88:
	move 1,2
	move 2,3
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

movdi_select_mem:
	jumpe 1,%L91
	move 6,(2)
	move 7,1(2)
	move 1,6
	move 2,7
%L90:
	popj 17,
%L91:
	move 4,(3)
	move 5,1(3)
	move 1,4
	move 2,5
	popj 17,

movdi_select_global:
	jumpe 1,%L93
	move 1,movdi_g0
	move 2,movdi_g0+1
%L92:
	popj 17,
%L93:
	move 1,movdi_g1
	move 2,movdi_g1+1
	popj 17,

movdi_branch_store:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,-4(17)
	move 7,-3(17)
	jumpe 1,%L95
	movem 3,(2)
	movem 4,1(2)
%L96:
	move 10,(2)
	move 11,1(2)
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L95:
	movem 6,(2)
	movem 7,1(2)
	jrst %L96

movdi_branch_global_store:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	move 7,4
	jumpe 1,%L98
	movem 2,movdi_g0
	movem 3,movdi_g0+1
%L99:
	move 1,movdi_g0
	move 2,movdi_g0+1
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,
%L98:
	movem 6,movdi_g0
	movem 7,movdi_g0+1
	jrst %L99

movdi_call_arg:
	jrst ext_di_identity

movdi_ucall_arg:
	jrst ext_udi_identity

movdi_call_loaded:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	jrst ext_di_identity

movdi_call_result:
	move 1,movdi_g0
	move 2,movdi_g0+1
	jrst ext_di_identity

movdi_live_across_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,1
	pushj 17,sink_int
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movdi_live_across_call_2:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,3
	move 11,4
	pushj 17,sink_di
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movdi_store_across_call:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 14,1
	move 12,2
	move 13,3
	move 1,12
	move 2,13
	pushj 17,sink_di
	movem 12,(14)
	movem 13,1(14)
	move 10,(14)
	move 11,13
	move 1,10
	move 2,11
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

movdi_load_across_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,(1)
	move 11,1(1)
	move 1,10
	move 2,11
	pushj 17,sink_di
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movdi_ulive_across_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 1,10
	move 2,11
	pushj 17,sink_udi
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movdi_many_args:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 10,3
	move 11,4
	move 12,-11(17)
	move 13,-10(17)
	move 6,-13(17)
	move 7,-12(17)
	move 4,-14(17)
	move 14,-15(17)
	move 15,1
	move 16,2
	jumpn 4,%L111
	move 15,10
	move 16,11
%L111:
	move 1,14
	pushj 17,sink_int
	move 1,12
	move 2,13
	jumpn 14,%L109
	move 1,15
	move 2,16
%L109:
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

movdi_many_moves:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,-4(17)
	move 7,-3(17)
	move 10,-6(17)
	move 11,-5(17)
	movem 1,movdi_g0
	movem 2,movdi_g0+1
	movem 3,movdi_g1
	movem 4,movdi_g1+1
	movem 6,movdi_g2
	movem 7,movdi_g2+1
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movdi_many_stores:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 10,-10(17)
	move 11,-7(17)
	movem 1,movdi_buf
	movem 2,movdi_buf+1
	movem 3,movdi_buf+2
	movem 4,movdi_buf+3
	movem 10,movdi_buf+4
	movem 11,movdi_buf+5
	move 6,movdi_buf
	move 7,movdi_buf+1
	move 12,movdi_buf+2
	move 13,movdi_buf+3
	xor 6,12
	xor 7,13
	move 14,movdi_buf+4
	move 15,11
	xor 6,14
	xor 7,11
	move 1,6
	move 2,7
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

movdi_loop_copy:
	push 17,10
	move 10,1
	move 5,2
	setzb 1,2
	movei 7,0
	caml 7,3
	jrst %L124
	move 6,3
	subi 6,1
%L125:
	move 4,7
	andi 4,17
	lsh 4,1
	move 3,4
	add 3,5
	move 1,(3)
	move 2,1(3)
	add 4,10
	movem 1,(4)
	movem 2,1(4)
	addi 7,1
	sojge 6,%L125	; doloop_end
%L124:
	pop 17,10
	popj 17,

movdi_uloop_copy:
	push 17,10
	move 10,1
	move 5,2
	setzb 1,2
	movei 7,0
	caml 7,3
	jrst %L135
	move 6,3
	subi 6,1
%L136:
	move 4,7
	andi 4,17
	lsh 4,1
	move 3,4
	add 3,5
	move 1,(3)
	move 2,1(3)
	add 4,10
	movem 1,(4)
	movem 2,1(4)
	addi 7,1
	sojge 6,%L136	; doloop_end
%L135:
	pop 17,10
	popj 17,

movdi_loop_fill:
	move 7,1
	move 5,2
	move 1,3
	move 2,4
	movei 6,0
	caml 6,5
	popj 17,
	move 3,5
	subi 3,1
%L146:
	move 4,6
	andi 4,17
	lsh 4,1
	add 4,7
	movem 1,(4)
	movem 2,1(4)
	addi 6,1
	sojge 3,%L146	; doloop_end
	popj 17,

movdi_loop_select:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 12,2
	move 11,3
	move 3,-4(17)
	setzb 1,2
	movei 5,0
	caml 5,4
	jrst %L159
	move 7,4
	subi 7,1
%L160:
	jumpe 3,%L152
	move 6,5
	andi 6,17
	move 4,6
	lsh 4,1
	add 4,12
%L161:
	move 1,(4)
	move 2,1(4)
	move 4,6
	lsh 4,1
	add 4,10
	movem 1,(4)
	movem 2,1(4)
	addi 5,1
	sojge 7,%L160	; doloop_end
%L159:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L152:
	move 6,5
	andi 6,17
	move 4,6
	lsh 4,1
	add 4,11
	jrst %L161

movdi_volatile_copy:
	move 4,(2)
	move 5,1(2)
	movem 4,(1)
	movem 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_volatile_global_copy:
	move 1,movdi_vg0
	move 2,movdi_vg0+1
	movem 1,movdi_vg1
	movem 2,movdi_vg1+1
	popj 17,

movdi_from_sint:
	move 4,1
	move 2,4
	ash 4,-43
	move 1,4
	popj 17,

movdi_from_usint:
	move 2,1
	movei 1,0
	popj 17,

movdi_store_from_sint:
	move 5,2
	ash 2,-43
	movem 2,(1)
	movem 5,1(1)
	popj 17,

movdi_to_sint:
	move 1,2
	popj 17,

movdi_to_usint:
	move 1,2
	popj 17,

movdi_return_after_store:
	movem 1,(3)
	movem 2,1(3)
	popj 17,

movdi_return_before_store:
	movem 1,(3)
	movem 2,1(3)
	popj 17,

movdi_struct_local:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	move 6,-3(17)
	move 7,-2(17)
	move 1,6
	move 2,7
	add 17,[-4,,-4]
	popj 17,

movdi_struct_local_b:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	move 6,-1(17)
	move 7,4
	move 1,6
	move 2,7
	add 17,[-4,,-4]
	popj 17,

movdi_nested_struct_copy:
	move 3,(2)
	movem 3,(1)
	move 3,1(2)
	movem 3,1(1)
	move 3,2(2)
	movem 3,2(1)
	move 2,3(2)
	movem 2,3(1)
	move 4,(1)
	move 5,1(1)
	move 6,2(1)
	xor 4,6
	xor 5,2
	move 1,4
	move 2,5
	popj 17,

dmove1:
	move 1,3
	move 2,4
	popj 17,

dmove2:
	move 4,(3)
	move 5,1(3)
	move 1,4
	move 2,5
	popj 17,

dmove3:
	move 1,[123456123456]
	move 2,[654321654321]
	popj 17,

dmovem:
	movem 1,(3)
	movem 2,1(3)
	popj 17,

	.bss
movdi_g0:
	.space	8
movdi_g1:
	.space	8
movdi_g2:
	.space	8
movdi_ug0:
	.space	8
movdi_ug1:
	.space	8
movdi_vg0:
	.space	8
movdi_vg1:
	.space	8
movdi_buf:
	.space	128
movdi_ubuf:
	.space	128
movdi_gp:
	.space	16
movdi_ugp:
	.space	16
