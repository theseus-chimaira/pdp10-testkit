
jrst_infinite_loop:
%L2:
	jrst %L2

jrst_forward_loop:
%L4:
	jumpe 1,%L3
	soja 1,%L4
%L6:
%L3:
	popj 17,

jrst_forward_join:
	seto 4,
	jumpl 1,%L7
	movei 4,1
	jumpn 1,%L7
%L9:
%L11:
	movei 4,0
%L12:
%L7:
	move 1,4
	popj 17,

jrst_cleanup:
	move 4,1
	movei 1,0
	jumpe 2,%L15
	seto 1,
	jumpl 4,%L15
	move 1,(2)
	add 1,4
%L17:
%L15:
	popj 17,

jrst_multi_join:
	move 4,1
	sub 4,2
	jumpl 1,%L23
	move 4,1
	add 4,2
	jumpl 2,%L24
%L23:
	move 1,4
	popj 17,
%L20:
%L22:
%L24:
	move 4,2
	sub 4,1
	jrst %L23

jrst_loop_break_continue:
	move 6,1
	setzb 3,1
%L26:
	caml 3,2
	popj 17,
	trne 3,1
	jrst %L30
	move 4,3
	andi 4,7
	add 4,6
	skipn 4,(4)
	popj 17,
	add 1,4
%L30:
	aoja 3,%L26

jrst_nested_loops:
	move 7,1
	setzb 6,1
%L35:
	caml 6,2
	popj 17,
	movei 3,0
%L38:
	caile 3,3
	jrst %L40
	move 4,6
	add 4,3
	andi 4,7
	add 4,7
	add 1,(4)
	aoja 3,%L38
%L40:
	aoja 6,%L35

jrst_switch_dense:
	andi 1,7
	jumpl 1,%L59
	caile 1,6
	jrst %L59
	jrst @%L60(1)
%L60:
	.word	.45
	.word	.47
	.word	.49
	.word	.51
	.word	.53
	.word	.55
	.word	.57
%L45:
	movei 1,10
%L42:
	popj 17,
%L59:
	movei 1,17
	popj 17,
%L47:
	movei 1,11
	popj 17,
%L49:
	movei 1,12
	popj 17,
%L51:
	movei 1,13
	popj 17,
%L53:
	movei 1,14
	popj 17,
%L55:
	movei 1,15
	popj 17,
%L57:
	movei 1,16
	popj 17,

jrst_switch_sparse:
	movei 4,0
	jumpe 1,%L61
	jumple 1,%L75
	movei 4,123456
	cain 1,123456
	jrst %L61
	movei 4,777777
	caie 1,777777
%L64:
%L66:
%L68:
%L70:
%L72:
	move 4,1
%L61:
	move 1,4
	popj 17,
%L75:
	seto 4,
	camn 1,[-1]
	jrst %L61
	jrst %L72

jrst_computed_arg:
	jrst (1)

jrst_computed_arg_after_mask:
	jumpn 2,%L80
	movei 1,0
	popj 17,
%L80:
	jrst (1)

jrst_computed_mem:
	move 4,(1)
	jrst (4)

jrst_computed_index:
	andi 2,7
	add 1,2
	move 4,(1)
	jrst (4)

	.data
	.align	2
table%0:
	.long	%L85+301989888
	.long	%L87+301989888
	.long	%L89+301989888
	.long	%L91+301989888
	.long	%L93+301989888
	.long	%L95+301989888
	.long	%L97+301989888
	.long	%L99+301989888

jrst_computed_local:
	andi 1,7
	move 4,table%0(1)
	jrst (4)
%L85:
	movei 1,0
%L84:
	popj 17,
%L87:
	movei 1,1
	popj 17,
%L89:
	movei 1,2
	popj 17,
%L91:
	movei 1,3
	popj 17,
%L93:
	movei 1,4
	popj 17,
%L95:
	movei 1,5
	popj 17,
%L97:
	movei 1,6
	popj 17,
%L99:
	movei 1,7
	popj 17,

	.data
	.align	2
table%1:
	.long	%L102+301989888
	.long	%L104+301989888
	.long	%L106+301989888
	.long	%L108+301989888

jrst_computed_local_fallthrough:
	andi 1,3
	move 4,table%1(1)
	jrst (4)
%L102:
%L110:
	move 1,2
	popj 17,
%L104:
	aoja 2,%L110
%L106:
	addi 2,2
	jrst %L110
%L108:
	addi 2,3
	jrst %L110

	.data
	.align	2
t0%2:
	.long	%L112+301989888
	.long	%L114+301989888
	.long	%L116+301989888
	.long	%L118+301989888
	.align	2
t1%3:
	.long	%L120+301989888
	.long	%L122+301989888
	.long	%L124+301989888
	.long	%L126+301989888

jrst_computed_two_tables:
	jumpl 1,%L130
	andi 2,3
	move 2,t1%3(2)
%L129:
	jrst (2)
%L112:
	movei 1,10
%L111:
	popj 17,
%L114:
	movei 1,11
	popj 17,
%L116:
	movei 1,12
	popj 17,
%L118:
	movei 1,13
	popj 17,
%L120:
	movei 1,20
	popj 17,
%L122:
	movei 1,21
	popj 17,
%L124:
	movei 1,22
	popj 17,
%L126:
	movei 1,23
	popj 17,
%L130:
	andi 2,3
	move 2,t0%2(2)
	jrst %L129

jrst_computed_store_label:
	move 6,[POINT 18,%L133,35]
	jumpe 2,%L138
	move 6,[POINT 18,%L136,35]
%L138:
	movem 6,(1)
	jrst @(1)
%L133:
	movei 1,0
%L131:
	popj 17,
%L136:
	movei 1,1
	popj 17,

jrst_computed_reload_label:
	move 6,[POINT 18,%L141,35]
	jumpe 2,%L146
	move 6,[POINT 18,%L144,35]
%L146:
	movem 6,(1)
	move 4,(1)
	jrst (4)
%L141:
	movei 1,0
%L139:
	popj 17,
%L144:
	movei 1,1
	popj 17,

jrst_tail_call1:
	jrst jre1

jrst_tail_call2:
	jrst jre2

jrst_tail_call3:
	jrst jre3

jrst_tail_vcall1:
	jrst jrv1

jrst_tail_vcall2:
	jrst jrv2

jrst_tail_call_cond:
	jumpl 1,jre1
	jrst jre2
%L154:
	jrst jre1

jrst_tail_call_after_work:
	add 1,2
	jrst jre1

jrst_tail_call_through_ptr:
	move 4,1
	move 1,2
	pushj 17,(4)
	popj 17,

jrst_tail_call_through_ptr2:
	move 4,1
	move 1,2
	move 2,3
	pushj 17,(4)
	popj 17,

jrst_recursive_void:
%L159:
	jrst %L159

jrst_recursive_sint:
%L161:
	jrst %L161

jrst_tail_recursive_loop:
%L164:
	jumpe 2,%L165
	addi 1,1
	soja 2,%L164
%L165:
	popj 17,

jrst_noreturn_like:
	push 17,10
	move 10,1
%L167:
	pushj 17,clobber
	jumpe 10,%L167
	soja 10,%L167

jrst_label_value_return:
	move 3,1
	move 4,[POINT 18,%L171,35]
	jumpe 1,%L173
	move 4,[POINT 18,%L174,35]
%L173:
	move 1,4
	jumpl 3,%L169
	jrst (4)
%L171:
	movei 1,0
%L169:
	popj 17,
%L174:
	movei 1,1
	popj 17,

	.data
	.align	2
ops%4:
	.long	%L179+301989888
	.long	%L181+301989888
	.long	%L183+301989888
	.long	%L185+301989888

jrst_threaded_interpreter:
	move 7,1
	setzb 6,1
%L187:
	caml 6,2
	popj 17,
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L191
%L190:
	ibp 3
	sojn 4,%L190	; decrement_and_branch_until_zero
%L191:
	ldb 4,3
	andi 4,3
	move 4,ops%4(4)
	addi 6,1
	jrst (4)
%L179:
	aoja 1,%L187
%L181:
	addi 1,2
	jrst %L187
%L183:
	addi 1,3
	jrst %L187
%L185:
	popj 17,

