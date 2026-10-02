
aobj_step:
	add 1,[1000001]
	popj 17,

aobj_step_twice:
	add 1,[2000002]
	popj 17,

aobj_step_unsigned:
	add 1,[1000001]
	popj 17,

uaobj_step:
	add 1,[1000001]
	popj 17,

aobj_get_addr:
	movei 1,1(1)
	popj 17,

aobj_get_count_bits:
	add 1,[1000001]
	hllz 1,1
	popj 17,

aobj_from_mem:
	move 1,(1)
	add 1,[1000001]
	popj 17,

aobj_from_global:
	move 1,aobj_ga
	add 1,[1000001]
	popj 17,

aobj_from_array:
	andi 1,17
	move 1,aobj_buf(1)
	add 1,[1000001]
	popj 17,

aobj_from_struct_a:
	move 1,(1)
	add 1,[1000001]
	popj 17,

aobj_from_struct_b:
	move 1,1(1)
	add 1,[1000001]
	popj 17,

aobj_store:
	add 2,[1000001]
	movem 2,(1)
	popj 17,

aobj_store_global:
	add 1,[1000001]
	movem 1,aobj_ga
	popj 17,

aobj_store_array:
	andi 2,17
	add 1,2
	add 3,[1000001]
	movem 3,(1)
	popj 17,

aobj_store_struct_a:
	add 2,[1000001]
	movem 2,(1)
	popj 17,

aobj_update_mem:
	move 4,(1)
	add 4,[1000001]
	movem 4,(1)
	move 1,4
	popj 17,

aobj_update_global:
	move 1,aobj_ga
	add 1,[1000001]
	movem 1,aobj_ga
	popj 17,

aobj_update_array:
	andi 1,17
	move 4,aobj_buf(1)
	add 4,[1000001]
	movem 4,aobj_buf(1)
	move 1,4
	popj 17,

aobj_update_struct_a:
	move 4,(1)
	add 4,[1000001]
	movem 4,(1)
	move 1,4
	popj 17,

aobjn_clear:
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

aobjn_select:
	add 1,[1000001]
	add 2,1
	jumpl 1,%L23
	move 2,3
	add 2,1
%L23:
	move 1,2
	popj 17,

aobjn_call:
	push 17,10
	move 10,1
	add 10,[1000001]
	jumpl 10,%L27
%L26:
	move 1,10
	pop 17,10
	popj 17,
%L27:
	pushj 17,f
	add 10,1
	jrst %L26

aobjn_likely:
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

aobjn_unlikely:
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

aobjn_unsigned_step:
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

aobjn_mem:
	move 1,(1)
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

aobjn_global:
	move 1,aobj_ga
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

aobjn_array:
	andi 1,17
	move 1,aobj_buf(1)
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

aobjn_struct_a:
	move 1,(1)
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

aobjn_update_mem:
	push 17,10
	move 10,1
	move 4,(1)
	add 4,[1000001]
	movem 4,(1)
	jumpl 4,%L44
%L43:
	move 1,(10)
	pop 17,10
	popj 17,
%L44:
	pushj 17,f
	jrst %L43

aobjn_update_global:
	move 1,aobj_ga
	add 1,[1000001]
	movem 1,aobj_ga
	jumpl 1,%L47
%L46:
	popj 17,
%L47:
	pushj 17,f
	move 1,aobj_ga
	popj 17,

aobjn_update_array:
	push 17,10
	move 10,1
	andi 10,17
	move 4,aobj_buf(10)
	add 4,[1000001]
	movem 4,aobj_buf(10)
	jumpl 4,%L50
%L49:
	move 1,aobj_buf(10)
	pop 17,10
	popj 17,
%L50:
	pushj 17,f
	jrst %L49

aobjn_update_struct_a:
	push 17,10
	move 10,1
	move 4,(1)
	add 4,[1000001]
	movem 4,(1)
	jumpl 4,%L53
%L52:
	move 1,(10)
	pop 17,10
	popj 17,
%L53:
	pushj 17,f
	jrst %L52

aobjp_clear:
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

aobjp_select:
	add 1,[1000001]
	add 2,1
	jumpl 1,%L58
%L56:
	move 1,2
	popj 17,
%L58:
	move 2,3
	add 2,1
	jrst %L56

aobjp_call:
	push 17,10
	move 10,1
	add 10,[1000001]
	jumpl 10,%L60
	pushj 17,f
	add 10,1
%L60:
	move 1,10
	pop 17,10
	popj 17,

aobjp_likely:
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

aobjp_unlikely:
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

aobjp_unsigned_step:
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

aobjp_mem:
	move 1,(1)
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

aobjp_global:
	move 1,aobj_ga
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

aobjp_array:
	andi 1,17
	move 1,aobj_buf(1)
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

aobjp_struct_a:
	move 1,(1)
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

aobjp_update_mem:
	push 17,10
	move 10,1
	move 4,(1)
	add 4,[1000001]
	movem 4,(1)
	jumpl 4,%L76
	pushj 17,f
%L76:
	move 1,(10)
	pop 17,10
	popj 17,

aobjp_update_global:
	move 1,aobj_ga
	add 1,[1000001]
	movem 1,aobj_ga
	jumpl 1,%L78
	pushj 17,f
	move 1,aobj_ga
%L78:
	popj 17,

aobjp_update_array:
	push 17,10
	move 10,1
	andi 10,17
	move 4,aobj_buf(10)
	add 4,[1000001]
	movem 4,aobj_buf(10)
	jumpl 4,%L80
	pushj 17,f
%L80:
	move 1,aobj_buf(10)
	pop 17,10
	popj 17,

aobjp_update_struct_a:
	push 17,10
	move 10,1
	move 4,(1)
	add 4,[1000001]
	movem 4,(1)
	jumpl 4,%L82
	pushj 17,f
%L82:
	move 1,(10)
	pop 17,10
	popj 17,

aobjn_loop_sum:
	movei 4,0
%L84:
	add 4,(2)
	addi 2,1
	add 1,[1000001]
	jumpl 1,%L84
	add 4,1
	move 1,4
	popj 17,

aobjn_loop_sum_guarded:
	move 4,1
	jumpl 1,%L94
%L88:
	move 1,4
	popj 17,
%L94:
	movei 4,0
%L90:
	add 4,(2)
	addi 2,1
	add 1,[1000001]
	jumpl 1,%L90
	add 4,1
	jrst %L88

aobjn_loop_count:
	movei 4,0
%L96:
	addi 4,1
	add 1,[1000001]
	jumpl 1,%L96
	add 4,1
	move 1,4
	popj 17,

aobjn_loop_store:
%L101:
	movem 3,(2)
	addi 2,1
	add 1,[1000001]
	jumpl 1,%L101
	popj 17,

aobjn_loop_copy:
%L106:
	move 6,(3)
	movem 6,(2)
	addi 3,1
	addi 2,1
	add 1,[1000001]
	jumpl 1,%L106
	popj 17,

aobjn_loop_find_zero:
%L111:
	move 4,(2)
	addi 2,1
	jumpe 4,%L110
	add 1,[1000001]
	jumpl 1,%L111
%L110:
	popj 17,

aobjp_loop_sum:
	movei 4,0
%L117:
	add 4,(2)
	addi 2,1
	add 1,[1000001]
	jumpge 1,%L117
	add 4,1
	move 1,4
	popj 17,

aobjp_loop_count:
	movei 4,0
%L122:
	addi 4,1
	add 1,[1000001]
	jumpge 1,%L122
	add 4,1
	move 1,4
	popj 17,

aobjn_addr_select:
	add 1,[1000001]
	hrrz 4,1
	add 2,4
	jumpl 1,%L126
	move 2,3
	add 2,4
%L126:
	move 1,2
	popj 17,

aobjp_addr_select:
	add 1,[1000001]
	hrrz 4,1
	add 2,4
	jumpl 1,%L130
%L128:
	move 1,2
	popj 17,
%L130:
	move 2,3
	add 2,4
	jrst %L128

aobjn_addr_load:
	add 1,[1000001]
	jumpl 1,%L134
%L131:
	popj 17,
%L134:
	andi 1,17
	add 2,1
	move 1,(2)
	popj 17,

aobjp_addr_load:
	add 1,[1000001]
	jumpl 1,%L135
	andi 1,17
	add 2,1
	move 1,(2)
%L135:
	popj 17,

uaobjn_step:
	add 1,[1000001]
	caige 1,0
	movei 1,0
	popj 17,

uaobjp_step:
	add 1,[1000001]
	caile 1,0
	movei 1,0
	popj 17,

uaobj_update_global:
	move 1,aobj_uga
	add 1,[1000001]
	movem 1,aobj_uga
	popj 17,

uaobjn_loop_count:
	movei 4,0
%L144:
	addi 4,1
	add 1,[1000001]
	jumpl 1,%L144
	add 4,1
	move 1,4
	popj 17,

uaobjp_loop_count:
	movei 4,0
%L149:
	addi 4,1
	add 1,[1000001]
	jumpge 1,%L149
	add 4,1
	move 1,4
	popj 17,

aobjn_explicit_lt:
	add 1,[1000001]
	skipl 1
	tdza 1,1
	movei 1,1
	popj 17,

aobjp_explicit_ge:
	add 1,[1000001]
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

aobjn_explicit_not_ge:
	add 1,[1000001]
	skipl 1
	tdza 1,1
	movei 1,1
	popj 17,

aobjp_explicit_not_lt:
	add 1,[1000001]
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

aobjn_two_steps:
	add 1,[1000001]
	jumpl 1,%L163
%L162:
	popj 17,
%L163:
	add 1,[1000001]
	popj 17,

aobjp_two_steps:
	add 1,[1000001]
	jumpl 1,%L165
	add 1,[1000001]
%L165:
	popj 17,

aobj_mixed_global:
	add 1,[1000001]
	jumpl 1,%L169
	movem 1,aobj_gb
%L168:
	popj 17,
%L169:
	movem 1,aobj_ga
	popj 17,

	.bss
aobj_ga:
	.space	4
aobj_gb:
	.space	4
aobj_uga:
	.space	4
aobj_buf:
	.space	64
aobj_gp:
	.space	8
