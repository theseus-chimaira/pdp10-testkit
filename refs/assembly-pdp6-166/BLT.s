
blt_array_100:
	move 4,[b,,a]
	blt 4,a+77
	popj 17,

blt_array_4:
	move 4,[d_small,,c_small]
	blt 4,c_small+3
	popj 17,

blt_array_1_word:
	move 6,b
	movem 6,a
	popj 17,

blt_array_2_words:
	move 4,[b,,a]
	blt 4,a+1
	popj 17,

blt_array_3_words:
	move 4,[b,,a]
	blt 4,a+2
	popj 17,

blt_array_7_words:
	move 4,[b,,a]
	blt 4,a+6
	popj 17,

blt_array_010_words:
	move 4,[b,,a]
	blt 4,a+7
	popj 17,

blt_array_077_words:
	move 4,[b,,a]
	blt 4,a+76
	popj 17,

blt_array_offset_src:
	move 1,[POINT 9,a,8]
	movei 2,b+1
	tlo 2,331100
	tlo 1,331100
	movei 3,374
	jrst memcpy

blt_array_offset_dst:
	movei 1,a+1
	tlo 1,331100
	move 2,[POINT 9,b,8]
	tlo 2,331100
	movei 3,374
	jrst memcpy

blt_array_offset_both:
	movei 1,a+1
	tlo 1,331100
	movei 2,b+2
	tlo 2,331100
	tlc 2,113300
	movei 3,364
	jrst memcpy

blt_ptr_100:
	movei 4,(1)
	hrl 4,2
	blt 4,77(1)
	popj 17,

blt_ptr_4:
	movei 4,(1)
	hrl 4,2
	blt 4,3(1)
	popj 17,

blt_ptr_1_word:
	move 2,(2)
	movem 2,(1)
	popj 17,

blt_ptr_2_words:
	movei 4,(1)
	hrl 4,2
	blt 4,1(1)
	popj 17,

blt_ptr_indexed:
	andi 3,7
	add 1,3
	andi 4,7
	add 2,4
	movei 4,(1)
	hrl 4,2
	blt 4,7(1)
	popj 17,

blt_ptr_large_indexed:
	andi 3,77
	add 1,3
	andi 4,77
	add 2,4
	movei 4,(1)
	hrl 4,2
	blt 4,37(1)
	popj 17,

blt_char_0400:
	move 1,[POINT 9,ca,8]
	move 2,[POINT 9,cb,8]
	movei 3,400
	jrst memcpy

blt_char_unaligned_offsets:
	move 1,[POINT 9,ca,17]
	move 2,[POINT 9,cb,26]
	movei 3,77
	jrst memcpy

blt_char_ptr:
	movei 3,400
	jrst memcpy

blt_char_ptr_small:
	movei 3,17
	jrst memcpy

blt_clear_array_100:
	move 3,[a,,a+1]
	setzm a
	blt 3,a+77
	popj 17,

blt_clear_array_4:
	move 3,[c_small,,c_small+1]
	setzm c_small
	blt 3,c_small+3
	popj 17,

blt_clear_array_1_word:
	setzm a
	popj 17,

blt_clear_array_2_words:
	move 3,[a,,a+1]
	setzm a
	blt 3,a+1
	popj 17,

blt_clear_array_3_words:
	move 3,[a,,a+1]
	setzm a
	blt 3,a+2
	popj 17,

blt_clear_array_offset:
	movei 1,a+1
	tlo 1,331100
	movei 2,0
	movei 3,374
	jrst memset

blt_clear_ptr_100:
	movs 4,1
	hrri 4,1(1)
	setzm (1)
	blt 4,77(1)
	popj 17,

blt_clear_ptr_4:
	movs 4,1
	hrri 4,1(1)
	setzm (1)
	blt 4,3(1)
	popj 17,

blt_clear_ptr_1_word:
	setzm (1)
	popj 17,

blt_clear_ptr_indexed:
	andi 2,7
	add 1,2
	movs 4,1
	hrri 4,1(1)
	setzm (1)
	blt 4,7(1)
	popj 17,

blt_clear_char_0400:
	move 1,[POINT 9,ca,8]
	movei 2,0
	movei 3,400
	jrst memset

blt_clear_char_unaligned:
	move 1,[POINT 9,ca,17]
	movei 2,0
	movei 3,77
	jrst memset

blt_clear_char_ptr:
	movei 2,0
	movei 3,400
	jrst memset

blt_clear_char_ptr_small:
	movei 2,0
	movei 3,17
	jrst memset

blt_struct_small:
	move 4,[gs1,,gs0]
	blt 4,gs0+3
	popj 17,

blt_struct_mixed:
	move 4,[gm1,,gm0]
	blt 4,gm0+4
	popj 17,

blt_struct_large:
	move 4,[gl1,,gl0]
	blt 4,gl0+77
	popj 17,

blt_struct_small_ptr:
	movei 4,(1)
	hrl 4,2
	blt 4,3(1)
	popj 17,

blt_struct_mixed_ptr:
	movei 4,(1)
	hrl 4,2
	blt 4,4(1)
	popj 17,

blt_struct_large_ptr:
	movei 4,(1)
	hrl 4,2
	blt 4,77(1)
	popj 17,

blt_struct_small_return:
	push 17,10
	move 6,(1)
	move 7,1(1)
	move 5,2(1)
	move 10,3(1)
	move 1,6
	move 2,7
	move 3,5
	move 4,10
	pop 17,10
	popj 17,

blt_struct_mixed_return:
	push 17,10
	move 10,1
	tlo 1,331100
	tlo 2,331100
	movei 3,24
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

blt_struct_small_arg:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	movei 4,gs0
	hrli 4,-3(17)
	blt 4,gs0+3
	add 17,[-4,,-4]
	popj 17,

blt_struct_mixed_arg:
	add 17,[4,,4]
	move 0,-4(17)
	movem 0,(17)
	movem 1,-4(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	movei 4,gm0
	hrli 4,-5(17)
	blt 4,gm0+4
	move 0,(17)
	movem 0,-4(17)
	add 17,[-4,,-4]
	popj 17,

blt_local_array_copy:
	add 17,[10,,10]
	movei 4,-7(17)
	movei 3,(4)
	hrl 3,1
	blt 3,7(4)
	movei 3,a
	hrl 3,4
	blt 3,a+7
	add 17,[-10,,-10]
	popj 17,

blt_local_array_use:
	add 17,[10,,10]
	movei 4,-7(17)
	movei 3,(4)
	hrl 3,1
	blt 3,7(4)
	move 1,-7(17)
	add 1,(17)
	add 17,[-10,,-10]
	popj 17,

blt_local_clear_and_copy:
	add 17,[10,,10]
	movei 4,-7(17)
	movs 2,4
	hrri 2,1(4)
	move 3,4
	addi 3,7
	setzm (4)
	blt 2,(3)
	movei 2,(4)
	hrl 2,1
	blt 2,(3)
	movei 3,a
	hrl 3,4
	blt 3,a+7
	add 17,[-10,,-10]
	popj 17,

blt_nested_struct_copy:
	add 17,[100,,100]
	movei 4,-77(17)
	hrl 4,2
	blt 4,(17)
	movei 4,(1)
	hrli 4,-77(17)
	blt 4,77(1)
	add 17,[-100,,-100]
	popj 17,

blt_memmove_like_forward:
	movei 6,1
	add 6,1
	movei 4,(6)
	hrl 4,2
	blt 4,100(1)
	popj 17,

blt_memmove_like_backward:
	movei 4,(1)
	hrli 4,1(2)
	blt 4,77(1)
	popj 17,

blt_nonzero_memset_word:
	jumpe 1,%L223
	move 4,1
	tlo 4,331100
%L223:
	move 1,4
	movei 2,377
	movei 3,400
	jrst memset

blt_nonzero_memset_char:
	movei 2,123
	movei 3,77
	jrst memset

	.comm	a, 256
	.comm	b, 256
	.comm	c_small, 16
	.comm	d_small, 16
	.comm	ca, 256
	.comm	cb, 256
	.comm	gs0, 16
	.comm	gs1, 16
	.comm	gm0, 20
	.comm	gm1, 20
	.comm	gl0, 256
	.comm	gl1, 256
