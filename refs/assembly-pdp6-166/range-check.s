	.data
	.align	2
g_low:
	.word	17
	.align	2
g_high:
	.word	42
	.align	2
g_int:
	.word	23
	.align	2
vg_int:
	.word	25
	.align	2
gs_int:
	.word	31
	.align	2
vgs_int:
	.word	33

range_or_call:
	cail 1,17
	cail 1,43
	pushj 17,bar
	jrst baz

range_or_ret:
	cail 1,17
	cail 1,43
	jrst bar
	jrst baz

range_or_doublecall:
	cail 1,17
	cail 1,43
	jrst %L8
%L7:
	jrst baz
%L8:
	pushj 17,bar
	pushj 17,bar
	jrst baz

range_or_doubletail:
	cail 1,17
	cail 1,43
	pushj 17,bar
	pushj 17,baz
	jrst baz

range_and_call:
	cail 1,20
	cail 1,42
%L13:
	jrst baz
	pushj 17,bar
	jrst baz

range_and_ret:
	cail 1,20
	cail 1,42
	jrst baz
	jrst bar

range_and_doublecall:
	cail 1,20
	cail 1,42
%L18:
	jrst baz
	pushj 17,bar
	pushj 17,bar
	jrst baz

range_and_doubletail:
	cail 1,20
	cail 1,42
	trna
	pushj 17,bar
	pushj 17,baz
	jrst baz

range_or_zero:
	cail 1,0
	cail 1,43
	pushj 17,bar
	jrst baz

range_and_zero:
	cail 1,0
	cail 1,42
%L27:
	jrst baz
	pushj 17,bar
	jrst baz

range_or_neg:
	caml 1,[-7]
	cail 1,43
	pushj 17,bar
	jrst baz

range_and_neg:
	caml 1,[-7]
	cail 1,42
%L33:
	jrst baz
	pushj 17,bar
	jrst baz

range_or_one:
	cail 1,1
	cail 1,100
	pushj 17,bar
	jrst baz

range_and_one:
	cail 1,1
	cail 1,77
%L39:
	jrst baz
	pushj 17,bar
	jrst baz

range_or_value_small:
	movei 6,0
	cail 1,17
	cail 1,5
	movei 6,1
	move 1,6
	popj 17,

range_or_value_zero:
	skipl 1,1
	cail 1,43
	trna
	tdza 1,1
	movei 1,1
	popj 17,

range_or_value_neg:
	movei 6,0
	caml 1,[-7]
	cail 1,61
	movei 6,1
	move 1,6
	popj 17,

range_or_value_large:
	movei 6,0
	cail 1,400000
	caml 1,[-377700]
	movei 6,1
	move 1,6
	popj 17,

range_and_value_small:
	cail 1,20
	cail 1,2
	tdza 1,1
	movei 1,1
	popj 17,

range_and_value_zero:
	skipl 1,1
	cail 1,42
	tdza 1,1
	movei 1,1
	popj 17,

range_and_value_neg:
	caml 1,[-7]
	cail 1,60
	tdza 1,1
	movei 1,1
	popj 17,

range_and_value_large:
	cail 1,400000
	caml 1,[-377701]
	tdza 1,1
	movei 1,1
	popj 17,

range_inside_closed:
	cail 1,17
	cail 1,5
	tdza 1,1
	movei 1,1
	popj 17,

range_outside_closed:
	movei 6,0
	cail 1,17
	cail 1,5
	movei 6,1
	move 1,6
	popj 17,

range_inside_open:
	cail 1,20
	cail 1,2
	tdza 1,1
	movei 1,1
	popj 17,

range_outside_open:
	movei 6,0
	cail 1,20
	cail 1,2
	movei 6,1
	move 1,6
	popj 17,

range_unsigned_inside:
	cail 1,17
	cail 1,5
	tdza 1,1
	movei 1,1
	popj 17,

range_unsigned_outside:
	movei 6,0
	cail 1,17
	cail 1,5
	movei 6,1
	move 1,6
	popj 17,

range_unsigned_inside_zero:
	skipl 1,1
	cail 1,43
	tdza 1,1
	movei 1,1
	popj 17,

range_unsigned_outside_zero:
	skipl 1,1
	cail 1,43
	trna
	tdza 1,1
	movei 1,1
	popj 17,

range_unsigned_inside_neg:
	caml 1,[-7]
	cail 1,61
	tdza 1,1
	movei 1,1
	popj 17,

range_unsigned_outside_neg:
	movei 6,0
	caml 1,[-7]
	cail 1,61
	movei 6,1
	move 1,6
	popj 17,

range_branch_inside:
	move 4,1
	addi 4,1
	cail 1,17
	cail 1,43
	subi 4,2
	move 1,4
	popj 17,

range_branch_outside:
	move 4,1
	addi 4,2
	cail 1,17
	cail 1,43
	jrst %L61
	subi 4,4
%L61:
	move 1,4
	popj 17,

range_mem_inside:
	move 4,(1)
	move 1,4
	cail 4,17
	cail 4,43
	movei 1,0
	popj 17,

range_mem_outside:
	move 1,(1)
	subi 1,17
	skipl 1,1
	cail 1,24
	trna
	tdza 1,1
	movei 1,1
	popj 17,

range_mem_unsigned:
	move 1,(1)
	subi 1,17
	skipl 1,1
	cail 1,24
	tdza 1,1
	movei 1,1
	popj 17,

range_global_inside:
	move 1,g_int
	subi 1,17
	skipl 1,1
	cail 1,24
	tdza 1,1
	movei 1,1
	popj 17,

range_global_limits:
	camge 1,g_low
	jrst %L71
	movei 4,1
	camle 1,g_high
%L71:
	seto 4,
	move 1,4
	popj 17,

range_volatile_inside:
	move 1,vg_int
	cail 1,17
	cail 1,5
	tdza 1,1
	movei 1,1
	popj 17,

range_sint_inside:
	cail 1,17
	cail 1,5
	tdza 1,1
	movei 1,1
	popj 17,

range_sint_mem:
	move 1,(1)
	subi 1,17
	skipl 1,1
	cail 1,24
	trna
	tdza 1,1
	movei 1,1
	popj 17,

range_sint_volatile:
	move 1,vgs_int
	cail 1,17
	cail 1,5
	tdza 1,1
	movei 1,1
	popj 17,

range_u_compare:
	cail 1,17
	cail 1,5
	tdza 1,1
	movei 1,1
	popj 17,

range_u_outside:
	movei 6,0
	cail 1,17
	cail 1,5
	movei 6,1
	move 1,6
	popj 17,

range_qi_promote:
	addi 1,775
	andi 1,777
	tlc 1,400000
	move 6,[-377777777762]
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

range_hi_promote:
	movei 1,24(1)
	tlc 1,400000
	move 6,[-377777777730]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

range_select:
	cail 1,17
	cail 1,43
	move 2,3
	move 1,2
	popj 17,

range_call_arg:
	cail 1,17
	cail 1,5
	tdza 1,1
	movei 1,1
	jrst use_int

range_store_flag:
	movei 4,0
	cail 2,17
	cail 2,5
	movei 4,1
	movem 4,(1)
	move 1,4
	popj 17,

range_mixed_arith:
	move 4,1
	addi 4,10
	cail 1,14
	cail 1,40
	subi 4,12
	move 1,4
	popj 17,

range_large_literal:
	cail 1,400000
	caml 1,[-377700]
	tdza 1,1
	movei 1,1
	popj 17,

	.globl	use_range_check
use_range_check:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	pushj 17,range_or_value_small
	move 10,1
	move 1,11
	pushj 17,range_or_value_zero
	add 10,1
	move 1,11
	pushj 17,range_or_value_neg
	add 10,1
	move 1,11
	pushj 17,range_or_value_large
	add 10,1
	move 1,11
	pushj 17,range_and_value_small
	add 10,1
	move 1,11
	pushj 17,range_and_value_zero
	add 10,1
	move 1,11
	pushj 17,range_and_value_neg
	add 10,1
	move 1,11
	pushj 17,range_and_value_large
	add 10,1
	move 1,11
	pushj 17,range_inside_closed
	add 10,1
	move 1,11
	pushj 17,range_outside_closed
	add 10,1
	move 1,11
	pushj 17,range_inside_open
	add 10,1
	move 1,11
	pushj 17,range_outside_open
	add 10,1
	move 1,11
	pushj 17,range_unsigned_inside
	add 10,1
	move 1,11
	pushj 17,range_unsigned_outside
	add 10,1
	move 1,11
	pushj 17,range_unsigned_inside_zero
	add 10,1
	move 1,11
	pushj 17,range_unsigned_outside_zero
	add 10,1
	move 1,11
	pushj 17,range_unsigned_inside_neg
	add 10,1
	move 1,11
	pushj 17,range_unsigned_outside_neg
	add 10,1
	move 1,11
	pushj 17,range_branch_inside
	add 10,1
	move 1,11
	pushj 17,range_branch_outside
	add 10,1
	move 1,12
	pushj 17,range_mem_inside
	add 10,1
	move 1,12
	pushj 17,range_mem_outside
	add 10,1
	move 1,12
	pushj 17,range_mem_unsigned
	add 10,1
	pushj 17,range_global_inside
	add 10,1
	move 1,11
	pushj 17,range_global_limits
	add 10,1
	pushj 17,range_volatile_inside
	add 10,1
	move 1,11
	pushj 17,range_sint_inside
	add 10,1
	movei 1,gs_int
	pushj 17,range_sint_mem
	add 10,1
	pushj 17,range_sint_volatile
	add 10,1
	move 1,11
	pushj 17,range_u_compare
	add 10,1
	move 1,11
	pushj 17,range_u_outside
	add 10,1
	move 1,11
	lsh 1,33
	ash 1,-33
	pushj 17,range_qi_promote
	add 10,1
	hrre 1,11	; extendhisi2
	pushj 17,range_hi_promote
	add 10,1
	move 1,11
	movei 2,13
	movei 3,26
	pushj 17,range_select
	add 10,1
	move 1,12
	move 2,11
	pushj 17,range_store_flag
	add 10,1
	move 1,11
	pushj 17,range_mixed_arith
	add 10,1
	move 1,11
	pushj 17,range_large_literal
	add 10,1
	move 1,11
	pushj 17,range_call_arg
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

