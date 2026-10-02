
inc_branch_eq:
	aos (1)
	skipn 1,(1)
	jrst %L1
	move 2,3
	add 2,1
%L1:
	move 1,2
	popj 17,

inc_branch_ne:
	aos (1)
	skipn 1,(1)
	jrst %L3
	move 3,2
	add 3,1
%L3:
	move 1,3
	popj 17,

inc_branch_gt:
	aos (1)
	skipg 1,(1)
	jrst %L5
	move 3,2
	add 3,1
%L5:
	move 1,3
	popj 17,

inc_branch_ge:
	aos (1)
	skipge 1,(1)
	jrst %L7
	move 3,2
	add 3,1
%L7:
	move 1,3
	popj 17,

inc_branch_lt:
	aos (1)
	skipge 1,(1)
	jrst %L11
%L9:
	move 1,3
	popj 17,
%L11:
	move 3,2
	add 3,1
	jrst %L9

inc_branch_le:
	aos (1)
	skipg 1,(1)
	jrst %L14
%L12:
	move 1,3
	popj 17,
%L14:
	move 3,2
	add 3,1
	jrst %L12

dec_branch_eq:
	sos (1)
	skipn 1,(1)
	jrst %L15
	move 2,3
	add 2,1
%L15:
	move 1,2
	popj 17,

dec_branch_ne:
	sos (1)
	skipn 1,(1)
	jrst %L17
	move 3,2
	add 3,1
%L17:
	move 1,3
	popj 17,

dec_branch_gt:
	sos (1)
	skipg 1,(1)
	jrst %L19
	move 3,2
	add 3,1
%L19:
	move 1,3
	popj 17,

dec_branch_ge:
	sos (1)
	skipge 1,(1)
	jrst %L21
	move 3,2
	add 3,1
%L21:
	move 1,3
	popj 17,

dec_branch_lt:
	sos (1)
	skipge 1,(1)
	jrst %L25
%L23:
	move 1,3
	popj 17,
%L25:
	move 3,2
	add 3,1
	jrst %L23

dec_branch_le:
	sos (1)
	skipg 1,(1)
	jrst %L28
%L26:
	move 1,3
	popj 17,
%L28:
	move 3,2
	add 3,1
	jrst %L26

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
	jrst %L43
	move 2,3
	add 2,1
%L43:
	move 1,2
	popj 17,

postdec_branch_old:
	sos 1,(1)
	camn 1,[-1]
	jrst %L45
	move 2,3
	add 2,1
%L45:
	move 1,2
	popj 17,

postinc_branch_new:
	aos (1)
	skipn 1,(1)
	jrst %L47
	move 2,3
	add 2,1
%L47:
	move 1,2
	popj 17,

postdec_branch_new:
	sos (1)
	skipn 1,(1)
	jrst %L49
	move 2,3
	add 2,1
%L49:
	move 1,2
	popj 17,

inc_goto_eq:
	aos (1)
	skipn 1,(1)
	jrst %L51
	move 2,3
	add 2,1
%L53:
%L51:
	move 1,2
	popj 17,

dec_goto_eq:
	sos (1)
	skipn 1,(1)
	jrst %L54
	move 2,3
	add 2,1
%L56:
%L54:
	move 1,2
	popj 17,

inc_goto_gt:
	aos (1)
	skipg 1,(1)
	jrst %L57
%L59:
	move 3,2
	add 3,1
%L57:
	move 1,3
	popj 17,

dec_goto_lt:
	sos (1)
	skipge 1,(1)
	jrst %L63
%L60:
	move 1,3
	popj 17,
%L62:
%L63:
	move 3,2
	add 3,1
	jrst %L60

inc_branch_inverted_eq:
	aos (1)
	skipn 1,(1)
	jrst %L64
%L66:
	move 2,3
	add 2,1
%L64:
	move 1,2
	popj 17,

dec_branch_inverted_eq:
	sos (1)
	skipn 1,(1)
	jrst %L67
%L69:
	move 2,3
	add 2,1
%L67:
	move 1,2
	popj 17,

inc_branch_inverted_gt:
	aos (1)
	skipg 1,(1)
	jrst %L70
	move 3,2
	add 3,1
%L72:
%L70:
	move 1,3
	popj 17,

dec_branch_inverted_lt:
	sos (1)
	skipge 1,(1)
	jrst %L76
%L75:
%L73:
	move 1,3
	popj 17,
%L76:
	move 3,2
	add 3,1
	jrst %L73

inc_global_eq:
	aos aosa_gi
	skipn 4,aosa_gi
	popj 17,
	move 1,2
	add 1,4
	popj 17,

dec_global_eq:
	sos sosa_gi
	skipn 4,sosa_gi
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
%L83:
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
	aos (1)
	skipn 1,(1)
	jrst %L88
	move 2,3
	add 2,1
%L88:
	move 1,2
	popj 17,

dec_sint_branch_eq:
	sos (1)
	skipn 1,(1)
	jrst %L90
	move 2,3
	add 2,1
%L90:
	move 1,2
	popj 17,

inc_sint_branch_gt:
	aos (1)
	skipg 1,(1)
	jrst %L92
	move 3,2
	add 3,1
%L92:
	move 1,3
	popj 17,

dec_sint_branch_lt:
	sos (1)
	skipge 1,(1)
	jrst %L96
%L94:
	move 1,3
	popj 17,
%L96:
	move 3,2
	add 3,1
	jrst %L94

inc_sint_global_eq:
	aos aosa_gs
	skipn 4,aosa_gs
	popj 17,
	move 1,2
	add 1,4
	popj 17,

dec_sint_global_eq:
	sos sosa_gs
	skipn 4,sosa_gs
	popj 17,
	move 1,2
	add 1,4
	popj 17,

inc_array_eq:
	andi 2,17
	add 1,2
	aos (1)
	skipn 1,(1)
	jrst %L101
	move 3,4
	add 3,1
%L101:
	move 1,3
	popj 17,

dec_array_eq:
	andi 2,17
	add 1,2
	sos (1)
	skipn 1,(1)
	jrst %L105
	move 3,4
	add 3,1
%L105:
	move 1,3
	popj 17,

inc_array_gt:
	andi 2,17
	add 1,2
	aos (1)
	skipg 1,(1)
	jrst %L109
	move 4,3
	add 4,1
%L109:
	move 1,4
	popj 17,

dec_array_lt:
	andi 2,17
	add 1,2
	sos (1)
	skipge 1,(1)
	jrst %L117
%L113:
	move 1,4
	popj 17,
%L117:
	move 4,3
	add 4,1
	jrst %L113

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
	jumpe 6,%L124
	move 1,3
	add 1,6
%L124:
	popj 17,

dec_global_array_eq:
	andi 1,17
	move 4,aosa_buf(1)
	move 6,4
	subi 6,1
	movem 6,aosa_buf(1)
	move 1,2
	jumpe 6,%L126
	move 1,3
	add 1,6
%L126:
	popj 17,

inc_struct_a_eq:
	aos (1)
	skipn 1,(1)
	jrst %L128
	move 2,3
	add 2,1
%L128:
	move 1,2
	popj 17,

dec_struct_a_eq:
	sos (1)
	skipn 1,(1)
	jrst %L130
	move 2,3
	add 2,1
%L130:
	move 1,2
	popj 17,

inc_struct_b_gt:
	move 4,1(1)
	move 6,4
	addi 6,1
	movem 6,1(1)
	add 2,6
	jumple 6,%L134
%L132:
	move 1,2
	popj 17,
%L134:
	move 2,3
	jrst %L132

dec_struct_b_lt:
	move 4,1(1)
	move 6,4
	subi 6,1
	movem 6,1(1)
	add 2,6
	jumpl 6,%L135
	move 2,3
%L135:
	move 1,2
	popj 17,

inc_struct_then_use:
	aos 1,(1)
	popj 17,

dec_struct_then_use:
	sos 1,(1)
	popj 17,

inc_global_struct_eq:
	aos aosa_gp
	skipn 4,aosa_gp
	popj 17,
	move 1,2
	add 1,4
	popj 17,

dec_global_struct_eq:
	sos aosa_gp+1
	skipn 4,aosa_gp+1
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
	jumpe 4,%L143
	move 1,(6)
	add 1,3
%L143:
	popj 17,

dec_volatile_eq:
	move 6,1
	move 4,(1)
	subi 4,1
	movem 4,(1)
	move 4,(1)
	move 1,2
	jumpe 4,%L145
	move 1,(6)
	add 1,3
%L145:
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
	jrst %L149
	move 4,2
	add 4,1
%L149:
	move 1,4
	popj 17,

dec_branch_with_live:
	add 2,3
	sos (1)
	add 4,2
	skipn 1,(1)
	jrst %L151
	move 4,2
	add 4,1
%L151:
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
	jrst %L154
	pushj 17,clobber
	move 1,12
%L153:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L154:
	pushj 17,clobber
	move 1,11
	add 1,(10)
	jrst %L153

dec_branch_call_after:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 12,2
	move 11,3
	sose (1)	; decrement_and_branch_until_zero
	jrst %L156
	pushj 17,clobber
	move 1,12
%L155:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L156:
	pushj 17,clobber
	move 1,11
	add 1,(10)
	jrst %L155

inc_then_branch_two_tests:
	aos (1)
	skipn 1,(1)
	jrst %L157
	move 2,3
	add 2,1
	jumple 1,%L160
%L157:
	move 1,2
	popj 17,
%L160:
	move 2,3
	sub 2,1
	jrst %L157

dec_then_branch_two_tests:
	sos (1)
	skipn 1,(1)
	jrst %L161
	move 2,3
	add 2,1
	jumpl 1,%L161
	move 2,3
	sub 2,1
%L161:
	move 1,2
	popj 17,

inc_loop_until_zero:
	movei 2,0
	move 3,(1)
%L165:
	addi 3,1
	movem 3,(1)
	addi 2,1
	jumpn 3,%L165
	move 1,2
	popj 17,

dec_loop_until_zero:
	movei 2,0
	move 3,(1)
%L168:
	subi 3,1
	movem 3,(1)
	addi 2,1
	jumpn 3,%L168
	move 1,2
	popj 17,

inc_loop_until_positive:
	movei 2,0
	move 3,(1)
%L171:
	addi 3,1
	movem 3,(1)
	addi 2,1
	jumple 3,%L171
	move 1,2
	popj 17,

dec_loop_until_negative:
	movei 2,0
	move 3,(1)
%L174:
	subi 3,1
	movem 3,(1)
	addi 2,1
	jumpge 3,%L174
	move 1,2
	popj 17,

inc_loop_array:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L186:
	move 4,3
	andi 4,17
	add 4,6
	aos (4)
	add 1,(4)
	addi 3,1
	sojge 2,%L186	; doloop_end
	popj 17,

dec_loop_array:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L197:
	move 4,3
	andi 4,17
	add 4,6
	sos (4)
	add 1,(4)
	addi 3,1
	sojge 2,%L197	; doloop_end
	popj 17,

inc_loop_array_branch:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L210:
	move 4,3
	andi 4,17
	add 4,6
	aos (4)
	skipe 4,(4)
	jrst %L203
	addi 1,1
%L201:
	addi 3,1
	sojge 2,%L210	; doloop_end
	popj 17,
%L203:
	add 1,4
	jrst %L201

dec_loop_array_branch:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L223:
	move 4,3
	andi 4,17
	add 4,6
	sos (4)
	skipe 4,(4)
	jrst %L216
	addi 1,1
%L214:
	addi 3,1
	sojge 2,%L223	; doloop_end
	popj 17,
%L216:
	add 1,4
	jrst %L214

inc_qint_branch_eq:
	ldb 4,1
	addi 4,1
	dpb 4,1
	lsh 4,33
	ash 4,-33
	move 1,2
	jumpe 4,%L224
	move 1,3
	add 1,4
%L224:
	popj 17,

dec_qint_branch_eq:
	ldb 4,1
	subi 4,1
	dpb 4,1
	lsh 4,33
	ash 4,-33
	move 1,2
	jumpe 4,%L226
	move 1,3
	add 1,4
%L226:
	popj 17,

inc_hint_branch_eq:
	ldb 4,1
	addi 4,1
	dpb 4,1	; movhi
	hrre 4,4
	move 1,2
	jumpe 4,%L228
	move 1,3
	add 1,4
%L228:
	popj 17,

dec_hint_branch_eq:
	ldb 4,1
	subi 4,1
	dpb 4,1	; movhi
	hrre 4,4
	move 1,2
	jumpe 4,%L230
	move 1,3
	add 1,4
%L230:
	popj 17,

inc_spair_eq:
	aos (1)
	skipn 1,(1)
	jrst %L232
	move 2,3
	add 2,1
%L232:
	move 1,2
	popj 17,

dec_spair_eq:
	move 4,1(1)
	move 6,4
	subi 6,1
	movem 6,1(1)
	move 1,2
	jumpe 6,%L234
	move 1,3
	add 1,6
%L234:
	popj 17,

inc_global_spair_eq:
	aos aosa_gsp
	skipn 4,aosa_gsp
	popj 17,
	move 1,2
	add 1,4
	popj 17,

dec_global_spair_eq:
	sos aosa_gsp+1
	skipn 4,aosa_gsp+1
	popj 17,
	move 1,2
	add 1,4
	popj 17,

inc_by_two_branch_eq:
	move 4,(1)
	addi 4,2
	movem 4,(1)
	move 1,2
	jumpe 4,%L240
	move 1,3
	add 1,4
%L240:
	popj 17,

dec_by_two_branch_eq:
	move 4,(1)
	subi 4,2
	movem 4,(1)
	move 1,2
	jumpe 4,%L242
	move 1,3
	add 1,4
%L242:
	popj 17,

inc_local_branch_eq:
	aoje 1,%L244
	move 2,3
	add 2,1
%L244:
	move 1,2
	popj 17,

dec_local_branch_eq:
	soje 1,%L246	; decrement_and_branch_until_zero
	move 2,3
	add 2,1
%L246:
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
