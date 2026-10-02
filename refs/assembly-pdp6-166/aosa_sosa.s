
inc_branch_eq:
	aosn 1,(1)
	jrst %L1
	move 2,3
	add 2,1
%L1:
	move 1,2
	popj 17,

inc_branch_ne:
	aosn 1,(1)
	jrst %L3
	move 3,2
	add 3,1
%L3:
	move 1,3
	popj 17,

inc_branch_gt:
	aosg 1,(1)
	jrst %L5
	move 3,2
	add 3,1
%L5:
	move 1,3
	popj 17,

inc_branch_ge:
	aosge 1,(1)
	jrst %L7
	move 3,2
	add 3,1
%L7:
	move 1,3
	popj 17,

inc_branch_lt:
	aosl 1,(1)
	jrst %L9
	move 3,2
	add 3,1
%L9:
	move 1,3
	popj 17,

inc_branch_le:
	aosle 1,(1)
	jrst %L11
	move 3,2
	add 3,1
%L11:
	move 1,3
	popj 17,

dec_branch_eq:
	sosn 1,(1)
	jrst %L13
	move 2,3
	add 2,1
%L13:
	move 1,2
	popj 17,

dec_branch_ne:
	sosn 1,(1)
	jrst %L15
	move 3,2
	add 3,1
%L15:
	move 1,3
	popj 17,

dec_branch_gt:
	sosg 1,(1)
	jrst %L17
	move 3,2
	add 3,1
%L17:
	move 1,3
	popj 17,

dec_branch_ge:
	sosge 1,(1)
	jrst %L19
	move 3,2
	add 3,1
%L19:
	move 1,3
	popj 17,

dec_branch_lt:
	sosl 1,(1)
	jrst %L21
	move 3,2
	add 3,1
%L21:
	move 1,3
	popj 17,

dec_branch_le:
	sosle 1,(1)
	jrst %L23
	move 3,2
	add 3,1
%L23:
	move 1,3
	popj 17,

inc_then_use:
	aos 1,(1)
	popj 17,

dec_then_use:
	sos 1,(1)
	popj 17,

inc_then_use_plus:
	aos (1)
	add 2,(1)
	move 1,2
	popj 17,

dec_then_use_plus:
	sos (1)
	add 2,(1)
	move 1,2
	popj 17,

inc_then_void:
	aos (1)
	popj 17,

dec_then_void:
	sos (1)
	popj 17,

preinc_value:
	aos 1,(1)
	popj 17,

predec_value:
	sos 1,(1)
	popj 17,

preinc_value_branch:
	aos (1)
	movei 4,1
	skipe 1,(1)
	move 4,1
	move 1,4
	popj 17,

predec_value_branch:
	sos (1)
	movei 4,1
	skipe 1,(1)
	move 4,1
	move 1,4
	popj 17,

postinc_value:
	move 4,(1)
	aos (1)
	add 4,(1)
	move 1,4
	popj 17,

postdec_value:
	move 4,(1)
	sos (1)
	add 4,(1)
	move 1,4
	popj 17,

postinc_branch_old:
	aos 1,(1)
	cain 1,1
	jrst %L39
	move 2,3
	add 2,1
%L39:
	move 1,2
	popj 17,

postdec_branch_old:
	sos 1,(1)
	camn 1,[-1]
	jrst %L41
	move 2,3
	add 2,1
%L41:
	move 1,2
	popj 17,

postinc_branch_new:
	aosn 1,(1)
	jrst %L43
	move 2,3
	add 2,1
%L43:
	move 1,2
	popj 17,

postdec_branch_new:
	sosn 1,(1)
	jrst %L45
	move 2,3
	add 2,1
%L45:
	move 1,2
	popj 17,

inc_goto_eq:
	aosn 1,(1)
	jrst %L47
	move 2,3
	add 2,1
%L49:
%L47:
	move 1,2
	popj 17,

dec_goto_eq:
	sosn 1,(1)
	jrst %L50
	move 2,3
	add 2,1
%L52:
%L50:
	move 1,2
	popj 17,

inc_goto_gt:
	aosg 1,(1)
	jrst %L53
%L55:
	move 3,2
	add 3,1
%L53:
	move 1,3
	popj 17,

dec_goto_lt:
	sosl 1,(1)
	jrst %L56
%L58:
	move 3,2
	add 3,1
%L56:
	move 1,3
	popj 17,

inc_branch_inverted_eq:
	aosn 1,(1)
	jrst %L59
%L61:
	move 2,3
	add 2,1
%L59:
	move 1,2
	popj 17,

dec_branch_inverted_eq:
	sosn 1,(1)
	jrst %L62
%L64:
	move 2,3
	add 2,1
%L62:
	move 1,2
	popj 17,

inc_branch_inverted_gt:
	aosg 1,(1)
	jrst %L65
	move 3,2
	add 3,1
%L67:
%L65:
	move 1,3
	popj 17,

dec_branch_inverted_lt:
	sosl 1,(1)
	jrst %L68
	move 3,2
	add 3,1
%L70:
%L68:
	move 1,3
	popj 17,

inc_global_eq:
	aosn 4,aosa_gi
	popj 17,
	move 1,2
	add 1,4
	popj 17,

dec_global_eq:
	sosn 4,sosa_gi
	popj 17,
	move 1,2
	add 1,4
	popj 17,

inc_global_gt:
	move 3,1
	aos aosa_gi
	move 1,2
	skipg 4,aosa_gi
	popj 17,
	move 1,3
	add 1,4
	popj 17,

dec_global_lt:
	move 3,1
	sos sosa_gi
	move 1,2
	skipl 4,sosa_gi
%L77:
	popj 17,
	move 1,3
	add 1,4
	popj 17,

inc_global_then_use:
	aos 1,aosa_gi
	popj 17,

dec_global_then_use:
	sos 1,sosa_gi
	popj 17,

inc_sint_branch_eq:
	aosn 1,(1)
	jrst %L82
	move 2,3
	add 2,1
%L82:
	move 1,2
	popj 17,

dec_sint_branch_eq:
	sosn 1,(1)
	jrst %L84
	move 2,3
	add 2,1
%L84:
	move 1,2
	popj 17,

inc_sint_branch_gt:
	aosg 1,(1)
	jrst %L86
	move 3,2
	add 3,1
%L86:
	move 1,3
	popj 17,

dec_sint_branch_lt:
	sosl 1,(1)
	jrst %L88
	move 3,2
	add 3,1
%L88:
	move 1,3
	popj 17,

inc_sint_global_eq:
	aosn 4,aosa_gs
	popj 17,
	move 1,2
	add 1,4
	popj 17,

dec_sint_global_eq:
	sosn 4,sosa_gs
	popj 17,
	move 1,2
	add 1,4
	popj 17,

inc_array_eq:
	andi 2,17
	add 1,2
	aosn 1,(1)
	jrst %L94
	move 3,4
	add 3,1
%L94:
	move 1,3
	popj 17,

dec_array_eq:
	andi 2,17
	add 1,2
	sosn 1,(1)
	jrst %L98
	move 3,4
	add 3,1
%L98:
	move 1,3
	popj 17,

inc_array_gt:
	andi 2,17
	add 1,2
	aosg 1,(1)
	jrst %L102
	move 4,3
	add 4,1
%L102:
	move 1,4
	popj 17,

dec_array_lt:
	andi 2,17
	add 1,2
	sosl 1,(1)
	jrst %L106
	move 4,3
	add 4,1
%L106:
	move 1,4
	popj 17,

inc_array_then_use:
	andi 2,17
	add 1,2
	aos 1,(1)
	popj 17,

dec_array_then_use:
	andi 2,17
	add 1,2
	sos 1,(1)
	popj 17,

inc_global_array_eq:
	andi 1,17
	move 4,aosa_buf(1)
	move 6,4
	addi 6,1
	movem 6,aosa_buf(1)
	move 1,2
	jumpe 6,%L116
	move 1,3
	add 1,6
%L116:
	popj 17,

dec_global_array_eq:
	andi 1,17
	move 4,aosa_buf(1)
	move 6,4
	subi 6,1
	movem 6,aosa_buf(1)
	move 1,2
	jumpe 6,%L118
	move 1,3
	add 1,6
%L118:
	popj 17,

inc_struct_a_eq:
	aosn 1,(1)
	jrst %L120
	move 2,3
	add 2,1
%L120:
	move 1,2
	popj 17,

dec_struct_a_eq:
	sosn 1,(1)
	jrst %L122
	move 2,3
	add 2,1
%L122:
	move 1,2
	popj 17,

inc_struct_b_gt:
	move 4,1(1)
	move 6,4
	addi 6,1
	movem 6,1(1)
	add 2,6
	jumple 6,%L126
%L124:
	move 1,2
	popj 17,
%L126:
	move 2,3
	jrst %L124

dec_struct_b_lt:
	move 4,1(1)
	move 6,4
	subi 6,1
	movem 6,1(1)
	add 2,6
	jumpl 6,%L127
	move 2,3
%L127:
	move 1,2
	popj 17,

inc_struct_then_use:
	aos 1,(1)
	popj 17,

dec_struct_then_use:
	sos 1,(1)
	popj 17,

inc_global_struct_eq:
	aosn 4,aosa_gp
	popj 17,
	move 1,2
	add 1,4
	popj 17,

dec_global_struct_eq:
	sosn 4,aosa_gp+1
	popj 17,
	move 1,2
	add 1,4
	popj 17,

inc_volatile_eq:
	move 6,1
	move 4,(1)
	addi 4,1
	movem 4,(1)
	move 4,(1)
	move 1,2
	jumpe 4,%L135
	move 1,(6)
	add 1,3
%L135:
	popj 17,

dec_volatile_eq:
	move 6,1
	move 4,(1)
	subi 4,1
	movem 4,(1)
	move 4,(1)
	move 1,2
	jumpe 4,%L137
	move 1,(6)
	add 1,3
%L137:
	popj 17,

inc_volatile_then_use:
	move 4,(1)
	addi 4,1
	movem 4,(1)
	move 1,(1)
	popj 17,

dec_volatile_then_use:
	move 4,(1)
	subi 4,1
	movem 4,(1)
	move 1,(1)
	popj 17,

inc_branch_with_live:
	add 2,3
	aos (1)
	add 4,2
	skipn 1,(1)
	jrst %L141
	move 4,2
	add 4,1
%L141:
	move 1,4
	popj 17,

dec_branch_with_live:
	add 2,3
	sos (1)
	add 4,2
	skipn 1,(1)
	jrst %L143
	move 4,2
	add 4,1
%L143:
	move 1,4
	popj 17,

inc_branch_call_after:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 12,2
	move 11,3
	aose (1)
	jrst %L146
	pushj 17,clobber
	move 1,12
%L145:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L146:
	pushj 17,clobber
	move 1,11
	add 1,(10)
	jrst %L145

dec_branch_call_after:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 12,2
	move 11,3
	sose (1)	; decrement_and_branch_until_zero
	jrst %L148
	pushj 17,clobber
	move 1,12
%L147:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L148:
	pushj 17,clobber
	move 1,11
	add 1,(10)
	jrst %L147

inc_then_branch_two_tests:
	aosn 1,(1)
	jrst %L149
	move 2,3
	add 2,1
	jumple 1,%L152
%L149:
	move 1,2
	popj 17,
%L152:
	move 2,3
	sub 2,1
	jrst %L149

dec_then_branch_two_tests:
	sosn 1,(1)
	jrst %L153
	move 2,3
	add 2,1
	jumpl 1,%L153
	move 2,3
	sub 2,1
%L153:
	move 1,2
	popj 17,

inc_loop_until_zero:
	movei 2,0
	move 3,(1)
%L157:
	addi 3,1
	movem 3,(1)
	addi 2,1
	jumpn 3,%L157
	move 1,2
	popj 17,

dec_loop_until_zero:
	movei 2,0
	move 3,(1)
%L160:
	subi 3,1
	movem 3,(1)
	addi 2,1
	jumpn 3,%L160
	move 1,2
	popj 17,

inc_loop_until_positive:
	movei 2,0
	move 3,(1)
%L163:
	addi 3,1
	movem 3,(1)
	addi 2,1
	jumple 3,%L163
	move 1,2
	popj 17,

dec_loop_until_negative:
	movei 2,0
	move 3,(1)
%L166:
	subi 3,1
	movem 3,(1)
	addi 2,1
	jumpge 3,%L166
	move 1,2
	popj 17,

inc_loop_array:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L178:
	move 4,3
	andi 4,17
	add 4,6
	aos (4)
	add 1,(4)
	addi 3,1
	sojge 2,%L178	; doloop_end
	popj 17,

dec_loop_array:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L189:
	move 4,3
	andi 4,17
	add 4,6
	sos (4)
	add 1,(4)
	addi 3,1
	sojge 2,%L189	; doloop_end
	popj 17,

inc_loop_array_branch:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L202:
	move 4,3
	andi 4,17
	add 4,6
	aose 4,(4)
	jrst %L195
	addi 1,1
%L193:
	addi 3,1
	sojge 2,%L202	; doloop_end
	popj 17,
%L195:
	add 1,4
	jrst %L193

dec_loop_array_branch:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L215:
	move 4,3
	andi 4,17
	add 4,6
	sose 4,(4)
	jrst %L208
	addi 1,1
%L206:
	addi 3,1
	sojge 2,%L215	; doloop_end
	popj 17,
%L208:
	add 1,4
	jrst %L206

inc_qint_branch_eq:
	ldb 4,1
	addi 4,1
	dpb 4,1
	lsh 4,33
	ash 4,-33
	move 1,2
	jumpe 4,%L216
	move 1,3
	add 1,4
%L216:
	popj 17,

dec_qint_branch_eq:
	ldb 4,1
	subi 4,1
	dpb 4,1
	lsh 4,33
	ash 4,-33
	move 1,2
	jumpe 4,%L218
	move 1,3
	add 1,4
%L218:
	popj 17,

inc_hint_branch_eq:
	ldb 4,1
	addi 4,1
	dpb 4,1	; movhi
	hrre 4,4
	move 1,2
	jumpe 4,%L220
	move 1,3
	add 1,4
%L220:
	popj 17,

dec_hint_branch_eq:
	ldb 4,1
	subi 4,1
	dpb 4,1	; movhi
	hrre 4,4
	move 1,2
	jumpe 4,%L222
	move 1,3
	add 1,4
%L222:
	popj 17,

inc_spair_eq:
	aosn 1,(1)
	jrst %L224
	move 2,3
	add 2,1
%L224:
	move 1,2
	popj 17,

dec_spair_eq:
	move 4,1(1)
	move 6,4
	subi 6,1
	movem 6,1(1)
	move 1,2
	jumpe 6,%L226
	move 1,3
	add 1,6
%L226:
	popj 17,

inc_global_spair_eq:
	aosn 4,aosa_gsp
	popj 17,
	move 1,2
	add 1,4
	popj 17,

dec_global_spair_eq:
	sosn 4,aosa_gsp+1
	popj 17,
	move 1,2
	add 1,4
	popj 17,

inc_by_two_branch_eq:
	move 4,(1)
	addi 4,2
	movem 4,(1)
	move 1,2
	jumpe 4,%L232
	move 1,3
	add 1,4
%L232:
	popj 17,

dec_by_two_branch_eq:
	move 4,(1)
	subi 4,2
	movem 4,(1)
	move 1,2
	jumpe 4,%L234
	move 1,3
	add 1,4
%L234:
	popj 17,

inc_local_branch_eq:
	aoje 1,%L236
	move 2,3
	add 2,1
%L236:
	move 1,2
	popj 17,

dec_local_branch_eq:
	soje 1,%L238	; decrement_and_branch_until_zero
	move 2,3
	add 2,1
%L238:
	move 1,2
	popj 17,

	.bss
aosa_gi:
	.space	4
sosa_gi:
	.space	4
aosa_gs:
	.space	4
sosa_gs:
	.space	4
aosa_buf:
	.space	64
aosa_sbuf:
	.space	64
aosa_gp:
	.space	8
aosa_gsp:
	.space	8
